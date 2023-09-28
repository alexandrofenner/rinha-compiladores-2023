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
unit engine.closureconvertion;

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
  engine.consts,
  engine.types,
  engine.procs;

function Engine_ClosureConvertion(var AEngineRunnerItem: TEngineRunnerItem;
  const AContextFunction, AFunction: PEngineContextFunction;
  const ALevel: Integer): PEngineContextFunction;

implementation

uses
  data.types,
  data.procs,
  data.stack,
  engine.contextvalues,
  err.classes;

type
  PEngineClosureConvertion = ^TEngineClosureConvertion;
  TEngineClosureConvertion = record
    FPrevious: PEngineClosureConvertion;
    FNext: PEngineClosureConvertion;

    FLevel: Integer;
    FEngineRunnerItem: PEngineRunnerItem;
    FContextFunction: PEngineContextFunction;
    FOldFunction: PEngineContextFunction;
    FNewFunction: PEngineContextFunction;
  end;

function Engine_CloneValue(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValue): PEngineContextValue; forward;
function Engine_CloneBlocks(var This: TEngineClosureConvertion;
  AOldBlock: PEngineContextBlock): PEngineContextBlock; forward;

function Engine_CloneValues(var This: TEngineClosureConvertion;
  const ASource: TArray<PEngineContextValue>;
  var ADest: TArray<PEngineContextValue>): Boolean; forward;

var
  ecvFirst: PEngineClosureConvertion;
  ecvLast: PEngineClosureConvertion;

procedure EngineClosureConvertion_Add(var ARObj: TEngineClosureConvertion);
begin
  if (ecvFirst <> nil) then
  begin
    ecvLast.FNext := @ARObj;
    ARObj.FPrevious := ecvLast;
  end else
  begin
    ecvFirst := @ARObj;
    ARObj.FPrevious := nil;
  end;

  ecvLast := @ARObj;
  ARObj.FNext := nil;
end;

procedure EngineClosureConvertion_Remove(var ARObj: TEngineClosureConvertion);
begin
  if (ecvFirst = @ARObj) then ecvFirst := nil;
  if (ecvLast = @ARObj) then ecvLast := nil;

  if (ARObj.FPrevious <> nil) then
    ARObj.FPrevious.FNext := ARObj.FNext;
  if (ARObj.FNext <> nil) then
    ARObj.FNext.FPrevious := ARObj.FPrevious;

  ARObj.FPrevious := nil;
  ARObj.FNext := nil;
end;

function NewEngineContextBy(var This: TEngineClosureConvertion;
  const AOldEngineContext: PEngineContext): PEngineContext;
var
  LEcv: PEngineClosureConvertion;
begin
  if (AOldEngineContext = nil) then Exit(nil);
  if (Pointer(This.FContextFunction) = AOldEngineContext) then
    Exit(AOldEngineContext);

  if (Pointer(This.FOldFunction) = AOldEngineContext) then
    Exit(Pointer(This.FNewFunction));

  LEcv := ecvFirst;
  while (LEcv <> nil) do
  begin
    if (Pointer(LEcv.FOldFunction) = AOldEngineContext) then
      Exit(Pointer(LEcv.FNewFunction));
    LEcv := LEcv.FNext;
  end;

  raise EInternalError.Create('DA3E3AED525A41DEB8853117B9833031');
end;

procedure EngCtxFunCpy0(var This: TEngineClosureConvertion;
  var ADest, ASource: TEngineContextFunction);
begin
  ADest.FBase.FTypeId := ASource.FBase.FTypeId;
  ADest.FBase.FCanFinalizeRefClosureVar := ASource.FBase.FCanFinalizeRefClosureVar;
  ADest.FBase.FOwner := NewEngineContextBy(This, ASource.FBase.FOwner);
  ADest.FBase.FLevel := ASource.FBase.FLevel;

    //FVarsCount: Integer;
    //FVarRefsCount: Integer;
    //FVarsFirst: PEngineContextVariable;
    //FVarRefsFirst: PEngineContextVariableRef;
    //FReadingVar: PEngineContextVariable;
    //FBlocks: PEngineContextBlock;

  ADest.FMinParamsCount := ASource.FMinParamsCount;
  ADest.FMaxParamsCount := ASource.FMaxParamsCount;
  ADest.FConstDeclr := nil;
  ADest.FDeclrName := ASource.FDeclrName;
  ADest.FTypeId := ASource.FTypeId;
  ADest.FFlags := ASource.FFlags;
  ADest.FRecursiveTypeId := ASource.FRecursiveTypeId;
end;

