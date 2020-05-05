unit Scheme;

interface

uses Classes, SysUtils, IniFiles, OmronFB2, SchemeItem, OmronFB2SetsFrm, Forms,
  HandScaner, HandScanerSetsFrm, SATOPrinter, SATOPrinterSetsFrm, SATOPrinting,
  SchemeWaitFrm, Mark;

type
  TScheme = class
  private
    FGetIndex: integer;
    FConfigFile: String;
    FOmronFB2_OnMeasurementValue: TOmronFB2OnMeasurementValue;
    FOmronFB2_OnShortStat: TShortStat;
    FHandScaner_OnData: THandScanerData;
    FHandScaner_OnShortStat: TShortStat;
    FSATOPrinter_OnShortStat: TShortStat;
    FSATOPrinter_OnTagData: TSATOPrinterTagData;
    FOnShortStat: TShortStat;

    procedure ConnectionStatus(Sender: TObject; AStatus: TSchemeDeviceConnStat;
      AReconnectTime: Cardinal);

    procedure OmronFB2_freeList;
    procedure OmronFB2_Measurement(Sender: TObject; AValue: String);
    procedure OmronFB2_upList;

    procedure HandScaner_freeList;
    procedure HandScaner_upList;
    procedure HandScaner_Data(Sender: TObject; AData: String);

    procedure SATOPrinter_freeList;
    procedure SATOPrinter_upList;
    procedure SATOPrinter_state(Sender: TObject);

    procedure SATOPrinterTagData_(
      Sender: TObject; // TSATOPrinting
      APrinter: TSATOPrinter; //Printer
      ATemplateName, // Имя файла шаблона без пути
      ATagName: String; // Имя переменной
      APageNum: integer; // Номер текйщей страницы которая должна идти на печать. Начинается с еденицы
      var AValue: Variant // Значение которое бедет подставляться
      );

  public
    // Массив камер OmronFB2
    OmronFB2_list: array of TOmronFB2;
    HandScaner_list: array of THandScaner;
    SATOPrinter_list: array of TSATOPrinter;

    constructor Create;
    destructor Destroy;override;
    // Проверка дублирования имени
    function checkName(AName: String; AWo, AIndex: integer): boolean;
    // Короткое сообщение статуса, которое можно отображать бод значком устройства на схеме
    property OnShortStat: TShortStat read FOnShortStat write FOnShortStat;


    // Инициализация схемы
    // Передается путь и полное имя конфигурационного файла
    // Иницыализация создает все устройства прописанные в конфиг-файле
    procedure init(AConfigFile: String);

    // Добавление камеры в прцессе формировании схемы
    // В качестве параметра отправляется имя для созданной камеры
    procedure OmronFB2_add(AName: String);
    // Получить камеру по имени
    function OmronFB2_get(AName: String): TOmronFB2;
    // Открывает форму настроек камеры по указанному имени
    // Если взвращает True значит имя камеры изменилось
    function OmronFB2_showSets(AName: String): boolean;
    // Активация камеры по имени
    // Если имя пусто, то активируются все камеры
    procedure OmronFB2_activate(AName: String);
    // Деактивация камеры по имени
    // Если имя пусто, то деактивируются все камеры
    procedure OmronFB2_deactivate(AName: String);
    // Вызывается при удалении камеры со схемы
    // Если камера с указанным именем не найдена, то возвращается false
    function OmronFB2_delete(AName: String): boolean;
    // Событие при получении сканируемых данных со всех камер на схеме
    // Определение имени камеры
    //   TOmronFB2(Sender).Name
    // или
    //   TShemeItem(Sender).Name
    property OmronFB2_OnMeasurementValue: TOmronFB2OnMeasurementValue read FOmronFB2_OnMeasurementValue
      write FOmronFB2_OnMeasurementValue;



    // Добавление камеры в прцессе формировании схемы
    // В качестве параметра отправляется имя для созданной камеры
    procedure HandScaner_add(AName: String);
    // Получить камеру по имени
    function HandScaner_get(AName: String): THandScaner;
    // Открывает форму настроек камеры по указанному имени
    // Если взвращает True значит имя камеры изменилось
    function HandScaner_showSets(AName: String): boolean;
    // Активация камеры по имени
    // Если имя пусто, то активируются все камеры
    procedure HandScaner_activate(AName: String);
    // Деактивация камеры по имени
    // Если имя пусто, то деактивируются все камеры
    procedure HandScaner_deactivate(AName: String);
    // Вызывается при удалении камеры со схемы
    // Если камера с указанным именем не найдена, то возвращается false
    function HandScaner_delete(AName: String): boolean;
    // Событие при получении сканируемых данных со всех ручных сканеров на схеме
    // Определение имени камеры
    //   TOmronFB2(Sender).Name
    // или
    //   TShemeItem(Sender).Name
    property HandScaner_OnData: THandScanerData read FHandScaner_OnData write FHandScaner_OnData;





    // Добавление камеры в прцессе формировании схемы
    // В качестве параметра отправляется имя для созданной камеры
    procedure SATOPrinter_add(AName: String);
    // Получить камеру по имени
    function SATOPrinter_get(AName: String): TSATOPrinter;
    // Открывает форму настроек камеры по указанному имени
    // Если взвращает True значит имя камеры изменилось
    function SATOPrinter_showSets(AName: String): boolean;
    // Активация камеры по имени
    // Если имя пусто, то активируются все камеры
    procedure SATOPrinter_activate(AName: String);
    // Деактивация камеры по имени
    // Если имя пусто, то деактивируются все камеры
    procedure SATOPrinter_deactivate(AName: String);
    // Вызывается при удалении камеры со схемы
    // Если камера с указанным именем не найдена, то возвращается false
    function SATOPrinter_delete(AName: String): boolean;



    // Вызывается перед/вовремя печати для установки значений динамических данных
    property SATOPrinter_OnTagData: TSATOPrinterTagData read FSATOPrinter_OnTagData write FSATOPrinter_OnTagData;
    // Печать
    //   APrinterName - имя принтера
    //   ATemplae - путь и имя шаблона
    //   ACount - количество копий
    procedure SATOPrinter_print(APrinterName, ATemplae: String; ACount: integer);
    // Короткое сообщение статуса ручных статусов, которое можно отображать бод значком камеры на схеме


  end;



