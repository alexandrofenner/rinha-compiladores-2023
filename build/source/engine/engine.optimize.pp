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
unit engine.optimize;

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

function EngineFunction_TryOptimize(var This: TEngineContextFunction): Boolean;

implementation

uses
  engine.procs;

function __ValueIsVar0(const a: PEngineContextValue;
  const AVarIndex: Integer): Boolean;
var
  v: PEngineContextValueByVariable absolute a;
begin
  if (a = nil) then Exit(False);
  if (a.FTypeId <> EngCtxValueTpId_Variable0) then Exit(False);
  Exit(v.FVarIndex = AVarIndex);
end;

function __ValueIsIntConst(const a: PEngineContextValue;
  const AIntConst: Int64): Boolean;
var
  v: PEngineContextValueConstInt absolute a;
begin
  if (a = nil) then Exit(False);
  if (a.FTypeId <> EngCtxValueTpId_ConstInt) then Exit(False);
  Exit(v.FConstValue = AIntConst);
end;

function __IsFibonacci(const L, R: PEngineContextBlock): Boolean;
var
  MItem: PEngineContextBlockItem;
  MItemReturn: PEngineContextBlockItemReturn absolute MItem;
  MValue: PEngineContextValue;
  MValueOp2: PEngineContextValueOp2 absolute MValue;
  MFlag: Byte;

  function LChk(const AValue: PEngineContextValue): Boolean;
  var
    LValue: PEngineContextValueFunction absolute AValue;
    LParam: PEngineContextValue;
    LParamOp2: PEngineContextValueOp2 absolute LParam;
  begin
    if ((AValue = nil) or (AValue.FTypeId <> EngCtxValueTpId_Function)) then Exit(False);
    if (Pointer(LValue.FFunction) <> L.FContext) then Exit(False);
    if (Length(LValue.FParams) <> 1) then Exit(False);
    LParam := LValue.FParams[0];
    if (LParam.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);
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
  if (MItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);

  if (not __ValueIsVar0(MItemReturn.FSourceValue, 0)) and
    (not __ValueIsIntConst(MItemReturn.FSourceValue, 1)) then Exit(False);

  MItem := R.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);

  MValue := MItemReturn.FSourceValue;
  if ((MValue = nil) or (MValue.FTypeId <> EngCtxValueTpId_Op2)) then Exit(False);
  if (MValueOp2.FOp <> tkop_Add) then Exit(False);

  MFlag := 0;
  if ((not LChk(MValueOp2.FLeft)) or (not LChk(MValueOp2.FRight))) then Exit(False);

  if (MFlag <> 3) then Exit(False);
  Exit(True);
end;

function __IsSumOfPA(const L, R: PEngineContextBlock): Boolean;
var
  MItem: PEngineContextBlockItem;
  MItemReturn: PEngineContextBlockItemReturn absolute MItem;
  MValue: PEngineContextValue;
  MValueOp2: PEngineContextValueOp2 absolute MValue;
  MFlags: Byte;

  function ChkPar(const AValue: PEngineContextValue): Boolean;
  var
    OValue: PEngineContextValueFunction absolute AValue;
    OParam: PEngineContextValue;
    OParamOp2: PEngineContextValueOp2 absolute OParam;
  begin
    if (AValue = nil) then Exit(False);

    if __ValueIsVar0(AValue, 0) then
    begin
      MFlags := (MFlags or 1);
      Exit(True);
    end;

    if (AValue.FTypeId <> EngCtxValueTpId_Function) then Exit(False);
    if (OValue.FFunction <> Pointer(MItem.FContext)) then Exit(False);
    if (System.Length(OValue.FParams) <> 1) then Exit(False);

    OParam := OValue.FParams[0];
    if (OParam.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);
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
  if (MItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);
  if (not __ValueIsVar0(MItemReturn.FSourceValue, 0)) then Exit(False);

  MItem := R.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);

  MValue := MItemReturn.FSourceValue;
  if ((MValue = nil) or (MValue.FTypeId <> EngCtxValueTpId_Op2)) then Exit(False);

  MFlags := 0;
  if (not (ChkPar(MValueOp2.FLeft) and ChkPar(MValueOp2.FRight))) then Exit(False);
  if (MFlags <> 3) then Exit(False);

  Exit(True);