function Engine_CloneValueByVariableRef(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValueByVariableRef): PEngineContextValue;
var
  LData: PFennerData;
begin
  LData := AuxStackVarsFrameBegin(1);
  try
    FennerData_Assign(LData^, StackVarsItem(
      This.FEngineRunnerItem.FStackBase + AOldValue.FBase.FVarIndex));
    Exit(EngineContextValueConst_CreateByFennerData(LData));
  finally
    AuxStackVarsFrameEnd(1);
  end;
end;

function Engine_CloneValue_Op2(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValueOp2): PEngineContextValueOp2;
var
  LLeft, LRight: PEngineContextValue;
begin
  LLeft := Engine_CloneValue(This, AOldValue.FLeft);
  LRight := Engine_CloneValue(This, AOldValue.FRight);

  if ((LLeft = AOldValue.FLeft) and (LRight = AOldValue.FRight)) then
    Exit(AOldValue);

  Result := AllocMem(SizeOf(TEngineContextValueOp2));
  Result.FLeft := LLeft;
  Result.FRight := LRight;
  Result.FBase.FTypeId := AOldValue.FBase.FTypeId;
  Result.FIndexOp := AOldValue.FIndexOp;
  Result.FOp := AOldValue.FOp;
end;

function Engine_CloneValue_Negative(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValueNegative): PEngineContextValueNegative;
var
  LValue: PEngineContextValue;
begin
  LValue := Engine_CloneValue(This, AOldValue.FRefValue);
  if (LValue = AOldValue.FRefValue) then
    Exit(AOldValue);

  Result := AllocMem(SizeOf(TEngineContextValueNegative));
  Result.FBase.FTypeId := EngCtxValueTpId_Negative;
  Result.FRefValue := LValue;
end;

function Engine_CloneValue_Factorial(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValueFact): PEngineContextValueFact;
var
  LValue: PEngineContextValue;
begin
  LValue := Engine_CloneValue(This, AOldValue.FValue);
  if (LValue = AOldValue.FValue) then
    Exit(AOldValue);

  Result := AllocMem(SizeOf(TEngineContextValueFact));
  Result.FBase.FTypeId := EngCtxValueTpId_Factorial;
  Result.FValue := LValue;
end;

function Engine_CloneValue_Function(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValueFunction): PEngineContextValueFunction;
begin
  Result := AllocMem(SizeOf(TEngineContextValueFunction));
  Result.FBase.FTypeId := EngCtxValueTpId_Function;
  Engine_CloneValues(This, AOldValue.FParams, Result.FParams);

  if (EngineContext_RelativeIndexOf(
    AOldValue.FFunction^.FBase, @This.FContextFunction.FBase) < 0) then
  begin
    Result.FFunction := AOldValue.FFunction;
    Exit;
  end;

  Result.FFunction := Engine_ClosureConvertion(This.FEngineRunnerItem^,
    This.FNewFunction, AOldValue.FFunction, (This.FLevel + 1));
end;

function Engine_CloneValue_FunctionByValue(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValueFunctionByValue): PEngineContextValueFunctionByValue;
begin
  Result := AllocMem(SizeOf(TEngineContextValueFunctionByValue));
  Result.FBase.FTypeId := EngCtxValueTpId_FunctionByValue;
  Engine_CloneValues(This, AOldValue.FParams, Result.FParams);

  Result.FValue := Engine_CloneValue(This, AOldValue.FValue);
end;

function Engine_CloneValue_Array(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValueArray): PEngineContextValueArray;
var
  i, LCount, LDiffCount: Integer;
  LValues: TArray<PEngineContextValue>;
  LOldItem, LNewItem: PEngineContextValue;
begin
  LCount := Length(AOldValue.FValues);
  SetLength(LValues, LCount);
  LDiffCount := 0;

  for i := 0 to (LCount - 1) do
  begin
    LOldItem := AOldValue.FValues[i];
    LNewItem := Engine_CloneValue(This, LOldItem);
    LValues[i] := LNewItem;
    if (LOldItem <> LNewItem) then Inc(LDiffCount);
  end;

  if (LDiffCount = 0) then Exit(AOldValue);

  Result := AllocMem(SizeOf(TEngineContextValueArray));
  Result.FValues := LValues;
end;

function Engine_CloneValue_If(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValueIf): PEngineContextValueIf;
begin
  Result := AllocMem(SizeOf(TEngineContextValueIf));
  Result.FBase.FTypeId := EngCtxValueTpId_If;
  Result.FExpression := Engine_CloneValue(This, AOldValue.FExpression);
  Result.FThen := Engine_CloneBlocks(This, AOldValue.FThen);
  Result.FElse := Engine_CloneBlocks(This, AOldValue.FElse);