implementation

uses funcs;

{ TScheme }

function TScheme.checkName(AName: String; AWo, AIndex: integer): boolean;
var i,n: integer;
  s: String;
begin
  result:=true;
  s:=LowerCase(AName);

  n:=Length(OmronFB2_list)-1;
  for I := 0 to n do begin
    if(AWo=1)and(AIndex=i) then continue;
    if s=LowerCase(OmronFB2_list[i].Name) then begin
      result:=false;
      exit;
    end;
  end;


  n:=Length(HandScaner_list)-1;
  for I := 0 to n do begin
    if(AWo=2)and(AIndex=i) then continue;
    if s=LowerCase(HandScaner_list[i].Name) then begin
      result:=false;
      exit;
    end;
  end;

  n:=Length(SATOPrinter_list)-1;
  for I := 0 to n do begin
    if(AWo=3)and(AIndex=i) then continue;
    if s=LowerCase(SATOPrinter_list[i].Name) then begin
      result:=false;
      exit;
    end;
  end;

end;

procedure TScheme.ConnectionStatus(Sender: TObject;
  AStatus: TSchemeDeviceConnStat; AReconnectTime: Cardinal);
begin
  if Assigned(OnShortStat) then
    case AStatus of
      sdstNotActive: FOnShortStat(TSchemeItem(Sender),'Не активен');
      sdstDisconnected: FOnShortStat(TSchemeItem(Sender),'Отключен');
      sdstConnecting: FOnShortStat(TSchemeItem(Sender),'Подключение...');
      sdstWaitReconnecting: FOnShortStat(TSchemeItem(Sender),
        'Переподключение '+IntToStr(TSchemeItem(Sender).calcReconnectTime(AReconnectTime) div 1000)+'с...');
      sdstConnected: FOnShortStat(TSchemeItem(Sender),'Подключен');
    end;
end;

constructor TScheme.Create;
begin
  if not Assigned(OmronFB2SetsForm) then Application.CreateForm(TOmronFB2SetsForm, OmronFB2SetsForm);
  if not Assigned(HandScanerSetsForm) then Application.CreateForm(THandScanerSetsForm, HandScanerSetsForm);
  if not Assigned(SATOPrinterSetsForm) then Application.CreateForm(TSATOPrinterSetsForm, SATOPrinterSetsForm);
  if not Assigned(SchemeWaitForm) then
    Application.CreateForm(TSchemeWaitForm, SchemeWaitForm);
end;

destructor TScheme.Destroy;
var n: integer;
begin
  SchemeWaitForm.ProgressBar1.Position:=0;
  n:=Length(OmronFB2_list)+Length(HandScaner_list)+Length(SATOPrinter_list);
  if n>0 then begin
    SchemeWaitForm.ProgressBar1.Max:=n;
    SchemeWaitForm.Show;
    Application.MainForm.Enabled:=false;
  end;
  OmronFB2_freeList;
  HandScaner_freeList;
  SATOPrinter_freeList;
  if n>0 then begin
    SchemeWaitForm.Hide;
    Application.MainForm.Enabled:=true;
  end;
  inherited;