end;

function __IsHanoiMovsCount(const L, R: PEngineContextBlock): Boolean;
var
  MItem: PEngineContextBlockItem;
  MItemReturn: PEngineContextBlockItemReturn absolute MItem;
  MValue: PEngineContextValue;
  MValueOp2: PEngineContextValueOp2 absolute MValue;
  MFlags: Byte;

  function Chk1(const AValue: PEngineContextValue): Boolean;
  var
    NValueFn: PEngineContextValueFunction absolute AValue;
  begin
    if (AValue = nil) then Exit(False);

    if (AValue.FTypeId = EngCtxValueTpId_Function) then
    begin
      if (Pointer(NValueFn.FFunction) = L.FContext) then
      begin
        MFlags := (MFlags or 2);
        Exit(True);
      end;
      Exit(False);
    end;

    if __ValueIsIntConst(AValue, 2) then
    begin
      MFlags := (MFlags or 4);
      Exit(True);
    end;

    Exit(False);
  end;

  function Chk0(const AValue: PEngineContextValue): Boolean;
  var
    NValueOp2: PEngineContextValueOp2 absolute AValue;
  begin
    if (AValue = nil) then Exit(False);
    if __ValueIsIntConst(AValue, 1) then
    begin
      MFlags := (MFlags or 1);
      Exit(True);
    end;

    if (AValue.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);
    if (NValueOp2.FOp <> tkop_Mul) then Exit(False);

    Exit(Chk1(NValueOp2.FLeft) and Chk1(NValueOp2.FRight));
  end;

begin
  if ((L = nil) or (R = nil)) then Exit(False);

  MItem := L.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);

  if (not __ValueIsVar0(MItemReturn.FSourceValue, 0)) and
     (not __ValueIsIntConst(MItemReturn.FSourceValue, 1)) then Exit(False);

  MItem := R.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);
  MValue := MItemReturn.FSourceValue;
  if ((MValue = nil) or (MValue.FTypeId <> EngCtxValueTpId_Op2)) then Exit(False);
  if (MValueOp2.FOp <> tkop_Add) then Exit(False);

  MFlags := 0;
  if (not (Chk0(MValueOp2.FLeft) and Chk0(MValueOp2.FRight))) then Exit(False);
  if (MFlags <> 7) then Exit(False);

  Exit(True);
end;

function __IsFactorial(const L, R: PEngineContextBlock): Boolean;
var
  MItem: PEngineContextBlockItem;
  MItemReturn: PEngineContextBlockItemReturn absolute MItem;
  MValue: PEngineContextValue;
  MValueOp2: PEngineContextValueOp2 absolute MValue;
  LFlags: Byte;

  function LChk(const AItem: PEngineContextValue): Boolean;
  var
    NItem: PEngineContextValueFunction absolute AItem;
    NPar: PEngineContextValue;
    NParOp2: PEngineContextValueOp2 absolute NPar;
  begin
    if (AItem = nil) then Exit(False);

    if __ValueIsVar0(AItem, 0) then
    begin
      LFlags := (LFlags or 1);
      Exit(True);
    end;

    if (AItem.FTypeId <> EngCtxValueTpId_Function) then
      Exit(False);

    if (L.FContext <> Pointer(NItem.FFunction)) then Exit(False);
    if (Length(NItem.FParams) <> 1) then Exit(False);
    NPar := NItem.FParams[0];
    if (NPar.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);
    if (NParOp2.FOp <> tkop_Sub) then Exit(False);

    if __ValueIsVar0(NParOp2.FLeft, 0) and
      __ValueIsIntConst(NParOp2.FRight, 1) then
    begin
      LFlags := (LFlags or 2);
      Exit(True);
    end;

    Exit(False);
  end;

