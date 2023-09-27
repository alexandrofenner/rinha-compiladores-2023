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
unit engine.procs;

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
  sys.procs,
  data.types,
  data.procs,
  data.stack,
  engine.consts,
  engine.types,
  engine.operators,
  scanner.types,
  scanner.procs,
  scanner.tostring,
  err.classes,
  sys.utils,
  sys.funcs;

procedure EngineGlobalContextSaveState_Backup(
  var This: TEngineGlobalContextSaveState); assembler;
procedure EngineGlobalContextSaveState_Restore(
  var This: TEngineGlobalContextSaveState); assembler;

procedure EngineContext_CreateSysFuncs(var This: TEngineContextGlobal);

procedure EngineContext_Parse(var This: TEngineContext;
  var TokenStack: TTokenStack; var Index: Integer);
procedure EngineContext_ParseGlobal(var This: TEngineContext);

function EngineContext_RelativeIndexOf(var This: TEngineContext;
  const AContext: PEngineContext): Integer;

function EngineContext_FindVar(var This: TEngineContext;
  const AName: LString): PEngineContextVariable;
function EngineContext_FindOrDeclrVar(var This: TEngineContext;
  const AName: LString): PEngineContextVariable;

function EngineContext_LocalFindOrDeclrVar(var This: TEngineContext;
  const AName: LString): PEngineContextVariable;

function EngineContext_FindOrDeclrVarRef(var This: TEngineContext;
  const AVariable: PEngineContextVariable;
  const ARelativeContextIndex: Integer): PEngineContextVariableRef;

function EngineContext_VarByName(var This: TEngineContext;
  const AToken: PToken): PEngineContextVariable;

function EngineContext_Root(var This: TEngineContext): PEngineContext;
function EngineContext_FindFirstLetConstFunction(var This: TEngineContext;
  const AVarIndex: Integer): PEngineContextBlockItemLetConstFunction;

function EngineContextGlobal_Create: PEngineContextGlobal;
procedure EngineContextGlobal_Destroy(p: PEngineContextGlobal);

procedure EngineGlobal_Execute; overload;
procedure EngineGlobal_Execute(var AResult: TFennerData); overload;

{ <EngineContextValue> }
procedure EngineContextValue_Destroy(var This: TEngineContextValue);
procedure EngineContextValue_Execute(var This: TEngineContextValue;
  var AItem: TEngineRunnerItem; var AResult: TFennerData); assembler;

function EngineContextValue_IsConst(var This: TEngineContextValue): Boolean;
function EngineContextValue_StackIndex(var This: TEngineContextValue;
  var AItem: TEngineRunnerItem): Integer; assembler;

function EngineContextValueConstFunction_Create(
  const AFunction: PEngineContextFunction): PEngineContextValueFunction;

function EngineContextValueFunction_Create(
  const AFunction: PEngineContextFunction;
  const AParams: TArray<PEngineContextValue>): PEngineContextValueFunction;

function EngineContextValueFunctionByValue_Create(
  const AValue: PEngineContextValue;
  const AParams: TArray<PEngineContextValue>):
    PEngineContextValueFunctionByValue;

function EngineContextValueNegative_Create(
  const ARefValue: PEngineContextValue): PEngineContextValueNegative;

function EngineContextValueByVariableLocal_Create(
  const AVarIndex: Integer): PEngineContextValueByVariable;
function EngineContextValueByVariableGlobal_Create(
  const AVarIndex: Integer): PEngineContextValueByVariable;

function EngineContextValueOp2_Create(const ALeft, ARight: PEngineContextValue;
  const AOp: Byte): PEngineContextValue;
function EngineContextValueFact_Create(
  const ARefValue: PEngineContextValue): PEngineContextValue;

{ </EngineContextValue> }

{ <EngineFunction> }
function EngineFunction_GetDeclrName(var This: TEngineContextFunction): LString;
function EngineFunction_GetName(var This: TEngineContextFunction): LString;
function EngineFunction_SetTypeId(var This: TEngineContextFunction;
  const ATypeId: Byte): Boolean; inline;
{ </EngineFunction> }

{ <EngineFunctionRef> }
procedure EngineContextFunctionRef_IncRef(var This: TEngineContextFunctionRef);
procedure EngineContextFunctionRef_DecRef(var This: TEngineContextFunctionRef);
{ </EngineFunctionRef> }

{ <EngineContextBlock> }
procedure EngineContextBlock_ItemsAdd(var This: TEngineContextBlock;
  const Item: PEngineContextBlockItem);
{ </EngineContextBlock> }

{ <EngineContextBlockItem> }
procedure EngineContextBlockItem(var This: TEngineContextBlockItem;
  var AItem: TEngineRunnerItem);

function EngineContextBlockItemLetConstBool_Create(const AVarIndex: Integer;
  const AValue: Boolean): PEngineContextBlockItemLetConstBool;
function EngineContextBlockItemLetConstInt_Create(const AVarIndex: Integer;
  const AValue: Int64): PEngineContextBlockItemLetConstInt;
function EngineContextBlockItemLetConstStr_Create(const AVarIndex: Integer;
  const AValue: LString): PEngineContextBlockItemLetConstStr;
function EngineContextBlockItemLetConstFunc_Create(const AVarIndex: Integer;
  const AValue: PEngineContextFunction): PEngineContextBlockItemLetConstFunction;
function EngineContextBlockItemLetConstArray_Create(const AVarIndex: Integer;
  const AValue: TFennerDataDynArray): PEngineContextBlockItemLetConstArray;
{ </EngineContextBlockItem> }

{ <EngineRunner> }
procedure EngineRunner_Initialize(var This: TEngineRunner);
//procedure EngineRunner_ExecuteContext(var This: TEngineRunner;
//  const AContext: PEngineContext; const AParams: TArray<PEngineContextValue>;
//  const AOwnerStackBase: Integer; const AFunctionRef: PEngineContextFunctionRef;
//  var AResult: TFennerData);

function EngineRunner_AddContext(var This: TEngineRunner;
  const AContext: PEngineContext; const ARunningId: Int64): Boolean;
{ </EngineRunner> }

function ClosureVarsFirst: PEngineContextFunctionRefClosureVar; //assembler;

procedure ClosureVarsAdd(const AItem: PEngineContextFunctionRefClosureVar);
procedure ClosureVarsRemove(const AItem: PEngineContextFunctionRefClosureVar);

function ExFunc_Execute(const AParams: TFennerDataDynArray;
  var AResult: TFennerData; const AIndex: Integer): Boolean; assembler;

implementation

uses
  sys.func_combination,
  engine.contextvalues,
  engine.optimize,
  engine.optimize_op2,
  engine.checkrecursive,
  engine.recursivecache,
  engine.validatefunc,
  engine.closureconvertion,
  engine.runner.executecontext;

type
  PEngineCaller = ^TEngineCaller;
  PEngineArrayBuilder = ^TEngineArrayBuilder;

  { TEngineCaller }

  TEngineCaller = record
  public
    FVariable: PEngineContextVariable;          { Weak }
    FParamsArray: TArray<PEngineContextValue>;  { Weak }
    FParamsCount: Integer;
    FToken: PToken;
    FContext: PEngineContext;

    procedure AddParam(const AParam: PEngineContextValue);
    procedure AddParams(const AParams: PEngineContextValueArray);
    procedure AddParams2(const AParams: PEngineContextValueConstArray);

    function Build: PEngineContextValue;

    class function Create(const AContext: PEngineContext;
      const AVariable: PEngineContextVariable;
      const AToken: PToken): PEngineCaller; static;
  strict private
    function BuildAsArray: PEngineContextValue;
  end;

  TEngineArrayBuilder = record
  public
    FItemsArray: TArray<PEngineContextValue>;
    FItemsCount: Integer;

    procedure Add(const AItem: PEngineContextValue);
    function Build: PEngineContextValue;

    class function Create: PEngineArrayBuilder; static; inline;
  strict private
    function ItemsIsConst: Boolean;
  end;

procedure Free_EngineCaller(p: PEngineCaller); inline;
begin
  System.Dispose(p);
end;

function ResolveExpression(var ATokenStack: TTokenStack;
  const AContext: PEngineContext;
  const AByLet: Boolean): PEngineContextValue; forward;

function ReadItemBlock(var ATokenStack: TTokenStack;
  const AContext: PEngineContext; var AIndex: Integer;
  const AIsLoose: Boolean): PEngineContextBlock; forward;

var
  gvEngineContextGlobal: PEngineContextGlobal;
  GenId_FunctionName: Integer;

  gvClosureVarsFirst: PEngineContextFunctionRefClosureVar;
  gvClosureVarsLast: PEngineContextFunctionRefClosureVar;

function ClosureVarsFirst: PEngineContextFunctionRefClosureVar;
begin
  Exit(gvClosureVarsFirst);
end;

procedure ClosureVarsAdd(const AItem: PEngineContextFunctionRefClosureVar);
begin
  if (gvClosureVarsFirst <> nil) then
  begin
    gvClosureVarsLast.FNext := AItem;
    AItem.FPrevious := gvClosureVarsLast;
  end else
    gvClosureVarsFirst := AItem;

  gvClosureVarsLast := AItem;
end;

procedure ClosureVarsRemove(const AItem: PEngineContextFunctionRefClosureVar);
begin
  if (gvClosureVarsFirst = AItem) then
    gvClosureVarsFirst := AItem.FNext;
  if (gvClosureVarsLast = AItem) then
    gvClosureVarsLast := AItem.FPrevious;

  if (AItem.FPrevious <> nil) then
    AItem.FPrevious.FNext := AItem.FNext;
  if (AItem.FNext <> nil) then
    AItem.FNext.FPrevious := AItem.FPrevious;

  AItem.FPrevious := nil;
  AItem.FNext := nil;
end;

procedure EngineGlobalContextSaveState_Backup(
  var This: TEngineGlobalContextSaveState); assembler; nostackframe;
asm
    mov rax, offset gvEngineContextGlobal
    mov rax, [eax]
    mov [rdi + TEngineGlobalContextSaveState.FGlobalContext], rax
end;

procedure EngineGlobalContextSaveState_Restore(
  var This: TEngineGlobalContextSaveState); assembler; nostackframe;
asm
    mov rax, [rdi + TEngineGlobalContextSaveState.FGlobalContext]
    mov rcx, offset gvEngineContextGlobal
    mov [rcx], rax
end;

const
  tk_Negative = 254;
  tk_RefValue_ = 255;

function GetRefValue(const AToken: PToken): PEngineContextValue; inline;
begin
  Exit(AToken.p);
end;

procedure SetRefValue(const AToken: PToken;
  const AValue: PEngineContextValue); inline;
begin
  AToken.Id := tk_RefValue_;
  AToken.p := AValue;
end;

procedure SimplifyNegatives(var ATkStack: TTokenStack);
var
  i: Integer;
  Tk0, Tk1: PToken;
begin
  i := (ATkStack.Count - 1);
  while (i >= 1) do
  begin
    Tk0 := ATkStack.DynArray[i];
    case Tk0.Id of
      tkop_Sub:
        begin
          Tk1 := ATkStack.DynArray[i - 1];
          case Tk1.Id of
            tkop_Sub:
              begin
                Tk1.Id := tkop_Add;
                TokenStack_Delete(ATkStack, i, 1);
              end;
            tkop_Add:
              begin
                Tk1.Id := tkop_Sub;
                TokenStack_Delete(ATkStack, i, 1);
              end;
            tkop_Mul..tkop_Power: Tk0.Id := tk_Negative;
          end;
        end;
      tkop_Add:
        begin
          Tk1 := ATkStack.DynArray[i - 1];
          case Tk1.Id of
            tkop_Sub:
              begin
                Tk1.Id := tkop_Sub;
                TokenStack_Delete(ATkStack, i, 1);
              end;
            tkop_Add:
              begin
                Tk1.Id := tkop_Add;
                TokenStack_Delete(ATkStack, i, 1);
              end;
            tkop_Mul..tkop_Power:
              TokenStack_Delete(ATkStack, i, 1);
          end;
        end;
    end;
    Dec(i);
  end;
end;

procedure SelectTokens_p_OpenClose(var ATkStack, ASubTkStack: TTokenStack;
  var AIndex: Integer);
var
  Tk: PToken;
  LStart, LIndex, pCount: Integer;
begin
  LIndex := AIndex;
  if (LIndex >= ATkStack.Count) then
    raise EBuilderUnexpectedEof.Create2(ATkStack);

  if (ATkStack.DynArray[LIndex].Id <> tk_pOpen) then
    raise EUnexpectedToken.Create(ATkStack.DynArray[LIndex]);

  Inc(LIndex);
  LStart := LIndex;

  pCount := 1;
  repeat
    if (LIndex >= ATkStack.Count) then
      raise EBuilderUnexpectedEof.Create2(ATkStack);

    Tk := ATkStack.DynArray[LIndex];
    case Tk.Id of
      tk_pOpen: Inc(pCount);
      tk_pClose:
        begin
          Dec(pCount);
          if (pCount = 0) then
          begin
            TokenStack_CopyBy(ASubTkStack, ATkStack, LStart, (LIndex - LStart));
            SimplifyNegatives(ASubTkStack);
            AIndex := (LIndex + 1);
            Break;
          end;
        end;
    end;
    Inc(LIndex);
  until False;
end;

procedure SelectTokens_4Return(var ATkStack, ASubTkStack: TTokenStack;
  var AIndex: Integer);
label lb_P0;
var
  LStart, LIndex, pCount, bCount, rCount: Integer;
  v_fPosArray: TArray<Integer>;
  v_fPosCount, v_fPosCapacity: Integer;

  Tk: PToken;
begin
  LIndex := AIndex;
  if (LIndex >= ATkStack.Count) then
    raise EBuilderUnexpectedEof.Create(ATkStack.DynArray[LIndex - 1]);

  LStart := LIndex;
  pCount := 0;
  bCount := 0;
  rCount := 0;
  v_fPosArray := nil;
  v_fPosCount := 0;
  v_fPosCapacity := 0;
  repeat
    Tk := ATkStack.DynArray[LIndex];
    case Tk.Id of
      tkrw_Function:
        begin
          { função }
          Inc(LIndex);
          if (LIndex >= ATkStack.Count) then goto lb_P0;
          Inc(rCount);

          Tk := ATkStack.DynArray[LIndex];
          if (Tk.Id = tk_pOpen) then
          repeat
            Inc(LIndex);
            if (LIndex >= ATkStack.Count) then goto lb_P0;
            Inc(rCount);
            Tk := ATkStack.DynArray[LIndex];

            if (Tk.Id = tk_pClose) then
            begin
              Inc(LIndex);
              if (LIndex >= ATkStack.Count) then goto lb_P0;
              Inc(rCount);
              Tk := ATkStack.DynArray[LIndex];
              Break;
            end;
          until False;

          if (Tk.Id = tk_AssignProc) then
          begin
            Inc(LIndex);
            if (LIndex >= ATkStack.Count) then goto lb_P0;
            Inc(rCount);
            Tk := ATkStack.DynArray[LIndex];
          end;

          if (Tk.Id = tk_bOpen) then
          begin
            if (v_fPosCount = v_fPosCapacity) then
            begin
              Inc(v_fPosCapacity, 16);
              SetLength(v_fPosArray, v_fPosCapacity);
            end;
            v_fPosArray[v_fPosCount] := bCount;
            Inc(v_fPosCount);
            Inc(bCount);
          end;
        end;
      tk_bOpen: Inc(bCount);
      tk_bClose:
        begin
          if ((bCount = 0) and (pCount = 0)) then Break;
          Dec(bCount);

          if ((v_fPosCount > 0) and (v_fPosArray[v_fPosCount - 1] = bCount)) then
          begin
            Dec(v_fPosCount);
            if (v_fPosCount = 0) then
            begin
              Inc(LIndex);
              Inc(rCount);

              if ((LIndex < ATkStack.Count) and
                (ATkStack.DynArray[LIndex].Id = tk_pOpen)) then
              begin
                Inc(pCount);
                Inc(LIndex);
                Inc(rCount);
                Continue;
              end;

              while ((LIndex < ATkStack.Count) and
                (ATkStack.DynArray[LIndex].Id = tk_SemiColon)) do
                  Inc(LIndex);

              if (pCount = 0) then Break;
              Dec(LIndex);
            end;
          end;
        end;
      tk_pOpen: Inc(pCount);
      tk_pClose: Dec(pCount);
      tk_SemiColon:
        if ((bCount = 0) and (pCount = 0)) then
        begin
          Inc(LIndex);
          Break;
        end;
    end;

    Inc(LIndex);
    if (LIndex >= ATkStack.Count) then
    begin
