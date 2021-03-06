unit UDao.Api.Status;


interface
uses System.SysUtils,
           System.JSON,

     System.StrUtils,
     DataSet.Serialize, FireDAC.Comp.Client,UWhats.account,UController.Comum;

  type
  TStatusApi = class
  private
    FConexao: TFDConnection;
    FStatus: string;
    FTelefone: string;
    FBateria: integer;
    procedure SetBateria(const Value: integer);
    procedure SetStatus(const Value: string);
    procedure SetTelefone(const Value: string);

  public
    constructor Create();
    destructor destroy; override;
    property pTelefone: string read FTelefone write SetTelefone;
    property pStatus: string read FStatus write SetStatus;
    property pBateria: integer read FBateria write SetBateria;
    function Status(out erro: string): string;


  end;
implementation

{ TChamadosApi }

uses UServer;



{ TStatusApi }

constructor TStatusApi.Create;
begin

end;

destructor TStatusApi.destroy;
begin

  inherited;
end;

procedure TStatusApi.SetBateria(const Value: integer);
begin
  FBateria := Value;
end;

procedure TStatusApi.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

procedure TStatusApi.SetTelefone(const Value: string);
begin
  FTelefone := Value;
end;

function TStatusApi.Status(out erro: string): string;
var
 pRetornoJson : TJsonObject;
begin
    pRetornoJson := nil;
    pRetornoJson := TJsonObject.Create;
   try

      FServer.whats.GetBateria;

      if FServer.whats.Conectado then
         begin
      pRetornoJson.AddPair('Status', FServer.whats.Status.Status);
      pRetornoJson.AddPair('Bateria',  FServer.whats.Status.Bateria.ToString);
      pRetornoJson.AddPair('Telefone conectado', FServer.whats.Status.MyNumero);
        end
         else
         begin
      pRetornoJson.AddPair('Status', 'Sem conex?o');
         end;

      Result := pRetornoJson.ToString;
  finally
  if (pRetornoJson <> nil) then
     FreeAndNil(pRetornoJson);

  //    Result := '{"RESULT":200, "IDLIST":[1,2,3,4,5]}';
end;

end;

end.