end;

procedure TScheme.HandScaner_activate(AName: String);
var
  cm: THandScaner;
  i,n: integer;
begin
  if AName='' then begin
    n:=Length(HandScaner_list)-1;
    for I := 0 to n do begin
      HandScaner_list[i].Active:=true;
      if Assigned(FHandScaner_OnShortStat) then FHandScaner_OnShortStat(HandScaner_list[i],'Отключен');
    end;
  end else begin
    cm:=HandScaner_get(AName);
    if cm<>nil then begin
      cm.Active:=true;
      if Assigned(FHandScaner_OnShortStat) then FHandScaner_OnShortStat(cm,'Отключен');
    end;
  end;
end;

procedure TScheme.HandScaner_add(AName: String);
var
  n: integer;
  ini: TIniFile;
begin
  ini:=TIniFile.Create(FConfigFile);
  n:=Length(HandScaner_list);
  SetLength(HandScaner_list,n+1);
  HandScaner_list[n]:=THandScaner.Create;
  HandScaner_list[n].Name:=AName;
  HandScaner_list[n].OnConnectionStatus:=ConnectionStatus;
  HandScaner_list[n].OnData:=HandScaner_Data;
  HandScaner_list[n].ComPort.Port:='COM1';
  HandScaner_list[n].ComPort.BaudRate:=9600;
  HandScaner_list[n].ComPort.FlowControl:=0;
  HandScaner_list[n].ComPort.Parity:=0;
  HandScaner_list[n].ComPort.StopBits:=0;
  HandScaner_list[n].ComPort.DataBits:=8;
  HandScaner_list[n].ReconnectTime:=5000;
  ini.WriteString('HandScaner',AName+'_Port',HandScaner_list[n].ComPort.Port);
  ini.WriteInteger('HandScaner',AName+'_BaudRate',HandScaner_list[n].ComPort.BaudRate);
  ini.WriteInteger('HandScaner',AName+'_FlowControl',HandScaner_list[n].ComPort.FlowControl);
  ini.WriteInteger('HandScaner',AName+'_Parity',HandScaner_list[n].ComPort.Parity);
  ini.WriteInteger('HandScaner',AName+'_StopBits',HandScaner_list[n].ComPort.StopBits);
  ini.WriteInteger('HandScaner',AName+'_DataBits',HandScaner_list[n].ComPort.DataBits);
  ini.WriteInteger('HandScaner',AName+'_ReconnectTime',HandScaner_list[n].ReconnectTime);
  if Assigned(FHandScaner_OnShortStat) then FHandScaner_OnShortStat(HandScaner_list[n],'Не активен');
  ini.Free;
  HandScaner_upList;
end;

procedure TScheme.HandScaner_Data(Sender: TObject; AData: String);
begin
  if Assigned(HandScaner_OnData) then
    HandScaner_OnData(TSchemeItem(Sender),AData);
end;

procedure TScheme.HandScaner_deactivate(AName: String);
var
  cm: THandScaner;
  i,n: integer;
begin
  if AName='' then begin
    n:=Length(HandScaner_list)-1;
    for I := 0 to n do begin
      HandScaner_list[i].Active:=false;
      if Assigned(FHandScaner_OnShortStat) then FHandScaner_OnShortStat(HandScaner_list[i],'Не активен');
    end;
  end else begin
    cm:=HandScaner_get(AName);
    if cm<>nil then begin
      cm.Active:=false;
      if Assigned(FHandScaner_OnShortStat) then FHandScaner_OnShortStat(cm,'Не активен');
    end;
  end;
end;

function TScheme.HandScaner_delete(AName: String): boolean;
var
  n,i,m: integer;
begin
  result:=false;
  n:=Length(HandScaner_list)-1;
  m:=-1;
  for I := 0 to n do
    if HandScaner_list[i].Name=AName then begin
      m:=i;
      break;
    end;
  if m=-1 then exit;
  HandScaner_list[m].OnConnectionStatus:=nil;
  HandScaner_list[m].OnData:=nil;
  HandScaner_list[m].Active:=false;
  HandScaner_list[m].Free;
  for I := m to n-1 do HandScaner_list[i]:=HandScaner_list[i+1];
  SetLength(HandScaner_list,n);
  HandScaner_upList;
  result:=true;
end;

procedure TScheme.HandScaner_freeList;
var
  i,n: Integer;
begin
  n:=Length(HandScaner_list)-1;
  for I := 0 to n do begin
    HandScaner_list[i].Active:=false;
    HandScaner_list[i].Free;
    SchemeWaitForm.Progress;
  end;
  SetLength(HandScaner_list,0);
end;

function TScheme.HandScaner_get(AName: String): THandScaner;
var
  n,i: integer;
