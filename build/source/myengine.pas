(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*                                                                            *)
(******************************************************************************)
unit MyEngine;

{$mode Delphi}{$H+}
{$pointermath on}
{$scopedenums on}

interface

uses
  MyTypes,
  MyData,
  MyScanner;

type
  PPMyEngineContextValue = ^PMyEngineContextValue;

  PMyEngineRunner = ^TMyEngineRunner;
  PMyEngineRunnerItem = ^TMyEngineRunnerItem;
  PMyEngineContext = ^TMyEngineContext;
  PMyEngineContextGlobal = ^TMyEngineContextGlobal;
  PMyEngineContextFunction = ^TMyEngineContextFunction;

  PMyEngineContextBlock = ^TMyEngineContextBlock;
  PMyEngineContextBlockItem = ^TMyEngineContextBlockItem;
  PMyEngineContextBlockItemLet = ^TMyEngineContextBlockItemLet;

  PMyEngineContextBlockItemLetConstBool = ^TMyEngineContextBlockItemLetConstBool;
  PMyEngineContextBlockItemLetConstInt = ^TMyEngineContextBlockItemLetConstInt;
  PMyEngineContextBlockItemLetConstStr = ^TMyEngineContextBlockItemLetConstStr;
  PMyEngineContextBlockItemLetConstFunction = ^TMyEngineContextBlockItemLetConstFunction;
  PMyEngineContextBlockItemLetConstArray = ^TMyEngineContextBlockItemLetConstArray;
  PMyEngineContextBlockItemLetArray = ^TMyEngineContextBlockItemLetArray;
  PMyEngineContextBlockItemLetValue = ^TMyEngineContextBlockItemLetValue;
  PMyEngineContextBlockItemCall = ^TMyEngineContextBlockItemCall;
  PMyEngineContextBlockItemReturn = ^TMyEngineContextBlockItemReturn;
  PMyEngineContextBlockItemIf = ^TMyEngineContextBlockItemIf;
  PMyEngineContextBlockItemBinCode = ^TMyEngineContextBlockItemBinCode;

  PMyEngineContextVariable = ^TMyEngineContextVariable;
  PMyEngineContextValue = ^TMyEngineContextValue;
  PMyEngineContextValueConstBool = ^TMyEngineContextValueConstBool;
  PMyEngineContextValueConstInt = ^TMyEngineContextValueConstInt;
  PMyEngineContextValueConstString = ^TMyEngineContextValueConstString;
  PMyEngineContextValueConstFunction = ^TMyEngineContextValueConstFunction;
  PMyEngineContextValueConstArray = ^TMyEngineContextValueConstArray;

  PMyEngineContextValueByVariable = ^TMyEngineContextValueByVariable;
  PMyEngineContextValueArray = ^TMyEngineContextValueArray;

  PMyEngineContextValueNegative = ^TMyEngineContextValueNegative;
  PMyEngineContextValueOp2 = ^TMyEngineContextValueOp2;
  PMyEngineContextValueFunction = ^TMyEngineContextValueFunction;
  PMyEngineContextValueFunctionByValue = ^TMyEngineContextValueFunctionByValue;
  PMyEngineContextValueIf = ^TMyEngineContextValueIf;

  TMyEngineContextTypeId = (eNone, eGlobal, eFunction);

  TMyEngineContextBlockItemTypeId = (eNone,
    eLetConstBool,
    eLetConstInt,
    eLetConstString,
    eLetConstFunction,
    eLetConstArray,
    eLetArray,
    eLetValue,
    eCall,
    eReturn,
    eIf,
    eBinCode
  );

  TMyEngineContextValueTypeId = (eNone, eConstBool, eConstInt, eConstString,
    eConstFunction, eConstArray,

    eVariableGlobal,
    eVariable0,
    eVariableN,

    eArray,

    eNegative,

    eOp2,
    eFunction,
    eFunctionByValue,
    eIf
  );

  TMyEngineContextFunctionTypeId = (
    eNone,
    eAST,
    eFibonacci,
    eCombination,
    eSumOfPA,
    eFactorial
  );

  TMyEngineGlobalContextSaveState = record
  private
    FContextGlobal: PMyEngineContextGlobal;
  public
    procedure Backup;
    procedure Restore;
  end;

  TMyEngineRunner = record
  private

    type
      TContextRecord = record
      public
        Context: PMyEngineContext;    { Weak }
        StackBase: Integer;
      end;

    var
      FCrStack: TArray<TContextRecord>;
      FCrCount: Integer;
      FCrCapacity: Integer;

    function AddContext(const AContext: PMyEngineContext): Boolean;
    procedure ExecuteContext(const AContext: PMyEngineContext;
      const AParams: TArray<PMyEngineContextValue>;
      const AOwnerStackBase: Integer; var AResult: TMyEngineContextVariableData);
    procedure Initialize;
  end;

  TMyEngineRunnerItem = record
  private
    FRunner: PMyEngineRunner;               { Weak }
    FResult: PMyEngineContextVariableData;  { Weak }
    FCrCount: Integer;
    FStackBase: Integer;
    FGlobalStackBase: Integer;
    FParamCount: Integer;
    FIsTerminated: Boolean;
  end;

  TMyEngineRunnerItem_BinaryCode_Proc = procedure (
    AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);

  TMyEngineContext = record
  public
    FTypeId: TMyEngineContextTypeId;
    FOwner: PMyEngineContext;               { Weak }
    FLevel: Integer;
    FVarsCount: Integer;
    FVarsFirst: PMyEngineContextVariable;
    FReadingVar: PMyEngineContextVariable;  { Weak }
    FBlocks: PMyEngineContextBlock;
  private
    procedure Parse(var ATokenStack: TMyTokenStack; var AIndex: Integer);
    procedure ParseGlobal;

    function FindVar(const AName: LString): PMyEngineContextVariable;

    function LocalFindOrDeclrVar(
      const AName: LString): PMyEngineContextVariable;
    function VarByName(const AToken: PMyToken): PMyEngineContextVariable;

    function RelativeIndexOf(const AContext: PMyEngineContext): Integer;
  end;

  TMyEngineContextGlobal = record
  public
    FBase: TMyEngineContext;

    class function Create: PMyEngineContextGlobal; static;
  strict private
    procedure CreateSysFunc_Print;

    procedure CreateSysFunc_ArrayGetItem(const AName: LString;
      const AProc: TMyEngineRunnerItem_BinaryCode_Proc);
    procedure CreateSysFunc_ArrayGetItems;
    function CreateSysFunc(const AName: LString; const AProc:
      TMyEngineRunnerItem_BinaryCode_Proc): PMyEngineContextFunction;
  end;

  TMyEngineContextFunction = record
  public
    FBase: TMyEngineContext;
    FMinParamsCount: Integer;
    FMaxParamsCount: Integer;
    FConstDeclr: PMyEngineContextValueConstFunction;
    FDeclrName: LString;
    FTypeId: TMyEngineContextFunctionTypeId;

    class function Create(
      const AOwner: PMyEngineContext): PMyEngineContextFunction; static;
  end;

  TMyEngineContextBlock = record
  public
    FContext: PMyEngineContext;         { Weak }
    FNext: PMyEngineContextBlock;
    FItemsFirst: PMyEngineContextBlockItem;
    FItemsLast: PMyEngineContextBlockItem;
  private
    procedure ItemsAdd(const AItem: PMyEngineContextBlockItem);
  end;

  TMyEngineContextBlockItem = record
  public
    FTypeId: TMyEngineContextBlockItemTypeId;
    FContext: PMyEngineContext;         { Weak }
    FBlock: PMyEngineContextBlock;      { Weak }
    FNext: PMyEngineContextBlockItem;
  end;

  TMyEngineContextBlockItemLet = record
  public
    FBase: TMyEngineContextBlockItem;
    FVarIndex: Integer;
  end;

  TMyEngineContextBlockItemLetConstBool = record
  public
    FBase: TMyEngineContextBlockItemLet;
    FConstValue: Boolean;
  end;

  TMyEngineContextBlockItemLetConstInt = record
  public
    FBase: TMyEngineContextBlockItemLet;
    FConstValue: Int64;
  end;

  TMyEngineContextBlockItemLetConstStr = record
  public
    FBase: TMyEngineContextBlockItemLet;
    FConstValue: LString;
  end;

  TMyEngineContextBlockItemLetConstFunction = record
  public
    FBase: TMyEngineContextBlockItemLet;
    FConstValue: Pointer;
  end;

  TMyEngineContextBlockItemLetConstArray = record
  public
    FBase: TMyEngineContextBlockItemLet;
    FConstValue: TMyEngineContextVariableDataDynArray;
  end;

  TMyEngineContextBlockItemLetArray = record
  public
    FBase: TMyEngineContextBlockItemLet;
    FValues: TArray<PMyEngineContextValue>;
  end;

  TMyEngineContextBlockItemLetValue = record
  public
    FBase: TMyEngineContextBlockItemLet;
    FValue: PMyEngineContextValue;
  end;

  TMyEngineContextBlockItemCall = record
  public
    FBase: TMyEngineContextBlockItem;
    FSourceValue: PMyEngineContextValue;
  end;

  TMyEngineContextBlockItemReturn = record
  public
    FBase: TMyEngineContextBlockItem;
    FSourceValue: PMyEngineContextValue;
  end;

  TMyEngineContextBlockItemIf = record
  public
    FBase: TMyEngineContextBlockItem;
    FExpression: PMyEngineContextValue;
    FThen: PMyEngineContextBlock;
    FElse: PMyEngineContextBlock;
  end;

  TMyEngineContextBlockItemBinCode = record
  public
    FBase: TMyEngineContextBlockItem;
    FProc: TMyEngineRunnerItem_BinaryCode_Proc;
    class function Create(const AProc: TMyEngineRunnerItem_BinaryCode_Proc):
      PMyEngineContextBlockItemBinCode; static;
  end;

  TMyEngineContextVariable = record
  public
    FContext: PMyEngineContext;         { Weak }
    FNext: PMyEngineContextVariable;
    FName: LString;
    FIndex: Integer;
    FData: TMyEngineContextVariableData;

    class function Create: PMyEngineContextVariable; static;
  end;

  TMyEngineContextValue = record
  public
    FTypeId: TMyEngineContextValueTypeId;

    procedure Execute(var AItem: TMyEngineRunnerItem;
      var AResult: TMyEngineContextVariableData);

    function IsConstValue: Boolean;
  end;

  TMyEngineContextValueConstBool = record
  public
    FBase: TMyEngineContextValue;
    FConstValue: Boolean;
  end;

  TMyEngineContextValueConstInt = record
  public
    FBase: TMyEngineContextValue;
    FConstValue: Int64;
  end;

  TMyEngineContextValueConstString = record
  public
    FBase: TMyEngineContextValue;
    FConstValue: LString;
  end;

  TMyEngineContextValueConstFunction = record
  public
    FBase: TMyEngineContextValue;
    FConstValue: PMyEngineContextFunction;
  end;

  TMyEngineContextValueConstArray = record
  public
    FBase: TMyEngineContextValue;
    FConstValue: TMyEngineContextVariableDataDynArray;
  end;

  TMyEngineContextValueByVariable = record
  public
    FBase: TMyEngineContextValue;
    FVarIndex: Integer;
    FRelContextIndex: Integer;
  end;

  TMyEngineContextValueArray = record
  public
    FBase: TMyEngineContextValue;
    FValues: TArray<PMyEngineContextValue>;
  end;

  TMyEngineContextValueNegative = record
  public
    FBase: TMyEngineContextValue;
    FRefValue: PMyEngineContextValue;

    class function Create(const ARefValue:
      PMyEngineContextValue): PMyEngineContextValueNegative; static;
  end;

  TMyEngineContextValueOp2 = record
  public
    FBase: TMyEngineContextValue;

    FLeft: PMyEngineContextValue;
    FRight: PMyEngineContextValue;
    FIndexOp: Word;
    FOp: Byte;

    { cdtor }
    class function Create(const ALeft, ARight: PMyEngineContextValue;
      const AOp: Byte): PMyEngineContextValueOp2; static;
  end;

  TMyEngineContextValueFunction = record
  public
    FBase: TMyEngineContextValue;
    FFunction: PMyEngineContextFunction;    { Weak }
    FParams: TArray<PMyEngineContextValue>;

    class function Create(const AFunction: PMyEngineContextFunction;
      const AParams: TArray<PMyEngineContextValue>):
      PMyEngineContextValueFunction; static;
  end;

  TMyEngineContextValueFunctionByValue = record
  public
    FBase: TMyEngineContextValue;
    FValue: PMyEngineContextValue;
    FParams: TArray<PMyEngineContextValue>;

    class function Create(const AValue: PMyEngineContextValue;
      const AParams: TArray<PMyEngineContextValue>):
      PMyEngineContextValueFunctionByValue; static;
  end;

  TMyEngineContextValueIf = record
  public
    FBase: TMyEngineContextValue;
    FExpression: PMyEngineContextValue;
    FThen: PMyEngineContextBlock;
    FElse: PMyEngineContextBlock;
  end;

procedure MyEngine_Execute; overload;
procedure MyEngine_Execute(var AResult: TMyEngineContextVariableData); overload;

implementation

