unit UController.Api.SendFile;

     interface
uses System.JSON,
     System.Classes,
     System.SysUtils,
     ServerUtils,
     uDWConsts,
     uDWJSONObject,
     UController.Comum;

procedure RegistrarRotas;

procedure SendFile(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);


procedure RotasSendFile(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);

implementation

uses
  UServer, UDao.Api.SendFiles;



procedure RegistrarRotas;
begin
    FServer.RESTDWWhats.AddUrl('sendFile', [crGet, crPost], RotasSendFile, true);
end;

procedure RotasSendFile(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);
begin
    case RequestType of
        rtGet: SendFile(Sender, RequestHeader, Params, ContentType, Result,
                            RequestType, StatusCode, ErrorMessage, OutCustomHeader);

        rtPost: SendFile(Sender, RequestHeader, Params, ContentType, Result,
                               RequestType, StatusCode, ErrorMessage, OutCustomHeader);
    end;
end;

procedure SendFile(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);
var
    SFiles: TSendFilesApi;
    pmsg,panexo,ptelefone: string;
    Erro,Retorno: string;
    body : System.JSON.TJsonValue;

begin
 SFiles := TSendFilesApi.Create();
  try
    try


          body                  := ParseBody(Params.RawBody.AsString);
          SFiles.Telefone       := body.GetValue<string>('telefone', '');
          SFiles.mensagem       := body.GetValue<string>('mensagen', '');
          SFiles.anexo          := body.GetValue<string>('anexo', '');
          FreeAndNil(body);
      Retorno := SFiles.SendFile(Erro,SFiles.telefone, SFiles.Mensagem, SFiles.Anexo);
      Result := Retorno;
      except
      on ex: exception do
      begin
        Result := CreateJsonObjStr('erro', ex.Message);
        StatusCode := 500;
      end;
    end;
  finally
    FreeAndNil(SFiles);
  end;
end;



end.
