unit MonitoringUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMonitoringForm = class(TForm)
    Panel3: TPanel;
    cbAutoScrolling: TCheckBox;
    btnSaveLog: TButton;
    Panel1: TPanel;
    chOnOff: TCheckBox;
    lbLogs: TListBox;
    SaveDialog1: TSaveDialog;
    procedure cbAutoScrollingClick(Sender: TObject);
    procedure btnSaveLogClick(Sender: TObject);
    procedure chOnOffClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams);override;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure send(Sender: TObject; AData: String);
    procedure recv(Sender: TObject; AData: String);
    procedure AddLog(Text: String);
  end;

var
  MonitoringForm: TMonitoringForm;

implementation

uses Unit1;

{$R *.dfm}

{ TMonitoringForm }

procedure TMonitoringForm.AddLog(Text: String);
begin
  if not chOnOff.Checked then exit;

  lbLogs.Items.Add(FormatDateTime('dd.mm.yyyy h:nn:ss.zzz',now)+'    '+Text);

  if cbAutoScrolling.Checked then
    lbLogs.TopIndex:=lbLogs.Items.Count-1;
end;

procedure TMonitoringForm.btnSaveLogClick(Sender: TObject);
begin
  SaveDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
  SaveDialog1.FileName:='monitoring_'+FormatDateTime('dd_mm_yyyy__h_nn_ss',now)+'.log';
  if SaveDialog1.Execute(handle) then
    lbLogs.Items.SaveToFile(SaveDialog1.FileName);
end;

procedure TMonitoringForm.cbAutoScrollingClick(Sender: TObject);
begin
  if cbAutoScrolling.Checked then
    lbLogs.TopIndex:=lbLogs.Items.Count-1;
end;

procedure TMonitoringForm.chOnOffClick(Sender: TObject);
begin
  btnSaveLog.Enabled:=not chOnOff.Checked;
end;

procedure TMonitoringForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle:=Params.ExStyle or WS_Ex_AppWindow;
  Params.WndParent:=0;
end;

procedure TMonitoringForm.FormHide(Sender: TObject);
begin
  Form1.fb2.OnSendData:=nil;
  Form1.fb2.OnRecvData:=nil;
end;

procedure TMonitoringForm.FormShow(Sender: TObject);
begin
  chOnOff.Checked:=false;
  cbAutoScrolling.Checked:=true;
  btnSaveLog.Enabled:=true;
  Form1.fb2.OnSendData:=send;
  Form1.fb2.OnRecvData:=recv;
end;

procedure TMonitoringForm.recv(Sender: TObject; AData: String);
begin
  AddLog('RECV: '+AData);
end;

procedure TMonitoringForm.send(Sender: TObject; AData: String);
begin
  AddLog('SEND: '+AData);
end;

end.
