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
unit data.types;

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

const
  dttp_None = 0;
  dttp_Bool = 1;
  dttp_Int = 2;
  dttp_Str = 3;
  dttp_Func = 4;
  dttp_Array = 5;
  dttp_Ptr = 6;

  MaxOf_dttp = dttp_Ptr;

  Id2_Func_Default = 1;
  Id2_Func_Ref = 2;

type
  PFennerData = ^TFennerData;
  TFennerData = record
    vId: Byte;
    vId2: Byte;
    case Integer of
      0: (vBool: Boolean);
      1: (vInt: Int64);
      2: (vStr: Pointer);
      3: (vFn: Pointer);
      4: (vArr: Pointer);
      5: (vPtr: Pointer);
  end;

  TFennerDataDynArray = TArray<TFennerData>;

const
  cs_TypeOf: array[0..6] of LString = (
    'undefined',
    'boolean',
    'integer',
    'string',
    'function',
    'array',
    'pointer');

  cs_TypeOfUnk: LString = 'unknown';

implementation

end.

