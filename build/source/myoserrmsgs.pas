unit MyOsErrMsgs;

{$mode ObjFPC}{$H+}

interface


uses
  MyTypes;

function MyGetOsErrMsg(I: Integer): LString;

implementation

{$ifdef Linux}
const
  cTable: array[1..3] of LString = (
    {   1 } 'Operação não permitida',
    {   2 } 'O arquivo ou diretório não existe',
    {   3 } 'O processo não existe'
  );
{$endif Linux}

{$ifdef MSWindows}
const
  cTable: array[1..3] of LString = (
    {   1 } 'Função inválida',
    {   2 } 'O arquivo não existe',
    {   3 } 'O diretório não existe'
  );
{$endif MSWindows}

function MyGetOsErrMsg(I: Integer): LString;
begin
  if ((I >= Low(cTable)) and (I <= High(cTable))) then
    Exit(cTable[I]);
  Exit('Erro desconhecido');
end;

end.