lb_P0: ;
      if ((bCount = 0) and (pCount = 0)) then
      begin
        Inc(rCount);
        Break;
      end;
      raise EBuilderUnexpectedEof.Create(ATkStack.DynArray[LIndex - 1]);
    end;
    Inc(rCount);
  until False;

  rCount := (LIndex - LStart);
  TokenStack_CopyBy(ASubTkStack, ATkStack, LStart, rCount);
  while ((ASubTkStack.Count > 0) and
    (ASubTkStack.DynArray[ASubTkStack.Count-1].Id = tk_SemiColon)) do
      Dec(ASubTkStack.Count);
  SimplifyNegatives(ASubTkStack);

  AIndex := LIndex;
end;

function NegativeOf(const AParam: PEngineContextValue): PEngineContextValue;
var
  cv_ConstBool: PEngineContextValueConstBool absolute AParam;
  cv_ConstInt: PEngineContextValueConstInt absolute AParam;
  cv_Negative: PEngineContextValueNegative absolute AParam;
begin
  case AParam.FTypeId of
    //EngCtxValueTpId_ConstBool:
    //  begin
    //    cv_ConstBool.FConstValue := (not cv_ConstBool.FConstValue);
    //    Exit(AParam);
    //  end;
    //EngCtxValueTpId_ConstInt:
    //  begin
    //    cv_ConstInt.FConstValue := (-cv_ConstInt.FConstValue);
    //    Exit(AParam);
    //  end;
    EngCtxValueTpId_Negative:
      begin
        Result := cv_Negative.FRefValue;
        EngineContextValue_Destroy(AParam^);
        Exit;
      end;
  end;

  Exit(Pointer(EngineContextValueNegative_Create(AParam)));
end;

function CreateContextValueByVariableRef(const AContext: PEngineContext;
  const AVarRef: PEngineContextVariableRef;
  const ARelContextIndex: Integer): PEngineContextValue;
var
  R: PEngineContextValueByVariableRef;
begin
  R := AllocMem(SizeOf(TEngineContextValueByVariableRef));
  R.FBase.FBase.FTypeId := EngCtxValueTpId_VariableRef;
  R.FBase.FVarIndex := AVarRef.FVariable.FIndex;
  R.FBase.FRelContextIndex := ARelContextIndex;
  R.FIndexRefClosureVar := AVarRef.FIndex;
  Exit(Pointer(R));
end;

function CreateContextValueByVariable0(
  const AContext: PEngineContext;
  const AVariable: PEngineContextVariable): PEngineContextValue;
var
  LRelIndex: Integer;
  R0: PEngineContextValueByVariable;
begin
  if (AVariable.FContext = Pointer(gvEngineContextGlobal)) then
  begin
    { Contexto Global }
    Exit(Pointer(EngineContextValueByVariableGlobal_Create(AVariable.FIndex)));
  end;

  LRelIndex := EngineContext_RelativeIndexOf(AContext^, AVariable.FContext);
  if (LRelIndex < 0) then
    raise EInternalError.Create('A80049BD22EE4837A5C314E4D30C7ECE');

//  R0 := AllocMem(SizeOf(TMyEngineContextValueByVariable));
//  R0.FVarIndex := AVariable.FIndex;
//
//  if (LRelIndex <> 0) then
//  begin
//    R0.FBase.FTypeId := TMyEngineContextValueTypeId.eVariableN;
//    R0.FRelContextIndex := LRelIndex;
//  end else
//    R0.FBase.FTypeId := TMyEngineContextValueTypeId.eVariable0;

  if (LRelIndex = 0) then
    Exit(Pointer(EngineContextValueByVariableLocal_Create(AVariable.FIndex)));

  Exit(CreateContextValueByVariableRef(AContext,
    EngineContext_FindOrDeclrVarRef(AContext^, AVariable, LRelIndex), LRelIndex));
end;

function CreateContextValueByVariable(const AContext: PEngineContext;
  const AToken: PToken): PEngineContextValue;
var
  LVar: PEngineContextVariable;
begin
  LVar := EngineContext_VarByName(AContext^, AToken);
  Exit(CreateContextValueByVariable0(AContext, LVar));
end;

function CreateContextValueByConstFunction(
  const AFunction: PEngineContextFunction): PEngineContextValue;
var
  R: PEngineContextValueConstFunction absolute Result;
begin
  Result := Pointer(AFunction.FConstDeclr);
  if (Result = nil) then
  begin
    R := AllocMem(SizeOf(TEngineContextValueConstFunction));
    R.FConstValue := AFunction;
    R.FBase.FTypeId := EngCtxValueTpId_ConstFunction;
    AFunction.FConstDeclr := R;
  end;
end;

function CreateContextValueByConstArray(
  var AArray: TFennerDataDynArray): PEngineContextValue;
var
  R: PEngineContextValueConstArray absolute Result;
begin
  R := AllocMem(SizeOf(TEngineContextValueConstArray));
  R.FConstValue := AArray;
  R.FBase.FTypeId := EngCtxValueTpId_ConstArray;
end;

function CreateEngineContextValueByData(
  const AData: PFennerData): PEngineContextValue;
begin
  case AData.vId of
    dttp_Bool: Exit(Pointer(EngineContextValueConstBool_Create(AData.vBool)));
    dttp_Int: Exit(Pointer(EngineContextValueConstInt_Create(AData.vInt)));
    dttp_Str: Exit(Pointer(EngineContextValueConstStr_Create(LString(AData.vStr))));
    dttp_Func:
      begin
        if (AData.vId2 = Id2_Func_Default) then
          Exit(CreateContextValueByConstFunction(AData.vFn));
      end;
    dttp_Array:
      Exit(CreateContextValueByConstArray(TFennerDataDynArray(AData.vArr)));
  end;
  Exit(nil);
end;

function CreateContextValueByToken(const AContext: PEngineContext;
  const AToken: PToken): PEngineContextValue;
begin
  case AToken.Id of
    tk_Identifier: Exit(CreateContextValueByVariable(AContext, AToken));
    tk_String: Exit(Pointer(EngineContextValueConstStr_Create(AToken.Vds)));
    tk_Integer: Exit(Pointer(EngineContextValueConstInt_Create(AToken.vdi)));
    tkrw_False: Exit(Pointer(EngineContextValueConstBool_Create(False)));
    tkrw_True: Exit(Pointer(EngineContextValueConstBool_Create(True)));
    tk_RefValue_: Exit(GetRefValue(AToken));
    tk_Recursive:
      if (AContext.FTypeId = EngCtxTp_Function) then
      begin
        SetRefValue(AToken, CreateContextValueByConstFunction(
          PEngineContextFunction(AContext)));
        Exit(GetRefValue(AToken));
      end;
  end;

  if (AToken.Id in SetOf_rw_Funcs) then
    Exit(CreateContextValueByVariable(AContext, AToken));

  raise EUnexpectedToken.Create(AToken);
end;

function SubExpression(const AContext: PEngineContext;
  const L, R: PToken; Op: Byte): PEngineContextValue;
var
  p0, p1: PEngineContextValue;
begin
  p0 := CreateContextValueByToken(AContext, L);
  p1 := CreateContextValueByToken(AContext, R);

  Exit(Pointer(EngineContextValueOp2_Create(p0, p1, Op)));
end;

function SubExpressionFact(const AContext: PEngineContext;
  const AToken: PToken): PEngineContextValue;
begin
  Exit(EngineContextValueFact_Create(
    CreateContextValueByToken(AContext, AToken)));
end;

function SubExpressionOrAnd(const AContext: PEngineContext;
  const L, R: PToken; Op: Byte): PEngineContextValue;
var
  LOp2: PEngineContextValueOp2 absolute Result;
begin
  Result := SubExpression(AContext, L, R, Op);
  if (Result.FTypeId = EngCtxValueTpId_Op2) then
    case Op of
      tkop_Or: Result.FTypeId := EngCtxValueTpId_Op2Or;
      tkop_And: Result.FTypeId := EngCtxValueTpId_Op2And;
    end;
end;

function ResolveExpression_7_CallFunction(var ATokenStack: TTokenStack;
  const AContext: PEngineContext; var AReturnValue: PEngineContextValue): Boolean;
var
  LTk: PToken;
  LValue: PEngineContextValue;
  LCaller: PEngineCaller;
begin
  if (ATokenStack.Count <= 0) then Exit(False);
  LTk := ATokenStack.DynArray[0];
  if (LTk.Id <> tk_RefValue_) then Exit(False);
  LValue := LTk.p;

  if (LValue.FTypeId = EngCtxValueTpId_ConstArray) then
  begin
    TokenStack_Delete(ATokenStack, 0, 1);
    AReturnValue := LValue;
    Exit(True);
  end;

  if (ATokenStack.Count < 2) then Exit(False);

  if (LValue.FTypeId = EngCtxValueTpId_ConstFunction) then
  begin
    LTk := ATokenStack.DynArray[1];
    if (LTk.Id = tk_RefValue_) then
    begin
      LCaller := TEngineCaller.Create(AContext, nil, ATokenStack.DynArray[0]);
      try
        LValue := LTk.p;
        case LValue.FTypeId of
          EngCtxValueTpId_Array:
            begin
              LCaller.AddParams(PEngineContextValueArray(LValue));
              AReturnValue := LCaller.Build;
              TokenStack_Delete(ATokenStack, 0, 2);
              Exit(True);
            end;
          EngCtxValueTpId_ConstArray:
            begin
              LCaller.AddParams2(PEngineContextValueConstArray(LValue));
              AReturnValue := LCaller.Build;
              TokenStack_Delete(ATokenStack, 0, 2);
              Exit(True);
            end;
          else
          //EngCtxValueTpId_ConstBool,
          //EngCtxValueTpId_ConstInt,
          //EngCtxValueTpId_ConstString,
          //EngCtxValueTpId_ConstFunction:
            begin
              LCaller.AddParam(LValue);
              AReturnValue := LCaller.Build;
              TokenStack_Delete(ATokenStack, 0, 2);
              Exit(True);
            end;
        end;
      finally
        Free_EngineCaller(LCaller);
      end;
    end;
  end;
  Exit(False);
end;

function ResolveExpression_7(var ATokenStack: TTokenStack;
  const AContext: PEngineContext): PEngineContextValue;
var
  i: Integer;
  Tk: PToken;
  LSubTkStack: TTokenStack;
  LIf: PEngineContextValueIf;
begin
  i := 0;
  if (ATokenStack.Count = 1) then
    Exit(CreateContextValueByToken(AContext, ATokenStack.DynArray[0]));
  if (ATokenStack.Count = 0) then
    Exit(@c_EngCtxValueConstArrayEmpty);

  Tk := ATokenStack.DynArray[i];
  if (Tk.Id = tkrw_If) then
  begin
    Inc(i);
    if (i >= ATokenStack.Count) then
      raise EBuilderUnexpectedEof.Create(ATokenStack.DynArray[i - 1]);

    Tk := ATokenStack.DynArray[i];
    if (Tk.Id = tk_RefValue_) then
    begin
      TokenStack_CopyBy(LSubTkStack, ATokenStack, i, 1);
      Inc(i);
    end else
      SelectTokens_p_OpenClose(ATokenStack, LSubTkStack, i);

    LIf := AllocMem(SizeOf(TEngineContextValueIf));
    LIf.FBase.FTypeId := EngCtxValueTpId_If;

    LIf.FExpression := ResolveExpression(LSubTkStack, AContext, False);
    LIf.FThen := ReadItemBlock(ATokenStack, AContext, i, True);

    if ((i < ATokenStack.Count) and
      (ATokenStack.DynArray[i].Id = tkrw_Else)) then
    begin
      Inc(i);
      if (i >= ATokenStack.Count) then
        raise EBuilderUnexpectedEof.Create2(ATokenStack);
      LIf.FElse := ReadItemBlock(ATokenStack, AContext, i, True);
    end;

    Exit(Pointer(LIf));
  end;
  if ResolveExpression_7_CallFunction(ATokenStack, AContext, Result) then Exit;

  raise EInternalError.Create('A0C820DE07AE4409A4A27B10BA1C64F4');
end;

function ResolveExpression_6(var ATokenStack: TTokenStack;
  const AContext: PEngineContext): PEngineContextValue;
label
  lbTryAgain;
var
  i, j: Integer;
  Tk: PToken;
  LValue: PEngineContextValue;
begin
  i := 0;
  lbTryAgain: ;
  j := (ATokenStack.Count - 1);
  while (i <= j) do
  begin
    Tk := ATokenStack.DynArray[i];
    case Tk.Id of
      tkop_Or,
      tkop_And:
        begin
          if (i < j) then
          begin
            LValue := SubExpressionOrAnd(AContext,
              ATokenStack.DynArray[i - 1],
              ATokenStack.DynArray[i + 1], Tk.Id);

            SetRefValue(ATokenStack.DynArray[i - 1], LValue);
            TokenStack_Delete(ATokenStack, i + 1, 2);
            goto lbTryAgain;
          end;
        end;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_7(ATokenStack, AContext));
end;

function ResolveExpression_5(var ATokenStack: TTokenStack;
  const AContext: PEngineContext): PEngineContextValue;
label
  lbTryAgain;
var
  i: Integer;
  Tk: PToken;
  LValue: PEngineContextValue;
begin
  i := 0;
  lbTryAgain: ;
  while (i < ATokenStack.Count) do
  begin
    Tk := ATokenStack.DynArray[i];
    case Tk.Id of
      tkop_Eq,
      tkop_Neq,
      tkop_Lt,
      tkop_Gt,
      tkop_Lte,
      tkop_Gte:
        begin
          LValue := SubExpression(AContext,
            ATokenStack.DynArray[i - 1],
            ATokenStack.DynArray[i + 1], Tk.Id);

          SetRefValue(ATokenStack.DynArray[i - 1], LValue);
          TokenStack_Delete(ATokenStack, i, 2);
          goto lbTryAgain;
        end;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_6(ATokenStack, AContext));
end;

function ResolveExpression_4(var ATokenStack: TTokenStack;
  const AContext: PEngineContext): PEngineContextValue;
label
  lbTryAgain;
var
  i, j: Integer;
  Tk: PToken;
  LValue: PEngineContextValue;
begin
  i := 0;
  lbTryAgain: ;
  j := (ATokenStack.Count - 1);
  while (i <= j) do
  begin
    Tk := ATokenStack.DynArray[i];
    case Tk.Id of
      tkop_Add,
      tkop_Sub:
        if (i > 0) then
        begin
          if (i < j) then
          begin
            LValue := SubExpression(AContext,
              ATokenStack.DynArray[i - 1],
              ATokenStack.DynArray[i + 1], Tk.Id);

            SetRefValue(ATokenStack.DynArray[i - 1], LValue);
            TokenStack_Delete(ATokenStack, i, 2);
            goto lbTryAgain;
          end;
        end else
        begin
          if (Tk.Id = tkop_Add) then
          begin
            TokenStack_Delete(ATokenStack, i, 1);
            goto lbTryAgain;
          end;

          LValue := NegativeOf(CreateContextValueByToken(
            AContext, ATokenStack.DynArray[i + 1]));

          SetRefvalue(Tk, LValue);
          TokenStack_Delete(ATokenStack, i + 1, 1);
          goto lbTryAgain;
        end;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_5(ATokenStack, AContext));
