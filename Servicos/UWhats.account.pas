unit UWhats.account;

interface

uses
  uTInject.ConfigCEF,uTInject,uTInject.Constant,uTInject.JS,uTInject.Console,
  uTInject.Diversos,uTInject.AdjustNumber,uTInject.Config,uTInject.Classes,
  Uwhats.mensagens, Uwhats.qrcode,Uwhats.status, Uwhats.files, Fmx.Graphics;

type
  TWFile = Uwhats.files.TWFile;

  IWhatsAppAccount = interface
    ['{FE9112AA-80D7-4358-95D9-1127E7E6BDB4}']
    function SendMessage(pId : string; pNumber : string; pMessage : string; pQuotedIdMessage : string = '') : IWMessageSendResponse; overload;
    function SendMessage(pId : string; pNumber : string; pMessage : string; pFile : IWFile; pQuotedIdMessage : string = '') : IWMessageSendResponse; overload;
    function SetSecretKey(const Value: string) : IWhatsAppAccount;
    procedure Connect;
    procedure Reload;
    procedure Logof;
  end;

  TWhatsAppAccount = class(TInterfacedObject, IWhatsAppAccount)
  private
    FWhatsApp : tinject;
    FSecretKey: string;
    FConnected: boolean;
    FPhoneNumber: string;
    FID: string;
    FQrCode: TWhatsAppQrCode;

    FPhoneBattery: integer;
    FAuthenticated: boolean;
    FStatus: TWhatsAppStatus;
    procedure SetConnected(const Value: boolean);
    procedure SetPhoneNumber(const Value: string);
    procedure SetID(const Value: string);
    procedure SetQrCode(const Value: TWhatsAppQrCode);
    procedure SetStatus(const Value: TWhatsAppStatus);
    procedure SetPhoneBattery(const Value: integer);
    procedure SetAuthenticated(const Value: boolean);
  protected
    function Authentication : string; //AUTENTICAÇÃO INTERNA


  public
    //read-only
     procedure WhatsAppOnStatus(Sender: TObject);
    procedure WhatsAppOnBateria(Sender: TObject);
       procedure WhatsAppOnGetMyNumber (Sender: TObject);
    procedure WhatsAppLowBattery(Sender: TObject);
    procedure GetBateria;
    procedure WhatsAppOnQrCodeUpdate(const Sender: TObject;


      const QrCode: TResultQRCodeClass); //gera o QRCODE - BASE64
       procedure WhatsIsConnected(Sender: TObject;
  Connected: Boolean);
    property Authenticated : boolean read FAuthenticated;
    property Conectado : boolean read FConnected;
    property ID : string read FID;
    property PhoneNumber : string read FPhoneNumber;
    property PhoneBattery : integer read FPhoneBattery;
    property SecretKey : string read FSecretKey;
    property QrCode : TWhatsAppQrCode read FQrCode;
    property Status : TWhatsAppStatus read FStatus;

    function SetSecretKey(const Value: string) : IWhatsAppAccount;
    function GetServiceWhatsApp : tinject;

    function SendMessage(pId : string; pNumber : string; pMessage : string; pQuotedIdMessage : string = '') : IWMessageSendResponse; overload;
    function SendMessage(pId : string; pNumber : string; pMessage : string; pFile : IWFile; pQuotedIdMessage : string = '') : IWMessageSendResponse; overload;


    procedure Connect;
    procedure Reload;
    procedure Logof;


    class function New(pSecretKey : string = '') : IWhatsAppAccount;
    constructor Create(pSecretKey : string = '');
    destructor Destroy; override;
  end;

implementation

uses System.SysUtils, System.Classes, uwhats.functions;

{ TWhatsAppAccount }

function TWhatsAppAccount.Authentication: string;
begin
  result := '';
  if (qrcode.status = FWhatsApp.StatusToStr) then
  begin
    result := 'OK';
    exit;
  end;
  if not(FWhatsApp.status = Inject_Initialized) then
  begin
    result := 'WhatsApp desconectado. Autentique-se.';
    exit;
  end;

end;



procedure TWhatsAppAccount.Connect;
begin
  if (FWhatsApp = nil) then
    exit;
  TThread.Synchronize(nil, procedure
  begin
   if not FWhatsApp.Auth(false) then
  Begin
       FWhatsApp.FormQrCodeType := TFormQrCodeType(Ft_none);
       FWhatsApp.FormQrCodeStart;

  End;
if not FWhatsApp.FormQrCodeShowing then
       FWhatsApp.FormQrCodeShowing := True;

  end);

end;