begin
  Result:=nil;
  n:=Length(HandScaner_list)-1;
  for I := 0 to n do
    if HandScaner_list[i].Name=AName then begin
      FGetIndex:=i;
      Result:=HandScaner_list[i];
      break;
    end;
end;

function TScheme.HandScaner_showSets(AName: String): boolean;
var
  cm: THandScaner;
  ini: TIniFile;
  b: boolean;
begin
  result:=false;
  cm:=HandScaner_get(AName);
  if cm<>nil then
    if HandScanerSetsForm.Execute(cm,FGetIndex,Self) then begin
      b:=cm.Active;
      cm.Active:=false;
      ini:=TIniFile.Create(FConfigFile);
      result:=AName<>cm.Name;
      ini.WriteString('HandScaner',cm.Name+'_Port',cm.ComPort.Port);
      ini.WriteInteger('HandScaner',cm.Name+'_BaudRate',cm.ComPort.BaudRate);
      ini.WriteInteger('HandScaner',cm.Name+'_FlowControl',cm.ComPort.FlowControl);
      ini.WriteInteger('HandScaner',cm.Name+'_Parity',cm.ComPort.Parity);
      ini.WriteInteger('HandScaner',cm.Name+'_StopBits',cm.ComPort.StopBits);
      ini.WriteInteger('HandScaner',cm.Name+'_DataBits',cm.ComPort.DataBits);
      ini.WriteInteger('HandScaner',cm.Name+'_ReconnectTime',cm.ReconnectTime);
      ini.Free;
      if result then HandScaner_upList;
      cm.Active:=b;
    end;
end;

procedure TScheme.HandScaner_upList;
var
  ini: TIniFile;
  s: String;
  n,i: integer;
begin
  ini:=TIniFile.Create(FConfigFile);
  s:='';
  n:=Length(HandScaner_list)-1;
  if n>-1 then begin
    for I := 0 to n do s:=s+HandScaner_list[i].Name+'|';
    s:=Copy(s,1,Length(s)-1);
  end;
  ini.WriteString('HandScaner','list',s);
  ini.Free;
end;

procedure TScheme.init(AConfigFile: String);
var
  ini: TIniFile;
  sl: TStringList;
  s: String;
  n,i: integer;