end;

function ResolveExpression_3(var ATokenStack: TTokenStack;
  const AContext: PEngineContext): PEngineContextValue;
label
  lbTryAgain;
var
  i: Integer;
  Tk: PToken;
  LValue: PEngineContextValue;
begin
  i := 0;
  lbTryAgain: ;
  while (i < ATokenStack.Count) do
  begin
    Tk := ATokenStack.DynArray[i];
    case Tk.Id of
      tkop_Mul,
      tkop_Div,
      tkop_Rem:
        begin
          LValue := SubExpression(AContext,
            ATokenStack.DynArray[i - 1],
            ATokenStack.DynArray[i + 1], Tk.Id);

          SetRefValue(ATokenStack.DynArray[i - 1], LValue);
          TokenStack_Delete(ATokenStack, i, 2);
          goto lbTryAgain;
        end;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_4(ATokenStack, AContext));
end;

function ResolveExpression_2(var ATokenStack: TTokenStack;
  const AContext: PEngineContext): PEngineContextValue;
label
  lbTryAgain;
var
  i: Integer;
  Tk: PToken;
  LValue: PEngineContextValue;
begin
  i := 0;
  lbTryAgain: ;
  while (i < ATokenStack.Count) do
  begin
    Tk := ATokenStack.DynArray[i];
    case Tk.Id of
      tkop_Power:
        begin
          LValue := SubExpression(AContext,
            ATokenStack.DynArray[i - 1],
            ATokenStack.DynArray[i + 1], Tk.Id);

          SetRefValue(ATokenStack.DynArray[i - 1], LValue);
          TokenStack_Delete(ATokenStack, i, 2);
          goto lbTryAgain;
        end;
      tkop_Fact:
        begin
          LValue := SubExpressionFact(AContext, ATokenStack.DynArray[i - 1]);
          SetRefValue(ATokenStack.DynArray[i - 1], LValue);
          TokenStack_Delete(ATokenStack, i, 1);
          goto lbTryAgain;
        end;
      else
        Inc(i);
    end;
  end;

  Exit(ResolveExpression_3(ATokenStack, AContext));
end;

function ResolveExpression_1(var ATokenStack: TTokenStack;
  const AContext: PEngineContext): PEngineContextValue;
label
  lbTryAgain, lbTryAgain1;
var
  i, j, pCount: Integer;
  Tk, Tk2: PToken;
  SubTkStack: TTokenStack;
  LArrBuilder: PEngineArrayBuilder;
begin
  LArrBuilder := nil;
  i := 0;
lbTryAgain: ;
  while (i < ATokenStack.Count) do
  begin
    Tk := ATokenStack.DynArray[i];
    if (Tk.Id = tk_pOpen) then
    begin
      pCount := 0;
lbTryAgain1: ;
      j := (i + 1);
      repeat
        if (j >= ATokenStack.Count) then
          raise EUnexpectedEof.Create(ATokenStack.DynArray[ATokenStack.Count - 1]);
        Tk2 := ATokenStack.DynArray[j];
        case Tk2.Id of
          tk_pOpen:
            begin
              Inc(pCount);
              Inc(j);
            end;
          tk_pClose:
            if (pCount = 0) then
            begin
              if (LArrBuilder <> nil) then
              begin
                TokenStack_CopyBy(SubTkStack, ATokenStack, (i + 1), (j - i - 1));
                TokenStack_Delete(ATokenStack, (i + 1), (j - i));
                LArrBuilder.Add(ResolveExpression(SubTkStack, AContext, False));

                SetRefValue(Tk, LArrBuilder.Build());
                goto lbTryAgain;
              end else
              begin
                TokenStack_CopyBy(SubTkStack, ATokenStack, (i + 1), (j - i - 1));
                TokenStack_Delete(ATokenStack, (i + 1), (j - i));

                SetRefValue(Tk, ResolveExpression(SubTkStack, AContext, False));
                goto lbTryAgain;
              end;
            end else
            begin
              Inc(j);
              Dec(pCount);
            end;
          tk_Comma:
            if (pCount = 0) then
            begin
              TokenStack_CopyBy(SubTkStack, ATokenStack, (i + 1), (j - i - 1));
              TokenStack_Delete(ATokenStack, (i + 1), (j - i));

              if (LArrBuilder = nil) then
                LArrBuilder := TEngineArrayBuilder.Create;
              LArrBuilder.Add(ResolveExpression(SubTkStack, AContext, False));

              goto lbTryAgain1;
            end else
              Inc(j);
          tkrw_Array:
            begin
              Inc(j);
              if (j >= ATokenStack.Count) then
                raise EUnexpectedEof.Create(ATokenStack.DynArray[ATokenStack.Count - 1]);
            end;
          else
            Inc(j);
        end;
      until False;
    end else
      Inc(i);
  end;

  Exit(ResolveExpression_2(ATokenStack, AContext));
end;

procedure ReadItemBlockItemLetValue(const ABlock: PEngineContextBlock;
  const AVar: PEngineContextVariable; const AValue: PEngineContextValue;
  const AContext: PEngineContext);
var
  LLV0: PEngineContextBlockItemLetValue0;
  LLRef: PEngineContextBlockItemLetValueRef absolute LLV0;

  LConstBool: PEngineContextBlockItemLetConstBool absolute LLV0;
  LConstInt: PEngineContextBlockItemLetConstInt absolute LLV0;
  LConstStr: PEngineContextBlockItemLetConstStr absolute LLV0;
  LConstFunc: PEngineContextBlockItemLetConstFunction absolute LLV0;
  LConstArray: PEngineContextBlockItemLetConstArray absolute LLV0;
  LRelIndex: Integer;

  LVarContext: PEngineContext;
  LVarRef: PEngineContextVariableRef;
begin
  case AValue.FTypeId of
    EngCtxValueTpId_ConstBool:
      begin
        LConstBool := EngineContextBlockItemLetConstBool_Create(AVar.FIndex,
          PEngineContextValueConstBool(AValue).FConstValue);
        EngineContextBlock_ItemsAdd(ABlock^, Pointer(LConstBool));
        Exit;
      end;
    EngCtxValueTpId_ConstInt:
      begin
        LConstInt := EngineContextBlockItemLetConstInt_Create(AVar.FIndex,
          PEngineContextValueConstInt(AValue).FConstValue);
        EngineContextBlock_ItemsAdd(ABlock^, Pointer(LConstInt));
        Exit;
      end;
    EngCtxValueTpId_ConstString:
      begin
        LConstStr := EngineContextBlockItemLetConstStr_Create(AVar.FIndex,
          PEngineContextValueConstString(AValue).FConstValue);
        EngineContextBlock_ItemsAdd(ABlock^, Pointer(LConstStr));
        Exit;
      end;
    EngCtxValueTpId_ConstFunction:
      begin
        LConstFunc := EngineContextBlockItemLetConstFunc_Create(AVar.FIndex,
          PEngineContextValueConstFunction(AValue).FConstValue);
        EngineContextBlock_ItemsAdd(ABlock^, Pointer(LConstFunc));
        Exit;
      end;
    EngCtxValueTpId_ConstArray:
      begin
        LConstArray := EngineContextBlockItemLetConstArray_Create(AVar.FIndex,
          PEngineContextValueConstArray(AValue).FConstValue);
        EngineContextBlock_ItemsAdd(ABlock^, Pointer(LConstArray));
        Exit;
      end;
  end;

  LVarContext := AVar.FContext;
  LRelIndex := EngineContext_RelativeIndexOf(AContext^, LVarContext);
  if (LRelIndex = 0) then
  begin
    LLV0 := AllocMem(SizeOf(TEngineContextBlockItemLetValue0));
    LLV0.FConstValue := AValue;
    LLV0.FBase.FVarIndex := AVar.FIndex;
    LLV0.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetValue0;
    EngineContextBlock_ItemsAdd(ABlock^, Pointer(LLV0));
    Exit;
  end;

  if (LVarContext.FTypeId = EngCtxTp_Global) then
  begin

    Exit;
  end;

  LVarRef := EngineContext_FindOrDeclrVarRef(AContext^, AVar, LRelIndex);

  LLRef := AllocMem(SizeOf(TEngineContextBlockItemLetValueRef));
  LLRef.FValue := AValue;
  LLRef.FBase.FVarIndex := AVar.FIndex;
  LLRef.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetValueRef;
  LLRef.FRelativeContextIndex := LRelIndex;
  LLRef.FIndexRefClosureVar := LVarRef.FIndex;
  EngineContextBlock_ItemsAdd(ABlock^, Pointer(LLRef));
end;

procedure ReadItemBlockItem(var ATokenStack: TTokenStack;
  const AContext: PEngineContext; const ABlock: PEngineContextBlock;
  var AIndex: Integer);
label
  lb_TryAgain, lb_Let, lb_Let2, lb_RetOrCall;
var
  i, j: Integer;
  Tk, TkPrev: PToken;
  LOldVar, LVar: PEngineContextVariable;
  LValue: PEngineContextValue;
  LSubTkStack: TTokenStack;
  LIf: PEngineContextBlockItemIf;
  LWhile: PEngineContextBlockItemWhile;
  LCall: PEngineContextBlockItemCall;
  LReturn: PEngineContextBlockItemReturn;
  LBlock: PEngineContextBlock;
  LIsSet, LIsNegative: Boolean;
begin
  i := AIndex;
  if (i >= ATokenStack.Count) then Exit;

  LIsNegative := False;

lb_TryAgain:
  Tk := ATokenStack.DynArray[i];
  case Tk.Id of
    tk_Identifier,
    tk_String,
    tk_Integer,

    tkrw_Print,
    tkrw_First,
    tkrw_Second,
    tkrw_Third,
    tkrw_Fourth,
    tkrw_Fifth,
    tkrw_Sixth,
    tkrw_Seventh,
    tkrw_Eighth,
    tkrw_Ninth,
    tkrw_Tenth,
    tkrw_Function,
    tkrw_Array_GetItem,
    tkrw_Array_GetLength,
    tkrw_TypeOf,
    tkrw_Min,
    tkrw_Max,

    tkrw_False,
    tkrw_True,
    tk_pOpen,
    tk_RefValue_:
      begin
lb_RetOrCall:;
        SelectTokens_4Return(ATokenStack, LSubTkStack, i);
        LValue := ResolveExpression(LSubTkStack, AContext, False);
        if LIsNegative then
        begin
          LValue := NegativeOf(LValue);
          LIsNegative := False;
        end;

        if (AContext.FTypeId = EngCtxTp_Function) then
        begin
          LReturn := AllocMem(SizeOf(TEngineContextBlockItemReturn));
          LReturn.FBase.FTypeId := EngCtxBlkItemTpId_Return;
          LReturn.FSourceValue := LValue;
          EngineContextBlock_ItemsAdd(ABlock^, Pointer(LReturn));
        end else
        begin
          LCall := AllocMem(SizeOf(TEngineContextBlockItemCall));
          LCall.FBase.FBase.FTypeId := EngCtxBlkItemTpId_Call;
          LCall.FSourceValue := LValue;
          EngineContextBlock_ItemsAdd(ABlock^, Pointer(LCall));
        end;
      end;
    tk_Recursive:
      begin
        if (AContext.FTypeId = EngCtxTp_Function) then
        begin
          LValue := CreateContextValueByConstFunction(
            PEngineContextFunction(AContext));
          if LIsNegative then
          begin
            LValue := NegativeOf(LValue);
            LIsNegative := False;
          end;

          SetRefValue(Tk, LValue);
          goto lb_RetOrCall;
        end;
        raise EUnexpectedToken.Create(Tk);
      end;
    tkrw_Let:
      begin
        LIsSet := False;
lb_Let: ;
        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.Create(ATokenStack.DynArray[i - 1]);

        Tk := ATokenStack.DynArray[i];
        if (Tk.Id <> tk_Identifier) then
          raise EBuilderVariableNameExpected.Create(Tk);

        if LIsSet then
          LVar := EngineContext_FindOrDeclrVar(AContext^, Tk.vds)
        else
          LVar := EngineContext_FindOrDeclrVar(AContext^, Tk.vds);

        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.Create(ATokenStack.DynArray[i - 1]);

        Tk := ATokenStack.DynArray[i];
        if (Tk.Id <> tk_Assign) then
          raise EBuilderAssignExpected.Create(Tk);

        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.Create(ATokenStack.DynArray[i - 1]);

        SelectTokens_4Return(ATokenStack, LSubTkStack, i);

        LOldVar := AContext.FReadingVar;
        AContext.FReadingVar := LVar;
        LValue := ResolveExpression(LSubTkStack, AContext, True);
        if LIsNegative then
        begin
          LValue := NegativeOf(LValue);
          LIsNegative := False;
        end;

        ReadItemBlockItemLetValue(ABlock, LVar, LValue, AContext);
        AContext.FReadingVar := LOldVar;
      end;
    tkrw_Set:
      begin
        LIsSet := True;
        goto lb_Let;
      end;
    tkrw_If:
      begin
        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.Create(ATokenStack.DynArray[i - 1]);

        if (ATokenStack.DynArray[i].Id = tk_RefValue_) then
        begin
          LValue := ATokenStack.DynArray[i].p;
          Inc(i);
        end else
        begin
          SelectTokens_p_OpenClose(ATokenStack, LSubTkStack, i);
          LValue := ResolveExpression(LSubTkStack, AContext, False);
        end;

        LIf := AllocMem(SizeOf(TEngineContextBlockItemIf));
        LIf.FBase.FTypeId := EngCtxBlkItemTpId_If;
        EngineContextBlock_ItemsAdd(ABlock^, Pointer(LIf));

        //LValue := ResolveExpression(LSubTkStack, AContext, False);
        if LIsNegative then
        begin
          LValue := NegativeOf(LValue);
          LIsNegative := False;
        end;

        LIf.FExpression := LValue;
        LIf.FThen := ReadItemBlock(ATokenStack, AContext, i, True);

        if ((i < ATokenStack.Count) and
          (ATokenStack.DynArray[i].Id = tkrw_Else)) then
        begin
          Inc(i);
          if (i >= ATokenStack.Count) then
            raise EBuilderUnexpectedEof.Create2(ATokenStack);

          if (ATokenStack.DynArray[i].Id = tkrw_If) then
          begin
            LBlock := AllocMem(SizeOf(TEngineContextBlock));
            LIf.FElse := LBlock;
            ReadItemBlockItem(ATokenStack, AContext, LBlock, i);
          end else
            LIf.FElse := ReadItemBlock(ATokenStack, AContext, i, True);
        end;
      end;
    tkrw_While:
      begin
        Inc(i);

        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.Create(ATokenStack.DynArray[i - 1]);

        SelectTokens_p_OpenClose(ATokenStack, LSubTkStack, i);

        LWhile := AllocMem(SizeOf(TEngineContextBlockItemWhile));
        LWhile.FBase.FTypeId := EngCtxBlkItemTpId_While;
        EngineContextBlock_ItemsAdd(ABlock^, Pointer(LWhile));

        LValue := ResolveExpression(LSubTkStack, AContext, False);
        if LIsNegative then
        begin
          LValue := NegativeOf(LValue);
          LIsNegative := False;
        end;

        LWhile.FExpression := LValue;
        LWhile.FBlock := ReadItemBlock(ATokenStack, AContext, i, True);
      end;
    tk_SemiColon: Inc(i);
    tkop_Add: Inc(i);
    tkop_Sub:
      begin
        LIsNegative := (not LIsNegative);
        Inc(i);
        if (i < ATokenStack.Count) then goto lb_TryAgain;
        Dec(i);
      end;
    else
      raise EUnexpectedToken.Create(Tk);
  end;
  AIndex := i;