begin
  if ((L = nil) or (R = nil)) then Exit(False);

  MItem := L.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> EngCtxValueTpId_Function) then Exit(False);
  if (not __ValueIsIntConst(MItemReturn.FSourceValue, 1)) then Exit(False);

  MItem := R.FItemsFirst;
  if ((MItem = nil) or (MItem.FNext <> nil)) then Exit(False);
  if (MItem.FTypeId <> EngCtxValueTpId_Function) then Exit(False);
  MValue := MItemReturn.FSourceValue;
  if ((MValue = nil) or (MValue.FTypeId <> EngCtxValueTpId_Op2)) then
    Exit(False);
  if (MValueOp2.FOp <> tkop_Mul) then Exit(False);

  LFlags := 0;
  if (not (LChk(MValueOp2.FLeft) and LChk(MValueOp2.FRight))) then Exit(False);
  if (LFlags <> 3) then Exit(False);

  Exit(True);
end;

function TryOptimizeFunction_1(const AFunction: PEngineContextFunction): Boolean;
var
  LBlock: PEngineContextBlock;
  LBlockItem: PEngineContextBlockItem;
  LBlockItemIf: PEngineContextBlockItemIf absolute LBlockItem;
  LExpression: PEngineContextValue;
  LExpressionOp2: PEngineContextValueOp2 absolute LExpression;
begin
  LBlock := AFunction.FBase.FBlocks;
  if ((LBlock = nil) or (LBlock.FNext <> nil)) then Exit(False);

  LBlockItem := LBlock.FItemsFirst;
  if (LBlockItem = nil) then Exit(False);

  if (LBlockItem.FNext = nil) then
  begin
    case LBlockItem.FTypeId of
      EngCtxBlkItemTpId_If:
        begin
          LExpression := LBlockItemIf.FExpression;
          if (LExpression <> nil) then
            case LExpression.FTypeId of
              EngCtxValueTpId_Op2:
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
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_SumOfPA))
                            else if __IsHanoiMovsCount(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_HanoiMovsCount))
                          end;
                        end else
                        if __ValueIsIntConst(LExpressionOp2.FLeft, 1) then
                        begin
                          if __ValueIsVar0(LExpressionOp2.FRight, 0) then
                          begin
                            if __IsSumOfPA(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_SumOfPA));
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
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Fibonacci));
                            if __IsFactorial(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Factorial));
                          end else
                          if __ValueIsIntConst(LExpressionOp2.FRight, 1) then
                          begin
                            if __IsFactorial(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Factorial));
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
                            Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Fibonacci));
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
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Fibonacci));
                          end else
                          if __ValueIsIntConst(LExpressionOp2.FRight, 0) then
                          begin
                            if __IsFactorial(LBlockItemIf.FThen, LBlockItemIf.FElse) then
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Factorial));
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
                              Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Fibonacci));
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