begin
  FConfigFile:=AConfigFile;
  ini:=TIniFile.Create(FConfigFile);

  // OmronFB2 begin
  OmronFB2_freeList;
  s:=ini.ReadString('OmronFB2','list','');
  if s<>'' then begin
    sl:=Explode('|',s);
    n:=sl.Count;
    SetLength(OmronFB2_list,n);
    dec(n);
    for I := 0 to n do begin
      s:=sl[i];
      OmronFB2_list[i]:=TOmronFB2.Create;
      OmronFB2_list[i].Name:=s;
      OmronFB2_list[i].OnMeasurementValue:=OmronFB2_Measurement;
      OmronFB2_list[i].OnConnectionStatus:=ConnectionStatus;
      OmronFB2_list[i].Addr:=ini.ReadString('OmronFB2',s+'_IP','192.168.1.2');
      OmronFB2_list[i].Port:=ini.ReadInteger('OmronFB2',s+'_Port',9876);
      OmronFB2_list[i].ConnectTimeout:=ini.ReadInteger('OmronFB2',s+'_ConnectTimeout',1000);
      OmronFB2_list[i].ReconnectTime:=ini.ReadInteger('OmronFB2',s+'_ReconnectTime',5000);
      OmronFB2_list[i].ReadTimeout:=ini.ReadInteger('OmronFB2',s+'_ReadTimeout',1000);
      OmronFB2_list[i].EchoTime:=ini.ReadInteger('OmronFB2',s+'_EchoTime',1000);
      if Assigned(FOmronFB2_OnShortStat) then FOmronFB2_OnShortStat(OmronFB2_list[i],'Не активен');
    end;
  end;
  // OmronFB2 end

  // HandScaner begin
  HandScaner_freeList;
  s:=ini.ReadString('HandScaner','list','');
  if s<>'' then begin
    sl:=Explode('|',s);
    n:=sl.Count;
    SetLength(HandScaner_list,n);
    dec(n);
    for I := 0 to n do begin
      s:=sl[i];
      HandScaner_list[i]:=THandScaner.Create;
      HandScaner_list[i].Name:=s;
      HandScaner_list[i].ComPort.Port:=ini.ReadString('HandScaner',s+'_Port','COM1');
      HandScaner_list[i].ComPort.BaudRate:=ini.ReadInteger('HandScaner',s+'_BaudRate',9600);
      HandScaner_list[i].ComPort.FlowControl:=ini.ReadInteger('HandScaner',s+'_FlowControl',0);
      HandScaner_list[i].ComPort.Parity:=ini.ReadInteger('HandScaner',s+'_Parity',0);
      HandScaner_list[i].ComPort.StopBits:=ini.ReadInteger('HandScaner',s+'_StopBits',0);
      HandScaner_list[i].ComPort.DataBits:=ini.ReadInteger('HandScaner',s+'_DataBits',8);
      HandScaner_list[i].ReconnectTime:=ini.ReadInteger('HandScaner',s+'_ReconnectTime',5000);
      HandScaner_list[i].OnConnectionStatus:=ConnectionStatus;
      HandScaner_list[i].OnData:=HandScaner_Data;
      if Assigned(FHandScaner_OnShortStat) then
        FHandScaner_OnShortStat(HandScaner_list[i],'Не активен');
    end;
  end;
  // HandScaner end


  // SATOPrinter begin
  SATOPrinter_freeList;
  s:=ini.ReadString('SATOPrinter','list','');
  if s<>'' then begin
    sl:=Explode('|',s);
    n:=sl.Count;
    SetLength(SATOPrinter_list,n);
    dec(n);
    for I := 0 to n do begin
      s:=sl[i];
      SATOPrinter_list[i]:=TSATOPrinter.Create;
      SATOPrinter_list[i].Name:=s;
      SATOPrinter_list[i].OnConnectionStatus:=ConnectionStatus;
      SATOPrinter_list[i].OnPrinterStatus:=SATOPrinter_State;
      SATOPrinter_list[i].IP:=ini.ReadString('SATOPrinter',s+'_IP','192.168.1.2');
      SATOPrinter_list[i].Port1:=ini.ReadInteger('SATOPrinter',s+'_Port1',1024);
      SATOPrinter_list[i].Port2:=ini.ReadInteger('SATOPrinter',s+'_Port2',1025);
      SATOPrinter_list[i].Port3:=ini.ReadInteger('SATOPrinter',s+'_Port3',9100);
      SATOPrinter_list[i].ConnectTimeout:=ini.ReadInteger('SATOPrinter',s+'_ConnectTimeout',1000);
      SATOPrinter_list[i].ReconnectTime:=ini.ReadInteger('SATOPrinter',s+'_ReconnectTime',5000);
      SATOPrinter_list[i].ReadTimeout:=ini.ReadInteger('SATOPrinter',s+'_ReadTimeout',1000);
      SATOPrinter_list[i].StatusInterval:=ini.ReadInteger('SATOPrinter',s+'_StatusInterval',1000);
      SATOPrinter_list[i].Mode:=ini.ReadBool('SATOPrinter',s+'_Mode',false);
      SATOPrinter_list[i].Template:=ini.ReadString('SATOPrinter',s+'_Template','');
      if Assigned(FSATOPrinter_OnShortStat) then
        FSATOPrinter_OnShortStat(SATOPrinter_list[i],'Не активен');
    end;
  end;
  // SATOPrinter end

  ini.Free;
end;

procedure TScheme.OmronFB2_activate(AName: String);
var
  cm: TOmronFB2;
  i,n: integer;
begin
  if AName='' then begin
    n:=Length(OmronFB2_list)-1;
    for I := 0 to n do begin
      OmronFB2_list[i].Active:=true;
      if Assigned(FOmronFB2_OnShortStat) then FOmronFB2_OnShortStat(OmronFB2_list[i],'Отключен');
    end;
  end else begin
    cm:=OmronFB2_get(AName);
    if cm<>nil then begin
      cm.Active:=true;
      if Assigned(FOmronFB2_OnShortStat) then FOmronFB2_OnShortStat(cm,'Отключен');
    end;
  end;
end;

procedure TScheme.OmronFB2_add(AName: String);
var
  n: integer;
  ini: TIniFile;
begin
  ini:=TIniFile.Create(FConfigFile);
  n:=Length(OmronFB2_list);
  SetLength(OmronFB2_list,n+1);
  OmronFB2_list[n]:=TOmronFB2.Create;
  OmronFB2_list[n].Name:=AName;
  OmronFB2_list[n].OnMeasurementValue:=OmronFB2_Measurement;
  OmronFB2_list[n].OnConnectionStatus:=ConnectionStatus;
  OmronFB2_list[n].Addr:='192.168.1.2';
  OmronFB2_list[n].Port:=9876;
  OmronFB2_list[n].ConnectTimeout:=1000;
  OmronFB2_list[n].ReconnectTime:=5000;
  OmronFB2_list[n].ReadTimeout:=1000;
  OmronFB2_list[n].EchoTime:=1000;
  ini.WriteString('OmronFB2',AName+'_IP',OmronFB2_list[n].Addr);
  ini.WriteInteger('OmronFB2',AName+'_Port',OmronFB2_list[n].Port);
  ini.WriteInteger('OmronFB2',AName+'_ConnectTimeout',OmronFB2_list[n].ConnectTimeout);
  ini.WriteInteger('OmronFB2',AName+'_ReconnectTime',OmronFB2_list[n].ReconnectTime);
  ini.WriteInteger('OmronFB2',AName+'_ReadTimeout',OmronFB2_list[n].ReadTimeout);
  ini.WriteInteger('OmronFB2',AName+'_EchoTime',OmronFB2_list[n].EchoTime);
  if Assigned(FOmronFB2_OnShortStat) then FOmronFB2_OnShortStat(OmronFB2_list[n],'Не активен');
  ini.Free;
  OmronFB2_upList;
