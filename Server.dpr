program Server;

uses
  System.StartUpCopy,
  uTInject.ConfigCEF,
  FMX.Forms,
  UServer in 'Fontes\UServer.pas' {FServer},
  UWhats in 'Servicos\UWhats.pas' {Servico_Whats: TDataModule},
  Generics.Base64 in 'Classes\Generics.Base64.pas',
  UWhats.account in 'Servicos\UWhats.account.pas',
  UWhats.files in 'Servicos\UWhats.files.pas',
  UWhats.base64 in 'Servicos\UWhats.base64.pas',
  UWhats.qrcode in 'Servicos\UWhats.qrcode.pas',
  UWhats.mensagens in 'Servicos\UWhats.mensagens.pas',
  UWhats.functions in 'Servicos\UWhats.functions.pas',
  UController.Api.Send in 'Servicos\UController.Api.Send.pas',
  UController.Comum in 'Servicos\UController.Comum.pas',
  UDao.Api.Send in 'Dao\UDao.Api.Send.pas',
  UWhats.status in 'Servicos\UWhats.status.pas',
  UController.Api.Status in 'Servicos\UController.Api.Status.pas',
  UDao.Api.Status in 'Dao\UDao.Api.Status.pas',
  UController.Api.Auth in 'Servicos\UController.Api.Auth.pas',
  UDao.Api.Auth in 'Dao\UDao.Api.Auth.pas',
  UController.Api.SendFile in 'Servicos\UController.Api.SendFile.pas',
  UDao.Api.SendFiles in 'Dao\UDao.Api.SendFiles.pas';

{$R *.res}

begin
 If not GlobalCEFApp.StartMainProcess then
    Exit;
  Application.Initialize;
  Application.CreateForm(TFServer, FServer);
  Application.CreateForm(TServico_Whats, Servico_Whats);
  Application.Run;
end.
