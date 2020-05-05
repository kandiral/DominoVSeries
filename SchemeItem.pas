unit SchemeItem;

interface

uses MMSystem;

type
  TSchemeItem = class;

  TSchemeDeviceConnStat = (sdstNotActive, sdstDisconnected, sdstConnecting, sdstWaitReconnecting, sdstConnected);
  TSchemeDeviceConnStatEv = procedure(Sender: TObject; AStatus: TSchemeDeviceConnStat;
    AReconnectTime: Cardinal)of object;

  TShortStat = procedure(ASender: TSchemeItem; AStat: String) of object;

  TSchemeItem = class
  private
    FName: String;
  protected
    function GetReconnectTime: cardinal;virtual;
  public
    property Name: String read FName write FName;
    function calcReconnectTime(tm: Cardinal): cardinal;
  end;

  function isValidName(AName: String): boolean;

implementation

function isValidName(AName: String): boolean;
const
  Alpha = ['A'..'Z', 'a'..'z', '_'];
  AlphaNumeric = Alpha + ['0'..'9'];

  function IsValidChar(AIndex: Integer; AChar: Char): Boolean;
  begin
    if AIndex = 1 then
      Result := AChar in Alpha
    else
      Result := AChar in AlphaNumeric;
  end;

var
  i: Integer;
begin
  Result := true;
  for i := 1 to Length(AName) do
    if not IsValidChar(i, AName[i]) then begin
      result:=false;
      exit;
    end;
end;


{ TSchemeItem }


function TSchemeItem.calcReconnectTime(tm: Cardinal): cardinal;
begin
  Result:=getReconnectTime-tm;
end;

function TSchemeItem.GetReconnectTime: cardinal;
begin

end;

end.