end;

procedure TScheme.OmronFB2_deactivate(AName: String);
var
  cm: TOmronFB2;
  i,n: integer;
begin
  if AName='' then begin
    n:=Length(OmronFB2_list)-1;
    for I := 0 to n do begin
      OmronFB2_list[i].Active:=false;
      if Assigned(FOmronFB2_OnShortStat) then FOmronFB2_OnShortStat(OmronFB2_list[i],'Не активен');
    end;
  end else begin
    cm:=OmronFB2_get(AName);
    if cm<>nil then begin
      cm.Active:=false;
      if Assigned(FOmronFB2_OnShortStat) then FOmronFB2_OnShortStat(cm,'Не активен');
    end;
  end;
end;

function TScheme.OmronFB2_delete(AName: String): boolean;
var
  n,i,m: integer;
begin
  result:=false;
  n:=Length(OmronFB2_list)-1;
  m:=-1;
  for I := 0 to n do
    if OmronFB2_list[i].Name=AName then begin
      m:=i;
      break;
    end;
  if m=-1 then exit;
  OmronFB2_list[m].OnConnectionStatus:=nil;
  OmronFB2_list[m].OnMeasurementValue:=nil;
  OmronFB2_list[m].Active:=false;
  OmronFB2_list[m].Free;
  for I := m to n-1 do OmronFB2_list[i]:=OmronFB2_list[i+1];
  SetLength(OmronFB2_list,n);
  OmronFB2_upList;
  result:=true;
end;

procedure TScheme.OmronFB2_freeList;
var
  i,n: Integer;
begin
  n:=Length(OmronFB2_list)-1;
  for I := 0 to n do begin
    OmronFB2_list[i].Active:=false;
    OmronFB2_list[i].Free;
    SchemeWaitForm.Progress;
  end;
  SetLength(OmronFB2_list,0);
end;

function TScheme.OmronFB2_get(AName: String): TOmronFB2;
var
  n,i: integer;
begin
  Result:=nil;
  n:=Length(OmronFB2_list)-1;
  for I := 0 to n do
    if OmronFB2_list[i].Name=AName then begin
      FGetIndex:=i;
      Result:=OmronFB2_list[i];
      break;
    end;
end;

procedure TScheme.OmronFB2_Measurement(Sender: TObject; AValue: String);
begin
  if Assigned(FOmronFB2_OnMeasurementValue) then FOmronFB2_OnMeasurementValue(TSchemeItem(Sender),AValue);
end;

function TScheme.OmronFB2_showSets(AName: String): boolean;
var
  cm: TOmronFB2;
  ini: TIniFile;
  b: boolean;
begin
  result:=false;
  cm:=OmronFB2_get(AName);
  if cm<>nil then
    if OmronFB2SetsForm.Execute(cm,FGetIndex,Self) then begin
      b:=cm.Active;
      cm.Active:=false;
      ini:=TIniFile.Create(FConfigFile);
      result:=AName<>cm.Name;
      ini.WriteString('OmronFB2',cm.Name+'_IP',cm.Addr);
      ini.WriteInteger('OmronFB2',cm.Name+'_Port',cm.Port);
      ini.WriteInteger('OmronFB2',cm.Name+'_ConnectTimeout',cm.ConnectTimeout);
      ini.WriteInteger('OmronFB2',cm.Name+'_ReconnectTime',cm.ReconnectTime);
      ini.WriteInteger('OmronFB2',cm.Name+'_ReadTimeout',cm.ReadTimeout);
      ini.WriteInteger('OmronFB2',cm.Name+'_EchoTime',cm.EchoTime);
      ini.Free;
      if result then OmronFB2_upList;
      cm.Active:=b;
    end;
end;

procedure TScheme.OmronFB2_upList;
var
  ini: TIniFile;
  s: String;
  n,i: integer;
