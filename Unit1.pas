(****************************************************************************************************)
(*                                                                                                  *)
(*  Kandiral Ruslan                                                                                 *)
(*  https://kandiral.ru                                                                             *)
(*  https://kandiral.ru/delphi/upravlenie_termotransfernym_printerom_domino_v_series_po_seti.html   *)
(*                                                                                                  *)
(****************************************************************************************************)
unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DominoVSeries, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.StdCtrls, StrUtils, KRTypes, Funcs, WideStrUtils;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Memo2: TMemo;
    LabeledEdit4: TLabeledEdit;
    Label3: TLabel;
    Memo3: TMemo;
    LabeledEdit5: TLabeledEdit;
    GroupBox2: TGroupBox;
    LabeledEdit6: TLabeledEdit;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    Panel3: TPanel;
    LabeledEdit7: TLabeledEdit;
    Panel4: TPanel;
    ListBox2: TListBox;
    Button3: TButton;
    Button4: TButton;
    Label4: TLabel;
    Button2: TButton;
    Button7: TButton;
    Button8: TButton;
    Button5: TButton;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    Button6: TButton;
    Edit1: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    isActivate: boolean;
    procedure printName(Sender: TObject; AText: String);
    procedure status(Sender: TObject; ACode: integer; ADescription: TStrings);
    procedure error(Sender: TObject; ACode: integer; ADescription: TStrings);
    procedure warning(Sender: TObject; ACode: integer; ADescription: TStrings);
    procedure printCount(Sender: TObject; AValue: integer);
    procedure send(Sender: TObject; APack: PKRBuffer; ALength: integer);
    procedure recv(Sender: TObject; APack: PKRBuffer; ALength: integer);
  public
    { Public declarations }
    printer: TDominoVSeries;
    data: TDVSData;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2, Unit3;

procedure TForm1.Button1Click(Sender: TObject);
var i: integer;
begin
  data.Request:='';
  data.rCommand:=LabeledEdit6.Text;
  data.isAnswer:=true;
  LabeledEdit7.Text:='';
  ListBox2.Clear;
  Label4.Caption:='Wait...';
  printer.Send(@data);
  if data.Error=0 then begin
    LabeledEdit7.Text:=data.aCommand;
    for I := 0 to Length(data.aPrms)-1 do
      if VarIsOrdinal(data.aPrms[i]) then
        ListBox2.Items.Add('INTEGER: '+IntToStr(data.aPrms[i]))
      else if VarIsFloat(data.aPrms[i]) then
        ListBox2.Items.Add('FLOAT: '+FormatFloat('0.0#####',data.aPrms[i]))
      else
        ListBox2.Items.Add('STRING: '+data.aPrms[i]);
    Label4.Caption:='OK';
  end else if data.Error<0 then Label4.Caption:='Error '+IntToStr(data.Error)
  else Label4.Caption:='Error: '+printer.Connector.ErrorMsg(data.Error);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  printer.AckError;
  printer.AckNonCriticalError
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ListBox1.Clear;
  SetLength(data.rPrms,0);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if Form2.ShowModal=mrOk then begin
    SetLength(data.rPrms,Length(data.rPrms)+1);
    case Form2.ComboBox1.ItemIndex of
      0: begin
        data.rPrms[Length(data.rPrms)-1]:=StrToIntDef(Form2.Edit1.Text,0);
        ListBox1.Items.Add('INTEGER: '+IntToStr(data.rPrms[Length(data.rPrms)-1]));
      end;
      1: begin
        Form2.Edit1.Text:=ReplaceStr(Form2.Edit1.Text,#44,FormatSettings.DecimalSeparator);
        Form2.Edit1.Text:=ReplaceStr(Form2.Edit1.Text,#46,FormatSettings.DecimalSeparator);
        data.rPrms[Length(data.rPrms)-1]:=StrToFloatDef(Form2.Edit1.Text,0);
        ListBox1.Items.Add('FLOAT: '+FormatFloat('0.0#####',data.rPrms[Length(data.rPrms)-1]));
      end;
      2: begin
        data.rPrms[Length(data.rPrms)-1]:=Form2.Edit1.Text;
        ListBox1.Items.Add('STRING: '+data.rPrms[Length(data.rPrms)-1]);
      end;
    end;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  printer.CancelPrint(false);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  isActive: boolean;
  bufSize: cardinal;
begin
  printer.PollSerialVar(LabeledEdit11.Text,isActive,bufSize);
  Edit1.Text:=IntToStr(bufSize)+' (Active='+IntToStr(integer(isActive))+')';
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  printer.FillSerialVar('VTEXT',LabeledEdit9.Text);
  printer.FillSerialVar('VTEXT2',LabeledEdit10.Text);
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  b0,b1,b2: boolean;
begin
  printer.PrintDesign(LabeledEdit8.Text,0,0,b0,b1,b2);
end;

procedure TForm1.error(Sender: TObject; ACode: integer; ADescription: TStrings);
begin
  LabeledEdit4.Text:=IntToStr(ACode);
  Memo2.Lines.Assign(ADescription);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if isActivate then exit;
  isActivate:=true;
  printer.Active:=true;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  timer1.Enabled:=false;
  sleep(1000);
  printer.Active:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  isActivate:=false;
  printer:=TDominoVSeries.Create(self);
  printer.StatInterval:=5000;
  printer.IP:='128.74.99.98';
  printer.Port:=9100;
  printer.Connector.ConnectTimeout:=2000;
  printer.Connector.WriteTimeout:=1500;
  printer.Connector.ReadTimeout:=1500;
  printer.OnPrintName:=printName;
  printer.OnPrintCount:=printCount;
  printer.OnStatus:=status;
  printer.OnError:=error;
  printer.OnWarning:=warning;
  printer.Connector.OnRecvAsync:=recv;
  printer.Connector.OnSendAsync:=send;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex=-1 then exit;
  if VarIsOrdinal(data.rPrms[ListBox1.ItemIndex]) then begin
    Form2.ComboBox1.ItemIndex:=0;
    Form2.Edit1.Text:=IntToStr(data.rPrms[ListBox1.ItemIndex]);
  end else if VarIsFloat(data.rPrms[ListBox1.ItemIndex]) then begin
    Form2.ComboBox1.ItemIndex:=1;
    Form2.Edit1.Text:=FormatFloat('0.0#####',data.rPrms[ListBox1.ItemIndex]);
  end else begin
    Form2.ComboBox1.ItemIndex:=2;
    Form2.Edit1.Text:=data.rPrms[ListBox1.ItemIndex];
  end;
  if Form2.ShowModal=mrOk then begin
    case Form2.ComboBox1.ItemIndex of
      0: begin
        data.rPrms[ListBox1.ItemIndex]:=StrToIntDef(Form2.Edit1.Text,0);
        ListBox1.Items[ListBox1.ItemIndex]:='INTEGER: '+IntToStr(data.rPrms[ListBox1.ItemIndex]);
      end;
      1: begin
        Form2.Edit1.Text:=ReplaceStr(Form2.Edit1.Text,#44,FormatSettings.DecimalSeparator);
        Form2.Edit1.Text:=ReplaceStr(Form2.Edit1.Text,#46,FormatSettings.DecimalSeparator);
        data.rPrms[ListBox1.ItemIndex]:=StrToFloatDef(Form2.Edit1.Text,0);
        ListBox1.Items[ListBox1.ItemIndex]:='FLOAT: '+FormatFloat('0.0#####',data.rPrms[ListBox1.ItemIndex]);
      end;
      2: begin
        data.rPrms[ListBox1.ItemIndex]:=Form2.Edit1.Text;
        ListBox1.Items[ListBox1.ItemIndex]:='STRING: '+data.rPrms[ListBox1.ItemIndex];
      end;
    end;
  end;

end;

procedure TForm1.printCount(Sender: TObject; AValue: integer);
begin
  LabeledEdit2.Text:=IntToStr(AValue);
end;

procedure TForm1.printName(Sender: TObject; AText: String);
begin
  LabeledEdit1.Text:=AText;
end;

procedure TForm1.recv(Sender: TObject; APack: PKRBuffer; ALength: integer);
var
  i: integer;
  s: String;
  wd: word;

  function wChr(w: Word): Char;
  begin
    Word(Pointer(@Result)^) := w;
  end;

begin
  Form3.Memo1.Lines.Add('RECV:');
  s:='';
  i:=0;
  repeat
    wd:=(word(APack^[i+1]) shl 8) or APack^[i];
    if wd<32 then s:=s+'#'+IntToStr(APack^[i]) else s:=s+wChr(wd);
    inc(i,2);
  until i>=ALength;
  Form3.Memo1.Lines.Add(s);
end;

procedure TForm1.send(Sender: TObject; APack: PKRBuffer; ALength: integer);
var
  i: integer;
  s: String;
  wd: word;

  function wChr(w: Word): Char;
  begin
    Word(Pointer(@Result)^) := w;
  end;

begin
  Form3.Memo1.Lines.Add('SEND:');
  s:='';
  i:=0;
  repeat
    wd:=(word(APack^[i+1]) shl 8) or APack^[i];
    if wd<32 then s:=s+'#'+IntToStr(APack^[i]) else s:=s+wChr(wd);
    inc(i,2);
  until i>=ALength;
  Form3.Memo1.Lines.Add(s);
end;

procedure TForm1.status(Sender: TObject; ACode: integer;
  ADescription: TStrings);
begin
  LabeledEdit3.Text:=IntToStr(ACode);
  Memo1.Lines.Assign(ADescription);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if printer.isConnected then
    StatusBar1.Panels[0].Text:='Connected'
  else
    StatusBar1.Panels[0].Text:='No Connection';
end;

procedure TForm1.warning(Sender: TObject; ACode: integer;
  ADescription: TStrings);
begin
  LabeledEdit5.Text:=IntToStr(ACode);
  Memo3.Lines.Assign(ADescription);
end;

end.
