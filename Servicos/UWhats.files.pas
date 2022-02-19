unit UWhats.files;

interface

uses
  FMX.Graphics;

type
  IWFile = interface
    ['{6D9C9923-E93B-4DAB-B07F-693ED4A468F6}']
    function GetName : string;
    function GetExtension : string;
    function GetBase64 : string;
    function GetMimeType : string;

    function LoadFromFile(pFilePath : string) : IWFile;
    function LoadImage(pImageName : string; pImageExt : string; pImage : TBitmap) : IWFile;
  end;

  TWFile = class(TInterfacedObject, IWFile)
  private
    FName: string;
    FExtension: string;
    FMimeType : string;
    FBase64: string;
    procedure SetBase64(const Value: string);
    procedure SetExtension(const Value: string);
    procedure SetName(const Value: string);
  public
    property Name : string read FName write SetName;
    property Extension : string read FExtension write SetExtension;
    property Base64 : string read FBase64 write SetBase64;

    function LoadFromFile(pFilePath : string) : IWFile;
    function LoadImage(pImageName : string; pImageExt : string; pImage : TBitmap) : IWFile;
    function GetName : string;
    function GetExtension : string;
    function GetBase64 : string;
    function GetMimeType : string;

    class function new : IWFile;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, UWhats.base64;

{ TWFile }

constructor TWFile.Create;
begin

end;

destructor TWFile.Destroy;
begin

  inherited;
end;

function TWFile.GetBase64: string;
begin
  result := FBase64;
end;

function TWFile.GetExtension: string;
begin
  result := FExtension;
end;

function TWFile.GetMimeType: string;
begin
  result := FMimeType;
end;

function TWFile.GetName: string;
begin
  result := FName;
end;

function TWFile.LoadFromFile(pFilePath: string): IWFile;
begin
  result := self;
  if not (fileExists(pFilePath)) then
    exit;

  FBase64 := FileToBase64(pFilePath);
  SetExtension(Copy(ExtractFileExt(pFilePath), 2, length(pFilePath)));
  FName := ExtractFileName(pFilePath);
end;

function TWFile.LoadImage(pImageName, pImageExt: string; pImage: TBitmap): IWFile;
begin
  result := self;
  if (pImage = nil) then
    exit;

  FBase64 := BitmapToBase64(pImage);
  FName := pImageName;
  SetExtension(pImageExt);
end;

class function TWFile.new: IWFile;
begin
  result := TWFile.Create;
end;

procedure TWFile.SetBase64(const Value: string);
begin
  FBase64 := Value;
end;

procedure TWFile.SetExtension(const Value: string);
var temp : string;
begin
  FExtension := Value;

  temp := FExtension.ToLower;
  if (temp = 'jpg') or (temp = 'jpeg') or (temp = 'png') or (temp = 'gif') then
    FMimeType := 'image/'+ temp
  else
    FMimeType := 'file/'+ temp;
end;

procedure TWFile.SetName(const Value: string);
begin
  FName := Value;
end;

end.
