unit UController.Api.Auth;

     interface
uses System.JSON,
     System.Classes,
     System.SysUtils,
     ServerUtils,
     uDWConsts,
     uDWJSONObject,
     UController.Comum;

procedure RegistrarRotas;

procedure Auth(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);


procedure RotasAuth(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);

implementation

uses
  UServer, UDao.Api.Auth;



procedure RegistrarRotas;
begin
    FServer.RESTDWWhats.AddUrl('auth', [crGet, crPost], RotasAuth, true);
end;

procedure RotasAuth(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);
begin
    case RequestType of
        rtGet: Auth(Sender, RequestHeader, Params, ContentType, Result,
                            RequestType, StatusCode, ErrorMessage, OutCustomHeader);

        rtPost: Auth(Sender, RequestHeader, Params, ContentType, Result,
                               RequestType, StatusCode, ErrorMessage, OutCustomHeader);
    end;
end;

procedure Auth(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);
var
    Chamados: TAuthApi;
    pmsg: string;
    Erro,Retorno: string;

begin
  try
    try
      Chamados := TAuthApi.Create();
      Retorno := Chamados.auth(Erro);
      Result := Retorno;
      except
      on ex: exception do
      begin
        Result := CreateJsonObjStr('erro', ex.Message);
        StatusCode := 500;
      end;
    end;
  finally
    FreeAndNil(Chamados);
  end;
end;



end.