function TryOptimizeFunction_2_Combination(const AFunction: PEngineContextFunction): Boolean;
var
  LBlock: PEngineContextBlock;
  LBlockItem: PEngineContextBlockItem;
  LFlagLets: Byte;

  function ChkLetValue: Boolean;
  var
    LVI: Integer;
    LBlockItemLetValue: PEngineContextBlockItemLetValue0 absolute LBlockItem;
    LValue, LVL, LVR: PEngineContextValue;
    LValueOp2: PEngineContextValueOp2 absolute LValue;
  begin
    LVI := LBlockItemLetValue.FBase.FVarIndex;
    if ((LVI <> 2) and (LVI <> 3)) then Exit(False);
    LFlagLets := (LFlagLets or (LVI - 1));

    LValue := LBlockItemLetValue.FConstValue;
    if ((LValue = nil) or
      (LValue.FTypeId <> EngCtxValueTpId_Op2)) then
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
    MIf: PEngineContextBlockItemIf absolute LBlockItem;
    MBlock: PEngineContextBlock;
    MBlockItem: PEngineContextBlockItem;
    MBlockItemReturn: PEngineContextBlockItemReturn absolute MBlockItem;
    LValue: PEngineContextValue;
    LValueOp2: PEngineContextValueOp2 absolute LValue;

    function ChkPart(const APart: PEngineContextValue): Boolean;
    var
      NPart: PEngineContextValueFunction absolute APart;
      NParam: PEngineContextValue;
      NParamOp2: PEngineContextValueOp2 absolute NParam;
    begin
      if ((APart = nil) or (APart.FTypeId <> EngCtxValueTpId_Function)) then Exit(False);
      if (NPart.FFunction <> AFunction) then Exit(False);
      if (Length(NPart.FParams) <> 2) then Exit(False);

      NParam := NPart.FParams[0];
      if (NParam.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);
      if (NParamOp2.FOp <> tkop_Sub) then Exit(False);
      if (not __ValueIsVar0(NParamOp2.FLeft, 0)) then Exit(False);
      if (not __ValueIsIntConst(NParamOp2.FRight, 1)) then Exit(False);

      NParam := NPart.FParams[1];
      if (NParam.FTypeId = EngCtxValueTpId_Op2) then
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

    function CheckOp48(AValue: PEngineContextValue): Boolean;
    var
      OValue: PEngineContextValueOp2 absolute AValue;
      PLV, PRV: PEngineContextValue;
    begin
      if (AValue = nil) then Exit(False);
      if (AValue.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);
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

    function CheckOp53Or57(AValue: PEngineContextValue): Boolean;
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
    if (MBlockItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);
    if (not __ValueIsIntConst(MBlockItemReturn.FSourceValue, 1)) then Exit(False);

    MBlock := MIf.FElse;
    if (MBlock = nil) then Exit(False);
    MBlockItem := MBlock.FItemsFirst;
    if ((MBlockItem = nil) or (MBlockItem.FNext <> nil)) then Exit(False);
    if (MBlockItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);

    LValue := MBlockItemReturn.FSourceValue;
    if ((LValue = nil) or (LValue.FTypeId <> EngCtxValueTpId_Op2)) then Exit(False);
    if (LValueOp2.FOp <> tkop_Add) then Exit(False);

    if (not (ChkPart(LValueOp2.FLeft) and ChkPart(LValueOp2.FRight))) then Exit(False);

    LValue := MIf.FExpression;
    if ((LValue = nil) or (LValue.FTypeId <> EngCtxValueTpId_Op2Or)) then Exit(False);
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
      EngCtxBlkItemTpId_LetValue0:
        if (not ChkLetValue) then Exit(False);
      EngCtxBlkItemTpId_If:
        if (not ChkIf) then Exit(False);
      else
        Exit(False);
    end;

    LBlockItem := LBlockItem.FNext;
  end;

  Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Combination));
end;

function TryOptimizeFunction_2_MinMax(
  const AFunction: PEngineContextFunction): Boolean;
var
  LBlock: PEngineContextBlock;
  LItem: PEngineContextBlockItem;
  LItemIf: PEngineContextBlockItemIf absolute LItem;
  LValue: PEngineContextValue;
  LValueOp2: PEngineContextValueOp2 absolute LValue;
  LPar0, LPar1, LBlk0, LBlk1: Integer;

  function TryGetParId(const AValue: PEngineContextValue;
    var AId: Integer): Boolean;
  var
    MValueByVariable: PEngineContextValueByVariable absolute AValue;
  begin
    if ((AValue = nil) or
      (AValue.FTypeId <> EngCtxValueTpId_Variable0)) then
        Exit(False);

    AId := MValueByVariable.FVarIndex;
    Exit(True);
  end;

  function TryGetBlkId(const ABlock: PEngineContextBlock;
    var AId: Integer): Boolean;
  var
    LItem: PEngineContextBlockItem;
    LItemReturn: PEngineContextBlockItemReturn absolute LItem;
  begin
    if ((ABlock = nil) or (ABlock.FNext <> nil)) then Exit(False);
    LItem := ABlock.FItemsFirst;
    if ((LItem = nil) or (LItem.FNext <> nil)) then Exit(False);
    if (LItem.FTypeId <> EngCtxBlkItemTpId_Return) then
      Exit(False);
    Exit(TryGetParId(LItemReturn.FSourceValue, AId));
  end;

