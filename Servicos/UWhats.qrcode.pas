unit UWhats.qrcode;
interface

type
  TWhatsAppQrCode = class
  private
    FBase64: string;
    FExpired: Boolean;
    FPage: Boolean;
    FExpiresAt: TDateTime;
    FStatus: string;
    procedure SetBase64(const Value: string);
    procedure SetExpired(const Value: Boolean);
    procedure SetExpiresAt(const Value: TDateTime);
    procedure SetPage(const Value: Boolean);
    procedure SetStatus(const Value: string);
  public
    property Base64 : string read FBase64 write SetBase64;
    property Expired : Boolean read FExpired write SetExpired;
    property ExpiresAt : TDateTime read FExpiresAt write SetExpiresAt;
    property Page : Boolean read FPage write SetPage;
    property Status : string read FStatus write SetStatus;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TWhatsAppQrCode }

constructor TWhatsAppQrCode.Create;
begin

end;

destructor TWhatsAppQrCode.Destroy;
begin
  inherited;
end;

procedure TWhatsAppQrCode.SetBase64(const Value: string);
begin
  FBase64 := Value;
end;

procedure TWhatsAppQrCode.SetExpired(const Value: Boolean);
begin
  FExpired := Value;
end;

procedure TWhatsAppQrCode.SetExpiresAt(const Value: TDateTime);
begin
  FExpiresAt := Value;
end;

procedure TWhatsAppQrCode.SetPage(const Value: Boolean);
begin
  FPage := Value;
end;

procedure TWhatsAppQrCode.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

end.
