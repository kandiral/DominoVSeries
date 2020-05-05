unit OmronFQ_CR1SetsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OmronFQ_CR1;

type
  TOmronFQ_CR1SetsForm = class(TForm)
    Panel1: TPanel;
    leAddr: TLabeledEdit;
    lePort: TLabeledEdit;
    leConnectTimeout: TLabeledEdit;
    leReconnectTime: TLabeledEdit;
    leReadTimeout: TLabeledEdit;
    leErrGetTime: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    leName: TLabeledEdit;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    res: boolean;
    FScheme: TObject;
    FIndex: integer;
    function Execute(ACamera: TOmronFQ_CR1; AIndex: integer; AScheme: TObject): boolean;
  end;

var
  OmronFQ_CR1SetsForm: TOmronFQ_CR1SetsForm;

implementation

uses Funcs, SchemeItem{, Scheme};

{$R *.dfm}

{ TOmronFQ_CR1SetsForm }

procedure TOmronFQ_CR1SetsForm.Button2Click(Sender: TObject);
var
  n: integer;
  s: String;
begin
  if not isValidName(leName.Text) then begin
    funcs.AppMsgBoxErr('Имя введено некорректно!');
    Exit;
  end;
{  if not TScheme(FScheme).checkName(leName.Text,1,Findex) then begin
    funcs.AppMsgBoxErr('Объект с таким именем уже присутствует на схеме!');
    Exit;
  end;}
  if not isIp(leAddr.Text) then begin
    funcs.AppMsgBoxErr('Не корректный IP адрес!');
    Exit;
  end;
  n:=StrToIntDef(lePort.Text,-1);
  if (n<1)or(n>65500) then begin
    funcs.AppMsgBoxErr('Не корректный порт!');
    Exit;
  end;
  n:=StrToIntDef(leConnectTimeout.Text,-1);
  if (n<100)or(n>30000) then begin
    funcs.AppMsgBoxErr('Не корректное значение "Таймаут подключения"!');
    Exit;
  end;
  n:=StrToIntDef(leReconnectTime.Text,-1);
  if (n<100)or(n>30000) then begin
    funcs.AppMsgBoxErr('Не корректное значение "Время переподключения"!');
    Exit;
  end;
  n:=StrToIntDef(leReadTimeout.Text,-1);
  if (n<100)or(n>30000) then begin
    funcs.AppMsgBoxErr('Не корректное значение "Таймаут чтения"!');
    Exit;
  end;
  n:=StrToIntDef(leErrGetTime.Text,-1);
  if (n<100)or(n>30000) then begin
    funcs.AppMsgBoxErr('Не корректное значение "Интервал получения статуса"!');
    Exit;
  end;


  res:=true;
  close;
end;

function TOmronFQ_CR1SetsForm.Execute(ACamera: TOmronFQ_CR1; AIndex: integer; AScheme: TObject): boolean;
begin
  FScheme:=AScheme;
  FIndex:=AIndex;
  leName.Text:=ACamera.Name;
  leAddr.Text:=ACamera.Addr;
  lePort.Text:=IntToStr(ACamera.Port);
  leConnectTimeout.Text:=IntToStr(ACamera.ConnectTimeout);
  leReconnectTime.Text:=IntToStr(ACamera.ReconnectTime);
  leReadTimeout.Text:=IntToStr(ACamera.ReadTimeout);
  leErrGetTime.Text:=IntToStr(ACamera.ErrGetTime);
  res:=false;
  showmodal;
  result:=res;
  if result then begin
    ACamera.Name:=leName.Text;
    ACamera.Addr:=leAddr.Text;
    ACamera.Port:=StrToInt(lePort.Text);
    ACamera.ConnectTimeout:=StrToInt(leConnectTimeout.Text);
    ACamera.ReconnectTime:=StrToInt(leReconnectTime.Text);
    ACamera.ReadTimeout:=StrToInt(leReadTimeout.Text);
    ACamera.ErrGetTime:=StrToInt(leErrGetTime.Text);
  end;
end;

end.
