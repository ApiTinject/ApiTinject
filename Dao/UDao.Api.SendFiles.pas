unit UDao.Api.SendFiles;

interface
uses System.SysUtils,
           System.JSON,

     System.StrUtils,
     DataSet.Serialize, FireDAC.Comp.Client,UWhats.account,UController.Comum;

  type
  TSendFilesApi = class
  private
    FConexao: TFDConnection;
    FChamado: Integer;
    FTelefone: string;
    FMensagem: string;
    FAnexo: string;
    procedure SetTelefone(const Value: string);
    procedure SetMensagem(const Value: string);
    procedure SetAnexo(const Value: string);

  public
    constructor Create();
    destructor destroy; override;
    property Telefone: string read FTelefone write SetTelefone;
    property Mensagem: string read FMensagem write SetMensagem;
    property Anexo: string read FAnexo write SetAnexo;
    function SendFile(out erro: string;pTelefone,pMsg,pAnexo: string): string;


  end;
implementation

{ TChamadosApi }

uses UServer;

constructor TSendFilesApi.Create();
begin

end;

destructor TSendFilesApi.destroy;
begin
  inherited;
end;



function TSendFilesApi.SendFile(out erro: string; pTelefone, pMsg,
  pAnexo: string): string;
var
 pRetornoJson : TJsonObject;
begin
    pRetornoJson := nil;
    pRetornoJson := TJsonObject.Create;
   try
    if FServer.whats.Conectado then
 begin
   FServer.whats.SendMessage(
    '123',
    pTelefone,
    pMsg,
    TWFile.new.LoadFromFile(pAnexo)
  );
      pRetornoJson.AddPair('status', 'OK');
      pRetornoJson.AddPair('mensagen', pMsg);
      pRetornoJson.AddPair('arquivo', pAnexo);
      pRetornoJson.AddPair('Enviado para o numero', pTelefone);
   end
   else
   begin
      pRetornoJson.AddPair('status', 'N?o');
      pRetornoJson.AddPair('mensagen', 'Favor aguardar conex?o');
   end;
      Result := pRetornoJson.ToString;
  finally
  if (pRetornoJson <> nil) then
     FreeAndNil(pRetornoJson);
end;
end;

procedure TSendFilesApi.SetAnexo(const Value: string);
begin
  FAnexo := Value;
end;

procedure TSendFilesApi.SetMensagem(const Value: string);
begin
  FMensagem := Value;
end;

procedure TSendFilesApi.SetTelefone(const Value: string);
begin
  FTelefone := Value;
end;

end.