end;

function ReadItemBlock(var ATokenStack: TTokenStack;
  const AContext: PEngineContext; var AIndex: Integer;
  const AIsLoose: Boolean): PEngineContextBlock;
label
  lb_Block;
var
  i, j: Integer;
  Tk: PToken;
  LRefBlock, LBlock: PEngineContextBlock;
begin
  i := AIndex;
  if (i >= ATokenStack.Count) then
    raise EBuilderUnexpectedEof.Create(ATokenStack.DynArray[i - 1]);

  Tk := ATokenStack.DynArray[i];
  if (Tk.Id = tk_bOpen) then
  begin
lb_Block: ;
    Inc(i);

    LBlock := AllocMem(SizeOf(TEngineContextBlock));
    LBlock.FContext := AContext;

    if (not AIsLoose) then
    begin
      LRefBlock := AContext.FBlocks;
      if (LRefBlock <> nil) then
      begin
        while (LRefBlock.FNext <> nil) do
          LRefBlock := LRefBlock.FNext;
        LRefBlock.FNext := LBlock;
      end else
        AContext.FBlocks := LBlock
    end;

    repeat
      if (i >= ATokenStack.Count) then
        raise EBuilderUnexpectedEof.Create(ATokenStack.DynArray[i - 1]);

      Tk := ATokenStack.DynArray[i];
      if (Tk.Id = tk_bClose) then
      begin
        Inc(i);
        AIndex := i;
        Exit(LBlock);
      end;

      ReadItemBlockItem(ATokenStack, AContext, LBlock, i);
    until False;
    Exit(LBlock);
  end;

  j := i;
  while (j < ATokenStack.Count) do
  begin
    Tk := ATokenStack.DynArray[j];
    case Tk.Id of
      tkrw_Else,
      tk_bClose,
      tk_SemiColon: Break;
      else
        Inc(j);
    end;
  end;

  if (j < i) then Exit(nil);

  TokenStack_Insert(ATokenStack, j, Token_CreateVirtual(tk_bClose));
  TokenStack_Insert(ATokenStack, i, Token_CreateVirtual(tk_bOpen));

//  Tk := ATokenStack.DynArray[i];
  goto lb_Block;
end;

function ReadFunction(var ATokenStack: TTokenStack;
  const AContext: PEngineContext; var AIndex: Integer;
  const AByLet: Boolean): PEngineContextValue;
var
  i: Integer;
  Tk: PToken;
  LFunction: PEngineContextFunction;
  LLPar, LPar: PEngineContextVariable;
  LValue: PEngineContextValueConstFunction;
begin
  i := (AIndex + 1);
  if (i >= ATokenStack.Count) then
    raise EUnexpectedEof.Create(ATokenStack.DynArray[ATokenStack.Count - 1]);

  LFunction := AllocMem(SizeOf(TEngineContextFunction));
  LFunction.FBase.FTypeId := EngCtxTp_Function;
  LFunction.FBase.FOwner := AContext;

  if AByLet then
  begin
    LPar := AContext.FReadingVar;
    if (LPar <> nil) then
    begin
      FennerData_SetAsFunction(LPar.FData, Id2_Func_Default, LFunction);
      LFunction.FDeclrName := LPar.FName;
    end;
  end;

  Tk := ATokenStack.DynArray[i];
  if (Tk.Id = tk_pOpen) then
  begin
    LLPar := nil;
    repeat
      Inc(i);
      if (i >= ATokenStack.Count) then
        raise EUnexpectedEof.Create(ATokenStack.DynArray[ATokenStack.Count - 1]);

      Tk := ATokenStack.DynArray[i];
      if ((LLPar = nil) and (Tk.Id = tk_pClose)) then
      begin
        Inc(i);
        Break;
      end;

      if (Tk.Id <> tk_Identifier) then
        raise EBuilderVariableNameExpected.Create(Tk);

      LPar := AllocMem(SizeOf(TEngineContextVariable));
      LPar.FContext := Pointer(LFunction);
      LPar.FName := Tk.vds;
      LPar.FIndex := LFunction.FBase.FVarsCount;
      Inc(LFunction.FBase.FVarsCount);
      Inc(LFunction.FMinParamsCount);
      Inc(LFunction.FMaxParamsCount);

      if (LLPar = nil) then
        LFunction.FBase.FVarsFirst := LPar
      else
        LLPar.FNext := LPar;

      LLPar := LPar;

      Inc(i);
      if (i >= ATokenStack.Count) then
        raise EUnexpectedEof.Create(ATokenStack.DynArray[ATokenStack.Count - 1]);

      Tk := ATokenStack.DynArray[i];
      if (Tk.Id = tk_pClose) then
      begin
        Inc(i);
        Break;
      end;

      if (Tk.Id <> tk_Comma) then
        raise EUnexpectedToken.Create(Tk);
    until False;
  end;

  if (i >= ATokenStack.Count) then
    raise EUnexpectedEof.Create(ATokenStack.DynArray[ATokenStack.Count - 1]);

  Tk := ATokenStack.DynArray[i];
  if (Tk.Id <> tk_AssignProc) then
    raise EUnexpectedToken.Create(Tk);

  Inc(i);
  if (i >= ATokenStack.Count) then
    raise EUnexpectedEof.Create(ATokenStack.DynArray[ATokenStack.Count - 1]);

  ReadItemBlock(ATokenStack, Pointer(LFunction), i, False);
  AIndex := i;

  LValue := AllocMem(SizeOf(TEngineContextValueConstFunction));
  LValue.FConstValue := LFunction;
  LValue.FBase.FTypeId := EngCtxValueTpId_ConstFunction;

  EngineFunction_GetDeclrName(LFunction^);
  if (not EngineFunction_TryOptimize(LFunction^)) then
    EngineFunction_SetTypeId(LFunction^, EngCtxFnTpId_AST);

  EngineFunction_Validate(LFunction);
  EngineFunction_CheckRecursive(LFunction^);

  Exit(Pointer(LValue));
end;

function ResolveExpression(var ATokenStack: TTokenStack;
  const AContext: PEngineContext; const AByLet: Boolean): PEngineContextValue;
label lbTryAgain;
var
  i, j, pCount, LStart: Integer;
  Tk, Tk1: PToken;
  LVar: PEngineContextVariable;
  LCaller: PEngineCaller;
  SubTkStack: TTokenStack;
  LIsNegative: Boolean;
begin
  LIsNegative := False;
  i := 0;
  lbTryAgain: ;
  while (i < ATokenStack.Count) do
  begin
    Tk := ATokenStack.DynArray[i];
    if (Tk.Id = tkrw_Function) then
    begin
      LStart := i;
      SetRefValue(Tk, ReadFunction(ATokenStack, AContext, i, AByLet));
      TokenStack_Delete(ATokenStack, LStart + 1, (i - LStart - 1));
      i := LStart;
      goto lbTryAgain;
    end else
    if (Tk.Id in (SetOf_rw_Funcs_AndId + [tk_RefValue_, tk_Recursive])) then
    begin
      j := (i + 1);
      if ((j < ATokenStack.Count) and
        (ATokenStack.DynArray[j].Id = tk_pOpen)) then
      begin
        if (Tk.Id in SetOf_rw_Funcs_AndId) then
          LVar := EngineContext_VarByName(AContext^, Tk)
        else
          LVar := nil;

        LCaller := TEngineCaller.Create(AContext, LVar, Tk);

        Inc(j);
        if (j >= ATokenStack.Count) then
          raise EUnexpectedEof.Create(ATokenStack.DynArray[ATokenStack.Count - 1]);

        Tk := ATokenStack.DynArray[j];
        if (Tk.Id = tk_pClose) then
        begin
          { Sem Parâmetros }
          TokenStack_Delete(ATokenStack, (i + 1), (j - i));
        end else
        begin
          { Com Parâmetros }
          pCount := 0;
          LStart := j;
          repeat
            Tk := ATokenStack.DynArray[j];
            case Tk.Id of
              tk_Comma:
                begin
                  if (pCount = 0) then
                  begin
                    TokenStack_CopyBy(SubTkStack, ATokenStack, LStart, (j - LStart));
                    LCaller.AddParam(
                      ResolveExpression(SubTkStack, AContext, False));
                    LStart := (j + 1);
                  end;
                end;
              tk_pOpen: Inc(pCount);
              tk_pClose:
                begin
                  if (pCount = 0) then
                  begin
                    TokenStack_CopyBy(SubTkStack, ATokenStack, LStart, (j - LStart));
                    LCaller.AddParam(
                      ResolveExpression(SubTkStack, AContext, False));
                    Break;
                  end;
                  Dec(pCount);
                end;
            end;
            Inc(j);
            if (j >= ATokenStack.Count) then
            begin
              if (pCount = 0) then
              begin
                TokenStack_CopyBy(SubTkStack, ATokenStack, LStart, (j - LStart));
                LCaller.AddParam(
                  ResolveExpression(SubTkStack, AContext, False));
                Break;
              end;
              raise EUnexpectedEof.Create(
                ATokenStack.DynArray[ATokenStack.Count - 1]);
            end;
          until False;
          TokenStack_Delete(ATokenStack, (i + 1), (j - i));
        end;

        Tk := ATokenStack.DynArray[i];
        if LIsNegative then
        begin
          LIsNegative := False;
          SetRefValue(Tk, NegativeOf(LCaller.Build()));
        end else
          SetRefValue(Tk, LCaller.Build());

        Free_EngineCaller(LCaller);
        goto lbTryAgain;
      end else
      if LIsNegative then
      begin
        LIsNegative := False;

        SetRefValue(Tk, NegativeOf(CreateContextValueByVariable(AContext, Tk)));
        goto lbTryAgain;
      end;
    end else
    if (Tk.Id = tk_Negative) then
    begin
      Tk1 := ATokenStack.DynArray[i + 1];
      if (Tk1.Id = tk_Identifier) then
      begin
        LIsNegative := True;
        TokenStack_Delete(ATokenStack, i, 1);
        goto lbTryAgain;
      end;
    end;
    Inc(i);
  end;

  Exit(ResolveExpression_1(ATokenStack, AContext));
end;

function EngineContext_CreateSysFunc(var This: TEngineContextGlobal;
  const AName: LString; const ATypeId: Byte): PEngineContextFunction;
var
  LVar: PEngineContextVariable;
  LFunc: PEngineContextFunction;
  LBlock: PEngineContextBlock;
  R: PEngineContextBlockItemLetConstFunction;
begin
  LFunc := AllocMem(SizeOf(TEngineContextFunction));
  LFunc.FTypeId := ATypeId;
  LFunc.FBase.FOwner := @This;
  LFunc.FBase.FTypeId := EngCtxTp_Function;

  LBlock := This.FBase.FBlocks;
  if (LBlock = nil) then
  begin
    LBlock := AllocMem(SizeOf(TEngineContextBlock));
    This.FBase.FBlocks := LBlock;
  end;

  LVar := EngineContext_LocalFindOrDeclrVar(This.FBase, AName);
  R := AllocMem(SizeOf(TEngineContextBlockItemLetConstFunction));
  R.FConstValue := LFunc;
  R.FBase.FVarIndex := LVar.FIndex;
  R.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstFunction;

  EngineContextBlock_ItemsAdd(LBlock^, Pointer(R));

  Exit(LFunc);
end;

procedure EngineContext_CreateSysFunc_Def(var This: TEngineContextGlobal;
  const AName: LString; const ATypeId: Byte;
  const AParamCount: Integer);
var
  LFunc: PEngineContextFunction;
begin
  LFunc := EngineContext_CreateSysFunc(This, AName, ATypeId);
  LFunc.FMinParamsCount := AParamCount;
  LFunc.FMaxParamsCount := AParamCount;
  LFunc.FFlags := EngCtxFnFlgId_Native;
end;

procedure EngineContext_CreateSysFunc_MultiCount(
  var This: TEngineContextGlobal;
  const AName: LString; const ATypeId: Byte;
  const AMinParamsCount: Integer;
  const AFlags: word);
var
  LFunc: PEngineContextFunction;
begin
  LFunc := EngineContext_CreateSysFunc(This, AName, ATypeId);
  LFunc.FMinParamsCount := AMinParamsCount;
  LFunc.FMaxParamsCount := $ffff;
  LFunc.FFlags := (AFlags or EngCtxFnFlgId_Native);
end;

procedure EngineContext_CreateSysFunc_ArrayGetItems(
  var This: TEngineContextGlobal);
begin
  EngineContext_CreateSysFunc_Def(This, 'first', EngCtxFnTpId_First, 1);
  EngineContext_CreateSysFunc_Def(This, 'second', EngCtxFnTpId_Second, 1);
  EngineContext_CreateSysFunc_Def(This, 'third', EngCtxFnTpId_Third, 1);
  EngineContext_CreateSysFunc_Def(This, 'fourth', EngCtxFnTpId_Fourth, 1);
  EngineContext_CreateSysFunc_Def(This, 'fifth', EngCtxFnTpId_Fifth, 1);
  EngineContext_CreateSysFunc_Def(This, 'sixth', EngCtxFnTpId_Sixth, 1);
  EngineContext_CreateSysFunc_Def(This, 'seventh', EngCtxFnTpId_Seventh, 1);
  EngineContext_CreateSysFunc_Def(This, 'eighth', EngCtxFnTpId_Eighth, 1);
  EngineContext_CreateSysFunc_Def(This, 'ninth', EngCtxFnTpId_Ninth, 1);
  EngineContext_CreateSysFunc_Def(This, 'tenth', EngCtxFnTpId_Tenth, 1);
end;

procedure EngineContext_CreateSysFuncs(var This: TEngineContextGlobal);
begin
  EngineContext_CreateSysFunc_ArrayGetItems(This);
  EngineContext_CreateSysFunc_Def(This, 'array_length', EngCtxFnTpId_Array_Length, 1);
  EngineContext_CreateSysFunc_Def(This, 'array_item',  EngCtxFnTpId_Array_Item, 2);
  EngineContext_CreateSysFunc_Def(This, 'typeof', EngCtxFnTpId_TypeOf, 1);
  EngineContext_CreateSysFunc_MultiCount(
    This, 'print', EngCtxFnTpId_Print, 0, EngCtxFnFlgId_Prohibited_Cache);
  EngineContext_CreateSysFunc_Multicount(
    This, 'min', EngCtxFnTpId_Min, 2, 0);
  EngineContext_CreateSysFunc_Multicount(
    This, 'max', EngCtxFnTpId_Max, 2, 0);
end;

procedure EngineContext_Parse(var This: TEngineContext;
  var TokenStack: TTokenStack; var Index: Integer); assembler; nostackframe;
//var
//  LBlock: PEngineContextBlock;
//  LIndex: Integer;
//begin
//  LBlock := This.FBlocks;
//  if (LBlock = nil) then
//  begin
//    LBlock := AllocMem(SizeOf(TEngineContextBlock));
//    LBlock.FContext := @This;
//    This.FBlocks := LBlock;
//  end;
//
//  LIndex := Index;
//  while (LIndex < TokenStack.Count) do
//    ReadItemBlockItem(TokenStack, @This, LBlock, LIndex);
//  Index := LIndex;
//end;
asm
    push rdi { This:[rsp] }
    push rsi { This:[rsp+8], TokenStack:[rsp] }
    push rdx { This:[rsp+16], TokenStack:[rsp+8], Index:[rsp] }
    mov  rdx, [rdx]
    push rdx { This:[rsp+24], TokenStack:[rsp+16], @Index:[rsp+8], ^Index:[rsp]}

    mov rax, [rdi + TEngineContext.FBlocks]
    test rax, rax
    jnz @a

    mov rdi, SizeOf(TEngineContextBlock)
    call AllocMem

    mov rdi, [rsp + 24]
    mov [rax + TEngineContextBlock.FContext], rdi
    mov [rdi + TEngineContext.FBlocks], rax

    mov rsi, [rsp + 16]
    mov rdx, [rsp]