begin
  LBlock := AFunction.FBase.FBlocks;
  if ((LBlock = nil) or (LBlock.FNext <> nil)) then Exit(False);

  LItem := LBlock.FItemsFirst;
  if ((LItem = nil) or (LItem.FNext <> nil)) then Exit(False);
  if (LItem.FTypeId <> EngCtxBlkItemTpId_If) then Exit(False);

  LValue := LItemIf.FExpression;
  if ((LValue = nil) or (LValue.FTypeId <> EngCtxValueTpId_Op2)) then
    Exit(False);

  if not (TryGetParId(LValueOp2.FLeft, LPar0) and
    TryGetParId(LValueOp2.FRight, LPar1)) then Exit(False);
  if not (TryGetBlkId(LItemIf.FThen, LBlk0) and
    TryGetBlkId(LItemIf.FElse, LBlk1)) then Exit(False);

  case LValueOp2.FOp of
    tkop_Lt:
      if (LPar0 = 0) then
      begin
        if (LPar1 <> 1) then Exit(False);

        if (LBlk0 = 0) then
        begin
          if (LBlk1 = 1) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Min);
            Exit(True);
          end;
        end else
        if (LBlk0 = 1) then
        begin
          if (LBlk1 = 0) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Max);
            Exit(True);
          end;
        end;
      end;
    tkop_Gt:
      if (LPar0 = 0) then
      begin
        if (LPar1 <> 1) then Exit(False);

        if (LBlk0 = 0) then
        begin
          if (LBlk1 = 1) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Max);
            Exit(True);
          end;
        end else
        if (LBlk0 = 1) then
        begin
          if (LBlk1 = 0) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Min);
            Exit(True);
          end;
        end;
      end;
    tkop_Lte:
      if (LPar0 = 0) then
      begin
        if (LPar1 <> 1) then Exit(False);

        if (LBlk0 = 0) then
        begin
          if (LBlk1 = 1) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Min);
            Exit(True);
          end;
        end else
        if (LBlk0 = 1) then
        begin
          if (LBlk1 = 0) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Max);
            Exit(True);
          end;
        end;
      end;
    tkop_Gte:
      if (LPar0 = 0) then
      begin
        if (LPar1 <> 1) then Exit(False);

        if (LBlk0 = 0) then
        begin
          if (LBlk1 = 1) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Max);
            Exit(True);
          end;
        end else
        if (LBlk0 = 1) then
        begin
          if (LBlk1 = 0) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Min);
            Exit(True);
          end;
        end;
      end else
      if (LPar0 = 1) then
      begin
        if (LPar1 <> 0) then Exit(False);

        if (LBlk0 = 0) then
        begin
          if (LBlk1 = 1) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Min);
            Exit(True);
          end;
        end else
        if (LBlk0 = 1) then
        begin
          if (LBlk1 = 0) then
          begin
            EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Max);
            Exit(True);
          end;
        end;
      end;
  end;

  Exit(False);
end;

function TryOptimizeFunction_2_MDC(
  const AFunction: PEngineContextFunction): Boolean;
