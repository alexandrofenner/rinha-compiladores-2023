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
unit engine.validatefunc;

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
  sys.procs,
  engine.consts,
  engine.types,
  data.types;

procedure EngineFunction_Validate(const AFunction: PEngineContextFunction);

implementation

type

  TEngineFunctionValidate = record
  private
    FRootFunction: PEngineContextFunction;

    FCount_Recursive: Integer;
    FCount_OtherFunctions: Integer;
    FCount_VarsN: Integer;
    FCount_VarsRef: Integer;
    FCount_VarsGlobal: Integer;

    FCount_FnByVariable: Integer;

    FFlags: Word;
  end;

  Tefv_BlkItem_fn = procedure(var ARObj: TEngineFunctionValidate;
    ABlkItem: PEngineContextBlockItem);

  Tefv_Value_fn = procedure(var ARObj: TEngineFunctionValidate;
    AValue: PEngineContextValue);

procedure EngineFunctionValidate_Block(
  var ARObj: TEngineFunctionValidate; ABlock: PEngineContextBlock); forward;
procedure EngineFunctionValidate_Value(
  var ARObj: TEngineFunctionValidate; AValue: PEngineContextValue); forward;
procedure EngineFunctionValidate_FennerData(
  var ARObj: TEngineFunctionValidate; AValue: PFennerData); forward;


