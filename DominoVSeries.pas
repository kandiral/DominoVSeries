(****************************************************************************************************)
(*                                                                                                  *)
(*  Kandiral Ruslan                                                                                 *)
(*  https://kandiral.ru                                                                             *)
(*  https://kandiral.ru/delphi/upravlenie_termotransfernym_printerom_domino_v_series_po_seti.html   *)
(*                                                                                                  *)
(****************************************************************************************************)
unit DominoVSeries;

interface

uses Windows, Messages, Classes, KRTCPConnector, KRTypes, SysUtils, Funcs,
  Variants, Forms, KRConnector, StrUtils;

type
  TDVSData=record
    rCommand, aCommand, Request: String;
    rPrms, aPrms: array of Variant;
    Error: integer;
    inProcess: boolean;
    AnswerHash: uint64;
    isAnswer: boolean;
  end;
  PDVSData=^TDVSData;

  TDVSStatEvent = procedure (Sender: TObject; ACode: integer; ADescription: TStrings) of object;
  TDVSStrEvent = procedure (Sender: TObject; AText: String) of object;
  TDVSIntEvent = procedure (Sender: TObject; AValue: integer) of object;

  TDominoVSeries = class(TComponent)
  private
    FConnector: TKRTCPConnector;
    FWH: HWND;
    FStatInterval: integer;
    statData, ackErrorData, ackNonCriticalErrorData, printDesignData, cancelPrintData,
    fillSerialVarData, PollSerialVarData: TDVSData;
    FOnWarning: TDVSStatEvent;
    FOnStatus: TDVSStatEvent;
    FOnError: TDVSStatEvent;
    FOnPrintCount: TDVSIntEvent;
    FOnPrintName: TDVSStrEvent;
    FWarningDescr: TStrings;
    FStatusDescr: TStrings;
    FErrorDescr: TStrings;
    FWarning: integer;
    FStatus: integer;
    FPrintName: String;
    FError: integer;
    FPrintCount: integer;
    procedure TmWP(var Msg: TMessage);
    function GetIP: String;
    function GetPort: Word;
    procedure SetIP(const Value: String);
    procedure SetPort(const Value: Word);
    function GetActive: boolean;
    procedure SetActive(const Value: boolean);
    procedure SetInterval(const Value: integer);
    procedure cb(AError: integer; APack: PKRBuffer; ALength: integer; AData: Pointer);
    procedure UpdateStat;
    function GetConnected: boolean;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    property IP: String read GetIP write SetIP;
    property Port: Word read GetPort write SetPort;
    property Active: boolean read GetActive write SetActive;
    property StatInterval: integer read FStatInterval write SetInterval;
    procedure Send(data: PDVSData);
    property isConnected: boolean read GetConnected;
    property PrintName: String read FPrintName;
    property PrintCount: integer read FPrintCount;
    property Status: integer read FStatus;
    property StatusDescr: TStrings read FStatusDescr;
    property Error: integer read FError;
    property ErrorDescr: TStrings read FErrorDescr;
    property Warning: integer read FWarning;
    property WarningDescr: TStrings read FWarningDescr;
    property Connector: TKRTCPConnector read FConnector;
    procedure AckError;
    procedure AckNonCriticalError;
    function PrintDesign(AFileName: String; APrintCount: Cardinal; AMessageStoreID: byte;
      out StartedOk: boolean; out SavedOk: boolean; out ContainPrompths: boolean): boolean;
    procedure CancelPrint(ARestartPrint: boolean);
    procedure FillSerialVar(AVarName, AValue: String);
    function PollSerialVar(AVarName: String; out isActive: boolean; out BufferSize: cardinal): boolean;
  published
    property OnStatus: TDVSStatEvent read FOnStatus write FOnStatus;
    property OnError: TDVSStatEvent read FOnError write FOnError;
    property OnWarning: TDVSStatEvent read FOnWarning write FOnWarning;
    property OnPrintName: TDVSStrEvent read FOnPrintName write FOnPrintName;
    property OnPrintCount: TDVSIntEvent read FOnPrintCount write FOnPrintCount;
  end;

implementation


function HTTPEncode(const AStr: String): String;
const
  NoConversion = ['A'..'Z','a'..'z','*','@','.','_','-',
                  '0'..'9','$','!','''','(',')'];
var
  Sp, Rp: PChar;
begin
  SetLength(Result, Length(AStr) * 3);
  Sp := PChar(AStr);
  Rp := PChar(Result);
  while Sp^ <> #0 do begin
    if Sp^ in NoConversion then Rp^ := Sp^ else begin
      FormatBuf(Rp^, 3, String('%%%.2x'), 6, [Ord(Sp^)]);
      Inc(Rp,2);
    end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function HTTPDecode(const AStr: String): String;
var
  Sp, Rp, Cp: PChar;
  S: String;
begin
  SetLength(Result, Length(AStr));
  Sp := PChar(AStr);
  Rp := PChar(Result);
  Cp := Sp;
  try
    while Sp^ <> #0 do begin
      case Sp^ of
        '+': Rp^ := ' ';
        '%': begin
          Inc(Sp);
          if Sp^ = '%' then Rp^ := '%' else begin
            Cp := Sp;
            Inc(Sp);
            if (Cp^ <> #0) and (Sp^ <> #0) then begin
              S := Char('$') + Cp^ + Sp^;
              Rp^ := Char(StrToInt(string(S)));
            end;
          end;
        end
        else Rp^ := Sp^;
      end;
      Inc(Rp);
      Inc(Sp);
    end;
  except end;
  SetLength(Result, Rp - PChar(Result));
end;

function wChr(w: Word): Char;
begin
  Word(Pointer(@Result)^) := w;
end;

{ TDominoVSeries }

procedure TDominoVSeries.AckError;
begin
  send(@ackErrorData);
end;

procedure TDominoVSeries.AckNonCriticalError;
begin
  send(@ackNonCriticalErrorData);
end;

procedure TDominoVSeries.CancelPrint(ARestartPrint: boolean);
begin
  cancelPrintData.Request:='';
  cancelPrintData.rPrms[0]:=Integer(ARestartPrint);
  send(@cancelPrintData);
end;

procedure TDominoVSeries.cb(AError: integer; APack: PKRBuffer; ALength: integer;
  AData: Pointer);
var
  i,n,t: integer;
  cmd, cnt: boolean;
  prm: String;
  ds: char;
  wd: word;
begin
  PDVSData(AData)^.Error:=AError;
  if(PDVSData(AData)^.isAnswer)and(AError=0)and(ALength>8)then begin
    if(APack^[ALength-1]=0)and(APack^[ALength-2]=10)then Dec(ALength,2);
    if(APack^[ALength-1]=0)and(APack^[ALength-2]=13)then Dec(ALength,2);
    if((word(APack^[1]) shl 8 )or APack^[0]<>1)or((word(APack^[ALength-1]) shl 8 )or APack^[ALength-2]<>23)then AError:=-1 else begin
      Dec(ALength,4);
      PDVSData(AData)^.AnswerHash:=0;
      SetLength(PDVSData(AData)^.aPrms,0);
      cmd:=true;
      PDVSData(AData)^.aCommand:='';
      n:=0;t:=0;
      ds:=FormatSettings.DecimalSeparator;
      FormatSettings.DecimalSeparator:=#46;
      cnt:=false;
      i:=0;
      repeat
        inc(i,2);
        PDVSData(AData)^.AnswerHash:=PDVSData(AData)^.AnswerHash+APack^[i];
        if cnt then begin
          cnt:=false;
          continue;
        end;
        wd:=(word(APack^[i+1]) shl 8) or APack^[i];
        if cmd then begin
          if wd=61 then cmd:=false else
            PDVSData(AData)^.aCommand:=PDVSData(AData)^.aCommand+wChr(wd);
        end else begin
          case t of
            0: if wd=2 then begin
                t:=3;
                prm:='';
              end else begin
                t:=1;
                prm:=wChr(wd);
              end;
            1: if wd=44 then begin
                SetLength(PDVSData(AData)^.aPrms,n+1);
                PDVSData(AData)^.aPrms[n]:=StrToIntDef(prm,0);
                inc(n);
                t:=0;
              end else if wd=46 then begin
                prm:=prm+wChr(wd);
                t:=2;
              end else prm:=prm+wChr(wd);
            2: if wd=44 then begin
                SetLength(PDVSData(AData)^.aPrms,n+1);
                PDVSData(AData)^.aPrms[n]:=StrToFloatDef(prm,0);
                inc(n);
                t:=0;
              end else prm:=prm+wChr(wd);
            3: if wd=3 then begin
                SetLength(PDVSData(AData)^.aPrms,n+1);
                PDVSData(AData)^.aPrms[n]:=prm;
                inc(n);
                t:=0;
                cnt:=true;
              end else begin
                prm:=prm+wChr(wd);
              end;
          end;
        end;
      until i>=ALength;
      case t of
        1: begin
            SetLength(PDVSData(AData)^.aPrms,n+1);
            PDVSData(AData)^.aPrms[n]:=StrToIntDef(prm,0);
            inc(n);
            t:=0;
          end;
        2: begin
            SetLength(PDVSData(AData)^.aPrms,n+1);
            PDVSData(AData)^.aPrms[n]:=StrToFloatDef(prm,0);
            inc(n);
            t:=0;
          end;
      end;
      FormatSettings.DecimalSeparator:=ds;
    end;
  end;
  PDVSData(AData)^.inProcess:=false;
end;

constructor TDominoVSeries.Create(AOwner: TComponent);
begin
  inherited;
  FConnector:=TKRTCPConnector.Create(Self);

  FWarningDescr:=TStringList.Create;
  FStatusDescr:=TStringList.Create;
  FErrorDescr:=TStringList.Create;
  FWarning:=-1;
  FStatus:=-1;
  FPrintName:='';
  FError:=-1;
  FPrintCount:=-1;

  statData.rCommand:='RequestStatus';
  SetLength(statData.rPrms,1);
  statData.rPrms[0]:='Ex. Text';
  statData.AnswerHash:=0;
  statData.isAnswer:=true;

  ackErrorData.rCommand:='AckError';
  SetLength(ackErrorData.rPrms,1);
  ackErrorData.rPrms[0]:=0;
  ackErrorData.AnswerHash:=0;
  ackErrorData.isAnswer:=false;

  ackNonCriticalErrorData.rCommand:='AckNonCriticalError';
  SetLength(ackNonCriticalErrorData.rPrms,1);
  ackNonCriticalErrorData.rPrms[0]:='Ex. Text';
  ackNonCriticalErrorData.AnswerHash:=0;
  ackNonCriticalErrorData.isAnswer:=false;

  printDesignData.rCommand:='PrintDesign';
  SetLength(printDesignData.rPrms,3);
  printDesignData.isAnswer:=true;

  cancelPrintData.rCommand:='CancelPrint';
  SetLength(cancelPrintData.rPrms,1);
  cancelPrintData.isAnswer:=false;

  fillSerialVarData.rCommand:='FillSerialVar';
  SetLength(fillSerialVarData.rPrms,2);
  fillSerialVarData.isAnswer:=false;

  PollSerialVarData.rCommand:='PollSerialVar';
  SetLength(PollSerialVarData.rPrms,1);
  PollSerialVarData.isAnswer:=true;

  FWH := AllocateHWnd(tmWP);
  SetInterval(2000);
end;

destructor TDominoVSeries.Destroy;
begin
  SetActive(false);
  FConnector.Free;
  TStringList(FWarningDescr).Free;
  TStringList(FStatusDescr).Free;
  TStringList(FErrorDescr).Free;
  inherited;
end;

procedure TDominoVSeries.FillSerialVar(AVarName, AValue: String);
begin
  fillSerialVarData.Request:='';
  fillSerialVarData.rPrms[0]:=AVarName;
  fillSerialVarData.rPrms[1]:=AValue;
  send(@fillSerialVarData);
end;

function TDominoVSeries.GetActive: boolean;
begin
  result:=FConnector.Active;
end;

function TDominoVSeries.GetConnected: boolean;
begin
  result:=GetActive;
  if result then
    result:=FConnector.Stat=cstConnected;
end;

function TDominoVSeries.GetIP: String;
begin
  result:=FConnector.IP;
end;

function TDominoVSeries.GetPort: Word;
begin
  result:=FConnector.Port;
end;

function TDominoVSeries.PollSerialVar(AVarName: String; out isActive: boolean;
  out BufferSize: cardinal): boolean;
begin
  PollSerialVarData.Request:='';
  PollSerialVarData.rPrms[0]:=AVarName;
  send(@PollSerialVarData);
  result:=(PollSerialVarData.Error=0)and(Length(PollSerialVarData.aPrms)=3);
  if result then begin
    isActive:=PollSerialVarData.aPrms[1]>0;
    BufferSize:=PollSerialVarData.aPrms[2];
  end;
end;

function TDominoVSeries.PrintDesign(AFileName: String; APrintCount: Cardinal;
  AMessageStoreID: byte; out StartedOk, SavedOk,
  ContainPrompths: boolean): boolean;
begin
  printDesignData.Request:='';
  printDesignData.rPrms[0]:=HTTPEncode(String(AFileName));
  printDesignData.rPrms[1]:=APrintCount;
  printDesignData.rPrms[2]:=AMessageStoreID;
  send(@printDesignData);
  result:=(printDesignData.Error=0) and (Length(printDesignData.aPrms)>5);
  if(result) then begin
    StartedOk:=printDesignData.aPrms[1]>0;
    SavedOk:=printDesignData.aPrms[2]>0;
    ContainPrompths:=printDesignData.aPrms[3]>0;
  end;
end;

procedure TDominoVSeries.Send(data: PDVSData);
var
  i,n: integer;
  buf: PKRBuffer;
  wd: word;
begin
  data^.inProcess:=true;
  new(buf);
  if Length(data^.Request)=0 then begin
    data^.Request:=#1+data^.rCommand;
    if length(data^.rPrms)>0 then begin
      for I := 0 to Length(data^.rPrms)-1 do begin
        if i=0 then data^.Request:=data^.Request+'=' else data^.Request:=data^.Request+',';
        if VarIsOrdinal(data^.rPrms[i]) then data^.Request:=data^.Request+IntToStr(data^.rPrms[i])
        else if VarIsFloat(data^.rPrms[i]) then data^.Request:=data^.Request+FormatFloat('0.0#####',data^.rPrms[i])
        else data^.Request:=data^.Request+#2+data^.rPrms[i]+#3;
      end;
    end;
    data^.Request:=data^.Request+#23#13#10;
  end;
  n:=Length(data^.Request);
  for I := 1 to n do begin
    wd:=ord(data^.Request[i]);
    buf^[(i-1)*2]:=wd;
    buf^[(i-1)*2+1]:=wd shr 8;
  end;
  FConnector.Send(buf,n*2,cb,data,data.isAnswer,0,0,0);
  while data^.inProcess do Application.ProcessMessages;
  dispose(buf);
end;

procedure TDominoVSeries.SetActive(const Value: boolean);
begin
  FConnector.Active:=Value;
end;

procedure TDominoVSeries.SetInterval(const Value: integer);
begin
  if FStatInterval<>Value then begin
    KillTimer(FWH, 1);
    FStatInterval:=Value;
    if FStatInterval<1 then FStatInterval:=0 else
      SetTimer(FWH, 1, FStatInterval, nil);
  end;
end;

procedure TDominoVSeries.SetIP(const Value: String);
begin
  FConnector.IP:=Value;
end;

procedure TDominoVSeries.SetPort(const Value: Word);
begin
  FConnector.Port:=Value;
end;

procedure TDominoVSeries.TmWP(var Msg: TMessage);
begin
  if Msg.Msg=WM_TIMER then begin
    case Msg.WParam of
    1: begin
        KillTimer(FWH, 1);
        if GetActive then UpdateStat;
        if FStatInterval>0 then SetTimer(FWH, 1, FStatInterval, nil);
      end;
    end;
  end else Msg.Result := DefWindowProc(FWH, Msg.Msg, Msg.wParam, Msg.lParam);
end;

procedure TDominoVSeries.UpdateStat;
var hash: uint64;
begin
  hash:=statData.AnswerHash;
  Send(@statData);
  if(statData.Error=0)and(hash<>statData.AnswerHash)and(statData.aCommand='AnswerStatus')and(Length(statData.aPrms)=17)then begin

    if VarIsStr(statData.aPrms[8])then begin
      statData.aPrms[8]:=HTTPDecode(statData.aPrms[8]);
      if(FPrintName<>statData.aPrms[8])then begin
        FPrintName:=statData.aPrms[8];
        if Assigned(FOnPrintName) then FOnPrintName(Self,FPrintName);
      end;
    end;

    if VarIsOrdinal(statData.aPrms[9])and(FPrintCount<>statData.aPrms[9])then begin
      FPrintCount:=statData.aPrms[9];
      if Assigned(FOnPrintCount) then FOnPrintCount(Self,FPrintCount);
    end;

    if VarIsOrdinal(statData.aPrms[0])and(FStatus<>statData.aPrms[0])then begin
      FStatus:=statData.aPrms[0];
      if VarIsStr(statData.aPrms[3]) then FStatusDescr.Text:=statData.aPrms[3];
      if Assigned(FOnStatus) then FOnStatus(Self,FStatus,FStatusDescr);
    end;

    if VarIsOrdinal(statData.aPrms[1])and(FError<>statData.aPrms[1])then begin
      FError:=statData.aPrms[1];
      FErrorDescr.Clear;
      if VarIsStr(statData.aPrms[4]) then FErrorDescr.Add(statData.aPrms[4]);
      if VarIsStr(statData.aPrms[5]) then FErrorDescr.Add(statData.aPrms[5]);
      if VarIsStr(statData.aPrms[6]) then FErrorDescr.Add(statData.aPrms[6]);
      if Assigned(FOnError) then FOnError(Self,FError,FErrorDescr);
    end;

    if VarIsOrdinal(statData.aPrms[2])and(FWarning<>statData.aPrms[2])then begin
      FWarning:=statData.aPrms[2];
      if VarIsStr(statData.aPrms[7]) then FWarningDescr.Text:=statData.aPrms[7];
      if Assigned(FOnWarning) then FOnWarning(Self,FWarning,FWarningDescr);
    end;


  end;
end;

end.