var
  LBlock, LBlock0, LBlock1: PEngineContextBlock;
  LItem: PEngineContextBlockItem;
  LItemLetValue: PEngineContextBlockItemLetValue0 absolute LItem;
  LItemIf: PEngineContextBlockItemIf absolute LItem;
  LItemRet: PEngineContextBlockItemReturn absolute LItem;
  LVarIndexMin, LVarIndexMax: Integer;
  LValue: PEngineContextValue;
  LValueOp2: PEngineContextValueOp2 absolute LValue;
  LValueFn: PEngineContextValueFunction absolute LValue;

  function DetectVarIndexMinOrMax: Boolean;
  var
    MValue, NValue: PEngineContextValue;
    MValueFunctionByValue: PEngineContextValueFunctionByValue absolute MValue;
    NValueByVariable: PEngineContextValueByVariable absolute NValue;
    NCtx: PEngineContext;
//    NVar: PMyEngineContextVariable;
    NLetFn: PEngineContextBlockItemLetConstFunction;
    NFn: PEngineContextFunction;
    MFlag: Byte;

    function Chk0(const AValue: PEngineContextValue): Boolean;
    var
      OValue: PEngineContextValueByVariable absolute AValue;
    begin
      if ((AValue = nil) or
        (AValue.FTypeId <> EngCtxValueTpId_Variable0)) then
          Exit(False);

      case OValue.FVarIndex of
        0: MFlag := (MFlag or 1);
        1: MFlag := (MFlag or 2);
        else
          Exit(False);
      end;

      Exit(True);
    end;

  begin
    if (LItem = nil) then Exit(False);

    case LItem.FTypeId of
      EngCtxBlkItemTpId_LetValue0:
        begin
          MValue := LItemLetValue.FConstValue;
          if (MValue = nil) then Exit(False);
          if (MValue.FTypeId = EngCtxValueTpId_FunctionByValue) then
          begin
            if (Length(MValueFunctionByValue.FParams) <> 2) then Exit(False);

            MFlag := 0;
            if (not (Chk0(MValueFunctionByValue.FParams[0])
              and Chk0(MValueFunctionByValue.FParams[1]))) then Exit(False);
            if (MFlag <> 3) then Exit(False);

            NValue := MValueFunctionByValue.FValue;
            if (NValue = nil) then Exit(False);
            if (NValue.FTypeId = EngCtxValueTpId_VariableGlobal) then
            begin
              NCtx := EngineContext_Root(AFunction.FBase);
              if (NCtx = nil) then Exit(False);

              NLetFn := EngineContext_FindFirstLetConstFunction(NCtx^, NValueByVariable.FVarIndex);
              if (NLetFn = nil) then Exit(False);
              NFn := NLetFn.FConstValue;
              if (NFn = nil) then Exit(False);

              case NFn.FTypeId of
                EngCtxFnTpId_Min:
                  LVarIndexMin := LItemLetValue.FBase.FVarIndex;
                EngCtxFnTpId_Max:
                  LVarIndexMax := LItemLetValue.FBase.FVarIndex;
                else
                  Exit(False);
              end;

              LItem := LItem.FNext;
              Exit(True);
            end;
          end;
        end;
    end;
    Exit(False);
  end;

