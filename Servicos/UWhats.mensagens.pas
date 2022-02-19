unit UWhats.mensagens;

interface

type
  IWMessageSendResponse = interface
    ['{1BA7098B-FB85-4D6B-9E00-D205FDB35AC5}']
    //ENVIOU A MENSAGEM TRUE / FALSE
    procedure SetSent(value : boolean);
    function GetSent : boolean;

    //MENSAGEM DE MOTIVO DE ALGUM ERRO INESPERADO
    procedure SetMessage(value : string);
    function GetMessage : string;
  end;

  TWMessageSendResponse = class(TInterfacedObject, IWMessageSendResponse)
    FSent : boolean;
    FMessage : string;
  public
    procedure SetSent(value : boolean);
    function GetSent : boolean;
    procedure SetMessage(value : string);
    function GetMessage : string;

    class function new : IWMessageSendResponse;
    constructor create;
    destructor destroy; override;
  end;

implementation

{ TWMessageSendResponse }

constructor TWMessageSendResponse.create;
begin
  FSent := false;
  FMessage := '';
end;

destructor TWMessageSendResponse.destroy;
begin
  inherited;
end;

function TWMessageSendResponse.GetMessage: string;
begin
  result := FMessage;
end;

function TWMessageSendResponse.GetSent: boolean;
begin
  result := FSent;
end;

class function TWMessageSendResponse.new: IWMessageSendResponse;
begin
  result := TWMessageSendResponse.create;
end;

procedure TWMessageSendResponse.SetMessage(value: string);
begin
  FMessage := value;
end;

procedure TWMessageSendResponse.SetSent(value: boolean);
begin
  FSent := value;
end;

end.
