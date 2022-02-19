unit UWhats.base64;

{** Andre
  * Classe de conversão de arquivos em texto
  * e de Texto em Arquivos, BASE64
**}


interface

uses Classes, netEncoding, SysUtils, IOUtils, FMX.Graphics;

procedure Base64ToFile(Arquivo, caminhoSalvar : String);
function Base64ToStream(imagem : String) : TMemoryStream;
function FileToBase64(Arquivo : String) : String;
function StreamToBase64(STream : TMemoryStream) : String;
function BitmapToBase64(imagem : TBitmap) : String;
function StringToBase64(value : String) : String;
function Base64ToString(value : String) : String;

implementation

uses EncdDecd;

function ReadFile(filePath : String) : String;
Var t : TStringList;
begin
  result := '';
  if not (FileExists(filePath)) then
    exit;

  t := TStringList.Create;
  Try
    t.LoadFromFile(filePath);
    result := t.Text;
  Finally
    if (assigned(T)) then
      FreeAndNil(T);
  end;
end;

procedure Base64ToFile(Arquivo, caminhoSalvar : String);
Var sTream : TMemoryStream;
begin
  sTream := nil;
  Try
    if (Trim(Arquivo) = '') then
      exit;
    if not (DirectoryExists(ExtractFilePath(caminhoSalvar))) then
      ForceDirectories(ExtractFilePath(caminhoSalvar));

    sTream := Base64ToStream(Arquivo);
    sTream.SaveToFile(caminhoSalvar);
  Finally
    sTream.free;
  End;
end;

function Base64ToStream(imagem: String): TMemoryStream;
var base64 : TBase64Encoding;
    bytes : tBytes;
begin
  base64 := TBase64Encoding.Create;
  Try
    bytes  := base64.DecodeStringToBytes(imagem);
    result := TBytesStream.Create(bytes);
    result.Position := 0; {ANDROID 64 BITS}
  Finally
    base64.Free;
    SetLength(bytes, 0);
  End;
end;

function FileToBase64(Arquivo : String): String;
Var sTream : tMemoryStream;
begin
  if (Trim(Arquivo) <> '') then
  begin
    sTream := TMemoryStream.Create;
    Try
      sTream.LoadFromFile(Arquivo);
      result := StreamToBase64(sTream);
    Finally
      Stream.Free;
    End;
  end else
    result := '';
end;

function StreamToBase64(STream: TMemoryStream): String;
Var base64 : tBase64Encoding;
begin
  base64 := TBase64Encoding.Create;
  Try
    stream.Position := 0; {ANDROID 64 BITS}
    result := base64.EncodeBytesToString(sTream.Memory, sTream.Size);
  Finally
    base64.Free;
  End;
end;

function BitmapToBase64(imagem: TBitmap): String;
Var sTream : TMemoryStream;
begin
  result := '';

  if not (imagem.IsEmpty) then
  begin
    sTream := TMemoryStream.Create;
    Try
      imagem.SaveToStream(sTream);
      result := StreamToBase64(sTream);
    Except
    End;
    sTream.Free;
  end;
end;

function StringToBase64(value : String) : String;
var input, output : TStringStream;
begin
  input := TStringStream.Create(value, TEncoding.UTF8);
  Output := TStringStream.Create('', TEncoding.UTF8);
  try
    EncodeStream(Input, Output);
    result := Output.DataString;
  finally
    Output.Free;
    Input.Free;
  end;
end;

function Base64ToString(value : String) : String;
var input, output: TStringStream;
begin
  result := value;
  Input := TStringStream.Create(value, TEncoding.UTF8);
  Output := TStringStream.Create('', TEncoding.UTF8);
  try
    DecodeStream(Input, Output);
    result := Output.DataString;
  finally
    output.Free;
    Input.Free;
  end;
end;

end.

