(******************************************************************************)
(*                                                                            *)
(*  Kandiral Ruslan                                                           *)
(*  https://kandiral.ru                                                       *)
(*  https://kandiral.ru/delphi/rabota_s_omron_fq_cr1.html                     *)
(*                                                                            *)
(******************************************************************************)
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, OmronFQ_CR1, KRIniConfig, Funcs, SchemeItem;

type
  TForm1 = class(TForm)
    btnConnection: TButton;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    btnStartMeasurements: TButton;
    statStartMeasurements: TEdit;
    btnStopMeasurements: TButton;
    statStopMeasurements: TEdit;
    btnExecuteMeasurement: TButton;
    statExecuteMeasurement: TEdit;
    ExecuteMeasurementValue: TEdit;
    btnMonitoring: TButton;
    btnReset: TButton;
    btnClearMeasurement: TButton;
    statClearMeasurement: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    ListBox1: TListBox;
    cbAutoScrolling: TCheckBox;
    btnSaveLog: TButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStartMeasurementsClick(Sender: TObject);
    procedure btnStopMeasurementsClick(Sender: TObject);
    procedure btnExecuteMeasurementClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbAutoScrollingClick(Sender: TObject);
    procedure btnConnectionClick(Sender: TObject);
    procedure btnMonitoringClick(Sender: TObject);
    procedure btnSaveLogClick(Sender: TObject);
    procedure btnClearMeasurementClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fb2: TOmronFQ_CR1;
    cfg: TKRIniConfig;
    cfgCodeLogAutoScrolling, cfgAddr, cfgPort, cfgConnectTimeout,
      cfgReconnectTime, cfgReadTimeout, cfgErrGetTime: TKRIniCfgParam;
    procedure Start;
    procedure Stop;
    procedure getCode(Sender: TObject; AValue: String);
    procedure ConnectionStatus(Sender: TObject;
      AStatus: TSchemeDeviceConnStat; AReconnectTime: Cardinal);
    procedure OnErr(ASender: TObject);
  end;

var
  Form1: TForm1;

implementation

uses OmronFQ_CR1SetsFrm, MonitoringUnit, IniFiles;

{$R *.dfm}

{ TForm1 }

procedure TForm1.btnSaveLogClick(Sender: TObject);
begin
  SaveDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
  SaveDialog1.FileName:='codes_from_fb2_'+FormatDateTime('dd_mm_yyyy__h_nn_ss',now)+'.log';
  if SaveDialog1.Execute(handle) then
    ListBox1.Items.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.btnStartMeasurementsClick(Sender: TObject);
begin
  btnStartMeasurements.Enabled:=false;
  statStartMeasurements.Text:='';
  if fb2.StartMeasurements then
    statStartMeasurements.Text:='OK'
  else
    statStartMeasurements.Text:='ERROR';
  btnStartMeasurements.Enabled:=true;
end;

procedure TForm1.btnStopMeasurementsClick(Sender: TObject);
begin
  btnStopMeasurements.Enabled:=false;
  statStopMeasurements.Text:='';
  if fb2.StopMeasurements then
    statStopMeasurements.Text:='OK'
  else
    statStopMeasurements.Text:='ERROR';
  btnStopMeasurements.Enabled:=true;
end;

procedure TForm1.btnClearMeasurementClick(Sender: TObject);
begin
  btnClearMeasurement.Enabled:=false;
  statClearMeasurement.Text:='';
  if fb2.ClearMeasurements then
    statClearMeasurement.Text:='OK'
  else
    statClearMeasurement.Text:='ERROR';
  btnClearMeasurement.Enabled:=true;
end;

procedure TForm1.btnConnectionClick(Sender: TObject);
var
  ini: TIniFile;
  b: boolean;
begin
  if OmronFQ_CR1SetsForm.Execute(fb2,0,Self) then begin
    b:=fb2.Active;
    fb2.Active:=false;
    ini:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'cam.ini');
    ini.WriteString('OmronFB2',fb2.Name+'_IP',fb2.Addr);
    ini.WriteInteger('OmronFB2',fb2.Name+'_Port',fb2.Port);
    ini.WriteInteger('OmronFB2',fb2.Name+'_ConnectTimeout',fb2.ConnectTimeout);
    ini.WriteInteger('OmronFB2',fb2.Name+'_ReconnectTime',fb2.ReconnectTime);
    ini.WriteInteger('OmronFB2',fb2.Name+'_ReadTimeout',fb2.ReadTimeout);
    ini.WriteInteger('OmronFB2',fb2.Name+'_ErrGetime',fb2.ErrGetTime);
    ini.Free;
    fb2.Active:=b;
  end;
end;

procedure TForm1.btnExecuteMeasurementClick(Sender: TObject);
var
  s: String;
begin
  btnExecuteMeasurement.Enabled:=false;
  statExecuteMeasurement.Text:='';
  ExecuteMeasurementValue.Text:='';
  if fb2.ExecuteMeasurement(s) then begin
    statExecuteMeasurement.Text:='OK';
    ExecuteMeasurementValue.Text:=s;
  end else
    statExecuteMeasurement.Text:='ERROR';
  btnExecuteMeasurement.Enabled:=true;
end;

procedure TForm1.btnMonitoringClick(Sender: TObject);
begin
  if MonitoringForm.Visible then begin
    SetActiveWindow(MonitoringForm.Handle);
    ShowWindow(MonitoringForm.Handle, SW_RESTORE);
    SetForegroundWindow(MonitoringForm.Handle);
  end else MonitoringForm.Show;
end;

procedure TForm1.btnResetClick(Sender: TObject);
begin
  FB2.Reset;
end;

procedure TForm1.cbAutoScrollingClick(Sender: TObject);
begin
  cfgCodeLogAutoScrolling.Value:=cbAutoScrolling.Checked;
  if cbAutoScrolling.Checked then
    ListBox1.TopIndex:=ListBox1.Items.Count-1;
end;

procedure TForm1.ConnectionStatus(Sender: TObject;
  AStatus: TSchemeDeviceConnStat; AReconnectTime: Cardinal);
begin
    case AStatus of
      sdstNotActive: StatusBar1.Panels[0].text:='Не активен';
      sdstDisconnected: StatusBar1.Panels[0].text:='Отключен';
      sdstConnecting: StatusBar1.Panels[0].text:='Подключение...';
      sdstWaitReconnecting: StatusBar1.Panels[0].text:=
        'Переподключение '+IntToStr(TSchemeItem(Sender).calcReconnectTime(AReconnectTime) div 1000)+'с...';
      sdstConnected: StatusBar1.Panels[0].text:='Подключен';
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  n: integer;
  ini: TIniFile;
begin
  cfg:=TKRIniConfig.Create(Self);

  cfgCodeLogAutoScrolling:=cfg.AddParam('CodeLogAutoScrolling','Settings',icvtBool,true);
  cbAutoScrolling.OnClick:=nil;
  cbAutoScrolling.Checked:=cfgCodeLogAutoScrolling.Value;
  cbAutoScrolling.OnClick:=cbAutoScrollingClick;


  ini:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'cam.ini');
  n:=0;
  fb2:=TOmronFQ_CR1.Create;
  fb2.Name:='';
  fb2.OnMeasurementValue:=getCode;
  fb2.OnConnectionStatus:=ConnectionStatus;
  fb2.OnErr:=OnErr;
  fb2.Addr:='192.168.1.2';
  fb2.Port:=9876;
  fb2.ConnectTimeout:=1000;
  fb2.ReconnectTime:=5000;
  fb2.ReadTimeout:=1000;
  fb2.ErrGetTime:=1000;
  ini.WriteString('OmronFB2',fb2.Name+'_IP',fb2.Addr);
  ini.WriteInteger('OmronFB2',fb2.Name+'_Port',fb2.Port);
  ini.WriteInteger('OmronFB2',fb2.Name+'_ConnectTimeout',fb2.ConnectTimeout);
  ini.WriteInteger('OmronFB2',fb2.Name+'_ReconnectTime',fb2.ReconnectTime);
  ini.WriteInteger('OmronFB2',fb2.Name+'_ReadTimeout',fb2.ReadTimeout);
  ini.WriteInteger('OmronFB2',fb2.Name+'_ErrGetTime',fb2.ErrGetTime);
  ini.Free;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Stop;
  fb2.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Start;