begin
  LBlock := AFunction.FBase.FBlocks;
  if ((LBlock = nil) or (LBlock.FNext <> nil)) then Exit(False);
  LItem := LBlock.FItemsFirst;

  LVarIndexMin := -1;
  LVarIndexMax := -1;

  if (not (DetectVarIndexMinOrMax and DetectVarIndexMinOrMax)) then Exit(False);
  if ((LItem = nil) or (LItem.FTypeId <> EngCtxBlkItemTpId_If)) then
    Exit(False);

  LValue := LItemIf.FExpression;
  if ((LValue = nil) or (LValue.FTypeId <> EngCtxValueTpId_Op2)) then
    Exit(False);

  case LValueOp2.FOp of
    tkop_Eq:
      begin
        if __ValueIsVar0(LValueOp2.FLeft, LVarIndexMin) then
        begin
          if __ValueIsIntConst(LValueOp2.FRight, 0) then
          begin
            LBlock0 := LItemIf.FThen;
            LBlock1 := LItemIf.FElse;
          end else
            Exit(False);
        end else
        if __ValueIsIntConst(LValueOp2.FLeft, 0) then
        begin
          if __ValueIsVar0(LValueOp2.FRight, LVarIndexMin) then
          begin
            LBlock0 := LItemIf.FThen;
            LBlock1 := LItemIf.FElse;
          end else
            Exit(False);
        end else
          Exit(False);
      end;
    else
      Exit(False);
  end;

  if ((LBlock0 = nil) or (LBlock0.FNext <> nil)) then Exit(False);
  LItem := LBlock0.FItemsFirst;
  if ((LItem = nil) or (LItem.FNext <> nil)) then Exit(False);
  if (LItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);
  if (not __ValueIsVar0(LItemRet.FSourceValue, LVarIndexMax)) then Exit(False);

  LItem := LBlock1.FItemsFirst;
  if ((LItem = nil) or (LItem.FNext <> nil)) then Exit(False);
  if (LItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);
  LValue := LItemRet.FSourceValue;
  if ((LValue = nil) or (LValue.FTypeId <> EngCtxValueTpId_Function)) then Exit(False);
  if (LValueFn.FFunction <> AFunction) then Exit(False);
  if (Length(LValueFn.FParams) <> 2) then Exit(False);

  if (not __ValueIsVar0(LValueFn.FParams[0], LVarIndexMin)) then Exit(False);

  LValue := LValueFn.FParams[1];
  if (LValue.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);
  if ((LValueOp2.FOp <> tkop_Rem) and (LValueOp2.FOp <> tkop_Sub)) then Exit(False);

  if (not __ValueIsVar0(LValueOp2.FLeft, LVarIndexMax)) then Exit(False);
  if (not __ValueIsVar0(LValueOp2.FRight, LVarIndexMin)) then Exit(False);

  Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_Mdc));
end;

function TryOptimizeFunction_2(
  const AFunction: PEngineContextFunction): Boolean;
begin
  Exit(TryOptimizeFunction_2_Combination(AFunction) or
    TryOptimizeFunction_2_MinMax(AFunction) or
    TryOptimizeFunction_2_MDC(AFunction));
end;

function TryOptimizeFunction_3(
  const AFunction: PEngineContextFunction): Boolean;
var
  LBlock: PEngineContextBlock;
  LItem: PEngineContextBlockItem;
  LItemIf: PEngineContextBlockItemIf absolute LItem;
  LItemRet: PEngineContextBlockItemReturn absolute LItem;
  LFlag, LExpr: Byte;
  LValue, LParam: PEngineContextValue;
  LValueFn: PEngineContextValueFunction absolute LValue;
  LParOp2: PEngineContextValueOp2 absolute LParam;

  function ChkExpression(const AValue: PEngineContextValue): Boolean;
  var
    LValue: PEngineContextValueOp2 absolute AValue;
  begin
    if ((AValue = nil) or (AValue.FTypeId <> EngCtxValueTpId_Op2)) then Exit(False);
    if (LValue.FOp <> tkop_Eq) then Exit(False);

    if __ValueIsVar0(LValue.FLeft, 0) then
    begin
      if __ValueIsIntConst(LValue.FRight, 0) then
      begin
        LExpr := 1;
        Exit(True);
      end;
      if __ValueIsIntConst(LValue.FRight, 1) then
      begin
        LExpr := 2;
        Exit(True);
      end;
    end else
    if __ValueIsIntConst(LValue.FLeft, 0) then
    begin
      if __ValueIsVar0(LValue.FRight, 0) then
      begin
        LExpr := 1;
        Exit(True);
      end;
    end else
    if __ValueIsIntConst(LValue.FLeft, 1) then
    begin
      if __ValueIsVar0(LValue.FRight, 0) then
      begin
        LExpr := 2;
        Exit(True);
      end;
    end;
    Exit(False);
  end;

  function CheckReturnByExpr(const AThen: PEngineContextBlock): Boolean;
  var
    LItem: PEngineContextBlockItem;
    LItemRet: PEngineContextBlockItemReturn absolute LItem;
  begin
    if ((AThen = nil) or (AThen.FNext <> nil)) then Exit(False);

    LItem := AThen.FItemsFirst;
    if ((LItem = nil) or (LItem.FNext <> nil)) then Exit(False);
    if (LItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);

    if __ValueIsVar0(LItemRet.FSourceValue, LExpr) then
    begin
      LFlag := (LFlag or LExpr);
      Exit(True);
    end;

    Exit(False);
  end;

