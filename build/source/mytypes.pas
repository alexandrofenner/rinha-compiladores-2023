(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*                                                                            *)
(******************************************************************************)
unit MyTypes;

{$mode delphi}{$H+}

interface

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

  tk_pOpen = 18;      //  (
  tk_pClose = 19;     //  )
  tk_Comma = 20;      //  ,
  tk_SemiColon = 21;  //  ;

  tk_Assign = 22;     //  =
  tk_AssignProc = 23; //  =>
  tk_bOpen = 24;      //  {
  tk_bClose = 25;     //  }
  tk_rOpen = 26;      //  [
  tk_rClose = 27;     //  ]
  tk_Fatorial = 28;   //  !
  tk_Question = 29;   //  ?
  tk_Colon = 30;      //  :
  tk_Recursive = 31;  //  ~

  BaseOf_TkRw = 40;

  tkrw_False = (BaseOf_TkRw + 0);
  tkrw_True = (BaseOf_TkRw + 1);
  tkrw_Array = (BaseOf_TkRw + 2);
  tkrw_Function = (BaseOf_TkRw + 3);
  tkrw_Let = (BaseOf_TkRw + 4);
  tkrw_If = (BaseOf_TkRw + 5);
  tkrw_Else = (BaseOf_TkRw + 6);
  tkrw_Print = (BaseOf_TkRw + 7);
  tkrw_First = (BaseOf_TkRw + 8);
  tkrw_Second = (BaseOf_TkRw + 9);
  tkrw_Third = (BaseOf_TkRw + 10);
  tkrw_Fourth = (BaseOf_TkRw + 11);
  tkrw_Fifth = (BaseOf_TkRw + 12);
  tkrw_Sixth = (BaseOf_TkRw + 13);
  tkrw_Seventh = (BaseOf_TkRw + 14);
  tkrw_Eighth = (BaseOf_TkRw + 15);
  tkrw_Ninth = (BaseOf_TkRw + 16);
  tkrw_Tenth = (BaseOf_TkRw + 17);
  tkrw_Array_GetItem = (BaseOf_TkRw + 18);
  tkrw_Array_GetLength = (BaseOf_TkRw + 19);

  SetOf_rw_Funcs = [tkrw_Print, tkrw_First, tkrw_Second, tkrw_Third,
    tkrw_Fourth, tkrw_Fifth, tkrw_Sixth, tkrw_Seventh, tkrw_Eighth,
    tkrw_Ninth, tkrw_Tenth, tkrw_Array_GetItem, tkrw_Array_GetLength];

  SetOf_rw_Funcs_AndId = SetOf_rw_Funcs + [tk_Identifier];

type
  LString = AnsiString;
  UString = UnicodeString;

  TBytes = array of Byte;

  TSysCharSet = set of AnsiChar;

  TMyInteger = Int64;
  TMyVariableDataType = (eNone, eBool, eInt, eStr, eFn);

const
  sFalse: LString = 'false';
  sTrue: LString = 'true';
  sArray: LString = 'array';

  sPrints: array[tkrw_Print..tkrw_Array_GetLength] of LString = (
    'print', 'first', 'second', 'third', 'fourth',
    'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth',
    'array_getitem', 'array_getlength');

implementation


end.

