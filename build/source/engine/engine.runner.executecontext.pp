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
unit engine.runner.executecontext;

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
  data.types,
  engine.consts,
  engine.types;

type
  PEngineRunner_ExecuteContext_Params = ^TEngineRunner_ExecuteContext_Params;
  TEngineRunner_ExecuteContext_Params = record
    LStackIndex: Integer;
    LCount: Integer;
    LAdded: Boolean;
    LTypeId: Byte;
    LContextFunction: PEngineContextFunction;
    LBlock: PEngineContextBlock;
    LItem: PEngineContextBlockItem;
    LParam: TEngineRunnerItem;
    p: PPEngineContextValue;
    LArgs: TFennerDataDynArray;
    LArgPtr: PFennerData;
    LStack: PFennerData;
    LRunningId: Int64;
    LRefCVar: PEngineContextFunctionRefClosureVar;
    LVar: PEngineContextVariable;
    LRCacheEntry: PEngineRecursiveCacheEntry;
  end;

function TEngineRunner_ExecuteContext_Params_New: PEngineRunner_ExecuteContext_Params;
procedure TEngineRunner_ExecuteContext_Params_Destroy(
  P: PEngineRunner_ExecuteContext_Params);

procedure EngineRunner_ExecuteContext(var This: TEngineRunner;
  const AContext: PEngineContext; const AParams: TArray<PEngineContextValue>;
  const AOwnerStackBase: Integer; const AFunctionRef: PEngineContextFunctionRef;
  var AResult: TFennerData);

implementation

uses
  data.stack,
  data.procs,
  engine.procs,
  engine.optimize,
  engine.recursivecache,
  err.classes;

var
  gvFreeRecord: PEngineRunner_ExecuteContext_Params;

function TEngineRunner_ExecuteContext_Params_New: PEngineRunner_ExecuteContext_Params;
begin
  Result := gvFreeRecord;
  if (Result = nil) then
    Exit(AllocMem(SizeOf(TEngineRunner_ExecuteContext_Params)));

  gvFreeRecord := PPointer(Result)^;
  FillChar(Result^, SizeOf(TEngineRunner_ExecuteContext_Params), 0);
end;

procedure TEngineRunner_ExecuteContext_Params_Destroy(
  P: PEngineRunner_ExecuteContext_Params);
begin
  PPointer(P)^ := gvFreeRecord;
  gvFreeRecord := P;
end;

procedure EngineRunner_ExecuteContext(var This: TEngineRunner;
  const AContext: PEngineContext; const AParams: TArray<PEngineContextValue>;
  const AOwnerStackBase: Integer; const AFunctionRef: PEngineContextFunctionRef;
  var AResult: TFennerData);

{$J+}
const
  cgv_RunningId: Int64 = 0;
{$J-}

var
  _P: PEngineRunner_ExecuteContext_Params;

  procedure InitializeArgs;
  var
    i: Integer;
  begin
    if (_P.LCount <= 0) then
    begin
      _P.LArgs := nil;
      Exit;
    end;

    SetLength(_P.LArgs, _P.LCount);
    _P.LArgPtr := Pointer(_P.LArgs);

    _P.p := Pointer(AParams);
    for i := 0 to (_P.LCount - 1) do
    begin
      EngineContextValue_Execute(_P.p^^, _P.LParam, _P.LArgPtr^);
      Inc(_P.p);
      Inc(_P.LArgPtr);
    end;

    _P.LStack := StackVarsItemZ(_P.LStackIndex);
    System.Move(_P.LArgs[0], _P.LStack^, (_P.LCount * SizeOf(TFennerData)));
  end;

  procedure CheckClosure(var AData: TFennerData);
  var
    LFunction: PEngineContextFunction;
    LFunctionRef: PEngineContextFunctionRef;
    I, LCount: Integer;
    LVarRef: PEngineContextVariableRef;
    LD: PEngineContextFunctionRefClosureVar;
  begin
    if (AData.vId <> dttp_Func) then Exit;

    LFunction := AData.vFn;
    if (LFunction.FBase.FVarRefsFirst = nil) then Exit;

    LFunctionRef := AllocMem(SizeOf(TEngineContextFunctionRef));
    LFunctionRef.FFunction := LFunction;

    LCount := LFunction.FBase.FVarRefsCount;
    SetLength(LFunctionRef.FClosureVars, LCount);
    LD := Pointer(LFunctionRef.FClosureVars);
    LVarRef := LFunction.FBase.FVarRefsFirst;

    for I := 0 to (LCount - 1) do
    begin
      LD.FVarRef := LVarRef;
      LD.FRunningId := _P.LRunningId;
      ClosureVarsAdd(LD);

      Inc(LD);
      Inc(LVarRef);
    end;

    FennerData_SetAsFunction(AData, Id2_Func_Ref, LFunctionRef);
  end;

