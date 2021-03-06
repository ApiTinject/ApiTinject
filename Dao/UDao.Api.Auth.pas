unit UDao.Api.Auth;


interface
uses System.SysUtils,
           System.JSON,

     System.StrUtils,
     DataSet.Serialize, FireDAC.Comp.Client,UWhats.account,UController.Comum;

  type
  TAuthApi = class
  private

  public
    constructor Create();
    destructor destroy; override;
    function Auth(out erro: string): string;


  end;
implementation

{ TChamadosApi }

uses UServer;



{ TStatusApi }

constructor TAuthApi.Create;
begin

end;

destructor TAuthApi.destroy;
begin

  inherited;
end;


function TAuthApi.Auth(out erro: string): string;
var
 pRetornoJson : TJsonObject;
begin
    pRetornoJson := nil;
    pRetornoJson := TJsonObject.Create;
   try

      if FServer.whats.Conectado = true then
        begin
      pRetornoJson.AddPair('Conectado', 'OK');
      pRetornoJson.AddPair('Telefone conectado', FServer.whats.Status.MyNumero);
        end
        else
        begin
      pRetornoJson.AddPair('Conectado', 'N?o');
      pRetornoJson.AddPair('QrCode', FServer.whats.QrCode.Base64);
        end;
      Result := pRetornoJson.ToString;
  finally
  if (pRetornoJson <> nil) then
     FreeAndNil(pRetornoJson);
end;

end;



end.