@a:
    push rax { This:[rsp + 32],
               TokenStack:[rsp + 24],
               @Index:[rsp + 16],
               ^Index:[rsp + 8],
               LBlock:[rsp] }

    lea r9,  [rsi + TTokenStack.Count]
    xor r8,  r8
    mov r8d, [r9]

    push r8  { This:[rsp + 40],
               TokenStack:[rsp + 32],
               @Index:[rsp + 24],
               ^Index:[rsp + 16],
               LBlock:[rsp + 8],
               TkSckCount:[rsp]}
@b:
    cmp rdx, r8
    jnb @c

    mov rdi, [rsp + 32] { TokenStack }
    mov rsi, [rsp + 40] { This }
    mov rdx, [rsp + 8]  { LBlock }
    mov rcx, [rsp + 24] { @Index }

    call ReadItemBlockItem
    mov r8, [rsp]       { recupera o valor de r8 }

    mov rdx, [rsp + 24] { recupera o indice }
    mov rdx, [rdx]
    jmp @b
@c:
    add rsp, 48
end;

procedure EngineContext_ParseGlobal(var This: TEngineContext);
  assembler; nostackframe;
{$j+}
const
  Index: Integer = 0;
{$j-}
asm
    xor rax, rax
    mov rdx, Offset Index
    mov rsi, Offset gvTokens
    jmp EngineContext_Parse
end;

function EngineContext_RelativeIndexOf(var This: TEngineContext;
  const AContext: PEngineContext): Integer; assembler; nostackframe;
asm
    test rsi, rsi
    jz AsmRet_Neg_1
    xor rax, rax
@a:
    cmp rsi, rdi
    jz AsmRet
    test rdi, rdi
    jz AsmRet_Neg_1
    mov rdi, [rdi + TEngineContext.FOwner]
    inc rax
    jmp @a
end;

function EngineContext_FindVar(var This: TEngineContext;
  const AName: LString): PEngineContextVariable;
var
  LContext: PEngineContext;
  LVar: PEngineContextVariable;
begin
  LContext := @This;
  while (LContext <> nil) do
  begin
    LVar := LContext.FVarsFirst;
    while (LVar <> nil) do
    begin
      if (LVar.FName = AName) then
      begin
        if ((LVar.FContext <> @This) and
          (LVar.FContext.FTypeId = EngCtxTp_Function) and
          (This.FTypeId = EngCtxTp_Function)) then
        begin
          LVar.FContext.FCanFinalizeRefClosureVar := True;
          Exit(LVar);
        end;

        Exit(LVar);
      end;
      LVar := LVar.FNext;
    end;
    LContext := LContext.FOwner;
  end;
  Exit(nil);
end;

function EngineContext_FindOrDeclrVar(var This: TEngineContext;
  const AName: LString): PEngineContextVariable;
var
  LVar: PEngineContextVariable;
begin
  LVar := EngineContext_FindVar(This, AName);
  if (LVar <> nil) then
    Exit(LVar);
  Exit(EngineContext_LocalFindOrDeclrVar(This, AName));
end;

function EngineContext_LocalFindOrDeclrVar(var This: TEngineContext;
  const AName: LString): PEngineContextVariable;
var
  LVar: PEngineContextVariable;
begin
  LVar := This.FVarsFirst;
  if (LVar = nil) then
  begin
    LVar := AllocMem(SizeOf(TEngineContextVariable));
    LVar.FContext := @This;
    LVar.FName := AName;
    LVar.FIndex := This.FVarsCount;
    Inc(This.FVarsCount);
    This.FVarsFirst := LVar;
    Exit(LVar);
  end;

  repeat
    if (LVar.FName = AName) then Exit(LVar);

    Result := LVar.FNext;
    if (Result = nil) then
    begin
      Result := AllocMem(SizeOf(TEngineContextVariable));
      Result.FContext := @This;
      Result.FName := AName;
      Result.FIndex := This.FVarsCount;
      Inc(This.FVarsCount);
      LVar.FNext := Result;
      Exit;
    end;
    LVar := Result;
  until False;
end;

function EngineContext_FindOrDeclrVarRef(var This: TEngineContext;
  const AVariable: PEngineContextVariable;
  const ARelativeContextIndex: Integer): PEngineContextVariableRef;
var
  LVarRef, LNext: PEngineContextVariableRef;
begin
  LVarRef := This.FVarRefsFirst;
  if (LVarRef = nil) then
  begin
    LVarRef := AllocMem(SizeOf(TEngineContextVariableRef));
    LVarRef.FContext := @This;
    LVarRef.FVariable := AVariable;
    LVarRef.FRelativeContextIndex := ARelativeContextIndex;
    This.FVarRefsFirst := LVarRef;
    Inc(This.FVarRefsCount);
    Exit(LVarRef);
  end;

  repeat
    if (LVarRef.FVariable = AVariable) then Exit(LVarRef);

    LNext := LVarRef.FNext;
    if (LNext = nil) then
    begin
      LNext := AllocMem(SizeOf(TEngineContextVariableRef));
      LNext.FContext := @This;
      LNext.FVariable := AVariable;
      LNext.FRelativeContextIndex := ARelativeContextIndex;
      LNext.FIndex := This.FVarRefsCount;
      LVarRef.FNext := LNext;
      Inc(This.FVarRefsCount);
      Exit(LNext);
    end;

    LVarRef := LNext;
  until False;
end;

function EngineContext_VarByName(var This: TEngineContext;
  const AToken: PToken): PEngineContextVariable;
begin
  if (AToken.Id = tk_Identifier) then
    Result := EngineContext_FindVar(This, AToken.vds)
  else if (AToken.Id in SetOf_rw_Funcs) then
    Result := EngineContext_FindVar(This, sRwPrints[AToken.Id])
  else
    Result := nil;

  if (Result = nil) then
    raise EBuilderVariableNotFound.Create(AToken);
end;

function EngineContext_Root(var This: TEngineContext): PEngineContext;
var
  LNext: PEngineContext;
begin
  Result := @This;
  if (Result <> nil) then
  repeat
    LNext := Result.FOwner;
    if (LNext = nil) then Exit;
    Result := LNext;
  until False;
end;

function EngineContext_FindFirstLetConstFunction(var This: TEngineContext;
  const AVarIndex: Integer): PEngineContextBlockItemLetConstFunction;
var
  LBlock: PEngineContextBlock;
  LItem: PEngineContextBlockItem;
  LItemLetCfn: PEngineContextBlockItemLetConstFunction absolute LItem;
begin
  LBlock := This.FBlocks;
  while (LBlock <> nil) do
  begin
    LItem := LBlock.FItemsFirst;
    while ((LItem <> nil) and
      (LItem.FTypeId = EngCtxBlkItemTpId_LetConstFunction)) do
    begin
      if (LItemLetCfn.FBase.FVarIndex = AVarIndex) then
        Exit(LItemLetCfn);
      LItem := LItem.FNext;
    end;
    LBlock := LBlock.FNext;
  end;
  Exit(nil);
end;

function EngineContextGlobal_Create: PEngineContextGlobal;
begin
  Result := SysAllocMem(SizeOf(TEngineContextGlobal));
  Result.FBase.FTypeId := EngCtxTp_Global;
  EngineContext_CreateSysFuncs(Result^);
end;

procedure EngineContextGlobal_Destroy(p: PEngineContextGlobal);
begin
end;

procedure EngineGlobal_Execute;
var
  P: PFennerData;
begin
  P := StackVarsFrameBegin(1);
  try
    EngineGlobal_Execute(P^);
  finally
    StackVarsFrameEnd(1);
  end;
end;

procedure EngineGlobal_Execute(var AResult: TFennerData);
var
  LSaveState: TEngineGlobalContextSaveState;
  LRunner: TEngineRunner;
  LContext: PEngineContextGlobal;
begin
  LContext := nil;
  EngineGlobalContextSaveState_Backup(LSaveState);
  try
    LContext := EngineContextGlobal_Create;
    gvEngineContextGlobal := LContext;
    EngineContext_ParseGlobal(LContext.FBase);

    EngineRunner_Initialize(LRunner);
    EngineRunner_ExecuteContext(LRunner,
      Pointer(LContext), nil, 0, nil, AResult);
  finally
    EngineGlobalContextSaveState_Restore(LSaveState);
  end;
end;

{ <EngineContextValue> }
procedure EngineContextValue_Destroy(var This: TEngineContextValue);
begin
end;

