unit UWhats;

interface

uses
   System.SysUtils, System.Classes, uTInject,
    //units adicionais obrigatórias
   uTInject.ConfigCEF,            uTInject.Constant,    uTInject.JS,
   uTInject.Console,   uTInject.Diversos,   uTInject.AdjustNumber,  uTInject.Config,uTInject.Classes;

type
    TServico_Whats = class(TDataModule)
        Inject: TInject;
    procedure InjectGetStatus(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Servico_Whats: TServico_Whats;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses UServer, Generics.Base64;

{$R *.dfm}

procedure TServico_Whats.InjectGetStatus(Sender: TObject);
begin
   case TInject(Sender).status of
    Server_ConnectedDown       : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Server_Disconnected        : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Server_Disconnecting       : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Server_Connected           : FServer.lblDados.Text := '';
    Server_Connecting          : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Inject_Initializing        : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Inject_Initialized         : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Server_ConnectingNoPhone   : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Server_ConnectingReaderCode: FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Server_TimeOut             : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Inject_Destroying          : FServer.lblDados.Text := TInject(Sender).StatusToStr;
    Inject_Destroy             : FServer.lblDados.Text:= TInject(Sender).StatusToStr;
   end;


 If TInject(Sender).Status in [Server_ConnectingNoPhone, Server_TimeOut] Then
  Begin
    if TInject(Sender).FormQrCodeType = Ft_Desktop then
    Begin
       if TInject(Sender).Status = Server_ConnectingNoPhone then
          Inject.FormQrCodeStop;
    end else
    Begin
      if TInject(Sender).Status = Server_ConnectingNoPhone then
      Begin
        if not TInject(Sender).FormQrCodeShowing then
           TInject(Sender).FormQrCodeShowing := True;
      end else
      begin
        TInject(Sender).FormQrCodeReloader;
      end;
    end;

  End;
end;

end.
