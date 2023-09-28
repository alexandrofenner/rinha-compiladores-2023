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
unit sys.types;

{$mode Delphi}{$H+}
{$asmmode Intel}
{$pointermath on}
{$scopedenums on}
{$r-,i-,o-}
{$warnings off}
{$hints off}
{$notes off}

interface

type
  TSysCharSet = set of AnsiChar;

  LString = AnsiString;

  TDynArrayOfPointer = TArray<Pointer>;

const
  cs_Bool: array[Boolean] of LString = ('false', 'true');

var
  s_True: LString absolute cs_Bool[True];
  s_False: LString absolute cs_Bool[False];

implementation

end.

