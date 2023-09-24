(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*  discord: alexandrofenner                                                  *)
(*                                                                            *)
(******************************************************************************)
unit err.osmsgs;

{$mode Delphi}{$H+}
{$asmmode Intel}
{$pointermath on}
{$scopedenums on}
{$r-,i-,o-}
{$warnings off}
{$hints off}
{$notes off}

interface

uses
  sys.types;

function SysGetOsErrMsg(I: Integer): LString;

implementation

const
  cTable: array[1..3] of LString = (
    {   1 } 'Operação não permitida',
    {   2 } 'O arquivo ou diretório não existe',
    {   3 } 'O processo não existe'
  );

function SysGetOsErrMsg(I: Integer): LString;
begin
  if ((I >= Low(cTable)) and (I <= High(cTable))) then
    Exit(cTable[I]);
  Exit('Erro desconhecido');
end;

end.

