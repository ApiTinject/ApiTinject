unit UController.Api.Status;

     interface
uses System.JSON,
     System.Classes,
     System.SysUtils,
     ServerUtils,
     uDWConsts,
     uDWJSONObject,
     UController.Comum;

procedure RegistrarRotas;

procedure Status(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);


procedure RotasStatus(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);

implementation

uses
  UServer, UDao.Api.Status;



procedure RegistrarRotas;
begin
    FServer.RESTDWWhats.AddUrl('status', [crGet, crPost], RotasStatus, true);
end;

procedure RotasStatus(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);
begin
    case RequestType of
        rtGet: Status(Sender, RequestHeader, Params, ContentType, Result,
                            RequestType, StatusCode, ErrorMessage, OutCustomHeader);

        rtPost: Status(Sender, RequestHeader, Params, ContentType, Result,
                               RequestType, StatusCode, ErrorMessage, OutCustomHeader);
    end;
end;

procedure Status(Sender: TObject; RequestHeader: TStringList;
                     Const Params: TDWParams; Var ContentType: String;
                     Var Result: String; Const RequestType: TRequestType;
                     Var StatusCode: Integer; Var ErrorMessage: String;
                     Var OutCustomHeader : TStringList);
var
    Chamados: TStatusApi;
    pmsg: string;
    jsonArray: TJSONArray;
    Erro,Retorno: string;

begin
  try
    try
      Chamados := TStatusApi.Create();

     // jsonArray := Chamados.Send(Erro,Chamados.telefone, pmsg);
      Retorno := Chamados.Status(Erro);
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

