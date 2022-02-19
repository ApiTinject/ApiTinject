unit Generics.Base64;

interface

uses Classes, netEncoding, SysUtils, IOUtils, FMX.Graphics;

function Base64ToStream(imagem: String): TMemoryStream;
function StreamToBase64(STream: TMemoryStream): String;
procedure Base64ToFile(Arquivo, caminhoSalvar: String);
function FileToBase64(Arquivo: String): String;
function BitmapToBase64(imagem: TBitmap): String;
function Base64ToBitmap(value: String): TBitmap;

function StringToBase64(value: String): String;
function Base64ToString(value: String): String;

implementation

uses EncdDecd;

function ReadFile(filePath: String): String;
Var
  t: TStringList;
begin
  result := '';
  if (FileExists(filePath)) then
  begin
    Try
      t := TStringList.Create;
      t.LoadFromFile(filePath);
      result := t.Text;
    Finally
      if (assigned(t)) then
        FreeAndNil(t);
    end;
  end;
end;

procedure Base64ToFile(Arquivo, caminhoSalvar: String);
Var
  STream: TMemoryStream;
begin
  STream := nil;
  Try
    if not(DirectoryExists(ExtractFilePath(caminhoSalvar))) then
      ForceDirectories(ExtractFilePath(caminhoSalvar));

    STream := Base64ToStream(Arquivo);
    STream.SaveToFile(caminhoSalvar);
  Finally
    STream.free;
  End;
end;

function Base64ToStream(imagem: String): TMemoryStream;
var
  Base64: TBase64Encoding;
  bytes: tBytes;
begin
  Base64 := TBase64Encoding.Create;
  Try
    bytes := Base64.DecodeStringToBytes(imagem);
    result := TBytesStream.Create(bytes);
    result.Position := 0; { ANDROID 64 BITS }
  Finally
    Base64.free;
    SetLength(bytes, 0);
  End;
end;

function FileToBase64(Arquivo: String): String;
Var
  STream: TMemoryStream;
begin
  if (Trim(Arquivo) <> '') then
  begin
    STream := TMemoryStream.Create;
    Try
      STream.LoadFromFile(Arquivo);
      result := StreamToBase64(STream);
    Finally
      STream.free;
    End;
  end
  else
    result := '';
end;

function StreamToBase64(STream: TMemoryStream): String;
Var
  Base64: TBase64Encoding;
begin
  Base64 := TBase64Encoding.Create;
  Try
    STream.Position := 0; { ANDROID 64 BITS }
    // result.Seek(0, 0); {ANDROID 32 BITS SOMENTE}
    result := Base64.EncodeBytesToString(STream.Memory, STream.Size);
  Finally
    Base64.free;
  End;
end;

function Base64ToBitmap(value: String): TBitmap;
var
  mem: TMemoryStream;
begin
  mem := nil;
  Try
    mem := Base64ToStream(value);
    result := TBitmap.CreateFromStream(mem);
  Finally
    mem.free;
  End;
end;

function BitmapToBase64(imagem: TBitmap): String;
Var
  STream: TMemoryStream;
begin
  result := '';

  if not(imagem.IsEmpty) then
  begin
    STream := TMemoryStream.Create;
    Try
      imagem.SaveToStream(STream);
      result := StreamToBase64(STream);
    Except
    End;
    STream.free;
  end;
end;

function StringToBase64(value: String): String;
var
  input, output: TStringStream;
begin
  input := TStringStream.Create(value, TEncoding.UTF8);
  output := TStringStream.Create('', TEncoding.UTF8);
  try
    EncodeStream(input, output);
    result := output.DataString;
  finally
    output.free;
    input.free;
  end;
end;

function Base64ToString(value: String): String;
var
  input, output: TStringStream;
begin
  input := TStringStream.Create(value, TEncoding.UTF8);
  output := TStringStream.Create('', TEncoding.UTF8);
  try
    DecodeStream(input, output);
    result := output.DataString;
  finally
    output.free;
    input.free;
  end;
end;

end.