begin
  ini:=TIniFile.Create(FConfigFile);
  s:='';
  n:=Length(OmronFB2_list)-1;
  if n>-1 then begin
    for I := 0 to n do s:=s+OmronFB2_list[i].Name+'|';
    s:=Copy(s,1,Length(s)-1);
  end;
  ini.WriteString('OmronFB2','list',s);
  ini.Free;
end;

procedure TScheme.SATOPrinterTagData_(Sender: TObject; APrinter: TSATOPrinter;
  ATemplateName, ATagName: String; APageNum: integer; var AValue: Variant);
begin
  if assigned(FSATOPrinter_OnTagData) then
    FSATOPrinter_OnTagData(Self, APrinter, ATemplateName, ATagName, APageNum, AValue);
end;

procedure TScheme.SATOPrinter_activate(AName: String);
var
  cm: TSATOPrinter;
  i,n: integer;
begin
  if AName='' then begin
    n:=Length(SATOPrinter_list)-1;
    for I := 0 to n do begin
      SATOPrinter_list[i].Active:=true;
      if Assigned(FSATOPrinter_OnShortStat) then FSATOPrinter_OnShortStat(SATOPrinter_list[i],'Отключен');
    end;
  end else begin
    cm:=SATOPrinter_get(AName);
    if cm<>nil then begin
      cm.Active:=true;
      if Assigned(FSATOPrinter_OnShortStat) then FSATOPrinter_OnShortStat(cm,'Отключен');
    end;
  end;
end;

procedure TScheme.SATOPrinter_add(AName: String);
var
  n: integer;
  ini: TIniFile;
begin
  ini:=TIniFile.Create(FConfigFile);
  n:=Length(SATOPrinter_list);
  SetLength(SATOPrinter_list,n+1);
  SATOPrinter_list[n]:=TSATOPrinter.Create;
  SATOPrinter_list[n].Name:=AName;
  SATOPrinter_list[n].OnConnectionStatus:=ConnectionStatus;
  SATOPrinter_list[n].OnPrinterStatus:=SATOPrinter_State;
  SATOPrinter_list[n].IP:='192.168.1.2';
  SATOPrinter_list[n].Port1:=1024;
  SATOPrinter_list[n].Port2:=1025;
  SATOPrinter_list[n].Port3:=9100;
  SATOPrinter_list[n].Mode:=false;
  SATOPrinter_list[n].ConnectTimeout:=1000;
  SATOPrinter_list[n].ReconnectTime:=5000;
  SATOPrinter_list[n].ReadTimeout:=1000;
  SATOPrinter_list[n].StatusInterval:=1000;
  SATOPrinter_list[n].Template:='';
  ini.WriteString('SATOPrinter',AName+'_IP',SATOPrinter_list[n].IP);
  ini.WriteInteger('SATOPrinter',AName+'_Port1',SATOPrinter_list[n].Port1);
  ini.WriteInteger('SATOPrinter',AName+'_Port2',SATOPrinter_list[n].Port2);
  ini.WriteInteger('SATOPrinter',AName+'_Port3',SATOPrinter_list[n].Port3);
  ini.WriteInteger('SATOPrinter',AName+'_ConnectTimeout',SATOPrinter_list[n].ConnectTimeout);
  ini.WriteInteger('SATOPrinter',AName+'_ReconnectTime',SATOPrinter_list[n].ReconnectTime);
  ini.WriteInteger('SATOPrinter',AName+'_ReadTimeout',SATOPrinter_list[n].ReadTimeout);
  ini.WriteInteger('SATOPrinter',AName+'_StatusInterval',SATOPrinter_list[n].StatusInterval);
  ini.WriteBool('SATOPrinter',AName+'_Mode',SATOPrinter_list[n].Mode);
  ini.WriteString('SATOPrinter',AName+'_Template',SATOPrinter_list[n].Template);
  if Assigned(FSATOPrinter_OnShortStat) then
    FSATOPrinter_OnShortStat(SATOPrinter_list[n],'Не активен');
  ini.Free;
  SATOPrinter_upList;
end;

procedure TScheme.SATOPrinter_deactivate(AName: String);
var
  cm: TSATOPrinter;
  i,n: integer;
begin
  if AName='' then begin
    n:=Length(SATOPrinter_list)-1;
    for I := 0 to n do begin
      SATOPrinter_list[i].Active:=false;
      if Assigned(FSATOPrinter_OnShortStat) then FSATOPrinter_OnShortStat(SATOPrinter_list[i],'Не активен');
    end;
  end else begin
    cm:=SATOPrinter_get(AName);
    if cm<>nil then begin
      cm.Active:=false;
      if Assigned(FSATOPrinter_OnShortStat) then FSATOPrinter_OnShortStat(cm,'Не активен');
    end;
  end;
end;

function TScheme.SATOPrinter_delete(AName: String): boolean;
var
  n,i,m: integer;
