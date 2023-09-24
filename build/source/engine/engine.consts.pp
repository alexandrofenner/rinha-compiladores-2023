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
unit engine.consts;

{$mode Delphi}{$H+}
{$asmmode Intel}
{$pointermath on}
{$scopedenums on}
{$r-,i-,o-}
{$warnings off}
{$hints off}
{$notes off}

interface

const
  { Engine Context Type Id }
  EngCtxTp_None = 0;
  EngCtxTp_Global = 1;
  EngCtxTp_Function = 2;

  { Engine Context Function Type Id }
  EngCtxFnTpId_None = 0;
  EngCtxFnTpId_AST = 1;
  EngCtxFnTpId_Print = 2;
  EngCtxFnTpId_Fibonacci = 3;
  EngCtxFnTpId_FibonacciR3 = 4;
  EngCtxFnTpId_Combination = 5;
  EngCtxFnTpId_SumOfPA = 6;
  EngCtxFnTpId_Factorial = 7;
  EngCtxFnTpId_Min = 8;
  EngCtxFnTpId_Max = 9;
  EngCtxFnTpId_Mdc = 10;
  EngCtxFnTpId_HanoiMovsCount = 11;
  EngCtxFnTpId_Array_Length = 12;
  EngCtxFnTpId_Array_Item = 13;
  EngCtxFnTpId_TypeOf = 14;
  EngCtxFnTpId_First = 15;
  EngCtxFnTpId_Second = 16;
  EngCtxFnTpId_Third = 17;
  EngCtxFnTpId_Fourth = 18;
  EngCtxFnTpId_Fifth = 19;
  EngCtxFnTpId_Sixth = 20;
  EngCtxFnTpId_Seventh = 21;
  EngCtxFnTpId_Eighth = 22;
  EngCtxFnTpId_Ninth = 23;
  EngCtxFnTpId_Tenth = 24;

  { Engine Context BlockItem Type Id }
  EngCtxBlkItemTpId_None = 0;
  EngCtxBlkItemTpId_LetConstBool = 1;
  EngCtxBlkItemTpId_LetConstInt = 2;
  EngCtxBlkItemTpId_LetConstString = 3;
  EngCtxBlkItemTpId_LetConstFunction = 4;
  EngCtxBlkItemTpId_LetConstArray = 5;
  EngCtxBlkItemTpId_LetArray = 6;
  EngCtxBlkItemTpId_LetValue0 = 7;
  EngCtxBlkItemTpId_LetValueRef = 8;
  EngCtxBlkItemTpId_Call = 9;
  EngCtxBlkItemTpId_Return = 10;
  EngCtxBlkItemTpId_If = 11;
  EngCtxBlkItemTpId_While = 12;

  { Engine Context Value Type Id }
  EngCtxValueTpId_None = 0;
  EngCtxValueTpId_ConstBool = 1;
  EngCtxValueTpId_ConstInt = 2;
  EngCtxValueTpId_ConstString = 3;
  EngCtxValueTpId_ConstFunction = 4;
  EngCtxValueTpId_ConstArray = 5;
  EngCtxValueTpId_VariableGlobal = 6;
  EngCtxValueTpId_Variable0 = 7;
  EngCtxValueTpId_VariableN = 8;     // deprecated?
  EngCtxValueTpId_VariableRef = 9;
  EngCtxValueTpId_Array = 10;
  EngCtxValueTpId_Negative = 11;
  EngCtxValueTpId_Op2 = 12;
  EngCtxValueTpId_Op2Or = 13;
  EngCtxValueTpId_Op2And = 14;
  EngCtxValueTpId_Factorial = 15;
  EngCtxValueTpId_Function = 16;
  EngCtxValueTpId_FunctionByValue = 17;
  EngCtxValueTpId_FunctionRef = 18;
  EngCtxValueTpId_If = 19;


implementation

end.