procedure EngineContextValue_Execute_VariableGlobal(
  var This: TEngineContextValueByVariable;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
begin
  FennerData_Assign(AResult,
    StackVarsItem(AItem.FGlobalStackBase + This.FVarIndex));
end;

procedure EngineContextValue_Execute_Variable0(
  var This: TEngineContextValueByVariable;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
begin
  FennerData_Assign(AResult,
    StackVarsItem(AItem.FStackBase + This.FVarIndex));
end;

procedure EngineContextValue_Execute_VariableN(
  var This: TEngineContextValueByVariable;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LIndex, LStackBase: Integer;
  LRunner: PEngineRunner;
begin
  LRunner := AItem.FRunner;
  LIndex := This.FRelContextIndex;
  if (Cardinal(LIndex) < Cardinal(LRunner.FCrCount)) then
  begin
    LStackBase := LRunner.FCrStack[LIndex].FStackBase;
    FennerData_Assign(AResult, StackVarsItem(LStackBase + This.FVarIndex));
    Exit;
  end;

  raise EInternalError.Create('E9DA496BA8224B06B545A4EE6F3E4A19');
end;

procedure EngineContextValue_Execute_VariableRef(
  var This: TEngineContextValueByVariableRef;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LFunctionRef: PEngineContextFunctionRef;
  LIndex, LStackBase: Integer;
  RefCVar: PEngineContextFunctionRefClosureVar;
  LVarRef: PEngineContextVariableRef;
  LRunner: PEngineRunner;
begin
  LRunner := AItem.FRunner;

  LFunctionRef := AItem.FFunctionRef;
  if (LFunctionRef <> nil) then
  begin
    LIndex := This.FIndexRefClosureVar;
    if (Cardinal(LIndex) < Cardinal(Length(LFunctionRef.FClosureVars))) then
    begin
      RefCVar := @LFunctionRef.FClosureVars[LIndex];

      LVarRef := RefCVar.FVarRef;
      if (LVarRef <> nil) then
      begin
        LIndex := LVarRef.FRelativeContextIndex;
        if (Cardinal(LIndex) < Cardinal(LRunner.FCrCount)) then
        begin
          LStackBase := LRunner.FCrStack[LIndex].FStackBase;
          FennerData_Assign(AResult, StackVarsItem(LStackBase + LVarRef.FIndex));
          Exit;
        end;
      end;

      FennerData_Assign(AResult, @RefCVar.FData);
      Exit;
    end;
  end;

  LIndex := This.FBase.FRelContextIndex;
  if (Cardinal(LIndex) < Cardinal(LRunner.FCrCount)) then
  begin
    LStackBase := LRunner.FCrStack[LIndex].FStackBase;
    FennerData_Assign(AResult, StackVarsItem(LStackBase + This.FBase.FVarIndex));
    Exit;
  end;

  raise EInternalError.Create('82A053B2D3FC4684A5F2463F141AA5A8');
end;

procedure EngineContextValue_Execute_Array(
  var This: TEngineContextValueArray;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  i, LCount, LStackIndex: Integer;
  vArr: Pointer;
  LValue: PEngineContextValue;
  LDataByStack: PFennerData;
begin
  LCount := Length(This.FValues);
  FennerData_InitializeArray(AResult, LCount);

  vArr := AResult.vArr;
  for i := 0 to (LCount - 1) do
  begin
    LValue := This.FValues[i];

    LStackIndex := EngineContextValue_StackIndex(LValue^, AItem);
    if (LStackIndex >= 0) then
    begin
      LDataByStack := StackVarsItem(LStackIndex);
      if ((LDataByStack.vId = dttp_Array)
        and (LDataByStack.vArr = vArr)) then
      begin
        FennerData_Clear(TFennerDataDynArray(vArr)[i]);
        Continue;
      end;
    end;
    EngineContextValue_Execute(LValue^, AItem, TFennerDataDynArray(vArr)[i]);
  end;
end;

procedure EngineContextValue_Execute_Negative(
  var This: TEngineContextValueNegative;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LPar: PFennerData;
begin
  LPar := AuxStackVarsFrameBegin(1);
  try
    EngineContextValue_Execute(This.FRefValue^, AItem, LPar^);
    case LPar.vId of
      dttp_Bool: FennerData_SetAsBool(AResult, (not LPar.vBool));
      dttp_Int: FennerData_SetAsInteger(AResult, -LPar.vInt);
      else
        raise EInternalError.Create('F692D22A3B334E7CB1D2E30F8F8411C9');
    end;
  finally
    AuxStackVarsFrameEnd(1);
  end;
end;

procedure EngineContextValue_Execute_Op2(
  var This: TEngineContextValueOp2;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LPars: PFennerData;
begin
  LPars := AuxStackVarsFrameBegin(2);
  try
    EngineContextValue_Execute(This.FLeft^, AItem, LPars[0]);
    EngineContextValue_Execute(This.FRight^, AItem, LPars[1]);
    cInvkOp(LPars, AResult,
      This.FIndexOp + Word(LPars[0].vId) * 6 + Word(LPars[1].vId));
  finally
    AuxStackVarsFrameEnd(2);
  end;
end;

procedure EngineContextValue_Execute_Op2Or(
  var This: TEngineContextValueOp2;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LPars: PFennerData;
begin
  LPars := AuxStackVarsFrameBegin(2);
  try
    EngineContextValue_Execute(This.FLeft^, AItem, LPars[0]);

    if ((LPars[0].vId = dttp_Bool) and LPars[0].vBool) then
    begin
      FennerData_SetAsBool(AResult, True);
      Exit;
    end;

    EngineContextValue_Execute(This.FRight^, AItem, LPars[1]);
    cInvkOp(LPars, AResult,
      This.FIndexOp + Word(LPars[0].vId) * 6 + Word(LPars[1].vId));
  finally
    AuxStackVarsFrameEnd(2);
  end;
end;

procedure EngineContextValue_Execute_Op2And(
  var This: TEngineContextValueOp2;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LPars: PFennerData;
begin
  LPars := AuxStackVarsFrameBegin(2);
  try
    EngineContextValue_Execute(This.FLeft^, AItem, LPars[0]);

    if ((LPars[0].vId = dttp_Bool) and (not LPars[0].vBool)) then
    begin
      FennerData_SetAsBool(AResult, False);
      Exit;
    end;

    EngineContextValue_Execute(This.FRight^, AItem, LPars[1]);
    cInvkOp(LPars, AResult,
      This.FIndexOp + Word(LPars[0].vId) * 6 + Word(LPars[1].vId));
  finally
    AuxStackVarsFrameEnd(2);
  end;
end;

procedure EngineContextValue_Execute_Factorial(
  var This: TEngineContextValueFact;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LPar: PFennerData;
  T: Int64;
begin
  LPar := AuxStackVarsFrameBegin(1);
  try
    EngineContextValue_Execute(This.FValue^, AItem, LPar^);
    T := FennerData_AsIntDefZero(LPar^);
    FennerData_SetAsInteger(AResult, MyFuncsAsm_Factorial(T));
  finally
    AuxStackVarsFrameEnd(1);
  end;
end;

procedure EngineContextValue_Execute_Function(
  var This: TEngineContextValueFunction;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
begin
  EngineRunner_ExecuteContext(AItem.FRunner^,
    Pointer(This.FFunction), This.FParams,
    AItem.FStackBase, nil, AResult);
end;

procedure EngineContextValue_Execute_FunctionByValue(
  var This: TEngineContextValueFunctionByValue;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LData: PFennerData;
  LFunction: PEngineContextFunction;
  LFunctionRef: PEngineContextFunctionRef;
begin
  LData := AuxStackVarsFrameBegin(1);
  try
    EngineContextValue_Execute(This.FValue^, AItem, LData^);

    if (LData.vId <> dttp_Func) then
      raise ETryCallNotFunction.Create;

    if (LData.vId2 = Id2_Func_Ref) then
    begin
      LFunctionRef := PEngineContextFunctionRef(LData.vFn);
      LFunction := LFunctionRef.FFunction;
    end else
    if (LData.vId2 = Id2_Func_Default) then
    begin
      LFunction := LData.vFn;
      LFunctionRef := nil;
    end else
      Exit;

    EngineRunner_ExecuteContext(AItem.FRunner^, Pointer(LFunction),
      This.FParams, AItem.FStackBase, LFunctionRef, AResult);
  finally
    AuxStackVarsFrameEnd(1);
  end;
end;

procedure EngineContextValue_Execute_FunctionRef(
  var This: TEngineContextValueByVariable;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
begin
end;

procedure EngineContextValue_Execute_If(
  var This: TEngineContextValueIf;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
var
  LData: PFennerData;
  LBlock: PEngineContextBlock;
  LItem: PEngineContextBlockItem;
  LSaveResult: PFennerData;
begin
  LSaveResult := AItem.FResult;
  LData := AuxStackVarsFrameBegin(1);
  try
    AItem.FResult := @AResult;

    EngineContextValue_Execute(This.FExpression^, AItem, LData^);
    if (LData^.vId <> dttp_Bool) then
      raise EIfIsntBoolean.Create;

    if LData^.vBool then
      LBlock := This.FThen
    else
      LBlock := This.FElse;

    if (LBlock <> nil) then
    begin
      LItem := LBlock.FItemsFirst;
      while (LItem <> nil) do
      begin
        if AItem.FIsTerminated then Break;
        EngineContextBlockItem(LItem^, AItem);
        LItem := LItem.FNext;
      end;
    end;
  finally
    AuxStackVarsFrameEnd(1);
    AItem.FResult := LSaveResult;
  end;
end;

procedure EngineContextValue_Execute(var This: TEngineContextValue;
  var AItem: TEngineRunnerItem; var AResult: TFennerData);
  assembler; nostackframe;
asm
    xor rax, rax
    mov al, This.FTypeId
    cmp al, EngCtxValueTpId_If
    ja  @none

    mov rcx, offset @a
    jmp [rcx + rax * 8]

@a:
    dq Offset @none                // None
    dq Offset @const_boolean       // const Boolean
    dq Offset @const_integer       // const Integer
    dq Offset @const_string        // const String
    dq Offset @const_function      // const Function
    dq Offset @const_array         // const Array
    dq Offset EngineContextValue_Execute_VariableGlobal  // Variável Global
    dq Offset EngineContextValue_Execute_Variable0       // Variável Local
    dq Offset EngineContextValue_Execute_VariableN       // Variável de Outro Contexto (não Local nem Global)
    dq Offset EngineContextValue_Execute_VariableRef     // Variável Closure
    dq Offset EngineContextValue_Execute_Array           // Array
    dq Offset EngineContextValue_Execute_Negative        // Negative
    dq Offset EngineContextValue_Execute_Op2             // Op2
    dq Offset EngineContextValue_Execute_Op2Or           // Op2Or
    dq Offset EngineContextValue_Execute_Op2And          // Op2And
    dq Offset EngineContextValue_Execute_Factorial       // Factorial
    dq Offset EngineContextValue_Execute_Function        // Function
    dq Offset EngineContextValue_Execute_FunctionByValue // Function By Value
    dq Offset EngineContextValue_Execute_FunctionRef     // Function Closure
    dq Offset EngineContextValue_Execute_If              // If


@none:
    mov  rdi, rdx
    mov  rsi, dttp_None
    jmp  FennerData_SetId

@const_boolean:
    xor  rax, rax
    mov  al,  [rdi + TEngineContextValueConstBool.FConstValue]
    mov  rsi, rax
    mov  rdi, rdx
    jmp  FennerData_SetAsBool

@const_integer:
    mov  rsi, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rdi, rdx
    jmp  FennerData_SetAsInteger

@const_string:
    mov  rsi, [rdi + TEngineContextValueConstString.FConstValue]
    mov  rdi, rdx
    jmp  FennerData_SetAsString

@const_function:
    mov  rax, rdx
    mov  rdx, [rdi + TEngineContextValueConstFunction.FConstValue]
    mov  rsi, Id2_Func_Default
    mov  rdi, rax
    jmp  FennerData_SetAsFunction

@const_array:
    lea  rsi, [rdi + TEngineContextValueConstArray.FConstValue]
    mov  rsi, [rsi]
    mov  rdi, rdx
    jmp  FennerData_SetAsArray
end;

function EngineContextValue_IsConst(var This: TEngineContextValue): Boolean;
begin
  Result :=
    (This.FTypeId <= EngCtxValueTpId_ConstArray) and
    (This.FTypeId >= EngCtxValueTpId_ConstBool);
end;

function EngineContextValue_StackIndex_VariableGlobal(
  var This: TEngineContextValueByVariable;
  var AItem: TEngineRunnerItem): Integer; assembler; nostackframe;
//begin
//  Exit(AItem.FGlobalStackBase + This.FVarIndex);
asm
    xor rax, rax
    mov eax, [rsi + TEngineRunnerItem.FGlobalStackBase]
    add eax, [rdi + TEngineContextValueByVariable.FVarIndex]
end;

function EngineContextValue_StackIndex_Variable0(
  var This: TEngineContextValueByVariable;
  var AItem: TEngineRunnerItem): Integer; assembler; nostackframe;
asm
    Jmp AsmRet_Neg_1
end;

function EngineContextValue_StackIndex_VariableN(
  var This: TEngineContextValueByVariable;
  var AItem: TEngineRunnerItem): Integer; assembler; nostackframe;
asm
    Jmp AsmRet_Neg_1
end;

function EngineContextValue_StackIndex_VariableRef(
  var This: TEngineContextValueByVariable;
  var AItem: TEngineRunnerItem): Integer; assembler; nostackframe;
asm
    Jmp AsmRet_Neg_1
end;

function EngineContextValue_StackIndex(var This: TEngineContextValue;
  var AItem: TEngineRunnerItem): Integer; assembler; nostackframe;
asm
    xor rax, rax
    mov al, This.FTypeId
    cmp al, EngCtxValueTpId_If
    ja  AsmRet_Neg_1

    mov rcx, offset @a
    jmp [rcx + rax * 8]

@a:
    dq Offset AsmRet_Neg_1        // None
    dq Offset AsmRet_Neg_1        // Const Boolean
    dq Offset AsmRet_Neg_1        // Const Integer
    dq Offset AsmRet_Neg_1        // Const String
    dq Offset AsmRet_Neg_1        // Const Function
    dq Offset AsmRet_Neg_1        // Const Array
    dq Offset EngineContextValue_StackIndex_VariableGlobal // Variável Global
    dq Offset EngineContextValue_StackIndex_Variable0      // Variável Local
    dq Offset EngineContextValue_StackIndex_VariableN      // Variável de Outro Contexto
    dq Offset EngineContextValue_StackIndex_VariableRef    // Variável Closure
    dq Offset AsmRet_Neg_1        // Array
    dq Offset AsmRet_Neg_1        // Negative
    dq Offset AsmRet_Neg_1        // Op2
    dq Offset AsmRet_Neg_1        // Op2Or
    dq Offset AsmRet_Neg_1        // Op2And
    dq Offset AsmRet_Neg_1        // Factorial
    dq Offset AsmRet_Neg_1        // Function
    dq Offset AsmRet_Neg_1        // Function By Value
    dq Offset AsmRet_Neg_1        // Function (Closure)
    dq Offset AsmRet_Neg_1        // If
end;

function EngineContextValueConstFunction_Create(
  const AFunction: PEngineContextFunction): PEngineContextValueFunction;
var
  R: PEngineContextValueConstFunction absolute Result;
begin
  Result := Pointer(AFunction.FConstDeclr);
  if (Result = nil) then
  begin
    R := AllocMem(SizeOf(TEngineContextValueConstFunction));
    R.FConstValue := AFunction;
    R.FBase.FTypeId := EngCtxValueTpId_ConstFunction;
    AFunction.FConstDeclr := R;
  end;
end;

function EngineContextValueFunction_Create(
  const AFunction: PEngineContextFunction;
  const AParams: TArray<PEngineContextValue>): PEngineContextValueFunction;
  assembler; nostackframe;
//begin
//  Result := AllocMem(SizeOf(TEngineContextValueFunction));
//  Result.FFunction := AFunction;
//  Result.FParams := AParams;
//  Result.FBase.FTypeId := EngCtxValueTpId_Function;
asm
    push rsi
    push rdi

    mov rdi, SizeOf(TEngineContextValueFunction)
    call AllocMem
    mov [rax + TEngineContextValue.FTypeId], EngCtxValueTpId_Function

    pop rdi
    mov [rax + TEngineContextValueFunction.FFunction], rdi

    pop rsi
    lea rdi, [rax + TEngineContextValueFunction.FParams]
    push rax
    call PtrArrCpy
    pop rax
end;

function EngineContextValueFunctionByValue_Create(
  const AValue: PEngineContextValue;
  const AParams: TArray<PEngineContextValue>):
    PEngineContextValueFunctionByValue;
begin
  Result := AllocMem(SizeOf(TEngineContextValueFunctionByValue));
  Result.FValue := AValue;
  Result.FParams := AParams;
  Result.FBase.FTypeId := EngCtxValueTpId_FunctionByValue;
end;

function EngineContextValueNegative_Create(
  const ARefValue: PEngineContextValue): PEngineContextValueNegative;
begin
  Result := AllocMem(SizeOf(TEngineContextValueNegative));
  Result.FBase.FTypeId := EngCtxValueTpId_Negative;
  Result.FRefValue := ARefValue;
end;

function EngineContextValueByVariableLocal_Create(
  const AVarIndex: Integer): PEngineContextValueByVariable;
begin
  Result := AllocMem(SizeOf(TEngineContextValueByVariable));
  Result.FBase.FTypeId := EngCtxValueTpId_Variable0;
  Result.FVarIndex := AVarIndex;
end;

function EngineContextValueByVariableGlobal_Create(
  const AVarIndex: Integer): PEngineContextValueByVariable;
begin
  Result := AllocMem(SizeOf(TEngineContextValueByVariable));
  Result.FBase.FTypeId := EngCtxValueTpId_VariableGlobal;
  Result.FVarIndex := AVarIndex;
end;

function EngineContextValueOp2_Create(const ALeft, ARight: PEngineContextValue;
  const AOp: Byte): PEngineContextValue;
var
  LOp2: PEngineContextValueOp2 absolute Result;
begin
  Result := EngineContextValueOp2_TryCreate_Optimized(ALeft, ARight, AOp);
  if (Result = nil) then
  begin
    LOp2 := AllocMem(SizeOf(TEngineContextValueOp2));
    LOp2.FBase.FTypeId := EngCtxValueTpId_Op2;
    LOp2.FLeft := ALeft;
    LOp2.FRight := ARight;
    LOp2.FOp := AOp;
    LOp2.FIndexOp := ((AOp - tkop_Add) * 36);
  end;
end;

function EngineContextValueFact_Create(
  const ARefValue: PEngineContextValue): PEngineContextValue;
var
  LRefValueConstInt: PEngineContextValueConstInt absolute ARefValue;
  LResFact: PEngineContextValueFact;
begin
  if (ARefValue.FTypeId = EngCtxValueTpId_ConstInt) then
    EngineContextValueConstInt_Create(
      MyFuncsAsm_Factorial(LRefValueConstInt.FConstValue));

  LResFact := AllocMem(SizeOf(TEngineContextValueFact));
  LResFact.FBase.FTypeId := EngCtxValueTpId_Factorial;
  LResFact.FValue := ARefValue;
end;

{ </EngineContextValue> }

{ <EngineFunction> }
function EngineFunction_GetDeclrName(var This: TEngineContextFunction): LString;
begin
  Result := This.FDeclrName;
  if (Pointer(Result) = nil) then
  begin
    This.FDeclrName := '_func_' + Int32ToLString(GenId_FunctionName);
    Inc(GenId_FunctionName);
  end;
end;

function EngineFunction_GetName(var This: TEngineContextFunction): LString;
var
  LContext: PEngineContext;
  LS: LString;
begin
  if (@This = nil) then Exit('(nil)');
  Result := EngineFunction_GetDeclrName(This);

  LContext := This.FBase.FOwner;
  while (LContext <> nil) do
  begin
    if (LContext.FTypeId = EngCtxTp_Function) then
    begin
      LS := EngineFunction_GetDeclrName(PEngineContextFunction(LContext)^);
      if (Length(LS) > 0) then
        Result := LS + '.' + Result;
    end;
    LContext := LContext.FOwner;
  end;
end;

function EngineFunction_SetTypeId(var This: TEngineContextFunction;
  const ATypeId: Byte): Boolean;
begin
  This.FTypeId := ATypeId;
  Exit(True);
end;

{ </EngineFunction> }

{ <EngineFunctionRef> }
procedure EngineContextFunctionRef_IncRef(var This: TEngineContextFunctionRef);
begin
  Inc(This.FRefCount);
end;

procedure EngineContextFunctionRef_DecRef(var This: TEngineContextFunctionRef);
begin
  Dec(This.FRefCount);
end;
{ </EngineFunctionRef> }

{ <EngineContextBlock> }
procedure EngineContextBlock_ItemsAdd(var This: TEngineContextBlock;
  const Item: PEngineContextBlockItem);
begin
  if (This.FItemsFirst = nil) then
    This.FItemsFirst := Item
  else
    This.FItemsLast.FNext := Item;

  This.FItemsLast := Item;
  Item.FBlock := @This;
  Item.FContext := This.FContext;
end;

{ </EngineContextBlock> }

procedure EngineContextBlockItem_LetConstBool(
  var This: TEngineContextBlockItem;
  var AItem: TEngineRunnerItem); assembler; nostackframe;
asm
    xor rcx, rcx
    xor rdx, rdx

    mov ecx, [rdi + TEngineContextBlockItemLetConstInt.FBase.FVarIndex]
    add ecx, [rsi + TEngineRunnerItem.FStackBase]
    imul rcx, SizeOf(TFennerData)

    mov rax, offset gvStackVarsArray
    mov dl,  [rdi + TEngineContextBlockItemLetConstBool.FConstValue]
    lea rdi, [rax + rcx]
    mov rsi, rdx

    mov al,  [rdi + TFennerData.vId]
    cmp al,  dttp_Bool
    jne FennerData_SetAsBool

    mov [rdi + TFennerData.vBool], dl
end;

procedure EngineContextBlockItem_LetConstInt(
  var This: TEngineContextBlockItemLetConstInt;
  var AItem: TEngineRunnerItem); assembler; nostackframe;
asm
   xor rcx, rcx

   mov ecx, [rdi + TEngineContextBlockItemLetConstInt.FBase.FVarIndex]
   add ecx, [rsi + TEngineRunnerItem.FStackBase]
   imul rcx, SizeOf(TFennerData)

   mov rax, offset gvStackVarsArray
   mov rsi, [rdi + TEngineContextBlockItemLetConstInt.FConstValue]
   lea rdi, [rax + rcx]
   mov al,  [rdi + TFennerData.vId]
   cmp al,  dttp_Int
   jne FennerData_SetAsInteger

   mov [rdi + TFennerData.vInt], rsi
end;

procedure EngineContextBlockItem_LetConstString(
  var This: TEngineContextBlockItemLetConstInt;
  var AItem: TEngineRunnerItem); assembler; nostackframe;
asm
    xor rcx, rcx

    mov ecx, [rdi + TEngineContextBlockItemLetConstInt.FBase.FVarIndex]
    add ecx, [rsi + TEngineRunnerItem.FStackBase]
    imul rcx, SizeOf(TFennerData)

    mov rax, offset gvStackVarsArray
    mov rsi, [rdi + TEngineContextBlockItemLetConstInt.FConstValue]
    lea rdi, [rax + rcx]
    mov al,  [rdi + TFennerData.vId]
    cmp al,  dttp_Str
    jne FennerData_SetAsString

    mov [rdi + TFennerData.vInt], rsi
end;

procedure EngineContextBlockItem_LetConstFunction(
  var This: TEngineContextBlockItemLetConstFunction;
  var AItem: TEngineRunnerItem); assembler; nostackframe;
asm
    xor rcx, rcx

    mov ecx, [rdi + TEngineContextBlockItemLetConstFunction.FBase.FVarIndex]
    add ecx, [rsi + TEngineRunnerItem.FStackBase]
    imul rcx, SizeOf(TFennerData)

    mov rax, offset gvStackVarsArray
    mov rdx, [rdi + TEngineContextBlockItemLetConstFunction.FConstValue]
    mov rsi, Id2_Func_Default
    lea rdi, [rax + rcx]

    jmp FennerData_SetAsFunction
end;

procedure EngineContextBlockItem_LetConstArray(
  var This: TEngineContextBlockItemLetConstArray;
  var AItem: TEngineRunnerItem);
begin
  FennerData_SetAsArray(
    StackVarsItem(This.FBase.FVarIndex + AItem.FStackBase)^,
    Pointer(This.FConstValue));
end;

procedure EngineContextBlockItem_LetArray(
  var This: TEngineContextBlockItemLetArray;
  var AItem: TEngineRunnerItem);
var
  LData: PFennerData;
  i, LCount: Integer;
begin
  LCount := Length(This.FConstValue);

  LData := StackVarsItem(This.FBase.FVarIndex + AItem.FStackBase);
  FennerData_InitializeArray(LData^, LCount);

  for i := 0 to (LCount - 1) do
    EngineContextValue_Execute(This.FConstValue[i]^, AItem,
      TFennerDataDynArray(LData.vArr)[i]);
end;

procedure EngineContextBlockItem_LetValue0(
  var This: TEngineContextBlockItemLetValue0;
  var AItem: TEngineRunnerItem);
begin
  EngineContextValue_Execute(This.FConstValue^, AItem,
    StackVarsItem(This.FBase.FVarIndex + AItem.FStackBase)^);
end;

procedure EngineContextBlockItem_LetValueRef(
  var This: TEngineContextBlockItemLetValueRef;
  var AItem: TEngineRunnerItem);
var
  LFunctionRef: PEngineContextFunctionRef;
  LIndex, LStackBase: Integer;
  RefCVar: PEngineContextFunctionRefClosureVar;
  LVarRef: PEngineContextVariableRef;
  LRunner: PEngineRunner;
begin
  LRunner := AItem.FRunner;
  LFunctionRef := AItem.FFunctionRef;
  if (LFunctionRef <> nil) then
  begin
    LIndex := This.FIndexRefClosureVar;
    if (Cardinal(LIndex) < Cardinal(Length(LFunctionRef.FClosureVars))) then
    begin
      RefCVar := @LFunctionRef.FClosureVars[LIndex];
      LVarRef := RefCVar.FVarRef;
      if (LVarRef <> nil) then
      begin
        LIndex := LVarRef.FRelativeContextIndex;
        if (Cardinal(LIndex) < Cardinal(LRunner.FCrCount)) then
        begin
          LStackBase := LRunner.FCrStack[LIndex].FStackBase;
          EngineContextValue_Execute(This.FValue^, AItem,
            StackVarsItem(LStackBase + LVarRef.FIndex)^);
          Exit;
        end;
      end;

      EngineContextValue_Execute(This.FValue^, AItem, RefCVar.FData);
      Exit;
    end;
  end;
end;

procedure EngineContextBlockItem_Call(
  var This: TEngineContextBlockItemLetValueRef;
  var AItem: TEngineRunnerItem);
begin
  EngineContextValue_Execute(This.FValue^, AItem, AItem.FResult^);
end;

procedure EngineContextFunction_ValidateReturn_Function(
  var AItem: TEngineRunnerItem; const AContextFunction: PEngineContextFunction;
  var AResult: TFennerData);
var
  LResFunction, LNewFunction: PEngineContextFunction;
begin
  if (AResult.vId2 <> Id2_Func_Default) then Exit;

  LResFunction := AResult.vFn;
  if ((LResFunction.FFlags and EngCtxFnFlgId_UseContextN) = 0) then Exit;

  LNewfunction := Engine_ClosureConvertion(AItem,
    AContextFunction, LResFunction, 0);
  if (LNewFunction <> nil) then
    AResult.vFn := LNewFunction;
end;

procedure EngineContextBlockItem_Return(
  var This: TEngineContextBlockItemReturn;
  var AItem: TEngineRunnerItem);
begin
  EngineContextValue_Execute(This.FSourceValue^, AItem, AItem.FResult^);
  if (AItem.FResult^.vId = dttp_Func) then
    EngineContextFunction_ValidateReturn_Function(AItem,
      Pointer(This.FBase.FContext), AItem.FResult^);

  AItem.FIsTerminated := True;
end;

procedure EngineContextBlockItem_If(
  var This: TEngineContextBlockItemIf;
  var AItem: TEngineRunnerItem);
var
  LData: PFennerData;
  LBlock: PEngineContextBlock;
  LItem: PEngineContextBlockItem;
begin
  LData := AuxStackVarsFrameBegin(1);
  try
    EngineContextValue_Execute(This.FExpression^, AItem, LData^);
    if (LData^.vId <> dttp_Bool) then
      raise EIfIsntBoolean.Create;

    if LData^.vBool then
      LBlock := This.FThen
    else
      LBlock := This.FElse;

    if (LBlock <> nil) then
    begin
      LItem := LBlock.FItemsFirst;
      while (LItem <> nil) do
      begin
        if AItem.FIsTerminated then Break;
        EngineContextBlockItem(LItem^, AItem);
        LItem := LItem.FNext;
      end;
    end;
  finally
    AuxStackVarsFrameEnd(1);
  end;
end;

procedure EngineContextBlockItem_While(
  var This: TEngineContextBlockItemWhile;
  var AItem: TEngineRunnerItem);
var
  LData: PFennerData;
  LBlock: PEngineContextBlock;
  LItem: PEngineContextBlockItem;
begin
  LData := AuxStackVarsFrameBegin(1);
  try
    repeat
      EngineContextValue_Execute(This.FExpression^, AItem, LData^);
      if (LData^.vId <> dttp_Bool) then
        raise EIfIsntBoolean.Create;
      if (not LData^.vBool) then Break;
      if AItem.FIsTerminated then Break;

      LBlock := This.FBlock;
      if (LBlock <> nil) then
      begin
        LItem := LBlock.FItemsFirst;
        while (LItem <> nil) do
        begin
          if AItem.FIsTerminated then Break;
          EngineContextBlockItem(LItem^, AItem);
          LItem := LItem.FNext;
        end;
      end;
    until False;
  finally
    AuxStackVarsFrameEnd(1);
  end;
end;

{ <EngineContextBlockItem> }
procedure EngineContextBlockItem(var This: TEngineContextBlockItem;
  var AItem: TEngineRunnerItem); assembler; nostackframe;
asm
    xor rax, rax
    mov al, [rdi + TEngineContextBlockItem.FTypeId]
    cmp al, EngCtxBlkItemTpId_While
    ja @z
    mov rcx, offset @b
    jmp [rcx + rax * 8]

@b:
    dq Offset AsmRet                                    // None
    dq Offset EngineContextBlockItem_LetConstBool       // Const Boolean
    dq Offset EngineContextBlockItem_LetConstInt        // Const Integer
    dq Offset EngineContextBlockItem_LetConstString     // Const String
    dq Offset EngineContextBlockItem_LetConstFunction   // Const Function
    dq Offset EngineContextBlockItem_LetConstArray      // Const Array

    dq Offset EngineContextBlockItem_LetArray           // Array
    dq Offset EngineContextBlockItem_LetValue0          // Value0
    dq Offset EngineContextBlockItem_LetValueRef        // ValueRef
    dq Offset EngineContextBlockItem_Call               // Call
    dq Offset EngineContextBlockItem_Return             // Return
    dq Offset EngineContextBlockItem_If                 // If
    dq Offset EngineContextBlockItem_While              // While
@z:
end;

function EngineContextBlockItemLetConstBool_Create(const AVarIndex: Integer;
  const AValue: Boolean): PEngineContextBlockItemLetConstBool;
begin
  Result := AllocMem(SizeOf(TEngineContextBlockItemLetConstBool));
  Result.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstBool;
  Result.FBase.FVarIndex := AVarIndex;
  Result.FConstValue := AValue;
end;

function EngineContextBlockItemLetConstInt_Create(const AVarIndex: Integer;
  const AValue: Int64): PEngineContextBlockItemLetConstInt;
begin
  Result := AllocMem(SizeOf(TEngineContextBlockItemLetConstInt));
  Result.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstInt;
  Result.FBase.FVarIndex := AVarIndex;
  Result.FConstValue := AValue;
end;

function EngineContextBlockItemLetConstStr_Create(const AVarIndex: Integer;
  const AValue: LString): PEngineContextBlockItemLetConstStr;
begin
  Result := AllocMem(SizeOf(TEngineContextBlockItemLetConstStr));
  Result.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstString;
  Result.FBase.FVarIndex := AVarIndex;
  Result.FConstValue := AValue;
end;

function EngineContextBlockItemLetConstFunc_Create(const AVarIndex: Integer;
  const AValue: PEngineContextFunction): PEngineContextBlockItemLetConstFunction;
begin
  Result := AllocMem(SizeOf(TEngineContextBlockItemLetConstFunction));
  Result.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstFunction;
  Result.FBase.FVarIndex := AVarIndex;
  Result.FConstValue := AValue;
end;

function EngineContextBlockItemLetConstArray_Create(const AVarIndex: Integer;
  const AValue: TFennerDataDynArray): PEngineContextBlockItemLetConstArray;
begin
  Result := AllocMem(SizeOf(TEngineContextBlockItemLetConstArray));
  Result.FBase.FBase.FTypeId := EngCtxBlkItemTpId_LetConstArray;
  Result.FBase.FVarIndex := AVarIndex;
  Result.FConstValue := AValue;
end;

{ </EngineContextBlockItem> }

function ExFunc_Execute_Print(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  t: LString;
  c, o: PFennerData;
begin
  t := '';
  c := Pointer(AParams);
  o := (c + Length(AParams));
  while (c < o) do
  begin
    t := t + FennerData_Print(c^);
    Inc(c);
  end;

  FennerData_SetAsString(AResult, t);
  AsmSysWriteLn(t);
  Exit(True);
end;

function ExFunc_Execute_Fibonacci(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  t: Int64;
begin
  if FennerData_TryAsInt(AParams[0], t) then
  begin
    FennerData_SetAsInteger(AResult, MyFuncsAsm_Fibonacci(t));
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_FibonacciR3(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  a, b, c: Int64;
begin
  if (FennerData_TryAsInt(AParams[0], a) and FennerData_TryAsInt(AParams[1], b)
    and FennerData_TryAsInt(AParams[2], c)) then
  begin
    FennerData_SetAsInteger(AResult, MyFuncsAsm_FibonacciR3(a, b, c));
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_Combination(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  a, b: Int64;
begin
  if (FennerData_TryAsInt(AParams[0], a) and
    FennerData_TryAsInt(AParams[1], b)) then
  begin
    FennerData_SetAsInteger(AResult, SysFunc_Combination(a, b));
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_SumOfPA(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  t: Int64;
begin
  if FennerData_TryAsInt(AParams[0], t) then
  begin
    FennerData_SetAsInteger(AResult, MyFuncsAsm_SumOfApTerms(t));
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_Factorial(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  t: Int64;
begin
  if FennerData_TryAsInt(AParams[0], t) then
  begin
    FennerData_SetAsInteger(AResult, MyFuncsAsm_Factorial(t));
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_Min(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  a, b: Int64;
begin
  if (FennerData_TryAsInt(AParams[0], a) and
    FennerData_TryAsInt(AParams[1], b)) then
  begin
    if (a > b) then a := b;
    FennerData_SetAsInteger(AResult, a);
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_Max(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  a, b: Int64;
begin
  if (FennerData_TryAsInt(AParams[0], a) and
    FennerData_TryAsInt(AParams[1], b)) then
  begin
    if (a < b) then a := b;
    FennerData_SetAsInteger(AResult, a);
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_Mdc(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  a, b: Int64;
begin
  if (FennerData_TryAsInt(AParams[0], a) and
    FennerData_TryAsInt(AParams[1], b)) then
  begin
    FennerData_SetAsInteger(AResult, MyFuncsAsm_Mdc(a, b));
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_HanoiMovsCount(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  t: Int64;
begin
  if FennerData_TryAsInt(AParams[0], t) then
  begin
    FennerData_SetAsInteger(AResult, MyFuncsAsm_HanoiMovsCount(t));
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute_Array_Length(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  p: PFennerData;
begin
  p := @AParams[0];
  if (p^.vId <> dttp_Array) then
    raise EParamIsntArray.Create;

  FennerData_SetAsInteger(AResult, Length(TFennerDataDynArray(p.vArr)));
  Exit(True);
end;

function ExFunc_Execute_Array_Item(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  p: PFennerData;
  i: Int64;
begin
  p := @AParams[0];
  if (p^.vId <> dttp_Array) then
    raise EParamIsntArray.Create;

  if (not FennerData_TryAsInt(AParams[1], i)) then
    raise EParamIsntInteger.Create;

  if (UInt64(i) < UInt64(Length(TFennerDataDynArray(p.vArr)))) then
    FennerData_Assign(AResult, @TFennerDataDynArray(p.vArr)[i])
  else
    FennerData_Clear(AResult);

  Exit(True);
end;

function ExFunc_Execute_TypeOf(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  vId: Byte;
begin
  vId := AParams[0].vId;
  if (vId <= High(cs_TypeOf)) then
    FennerData_SetAsString(AResult, cs_TypeOf[vId])
  else
    FennerData_SetAsString(AResult, cs_TypeOfUnk + Int32ToLString(vId));

  Exit(True);
end;

function ExFunc_Execute_GetItem(const AParams: TFennerDataDynArray;
  var AResult: TFennerData; const AIndex: Integer): Boolean;
var
  p: PFennerData;
  c: Integer;
begin
  p := @AParams[0];
  if (p^.vId <> dttp_Array) then
    raise EParamIsntArray.Create;

  c := Length(TFennerDataDynArray(p^.vArr));
  if (Cardinal(AIndex) < Cardinal(c)) then
    FennerData_Assign(AResult, @TFennerDataDynArray(p^.vArr)[AIndex])
  else
    FennerData_Clear(AResult);

  Exit(True);
end;

function ExFunc_Execute_First(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    xor rdx, rdx
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Second(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 1
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Third(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 2
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Fourth(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 3
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Fifth(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 4
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Sixth(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 5
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Seventh(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 6
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Eighth(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 7
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Ninth(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 8
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Tenth(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
asm
    mov rdx, 9
    jmp ExFunc_Execute_GetItem
end;

function ExFunc_Execute_Ackermann(const AParams: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  m, n: Int64;
begin
  if (FennerData_TryAsInt(AParams[0], m) and
    FennerData_TryAsInt(AParams[1], n)) then
  begin
    FennerData_SetAsInteger(AResult, MyFuncsAsm_Ackermann(m, n));
    Exit(True);
  end;

  Exit(False);
end;

function ExFunc_Execute(const AParams: TFennerDataDynArray;
  var AResult: TFennerData; const AIndex: Integer): Boolean;
  assembler; nostackframe;
asm
    xor rax, rax
    cmp rdx, EngCtxFnTpId_Ackermann
    ja  AsmRet_0
    mov rcx, offset @a
    mov rcx, [rcx + rdx * 8]
    jmp rcx
@a:
    dq Offset AsmRet_0                  // None
    dq Offset AsmRet_0                  // AST
    dq Offset ExFunc_Execute_Print
    dq Offset ExFunc_Execute_Fibonacci
    dq Offset ExFunc_Execute_FibonacciR3
    dq Offset ExFunc_Execute_Combination
    dq Offset ExFunc_Execute_SumOfPA
    dq Offset ExFunc_Execute_Factorial
    dq Offset ExFunc_Execute_Min
    dq Offset ExFunc_Execute_Max
    dq Offset ExFunc_Execute_Mdc
    dq Offset ExFunc_Execute_HanoiMovsCount
    dq Offset ExFunc_Execute_Array_Length
    dq Offset ExFunc_Execute_Array_Item
    dq Offset ExFunc_Execute_TypeOf
    dq Offset ExFunc_Execute_First
    dq Offset ExFunc_Execute_Second
    dq Offset ExFunc_Execute_Third
    dq Offset ExFunc_Execute_Fourth
    dq Offset ExFunc_Execute_Fifth
    dq Offset ExFunc_Execute_Sixth
    dq Offset ExFunc_Execute_Seventh
    dq Offset ExFunc_Execute_Eighth
    dq Offset ExFunc_Execute_Ninth
    dq Offset ExFunc_Execute_Tenth
    dq Offset ExFunc_Execute_Ackermann
end;

procedure EngineRunner_Initialize(var This: TEngineRunner);
var
  I: Integer;
begin
  This.FCrStack := nil;
  FillChar(This, SizeOf(This), 0);
  for I := Low(This.FRecursiveCaches) to High(This.FRecursiveCaches) do
    This.FRecursiveCaches[I].FIndex := I;
end;

//procedure EngineRunner_ExecuteContext(var This: TEngineRunner;
//  const AContext: PEngineContext; const AParams: TArray<PEngineContextValue>;
//  const AOwnerStackBase: Integer; const AFunctionRef: PEngineContextFunctionRef;
//  var AResult: TFennerData);
//
//{$J+}
//const
//  cgv_RunningId: Int64 = 0;
//{$J-}
//
//var
//  LStackIndex, LCount: Integer;
//  LAdded: Boolean;
//  LTypeId: Byte;
//  LContextFunction: PEngineContextFunction absolute AContext;
//  LBlock: PEngineContextBlock;
//  LItem: PEngineContextBlockItem;
//  LParam: TEngineRunnerItem;
//  p: PPEngineContextValue;
//  LArgs: TFennerDataDynArray;
//  LArgPtr, LStack: PFennerData;
//  LRunningId: Int64;
//  LRefCVar: PEngineContextFunctionRefClosureVar;
//  LVar: PEngineContextVariable;
//  LRCacheEntry: PEngineRecursiveCacheEntry;
//
//  procedure InitializeArgs;
//  var
//    i: Integer;
//  begin
//    if (LCount <= 0) then
//    begin
//      LArgs := nil;
//      Exit;
//    end;
//
//    SetLength(LArgs, LCount);
//    LArgPtr := Pointer(LArgs);
//
//    p := Pointer(AParams);
//    for i := 0 to (LCount - 1) do
//    begin
//      EngineContextValue_Execute(p^^, LParam, LArgPtr^);
//      Inc(p);
//      Inc(LArgPtr);
//    end;
//
//    LStack := StackVarsItemZ(LStackIndex);
//    System.Move(LArgs[0], LStack^, (LCount * SizeOf(TFennerData)));
//  end;
//
//  procedure CheckClosure(var AData: TFennerData);
//  var
//    LFunction: PEngineContextFunction;
//    LFunctionRef: PEngineContextFunctionRef;
//    I, LCount: Integer;
//    LVarRef: PEngineContextVariableRef;
//    LD: PEngineContextFunctionRefClosureVar;
//  begin
//    if (AData.vId <> dttp_Func) then Exit;
//
//    LFunction := AData.vFn;
//    if (LFunction.FBase.FVarRefsFirst = nil) then Exit;
//
//    LFunctionRef := AllocMem(SizeOf(TEngineContextFunctionRef));
//    LFunctionRef.FFunction := LFunction;
//
//    LCount := LFunction.FBase.FVarRefsCount;
//    SetLength(LFunctionRef.FClosureVars, LCount);
//    LD := Pointer(LFunctionRef.FClosureVars);
//    LVarRef := LFunction.FBase.FVarRefsFirst;
//
//    for I := 0 to (LCount - 1) do
//    begin
//      LD.FVarRef := LVarRef;
//      LD.FRunningId := LRunningId;
//      ClosureVarsAdd(LD);
//
//      Inc(LD);
//      Inc(LVarRef);
//    end;
//
//    FennerData_SetAsFunction(AData, Id2_Func_Ref, LFunctionRef);
//  end;
//
//begin
//  Inc(cgv_RunningId);
//  LRunningId := cgv_RunningId;
//  LAdded := EngineRunner_AddContext(This, AContext, LRunningId);
//  LRCacheEntry := nil;
//
//  LStackIndex := StackVarsAdd(AContext.FVarsCount);
//
//  LCount := Length(AParams);
//
//  LParam.FRunner := @This;
//  LParam.FResult := @AResult;
//  LParam.FStackBase := AOwnerStackBase;
//  LParam.FFunctionRef := AFunctionRef;
//
//  if (This.FCrCount > 0) then
//    LParam.FGlobalStackBase := This.FCrStack[0].FStackBase
//  else
//    LParam.FGlobalStackBase := 0;
//
//  LParam.FCrCount := This.FCrCount;
//  LParam.FParamCount := LCount;
//  LParam.FIsTerminated := False;
//
//  LParam.FRunningId := LRunningId;
//
//  if (AContext.FTypeId = EngCtxTp_Function) then
//  begin
//    if ((LContextFunction.FMinParamsCount > LCount)
//    or (LContextFunction.FMaxParamsCount < LCount)) then
//      raise EFunctionInvalidParamCount.Create(
//        EngineFunction_GetName(LContextFunction^),
//        LCount, LContextFunction.FMinParamsCount,
//        LContextFunction.FMaxParamsCount);
//
//    LTypeId := LContextFunction.FTypeId;
//    if (LTypeId = Id2_Func_Default) then
//    begin
//      if (not EngineFunction_TryOptimize(LContextFunction^)) then
//        EngineFunction_SetTypeId(LContextFunction^, EngCtxFnTpId_AST);
//      LTypeId := LContextFunction.FTypeId;
//    end;
//
//    if (LTypeId > EngCtxFnTpId_AST) then
//    begin
//      InitializeArgs;
//      if ExFunc_Execute(LArgs, AResult, LTypeId) then Exit;
//    end else
//    begin
//      InitializeArgs;
//      if (LContextFunction.FRecursiveTypeId > 0) then
//      begin
//        LRCacheEntry := EngineRecursiveCache_GetEntry(
//          This.FRecursiveCaches[LContextFunction.FRecursiveTypeId], AContext);
//
//        if EngineRecursiveCacheEntry_TryGet(LRCacheEntry^, LArgs, AResult) then Exit;
//      end;
//    end;
//  end else
//    InitializeArgs;
//
//  LParam.FStackBase := LStackIndex;
//
//  LBlock := AContext.FBlocks;
//  while (LBlock <> nil) do
//  begin
//    LItem := LBlock.FItemsFirst;
//    while (LItem <> nil) do
//    begin
//      if LParam.FIsTerminated then
//      begin
//        StackVarsAdd(AContext.FVarsCount);
//        if LAdded then Dec(This.FCrCount);
//        Exit;
//      end;
//
//      EngineContextBlockItem(LItem^, LParam);
//      LItem := LItem.FNext;
//    end;
//
//    LBlock := LBlock.FNext;
//  end;
//
//  CheckClosure(LParam.FResult^);
//  if AContext.FCanFinalizeRefClosureVar then
//  begin
//    LRefCVar := gvClosureVarsFirst;
//    while (LRefCVar <> nil) do
//    begin
//      if ((LRefCVar.FRunningId = LRunningId)
//        and (LRefCVar.FVarRef <> nil)) then
//      begin
//        LVar := LRefCVar.FVarRef.FVariable;
//        LRefCVar.FVarRef := nil;
//
//        if (LVar <> nil) then
//          FennerData_Assign(LRefCVar.FData,
//            StackVarsItem(LStackIndex + LVar.FIndex));
//      end;
//
//      LRefCVar := LRefCVar.FNext;
//    end;
//  end;
//
//  if (LRCacheEntry <> nil) then
//  begin
//    EngineRecursiveCacheEntry_Put(LRCacheEntry^, LArgs, AResult);
//    EngineRecursiveCacheEntry_DecRef(LRCacheEntry^);
//  end;
//
//  StackVarsRemove(AContext.FVarsCount);
//
//  if LAdded then Dec(This.FCrCount);
//end;

function EngineRunner_AddContext(var This: TEngineRunner;
  const AContext: PEngineContext; const ARunningId: Int64): Boolean;
var
  P: PEngineRunnerContextRecord;
begin
  if ((This.FCrCount > 0) and
    (This.FCrStack[This.FCrCount - 1].FContext = AContext)) then
      Exit(False);

  if (This.FCrCount = This.FCrCapacity) then
  begin
    Inc(This.FCrCapacity, 32);
    SetLength(This.FCrStack, This.FCrCapacity);
  end;

  P := @This.FCrStack[This.FCrCount];
  P.FContext := AContext;
  P.FStackBase := gvStackVarsIndex;
  P.FRunningId := ARunningId;
  Inc(This.FCrCount);

  Exit(True);
end;

{ TEngineCaller }

procedure TEngineCaller.AddParam(const AParam: PEngineContextValue);
begin
  if (FParamsCount >= Length(FParamsArray)) then
    SetLength(FParamsArray, (FParamsCount + 32));

  FParamsArray[FParamsCount] := AParam;
  Inc(FParamsCount);
end;

procedure TEngineCaller.AddParams(const AParams: PEngineContextValueArray);
var
  i: Integer;
begin
  for i := 0 to High(AParams.FValues) do
    AddParam(AParams.FValues[i]);
end;

procedure TEngineCaller.AddParams2(
  const AParams: PEngineContextValueConstArray);
var
  v: Pointer;
  i: Integer;
begin
  v := Pointer(AParams.FConstValue);
  for i := 0 to High(TFennerDataDynArray(v)) do
    AddParam(CreateEngineContextValueByData(@TFennerDataDynArray(v)[i]));
end;

function TEngineCaller.Build: PEngineContextValue;
var
  LFuncPtr: Pointer;
  LInnerContextValue: PEngineContextValue;
  LValue: PEngineContextValue;
  LValueConstFunction: PEngineContextValueConstFunction absolute LValue;
begin
  SetLength(FParamsArray, FParamsCount);

  if (FVariable = nil) then
  begin
    if (FToken.Id = tkrw_Array) then
      Exit(BuildAsArray);
    if (FToken.Id = tk_RefValue_) then
    begin
      LValue := FToken.p;
      if (LValue.FTypeId = EngCtxValueTpId_ConstFunction) then
      begin
        if (Pointer(LValueConstFunction.FConstValue) = FContext) then
          Exit(Pointer(EngineContextValueFunction_Create(
            Pointer(FContext), FParamsArray)));
      end;

      Exit(Pointer(EngineContextValueFunctionByValue_Create(
        FToken.p, FParamsArray)));
    end;
    if (FToken.Id = tk_Recursive) then
    begin
      if (FContext.FTypeId = EngCtxTp_Function) then
        Exit(Pointer(EngineContextValueFunction_Create(
          Pointer(FContext), FParamsArray)));
    end;
  end else
  begin
    LFuncPtr := FVariable.FData.vFn;
    if (FVariable.FData.vFn <> nil) then
    begin
      if (FVariable.FData.vId2 = Id2_Func_Default) then
        Exit(Pointer(EngineContextValueFunction_Create(LFuncPtr, FParamsArray)));

      Exit(nil);
    end;

    LInnerContextValue := CreateContextValueByVariable0(FContext, FVariable);
    Exit(Pointer(EngineContextValueFunctionByValue_Create(
      LInnerContextValue, FParamsArray)));
  end;

  raise EInternalError.Create('1517BE5A29324DFD8A10023CC833D3BC');
end;

function TEngineCaller.BuildAsArray: PEngineContextValue;
var
  LAB: TEngineArrayBuilder;
begin
  LAB.FItemsArray := FParamsArray;
  LAB.FItemsCount := FParamsCount;
  Exit(LAB.Build());
end;

class function TEngineCaller.Create(const AContext: PEngineContext;
  const AVariable: PEngineContextVariable;
  const AToken: PToken): PEngineCaller;
begin
  Result := AllocMem(SizeOf(TEngineCaller));
  Result.FContext := AContext;
  Result.FVariable := AVariable;
  Result.FToken := AToken;
end;

{ TEngineArrayBuilder }

procedure TEngineArrayBuilder.Add(const AItem: PEngineContextValue);
begin
  if (FItemsCount >= Length(FItemsArray)) then
    SetLength(FItemsArray, (FItemsCount + 32));

  FItemsArray[FItemsCount] := AItem;
  Inc(FItemsCount);
end;

function TEngineArrayBuilder.Build: PEngineContextValue;
var
  R0: PEngineContextValueConstArray;
  R1: PEngineContextValueArray;
  i: Integer;
begin
  SetLength(FItemsArray, FItemsCount);

  if ItemsIsConst then
  begin
    R0 := AllocMem(SizeOf(TEngineContextValueConstArray));
    R0.FBase.FTypeId := EngCtxValueTpId_ConstArray;
    SetLength(R0.FConstValue, FItemsCount);
    for i := 0 to (FItemsCount - 1) do
      EngineContextValue_Execute(FItemsArray[i]^,
        PEngineRunnerItem(nil)^, R0.FConstValue[i]);
    Exit(Pointer(R0));
  end;

  R1 := AllocMem(SizeOf(TEngineContextValueArray));
  R1.FBase.FTypeId := EngCtxValueTpId_Array;
  R1.FValues := FItemsArray;
  Exit(Pointer(R1));
end;

class function TEngineArrayBuilder.Create: PEngineArrayBuilder;
begin
  Exit(AllocMem(SizeOf(TEngineArrayBuilder)));
end;

function TEngineArrayBuilder.ItemsIsConst: Boolean;
var
  i: Integer;
begin
  for i := 0 to (FItemsCount - 1) do
    if (not EngineContextValue_IsConst(FItemsArray[i]^)) then Exit(False);
  Exit(True);
end;

end.

