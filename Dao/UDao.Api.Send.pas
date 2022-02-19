unit UDao.Api.Send;

interface
uses System.SysUtils,
           System.JSON,

     System.StrUtils,
     DataSet.Serialize, FireDAC.Comp.Client,UWhats.account,UController.Comum,
  System.Classes, System.Generics.Collections;

  type
  TSendApi = class
  private
    FConexao: TFDConnection;
    FChamado: Integer;
    FTelefone: string;
    FMensagem: string;
    procedure SetTelefone(const Value: string);
    procedure SetMensagem(const Value: string);

  public
    constructor Create();
    destructor destroy; override;
    property Telefone: string read FTelefone write SetTelefone;
    property Mensagem: string read FMensagem write SetMensagem;
    function Send(out erro: string;pTelefone,pMsg: string): string;
    function Gerar(ptipo,ptelefone,pMsg: string):string;


  end;
implementation

{ TChamadosApi }

uses UServer, Winapi.Windows;

constructor TSendApi.Create();
begin

end;

destructor TSendApi.destroy;
begin
  inherited;
end;



function TSendApi.Gerar(ptipo,ptelefone,pMsg: string): string;
var
  i: Integer;
  JSONServico: TJSONArray;
  Send, info: TJSONObject;
begin
  JSONServico := TJSONArray.Create;
  try
      Send := TJSONObject.Create;
      JSONServico.AddElement(Send);
      Send.AddPair('pagina', '1');
      Send.AddPair('total_de_paginas', '1');
      Send.AddPair('registros', '1');
      Send.AddPair('total_de_registros', '1');
      info := TJSONObject.Create;
      Send.AddPair('Info', info);
      if ptipo ='S' then
      info.AddPair('status','ok')
      else
      info.AddPair('status','Erro');
      info.AddPair('mensagen',pMsg);
      info.AddPair('Enviado para o numero',ptelefone);
      result := send.ToString;
  finally
    JSONServico.Free;
  end;

end;

function TSendApi.Send(out erro: string; ptelefone,pMsg: string): string;
begin
  try

    if FServer.whats.Conectado then
    begin
      FServer.whats.SendMessage('123', pTelefone, pMsg);
      Result := Gerar('S',pTelefone,pMsg);
    end
    else
    begin
      Result := Gerar('N',pTelefone,pMsg);
     end;

  finally

  end;

end;



procedure TSendApi.SetMensagem(const Value: string);
begin
  FMensagem := Value;
end;

procedure TSendApi.SetTelefone(const Value: string);
begin
  FTelefone := Value;
end;

end.
