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
unit scanner.types;

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
  tk_None = 0;
  tk_Identifier = 1;
  tk_String = 2;
  tk_Integer = 3;

  tkop_Add = 4;       //  `3 + 5 = 8`, `"a" + 2 = "a2`, `2 + "a" = "2a"`,
  tkop_Sub = 5;       //  `0 - 1 = -1`
  tkop_Mul = 6;       //  `2 * 2 = 4`
  tkop_Div = 7;       //  `3 / 2 = 1`
  tkop_Rem = 8;       //  `4 % 2 = 0`
  tkop_Eq = 9;        //  `"a" == "a"`, `2 == 1 + 1`, `true == true`
  tkop_Neq = 10;      //  `"a" != "b"`, `3 != 1 + 1`, `true != false`
  tkop_Lt = 11;       //  `1 < 2`
  tkop_Gt = 12;       //  `2 > 3`
  tkop_Lte = 13;      //  `1 <= 2`
  tkop_Gte = 14;      //  `1 >= 2`
  tkop_And = 15;      //  `true && false`
  tkop_Or = 16;       //  `false || true`
  tkop_Power = 17;    //  `1 ** 2`
  tkop_Fact = 18;     //  !

  tk_pOpen = 19;      //  (
  tk_pClose = 20;     //  )
  tk_Comma = 21;      //  ,
  tk_SemiColon = 22;  //  ;

  tk_Assign = 23;     //  =
  tk_AssignProc = 24; //  =>
  tk_bOpen = 25;      //  {
  tk_bClose = 26;     //  }
  tk_rOpen = 27;      //  [
  tk_rClose = 28;     //  ]
  tk_Fatorial = 29;   //  !
  tk_Question = 30;   //  ?
  tk_Colon = 31;      //  :
  tk_Recursive = 32;  //  ~

  BaseOf_TkRw = 40;

  tkrw_False = (BaseOf_TkRw + 0);
  tkrw_True = (BaseOf_TkRw + 1);
  tkrw_Array = (BaseOf_TkRw + 2);
  tkrw_Function = (BaseOf_TkRw + 3);
  tkrw_Let = (BaseOf_TkRw + 4);
  tkrw_Set = (BaseOf_TkRw + 5);
  tkrw_If = (BaseOf_TkRw + 6);
  tkrw_Else = (BaseOf_TkRw + 7);
  tkrw_While = (BaseOf_TkRw + 8);

  tkrw_Print = (BaseOf_TkRw + 9);
  tkrw_First = (BaseOf_TkRw + 10);
  tkrw_Second = (BaseOf_TkRw + 11);
  tkrw_Third = (BaseOf_TkRw + 12);
  tkrw_Fourth = (BaseOf_TkRw + 13);
  tkrw_Fifth = (BaseOf_TkRw + 14);
  tkrw_Sixth = (BaseOf_TkRw + 15);
  tkrw_Seventh = (BaseOf_TkRw + 16);
  tkrw_Eighth = (BaseOf_TkRw + 17);
  tkrw_Ninth = (BaseOf_TkRw + 18);
  tkrw_Tenth = (BaseOf_TkRw + 19);
  tkrw_Array_GetItem = (BaseOf_TkRw + 20);
  tkrw_Array_GetLength = (BaseOf_TkRw + 21);
  tkrw_TypeOf = (BaseOf_TkRw + 22);
  tkrw_Max = (BaseOf_TkRw + 23);
  tkrw_Min = (BaseOf_TkRw + 24);

  SetOf_rw_Funcs = [tkrw_Print, tkrw_First, tkrw_Second, tkrw_Third,
    tkrw_Fourth, tkrw_Fifth, tkrw_Sixth, tkrw_Seventh, tkrw_Eighth,
    tkrw_Ninth, tkrw_Tenth, tkrw_Array_GetItem, tkrw_Array_GetLength,
    tkrw_TypeOf, tkrw_Max, tkrw_Min];

  SetOf_rw_Funcs_AndId = SetOf_rw_Funcs + [tk_Identifier];

type
  PPToken = ^PToken;
  PToken = ^TToken;
  TToken = record
  public
    Id: Byte;
    vds: LString;
    case Integer of
      0: (vdi: Int64;

          {
            Position -> Posição do caractere inicial do token
            Column -> Id da coluna
            Row -> Id da linha
            Length -> Quantidade de caracteres
          }
          Position: Integer;
          Column: Integer;
          Row: Integer;
          Length: Integer);
      1: (p: Pointer);
  end;

  PTokenStack = ^TTokenStack;
  TTokenStack = record
  public
    DynArray: TArray<PToken>;
    Count: Integer;
    Capacity: Integer;
  end;

  TScannerState = record
  public
    FSource: PAnsiChar;
    FCursor: PAnsiChar;
    FBgLinePos: PAnsiChar;
    FCurLineId: Integer;
    FOutOf: PAnsiChar;
    FToken: PToken;
    FStack: TTokenStack;
  end;

const
  sFalse: LString = 'false';
  sTrue: LString = 'true';
  sArray: LString = 'array';

  sRwPrints: array[tkrw_Print..tkrw_Min] of LString = (
    'print', 'first', 'second', 'third', 'fourth',
    'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth',
    'array_item', 'array_length', 'typeof', 'max', 'min');

  sTkOpersInfo: array[tkop_Add..tkop_Fact] of LString = (
    '(+) adição',
    '(-) subtração',
    '(*) multiplicação',
    '(/) divisão',
    '(%) módulo',
    '(==) igualdade',
    '(!=) diferença',
    '(<) menor',
    '(>) maior',
    '(<=) menor ou igual',
    '(>=) maior ou igual',
    '(&&) "E" booleânico',
    '(||) "Ou" booleânico',
    '(**) potência',
    '(!) fatorial');

implementation

end.

