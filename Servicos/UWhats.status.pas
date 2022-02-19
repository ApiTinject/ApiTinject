unit UWhats.status;

interface

type
  TWhatsAppStatus = class
  private
    FMyNumero: String;
    FStatus: string;
    FBateria: Integer;
    procedure SetBateria(const Value: Integer);
    procedure SetMyNumero(const Value: String);
    procedure SetStatus(const Value: string);

  public
    property Bateria : Integer read FBateria write SetBateria;
    property MyNumero : String read FMyNumero write SetMyNumero;
    property Status : string read FStatus write SetStatus;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TWhatsAppStatus }

constructor TWhatsAppStatus.Create;
begin

end;

destructor TWhatsAppStatus.Destroy;
begin

  inherited;
end;

procedure TWhatsAppStatus.SetBateria(const Value: Integer);
begin
  FBateria := Value;
end;

procedure TWhatsAppStatus.SetMyNumero(const Value: String);
begin
  FMyNumero := Value;
end;

procedure TWhatsAppStatus.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

end.