uses
  MyErrs,
  MyOperators,
  MySysUtils,
  MyCombinationUnit;

var
  GenId_FunctionName: Integer;

procedure GenerateFunctionName(const AFunction: PMyEngineContextFunction);
begin
  if (Pointer(AFunction.FDeclrName) = nil) then
  begin
    AFunction.FDeclrName := '_func_' + Int32ToLString(GenId_FunctionName);
    Inc(GenId_FunctionName);
  end;
end;

function GetFunctionName(const AFunction: PMyEngineContextFunction): LString;
var
  LContext: PMyEngineContext;
  LS: LString;
begin
  if (AFunction = nil) then Exit('(nil)');

  Result := AFunction.FDeclrName;

  LContext := AFunction.FBase.FOwner;
  while (LContext <> nil) do
  begin
    if (LContext.FTypeId = TMyEngineContextTypeId.eFunction) then
    begin
      LS := PMyEngineContextFunction(LContext).FDeclrName;
      if (Length(LS) > 0) then
        Result := LS + '.' + Result;
    end;
    LContext := LContext.FOwner;
  end;
end;

function SetFunctionTypeId(const AFunction: PMyEngineContextFunction;
  const ATypeId: TMyEngineContextFunctionTypeId): Boolean;
begin
  AFunction.FTypeId := ATypeId;
  Exit(True);
end;

function __ValueIsVar0(
  const a: PMyEngineContextValue;
  const AVarIndex: Integer): Boolean;
var
  v: PMyEngineContextValueByVariable absolute a;
begin
  if (a = nil) then Exit(False);
  if (a.FTypeId <> TMyEngineContextValueTypeId.eVariable0) then Exit(False);
  Exit(v.FVarIndex = AVarIndex);
end;

function __ValueIsIntConst(
  const a: PMyEngineContextValue;
  const AIntConst: Int64): Boolean;
var
  v: PMyEngineContextValueConstInt absolute a;
begin
  if (a = nil) then Exit(False);
  if (a.FTypeId <> TMyEngineContextValueTypeId.eConstInt) then Exit(False);
  Exit(v.FConstValue = AIntConst);
end;

function __IsFibonacci(const L, R: PMyEngineContextBlock): Boolean;
var
  MItem: PMyEngineContextBlockItem;
  MItemReturn: PMyEngineContextBlockItemReturn absolute MItem;
  MValue: PMyEngineContextValue;
  MValueOp2: PMyEngineContextValueOp2 absolute MValue;
  MFlag: Byte;

  function LChk(const AValue: PMyEngineContextValue): Boolean;
  var
    LValue: PMyEngineContextValueFunction absolute AValue;
    LParam: PMyEngineContextValue;
    LParamOp2: PMyEngineContextValueOp2 absolute LParam;
  begin
    if ((AValue = nil) or (AValue.FTypeId <> TMyEngineContextValueTypeId.eFunction)) then Exit(False);
    if (Pointer(LValue.FFunction) <> L.FContext) then Exit(False);
    if (Length(LValue.FParams) <> 1) then Exit(False);
    LParam := LValue.FParams[0];
    if (LParam.FTypeId <> TMyEngineContextValueTypeId.eOp2) then Exit(False);
    if (LParamOp2.FOp <> tkop_Sub) then Exit(False);
    if (not __ValueIsVar0(LParamOp2.FLeft, 0)) then Exit(False);
    if __ValueIsIntConst(LParamOp2.FRight, 1) then
    begin
      MFlag := (MFlag or 1);
      Exit(True);
    end;
    if __ValueIsIntConst(LParamOp2.FRight, 2) then
    begin
      MFlag := (MFlag or 2);
      Exit(True);
    end;
    Exit(False);
  end;

begin
  if ((L = nil) or (R = nil)) then Exit(False);

  MItem := L.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> TMyEngineContextBlockItemTypeId.eReturn) then Exit(False);

  if (not __ValueIsVar0(MItemReturn.FSourceValue, 0)) then Exit(False);

  MItem := R.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> TMyEngineContextBlockItemTypeId.eReturn) then Exit(False);

  MValue := MItemReturn.FSourceValue;
  if ((MValue = nil) or (MValue.FTypeId <> TMyEngineContextValueTypeId.eOp2)) then Exit(False);
  if (MValueOp2.FOp <> tkop_Add) then Exit(False);

  MFlag := 0;
  if ((not LChk(MValueOp2.FLeft)) or (not LChk(MValueOp2.FRight))) then Exit(False);

  if (MFlag <> 3) then Exit(False);
  Exit(True);
end;

function __IsSumOfPA(const L, R: PMyEngineContextBlock): Boolean;
var
  MItem: PMyEngineContextBlockItem;
  MItemReturn: PMyEngineContextBlockItemReturn absolute MItem;
  MValue: PMyEngineContextValue;
  MValueOp2: PMyEngineContextValueOp2 absolute MValue;
  MFlags: Byte;

  function ChkPar(const AValue: PMyEngineContextValue): Boolean;
  var
    OValue: PMyEngineContextValueFunction absolute AValue;
    OParam: PMyEngineContextValue;
    OParamOp2: PMyEngineContextValueOp2 absolute OParam;
  begin
    if (AValue = nil) then Exit(False);

    if __ValueIsVar0(AValue, 0) then
    begin
      MFlags := (MFlags or 1);
      Exit(True);
    end;

    if (AValue.FTypeId <> TMyEngineContextValueTypeId.eFunction) then Exit(False);
    if (OValue.FFunction <> Pointer(MItem.FContext)) then Exit(False);
    if (System.Length(OValue.FParams) <> 1) then Exit(False);

    OParam := OValue.FParams[0];
    if (OParam.FTypeId <> TMyEngineContextValueTypeId.eOp2) then Exit(False);
    if (OParamOp2.FOp <> tkop_Sub) then Exit(False);

    if (not __ValueIsVar0(OParamOp2.FLeft, 0)) then Exit(False);
    if (not __ValueIsIntConst(OParamOp2.FRight, 1)) then Exit(False);

    MFlags := (MFlags or 2);
    Exit(True);
  end;

begin
  if ((L = nil) or (R = nil)) then Exit(False);

  MItem := L.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> TMyEngineContextBlockItemTypeId.eReturn) then Exit(False);
  if (not __ValueIsVar0(MItemReturn.FSourceValue, 0)) then Exit(False);

  MItem := R.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> TMyEngineContextBlockItemTypeId.eReturn) then Exit(False);

  MValue := MItemReturn.FSourceValue;
  if ((MValue = nil) or (MValue.FTypeId <> TMyEngineContextValueTypeId.eOp2)) then Exit(False);

  MFlags := 0;
  if (not (ChkPar(MValueOp2.FLeft) and ChkPar(MValueOp2.FRight))) then Exit(False);
  if (MFlags <> 3) then Exit(False);

  Exit(True);
end;

function __IsFactorial(const L, R: PMyEngineContextBlock): Boolean;
var
  MItem: PMyEngineContextBlockItem;
  MItemReturn: PMyEngineContextBlockItemReturn absolute MItem;
begin
  if ((L = nil) or (R = nil)) then Exit(False);

  MItem := L.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> TMyEngineContextBlockItemTypeId.eReturn) then Exit(False);
  if (not __ValueIsIntConst(MItemReturn.FSourceValue, 1)) then Exit(False);


  Random(0);
  Exit(False);
end;

function TryOptimizeFunction_1(
  const AFunction: PMyEngineContextFunction): Boolean;
var
  LBlock: PMyEngineContextBlock;
  LBlockItem: PMyEngineContextBlockItem;
  LBlockItemIf: PMyEngineContextBlockItemIf absolute LBlockItem;
  LExpression: PMyEngineContextValue;
  LExpressionOp2: PMyEngineContextValueOp2 absolute LExpression;