constructor TWhatsAppAccount.Create(pSecretKey : string = '');
begin
  FQrCode := TWhatsAppQrCode.Create;
  FStatus  := TWhatsAppStatus.Create;
  FWhatsApp := TInject.Create(nil);

  //SETA SECRET KEY NO COMPONENTE DO WHATS w4delphi
  SetSecretKey(pSecretKey);

  FWhatsApp.Config.AutoDelay := 30;
  FWhatsApp.Config.SyncContacts := true;
  FWhatsApp.OnLowBattery      := WhatsAppLowBattery;
  FWhatsApp.OnGetMyNumber     := WhatsAppOnGetMyNumber;
  FWhatsApp.OnGetBatteryLevel := WhatsAppOnBateria;
  FWhatsApp.OnGetStatus       := WhatsAppOnStatus;
  FWhatsApp.OnIsConnected     := WhatsIsConnected;
  FWhatsApp.OnGetQrCode       := WhatsAppOnQrCodeUpdate;
end;

destructor TWhatsAppAccount.Destroy;
begin
  if (FrmConsole <> nil) then
  begin
    TThread.Synchronize(nil, procedure
      begin
        if (FrmConsole.Showing) then
          FrmConsole.Close;
        freeAndNil(FrmConsole);
      end);
  end;
  freeAndNil(FWhatsApp);
  freeAndNil(FQrCode);
  freeAndNil(FStatus);

  inherited;
end;

procedure TWhatsAppAccount.GetBateria;
begin
FWhatsApp.GetBatteryStatus;
end;

function TWhatsAppAccount.GetServiceWhatsApp: TInject;
begin
  result := FWhatsApp;
end;

procedure TWhatsAppAccount.Logof;
begin
  if (FWhatsApp = nil) then
    exit;

  FWhatsApp.ShutDown;
end;

class function TWhatsAppAccount.New(pSecretKey: string): IWhatsAppAccount;
begin
  result := TWhatsAppAccount.Create(pSecretKey);
end;

procedure TWhatsAppAccount.Reload;
begin
  if (FWhatsApp = nil) then
    exit;

  FWhatsApp.Logtout;
end;

function TWhatsAppAccount.SendMessage(pId : string; pNumber : string; pMessage : string; pQuotedIdMessage : string = '') : IWMessageSendResponse;
var auth : string;
begin
  result := TWMessageSendResponse.create;
  result.SetSent(false);
  auth:=Authentication;
  if (FConnected = false) then
  begin
    result.setMessage(auth);
    exit;
  end;

  pNumber := trim(OnlyNumbers(pNumber));
  if (pNumber = '') then
  begin
    result.setMessage('Número de telefone não definido.');
    exit;
  end
  else if (trim(pMessage) = '') then
  begin
    result.setMessage('A mensagem para envio não foi definida.');
    exit;
  end;
  if (trim(pId) = '') then //GERA UM ID PARA A MENSAGEM CASO NÃO RECEBER NENHUM
    pId := Random(100000).ToString+ FormatDateTime('yyyymmddhhmmss', now);

  try
    FWhatsApp.Send(pNumber+'@c.us', pMessage, pQuotedIdMessage);
    result.SetSent(true);
  except
    on E : Exception do
      result.SetMessage('Erro de envio: '+ E.Message);
  end;
end;

function TWhatsAppAccount.SendMessage(pId, pNumber, pMessage: string; pFile: IWFile; pQuotedIdMessage: string): IWMessageSendResponse;
var imageBase64, auth : string;
begin
  result := TWMessageSendResponse.create;
  result.SetSent(false);
  if (FConnected = false) then
  begin
    result.setMessage(auth);
    exit;
  end;

  if not (assigned(pFile)) then //SE NÃO RECEBEU NENHUM ARQUIVO, MANDA APENSA A MENSAGEM DE TEXTO
    result := SendMessage(pId, pNumber, pMessage, pQuotedIdMessage);

  pNumber := trim(OnlyNumbers(pNumber));
  if (pNumber = '') then
  begin
    result.setMessage('Número de telefone não definido.');
    exit;
  end
  else if (trim(pMessage) = '') then
  begin
    result.setMessage('A mensagem para envio não foi definida.');
    exit;
  end;
  if (trim(pId) = '') then //GERA UM ID PARA A MENSAGEM CASO NÃO RECEBER NENHUM
    pId := Random(100000).ToString+ FormatDateTime('yyyymmddhhmmss', now);

  try
    FWhatsApp.SendBase64('data:'+pFile.GetMimeType+'/'+pFile.GetExtension+';base64,'+
      pFile.GetBase64,
      pNumber+'@c.us',

      pFile.GetName,

      pMessage

    );
    result.SetSent(true);
  except
    on E : Exception do
      result.SetMessage('Erro de envio: '+ E.Message);
  end;