end;

function Engine_CloneValue(var This: TEngineClosureConvertion;
  const AOldValue: PEngineContextValue): PEngineContextValue;
var
  LOldValueConstFunction: PEngineContextValueConstFunction absolute AOldValue;
  LOldValueByVariableRef: PEngineContextValueByVariableRef absolute AOldValue;
  LRelContextIndex: Integer;
begin
  case AOldValue.FTypeId of
    EngCtxValueTpId_ConstBool,
    EngCtxValueTpId_ConstInt,
    EngCtxValueTpId_ConstString,
    EngCtxValueTpId_ConstArray,
    EngCtxValueTpId_VariableGlobal,
    EngCtxValueTpId_Variable0: Exit(AOldValue);
    EngCtxValueTpId_ConstFunction:
      begin
        Exit(Pointer(EngineContextValueConstFunction_Create(
          Engine_ClosureConvertion(This.FEngineRunnerItem^,
            This.FNewFunction, LOldValueConstFunction.FConstValue,
            This.FLevel + 1))));
      end;
    //EngCtxValueTpId_VariableN = 8;     // deprecated?
    EngCtxValueTpId_VariableRef:
      begin
        LRelContextIndex := LOldValueByVariableRef.FBase.FRelContextIndex;
        if (LRelContextIndex <= This.FLevel) then Exit(AOldValue);
        Exit(Pointer(Engine_CloneValueByVariableRef(This, Pointer(AOldValue))));
      end;
    EngCtxValueTpId_Array:
      Exit(Pointer(Engine_CloneValue_Array(This, Pointer(AOldValue))));
    EngCtxValueTpId_Negative:
      Exit(Pointer(Engine_CloneValue_Negative(This, Pointer(AOldValue))));
    EngCtxValueTpId_Op2,
    EngCtxValueTpId_Op2Or,
    EngCtxValueTpId_Op2And:
      Exit(Pointer(Engine_CloneValue_Op2(This, Pointer(AOldValue))));
    EngCtxValueTpId_Factorial:
      Exit(Pointer(Engine_CloneValue_Factorial(This, Pointer(AOldValue))));
    EngCtxValueTpId_Function:
      Exit(Pointer(Engine_CloneValue_Function(This, Pointer(AOldValue))));
    EngCtxValueTpId_FunctionByValue:
      Exit(Pointer(Engine_CloneValue_FunctionByValue(This, Pointer(AOldValue))));
    EngCtxValueTpId_FunctionRef: Exit(AOldValue);
    //  Exit(Pointer(Engine_CloneValue_FunctionRef(This, Pointer(AOldValue))));
    EngCtxValueTpId_If:
      Exit(Pointer(Engine_CloneValue_If(This, Pointer(AOldValue))));
  end;
  raise EInternalError.Create('763C4A49544F4EB8A33AE930646C1083');
end;

procedure Engine_CloneBlock(var This: TEngineClosureConvertion;
  const AOldBlock, ANewBlock: PEngineContextBlock);
var
  LOldItem, LNewItem: PEngineContextBlockItem;

  LOldItemLetConstBool: PEngineContextBlockItemLetConstBool absolute LOldItem;
  LOldItemLetConstInt: PEngineContextBlockItemLetConstInt absolute LOldItem;
  LOldItemLetConstStr: PEngineContextBlockItemLetConstStr absolute LOldItem;
  LOldItemLetConstFn: PEngineContextBlockItemLetConstFunction absolute LOldItem;
  LOldItemLetConstArray: PEngineContextBlockItemLetConstArray absolute LOldItem;
  LOldItemLetArray: PEngineContextBlockItemLetArray absolute LOldItem;
  LOldItemLetValue0: PEngineContextBlockItemLetValue0 absolute LOldItem;
  LOldItemLetValueRef: PEngineContextBlockItemLetValueRef absolute LOldItem;
  LOldItemReturn: PEngineContextBlockItemReturn absolute LOldItem;
  LOldItemIf: PEngineContextBlockItemIf absolute LOldItem;
  LOldItemWhile: PEngineContextBlockItemWhile absolute LOldItem;

  LNewItemLetConstBool: PEngineContextBlockItemLetConstBool absolute LNewItem;
  LNewItemLetConstInt: PEngineContextBlockItemLetConstInt absolute LNewItem;
  LNewItemLetConstStr: PEngineContextBlockItemLetConstStr absolute LNewItem;
  LNewItemLetConstFn: PEngineContextBlockItemLetConstFunction absolute LNewItem;
  LNewItemLetConstArray: PEngineContextBlockItemLetConstArray absolute LNewItem;
  LNewItemLetArray: PEngineContextBlockItemLetArray absolute LNewItem;
  LNewItemLetValue0: PEngineContextBlockItemLetValue0 absolute LNewItem;
  LNewItemLetValueRef: PEngineContextBlockItemLetValueRef absolute LNewItem;
  LNewItemReturn: PEngineContextBlockItemReturn absolute LNewItem;
  LNewItemIf: PEngineContextBlockItemIf absolute LNewItem;
  LNewItemWhile: PEngineContextBlockItemWhile absolute LNewItem;