begin
  result:=false;
  n:=Length(SATOPrinter_list)-1;
  m:=-1;
  for I := 0 to n do
    if SATOPrinter_list[i].Name=AName then begin
      m:=i;
      break;
    end;
  if m=-1 then exit;
  SATOPrinter_list[m].OnConnectionStatus:=nil;
  SATOPrinter_list[m].OnPrinterStatus:=nil;
  SATOPrinter_list[m].Active:=false;
  SATOPrinter_list[m].Free;
  for I := m to n-1 do SATOPrinter_list[i]:=SATOPrinter_list[i+1];
  SetLength(SATOPrinter_list,n);
  SATOPrinter_upList;
  result:=true;
end;

procedure TScheme.SATOPrinter_freeList;
var
  i,n: Integer;
begin
  n:=Length(SATOPrinter_list)-1;
  for I := 0 to n do begin
    SATOPrinter_list[i].Active:=false;
    SATOPrinter_list[i].Free;
    SchemeWaitForm.Progress;
  end;
  SetLength(SATOPrinter_list,0);
end;

function TScheme.SATOPrinter_get(AName: String): TSATOPrinter;
var
  n,i: integer;
begin
  Result:=nil;
  n:=Length(SATOPrinter_list)-1;
  for I := 0 to n do
    if SATOPrinter_list[i].Name=AName then begin
      FGetIndex:=i;
      Result:=SATOPrinter_list[i];
      break;
    end;
end;

procedure TScheme.SATOPrinter_print(APrinterName, ATemplae: String; ACount: integer);
var
  printing: TSATOPtinting;
  mark: TMark;
begin

  mark:=TMark.Create;
  mark.FileName:=ATemplae;
  mark.load;

  printing:=TSATOPtinting.Create;
  printing.printer:=SATOPrinter_get(APrinterName);
  printing.onTagData:=SATOPrinterTagData_;
  printing.start(Mark,ACount);
  sleep(1000);
  printing.Free;
  mark.Free;

end;

function TScheme.SATOPrinter_showSets(AName: String): boolean;
var
  cm: TSATOPrinter;
  ini: TIniFile;
  b: boolean;
begin
  result:=false;
  cm:=SATOPrinter_get(AName);
  if cm<>nil then
    if SATOPrinterSetsForm.Execute(cm,FGetIndex,Self) then begin
      b:=cm.Active;
      cm.Active:=false;
      ini:=TIniFile.Create(FConfigFile);
      result:=AName<>cm.Name;
      ini.WriteString('SATOPrinter',cm.Name+'_IP',cm.IP);
      ini.WriteInteger('SATOPrinter',cm.Name+'_Port1',cm.Port1);
      ini.WriteInteger('SATOPrinter',cm.Name+'_Port2',cm.Port2);
      ini.WriteInteger('SATOPrinter',cm.Name+'_Port3',cm.Port3);
      ini.WriteInteger('SATOPrinter',cm.Name+'_ConnectTimeout',cm.ConnectTimeout);
      ini.WriteInteger('SATOPrinter',cm.Name+'_ReconnectTime',cm.ReconnectTime);
      ini.WriteInteger('SATOPrinter',cm.Name+'_ReadTimeout',cm.ReadTimeout);
      ini.WriteInteger('SATOPrinter',cm.Name+'_StatusInterval',cm.StatusInterval);
      ini.WriteBool('SATOPrinter',cm.Name+'_Mode)',cm.Mode);
      ini.WriteString('SATOPrinter',cm.Name+'_Template',cm.Template);
      ini.Free;
      if result then SATOPrinter_upList;
      cm.Active:=b;
    end;
end;

procedure TScheme.SATOPrinter_state(Sender: TObject);
var s: string;
begin
  if not Assigned(FSATOPrinter_OnShortStat) then exit;
  case TSATOPrinter(Sender).PrinterStatus.PS of
  0: s:='Ожидание';
  1: s:='Ожидание выдачи';
  2: s:='Анализ';
  3: s:='Печать';
  4: s:='Не в сети';
  5: s:='Ошибка'
  else exit;
  end;
  FSATOPrinter_OnShortStat(TSchemeItem(Sender),s);
end;

procedure TScheme.SATOPrinter_upList;
var
  ini: TIniFile;
  s: String;
  n,i: integer;
begin
  ini:=TIniFile.Create(FConfigFile);
  s:='';
  n:=Length(SATOPrinter_list)-1;
  if n>-1 then begin
    for I := 0 to n do s:=s+SATOPrinter_list[i].Name+'|';
    s:=Copy(s,1,Length(s)-1);
  end;
  ini.WriteString('SATOPrinter','list',s);
  ini.Free;
end;

end.
