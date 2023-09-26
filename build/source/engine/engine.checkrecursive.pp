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
unit engine.checkrecursive;

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
  sys.types,
  scanner.types,
  engine.consts,
  engine.types;

procedure EngineFunction_CheckRecursive(var This: TEngineContextFunction);

implementation

//function EngineFunction_CheckRecursiveBlock(var This: TEngineContextFunction;
//  Block: PEngineContextBlock): Boolean; forward;
//function EngineFunction_CheckRecursiveValue(var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean; forward;
//
//function EngineFunction_CheckRecursiveItem_False(
//  var This: TEngineContextFunction; var Item: TEngineContextBlockItem): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveItem_LetConstFunction(
//  var This: TEngineContextFunction; var Item: TEngineContextBlockItem): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveItem_Call(
//  var This: TEngineContextFunction; var Item: TEngineContextBlockItem): Boolean;
//var
//  LItem: TEngineContextBlockItemCall absolute Item;
//begin
//  Exit(EngineFunction_CheckRecursiveValue(This, LItem.FSourceValue^));
//end;
//
//function EngineFunction_CheckRecursiveItem_Return(
//  var This: TEngineContextFunction; var Item: TEngineContextBlockItem): Boolean;
//var
//  LItem: TEngineContextBlockItemReturn absolute Item;
//begin
//  Exit(EngineFunction_CheckRecursiveValue(This, LItem.FSourceValue^));
//end;
//
//function EngineFunction_CheckRecursiveItem_If(
//  var This: TEngineContextFunction; var Item: TEngineContextBlockItem): Boolean;
//var
//  LItem: TEngineContextBlockItemIf absolute Item;
//begin
//  Exit(EngineFunction_CheckRecursiveValue(This, LItem.FExpression^) or
//       EngineFunction_CheckRecursiveBlock(This, LItem.FThen) or
//       EngineFunction_CheckRecursiveBlock(This, LItem.FElse));
//end;
//
//function EngineFunction_CheckRecursiveItem_While(
//  var This: TEngineContextFunction; var Item: TEngineContextBlockItem): Boolean;
//var
//  LItem: TEngineContextBlockItemWhile absolute Item;
//begin
//  Exit(EngineFunction_CheckRecursiveValue(This, LItem.FExpression^) or
//       EngineFunction_CheckRecursiveBlock(This, LItem.FBlock));
//end;
//
//type
//  TfnItem_EngineFunction_CheckRecursiveItem = function (
//    var This: TEngineContextFunction;
//    var Item: TEngineContextBlockItem): Boolean;
//
//  TfnItem_EngineFunction_CheckRecursiveValue = function(
//    var This: TEngineContextFunction;
//    var Item: TEngineContextValue): Boolean;
//
//const
//  cItemFnTab: array[0..12] of TfnItem_EngineFunction_CheckRecursiveItem = (
//    EngineFunction_CheckRecursiveItem_False,              // None
//    EngineFunction_CheckRecursiveItem_False,              // Const Boolean
//    EngineFunction_CheckRecursiveItem_False,              // Const Integer
//    EngineFunction_CheckRecursiveItem_False,              // Const String
//    EngineFunction_CheckRecursiveItem_LetConstFunction,   // Const Function
//    EngineFunction_CheckRecursiveItem_False,              // Const Array
//    EngineFunction_CheckRecursiveItem_False,              // Array
//    EngineFunction_CheckRecursiveItem_False,              // Value0
//    EngineFunction_CheckRecursiveItem_False,              // ValueRef
//    EngineFunction_CheckRecursiveItem_Call,               // Call
//    EngineFunction_CheckRecursiveItem_Return,             // Return
//    EngineFunction_CheckRecursiveItem_If,                 // If
//    EngineFunction_CheckRecursiveItem_While               // While
//  );
//
//function EngineFunction_CheckRecursiveBlock(
//  var This: TEngineContextFunction;
//  Block: PEngineContextBlock): Boolean;
//var
//  Item: PEngineContextBlockItem;
//begin
//  while (Block <> nil) do
//  begin
//    Item := Block^.FItemsFirst;
//    while (Item <> nil) do
//    begin
//      if cItemFnTab[Item^.FTypeId](This, Item^) then Exit(True);
//      Item := Item^.FNext;
//    end;
//    Block := Block^.FNext;
//  end;
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_False(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_ConstFunction(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//var
//  LItem: TEngineContextValueFunction absolute Item;
//begin
//  Random(0);
//
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_ConstArray(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_VariableGlobal(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_Variable0(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_VariableN(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_VariableRef(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_Array(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_Negative(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_Op2(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//var
//  LItem: TEngineContextValueOp2 absolute Item;
//begin
//  Exit(
//    EngineFunction_CheckRecursiveValue(This, LItem.FLeft^) or
//    EngineFunction_CheckRecursiveValue(This, LItem.FRight^)
//  );
//end;
//
//function EngineFunction_CheckRecursiveValue_Factorial(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_Function(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//var
//  LItem: TEngineContextValueFunction absolute Item;
//begin
//  Exit(LItem.FFunction = @This);
//end;
//
//function EngineFunction_CheckRecursiveValue_FunctionByValue(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_FunctionRef(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//function EngineFunction_CheckRecursiveValue_If(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit(False);
//end;
//
//const
//  fnTab: array[0..19] of TfnItem_EngineFunction_CheckRecursiveValue = (
//    EngineFunction_CheckRecursiveValue_False,           // None
//    EngineFunction_CheckRecursiveValue_False,           // Const Boolean
//    EngineFunction_CheckRecursiveValue_False,           // Const Integer
//    EngineFunction_CheckRecursiveValue_False,           // Const String
//    EngineFunction_CheckRecursiveValue_ConstFunction,   // Const Function
//    EngineFunction_CheckRecursiveValue_ConstArray,      // Const Array
//    EngineFunction_CheckRecursiveValue_VariableGlobal,  // Variavel Global
//    EngineFunction_CheckRecursiveValue_Variable0,       // Variavel Local
//    EngineFunction_CheckRecursiveValue_VariableN,       // Variavel de Outro Contexto
//    EngineFunction_CheckRecursiveValue_VariableRef,     // Variavel Closure
//    EngineFunction_CheckRecursiveValue_Array,           // Array
//    EngineFunction_CheckRecursiveValue_Negative,        // Negative
//    EngineFunction_CheckRecursiveValue_Op2,             // Op2
//    EngineFunction_CheckRecursiveValue_Op2,             // Op2Or
//    EngineFunction_CheckRecursiveValue_Op2,             // Op2And,
//    EngineFunction_CheckRecursiveValue_Factorial,       // Factorial
//    EngineFunction_CheckRecursiveValue_Function,        // Function
//    EngineFunction_CheckRecursiveValue_FunctionByValue, // Function by Value
//    EngineFunction_CheckRecursiveValue_FunctionRef,     // Function Closure
//    EngineFunction_CheckRecursiveValue_If               // If
//  );
//
//function EngineFunction_CheckRecursiveValue(
//  var This: TEngineContextFunction;
//  var Item: TEngineContextValue): Boolean;
//begin
//  Exit((@Item <> nil) and fnTab[Item.FTypeId](This, Item));
//end;

procedure EngineFunction_CheckRecursive(var This: TEngineContextFunction);
var
  LFlags: Word;
begin
  if (This.FRecursiveTypeId <> 0) then Exit;

  if (This.FMinParamsCount <= 0) then
  begin
    // Se pode ser invocada sem parâmetros..
    This.FRecursiveTypeId := -3;
    Exit;
  end;

  if (This.FMinParamsCount <> This.FMaxParamsCount) then
  begin
    // Se a qtde de parametros pode ser diferente..
    This.FRecursiveTypeId := -2;
    Exit;
  end;

  LFlags := (This.FFlags and (
    EngCtxFnFlgId_Recursive or EngCtxFnFlgId_Prohibited_Cache));

  if (LFlags <> EngCtxFnFlgId_Recursive) then
  begin
    // Recursividade Negada
    This.FRecursiveTypeId := -1;
    Exit;
  end;

  //if (not EngineFunction_CheckRecursiveBlock(This, This.FBase.FBlocks)) then
  //begin
  //  // Se não é recursiva
  //  This.FRecursiveTypeId := -1;
  //  Exit;
  //end;

  This.FRecursiveTypeId := This.FMinParamsCount;
end;

end.