begin
  LOldItem := AOldBlock.FItemsFirst;
  while (LOldItem <> nil) do
  begin
    case LOldItem.FTypeId of
      //EngCtxBlkItemTpId_None = 0;
      EngCtxBlkItemTpId_LetConstBool:
        begin
          LNewItemLetConstBool := AllocMem(SizeOf(TEngineContextBlockItemLetConstBool));
          LNewItemLetConstBool.FConstValue := LOldItemLetConstBool.FConstValue;
          LNewItemLetConstBool.FBase.FVarIndex := LOldItemLetConstBool.FBase.FVarIndex;
          LNewItemLetConstBool.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstBool;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      EngCtxBlkItemTpId_LetConstInt:
        begin
          LNewItemLetConstInt := AllocMem(SizeOf(TEngineContextBlockItemLetConstInt));
          LNewItemLetConstInt.FConstValue := LOldItemLetConstInt.FConstValue;
          LNewItemLetConstInt.FBase.FVarIndex := LOldItemLetConstInt.FBase.FVarIndex;
          LNewItemLetConstInt.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstInt;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      EngCtxBlkItemTpId_LetConstString:
        begin
          LNewItemLetConstStr := AllocMem(SizeOf(TEngineContextBlockItemLetConstStr));
          LNewItemLetConstStr.FConstValue := LOldItemLetConstStr.FConstValue;
          LNewItemLetConstStr.FBase.FVarIndex := LOldItemLetConstInt.FBase.FVarIndex;
          LNewItemLetConstStr.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstString;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      EngCtxBlkItemTpId_LetConstFunction:
        begin
          LNewItemLetConstFn := AllocMem(SizeOf(TEngineContextBlockItemLetConstFunction));
          LNewItemLetConstFn.FConstValue := Engine_ClosureConvertion(This.FEngineRunnerItem^,
            This.FNewFunction, LOldItemLetConstFn^.FConstValue, This.FLevel + 1);
          LNewItemLetConstStr.FBase.FVarIndex := LOldItemLetConstInt.FBase.FVarIndex;
          LNewItemLetConstStr.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstFunction;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      EngCtxBlkItemTpId_LetConstArray:
        begin
          LNewItemLetConstArray := AllocMem(SizeOf(TEngineContextBlockItemLetConstArray));
          LNewItemLetConstArray.FConstValue := LOldItemLetConstArray.FConstValue;
          LNewItemLetConstArray.FBase.FVarIndex := LOldItemLetConstInt.FBase.FVarIndex;
          LNewItemLetConstArray.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstArray;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      EngCtxBlkItemTpId_LetArray:
        begin
          LNewItemLetArray := AllocMem(SizeOf(TEngineContextBlockItemLetArray));
          Engine_CloneValues(This, LOldItemLetArray.FConstValue, LNewItemLetArray.FConstValue);
          LNewItemLetConstArray.FBase.FVarIndex := LOldItemLetConstInt.FBase.FVarIndex;
          LNewItemLetConstArray.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetArray;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      EngCtxBlkItemTpId_LetValue0:
        begin
          LNewItemLetValue0 := AllocMem(SizeOf(TEngineContextBlockItemLetValue0));
          LNewItemLetValue0.FConstValue := Engine_CloneValue(This, LOldItemLetValue0.FConstValue);
          LNewItemLetValue0.FBase.FVarIndex := LOldItemLetValue0.FBase.FVarIndex;
          LNewItemLetValue0.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetValue0;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      EngCtxBlkItemTpId_LetValueRef:
        begin
          LNewItemLetValueRef := AllocMem(SizeOf(TEngineContextBlockItemLetValueRef));
          LNewItemLetValueRef.FValue := Engine_CloneValue(This, LOldItemLetValueRef.FValue);
          LNewItemLetValueRef.FIndexRefClosureVar := LOldItemLetValueRef.FIndexRefClosureVar;
          LNewItemLetValueRef.FRelativeContextIndex := LOldItemLetValueRef.FRelativeContextIndex;
          LNewItemLetValueRef.FBase.FVarIndex := LOldItemLetValueRef.FBase.FVarIndex;
          LNewItemLetValueRef.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetValueRef;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      //EngCtxBlkItemTpId_Call = 9;
      EngCtxBlkItemTpId_Return:
        begin
          LNewItemReturn := AllocMem(SizeOf(TEngineContextBlockItemReturn));
          LNewItemReturn.FBase.FTypeId := EngCtxBlkItemTpId_Return;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
          LNewItemReturn.FSourceValue :=
            Engine_CloneValue(This, LOldItemReturn.FSourceValue);
        end;
      EngCtxBlkItemTpId_If:
        begin
          LNewItemIf := AllocMem(SizeOf(TEngineContextBlockItemIf));
          LNewItemIf.FBase.FTypeId := EngCtxBlkItemTpId_If;
          LNewItemIf.FExpression := Engine_CloneValue(This, LOldItemIf.FExpression);
          LNewItemIf.FThen := Engine_CloneBlocks(This, LOldItemIf.FThen);
          LNewItemIf.FElse := Engine_CloneBlocks(This, LOldItemIf.FElse);
          LNewItemIf.FBase.FTypeId := EngCtxBlkItemTpId_If;
          EngineContextBlock_ItemsAdd(ANewBlock^, LNewItem);
        end;
      EngCtxBlkItemTpId_While:
        begin
          LNewItemWhile := AllocMem(SizeOf(TEngineContextBlockItemWhile));
          LNewItemWhile.FBase.FTypeId := EngCtxBlkItemTpId_While;
          LNewItemWhile.FExpression := Engine_CloneValue(This, LOldItemWhile.FExpression);
          LNewItemWhile.FBlock := Engine_CloneBlocks(This, LOldItemWhile.FBlock);
        end;
      else
        raise EInternalError.Create('11D8460C123141E8BCC9BB3F8FC55485');
    end;

    LOldItem := LOldItem.FNext;
  end;
