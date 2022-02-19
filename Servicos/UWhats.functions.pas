unit UWhats.functions;

interface

function OnlyNumbers(value : String) : String;

implementation

uses
  System.SysUtils;

function OnlyNumbers(value : String) : String;
var i: integer;
begin
  result := '';
  if (trim(value) = '') then
    exit;

  for i := 0 to length(value) do
    if pos(value[i], '0123456789') > 0 then
      result := result + value[i];
end;

end.
