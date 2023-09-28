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
unit engine.types;

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
  data.types,
  engine.consts;

type
  PPEngineContextValue = ^PEngineContextValue;

  PEngineRunnerContextRecord = ^TEngineRunnerContextRecord;
  PEngineRecursiveCacheEntry = ^TEngineRecursiveCacheEntry;
  PEngineRecursiveCache = ^TEngineRecursiveCache;
  PEngineRunner = ^TEngineRunner;
  PEngineRunnerItem = ^TEngineRunnerItem;
  PEngineContext = ^TEngineContext;
  PEngineContextGlobal = ^TEngineContextGlobal;
  PEngineContextFunction = ^TEngineContextFunction;
  PEngineContextFunctionRefClosureVar = ^TEngineContextFunctionRefClosureVar;
  PEngineContextFunctionRef = ^TEngineContextFunctionRef;
  PEngineContextBlock = ^TEngineContextBlock;
  PEngineContextBlockItem = ^TEngineContextBlockItem;
  PEngineContextBlockItemLet = ^TEngineContextBlockItemLet;
  PEngineContextBlockItemLetConstBool = ^TEngineContextBlockItemLetConstBool;
  PEngineContextBlockItemLetConstInt = ^TEngineContextBlockItemLetConstInt;
  PEngineContextBlockItemLetConstStr = ^TEngineContextBlockItemLetConstStr;
  PEngineContextBlockItemLetConstFunction = ^TEngineContextBlockItemLetConstFunction;
  PEngineContextBlockItemLetConstArray = ^TEngineContextBlockItemLetConstArray;
  PEngineContextBlockItemLetArray = ^TEngineContextBlockItemLetArray;
  PEngineContextBlockItemLetValue0 = ^TEngineContextBlockItemLetValue0;
  PEngineContextBlockItemLetValueRef = ^TEngineContextBlockItemLetValueRef;
  PEngineContextBlockItemCall = ^TEngineContextBlockItemCall;
  PEngineContextBlockItemReturn = ^TEngineContextBlockItemReturn;
  PEngineContextBlockItemIf = ^TEngineContextBlockItemIf;
  PEngineContextBlockItemWhile = ^TEngineContextBlockItemWhile;
  PEngineContextVariable = ^TEngineContextVariable;
  PEngineContextVariableRef = ^TEngineContextVariableRef;
  PEngineContextValue = ^TEngineContextValue;
  PEngineContextValueConstBool = ^TEngineContextValueConstBool;
  PEngineContextValueConstInt = ^TEngineContextValueConstInt;
  PEngineContextValueConstString = ^TEngineContextValueConstString;
  PEngineContextValueConstFunction = ^TEngineContextValueConstFunction;
  PEngineContextValueConstArray = ^TEngineContextValueConstArray;
  PEngineContextValueByVariable = ^TEngineContextValueByVariable;
  PEngineContextValueByVariableRef = ^TEngineContextValueByVariableRef;
  PEngineContextValueArray = ^TEngineContextValueArray;
  PEngineContextValueNegative = ^TEngineContextValueNegative;
  PEngineContextValueOp2 = ^TEngineContextValueOp2;
  PEngineContextValueFact = ^TEngineContextValueFact;
  PEngineContextValueFunction = ^TEngineContextValueFunction;
  PEngineContextValueFunctionByValue = ^TEngineContextValueFunctionByValue;
  PEngineContextValueIf = ^TEngineContextValueIf;
  PEngineContextPointer = ^TEngineContextPointer;

  TEngineGlobalContextSaveState = record
  public
    FGlobalContext: PEngineContext;  { Weak }
  end;

  TEngineRunnerContextRecord = record
  public
    FContext: PEngineContext;
    FStackBase: Integer;
    FRunningId: Int64;
  end;

  TEngineRecursiveCacheEntry = record
  public
    FContext: PEngineContext;
    FNext: PEngineRecursiveCacheEntry;
    FPrevious: PEngineRecursiveCacheEntry;
    FCache: PEngineRecursiveCache;
    FRefCount: Integer;
    FContentArray: array[0..31] of Pointer;
    FContentCount: Integer;
    FContentIndex: Integer;
    FFnTryGet: Pointer;
    FFnPut: Pointer;
    FTempBuffer: Pointer;
  end;

  TEngineRecursiveCache = record
  public
    FEntriesFirst: PEngineRecursiveCacheEntry;
    FEntriesLast: PEngineRecursiveCacheEntry;
    FIndex: Integer;
  end;

  TEngineRunner = record
  public
    FCrStack: TArray<TEngineRunnerContextRecord>;
    FCrCount: Integer;
    FCrCapacity: Integer;
    FRecursiveCaches: array[0..31] of TEngineRecursiveCache;
  end;

  TEngineRunnerItem = record
  public
    FRunner: PEngineRunner;                   { Weak }
    FResult: PFennerData;                     { Weak }
    FFunctionRef: PEngineContextFunctionRef;  { Weak }
    FCrCount: Integer;
    FStackBase: Integer;
    FGlobalStackBase: Integer;
    FParamCount: Integer;
    FRunningId: Int64;
    FIsTerminated: Boolean;
  end;

  TEngineContext = record
  public
    FTypeId: Byte;
    FCanFinalizeRefClosureVar: Boolean;
    FOwner: PEngineContext;                   { Weak }
    FLevel: Integer;
    FVarsCount: Integer;
    FVarRefsCount: Integer;
    FVarsFirst: PEngineContextVariable;
    FVarRefsFirst: PEngineContextVariableRef;
    FReadingVar: PEngineContextVariable;
    FBlocks: PEngineContextBlock;
  end;

  TEngineContextGlobal = record
  public
    FBase: TEngineContext;
  end;

  TEngineContextFunction = record
  public
    FBase: TEngineContext;
    FMinParamsCount: Integer;
    FMaxParamsCount: Integer;
    FConstDeclr: PEngineContextValueConstFunction;
    FDeclrName: LString;
    FTypeId: Byte;
    FFlags: Word;
    FRecursiveTypeId: Integer;
  end;

  TEngineContextFunctionRefClosureVar = record
  public
    FVarRef: PEngineContextVariableRef;  { Weak }
    FData: TFennerData;
    FRunningId: Int64;

    FPrevious: PEngineContextFunctionRefClosureVar;
    FNext: PEngineContextFunctionRefClosureVar;
  end;

  TEngineContextFunctionRef = record
  public
    FRefCount: Integer;
    FFunction: PEngineContextFunction;
    FClosureVars: TArray<TEngineContextFunctionRefClosureVar>;
  end;

  TEngineContextBlock = record
  public
    FContext: PEngineContext;             { Weak }
    FNext: PEngineContextBlock;           { Weak }
    FItemsFirst: PEngineContextBlockItem;
    FItemsLast: PEngineContextBlockItem;
  end;

  TEngineContextBlockItem = record
  public
    FTypeId: Byte;
    FContext: PEngineContext;         { Weak }
    FBlock: PEngineContextBlock;      { Weak }
    FNext: PEngineContextBlockItem;   { Weak }
  end;

  TEngineContextBlockItemLet = record
  public
    FBase: TEngineContextBlockItem;
    FVarIndex: Integer;
  end;

  TEngineContextBlockItemLetConstBool = record
  public
    FBase: TEngineContextBlockItemLet;
    FConstValue: Boolean;
  end;

  TEngineContextBlockItemLetConstInt = record
  public
    FBase: TEngineContextBlockItemLet;
    FConstValue: Int64;
  end;

  TEngineContextBlockItemLetConstStr = record
  public
    FBase: TEngineContextBlockItemLet;
    FConstValue: LString;
  end;

  TEngineContextBlockItemLetConstFunction = record
  public
    FBase: TEngineContextBlockItemLet;
    FConstValue: Pointer;
  end;

  TEngineContextBlockItemLetConstArray = record
  public
    FBase: TEngineContextBlockItemLet;
    FConstValue: TFennerDataDynArray;
  end;

  TEngineContextBlockItemLetArray = record
  public
    FBase: TEngineContextBlockItemLet;
    FConstValue: TArray<PEngineContextValue>;
  end;

  TEngineContextBlockItemLetValue0 = record
  public
    FBase: TEngineContextBlockItemLet;
    FConstValue: PEngineContextValue;
  end;

  TEngineContextBlockItemLetValueRef = record
  public
    FBase: TEngineContextBlockItemLet;
    FValue: PEngineContextValue;
    FRelativeContextIndex: Integer;
    FIndexRefClosureVar: Integer;
  end;

  TEngineContextBlockItemCall = record
  public
    FBase: TEngineContextBlockItemLet;
    FSourceValue: PEngineContextValue;
  end;

  TEngineContextBlockItemReturn = record
  public
    FBase: TEngineContextBlockItem;
    FSourceValue: PEngineContextValue;
  end;

  TEngineContextBlockItemIf = record
  public
    FBase: TEngineContextBlockItem;
    FExpression: PEngineContextValue;
    FThen: PEngineContextBlock;
    FElse: PEngineContextBlock;
  end;

  TEngineContextBlockItemWhile = record
  public
    FBase: TEngineContextBlockItem;
    FExpression: PEngineContextValue;
    FBlock: PEngineContextBlock;
  end;

  TEngineContextVariable = record
  public
    FContext: PEngineContext;       { Weak }
    FNext: PEngineContextVariable;
    FName: LString;
    FIndex: Integer;
    FData: TFennerData;
  end;

  TEngineContextVariableRef = record
  public
    FContext: PEngineContext;      { Weak }
    FIndex: Integer;
    FNext: PEngineContextVariableRef;
    FVariable: PEngineContextVariable;
    FRelativeContextIndex: Integer;
  end;

  TEngineContextValue = record
  public
    FTypeId: Byte;
  end;

  TEngineContextValueConstBool = record
  public
    FBase: TEngineContextValue;
    FConstValue: Boolean;
  end;

  TEngineContextValueConstInt = record
  public
    FBase: TEngineContextValue;
    FConstValue: Int64;
  end;

  TEngineContextValueConstString = record
  public
    FBase: TEngineContextValue;
    FConstValue: LString;
  end;

  TEngineContextValueConstFunction = record
  public
    FBase: TEngineContextValue;
    FConstValue: PEngineContextFunction;
  end;

  TEngineContextValueConstArray = record
  public
    FBase: TEngineContextValue;
    FConstValue: TFennerDataDynArray;
  end;

  TEngineContextValueByVariable = record
  public
    FBase: TEngineContextValue;
    FVarIndex: Integer;
    FRelContextIndex: Integer;
  end;

  TEngineContextValueByVariableRef = record
  public
    FBase: TEngineContextValueByVariable;
    FIndexRefClosureVar: Integer;
  end;

  TEngineContextValueArray = record
  public
    FBase: TEngineContextValue;
    FValues: TArray<PEngineContextValue>;
  end;

  TEngineContextValueNegative = record
  public
    FBase: TEngineContextValue;
    FRefValue: PEngineContextValue;
  end;

  TEngineContextValueOp2 = record
  public
    FBase: TEngineContextValue;

    FLeft: PEngineContextValue;
    FRight: PEngineContextValue;
    FIndexOp: Word;
    FOp: Byte;
  end;

  TEngineContextValueFact = record
  public
    FBase: TEngineContextValue;
    FValue: PEngineContextValue;
  end;

  TEngineContextValueFunction = record
  public
    FBase: TEngineContextValue;
    FFunction: PEngineContextFunction;    { Weak }
    FParams: TArray<PEngineContextValue>;
  end;

  TEngineContextValueFunctionByValue = record
  public
    FBase: TEngineContextValue;
    FValue: PEngineContextValue;
    FParams: TArray<PEngineContextValue>;
  end;

  TEngineContextValueIf = record
  public
    FBase: TEngineContextValue;
    FExpression: PEngineContextValue;
    FThen: PEngineContextBlock;
    FElse: PEngineContextBlock;
  end;

  TEngineContextPointer = record
  public
    FRefCount: Integer;
  end;

const
  c_EngCtxValueConstFalse: TEngineContextValueConstBool = (
    FBase: (FTypeId: EngCtxValueTpId_ConstBool);
    FConstValue: False);

  c_EngCtxValueConstTrue: TEngineContextValueConstBool = (
    FBase: (FTypeId: EngCtxValueTpId_ConstBool);
    FConstValue: True);

  c_EngCtxValueConstArrayEmpty: TEngineContextValueConstArray = (
    FBase: (FTypeId: EngCtxValueTpId_ConstArray);
    FConstValue: nil);

implementation

end.