end;

function Engine_CloneBlocks(var This: TEngineClosureConvertion;
  AOldBlock: PEngineContextBlock): PEngineContextBlock;
var
  LNewBlock, LPrevious: PEngineContextBlock;
  LOldItem: PEngineContextBlockItem;
begin
  Result := nil;
  LPrevious := nil;
  while (AOldBlock <> nil) do
  begin
    LNewBlock := AllocMem(SizeOf(TEngineContextBlock));
    if (LPrevious <> nil) then
      LPrevious.FNext := LNewBlock
    else
      Result := LNewBlock;

    LNewBlock.FContext := NewEngineContextBy(This, AOldBlock.FContext);
    Engine_CloneBlock(This, AOldBlock, LNewBlock);
    AOldBlock := AOldBlock.FNext;
  end;
end;

function Engine_CloneValues(var This: TEngineClosureConvertion;
  const ASource: TArray<PEngineContextValue>;
  var ADest: TArray<PEngineContextValue>): Boolean;
var
  i, LCount, LDiffCount: Integer;
  LSource, LDest: PEngineContextValue;
begin
  LCount := Length(ASource);
  SetLength(ADest, LCount);

  LDiffCount := 0;
  for i := 0 to (LCount - 1) do
  begin
    LSource := ASource[i];
    LDest := Engine_CloneValue(This, LSource);
    if (LSource <> LDest) then Inc(LDiffCount);
    ADest[i] := LDest;
  end;

  Exit(LDiffCount > 0);
end;

function Engine_ClosureConvertion(var AEngineRunnerItem: TEngineRunnerItem;
  const AContextFunction, AFunction: PEngineContextFunction;
  const ALevel: Integer): PEngineContextFunction;
var
  LRObj: TEngineClosureConvertion;
  LSaveNext: Pointer;
begin
  EngineClosureConvertion_Add(LRObj);
  LRObj.FLevel := ALevel;
  LRObj.FEngineRunnerItem := @AEngineRunnerItem;
  LRObj.FContextFunction := AContextFunction;
  LRObj.FOldFunction := AFunction;
  Result := AllocMem(SizeOf(TEngineContextFunction));
  LRObj.FNewFunction := Result;
  EngCtxFunCpy0(LRObj, Result^, AFunction^);
  Result.FBase.FBlocks := Engine_CloneBlocks(LRObj, AFunction.FBase.FBlocks);
  EngineClosureConvertion_Remove(LRObj);
end;

end.

