(******************************************************************************)
(*                                                                            *)
(*  Kandiral Ruslan                                                           *)
(*  https://kandiral.ru                                                       *)
(*  https://kandiral.ru/delphi/rabota_s_omron_fq_cr1.html                     *)
(*                                                                            *)
(******************************************************************************)
unit OmronFQ_CR1;

interface

uses KRTypes, KRSockets, KRTCPSocketClient, KRThread, MMSystem, Forms, SysUtils,
  Funcs, Classes, SchemeItem;

type
  TOmronFQ_CR1OnMeasurementValue = procedure(Sender: TObject; AValue: String) of object;
  TOmronFQ_CR1OnData = procedure(Sender: TObject; AData: String) of object;

  TOmronFQ_CR1 = class;

  TOmronFQ_CR1Thread = class(TKRThread)
  private
    FLock: TObject;
    FOmronFQ_CR1: TOmronFQ_CR1;
    si, n, fun, l: integer;
    str: array[0..6] of AnsiString;
    sBuf, Buf: TKRBuffer;
    FRecv: String;

    client: TKRTCPSocketClient;
    FLastConnectTime, FReconnectTime, FLastErrGetTime, FReadTimeout,
      FWaitRespTime, FErrGetTime: Cardinal;
    FState: TSchemeDeviceConnStat;
    FErr: String;
    nnn: integer;
    FErrGetErr: integer;
    FMeasurementValue: TOmronFQ_CR1OnMeasurementValue;
    FSendData, FRecvData: TOmronFQ_CR1OnData;
    FValue: String;
    FStartMeasurements: integer;
    FStopMeasurements: integer;
    FExecuteMeasurement: integer;
    FExecuteMeasurementValue: String;
    FSensorModel: integer;
    FSensorModelValue: String;
    FClearMeasurements: integer;
    FReset: integer;

    procedure SendAsync;
    procedure RecvAsync;
    procedure CodeAsync;
    procedure Code(s: String);

    procedure Status;
    procedure SetStatus(AStatus: TSchemeDeviceConnStat);

    function ErrGet(pBuf: PKRBuffer; var AResp: integer): integer;
    function ErrGetResp(s0,s1: String): boolean;
    procedure ErrGetErr;
    procedure Err;

    function Reset(pBuf: PKRBuffer; var AResp: integer): integer;

    function StartMeasurements(pBuf: PKRBuffer; var AResp: integer): integer;
    function StartMeasurementsResp(s: String): boolean;
    procedure StartMeasurementsErr;

    function ClearMeasurements(pBuf: PKRBuffer; var AResp: integer): integer;
    function ClearMeasurementsResp(s: String): boolean;
    procedure ClearMeasurementsErr;

    function StopMeasurements(pBuf: PKRBuffer; var AResp: integer): integer;
    function StopMeasurementsResp(s: String): boolean;
    procedure StopMeasurementsErr;

    function ExecuteMeasurement(pBuf: PKRBuffer; var AResp: integer): integer;
    function ExecuteMeasurementResp(s1,s2,s3: String): boolean;
    procedure ExecuteMeasurementErr;

    function SensorModel(pBuf: PKRBuffer; var AResp: integer): integer;
    function SensorModelResp(s1,s2: String): boolean;
    procedure SensorModelErr;


  protected
    procedure KRExecute; override;
    procedure KRExecutePausedFirst; override;
  public
    constructor Create(AOmronFQ_CR1: TOmronFQ_CR1);
    destructor Destroy;override;
  end;

  TOmronFQ_CR1 = class(TSchemeItem)
  private
    thread: TOmronFQ_CR1Thread;
    FConnectionStatus: TSchemeDeviceConnStatEv;
    FOnErr: TNotifyEvent;
    function GetConnectTimeout: Cardinal;
    procedure SetConnectTimeout(const Value: Cardinal);
    procedure SetReconnectTime(const Value: Cardinal);
    function GetReadTimeout: Cardinal;
    procedure SetReadTimeout(const Value: Cardinal);
    function GetActive: boolean;
    procedure SetActive(const Value: boolean);
    function GetAddr: AnsiString;
    function GetPort: Word;
    procedure SetAddr(const Value: AnsiString);
    procedure SetPort(const Value: Word);
    function GetMeasurementValue: TOmronFQ_CR1OnMeasurementValue;
    procedure SetMeasurementValue(const Value: TOmronFQ_CR1OnMeasurementValue);
    function GetState: TSchemeDeviceConnStat;
    function GetErrGetTime: Cardinal;
    procedure SetErrGetTime(const Value: Cardinal);
    function GetRecvData: TOmronFQ_CR1OnData;
    function GetSendData: TOmronFQ_CR1OnData;
    procedure SetRecvData(const Value: TOmronFQ_CR1OnData);
    procedure SetSendData(const Value: TOmronFQ_CR1OnData);
    function getErr: String;
    function GetSensorModel: String;
  protected
    function GetReconnectTime: Cardinal;override;
  public
    constructor Create;
    destructor Destroy;override;

    property Active: boolean read GetActive write SetActive;
    property State: TSchemeDeviceConnStat read GetState;
    property Err: String read getErr;

    property ConnectTimeout: Cardinal read GetConnectTimeout write SetConnectTimeout;
    property ReconnectTime: Cardinal read GetReconnectTime write SetReconnectTime;
    property ReadTimeout: Cardinal read GetReadTimeout write SetReadTimeout;
    property ErrGetTime: Cardinal read GetErrGetTime write SetErrGetTime;

    property Addr: AnsiString read GetAddr write SetAddr;
    property Port: Word read GetPort write SetPort;

    property OnErr: TNotifyEvent read FOnErr write FOnErr;
    property OnConnectionStatus: TSchemeDeviceConnStatEv read FConnectionStatus write FConnectionStatus;
    property OnMeasurementValue: TOmronFQ_CR1OnMeasurementValue read GetMeasurementValue
      write SetMeasurementValue;
    property OnSendData: TOmronFQ_CR1OnData read GetSendData write SetSendData;
    property OnRecvData: TOmronFQ_CR1OnData read GetRecvData write SetRecvData;

    procedure Reset;

    function ClearMeasurements: boolean;
    function StartMeasurements: boolean;
    function StopMeasurements: boolean;
    function ExecuteMeasurement(var AValue: String):boolean;

    property SensorModel: String read GetSensorModel;

  end;

implementation

{ TOmronFQ_CR1 }

function TOmronFQ_CR1.ClearMeasurements: boolean;
begin
  if(thread.Active)and(thread.FClearMeasurements>2)then begin
    thread.FClearMeasurements:=1;
    while(not thread.Pause)and(thread.FClearMeasurements<3)do Application.ProcessMessages;
    Result:=thread.FClearMeasurements=3;
  end else Result:=false;
end;

constructor TOmronFQ_CR1.Create;
begin
  thread:=TOmronFQ_CR1Thread.Create(Self);
end;

destructor TOmronFQ_CR1.Destroy;
begin
  thread.Free;
  inherited;
end;

function TOmronFQ_CR1.ExecuteMeasurement(var AValue: String): boolean;
begin
  if(thread.Active)and(thread.FExecuteMeasurement>2)then begin
    thread.FExecuteMeasurement:=1;
    while(not thread.Pause)and(thread.FExecuteMeasurement<3)do Application.ProcessMessages;
    Result:=thread.FExecuteMeasurement=3;
    if Result then AValue:=thread.FExecuteMeasurementValue;
  end else Result:=false;
end;

function TOmronFQ_CR1.GetActive: boolean;
begin
  Result:=thread.Active;
end;

function TOmronFQ_CR1.GetAddr: AnsiString;
begin
  Result:=thread.client.Addr;
end;

function TOmronFQ_CR1.GetConnectTimeout: Cardinal;
begin
  result:=thread.client.ConnectTimeout;
end;

function TOmronFQ_CR1.getErr: String;
begin
  System.TMonitor.Enter(thread.FLock);
  Result:=thread.FErr;
  System.TMonitor.Exit(thread.FLock);
end;

function TOmronFQ_CR1.GetErrGetTime: Cardinal;
begin
  Result:=thread.FErrGetTime;
end;

function TOmronFQ_CR1.GetMeasurementValue: TOmronFQ_CR1OnMeasurementValue;
begin
  Result:=thread.FMeasurementValue;
end;

function TOmronFQ_CR1.GetPort: Word;
begin
  result:=thread.client.Port;
end;

function TOmronFQ_CR1.GetReadTimeout: Cardinal;
begin
  Result:=thread.FReadTimeout;
end;

function TOmronFQ_CR1.GetReconnectTime: Cardinal;
begin
  Result:=thread.FReconnectTime;
end;

function TOmronFQ_CR1.GetRecvData: TOmronFQ_CR1OnData;
begin
  Result:=thread.FRecvData;
end;

function TOmronFQ_CR1.GetSendData: TOmronFQ_CR1OnData;
begin
  Result:=thread.FSendData;
end;

function TOmronFQ_CR1.GetSensorModel: String;
begin
  result:='';
  if thread.FSensorModel<>3 then exit;
  result:=thread.FSensorModelValue;
end;

function TOmronFQ_CR1.GetState: TSchemeDeviceConnStat;
begin
  Result:=thread.FState;
end;

procedure TOmronFQ_CR1.Reset;
begin
  if(thread.Active)and(thread.FReset>2)then thread.FReset:=1;
end;

procedure TOmronFQ_CR1.SetActive(const Value: boolean);
begin
  thread.Active:=Value;
end;

procedure TOmronFQ_CR1.SetAddr(const Value: AnsiString);
begin
  thread.client.Addr:=Value;
end;

procedure TOmronFQ_CR1.SetConnectTimeout(const Value: Cardinal);
begin
  thread.client.ConnectTimeout:=Value;
end;

procedure TOmronFQ_CR1.SetErrGetTime(const Value: Cardinal);
begin
  thread.FErrGetTime:=Value;
end;

procedure TOmronFQ_CR1.SetMeasurementValue(
  const Value: TOmronFQ_CR1OnMeasurementValue);
begin
  thread.FMeasurementValue:=Value;
end;

procedure TOmronFQ_CR1.SetPort(const Value: Word);
begin
  thread.client.Port:=Value;
end;

procedure TOmronFQ_CR1.SetReadTimeout(const Value: Cardinal);
begin
  thread.FReadTimeout:=Value;
end;

procedure TOmronFQ_CR1.SetReconnectTime(const Value: Cardinal);
begin
  thread.FReconnectTime:=Value;
end;

procedure TOmronFQ_CR1.SetRecvData(const Value: TOmronFQ_CR1OnData);
begin
  thread.FRecvData:=Value;
end;

procedure TOmronFQ_CR1.SetSendData(const Value: TOmronFQ_CR1OnData);
begin
  thread.FSendData:=Value;
end;

function TOmronFQ_CR1.StartMeasurements: boolean;
begin
  if(thread.Active)and(thread.FStartMeasurements>2)then begin
    thread.FStartMeasurements:=1;
    while(not thread.Pause)and(thread.FStartMeasurements<3)do Application.ProcessMessages;
    Result:=thread.FStartMeasurements=3;
  end else Result:=false;
end;

function TOmronFQ_CR1.StopMeasurements: boolean;
begin
  if(thread.Active)and(thread.FStopMeasurements>2)then begin
    thread.FStopMeasurements:=1;
    while(not thread.Pause)and(thread.FStopMeasurements<3)do Application.ProcessMessages;
    Result:=thread.FStopMeasurements=3;
  end else Result:=false;
end;

{ TOmronFQ_CR1Thread }

function TOmronFQ_CR1Thread.ClearMeasurements(pBuf: PKRBuffer;
  var AResp: integer): integer;
begin
  fun:=7;
  FClearMeasurements:=2;
  AResp:=1;
  pBuf^[0]:=67;
  pBuf^[1]:=76;
  pBuf^[2]:=82;
  pBuf^[3]:=77;
  pBuf^[4]:=69;
  pBuf^[5]:=65;
  pBuf^[6]:=83;
  pBuf^[7]:=13;
  Result:=8;
end;

procedure TOmronFQ_CR1Thread.ClearMeasurementsErr;
begin
  FClearMeasurements:=4;
end;

function TOmronFQ_CR1Thread.ClearMeasurementsResp(s: String): boolean;
begin
  result:=s='OK';
  if result then FClearMeasurements:=3;
end;

procedure TOmronFQ_CR1Thread.Code(s: String);
begin
  FValue:=s;
  Synchronize(CodeAsync);
end;

procedure TOmronFQ_CR1Thread.CodeAsync;
begin
  if Assigned(FMeasurementValue) then FMeasurementValue(FOmronFQ_CR1,FValue);
end;

constructor TOmronFQ_CR1Thread.Create(AOmronFQ_CR1: TOmronFQ_CR1);
begin
  FLock:=TObject.Create;
  FOmronFQ_CR1:=AOmronFQ_CR1;
  FWaitRespTime:=50;
  FReconnectTime:=5000;
  FReadTimeout:=1000;
  FErrGetTime:=1000;
  nnn:=-1;
  FErr:='';
  FLastConnectTime:=MMSystem.timeGetTime-FReconnectTime-1;
  FState:=sdstNotActive;

  FStartMeasurements:=4;
  FStopMeasurements:=4;
  FExecuteMeasurement:=4;
  FSensorModel:=4;
  FClearMeasurements:=4;
  FReset:=4;

  client:=TKRTCPSocketClient.Create;
  inherited Create;
end;

destructor TOmronFQ_CR1Thread.Destroy;
begin
  client.Free;
  inherited;
  FLock.Free;
end;

procedure TOmronFQ_CR1Thread.Err;
begin
  if Assigned(FOmronFQ_CR1.FOnErr) then FOmronFQ_CR1.FOnErr(FOmronFQ_CR1);  
end;

function TOmronFQ_CR1Thread.ErrGet(pBuf: PKRBuffer; var AResp: integer): integer;
var
  i: integer;
begin
  fun:=1;
  pBuf^[0]:=69;
  pBuf^[1]:=82;
  pBuf^[2]:=82;
  pBuf^[3]:=71;
  pBuf^[4]:=69;
  pBuf^[5]:=84;
  pBuf^[6]:=13;
  result:=7;
  AResp:=2;
  FLastErrGetTime:=MMSystem.timeGetTime;
end;

procedure TOmronFQ_CR1Thread.ErrGetErr;
begin
  inc(FErrGetErr);
  if FErrGetErr>5 then begin
    client.Close;
    setStatus(sdstDisconnected);
  end;
end;

function TOmronFQ_CR1Thread.ErrGetResp(s0, s1: String): boolean;
var
  b: boolean;
begin
  result:=s1='OK';
  if result then begin
    FErrGetErr:=0;
    System.TMonitor.Enter(FLock);
    b:=FErr<>s0;
    if b then FErr:=s0;
    System.TMonitor.Exit(FLock);
    if b then Synchronize(Err);
    if FSensorModel<>3 then FSensorModel:=1;
  end;
end;

function TOmronFQ_CR1Thread.ExecuteMeasurement(pBuf: PKRBuffer; var AResp: integer): integer;
begin
  fun:=4;
  FExecuteMeasurement:=2;
  AResp:=3;
  pBuf^[0]:=77;
  pBuf^[1]:=69;
  pBuf^[2]:=65;
  pBuf^[3]:=83;
  pBuf^[4]:=85;
  pBuf^[5]:=82;
  pBuf^[6]:=69;
  pBuf^[7]:=13;
  Result:=8;
end;

procedure TOmronFQ_CR1Thread.ExecuteMeasurementErr;
begin
  FExecuteMeasurement:=4;
end;

function TOmronFQ_CR1Thread.ExecuteMeasurementResp(s1, s2, s3: String): boolean;
begin
  result:=s1='OK';
  if(Length(s3)=1)and(s3[1]=#10)then begin
    FExecuteMeasurementValue:=s2;
    FExecuteMeasurement:=3;
  end else ExecuteMeasurementErr;
end;

procedure TOmronFQ_CR1Thread.KRExecute;
var
  i, cr, resp: integer;
  tm, tm0: cardinal;
  b: boolean;

  procedure _error;
  begin
    if resp>0 then begin
      resp:=0;
      case fun of
      1: ErrGetErr;
      2: StartMeasurementsErr;
      3: StopMeasurementsErr;
      4: ExecuteMeasurementErr;
      5: SensorModelErr;
      7: ClearMeasurementsErr;
      end;
    end;

  end;

begin
  if not client.Connected then begin
    if(ElapsedTime(FLastConnectTime)>FReconnectTime)then begin
      try
        SetStatus(sdstConnecting);
        client.Open;
        FLastErrGetTime:=MMSystem.timeGetTime-FErrGetTime-1;
      except end;
      FLastConnectTime:=timeGetTime;
    end;
    if not client.Connected then begin
      SetStatus(sdstWaitReconnecting);
      sleep(50);
      exit;
    end else SetStatus(sdstConnected);

    FErrGetErr:=0;
    n:=0;
    si:=0;
    str[0]:='';
    FErr:='';
    FSensorModel:=4;
  end;

  resp:=0;

  try
    l:=0;
    if(FReset=1)then l:=Reset(@sBuf,resp);
    if(l=0)and(FClearMeasurements=1)then l:=ClearMeasurements(@sBuf,resp);
    if(l=0)and(FSensorModel=1)then l:=SensorModel(@sBuf,resp);
    if(l=0)and(FExecuteMeasurement=1)then l:=ExecuteMeasurement(@sBuf,resp);
    if(l=0)and(FStartMeasurements=1)then l:=StartMeasurements(@sBuf,resp);
    if(l=0)and(FStopMeasurements=1)then l:=StopMeasurements(@sBuf,resp);
    if(l=0)and(ElapsedTime(FLastErrGetTime)>=FErrGetTime)then l:=ErrGet(@sBuf,resp);
    if l>0 then begin
      if Assigned(FSendData) then Synchronize(SendAsync);
      if client.SendBuf(sBuf,l)=-1 then _error();
    end;
  except
    _error();
  end;

  try
    tm:=MMSystem.timeGetTime;
    tm0:=MMSystem.timeGetTime+FWaitRespTime;
    while(MMSystem.timeGetTime-tm<FReadTimeout)do begin
      if Client.WaitForData(FWaitRespTime) then begin
        l:=Client.ReceiveBuf(Pointer(Integer(@Buf[0])+n)^,255-n);
        if l=-1 then begin
          _error();
          break;
        end else begin
          cr:=-1;
          for i:=n to n+l-1 do begin
            if Buf[i]=13 then begin
              if Assigned(FRecvData) then begin
                FRecv:=str[si];
                Synchronize(RecvAsync);
              end;
              cr:=i;
              b:=false;
              if(resp>0)and(si+1=resp)then begin
                case fun of
                1: b:=ErrGetResp(str[0],str[1]);
                2: b:=StartMeasurementsResp(str[0]);
                3: b:=StopMeasurementsResp(str[0]);
                4: b:=ExecuteMeasurementResp(str[0],str[1],str[2]);
                5: b:=SensorModelResp(str[0],str[1]);
                7: b:=ClearMeasurementsResp(str[0]);
                end;
                if b then begin
                  resp:=0;
                  si:=0;
                  str[0]:='';
                end;
              end;
              if not b then begin
                if(si=1)and(Length(str[1])=1)and(str[1][1]=#10)then begin
                  code(str[0]);
                  si:=0;
                  str[0]:='';
                end else if(resp>0)and(si=0)and(str[0]='ER')then begin
                  _error();
                  si:=0;
                  str[0]:='';
                end else if(resp>si+1)or(si=0)then begin
                  if si=6 then si:=0 else si:=si+1;
                  str[si]:='';
                end else begin
                  si:=0;
                  str[0]:='';
                end;
              end;
            end else str[si]:=str[si]+Chr(Buf[i]);
          end;
          n:=n+l;
          if cr>-1 then begin
            n:=n-cr-1;
            for i:=0 to n-1 do Buf[i]:=Buf[i+cr+1];
          end else if n>250 then n:=0;
        end;
        tm0:=MMSystem.timeGetTime+FWaitRespTime;
        continue;
      end;
      if tm0<MMSystem.timeGetTime then break;
    end;

    if resp>0 then _error();

  except
    _error();
  end;

  if nnn>-1 then inc(nnn);

end;

procedure TOmronFQ_CR1Thread.KRExecutePausedFirst;
begin
  client.Close;
  SetStatus(sdstNotActive);
end;

procedure TOmronFQ_CR1Thread.RecvAsync;
begin
  if Assigned(FRecvData) then FRecvData(FOmronFQ_CR1,FRecv);
end;

function TOmronFQ_CR1Thread.Reset(pBuf: PKRBuffer; var AResp: integer): integer;
begin
  FReset:=3;
  AResp:=0;
  pBuf^[0]:=82;
  pBuf^[1]:=69;
  pBuf^[2]:=83;
  pBuf^[3]:=69;
  pBuf^[4]:=84;
  pBuf^[5]:=13;
  Result:=6;
end;

procedure TOmronFQ_CR1Thread.SendAsync;
var
  s: String;
  i: integer;
begin
  if Assigned(FSendData) then begin
    s:='';
    for i := 0 to l-1 do s:=s+Chr(sBuf[i]);
    FSendData(FOmronFQ_CR1,s);
  end;
end;

function TOmronFQ_CR1Thread.SensorModel(pBuf: PKRBuffer;
  var AResp: integer): integer;
begin
  fun:=5;
  AResp:=2;
  FSensorModel:=2;
  pBuf^[0]:=86;
  pBuf^[1]:=69;
  pBuf^[2]:=82;
  pBuf^[3]:=71;
  pBuf^[4]:=69;
  pBuf^[5]:=84;
  pBuf^[6]:=32;
  pBuf^[7]:=47;
  pBuf^[8]:=72;
  pBuf^[9]:=13;
  Result:=10;
end;

procedure TOmronFQ_CR1Thread.SensorModelErr;
begin
  FSensorModel:=4;
end;

function TOmronFQ_CR1Thread.SensorModelResp(s1, s2: String): boolean;
begin
  result:=s2='OK';
  if result then begin
    FSensorModelValue:=s1;
    FSensorModel:=3;
    Synchronize(Err);
  end;
end;

procedure TOmronFQ_CR1Thread.SetStatus(AStatus: TSchemeDeviceConnStat);
begin
  FState:=AStatus;
  Synchronize(Status);
end;

function TOmronFQ_CR1Thread.StartMeasurements(pBuf: PKRBuffer;
  var AResp: integer): integer;
begin
  fun:=2;
  AResp:=1;
  FStartMeasurements:=2;
  pBuf^[0]:=77;
  pBuf^[1]:=69;
  pBuf^[2]:=65;
  pBuf^[3]:=83;
  pBuf^[4]:=85;
  pBuf^[5]:=82;
  pBuf^[6]:=69;
  pBuf^[7]:=32;
  pBuf^[8]:=47;
  pBuf^[9]:=67;
  pBuf^[10]:=13;
  Result:=11;
end;

procedure TOmronFQ_CR1Thread.StartMeasurementsErr;
begin
  FStartMeasurements:=4;
end;

function TOmronFQ_CR1Thread.StartMeasurementsResp(s: String): boolean;
begin
  result:=s='OK';
  if result then FStartMeasurements:=3;
end;

procedure TOmronFQ_CR1Thread.Status;
begin
  if Assigned(FOmronFQ_CR1.FConnectionStatus) then
    FOmronFQ_CR1.FConnectionStatus(FOmronFQ_CR1,FState,MMSystem.timeGetTime-FLastConnectTime);
end;

function TOmronFQ_CR1Thread.StopMeasurements(pBuf: PKRBuffer;
  var AResp: integer): integer;
begin
  fun:=3;
  AResp:=1;
  FStopMeasurements:=2;
  pBuf^[0]:=77;
  pBuf^[1]:=69;
  pBuf^[2]:=65;
  pBuf^[3]:=83;
  pBuf^[4]:=85;
  pBuf^[5]:=82;
  pBuf^[6]:=69;
  pBuf^[7]:=32;
  pBuf^[8]:=47;
  pBuf^[9]:=69;
  pBuf^[10]:=13;
  Result:=11;
end;

procedure TOmronFQ_CR1Thread.StopMeasurementsErr;
begin
  FStopMeasurements:=4
end;

function TOmronFQ_CR1Thread.StopMeasurementsResp(s: String): boolean;
begin
  result:=s='OK';
  if result then FStopMeasurements:=3;
end;

end.
