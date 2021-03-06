unit UController.Api.Send;

     interface
uses System.JSON,
     System.Classes,
     System.SysUtils,
     ServerUtils,
     uDWConsts,
     uDWJSONObject,
     UController.Comum;

procedure RegistrarRotas;

procedure Send(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);


procedure RotasSend(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);

implementation

uses
  UServer, UDao.Api.Send;



procedure RegistrarRotas;
begin
    FServer.RESTDWWhats.AddUrl('send', [crGet, crPost], RotasSend, true);
end;

procedure RotasSend(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);
begin
    case RequestType of
        rtGet: Send(Sender, RequestHeader, Params, ContentType, Result,
                            RequestType, StatusCode, ErrorMessage, OutCustomHeader);

        rtPost: Send(Sender, RequestHeader, Params, ContentType, Result,
                               RequestType, StatusCode, ErrorMessage, OutCustomHeader);
    end;
end;

procedure Send(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);
var
    SSend: TSendApi;
    pmsg,panexo,ptelefone: string;
    Erro,Retorno: string;
    body : System.JSON.TJsonValue;
begin
  SSend := TSendApi.Create();
  try
    try
          try
          body                 := ParseBody(Params.RawBody.AsString);
          SSend.Telefone       := body.GetValue<string>('telefone', '');
          SSend.mensagem       := body.GetValue<string>('mensagen', '');
          finally
          FreeAndNil(body);
          end;
      Retorno := SSend.Send(Erro,SSend.telefone, SSend.Mensagem);
      Result := Retorno;
      except
      on ex: exception do
      begin
        Result := CreateJsonObjStr('erro', ex.Message);
        StatusCode := 500;
      end;
    end;
  finally
    FreeAndNil(SSend);
  end;
end;



end.