begin
  LBlock := AFunction.FBase.FBlocks;
  if ((LBlock = nil) or (LBlock.FNext <> nil)) then Exit(False);

  LBlockItem := LBlock.FItemsFirst;
  if (LBlockItem = nil) then Exit(False);

  if (LBlockItem.FNext = nil) then
  begin
    case LBlockItem.FTypeId of
      TMyEngineContextBlockItemTypeId.eIf:
        begin
          LExpression := LBlockItemIf.FExpression;
          if (LExpression <> nil) then
            case LExpression.FTypeId of
              TMyEngineContextValueTypeId.eOp2:
                begin
                  case LExpressionOp2.FOp of
                    tkop_Eq:
                      begin
                        { a == b }
                        if __ValueIsVar0(LExpressionOp2.FLeft, 0) then
                        begin
                          if __ValueIsIntConst(LExpressionOp2.FRight, 1) then
                          begin
                            if __IsSumOfPA(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(SetFunctionTypeId(AFunction,
                                TMyEngineContextFunctionTypeId.eSumOfPA));
                          end;
                        end else
                        if __ValueIsIntConst(LExpressionOp2.FLeft, 1) then
                        begin
                          if __ValueIsVar0(LExpressionOp2.FRight, 0) then
                          begin
                            if __IsSumOfPA(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(SetFunctionTypeId(AFunction,
                                TMyEngineContextFunctionTypeId.eSumOfPA));
                          end;
                        end;
                      end;
                    tkop_Lt:
                      begin
                        { a < b }
                        if __ValueIsVar0(LExpressionOp2.FLeft, 0) then
                        begin
                          if __ValueIsIntConst(LExpressionOp2.FRight, 2) then
                          begin
                            if __IsFibonacci(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(SetFunctionTypeId(AFunction,
                                TMyEngineContextFunctionTypeId.eFibonacci));
                          end else
                          if __ValueIsIntConst(LExpressionOp2.FRight, 1) then
                          begin
                            if __IsFactorial(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(SetFunctionTypeId(AFunction,
                                TMyEngineContextFunctionTypeId.eFactorial));
                          end;
                        end;
                      end;
                    tkop_Gt:
                      begin
                        { a > b }
                        if __ValueIsVar0(LExpressionOp2.FRight, 0) and
                           __ValueIsIntConst(LExpressionOp2.FLeft, 2) then
                        begin
                          if __IsFibonacci(LBlockItemIf.FElse, LBlockItemIf.FThen) then
                            Exit(SetFunctionTypeId(AFunction,
                              TMyEngineContextFunctionTypeId.eFibonacci));
                        end;
                      end;
                    tkop_Lte:
                      begin
                        { a <= b }
                        if __ValueIsVar0(LExpressionOp2.FLeft, 0) then
                        begin
                          if __ValueIsIntConst(LExpressionOp2.FRight, 1) then
                          begin
                            if __IsFibonacci(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(SetFunctionTypeId(AFunction,
                                TMyEngineContextFunctionTypeId.eFibonacci));
                          end else
                          if __ValueIsIntConst(LExpressionOp2.FRight, 0) then
                          begin
                            if __IsFactorial(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(SetFunctionTypeId(AFunction,
                                TMyEngineContextFunctionTypeId.eFactorial));
                          end;
                        end;
                      end;
                    tkop_Gte:
                      begin
                        { a >= b }
                        if __ValueIsVar0(LExpressionOp2.FRight, 0) then
                        begin
                          if __ValueIsIntConst(LExpressionOp2.FLeft, 1) then
                          begin
                            if __IsFibonacci(LBlockItemIf.FElse, LBlockItemIf.FThen) then
                              Exit(SetFunctionTypeId(AFunction,
                                TMyEngineContextFunctionTypeId.eFibonacci));
                          end;
                        end;
                      end;
                  end;
                end;
            end;
        end;
    end;
  end;

  Exit(False);
end;

function TryOptimizeFunction_2_Combination(
  const AFunction: PMyEngineContextFunction): Boolean;
var
  LBlock: PMyEngineContextBlock;
  LBlockItem: PMyEngineContextBlockItem;
  LFlagLets: Byte;

  function ChkLetValue: Boolean;
  var
    LVI: Integer;
    LBlockItemLetValue: PMyEngineContextBlockItemLetValue absolute LBlockItem;
    LValue, LVL, LVR: PMyEngineContextValue;
    LValueOp2: PMyEngineContextValueOp2 absolute LValue;
  begin
    LVI := LBlockItemLetValue.FBase.FVarIndex;
    if ((LVI <> 2) and (LVI <> 3)) then Exit(False);
    LFlagLets := (LFlagLets or (LVI - 1));

    LValue := LBlockItemLetValue.FValue;
    if ((LValue = nil) or
      (LValue.FTypeId <> TMyEngineContextValueTypeId.eOp2)) then
        Exit(False);
    if (LValueOp2.FOp <> tkop_Eq) then Exit(False);

    LVL := LValueOp2.FLeft;
    LVR := LValueOp2.FRight;

    if __ValueIsVar0(LVL, 1) then
    begin
      if __ValueIsVar0(LVR, 0) then
        LFlagLets := (LFlagLets or 4)
      else if __ValueIsIntConst(LVR, 0) then
        LFlagLets := (LFlagLets or 8)
      else
        Exit(False);
    end else
    if __ValueIsVar0(LVR, 1) then
    begin
      if __ValueIsVar0(LVL, 0) then
        LFlagLets := (LFlagLets or 4)
      else if __ValueIsIntConst(LVL, 0) then
        LFlagLets := (LFlagLets or 8)
      else
        Exit(False);
    end else
      Exit(False);

    Exit(True);
  end;

  function ChkIf: Boolean;
  var
    MIf: PMyEngineContextBlockItemIf absolute LBlockItem;
    MBlock: PMyEngineContextBlock;
    MBlockItem: PMyEngineContextBlockItem;
    MBlockItemReturn: PMyEngineContextBlockItemReturn absolute MBlockItem;
    LValue: PMyEngineContextValue;
    LValueOp2: PMyEngineContextValueOp2 absolute LValue;

    function ChkPart(const APart: PMyEngineContextValue): Boolean;
    var
      NPart: PMyEngineContextValueFunction absolute APart;
      NParam: PMyEngineContextValue;
      NParamOp2: PMyEngineContextValueOp2 absolute NParam;
    begin
      if ((APart = nil) or (APart.FTypeId <> TMyEngineContextValueTypeId.eFunction)) then Exit(False);
      if (NPart.FFunction <> AFunction) then Exit(False);
      if (Length(NPart.FParams) <> 2) then Exit(False);

      NParam := NPart.FParams[0];
      if (NParam.FTypeId <> TMyEngineContextValueTypeId.eOp2) then Exit(False);
      if (NParamOp2.FOp <> tkop_Sub) then Exit(False);
      if (not __ValueIsVar0(NParamOp2.FLeft, 0)) then Exit(False);
      if (not __ValueIsIntConst(NParamOp2.FRight, 1)) then Exit(False);

      NParam := NPart.FParams[1];
      if (NParam.FTypeId = TMyEngineContextValueTypeId.eOp2) then
      begin
        if (NParamOp2.FOp <> tkop_Sub) then Exit(False);
        if (not __ValueIsVar0(NParamOp2.FLeft, 1)) then Exit(False);
        if (not __ValueIsIntConst(NParamOp2.FRight, 1)) then Exit(False);

        LFlagLets := (LFlagLets or 16);
        Exit(True);
      end;

      if __ValueIsVar0(NParam, 1) then
      begin
        LFlagLets := (LFlagLets or 32);
        Exit(True);
      end;

      Exit(False);
    end;

    function CheckOp48(AValue: PMyEngineContextValue): Boolean;
    var
      OValue: PMyEngineContextValueOp2 absolute AValue;
      PLV, PRV: PMyEngineContextValue;
    begin
      if (AValue = nil) then Exit(False);
      if (AValue.FTypeId <> TMyEngineContextValueTypeId.eOp2) then Exit(False);
      if (OValue.FOp <> tkop_Eq) then Exit(False);

      PLV := OValue.FLeft;
      PRV := OValue.FRight;
      if ((PLV = nil) or (PRV = nil)) then Exit(False);

      if __ValueIsVar0(PLV, 1) then
      begin
        if __ValueIsVar0(PRV, 0) then
          LFlagLets := (LFlagLets or 4)
        else if __ValueIsIntConst(PRV, 0) then
          LFlagLets := (LFlagLets or 8)
        else
          Exit(False);
      end else
      if __ValueIsVar0(PRV, 1) then
      begin
        if __ValueIsVar0(PLV, 0) then
          LFlagLets := (LFlagLets or 4)
        else if __ValueIsIntConst(PLV, 0) then
          LFlagLets := (LFlagLets or 8)
        else
          Exit(False);
      end else
        Exit(False);

      Exit(True);
    end;

    function CheckOp53Or57(AValue: PMyEngineContextValue): Boolean;
    begin
      if (AValue = nil) then Exit(False);

      if __ValueIsVar0(AValue, 2) then
      begin
        LFlagLets := (LFlagLets or 8);
        Exit(True);
      end;

      Exit(CheckOp48(AValue));
    end;

  begin
    if (LBlockItem.FNext <> nil) then Exit(False);

    MBlock := MIf.FThen;
    if (MBlock = nil) then Exit(False);

    MBlockItem := MBlock.FItemsFirst;
    if ((MBlockItem = nil) or (MBlockItem.FNext <> nil)) then Exit(False);
    if (MBlockItem.FTypeId <> TMyEngineContextBlockItemTypeId.eReturn) then Exit(False);
    if (not __ValueIsIntConst(MBlockItemReturn.FSourceValue, 1)) then Exit(False);

    MBlock := MIf.FElse;
    if (MBlock = nil) then Exit(False);
    MBlockItem := MBlock.FItemsFirst;
    if ((MBlockItem = nil) or (MBlockItem.FNext <> nil)) then Exit(False);
    if (MBlockItem.FTypeId <> TMyEngineContextBlockItemTypeId.eReturn) then Exit(False);

    LValue := MBlockItemReturn.FSourceValue;
    if ((LValue = nil) or (LValue.FTypeId <> TMyEngineContextValueTypeId.eOp2)) then Exit(False);
    if (LValueOp2.FOp <> tkop_Add) then Exit(False);

    if (not (ChkPart(LValueOp2.FLeft) and ChkPart(LValueOp2.FRight))) then Exit(False);

    LValue := MIf.FExpression;
    if ((LValue = nil) or (LValue.FTypeId <> TMyEngineContextValueTypeId.eOp2)) then Exit(False);
    if (LValueOp2.FOp <> tkop_Or) then Exit(False);

    case LFlagLets of
      48:
        begin
          if (CheckOp48(LValueOp2.FLeft) and CheckOp48(LValueOp2.FRight)) then
          begin
            if (LFlagLets = 60) then Exit(True);
          end;
        end;
      53, 57:
        begin
          if (CheckOp53Or57(LValueOp2.FLeft) and CheckOp53Or57(LValueOp2.FRight)) then
            if (LFlagLets = 61) then Exit(True);
        end;
      63:
        begin
          if __ValueIsVar0(LValueOp2.FLeft, 2) then
          begin
            if __ValueIsVar0(LValueOp2.FRight, 3) then
              Exit(True);
          end else
          if __ValueIsVar0(LValueOp2.FRight, 2) then
          begin
            if __ValueIsVar0(LValueOp2.FLeft, 3) then
              Exit(True);
          end;
        end;
    end;

    Exit(False);
  end;

begin
  LBlock := AFunction.FBase.FBlocks;
  if ((LBlock = nil) or (LBlock.FNext <> nil)) then Exit(False);

  LFlagLets := 0;
  LBlockItem := LBlock.FItemsFirst;
  while (LBlockItem <> nil) do
  begin
    case LBlockItem.FTypeId of
      TMyEngineContextBlockItemTypeId.eLetValue:
        if (not ChkLetValue) then Exit(False);
      TMyEngineContextBlockItemTypeId.eIf:
        if (not ChkIf) then Exit(False);
      else
        Exit(False);
    end;

    LBlockItem := LBlockItem.FNext;
  end;

  Exit(SetFunctionTypeId(AFunction,
    TMyEngineContextFunctionTypeId.eCombination));
end;

function TryOptimizeFunction_2(
  const AFunction: PMyEngineContextFunction): Boolean;
begin
  Exit(TryOptimizeFunction_2_Combination(AFunction));
end;

function TryOptimizeFunction(
  const AFunction: PMyEngineContextFunction): Boolean;
begin
  case AFunction.FMinParamsCount of
    1: Exit(TryOptimizeFunction_1(AFunction));
    2: Exit(TryOptimizeFunction_2(AFunction));
  end;

  Exit(False);
end;

procedure EngineRunnerItem_Execute_If(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem); forward;

procedure TMyEngineContextValue_Execute_If(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData); forward;

type
  TProcOf_MyEngineContextValue_Execute = procedure(
    AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
      var AResult: TMyEngineContextVariableData);

  TProcOf_EngineContextBlock_ParseItemLetValue = procedure(
    var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
    const AValue: PMyEngineContextValue);

  TProcOf_EngineRunnerItem_Execute =
    procedure(AThis: PMyEngineContextBlockItem;
      var AItem: TMyEngineRunnerItem);

procedure TMyEngineContextValue_Execute_None(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure TMyEngineContextValue_Execute_ConstBool(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(PMyEngineContextValueConstBool(AThis).FConstValue);
end;

procedure TMyEngineContextValue_Execute_ConstInt(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(PMyEngineContextValueConstInt(AThis).FConstValue);
end;

procedure TMyEngineContextValue_Execute_ConstString(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(PMyEngineContextValueConstString(AThis).FConstValue);
end;

procedure TmyEngineContextValue_Execute_ConstFunction(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsFunction(PMyEngineContextValueConstFunction(AThis).FConstValue);
end;

procedure TmyEngineContextValue_Execute_ConstArray(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsArray(PMyEngineContextValueConstArray(AThis).FConstValue);
end;

procedure TmyEngineContextValue_Execute_VariableGlobal(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
var
  LThis: PMyEngineContextValueByVariable absolute AThis;
begin
  AResult.Assign(StackVarItem(AItem.FGlobalStackBase + LThis.FVarIndex)^);
end;

procedure TmyEngineContextValue_Execute_Variable0(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
var
  LThis: PMyEngineContextValueByVariable absolute AThis;
begin
  AResult.Assign(StackVarItem(AItem.FStackBase + LThis.FVarIndex)^);
end;

procedure TmyEngineContextValue_Execute_VariableN(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
var
  LThis: PMyEngineContextValueByVariable absolute AThis;
  LIndex, LStackBase: Integer;
  LRunner: PMyEngineRunner;
begin
  LRunner := AItem.FRunner;

  LIndex := LThis.FRelContextIndex;
  if (Cardinal(LIndex) < Cardinal(LRunner.FCrCount)) then
  begin
    LStackBase := LRunner.FCrStack[LIndex].StackBase;

    AResult.Assign(StackVarItem(LStackBase + LThis.FVarIndex)^);
    Exit;
  end;
end;

procedure TmyEngineContextValue_Execute_Array(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
var
  LThis: PMyEngineContextValueArray absolute AThis;
  i, LCount: Integer;
begin
  LCount := Length(LThis.FValues);
  AResult.InitializeArray(LCount);

  for i := 0 to (LCount - 1) do
    LThis.FValues[i].Execute(AItem,
      TMyEngineContextVariableDataDynArray(AResult.vArr)[i]);
end;

procedure TmyEngineContextValue_Execute_Negative(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
begin
end;

procedure TmyEngineContextValue_Execute_Op2(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
var
  LThis: PMyEngineContextValueOp2 absolute AThis;
  Pars: TMyEngineContextVariableData2;
begin
  FillChar(Pars, SizeOf(Pars), 0);
  try
    LThis.FLeft.Execute(AItem, Pars[0]);
    LThis.FRight.Execute(AItem, Pars[1]);
    cInvProcTable[LThis.FIndexOp + Word(Pars[0].vId) * 6 + Word(Pars[1].vId)](Pars, AResult);
  finally
    Pars[0].SetId(TMyEngineContextVariableDataTypeId.eNone);
    Pars[1].SetId(TMyEngineContextVariableDataTypeId.eNone);
  end;
end;

procedure TmyEngineContextValue_Execute_Function(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
var
  LThis: PMyEngineContextValueFunction absolute AThis;
begin
  AItem.FRunner.ExecuteContext(Pointer(LThis.FFunction),
    LThis.FParams, AItem.FStackBase, AResult);
end;

procedure TmyEngineContextValue_Execute_FunctionByValue(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
var
  LThis: PMyEngineContextValueFunctionByValue absolute AThis;
  LData: PMyEngineContextVariableData;
  LIndex: Integer;
  LFunction: PMyEngineContextFunction;
begin
  LIndex := gvStackVarsIndex;
  AddStackVars(1);
  try
    LData := StackVarItem(LIndex);
    LThis.FValue.Execute(AItem, LData^);

    if (LData.vId = TMyEngineContextVariableDataTypeId.eFunc) then
    begin
      LFunction := LData.vFunc;
      AItem.FRunner.ExecuteContext(Pointer(LFunction),
        LThis.FParams, AItem.FStackBase, AResult);
    end;
  finally
    DecStackVars(1);
  end;
end;

procedure EngineContextBlock_ParseItemLetValue_Default(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
begin
end;

procedure EngineContextBlock_ParseItemLetValue_ConstBool(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
var
  R: PMyEngineContextBlockItemLetConstBool;
begin
  R := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstBool));
  R.FConstValue := PMyEngineContextValueConstBool(AValue).FConstValue;
  R.FBase.FVarIndex := AVar.FIndex;
  R.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstBool;
  ABlock.ItemsAdd(@R.FBase.FBase);
end;

procedure EngineContextBlock_ParseItemLetValue_ConstInt(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
var
  R: PMyEngineContextBlockItemLetConstInt;
begin
  R := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstInt));
  R.FConstValue := PMyEngineContextValueConstInt(AValue).FConstValue;
  R.FBase.FVarIndex := AVar.FIndex;
  R.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstInt;
  ABlock.ItemsAdd(Pointer(R));
end;

procedure EngineContextBlock_ParseItemLetValue_ConstStr(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
var
  R: PMyEngineContextBlockItemLetConstStr;
begin
  R := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstStr));
  R.FConstValue := PMyEngineContextValueConstString(AValue).FConstValue;
  R.FBase.FVarIndex := AVar.FIndex;
  R.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstString;
  ABlock.ItemsAdd(Pointer(R));
end;

procedure EngineContextBlock_ParseItemLetValue_ConstFunction(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
var
  R: PMyEngineContextBlockItemLetConstFunction;
begin
  R := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstFunction));
  R.FConstValue := PMyEngineContextValueConstFunction(AValue).FConstValue;
  R.FBase.FVarIndex := AVar.FIndex;
  R.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstFunction;
  ABlock.ItemsAdd(Pointer(R));
end;

procedure EngineContextBlock_ParseItemLetValue_ConstArray(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
var
  R: PMyEngineContextBlockItemLetConstArray;
begin
  R := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstArray));
  R.FConstValue := PMyEngineContextValueConstArray(AValue).FConstValue;
  R.FBase.FVarIndex := AVar.FIndex;
  R.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstArray;
  ABlock.ItemsAdd(Pointer(R));
end;

procedure EngineContextBlock_ParseItemLetValue_VariableGlobal(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
begin
end;

procedure EngineContextBlock_ParseItemLetValue_Variable0(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
begin
end;

procedure EngineContextBlock_ParseItemLetValue_VariableN(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
begin
end;

procedure EngineContextBlock_ParseItemLetValue_Array(
  var ABlock: TMyEngineContextBlock; const AVar: PMyEngineContextVariable;
  const AValue: PMyEngineContextValue);
var
  R: PMyEngineContextBlockItemLetArray;
begin
  R := AllocMem(SizeOf(TMyEngineContextBlockItemLetArray));
  R.FValues := PMyEngineContextValueArray(AValue).FValues;
  R.FBase.FVarIndex := AVar.FIndex;
  R.FBase.FBase.FTypeId:= TMyEngineContextBlockItemTypeId.eLetArray;
  ABlock.ItemsAdd(Pointer(R));
end;

procedure EngineRunnerItem_Execute_None(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
begin
end;

procedure EngineRunnerItem_Execute_ConstBool(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemLetConstBool absolute AThis;
begin
  StackVarItem(LThis.FBase.FVarIndex + AItem.FStackBase)
    .SetAsBoolean(LThis.FConstValue);
end;

procedure EngineRunnerItem_Execute_ConstInt(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemLetConstInt absolute AThis;
begin
  StackVarItem(LThis.FBase.FVarIndex + AItem.FStackBase)
    .SetAsInteger(LThis.FConstValue);
end;

procedure EngineRunnerItem_Execute_ConstStr(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemLetConstStr absolute AThis;
begin
  StackVarItem(LThis.FBase.FVarIndex + AItem.FStackBase)
    .SetAsString(LThis.FConstValue);
end;

procedure EngineRunnerItem_Execute_ConstFunction(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemLetConstFunction absolute AThis;
begin
  StackVarItem(LThis.FBase.FVarIndex + AItem.FStackBase)
    .SetAsFunction(LThis.FConstValue);
end;

procedure EngineRunnerItem_Execute_ConstArray(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemLetConstArray absolute AThis;
begin
  StackVarItem(LThis.FBase.FVarIndex + AItem.FStackBase)
    .SetAsArray(LThis.FConstValue);
end;

procedure EngineRunnerItem_Execute_Array(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemLetArray absolute AThis;
  LData: PMyEngineContextVariableData;
  i, LCount: Integer;
begin
  LCount := Length(LThis.FValues);

  LData := StackVarItem(LThis.FBase.FVarIndex + AItem.FStackBase);
  LData.InitializeArray(LCount);

  for i := 0 to (LCount - 1) do
    LThis.FValues[i].Execute(AItem,
      TMyEngineContextVariableDataDynArray(LData.vArr)[i]);
end;

procedure EngineRunnerItem_Execute_Value(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemLetValue absolute AThis;
begin
  LThis.FValue.Execute(AItem,
    StackVarItem(LThis.FBase.FVarIndex + AItem.FStackBase)^);
end;

procedure EngineRunnerItem_Execute_Call(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemCall absolute AThis;
begin
  LThis.FSourceValue.Execute(AItem, AItem.FResult^);
end;

procedure EngineRunnerItem_Execute_Return(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemReturn absolute AThis;
begin
  LThis.FSourceValue.Execute(AItem, AItem.FResult^);
  AItem.FIsTerminated := True;
end;

procedure EngineRunnerItem_Execute_BinCode(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemBinCode absolute AThis;
begin
  LThis.FProc(AThis, AItem);
end;

type
  TProcOf_ExFunc_Execute = function(
    const AParams: TMyEngineContextVariableDataDynArray;
    var AResult: TMyEngineContextVariableData): Boolean;

function ExFunc_Execute_Fibonacci(
  const AParams: TMyEngineContextVariableDataDynArray;
  var AResult: TMyEngineContextVariableData): Boolean;
var
  T,A,B: Int64;
begin
  if (not AParams[0].TryGetAsInt(T)) then Exit(False);

  A := 0;
  B := 1;
  Dec(T);
  while (T > 0) do
  begin
    Inc(A, B);
    Dec(T);
    if (T = 0) then
    begin
      AResult.SetAsInteger(A);
      Exit(True);
    end;
    Inc(B, A);
    Dec(T);
  end;

  AResult.SetAsInteger(B);
  Exit(True);
end;

function ExFunc_Execute_Combination(
  const AParams: TMyEngineContextVariableDataDynArray;
  var AResult: TMyEngineContextVariableData): Boolean;
var
  n, k: Int64;
begin
  if (not AParams[0].TryGetAsInt(n)) then Exit(False);
  if (not AParams[1].TryGetAsInt(k)) then Exit(False);
  AResult.SetAsInteger(My_Combination(n, k));
  Exit(True);
end;

function ExFunc_Execute_SumOfPA(
  const AParams: TMyEngineContextVariableDataDynArray;
  var AResult: TMyEngineContextVariableData): Boolean;
var
  T: Int64;
begin
  if (not AParams[0].TryGetAsInt(T)) then Exit(False);
  AResult.SetAsInteger(((T + 1) * T) div 2);
  Exit(True);
end;

function ExFunc_Execute_Factorial(
  const AParams: TMyEngineContextVariableDataDynArray;
  var AResult: TMyEngineContextVariableData): Boolean;
var
  T, R: Int64;
begin
  if (not AParams[0].TryGetAsInt(T)) then Exit(False);

  if (T <= 0) then
  begin
    AResult.SetAsInteger(1);
    Exit(True);
  end;

  R := 1;
  while (T > 1) do
  begin
    R := (R * T);
    Dec(T);
  end;

  AResult.SetAsInteger(R);
  Exit(True);
end;

const
  cTableExFuncExecute: array[TMyEngineContextFunctionTypeId] of
    TProcOf_ExFunc_Execute = (
      nil,
      nil,
      ExFunc_Execute_Fibonacci,
      ExFunc_Execute_Combination,
      ExFunc_Execute_SumOfPA,
      ExFunc_Execute_Factorial);

procedure SysProc_Print(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
var
  i: Integer;
  p: PMyEngineContextVariableData;
begin
  i := AItem.FParamCount;
  if (i > 0) then
  begin
    p := StackVarItem(AItem.FStackBase);
    repeat
      if (p.vId = TMyEngineContextVariableDataTypeId.eStr) then
        Write(LString(p.vStr))
      else
        Write(p.ToDisplay);

      Dec(i);
      if (i = 0) then Break;
      Inc(p);
    until False;
  end;

  WriteLn;
end;

function SysProc_ArrayGet(var AItem: TMyEngineRunnerItem;
  const AIndex: Integer): Boolean;
var
  p: PMyEngineContextVariableData;
  LCount: Integer;
begin
  p := StackVarItem(AItem.FStackBase);
  if (p.vId = TMyEngineContextVariableDataTypeId.eArray) then
  begin
    LCount := Length(TMyEngineContextVariableDataDynArray(p.vArr));
    if (AIndex < LCount) then
    begin
      AItem.FResult.Assign(TMyEngineContextVariableDataDynArray(p.vArr)[AIndex]);
      Exit(True);
    end;
  end;
  AItem.FResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
  Exit(False);
end;

procedure SysProc_First(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 0)) then
    raise EParamIsntArray.Create('first', 1);
end;

procedure SysProc_Second(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 1)) then
    raise EParamIsntArray.Create('second', 1);
end;

procedure SysProc_Third(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 2)) then
    raise EParamIsntArray.Create('third', 1);
end;

procedure SysProc_Fourth(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 3)) then
    raise EParamIsntArray.Create('fourth', 1);
end;

procedure SysProc_Fifth(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 4)) then
    raise EParamIsntArray.Create('fifth', 1);
end;

procedure SysProc_Sixth(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 5)) then
    raise EParamIsntArray.Create('sixth', 1);
end;

procedure SysProc_Seventh(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 6)) then
    raise EParamIsntArray.Create('seventh', 1);
end;

procedure SysProc_Eighth(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 7)) then
    raise EParamIsntArray.Create('eighth', 1);
end;

procedure SysProc_Ninth(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 8)) then
    raise EParamIsntArray.Create('ninth', 1);
end;

procedure SysProc_Tenth(AThis: PMyEngineContextBlockItem;
  var AItem: TMyEngineRunnerItem);
begin
  if (not SysProc_ArrayGet(AItem, 9)) then
    raise EParamIsntArray.Create('tenth', 1);
end;

const
  cProcTable_MyEngineContextValue_Execute:
    array[TMyEngineContextValueTypeId] of
      TProcOf_MyEngineContextValue_Execute = (

    TMyEngineContextValue_Execute_None,

    TMyEngineContextValue_Execute_ConstBool,
    TMyEngineContextValue_Execute_ConstInt,
    TMyEngineContextValue_Execute_ConstString,
    TMyEngineContextValue_Execute_ConstFunction,
    TMyEngineContextValue_Execute_ConstArray,

    TMyEngineContextValue_Execute_VariableGlobal,
    TMyEngineContextValue_Execute_Variable0,
    TMyEngineContextValue_Execute_VariableN,

    TmyEngineContextValue_Execute_Array,

    TMyEngineContextValue_Execute_Negative,
    TMyEngineContextValue_Execute_Op2,
    TMyEngineContextValue_Execute_Function,
    TMyEngineContextValue_Execute_FunctionByValue,
    TMyEngineContextValue_Execute_If
  );

  cProcTable_EngineContextBlock_ParseItemLetValue:
    array[TMyEngineContextValueTypeId] of
      TProcOf_EngineContextBlock_ParseItemLetValue = (

      { eNone }
      EngineContextBlock_ParseItemLetValue_Default,
      { eConstBool }
      EngineContextBlock_ParseItemLetValue_ConstBool,
      { eConstInt }
      EngineContextBlock_ParseItemLetValue_ConstInt,
      { eConstString }
      EngineContextBlock_ParseItemLetValue_ConstStr,
      { eConstFunction }
      EngineContextBlock_ParseItemLetValue_ConstFunction,
      { eConstArray }
      EngineContextBlock_ParseItemLetValue_ConstArray,
      { eVariableGlobal }
      EngineContextBlock_ParseItemLetValue_VariableGlobal,
      { eVariable0 }
      EngineContextBlock_ParseItemLetValue_Variable0,
      { eVariableN }
      EngineContextBlock_ParseItemLetValue_VariableN,
      { eArray }
      EngineContextBlock_ParseItemLetValue_Array,
      { eNegative }
      EngineContextBlock_ParseItemLetValue_Default,
      { eOp2 }
      EngineContextBlock_ParseItemLetValue_Default,
      { eFunction }
      EngineContextBlock_ParseItemLetValue_Default,
      { eFunctionByValue }
      EngineContextBlock_ParseItemLetValue_Default,
      { eIf }
      EngineContextBlock_ParseItemLetValue_Default
  );

  cProcTable_EngineContextBlockItem_Execute:
    array[TMyEngineContextBlockItemTypeId] of
      TProcOf_EngineRunnerItem_Execute = (

      { eNone }
      EngineRunnerItem_Execute_None,
      { eConstBool }
      EngineRunnerItem_Execute_ConstBool,
      { eConstInt }
      EngineRunnerItem_Execute_ConstInt,
      { eConstString }
      EngineRunnerItem_Execute_ConstStr,
      { eConstFunction }
      EngineRunnerItem_Execute_ConstFunction,
      { eConstArray }
      EngineRunnerItem_Execute_ConstArray,
      { eArray }
      EngineRunnerItem_Execute_Array,
      { eValue }
      EngineRunnerItem_Execute_Value,
      { eCall }
      EngineRunnerItem_Execute_Call,
      { eReturn }
      EngineRunnerItem_Execute_Return,
      { eIf }
      EngineRunnerItem_Execute_If,
      { eBinCode }
      EngineRunnerItem_Execute_BinCode
    );

type
  PMyEngineCaller = ^TMyEngineCaller;
  PMyEngineArrayBuilder = ^TMyEngineArrayBuilder;

  TMyEngineCaller = record
  public
    FVariable: PMyEngineContextVariable;          { Weak }
    FParamsArray: TArray<PMyEngineContextValue>;  { Weak }
    FParamsCount: Integer;
    FToken: PMyToken;
    FContext: PMyEngineContext;

    procedure AddParam(const AParam: PMyEngineContextValue);
    function Build: PMyEngineContextValue;

    class function Create(const AContext: PMyEngineContext;
      const AVariable: PMyEngineContextVariable;
      const AToken: PMyToken): PMyEngineCaller; static;
  strict private
    function BuildAsArray: PMyEngineContextValue;
  end;

  TMyEngineArrayBuilder = record
  public
    FItemsArray: TArray<PMyEngineContextValue>;
    FItemsCount: Integer;

    procedure Add(const AItem: PMyEngineContextValue);
    function Build: PMyEngineContextValue;

    class function Create: PMyEngineArrayBuilder; static; inline;
  strict private
    function ItemsIsConst: Boolean;
  end;

function ResolveExpression(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext;
  const AByLet: Boolean): PMyEngineContextValue; forward;

function ReadItemBlock(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext; var AIndex: Integer;
  const AIsLoose: Boolean): PMyEngineContextBlock; forward;

function CreateEngineContextValueByData(
  const AData: PMyEngineContextVariableData): PMyEngineContextValue; forward;

procedure EngineRunnerItem_Execute_If(
  AThis: PMyEngineContextBlockItem; var AItem: TMyEngineRunnerItem);
var
  LThis: PMyEngineContextBlockItemIf absolute AThis;
  LData: PMyEngineContextVariableData;
  LBlock: PMyEngineContextBlock;
  LItem: PMyEngineContextBlockItem;
begin
  LData := StackVarsFrameBegin(1);
  try
    LThis.FExpression.Execute(AItem, LData^);
    if cIf_FuncTable[LData^.vId](LData^) then
      LBlock := LThis.FThen
    else
      LBlock := LThis.FElse;

    if (LBlock <> nil) then
    begin
      LItem := LBlock.FItemsFirst;
      while (LItem <> nil) do
      begin
        if AItem.FIsTerminated then Break;
        cProcTable_EngineContextBlockItem_Execute[LItem.FTypeId](LItem, AItem);
        LItem := LItem.FNext;
      end;
    end;
  finally
    StackVarsFrameEnd(1);
  end;
end;

procedure TMyEngineContextValue_Execute_If(
  AThis: PMyEngineContextValue; var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
var
  LThis: PMyEngineContextValueIf absolute AThis;
  LData: PMyEngineContextVariableData;
  LBlock: PMyEngineContextBlock;
  LItem: PMyEngineContextBlockItem;
  LSaveResult: PMyEngineContextVariableData;
begin
  LSaveResult := AItem.FResult;
  LData := StackVarsFrameBegin(1);
  try
    AItem.FResult := @AResult;

    LThis.FExpression.Execute(AItem, LData^);
    if cIf_FuncTable[LData^.vId](LData^) then
      LBlock := LThis.FThen
    else
      LBlock := LThis.FElse;

    if (LBlock <> nil) then
    begin
      LItem := LBlock.FItemsFirst;
      while (LItem <> nil) do
      begin
        if AItem.FIsTerminated then Break;
        cProcTable_EngineContextBlockItem_Execute[LItem.FTypeId](LItem, AItem);
        LItem := LItem.FNext;
      end;
    end;
  finally
    StackVarsFrameEnd(1);
    AItem.FResult := LSaveResult;
  end;
end;

var
  gvContextGlobal: PMyEngineContextGlobal;

procedure MyEngine_Execute;
var
  LData: PMyEngineContextVariableData;
begin
  AddStackVars(1);
  try
    LData := StackVarItem(gvStackVarsIndex - 1);
    MyEngine_Execute(LData^);
  finally
    DecStackVars(1);
  end;
end;

procedure MyEngine_Execute(var AResult: TMyEngineContextVariableData);
var
  LSaveState: TMyEngineGlobalContextSaveState;
  LRunner: TMyEngineRunner;
begin
  LSaveState.Backup;
  gvContextGlobal := TMyEngineContextGlobal.Create;
  try
    gvContextGlobal.FBase.ParseGlobal;

    LRunner.Initialize;
    LRunner.ExecuteContext(Pointer(gvContextGlobal), nil, 0, AResult);
  finally
    LSaveState.Restore;
  end;
end;

procedure Free_ContextValue(p: PMyEngineContextValue);
begin

end;

procedure Free_EngineCaller(p: PMyEngineCaller); inline;
begin
  System.Dispose(p);
end;

procedure Free_EngineArrayBuilder(p: PMyEngineArrayBuilder); inline;
begin
  System.Dispose(p);
end;

const
  tk_Negative = 254;
  tk_RefValue_ = 255;

function GetRefValue(const AToken: PMyToken): PMyEngineContextValue;
begin
  Exit(AToken.p);
end;

procedure SetRefValue(const AToken: PMyToken;
  const AValue: PMyEngineContextValue);
begin
  AToken.Id := tk_RefValue_;
  AToken.p := AValue;
end;

procedure SimplifyNegatives(var ATkStack: TMyTokenStack);
var
  i: Integer;
  Tk0, Tk1: PMyToken;
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
                ATkStack.Delete(i, 1);
              end;
            tkop_Add:
              begin
                Tk1.Id := tkop_Sub;
                ATkStack.Delete(i, 1);
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
                ATkStack.Delete(i, 1);
              end;
            tkop_Add:
              begin
                Tk1.Id := tkop_Add;
                ATkStack.Delete(i, 1);
              end;
            tkop_Mul..tkop_Power: ATkStack.Delete(i, 1);
          end;
        end;
    end;
    Dec(i);
  end;
end;

procedure SelectTokens_p_OpenClose(var ATkStack, ASubTkStack: TMyTokenStack;
  var AIndex: Integer);
var
  Tk: PMyToken;
  LStart, LIndex, pCount: Integer;
begin
  LIndex := AIndex;
  if (LIndex >= ATkStack.Count) then
    raise EBuilderUnexpectedEof.New2(ATkStack);

  if (ATkStack.DynArray[LIndex].Id <> tk_pOpen) then
    raise EUnexpectedToken.New(ATkStack.DynArray[LIndex]);

  Inc(LIndex);
  LStart := LIndex;

  pCount := 1;
  repeat
    if (LIndex >= ATkStack.Count) then
      raise EBuilderUnexpectedEof.New2(ATkStack);

    Tk := ATkStack.DynArray[LIndex];
    case Tk.Id of
      tk_pOpen: Inc(pCount);
      tk_pClose:
        begin
          Dec(pCount);
          if (pCount = 0) then
          begin
            ASubTkStack.CopyBy(ATkStack, LStart, (LIndex - LStart));
            SimplifyNegatives(ASubTkStack);
            AIndex := (LIndex + 1);
            Break;
          end;
        end;
    end;
    Inc(LIndex);
  until False;
end;

procedure SelectTokens_4Return(var ATkStack, ASubTkStack: TMyTokenStack;
  var AIndex: Integer);
var
  LStart, LIndex, pCount, bCount, rCount: Integer;
  Tk: PMyToken;
begin
  LIndex := AIndex;
  if (LIndex >= ATkStack.Count) then
    raise EBuilderUnexpectedEof.New(ATkStack.DynArray[LIndex - 1]);

  LStart := LIndex;
  pCount := 0;
  bCount := 0;
  rCount := 0;
  repeat
    Tk := ATkStack.DynArray[LIndex];
    case Tk.Id of
      tk_bOpen: Inc(bCount);
      tk_bClose:
        begin
          if ((bCount = 0) and (pCount = 0)) then Break;
          Dec(bCount);
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
      if ((bCount = 0) and (pCount = 0)) then
      begin
        Inc(rCount);
        Break;
      end;
      raise EBuilderUnexpectedEof.New(ATkStack.DynArray[LIndex - 1]);
    end;
    Inc(rCount);
  until False;

  ASubTkStack.CopyBy(ATkStack, LStart, rCount);
  SimplifyNegatives(ASubTkStack);

  AIndex := LIndex;
end;

function NegativeOf(const AParam: PMyEngineContextValue): PMyEngineContextValue;
var
  cv_ConstBool: PMyEngineContextValueConstBool absolute AParam;
  cv_ConstInt: PMyEngineContextValueConstInt absolute AParam;
  cv_Negative: PMyEngineContextValueNegative absolute AParam;
begin
  case AParam.FTypeId of
    TMyEngineContextValueTypeId.eConstBool:
      begin
        cv_ConstBool.FConstValue := (not cv_ConstBool.FConstValue);
        Exit(AParam);
      end;
    TMyEngineContextValueTypeId.eConstInt:
      begin
        cv_ConstInt.FConstValue := (-cv_ConstInt.FConstValue);
        Exit(AParam);
      end;
    TMyEngineContextValueTypeId.eNegative:
      begin
        Result := cv_Negative.FRefValue;
        Free_ContextValue(AParam);
        Exit;
      end;
  end;

  Exit(Pointer(TMyEngineContextValueNegative.Create(AParam)));
end;

function CreateContextValueByVariable0(
  const AContext, AVarContext: PMyEngineContext;
  const AVarIndex: Integer): PMyEngineContextValue;
var
  LRelIndex: Integer;
  R0: PMyEngineContextValueByVariable;
begin
  if (AVarContext = Pointer(gvContextGlobal)) then
  begin
    { Contexto Global }
    R0 := AllocMem(SizeOf(TMyEngineContextValueByVariable));
    R0.FBase.FTypeId := TMyEngineContextValueTypeId.eVariableGlobal;
    R0.FVarIndex := AVarIndex;
    Exit(Pointer(R0));
  end;

  LRelIndex := AContext.RelativeIndexOf(AVarContext);
  if (LRelIndex < 0) then
    raise EInternalError.Create('A80049BD22EE4837A5C314E4D30C7ECE');

  R0 := AllocMem(SizeOf(TMyEngineContextValueByVariable));
  R0.FVarIndex := AVarIndex;

  if (LRelIndex <> 0) then
  begin
    R0.FBase.FTypeId := TMyEngineContextValueTypeId.eVariableN;
    R0.FRelContextIndex := LRelIndex;
  end else
    R0.FBase.FTypeId := TMyEngineContextValueTypeId.eVariable0;
  Exit(Pointer(R0));
end;

function CreateContextValueByVariable(const AContext: PMyEngineContext;
  const AToken: PMyToken): PMyEngineContextValue;
var
  LVar: PMyEngineContextVariable;
begin
  LVar := AContext.VarByName(AToken);
  Exit(CreateContextValueByVariable0(AContext, LVar.FContext, LVar.FIndex));
end;

function CreateContextValueByConstString(
  const s: LString): PMyEngineContextValue;
var
  R: PMyEngineContextValueConstString absolute Result;
begin
  R := AllocMem(SizeOf(TMyEngineContextValueConstString));
  R.FConstValue := s;
  R.FBase.FTypeId := TMyEngineContextValueTypeId.eConstString;
end;

function CreateContextValueByConstInt(const i: Int64): PMyEngineContextValue;
var
  R: PMyEngineContextValueConstInt absolute Result;
begin
  R := AllocMem(SizeOf(TMyEngineContextValueConstInt));
  R.FConstValue := i;
  R.FBase.FTypeId := TMyEngineContextValueTypeId.eConstInt;
end;

function CreateContextValueByConstBool(const b: Boolean): PMyEngineContextValue;
var
  R: PMyEngineContextValueConstBool absolute Result;
begin
  R := AllocMem(SizeOf(TMyEngineContextValueConstBool));
  R.FConstValue := b;
  R.FBase.FTypeId := TMyEngineContextValueTypeId.eConstBool;
end;

function CreateContextValueByConstFunction(
  const AFunction: PMyEngineContextFunction): PMyEngineContextValue;
var
  R: PMyEngineContextValueConstFunction absolute Result;
begin
  Result := Pointer(AFunction.FConstDeclr);
  if (Result = nil) then
  begin
    R := AllocMem(SizeOf(TMyEngineContextValueConstFunction));
    R.FConstValue := AFunction;
    R.FBase.FTypeId := TMyEngineContextValueTypeId.eConstFunction;
    AFunction.FConstDeclr := R;
  end;
end;

function CreateContextValueByConstArray(
  var AArray: TMyEngineContextVariableDataDynArray): PMyEngineContextValue;
var
  R: PMyEngineContextValueConstArray absolute Result;
begin
  R := AllocMem(SizeOf(TMyEngineContextValueConstArray));
  MyDataVars_Copy(R.FConstValue, AArray);
  R.FBase.FTypeId := TMyEngineContextValueTypeId.eConstArray;
end;

function CreateEngineContextValueByData(
  const AData: PMyEngineContextVariableData): PMyEngineContextValue;
begin
  case AData.vId of
    TMyEngineContextVariableDataTypeId.eBool:
      Exit(CreateContextValueByConstBool(AData.vBool));
    TMyEngineContextVariableDataTypeId.eInt:
      Exit(CreateContextValueByConstInt(AData.vInt));
    TMyEngineContextVariableDataTypeId.eStr:
      Exit(CreateContextValueByConstString(LString(AData.vStr)));
    TMyEngineContextVariableDataTypeId.eFunc:
      Exit(CreateContextValueByConstFunction(AData.vFunc));
    TMyEngineContextVariableDataTypeId.eArray:
      Exit(CreateContextValueByConstArray(
        TMyEngineContextVariableDataDynArray(AData.vArr)));
    else
      Exit(nil);
  end;
end;

function CreateContextValueByToken(const AContext: PMyEngineContext;
  const AToken: PMyToken): PMyEngineContextValue;
begin
  case AToken.Id of
    tk_Identifier: Exit(CreateContextValueByVariable(AContext, AToken));
    tk_String: Exit(CreateContextValueByConstString(AToken.Vds));
    tk_Integer: Exit(CreateContextValueByConstInt(AToken.vdi));
    tkrw_False: Exit(CreateContextValueByConstBool(False));
    tkrw_True: Exit(CreateContextValueByConstBool(True));
    tk_RefValue_: Exit(GetRefValue(AToken));
    tk_Recursive:
      if (AContext.FTypeId = TMyEngineContextTypeId.eFunction) then
      begin
        SetRefValue(AToken, CreateContextValueByConstFunction(
          PMyEngineContextFunction(AContext)));
        Exit(GetRefValue(AToken));
      end;
//    else
//      raise EUnexpectedToken.New(AToken);
  end;
  raise EUnexpectedToken.New(AToken);
end;

function SubExpression(const AContext: PMyEngineContext;
  const L, R: PMyToken; Op: Byte): PMyEngineContextValue;
var
  p0, p1: PMyEngineContextValue;
begin
  p0 := CreateContextValueByToken(AContext, L);
  p1 := CreateContextValueByToken(AContext, R);

  Exit(Pointer(TMyEngineContextValueOp2.Create(p0, p1, Op)));
end;

function ResolveExpression_7(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext): PMyEngineContextValue;
var
  i: Integer;
  Tk: PMyToken;
  LSubTkStack: TMyTokenStack;
  LIf: PMyEngineContextValueIf;
begin
  i := 0;
  if (ATokenStack.Count = 1) then
    Exit(CreateContextValueByToken(AContext, ATokenStack.DynArray[0]));

  if (ATokenStack.Count > 0) then
  begin
    Tk := ATokenStack.DynArray[i];
    if (Tk.Id = tkrw_If) then
    begin
      Inc(i);
      if (i >= ATokenStack.Count) then
        raise EBuilderUnexpectedEof.New(ATokenStack.DynArray[i - 1]);

      Tk := ATokenStack.DynArray[i];
      if (Tk.Id = tk_RefValue_) then
      begin
        LSubTkStack.CopyBy(ATokenStack, i, 1);
        Inc(i);
      end else
        SelectTokens_p_OpenClose(ATokenStack, LSubTkStack, i);

      LIf := AllocMem(SizeOf(TMyEngineContextValueIf));
      LIf.FBase.FTypeId := TMyEngineContextValueTypeId.eIf;

      LIf.FExpression := ResolveExpression(LSubTkStack, AContext, False);
      LIf.FThen := ReadItemBlock(ATokenStack, AContext, i, True);

      if ((i < ATokenStack.Count) and
        (ATokenStack.DynArray[i].Id = tkrw_Else)) then
      begin
        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.New2(ATokenStack);
        LIf.FElse := ReadItemBlock(ATokenStack, AContext, i, True);
      end;

      Exit(Pointer(LIf));
    end;
  end;

  raise EInternalError.Create('A0C820DE07AE4409A4A27B10BA1C64F4');
end;

function ResolveExpression_6(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext): PMyEngineContextValue;
label
  lbTryAgain;
var
  i: Integer;
  Tk: PMyToken;
  LValue: PMyEngineContextValue;
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
          ATokenStack.Delete(i + 1, 2);
          goto lbTryAgain;
        end;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_7(ATokenStack, AContext));
end;

function ResolveExpression_5(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext): PMyEngineContextValue;
label
  lbTryAgain;
var
  i, j: Integer;
  Tk: PMyToken;
  LValue: PMyEngineContextValue;
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
            LValue := SubExpression(AContext,
              ATokenStack.DynArray[i - 1],
              ATokenStack.DynArray[i + 1], Tk.Id);

            SetRefValue(ATokenStack.DynArray[i - 1], LValue);
            ATokenStack.Delete(i + 1, 2);
            goto lbTryAgain;
          end;
        end;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_6(ATokenStack, AContext));
end;

function ResolveExpression_4(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext): PMyEngineContextValue;
label
  lbTryAgain;
var
  i, j: Integer;
  Tk: PMyToken;
  LValue: PMyEngineContextValue;
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
            ATokenStack.Delete(i + 1, 2);
            goto lbTryAgain;
          end;
        end else
        begin
          if (Tk.Id = tkop_Add) then
          begin
            ATokenStack.Delete(i, 1);
            goto lbTryAgain;
          end;

          LValue := NegativeOf(CreateContextValueByToken(
            AContext, ATokenStack.DynArray[i + 1]));

          SetRefvalue(Tk, LValue);
          ATokenStack.Delete(i + 1, 1);
          goto lbTryAgain;
        end;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_5(ATokenStack, AContext));
end;

function ResolveExpression_3(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext): PMyEngineContextValue;
label
  lbTryAgain;
var
  i: Integer;
  Tk: PMyToken;
  LValue: PMyEngineContextValue;
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
          ATokenStack.Delete(i + 1, 2);
          goto lbTryAgain;
        end;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_4(ATokenStack, AContext));
end;

function ResolveExpression_2(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext): PMyEngineContextValue;
label
  lbTryAgain;
var
  i: Integer;
  Tk: PMyToken;
  LValue: PMyEngineContextValue;
begin
  i := 0;
  lbTryAgain: ;
  while (i < ATokenStack.Count) do
  begin
    Tk := ATokenStack.DynArray[i];
    if (Tk.Id = tkop_Power) then
    begin
      LValue := SubExpression(AContext,
        ATokenStack.DynArray[i - 1],
        ATokenStack.DynArray[i + 1], Tk.Id);

      SetRefValue(ATokenStack.DynArray[i - 1], LValue);
      ATokenStack.Delete(i + 1, 2);
      goto lbTryAgain;
    end;

    Inc(i);
  end;

  Exit(ResolveExpression_3(ATokenStack, AContext));
end;

function ResolveExpression_1(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext): PMyEngineContextValue;
label
  lbTryAgain, lbTryAgain1;
var
  i, j, pCount: Integer;
  Tk, Tk2: PMyToken;
  SubTkStack: TMyTokenStack;
  LArrBuilder: PMyEngineArrayBuilder;
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
          raise EUnexpectedEof.New(ATokenStack.DynArray[ATokenStack.Count - 1]);
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
                SubTkStack.CopyBy(ATokenStack, (i + 1), (j - i - 1));
                ATokenStack.Delete((i + 1), (j - i));
                LArrBuilder.Add(ResolveExpression(SubTkStack, AContext, False));

                SetRefValue(Tk, LArrBuilder.Build());
                goto lbTryAgain;
              end else
              begin
                SubTkStack.CopyBy(ATokenStack, (i + 1), (j - i - 1));
                ATokenStack.Delete((i + 1), (j - i));

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
              SubTkStack.CopyBy(ATokenStack, (i + 1), (j - i - 1));
              ATokenStack.Delete((i + 1), (j - i));

              if (LArrBuilder = nil) then
                LArrBuilder := TMyEngineArrayBuilder.Create;
              LArrBuilder.Add(ResolveExpression(SubTkStack, AContext, False));

              goto lbTryAgain1;
            end else
              Inc(j);
          else
            Inc(j);
        end;
      until False;
    end else
      Inc(i);
  end;
  Exit(ResolveExpression_2(ATokenStack, AContext));
end;

procedure ReadItemBlockItemLetValue(const ABlock: PMyEngineContextBlock;
  const AVar: PMyEngineContextVariable; const AValue: PMyEngineContextValue);
var
  LValue: PMyEngineContextBlockItemLetValue;
  LConstBool: PMyEngineContextBlockItemLetConstBool absolute LValue;
  LConstInt: PMyEngineContextBlockItemLetConstInt absolute LValue;
  LConstStr: PMyEngineContextBlockItemLetConstStr absolute LValue;
  LConstFunc: PMyEngineContextBlockItemLetConstFunction absolute LValue;
  LConstArray: PMyEngineContextBlockItemLetConstArray absolute LValue;
begin
  case AValue.FTypeId of
    TMyEngineContextValueTypeId.eConstBool:
      begin
        LConstBool := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstBool));
        LConstBool.FConstValue := PMyEngineContextValueConstBool(AValue).FConstValue;
        LConstBool.FBase.FVarIndex := AVar.FIndex;
        LConstBool.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstBool;
        ABlock.ItemsAdd(Pointer(LConstBool));
        Exit;
      end;
    TMyEngineContextValueTypeId.eConstInt:
      begin
        LConstInt := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstInt));
        LConstInt.FConstValue := PMyEngineContextValueConstInt(AValue).FConstValue;
        LConstInt.FBase.FVarIndex := AVar.FIndex;
        LConstInt.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstInt;
        ABlock.ItemsAdd(Pointer(LConstInt));
        Exit;
      end;
    TMyEngineContextValueTypeId.eConstString:
      begin
        LConstStr := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstStr));
        LConstStr.FConstValue := PMyEngineContextValueConstString(AValue).FConstValue;
        LConstInt.FBase.FVarIndex := AVar.FIndex;
        LConstInt.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstString;
        ABlock.ItemsAdd(Pointer(LConstStr));
        Exit;
      end;
    TMyEngineContextValueTypeId.eConstFunction:
      begin
        LConstFunc := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstFunction));
        LConstFunc.FConstValue := PMyEngineContextValueConstFunction(AValue).FConstValue;
        LConstFunc.FBase.FVarIndex := AVar.FIndex;
        LConstFunc.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstFunction;
        ABlock.ItemsAdd(Pointer(LConstFunc));
        Exit;
      end;
    TMyEngineContextValueTypeId.eConstArray:
      begin
        LConstArray := AllocMem(SizeOf(TMyEngineContextBlockItemLetConstArray));
        LConstArray.FConstValue := PMyEngineContextValueConstArray(AValue).FConstValue;
        LConstArray.FBase.FVarIndex := AVar.FIndex;
        LConstArray.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetConstArray;
        ABlock.ItemsAdd(Pointer(LConstArray));
        Exit;
      end;
  end;

  LValue := AllocMem(SizeOf(TMyEngineContextBlockItemLetValue));
  LValue.FValue := AValue;
  LValue.FBase.FVarIndex := AVar.FIndex;
  LValue.FBase.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eLetValue;
  ABlock.ItemsAdd(Pointer(LValue));
end;

procedure ReadItemBlockItem(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext; const ABlock: PMyEngineContextBlock;
  var AIndex: Integer);
label
  lb_RetOrCall;
var
  i: Integer;
  Tk: PMyToken;
  LOldVar, LVar: PMyEngineContextVariable;
  LValue: PMyEngineContextValue;
  LSubTkStack: TMyTokenStack;
  LIf: PMyEngineContextBlockItemIf;
  LCall: PMyEngineContextBlockItemCall;
  LReturn: PMyEngineContextBlockItemReturn;
begin
  i := AIndex;
  if (i >= ATokenStack.Count) then Exit;

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

    tkrw_False,
    tkrw_True,
    tk_pOpen,
    tk_RefValue_:
      begin
lb_RetOrCall:;
        SelectTokens_4Return(ATokenStack, LSubTkStack, i);
        LValue := ResolveExpression(LSubTkStack, AContext, False);
        if (AContext.FTypeId = TMyEngineContextTypeId.eFunction) then
        begin
          LReturn := AllocMem(SizeOf(TMyEngineContextBlockItemReturn));
          LReturn.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eReturn;
          LReturn.FSourceValue := LValue;
          ABlock.ItemsAdd(Pointer(LReturn));
        end else
        begin
          LCall := AllocMem(SizeOf(TMyEngineContextBlockItemCall));
          LCall.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eCall;
          LCall.FSourceValue := LValue;
          ABlock.ItemsAdd(Pointer(LCall));
        end;
      end;
    tk_Recursive:
      begin
        if (AContext.FTypeId = TMyEngineContextTypeId.eFunction) then
        begin
          SetRefValue(Tk, CreateContextValueByConstFunction(
            PMyEngineContextFunction(AContext)));
          goto lb_RetOrCall;
        end;
        raise EUnexpectedToken.New(Tk);
      end;
    tkrw_Let:
      begin
        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.New(ATokenStack.DynArray[i - 1]);

        Tk := ATokenStack.DynArray[i];
        if (Tk.Id <> tk_Identifier) then
          raise EBuilderVariableNameExpected.New(Tk);

        LVar := AContext.LocalFindOrDeclrVar(Tk.vds);
        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.New(ATokenStack.DynArray[i - 1]);

        Tk := ATokenStack.DynArray[i];
        if (Tk.Id <> tk_Assign) then
          raise EBuilderAssignExpected.New(Tk);

        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.New(ATokenStack.DynArray[i - 1]);

        SelectTokens_4Return(ATokenStack, LSubTkStack, i);
        LOldVar := AContext.FReadingVar;
        AContext.FReadingVar := LVar;
        LValue := ResolveExpression(LSubTkStack, AContext, True);
        ReadItemBlockItemLetValue(ABlock, LVar, LValue);
        AContext.FReadingVar := LOldVar;
      end;
    tkrw_If:
      begin
        Inc(i);
        if (i >= ATokenStack.Count) then
          raise EBuilderUnexpectedEof.New(ATokenStack.DynArray[i - 1]);

        SelectTokens_p_OpenClose(ATokenStack, LSubTkStack, i);

        LIf := AllocMem(SizeOf(TMyEngineContextBlockItemIf));
        LIf.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eIf;
        ABlock.ItemsAdd(Pointer(LIf));

        LIf.FExpression := ResolveExpression(LSubTkStack, AContext, False);
        LIf.FThen := ReadItemBlock(ATokenStack, AContext, i, True);

        if ((i < ATokenStack.Count) and
          (ATokenStack.DynArray[i].Id = tkrw_Else)) then
        begin
          Inc(i);
          if (i >= ATokenStack.Count) then
            raise EBuilderUnexpectedEof.New2(ATokenStack);
          LIf.FElse := ReadItemBlock(ATokenStack, AContext, i, True);
        end;
      end;
    tk_SemiColon: Inc(i);
    else
      raise EUnexpectedToken.New(Tk);
  end;
  AIndex := i;
end;

function ReadItemBlock(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext; var AIndex: Integer;
  const AIsLoose: Boolean): PMyEngineContextBlock;
label
  lb_Block;
var
  i, j: Integer;
  Tk: PMyToken;
  LRefBlock, LBlock: PMyEngineContextBlock;
begin
  i := AIndex;
  if (i >= ATokenStack.Count) then
    raise EBuilderUnexpectedEof.New(ATokenStack.DynArray[i - 1]);

  Tk := ATokenStack.DynArray[i];
  if (Tk.Id = tk_bOpen) then
  begin
lb_Block: ;
    Inc(i);

    LBlock := AllocMem(SizeOf(TMyEngineContextBlock));
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
        raise EBuilderUnexpectedEof.New(ATokenStack.DynArray[i - 1]);

      if (ATokenStack.DynArray[i].Id = tk_bClose) then
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

  ATokenStack.Insert(j, TMyToken_CreateVirtual(tk_bClose));
  ATokenStack.Insert(i, TMyToken_CreateVirtual(tk_bOpen));

//  Tk := ATokenStack.DynArray[i];
  goto lb_Block;
end;

function ReadFunction(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext; var AIndex: Integer;
  const AByLet: Boolean): PMyEngineContextValue;
var
  i: Integer;
  Tk: PMyToken;
  LFunction: PMyEngineContextFunction;
  LLPar, LPar: PMyEngineContextVariable;
  LValue: PMyEngineContextValueConstFunction;
begin
  i := (AIndex + 1);
  if (i >= ATokenStack.Count) then
    raise EUnexpectedEof.New(ATokenStack.DynArray[ATokenStack.Count - 1]);

  LFunction := TMyEngineContextFunction.Create(AContext);

  if AByLet then
  begin
    LPar := AContext.FReadingVar;
    if (LPar <> nil) then
    begin
      LPar.FData.SetAsFunction(LFunction);
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
        raise EUnexpectedEof.New(ATokenStack.DynArray[ATokenStack.Count - 1]);

      Tk := ATokenStack.DynArray[i];
      if ((LLPar = nil) and (Tk.Id = tk_pClose)) then
      begin
        Inc(i);
        Break;
      end;

      if (Tk.Id <> tk_Identifier) then
        raise EBuilderVariableNameExpected.New(Tk);

      LPar := TMyEngineContextVariable.Create;
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
        raise EUnexpectedEof.New(ATokenStack.DynArray[ATokenStack.Count - 1]);

      Tk := ATokenStack.DynArray[i];
      if (Tk.Id = tk_pClose) then
      begin
        Inc(i);
        Break;
      end;

      if (Tk.Id <> tk_Comma) then
        raise EUnexpectedToken.New(Tk);
    until False;
  end;

  if (i >= ATokenStack.Count) then
    raise EUnexpectedEof.New(ATokenStack.DynArray[ATokenStack.Count - 1]);

  Tk := ATokenStack.DynArray[i];
  if (Tk.Id <> tk_AssignProc) then
    raise EUnexpectedToken.New(Tk);

  Inc(i);
  if (i >= ATokenStack.Count) then
    raise EUnexpectedEof.New(ATokenStack.DynArray[ATokenStack.Count - 1]);

  ReadItemBlock(ATokenStack, Pointer(LFunction), i, False);
  AIndex := i;

  LValue := AllocMem(SizeOf(TMyEngineContextValueConstFunction));
  LValue.FConstValue := LFunction;
  LValue.FBase.FTypeId := TMyEngineContextValueTypeId.eConstFunction;

  GenerateFunctionName(LFunction);
  if (not TryOptimizeFunction(LFunction)) then
    SetFunctionTypeId(LFunction, TMyEngineContextFunctionTypeId.eAST);
  Exit(Pointer(LValue));
end;

function ResolveExpression(var ATokenStack: TMyTokenStack;
  const AContext: PMyEngineContext;
  const AByLet: Boolean): PMyEngineContextValue;
label lbTryAgain;
var
  i, j, pCount, LStart: Integer;
  Tk, Tk1: PMyToken;
  LVar: PMyEngineContextVariable;
  LCaller: PMyEngineCaller;
  SubTkStack: TMyTokenStack;
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
      ATokenStack.Delete(LStart + 1, (i - LStart - 1));
      i := LStart;
      goto lbTryAgain;
    end else
    if (Tk.Id in [tk_Identifier, tkrw_Array, tkrw_Print, tkrw_First,
      tkrw_Second, tkrw_Third, tkrw_Fourth, tkrw_Fifth, tkrw_Sixth,
      tkrw_Seventh, tkrw_Eighth, tkrw_Ninth, tkrw_Tenth, tk_RefValue_,
      tk_Recursive]) then
    begin
      j := (i + 1);
      if ((j < ATokenStack.Count) and
        (ATokenStack.DynArray[j].Id = tk_pOpen)) then
      begin
        if (Tk.Id = tk_Identifier) then
          LVar := AContext.VarByName(Tk)
        else if ((Tk.Id >= Low(sPrints)) and (Tk.Id <= High(sPrints))) then
        begin
          Tk.vds := sPrints[Tk.Id];
          LVar := AContext.VarByName(Tk);
        end else
          LVar := nil;

        LCaller := TMyEngineCaller.Create(AContext, LVar, Tk);

        Inc(j);
        if (j >= ATokenStack.Count) then
          raise EUnexpectedEof.New(ATokenStack.DynArray[ATokenStack.Count - 1]);

        Tk := ATokenStack.DynArray[j];
        if (Tk.Id = tk_pClose) then
        begin
          { Sem Parâmetros }
          ATokenStack.Delete(i + 1, (j - i));
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
                    SubTkStack.CopyBy(ATokenStack, LStart, (j - LStart));
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
                    SubTkStack.CopyBy(ATokenStack, LStart, (j - LStart));
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
                SubTkStack.CopyBy(ATokenStack, LStart, (j - LStart));
                LCaller.AddParam(
                  ResolveExpression(SubTkStack, AContext, False));
                Break;
              end;
              raise EUnexpectedEof.New(
                ATokenStack.DynArray[ATokenStack.Count - 1]);
            end;
          until False;
          ATokenStack.Delete(i + 1, (j - i));
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
        ATokenStack.Delete(i, 1);
        goto lbTryAgain;
      end;
    end;
    Inc(i);
  end;

  Exit(ResolveExpression_1(ATokenStack, AContext));
end;

{ TMyEngineCaller }

procedure TMyEngineCaller.AddParam(const AParam: PMyEngineContextValue);
begin
  if (FParamsCount >= Length(FParamsArray)) then
    SetLength(FParamsArray, (FParamsCount + 32));

  FParamsArray[FParamsCount] := AParam;
  Inc(FParamsCount);
end;

function TMyEngineCaller.Build: PMyEngineContextValue;
var
  LFunction: PMyEngineContextFunction;
  LInnerContextValue: PMyEngineContextValue;
begin
  SetLength(FParamsArray, FParamsCount);

  if (FVariable = nil) then
  begin
    if (FToken.Id = tkrw_Array) then
      Exit(BuildAsArray);
    if (FToken.Id = tk_RefValue_) then
      Exit(Pointer(TMyEngineContextValueFunctionByValue
        .Create(FToken.p, FParamsArray)));
    if (FToken.Id = tk_Recursive) then
    begin
      if (FContext.FTypeId = TMyEngineContextTypeId.eFunction) then
      begin
        Exit(Pointer(TMyEngineContextValueFunctionByValue
          .Create(CreateContextValueByConstFunction(
          PMyEngineContextFunction(FContext)), FParamsArray)));
      end;
    end;
  end else
  begin
    LFunction := FVariable.FData.vFunc;
    if (LFunction <> nil) then
      Exit(Pointer(TMyEngineContextValueFunction
        .Create(LFunction, FParamsArray)));

    LInnerContextValue := CreateContextValueByVariable0(
      FContext, FVariable.FContext, FVariable.FIndex);
    Exit(Pointer(TMyEngineContextValueFunctionByValue
      .Create(LInnerContextValue, FParamsArray)));
  end;

  raise EInternalError.Create('1517BE5A29324DFD8A10023CC833D3BC');
end;

function TMyEngineCaller.BuildAsArray: PMyEngineContextValue;
var
  LAB: TMyEngineArrayBuilder;
begin
  LAB.FItemsArray := FParamsArray;
  LAB.FItemsCount := FParamsCount;
  Exit(LAB.Build());
end;

class function TMyEngineCaller.Create(const AContext: PMyEngineContext;
  const AVariable: PMyEngineContextVariable;
  const AToken: PMyToken): PMyEngineCaller;
begin
  Result := AllocMem(SizeOf(TMyEngineCaller));
  Result.FContext := AContext;
  Result.FVariable := AVariable;
  Result.FToken := AToken;
end;

{ TMyEngineArrayBuilder }

procedure TMyEngineArrayBuilder.Add(const AItem: PMyEngineContextValue);
begin
  if (FItemsCount >= Length(FItemsArray)) then
    SetLength(FItemsArray, (FItemsCount + 32));

  FItemsArray[FItemsCount] := AItem;
  Inc(FItemsCount);
end;

function TMyEngineArrayBuilder.Build: PMyEngineContextValue;
var
  R0: PMyEngineContextValueConstArray;
  R1: PMyEngineContextValueArray;
  i: Integer;
begin
  SetLength(FItemsArray, FItemsCount);

  if ItemsIsConst then
  begin
    R0 := AllocMem(SizeOf(TMyEngineContextValueConstArray));
    R0.FBase.FTypeId := TMyEngineContextValueTypeId.eConstArray;
    SetLength(R0.FConstValue, FItemsCount);
    for i := 0 to (FItemsCount - 1) do
      FItemsArray[i].Execute(PMyEngineRunnerItem(nil)^, R0.FConstValue[i]);
    Exit(Pointer(R0));
  end;

  R1 := AllocMem(SizeOf(TMyEngineContextValueArray));
  R1.FBase.FTypeId := TMyEngineContextValueTypeId.eArray;
  R1.FValues := FItemsArray;
  Exit(Pointer(R1));
end;

class function TMyEngineArrayBuilder.Create: PMyEngineArrayBuilder;
begin
  Exit(AllocMem(SizeOf(TMyEngineArrayBuilder)));
end;

function TMyEngineArrayBuilder.ItemsIsConst: Boolean;
var
  i: Integer;
begin
  for i := 0 to (FItemsCount - 1) do
    if (not FItemsArray[i].IsConstValue) then Exit(False);
  Exit(True);
end;

{ TMyEngineGlobalContextSaveState }

procedure TMyEngineGlobalContextSaveState.Backup;
begin
  FContextGlobal := gvContextGlobal;
end;

procedure TMyEngineGlobalContextSaveState.Restore;
begin
  gvContextGlobal := FContextGlobal;
end;

{ TMyEngineRunner }

function TMyEngineRunner.AddContext(const AContext: PMyEngineContext): Boolean;
begin
  if ((FCrCount > 0) and (FCrStack[FCrCount - 1].Context = AContext)) then
    Exit(False);

  if (FCrCount = FCrCapacity) then
  begin
    Inc(FCrCapacity, 32);
    SetLength(FCrStack, FCrCapacity);
  end;

  FCrStack[FCrCount].Context := AContext;
  FCrStack[FCrCount].StackBase := gvStackVarsIndex;
  Inc(FCrCount);
  Exit(True);
end;

procedure TMyEngineRunner.ExecuteContext(const AContext: PMyEngineContext;
  const AParams: TArray<PMyEngineContextValue>; const AOwnerStackBase: Integer;
  var AResult: TMyEngineContextVariableData);
var
  LStackIndex, LCount: Integer;
  LAdded: Boolean;
  LTypeId: TMyEngineContextFunctionTypeId;
  LContextFunction: PMyEngineContextFunction absolute AContext;
  LBlock: PMyEngineContextBlock;
  LItem: PMyEngineContextBlockItem;
  LParam: TMyEngineRunnerItem;
  p: PPMyEngineContextValue;
  LArgs: TMyEngineContextVariableDataDynArray;
  LArgPtr, LStack: PMyEngineContextVariableData;

  procedure InitializeArgs;
  var
    i: Integer;
  begin
    if (LCount <= 0) then
    begin
      LArgs := nil;
      Exit;
    end;

    SetLength(LArgs, LCount);
    LArgPtr := Pointer(LArgs);

    p := Pointer(AParams);
    for i := 0 to (LCount - 1) do
    begin
      p^^.Execute(LParam, LArgPtr^);
      Inc(p);
      Inc(LArgPtr);
    end;

    LStack := StackVarItem(LStackIndex);
    for i := 0 to (LCount - 1) do
      LStack[i].SetId(TMyEngineContextVariableDataTypeId.eNone);

    System.Move(LArgs[0], StackVarItem(LStackIndex)^,
      (LCount * SizeOf(TMyEngineContextVariableData)));
  end;

begin
  LAdded := AddContext(AContext);

  LStackIndex := gvStackVarsIndex;
  AddStackVars(AContext.FVarsCount);

  LCount := Length(AParams);

  LParam.FRunner := @Self;
  LParam.FResult := @AResult;
  LParam.FStackBase := AOwnerStackBase;

  if (FCrCount > 0) then
    LParam.FGlobalStackBase := FCrStack[0].StackBase
  else
    LParam.FGlobalStackBase := 0;

  LParam.FCrCount := FCrCount;
  LParam.FParamCount := LCount;
  LParam.FIsTerminated := False;

  if (AContext.FTypeId = TMyEngineContextTypeId.eFunction) then
  begin
    if ((LContextFunction.FMinParamsCount > LCount)
    or (LContextFunction.FMaxParamsCount < LCount)) then
      raise EFunctionInvalidParamCount.Create(
        GetFunctionName(LContextFunction),
        LCount, LContextFunction.FMinParamsCount,
        LContextFunction.FMaxParamsCount);

    LTypeId := LContextFunction.FTypeId;
    if (LTypeId = TMyEngineContextFunctionTypeId.eNone) then
    begin
      if (not TryOptimizeFunction(LContextFunction)) then
        SetFunctionTypeId(LContextFunction, TMyEngineContextFunctionTypeId.eAST);
      LTypeId := LContextFunction.FTypeId;
    end;

    if (LTypeId > TMyEngineContextFunctionTypeId.eAST) then
    begin
      InitializeArgs;
      if cTableExFuncExecute[LTypeId](LArgs, AResult) then Exit;
    end else
      InitializeArgs;
  end else
    InitializeArgs;

  LParam.FStackBase := LStackIndex;

  LBlock := AContext.FBlocks;
  while (LBlock <> nil) do
  begin
    LItem := LBlock.FItemsFirst;
    while (LItem <> nil) do
    begin
      if LParam.FIsTerminated then
      begin
        AddStackVars(AContext.FVarsCount);
        if LAdded then Dec(FCrCount);
        Exit;
      end;

      cProcTable_EngineContextBlockItem_Execute[LItem.FTypeId](LItem, LParam);
      LItem := LItem.FNext;
    end;

    LBlock := LBlock.FNext;
  end;

  AddStackVars(AContext.FVarsCount);

  if LAdded then Dec(FCrCount);
end;

procedure TMyEngineRunner.Initialize;
begin
  FCrCount := 0;
  FCrCapacity := 0;
  FCrStack := nil;
end;

{ TMyEngineContext }

function TMyEngineContext.FindVar(
  const AName: LString): PMyEngineContextVariable;
var
  LContext: PMyEngineContext;
  LVar: PMyEngineContextVariable;
begin
  LContext := @Self;
  while (LContext <> nil) do
  begin
    LVar := LContext.FVarsFirst;
    while (LVar <> nil) do
    begin
      if (LVar.FName = AName) then Exit(LVar);
      LVar := LVar.FNext;
    end;
    LContext := LContext.FOwner;
  end;
  Exit(nil);
end;

function TMyEngineContext.LocalFindOrDeclrVar(
  const AName: LString): PMyEngineContextVariable;
var
  LVar: PMyEngineContextVariable;
begin
  LVar := FVarsFirst;
  if (LVar = nil) then
  begin
    LVar := AllocMem(SizeOf(TMyEngineContextVariable));
    LVar.FContext := @Self;
    LVar.FName := AName;
    LVar.FIndex := FVarsCount;
    Inc(FVarsCount);
    FVarsFirst := LVar;
    Exit(LVar);
  end;

  repeat
    if (LVar.FName = AName) then Exit(LVar);

    Result := LVar.FNext;
    if (Result = nil) then
    begin
      Result := AllocMem(SizeOf(TMyEngineContextVariable));
      Result.FContext := @Self;
      Result.FName := AName;
      Result.FIndex := FVarsCount;
      Inc(FVarsCount);
      LVar.FNext := Result;
      Exit;
    end;
    LVar := Result;
  until False;
end;

procedure TMyEngineContext.Parse(
  var ATokenStack: TMyTokenStack; var AIndex: Integer);
var
  LBlock: PMyEngineContextBlock;
  LIndex: Integer;
begin
  LBlock := FBlocks;
  if (LBlock = nil) then
  begin
    LBlock := AllocMem(SizeOf(TMyEngineContextBlock));
    LBlock.FContext := @Self;
    FBlocks := LBlock;
  end;

  LIndex := AIndex;
  while (LIndex < ATokenStack.Count) do
    ReadItemBlockItem(ATokenStack, @Self, LBlock, LIndex);
  AIndex := LIndex;
end;

procedure TMyEngineContext.ParseGlobal;
var
  LIndex: Integer;
begin
  LIndex := 0;
  Parse(gvTokens, LIndex);
end;

function TMyEngineContext.RelativeIndexOf(
  const AContext: PMyEngineContext): Integer;
var
  LCursor: PMyEngineContext;
begin
  if (AContext = nil) then Exit(-1);

  Result := 0;
  LCursor := @Self;
  repeat
    if (LCursor = AContext) then Exit;
    if (LCursor = nil) then Exit(-1);
    LCursor := LCursor.FOwner;
    Inc(Result);
  until False;
end;

function TMyEngineContext.VarByName(
  const AToken: PMyToken): PMyEngineContextVariable;
begin
  Result := FindVar(AToken.vds);
  if (Result = nil) then
    raise EBuilderVariableNotFound.New(AToken);
end;

{ TMyEngineContextGlobal }

class function TMyEngineContextGlobal.Create: PMyEngineContextGlobal;
begin
  Result := AllocMem(SizeOf(TMyEngineContextGlobal));
  Result.FBase.FTypeId := TMyEngineContextTypeId.eGlobal;
  Result.CreateSysFunc_Print;
  Result.CreateSysFunc_ArrayGetItems;
end;

function TMyEngineContextGlobal.CreateSysFunc(const AName: LString;
  const AProc: TMyEngineRunnerItem_BinaryCode_Proc): PMyEngineContextFunction;
var
  LVar: PMyEngineContextVariable;
  LFunc: PMyEngineContextFunction;
  LBlock: PMyEngineContextBlock;
begin
  LFunc := TMyEngineContextFunction.Create(@Self);

  LBlock := LFunc.FBase.FBlocks;
  if (LBlock = nil) then
  begin
    LBlock := AllocMem(SizeOf(TMyEngineContextBlock));
    LFunc.FBase.FBlocks := LBlock;
  end;

  LBlock.ItemsAdd(Pointer(TMyEngineContextBlockItemBinCode.Create(AProc)));

  LVar := FBase.LocalFindOrDeclrVar(AName);
  LVar.FData.SetAsFunction(LFunc);
  Exit(LFunc);
end;

procedure TMyEngineContextGlobal.CreateSysFunc_ArrayGetItem(
  const AName: LString; const AProc: TMyEngineRunnerItem_BinaryCode_Proc);
var
  LFunc: PMyEngineContextFunction;
begin
  LFunc := CreateSysFunc(AName, AProc);
  LFunc.FMinParamsCount := 1;
  LFunc.FMaxParamsCount := 1;
end;

procedure TMyEngineContextGlobal.CreateSysFunc_ArrayGetItems;
begin
  CreateSysFunc_ArrayGetItem('first', SysProc_First);
  CreateSysFunc_ArrayGetItem('second', SysProc_Second);
  CreateSysFunc_ArrayGetItem('third', SysProc_Third);
  CreateSysFunc_ArrayGetItem('fourth', SysProc_Fourth);
  CreateSysFunc_ArrayGetItem('fifth', SysProc_Fifth);
  CreateSysFunc_ArrayGetItem('sixth', SysProc_Sixth);
  CreateSysFunc_ArrayGetItem('seventh', SysProc_Seventh);
  CreateSysFunc_ArrayGetItem('eighth', SysProc_Eighth);
  CreateSysFunc_ArrayGetItem('ninth', SysProc_Ninth);
  CreateSysFunc_ArrayGetItem('tenth', SysProc_Tenth);
end;

procedure TMyEngineContextGlobal.CreateSysFunc_Print;
var
  LFunc: PMyEngineContextFunction;
begin
  LFunc := CreateSysFunc('print', SysProc_Print);
  LFunc.FMinParamsCount := 1;
  LFunc.FMaxParamsCount := 100;
end;

{ TMyEngineContextFunction }

class function TMyEngineContextFunction.
  Create(const AOwner: PMyEngineContext): PMyEngineContextFunction;
begin
  Result := AllocMem(SizeOf(TMyEngineContextFunction));
  Result.FBase.FOwner := AOwner;
  Result.FBase.FTypeId := TMyEngineContextTypeId.eFunction;
end;

{ TMyEngineContextBlock }

procedure TMyEngineContextBlock.ItemsAdd(
  const AItem: PMyEngineContextBlockItem);
begin
  if (FItemsFirst = nil) then
    FItemsFirst := AItem
  else
    FItemsLast.FNext := AItem;

  FItemsLast := AItem;
  AItem.FBlock := @Self;
  AItem.FContext := FContext;
end;

{ TMyEngineContextBlockItemBinCode }

class function TMyEngineContextBlockItemBinCode.Create(
  const AProc: TMyEngineRunnerItem_BinaryCode_Proc):
  PMyEngineContextBlockItemBinCode;
begin
  Result := AllocMem(SizeOf(TMyEngineContextBlockItemBinCode));
  Result.FProc := AProc;
  Result.FBase.FTypeId := TMyEngineContextBlockItemTypeId.eBinCode;
end;

{ TMyEngineContextValue }

procedure TMyEngineContextValue.Execute(var AItem: TMyEngineRunnerItem;
  var AResult: TMyEngineContextVariableData);
begin
  cProcTable_MyEngineContextValue_Execute[FTypeId](@Self, AItem, AResult);
end;

function TMyEngineContextValue.IsConstValue: Boolean;
begin
  Exit(FTypeId in [
    TMyEngineContextValueTypeId.eConstBool,
    TMyEngineContextValueTypeId.eConstInt,
    TMyEngineContextValueTypeId.eConstString,
    TMyEngineContextValueTypeId.eConstFunction,
    TMyEngineContextValueTypeId.eConstArray]);
end;

{ TMyEngineContextVariable }

class function TMyEngineContextVariable.Create: PMyEngineContextVariable;
begin
  Result := AllocMem(SizeOf(TMyEngineContextVariable));
end;

{ TMyEngineContextValueNegative }

class function TMyEngineContextValueNegative.Create(
  const ARefValue: PMyEngineContextValue): PMyEngineContextValueNegative;
begin
  Result := AllocMem(SizeOf(TMyEngineContextValueNegative));
  Result.FBase.FTypeId := TMyEngineContextValueTypeId.eNegative;
  Result.FRefValue := ARefValue;
end;

{ TMyEngineContextValueOp2 }

class function TMyEngineContextValueOp2.Create(
  const ALeft, ARight: PMyEngineContextValue;
  const AOp: Byte): PMyEngineContextValueOp2;
begin
  Result := AllocMem(SizeOf(TMyEngineContextValueOp2));
  Result.FLeft := ALeft;
  Result.FRight := ARight;
  Result.FBase.FTypeId := TMyEngineContextValueTypeId.eOp2;
  Result.FIndexOp := ((AOp - tkop_Add) * 36);
  Result.FOp := AOp;
end;

{ TMyEngineContextValueFunction }

class function TMyEngineContextValueFunction.Create(
  const AFunction: PMyEngineContextFunction;
  const AParams: TArray<PMyEngineContextValue>): PMyEngineContextValueFunction;
begin
  Result := AllocMem(SizeOf(TMyEngineContextValueFunction));
  Result.FFunction := AFunction;
  Result.FParams := AParams;
  Result.FBase.FTypeId := TMyEngineContextValueTypeId.eFunction;
end;

{ TMyEngineContextValueFunctionByValue }

class function TMyEngineContextValueFunctionByValue.Create(
  const AValue: PMyEngineContextValue;
  const AParams: TArray<PMyEngineContextValue>):
  PMyEngineContextValueFunctionByValue;
begin
  Result := AllocMem(SizeOf(TMyEngineContextValueFunctionByValue));
  Result.FValue := AValue;
  Result.FParams := AParams;
  Result.FBase.FTypeId := TMyEngineContextValueTypeId.eFunctionByValue;
end;

end.
