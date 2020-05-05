program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MonitoringUnit in 'MonitoringUnit.pas' {MonitoringForm},
  OmronFQ_CR1SetsFrm in 'OmronFQ_CR1SetsFrm.pas' {OmronFQ_CR1SetsForm},
  OmronFQ_CR1 in 'OmronFQ_CR1.pas',
  Scheme in 'Scheme.pas',
  SchemeItem in 'SchemeItem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TMonitoringForm, MonitoringForm);
  Application.CreateForm(TOmronFQ_CR1SetsForm, OmronFQ_CR1SetsForm);
  Application.Run;
end.