end;

procedure TForm1.getCode(Sender: TObject; AValue: String);
begin
  ListBox1.Items.Add(FormatDateTime('dd.mm.yyyy h:nn:ss.zzz',now)+'        '+AValue);
  if cbAutoScrolling.Checked then
    ListBox1.TopIndex:=ListBox1.Items.Count-1;
end;

procedure TForm1.OnErr(ASender: TObject);
var
  s: String;
begin
  s:=TOmronFQ_CR1(ASender).Err;
  if s='00000000' then begin
    s:=TOmronFQ_CR1(ASender).SensorModel;
    if s='' then StatusBar1.Panels[0].text:='Подключен'
    else StatusBar1.Panels[0].text:=s;
  end else if s='01040302' then StatusBar1.Panels[0].text:='Ошибка ввода TRIG'
  else if s='11020900' then StatusBar1.Panels[0].text:='Ошибка ввода IN'
  else if s='01030800' then StatusBar1.Panels[0].text:='Ошибка данных сцены'
  else if(s='02160702')or(s='02160703')then StatusBar1.Panels[0].text:='Ошибка регистрации'
  else StatusBar1.Panels[0].text:='Неизвестная ошибка';
end;

procedure TForm1.Start;
begin
  fb2.Active:=true;
end;

procedure TForm1.Stop;
begin
  fb2.Active:=false;
end;

end.