procedure efv_BlkItem_Nop(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_LetConstFunction(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_LetConstArray(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_LetArray(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_LetValue0(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_LetValueRef(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_Call(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_Return(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_If(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;
procedure efv_BlkItem_While(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); forward;

procedure efv_Value_Nop(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_ConstFunction(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_ConstArray(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_VariableGlobal(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_Variable0(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_VariableN(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_VariableRef(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_Array(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_Negative(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_Op2(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_Factorial(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_Function(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_FunctionByValue(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_FunctionRef(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;
procedure efv_Value_If(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); forward;

procedure efv_Function(var ARObj: TEngineFunctionValidate;
  const AFunction: PEngineContextFunction);
begin
  if (Pointer(AFunction) = ARObj.FRootFunction) then
  begin
    Inc(ARObj.FCount_Recursive);
    Exit;
  end;

  Inc(ARObj.FCount_OtherFunctions);
  if ((AFunction.FFlags and EngCtxFnFlgId_Prohibited_Cache) <> 0) then
  begin
    ARObj.FFlags := (ARObj.FFlags or EngCtxFnFlgId_Prohibited_Cache);
    Exit;
  end;
end;

procedure efv_BlkItem_Nop(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); assembler; nostackframe;
asm
    { Nop }
end;

procedure efv_BlkItem_LetConstFunction(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); //assembler; nostackframe;
//asm
//    mov rsi, [rsi + TEngineContextBlockItemLetConstFunction.FConstValue]
//    jmp efv_Function
begin
  efv_Function(ARObj,
    PEngineContextBlockItemLetConstFunction(ABlkItem).FConstValue);
end;

procedure efv_BlkItem_LetConstArray(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem);
var
  LBlkItem: PEngineContextBlockItemLetConstArray absolute ABlkItem;
  i: Integer;
begin
  for i := 0 to High(LBlkItem.FConstValue) do
    EngineFunctionValidate_FennerData(ARObj, @LBlkItem.FConstValue[i]);
end;

procedure efv_BlkItem_LetArray(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem);
var
  LBlkItem: PEngineContextBlockItemLetArray absolute ABlkItem;
  i: Integer;
begin
  for i := 0 to High(LBlkItem.FConstValue) do
    EngineFunctionValidate_Value(ARObj, LBlkItem.FConstValue[i]);
end;

procedure efv_BlkItem_LetValue0(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); //assembler; nostackframe;
//asm
//    mov rsi, [rsi + TEngineContextBlockItemLetValue0.FConstValue]
//    jmp EngineFunctionValidate_Value
begin
  EngineFunctionValidate_Value(ARObj,
    PEngineContextBlockItemLetValue0(ABlkItem).FConstValue);
end;

procedure efv_BlkItem_LetValueRef(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); //assembler; nostackframe;
//asm
//    mov rsi, [rsi + TEngineContextBlockItemLetValueRef.FValue]
//    jmp EngineFunctionValidate_Value
begin
  EngineFunctionValidate_Value(ARObj,
    PEngineContextBlockItemLetValueRef(ABlkItem).FValue);
end;

procedure efv_BlkItem_Call(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); //assembler; nostackframe;
//asm
//    mov rsi, [rsi + TEngineContextBlockItemCall.FSourceValue]
//    jmp EngineFunctionValidate_Value
begin
  EngineFunctionValidate_Value(ARObj,
    PEngineContextBlockItemCall(ABlkItem).FSourceValue);
end;

procedure efv_BlkItem_Return(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem); //assembler; nostackframe;
//asm
//    mov rsi, [rsi + TEngineContextBlockItemReturn.FSourceValue]
//    jmp EngineFunctionValidate_Value
begin
  EngineFunctionValidate_Value(ARObj,
    PEngineContextBlockItemReturn(ABlkItem).FSourceValue);
end;

procedure efv_BlkItem_If(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem);
var
  LBlkItem: PEngineContextBlockItemIf absolute ABlkItem;
begin
  EngineFunctionValidate_Value(ARObj, LBlkItem.FExpression);
  EngineFunctionValidate_Block(ARObj, LBlkItem.FThen);
  EngineFunctionValidate_Block(ARObj, LBlkItem.FElse);
end;

procedure efv_BlkItem_While(var ARObj: TEngineFunctionValidate;
  ABlkItem: PEngineContextBlockItem);
var
  LBlkItem: PEngineContextBlockItemWhile absolute ABlkItem;
begin
  EngineFunctionValidate_Value(ARObj, LBlkItem.FExpression);
  EngineFunctionValidate_Block(ARObj, LBlkItem.FBlock);
end;

procedure efv_Value_Nop(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); assembler; nostackframe;
asm
    { Nop }
end;

procedure efv_Value_ConstFunction(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); //assembler; nostackframe;
//asm
//    mov rax, [rdi + TEngineFunctionValidate.FRootFunction]
//    cmp rax, rsi
//    je  @a
//    lea rax, [rdi + TEngineFunctionValidate.FCount_OtherFunctions]
//    inc dword ptr [rax]
//    ret
//@a:
//    lea rax, [rdi + TEngineFunctionValidate.FCount_Recursive]
//    inc dword ptr [rax]
var
  LFunction: PEngineContextFunction;
begin
  LFunction := PEngineContextValueFunction(AValue).FFunction;
  efv_Function(ARObj, LFunction);

  if (LFunction.FFlags and EngCtxFnFlgId_UseContextN) <> 0 then
    ARObj.FFlags := (ARObj.FFlags or EngCtxFnFlgId_UseContextN);
end;

procedure efv_Value_ConstArray(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue);
var
  LValue: PEngineContextValueArray absolute AValue;
  i: Integer;
begin
  for i := 0 to High(LValue.FValues) do
    EngineFunctionValidate_Value(ARObj, LValue.FValues[i]);
end;

procedure efv_Value_VariableGlobal(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); //assembler; nostackframe;
begin
  Inc(ARObj.FCount_VarsGlobal);
end;

procedure efv_Value_Variable0(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); assembler; nostackframe;
asm
    { nop }
end;

procedure efv_Value_VariableN(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); //assembler; nostackframe;
//asm
//    lea rdi, [rdi + TEngineFunctionValidate.FCount_VarsN]
//    inc dword ptr [rdi]
begin
  Inc(ARObj.FCount_VarsN);
end;

procedure efv_Value_VariableRef(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); //assembler; nostackframe;
begin
  Inc(ARObj.FCount_VarsRef);
end;

procedure efv_Value_Array(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue);
var
  LValue: PEngineContextValueArray absolute AValue;
  i: Integer;
begin
  for i := 0 to High(LValue.FValues) do
    EngineFunctionValidate_Value(ARObj, @LValue.FValues[i]);
end;

procedure efv_Value_Negative(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); //assembler; nostackframe;
//asm
//    mov rdi, [rdi + TEngineContextValueNegative.FRefValue]
//    jmp EngineFunctionValidate_Value
begin
  EngineFunctionValidate_Value(ARObj,
    PEngineContextValueNegative(AValue).FRefValue);
end;

procedure efv_Value_Op2(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue);
var
  LValue: PEngineContextValueOp2 absolute AValue;
begin
  EngineFunctionValidate_Value(ARObj, LValue^.FLeft);
  EngineFunctionValidate_Value(ARObj, LValue^.FRight);
end;

procedure efv_Value_Factorial(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue);
var
  LValue: PEngineContextValueFact absolute AValue;
begin
  EngineFunctionValidate_Value(ARObj, LValue.FValue);
end;

procedure efv_Value_Function(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); //assembler; nostackframe;
//asm
//    mov rsi, [rsi + TEngineContextValueFunction.FFunction]
//    jmp efv_Function
begin
  efv_Function(ARObj, PEngineContextValueFunction(AValue).FFunction);
end;

procedure efv_Value_FunctionByValue(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue);
var
  LValue: PEngineContextValueFunctionByValue absolute AValue;
begin
  EngineFunctionValidate_Value(ARObj, LValue.FValue);
end;

procedure efv_Value_FunctionRef(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue); assembler; nostackframe;
asm
    { Nop }
end;

procedure efv_Value_If(var ARObj: TEngineFunctionValidate;
  AValue: PEngineContextValue);
var
  LValue: PEngineContextValueIf absolute AValue;
begin
  EngineFunctionValidate_Value(ARObj, LValue.FExpression);
  EngineFunctionValidate_Block(ARObj, LValue.FThen);
  EngineFunctionValidate_Block(ARObj, LValue.FElse);
end;

procedure EngineFunctionValidate_BlockItem(
  var ARObj: TEngineFunctionValidate; ABlkItem: PEngineContextBlockItem);
//  assembler; nostackframe;
//asm
//    push rbx
//    push r10
//
//    mov  r10, rdi
//    mov  rbx, rsi
//
//@loop:
//    test rbx, rbx
//    jz   @_end
//
//    xor rdx, rdx
//    mov dl, [rbx + TEngineContextBlockItem.FTypeId]
//    cmp rdx, 12
//    ja @_end
//
//    mov rcx, Offset @fn_tab
//    mov rcx, [rcx + rdx * 8]
//    call rcx
//
//    mov rbx, [rbx + TEngineContextBlockItem.FNext]
//    jmp @loop
//
//@fn_tab:
//    dq Offset efv_BlkItem_Nop                  { None }
//    dq Offset efv_BlkItem_Nop                  { LetConstBool }
//    dq Offset efv_BlkItem_Nop                  { LetConstInt }
//    dq Offset efv_BlkItem_Nop                  { LetConstString }
//    dq Offset efv_BlkItem_LetConstFunction     { LetConstFunction }
//    dq Offset efv_BlkItem_LetConstArray        { LetConstArray }
//    dq Offset efv_BlkItem_LetArray             { LetArray }
//    dq Offset efv_BlkItem_LetValue0            { LetValue0 }
//    dq Offset efv_BlkItem_LetValueRef          { LetValueRef }
//    dq Offset efv_BlkItem_Call                 { Call }
//    dq Offset efv_BlkItem_Return               { Return }
//    dq Offset efv_BlkItem_If                   { If }
//    dq Offset efv_BlkItem_While                { While }
//
//@_end:
//    pop  r10
//    pop  rbx
//end;
begin
  while (ABlkItem <> nil) do
  begin

  case ABlkItem^.FTypeId of
    EngCtxBlkItemTpId_None: ;
    EngCtxBlkItemTpId_LetConstBool: ;
    EngCtxBlkItemTpId_LetConstInt: ;
    EngCtxBlkItemTpId_LetConstString: ;
    EngCtxBlkItemTpId_LetConstFunction: efv_BlkItem_LetConstFunction(ARObj, ABlkItem);
    EngCtxBlkItemTpId_LetConstArray: efv_BlkItem_LetConstArray(ARObj, ABlkItem);
    EngCtxBlkItemTpId_LetArray: efv_BlkItem_LetArray(ARObj, ABlkItem);
    EngCtxBlkItemTpId_LetValue0: efv_BlkItem_LetValue0(ARObj, ABlkItem);
    EngCtxBlkItemTpId_LetValueRef: efv_BlkItem_LetValueRef(ARObj, ABlkItem);
    EngCtxBlkItemTpId_Call: efv_BlkItem_Call(ARObj, ABlkItem);
    EngCtxBlkItemTpId_Return: efv_BlkItem_Return(ARObj, ABlkItem);
    EngCtxBlkItemTpId_If: efv_BlkItem_If(ARObj, ABlkItem);
    EngCtxBlkItemTpId_While: efv_BlkItem_While(ARObj, ABlkItem);
    else
      Random(0);
  end;
    ABlkItem := ABlkItem.FNext;
  end;
end;

procedure EngineFunctionValidate_Block(
  var ARObj: TEngineFunctionValidate; ABlock: PEngineContextBlock);
begin
  while (ABlock <> nil) do
  begin
    EngineFunctionValidate_BlockItem(ARObj, ABlock.FItemsFirst);
    ABlock := ABlock.FNext;
  end;
end;

procedure EngineFunctionValidate_Value(
  var ARObj: TEngineFunctionValidate; AValue: PEngineContextValue);
  assembler; nostackframe;
asm
    test rsi, rsi
    jz  AsmRet

    xor rax, rax
    mov al, [rsi + TEngineContextValue.FTypeId]
    cmp rax, 19
    ja AsmRet

    mov rcx, Offset @tab
    jmp [rcx + rax * 8]

@tab:
    dq Offset efv_Value_Nop              // None
    dq Offset efv_Value_Nop              // Const Bool
    dq Offset efv_Value_Nop              // Const Int
    dq Offset efv_Value_Nop              // Const String
    dq Offset efv_Value_ConstFunction    // Const Function
    dq Offset efv_Value_ConstArray       // Const Array
    dq Offset efv_Value_VariableGlobal   // Variável Global
    dq Offset efv_Value_Variable0        // Variável Local
    dq Offset efv_Value_VariableN        // Variável de Outro Contexto
    dq Offset efv_Value_VariableRef      // Variável (Closure)
    dq Offset efv_Value_Array            // Array
    dq Offset efv_Value_Negative         // Negative
    dq Offset efv_Value_Op2              // Op2
    dq Offset efv_Value_Op2              // Op2Or
    dq Offset efv_Value_Op2              // Op2And
    dq Offset efv_Value_Factorial        // Factorial
    dq Offset efv_Value_Function         // Função
    dq Offset efv_Value_FunctionByValue  // Função por Valor
    dq Offset efv_Value_FunctionRef      // Função (Closure)
    dq Offset efv_Value_If               // If
end;

procedure EngineFunctionValidate_FennerData(
  var ARObj: TEngineFunctionValidate; AValue: PFennerData);
begin
  if (AValue.vId = dttp_Func) and (AValue.vId2 = Id2_Func_Default) then
    efv_Function(ARObj, AValue.vFn);
end;

procedure EngineFunction_Validate(const AFunction: PEngineContextFunction);
var
  LRObj: TEngineFunctionValidate;
  LFlags: Word;
begin
  FillChar(LRObj, SizeOf(LRObj), 0);
  LRObj.FRootFunction := AFunction;
  LRObj.FFlags := AFunction.FFlags;
  EngineFunctionValidate_Block(LRObj, AFunction.FBase.FBlocks);

  LFlags := LRObj.FFlags;
  if (LRObj.FCount_Recursive > 0) then
    LFlags := (LFlags or EngCtxFnFlgId_Recursive);
  if (LRObj.FCount_VarsGlobal > 0) then
    LFlags := (LFlags or EngCtxFnFlgId_Prohibited_Cache);
  if (LRObj.FCount_VarsRef > 0) then
    LFlags := (LFlags or EngCtxFnFlgId_UseContextN);

  AFunction.FFlags := LFlags;
end;

end.