end;

procedure TWhatsAppAccount.SetAuthenticated(const Value: boolean);
begin
  FAuthenticated := Value;
end;

procedure TWhatsAppAccount.SetConnected(const Value: boolean);
begin
  FConnected := Value;
end;

procedure TWhatsAppAccount.SetID(const Value: string);
begin
  FID := Value;
end;

procedure TWhatsAppAccount.SetPhoneBattery(const Value: integer);
begin
  FPhoneBattery := Value;
end;

procedure TWhatsAppAccount.SetPhoneNumber(const Value: string);
begin
  FPhoneNumber := Value;
end;

procedure TWhatsAppAccount.SetQrCode(const Value: TWhatsAppQrCode);
begin
  FQrCode := Value;
end;

function TWhatsAppAccount.SetSecretKey(const Value: string) : IWhatsAppAccount;
begin
  result := self;

  FSecretKey := Value;
  if (FWhatsApp <> nil) then

end;

procedure TWhatsAppAccount.SetStatus(const Value: TWhatsAppStatus);
begin
 FStatus := Value;
end;

procedure TWhatsAppAccount.WhatsAppLowBattery(Sender: TObject);
begin
  Status.Bateria := FWhatsApp.BatteryLevel;
end;

procedure TWhatsAppAccount.WhatsAppOnBateria(Sender: TObject);
begin
  Status.MyNumero:= FWhatsApp.MyNumber;
  Status.Bateria := FWhatsApp.BatteryLevel;
end;

procedure TWhatsAppAccount.WhatsAppOnGetMyNumber(Sender: TObject);
begin
 Status.MyNumero := FWhatsApp.MyNumber;
end;

procedure TWhatsAppAccount.WhatsAppOnQrCodeUpdate(const Sender: TObject;
      const QrCode: TResultQRCodeClass);
begin
  FQrCode.Base64 := trim(Copy(QrCode.AQrCode, pos(',',QrCode.AQrCode) + 1, length(QrCode.AQrCode)));
end;

procedure TWhatsAppAccount.WhatsAppOnStatus(Sender: TObject);
var b64 : string;
begin

  case FWhatsApp.status of
    Server_ConnectedDown       : Status.Status := FWhatsApp.StatusToStr;
    Server_Disconnected        : Status.Status := FWhatsApp.StatusToStr;
    Server_Disconnecting       : Status.Status := FWhatsApp.StatusToStr;
    Server_Connected           : Status.Status := '';
    Server_Connecting          : Status.Status := FWhatsApp.StatusToStr;
    Inject_Initializing        : Status.Status := FWhatsApp.StatusToStr;
    Inject_Initialized         : Status.Status := FWhatsApp.StatusToStr;
    Server_ConnectingNoPhone   : Status.Status := FWhatsApp.StatusToStr;
    Server_ConnectingReaderCode: Status.Status := FWhatsApp.StatusToStr;
    Server_TimeOut             : Status.Status := FWhatsApp.StatusToStr;
    Inject_Destroying          : Status.Status := FWhatsApp.StatusToStr;
    Inject_Destroy             : Status.Status := FWhatsApp.StatusToStr;
   end;


  if FWhatsApp.Status = Inject_Initialized then
    begin
      FConnected := true;
      WhatsAppOnBateria(Self);
      WhatsAppLowBattery(Self);

    end
     else
     begin
     FConnected := False;

     end;
  b64 := Copy(QrCode.Base64, pos(',', QrCode.Base64) + 1, length(QrCode.Base64));
  FQrCode.Base64 := b64;

 If FWhatsApp.Status in [Server_ConnectingNoPhone, Server_TimeOut] Then
  Begin
    if FWhatsApp.FormQrCodeType = Ft_Desktop then
    Begin
       if FWhatsApp.Status = Server_ConnectingNoPhone then
          FWhatsApp.FormQrCodeStop;
          FConnected := false;
    end else
    Begin
      if FWhatsApp.Status = Server_ConnectingNoPhone then
      Begin
        if not FWhatsApp.FormQrCodeShowing then
           FWhatsApp.FormQrCodeShowing := True;
           FConnected := True
      end else
      begin
        FWhatsApp.FormQrCodeReloader;
      end;
    end;
  End;
end;


procedure TWhatsAppAccount.WhatsIsConnected(Sender: TObject;
  Connected: Boolean);
begin
   if Connected = true then
   FConnected:=true
   else
   FConnected:=false;
end;

end.