begin
  Inc(cgv_RunningId);
  _P := TEngineRunner_ExecuteContext_Params_New;
  try
    _P^.LContextFunction := Pointer(AContext);

    _P^.LRunningId := cgv_RunningId;
    _P^.LAdded := EngineRunner_AddContext(This, AContext, _P^.LRunningId);
    _P^.LRCacheEntry := nil;

    _P^.LStackIndex := StackVarsAdd(AContext.FVarsCount);

    _P^.LCount := Length(AParams);

    _P^.LParam.FRunner := @This;
    _P^.LParam.FResult := @AResult;
    _P^.LParam.FStackBase := AOwnerStackBase;
    _P^.LParam.FFunctionRef := AFunctionRef;

    if (This.FCrCount > 0) then
      _P^.LParam.FGlobalStackBase := This.FCrStack[0].FStackBase
    else
      _P^.LParam.FGlobalStackBase := 0;

    _P^.LParam.FCrCount := This.FCrCount;
    _P^.LParam.FParamCount := _P^.LCount;
    _P^.LParam.FIsTerminated := False;

    _P^.LParam.FRunningId := _P^.LRunningId;

    if (AContext.FTypeId = EngCtxTp_Function) then
    begin
      if ((_P^.LContextFunction.FMinParamsCount > _P^.LCount)
      or (_P^.LContextFunction.FMaxParamsCount < _P^.LCount)) then
        raise EFunctionInvalidParamCount.Create(
          EngineFunction_GetName(_P^.LContextFunction^),
          _P^.LCount, _P^.LContextFunction.FMinParamsCount,
          _P^.LContextFunction.FMaxParamsCount);

      _P^.LTypeId := _P^.LContextFunction.FTypeId;
      if (_P^.LTypeId = Id2_Func_Default) then
      begin
        if (not EngineFunction_TryOptimize(_P^.LContextFunction^)) then
          EngineFunction_SetTypeId(_P^.LContextFunction^, EngCtxFnTpId_AST);
        _P^.LTypeId := _P^.LContextFunction.FTypeId;
      end;

      if (_P^.LTypeId > EngCtxFnTpId_AST) then
      begin
        InitializeArgs;
        if ExFunc_Execute(_P^.LArgs, AResult, _P^.LTypeId) then Exit;
      end else
      begin
        InitializeArgs;
        if (_P^.LContextFunction.FRecursiveTypeId > 0) then
        begin
          _P^.LRCacheEntry := EngineRecursiveCache_GetEntry(
            This.FRecursiveCaches[_P^.LContextFunction.FRecursiveTypeId], AContext);

          if EngineRecursiveCacheEntry_TryGet(_P^.LRCacheEntry^, _P^.LArgs, AResult) then Exit;
        end;
      end;
    end else
      InitializeArgs;

    _P^.LParam.FStackBase := _P^.LStackIndex;

    _P^.LBlock := AContext.FBlocks;
    while (_P^.LBlock <> nil) do
    begin
      _P^.LItem := _P^.LBlock.FItemsFirst;
      while (_P^.LItem <> nil) do
      begin
        if _P^.LParam.FIsTerminated then
        begin
          StackVarsAdd(AContext.FVarsCount);
          if _P^.LAdded then Dec(This.FCrCount);
          Exit;
        end;

        EngineContextBlockItem(_P^.LItem^, _P^.LParam);
        _P^.LItem := _P^.LItem.FNext;
      end;

      _P^.LBlock := _P^.LBlock.FNext;
    end;

    CheckClosure(_P^.LParam.FResult^);
    if AContext.FCanFinalizeRefClosureVar then
    begin
      _P^.LRefCVar := ClosureVarsFirst;
      while (_P^.LRefCVar <> nil) do
      begin
        if ((_P^.LRefCVar.FRunningId = _P^.LRunningId)
          and (_P^.LRefCVar.FVarRef <> nil)) then
        begin
          _P^.LVar := _P^.LRefCVar.FVarRef.FVariable;
          _P^.LRefCVar.FVarRef := nil;

          if (_P^.LVar <> nil) then
            FennerData_Assign(_P^.LRefCVar.FData,
              StackVarsItem(_P^.LStackIndex + _P^.LVar.FIndex));
        end;

        _P^.LRefCVar := _P^.LRefCVar.FNext;
      end;
    end;

    if (_P^.LRCacheEntry <> nil) then
    begin
      EngineRecursiveCacheEntry_Put(_P^.LRCacheEntry^, _P^.LArgs, AResult);
      EngineRecursiveCacheEntry_DecRef(_P^.LRCacheEntry^);
    end;

    StackVarsRemove(AContext.FVarsCount);

    if _P^.LAdded then Dec(This.FCrCount);
  finally
    TEngineRunner_ExecuteContext_Params_Destroy(_P);
  end;
end;

end.