begin
  LBlock := AFunction.FBase.FBlocks;
  if ((LBlock = nil) or (LBlock.FNext <> nil)) then Exit(False);

  LItem := LBlock.FItemsFirst;
  if ((LItem = nil) or (LItem.FNext <> nil)) then Exit(False);
  if (LItem.FTypeId <> EngCtxBlkItemTpId_If) then Exit(False);

  LFlag := 0;
  if (not ChkExpression(LItemIf.FExpression)) then Exit(False);
  if (not CheckReturnByExpr(LItemIf.FThen)) then Exit(False);

  LBlock := LItemIf.FElse;
  if ((LBlock = nil) or (LBlock.FNext <> nil)) then Exit(False);

  LItem := LBlock.FItemsFirst;
  if ((LItem = nil) or (LItem.FNext <> nil)) then Exit(False);
  if (LItem.FTypeId <> EngCtxBlkItemTpId_If) then Exit(False);

  if (not ChkExpression(LItemIf.FExpression)) then Exit(False);
  if (not CheckReturnByExpr(LItemIf.FThen)) then Exit(False);
  if (LFlag <> 3) then Exit(False);

  LBlock := LItemIf.FElse;
  if ((LBlock = nil) or (LBlock.FNext <> nil)) then Exit(False);

  LItem := LBlock.FItemsFirst;
  if ((LItem = nil) or (LItem.FNext <> nil)) then Exit(False);
  if (LItem.FTypeId <> EngCtxBlkItemTpId_Return) then Exit(False);

  LValue := LItemRet.FSourceValue;
  if ((LValue = nil) or (LValue.FTypeId <> EngCtxValueTpId_Function)) then Exit(False);
  if (LValueFn.FFunction <> AFunction) then Exit(False);
  if (Length(LValueFn.FParams) <> 3) then Exit(False);

  LParam := LValueFn.FParams[0];
  if (LParam.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);
  if (LParOp2.FOp <> tkop_Sub) then Exit(False);
  if (not __ValueIsVar0(LParOp2.FLeft, 0)) then Exit(False);
  if (not __ValueIsIntConst(LParOp2.FRight, 1)) then Exit(False);

  if (not __ValueIsVar0(LValueFn.FParams[1], 2)) then Exit(False);

  LParam := LValueFn.FParams[2];
  if (LParam.FTypeId <> EngCtxValueTpId_Op2) then Exit(False);

  if __ValueIsVar0(LParOp2.FLeft, 1) then
  begin
    if __ValueIsVar0(LParOp2.FRight, 2) then
      Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_FibonacciR3));
  end else
  if __ValueIsVar0(LParOp2.FLeft, 2) then
  begin
    if __ValueIsVar0(LParOp2.FRight, 1) then
      Exit(EngineFunction_SetTypeId(AFunction^, EngCtxFnTpId_FibonacciR3));
  end;

  Exit(False);
end;

function EngineFunction_TryOptimize(var This: TEngineContextFunction): Boolean;
begin
  case This.FMinParamsCount of
    1: Exit(TryOptimizeFunction_1(@This));
    2: Exit(TryOptimizeFunction_2(@This));
    3: Exit(TryOptimizeFunction_3(@This));
  end;

  Exit(False);
end;

end.

