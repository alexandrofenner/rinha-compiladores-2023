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
unit engine.operators;

{$mode Delphi}{$H+}
{$asmmode Intel}
{$pointermath on}
{$scopedenums on}
{$r-,i-,o-,q-}
{$warnings off}
{$hints off}
{$notes off}

interface

uses
  sys.types,
  sys.utils,
  sys.procs,
  sys.funcs,
  scanner.types,
  data.types,
  data.procs,
  data._array;

procedure cInvkOp(APars: PFennerData; var AResult: TFennerData;
  AOp: UInt64); assembler;

implementation

uses
  err.classes;

procedure ThrowInvalidOp2(APars: PFennerData; var AResult: TFennerData;
  const AOp: Byte);
var
  LMsg, LMsgTypes: LString;
  LId0, LId1: Byte;
begin
  LId0 := APars[0].vId;
  LId1 := APars[1].vId;

  if (LId0 = LId1) then
    LMsgTypes := 'dois itens do tipo [' + cs_TypeOf[LId0] + ']'
  else
    LMsgTypes := 'um item do tipo [' + cs_TypeOf[LId0] +
      '] e outro item do tipo [' + cs_TypeOf[LId1] + ']';

  LMsg := 'Operação ilegal: [' + sTkOpersInfo[AOp] + '] entre ' + LMsgTypes;

  raise EInvalidOperation.Create(LMsg);
end;

procedure cInvAdd_Bool_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsString(AResult,
    BoolToLString(APars[0].vBool) + LString(APars[1].vStr));
end;

procedure cInvAdd_Int_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsString(AResult,
    Int64ToLString(APars[0].vInt) + LString(APars[1].vStr));
end;

procedure cInvAdd_Str_Bool(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsString(AResult,
    LString(APars[0].vStr) + BoolToLString(APars[1].vBool));
end;

procedure cInvAdd_Str_Int(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsString(AResult,
    LString(APars[0].vStr) + Int64ToLString(APars[1].vInt));
end;

procedure cInvAdd_Str_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsString(AResult,
    LString(APars[0].vStr) + LString(APars[1].vStr));
end;

procedure cInvAdd_Str_Print(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsString(AResult,
    LString(APars[0].vStr) + FennerData_Print(APars[1]));
end;

procedure cInvAdd_Print_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsString(AResult,
    FennerData_Print(APars[0]) + LString(APars[1].vStr));
end;

procedure cInvAdd_Array_Array(APars: PFennerData; var AResult: TFennerData);
var
  c0, c1, i, j: Integer;
  sr: Pointer;
  vr: TFennerDataDynArray;
begin
  c0 := Length(TFennerDataDynArray(APars[0].vArr));
  if (c0 = 0) then
  begin
    FennerData_SetAsArray(AResult, APars[0].vArr);
    Exit;
  end;
  c1 := Length(TFennerDataDynArray(APars[1].vArr));
  if (c1 = 0) then
  begin
    FennerData_SetAsArray(AResult, APars[1].vArr);
    Exit;
  end;
  SetLength(vr, (c0 + c1));

  j := 0;
  sr := APars[0].vArr;
  for i := 0 to (c0 - 1) do
  begin
    FennerData_Assign(vr[j], @TFennerDataDynArray(sr)[i]);
    Inc(j);
  end;
  sr := APars[1].vArr;
  for i := 0 to (c1 - 1) do
  begin
    FennerData_Assign(vr[j], @TFennerDataDynArray(sr)[i]);
    Inc(j);
  end;

  FennerData_SetAsArray(AResult, Pointer(vr));
end;

{ Operador: Eq }

procedure cInvEq_Str_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult,
    LString(APars[0].vStr) = LString(APars[1].vStr));
end;

procedure cInvEq_Func_Func(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult, APars[0].vFn = APars[1].vFn);
end;

procedure cInvEq_Array_Array(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult,
    FennerDataArray_IsEquals(TFennerDataDynArray(APars[0].vArr),
      TFennerDataDynArray(APars[1].vArr)));
end;

{ Operador: Neq }

procedure cInvNeq_Str_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult,
    LString(APars[0].vStr) <> LString(APars[1].vStr));
end;

procedure cInvNeq_Func_Func(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult, APars[0].vFn <> APars[1].vFn);
end;

procedure cInvNeq_Array_Array(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult,
    not FennerDataArray_IsEquals(
      TFennerDataDynArray(APars[0].vArr),
      TFennerDataDynArray(APars[1].vArr)));
end;

{ Operador: Lt }

procedure cInvLt_Str_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult, LString(APars[0].vStr) < LString(APars[1].vStr));
end;

{ Operador: Gt }

procedure cInvGt_Str_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult, LString(APars[0].vStr) > LString(APars[1].vStr));
end;

{ Operador: Lte }

procedure cInvLte_Str_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult, LString(APars[0].vStr) <= LString(APars[1].vStr));
end;

{ Operador: Gte }

procedure cInvGte_Str_Str(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsBool(AResult, LString(APars[0].vStr) >= LString(APars[1].vStr));
end;

{ Operador: Power }

procedure cInvPower_Int_Int(APars: PFennerData; var AResult: TFennerData);
begin
  FennerData_SetAsInteger(AResult, MyFuncs_IntPower(APars[0].vInt, APars[1].vInt));
end;

procedure cInvkOp(APars: PFennerData; var AResult: TFennerData; AOp: UInt64);
  assembler; nostackframe;
asm
    cmp rdx, 503
    ja AsmRet
    mov rcx, Offset @tab
    jmp [rcx + rdx * 8]

@inv_op_add:
    mov rdx, tkop_Add
    jmp ThrowInvalidOp2
@inv_op_sub:
    mov rdx, tkop_Sub
    jmp ThrowInvalidOp2
@inv_op_mul:
    mov rdx, tkop_Mul
    jmp ThrowInvalidOp2
@inv_op_div:
    mov rdx, tkop_Div
    jmp ThrowInvalidOp2
@inv_op_rem:
    mov rdx, tkop_Rem
    jmp ThrowInvalidOp2
@inv_op_eq:
    mov rdx, tkop_Eq
    jmp ThrowInvalidOp2
@inv_op_neq:
    mov rdx, tkop_Neq
    jmp ThrowInvalidOp2
@inv_op_lt:
    mov rdx, tkop_Lt
    jmp ThrowInvalidOp2
@inv_op_gt:
    mov rdx, tkop_Gt
    jmp ThrowInvalidOp2
@inv_op_lte:
    mov rdx, tkop_Lte
    jmp ThrowInvalidOp2
@inv_op_gte:
    mov rdx, tkop_Gte
    jmp ThrowInvalidOp2
@inv_op_and:
    mov rdx, tkop_And
    jmp ThrowInvalidOp2
@inv_op_or:
    mov rdx, tkop_Or
    jmp ThrowInvalidOp2
@inv_op_power:
    mov rdx, tkop_Power
    jmp ThrowInvalidOp2
@inv_op_fact:
    mov rdx, tkop_Fact
    jmp ThrowInvalidOp2
@ret_false:
    mov rdi, rsi
    xor rsi, rsi
    jmp FennerData_SetAsBool
@ret_true:
    mov rdi, rsi
    xor rsi, rsi
    dec rsi
    jmp FennerData_SetAsBool

@eq_bool_bool:
    mov al, [rdi + TFennerData.vBool]
    mov ah, [rdi + TFennerData.vBool + SizeOf(TFennerData)]
    cmp al, ah
    je @ret_true
    jmp @ret_false
@neq_bool_bool:
    mov al, [rdi + TFennerData.vBool]
    mov ah, [rdi + TFennerData.vBool + SizeOf(TFennerData)]
    cmp al, ah
    jne @ret_true
    jmp @ret_false
@lt_bool_bool:
    mov al, [rdi + TFennerData.vBool]
    mov ah, [rdi + TFennerData.vBool + SizeOf(TFennerData)]
    cmp al, ah
    jb @ret_true
    jmp @ret_false
@gt_bool_bool:
    mov al, [rdi + TFennerData.vBool]
    mov ah, [rdi + TFennerData.vBool + SizeOf(TFennerData)]
    cmp al, ah
    ja @ret_true
    jmp @ret_false
@lte_bool_bool:
    mov al, [rdi + TFennerData.vBool]
    mov ah, [rdi + TFennerData.vBool + SizeOf(TFennerData)]
    cmp al, ah
    jbe @ret_true
    jmp @ret_false
@gte_bool_bool:
    mov al, [rdi + TFennerData.vBool]
    mov ah, [rdi + TFennerData.vBool + SizeOf(TFennerData)]
    cmp al, ah
    jae @ret_true
    jmp @ret_false
@and_bool_bool:
    mov al, [rdi + TFennerData.vBool]
    mov ah, [rdi + TFennerData.vBool + SizeOf(TFennerData)]
    and al, ah
    jz @ret_false
    jmp @ret_true
@or_bool_bool:
    mov al, [rdi + TFennerData.vBool]
    mov ah, [rdi + TFennerData.vBool + SizeOf(TFennerData)]
    or al, ah
    jz @ret_false
    jmp @ret_true
@add_int_int:
    mov rcx, [rdi + TFennerData.vInt]
    add rcx, [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    mov rdi, rsi
    mov rsi, rcx
    jmp FennerData_SetAsInteger
@sub_int_int:
    mov rcx, [rdi + TFennerData.vInt]
    sub rcx, [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    mov rdi, rsi
    mov rsi, rcx
    jmp FennerData_SetAsInteger
@mul_int_int:
    mov rax, [rdi + TFennerData.vInt]
    imul [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    mov rdi, rsi
    mov rsi, rax
    jmp FennerData_SetAsInteger
@div_int_int:
    mov rax, [rdi + TFennerData.vInt]
    xor rdx, rdx
    idiv [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    mov rdi, rsi
    mov rsi, rax
    jmp FennerData_SetAsInteger
@rem_int_int:
    mov rax, [rdi + TFennerData.vInt]
    xor rdx, rdx
    idiv [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    mov rdi, rsi
    mov rsi, rdx
    jmp FennerData_SetAsInteger
@eq_int_int:
    mov rax, [rdi + TFennerData.vInt]
    cmp rax, [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    je @ret_true
    jmp @ret_false
@neq_int_int:
    mov rax, [rdi + TFennerData.vInt]
    cmp rax, [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    jne @ret_true
    jmp @ret_false
@lt_int_int:
    mov rax, [rdi + TFennerData.vInt]
    cmp rax, [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    jl @ret_true
    jmp @ret_false
@gt_int_int:
    mov rax, [rdi + TFennerData.vInt]
    cmp rax, [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    jg @ret_true
    jmp @ret_false
@lte_int_int:
    mov rax, [rdi + TFennerData.vInt]
    cmp rax, [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    jle @ret_true
    jmp @ret_false
@gte_int_int:
    mov rax, [rdi + TFennerData.vInt]
    cmp rax, [rdi + TFennerData.vInt + SizeOf(TFennerData)]
    jge @ret_true
    jmp @ret_false

@tab:
{ Operador: Add }
  { None -> }
    dq Offset @inv_op_add               //  000 -> None + None
    dq Offset @inv_op_add               //  001 -> None + Bool
    dq Offset @inv_op_add               //  002 -> None + Int
    dq Offset @inv_op_add               //  003 -> None + Str
    dq Offset @inv_op_add               //  004 -> None + Func
    dq Offset @inv_op_add               //  005 -> None + Array

  { Bool -> }
    dq Offset @inv_op_add               //  006 -> Bool + None
    dq Offset @inv_op_add               //  007 -> Bool + Bool
    dq Offset @inv_op_add               //  008 -> Bool + Int
    dq Offset cInvAdd_Bool_Str,         //  009 -> Bool + Str
    dq Offset @inv_op_add               //  010 -> Bool + Func
    dq Offset @inv_op_add               //  011 -> Bool + Array

  { Int -> }
    dq Offset @inv_op_add               //  012 -> Int + None
    dq Offset @inv_op_add               //  013 -> Int + Bool
    dq Offset @add_int_int              //  014 -> Int + Int
    dq Offset cInvAdd_Int_Str,          //  015 -> Int + Str
    dq Offset @inv_op_add               //  016 -> Int + Func
    dq Offset @inv_op_add               //  017 -> Int + Array

  { Str -> }
    dq Offset @inv_op_add               //  018 -> Str + None
    dq Offset cInvAdd_Str_Bool,         //  019 -> Str + Bool
    dq Offset cInvAdd_Str_Int,          //  020 -> Str + Int
    dq Offset cInvAdd_Str_Str,          //  021 -> Str + Str
    dq Offset cInvAdd_Str_Print         //  022 -> Str + Func
    dq Offset cInvAdd_Str_Print         //  023 -> Str + Array

  { Func -> }
    dq Offset @inv_op_add               //  024 -> Func + None
    dq Offset @inv_op_add               //  025 -> Func + Bool
    dq Offset @inv_op_add               //  026 -> Func + Int
    dq Offset cInvAdd_Print_Str         //  027 -> Func + Str
    dq Offset @inv_op_add               //  028 -> Func + Func
    dq Offset @inv_op_add               //  029 -> Func + Array

  { Array -> }
    dq Offset @inv_op_add               //  030 -> Array + None
    dq Offset @inv_op_add               //  031 -> Array + Bool
    dq Offset @inv_op_add               //  032 -> Array + Int
    dq Offset cInvAdd_Print_Str         //  033 -> Array + Str
    dq Offset @inv_op_add               //  034 -> Array + Func
    dq Offset cInvAdd_Array_Array       //  035 -> Array + Array

{ Operador: Sub }
  { None -> }
    dq Offset @inv_op_sub               //  036 -> None - None
    dq Offset @inv_op_sub               //  037 -> None - Bool
    dq Offset @inv_op_sub               //  038 -> None - Int
    dq Offset @inv_op_sub               //  039 -> None - Str
    dq Offset @inv_op_sub               //  040 -> None - Func
    dq Offset @inv_op_sub               //  041 -> None - Array

  { Bool -> }
    dq Offset @inv_op_sub               //  042 -> Bool - None
    dq Offset @inv_op_sub               //  043 -> Bool - Bool
    dq Offset @inv_op_sub               //  044 -> Bool - Int
    dq Offset @inv_op_sub               //  045 -> Bool - Str
    dq Offset @inv_op_sub               //  046 -> Bool - Func
    dq Offset @inv_op_sub               //  047 -> Bool - Array

  { Int -> }
    dq Offset @inv_op_sub               //  048 -> Int - None
    dq Offset @inv_op_sub               //  049 -> Int - Bool
    dq Offset @sub_int_int              //  050 -> Int - Int
    dq Offset @inv_op_sub               //  051 -> Int - Str
    dq Offset @inv_op_sub               //  052 -> Int - Func
    dq Offset @inv_op_sub               //  053 -> Int - Array

  { Str -> }
    dq Offset @inv_op_sub               //  054 -> Str - None
    dq Offset @inv_op_sub               //  055 -> Str - Bool
    dq Offset @inv_op_sub               //  056 -> Str - Int
    dq Offset @inv_op_sub               //  057 -> Str - Str
    dq Offset @inv_op_sub               //  058 -> Str - Func
    dq Offset @inv_op_sub               //  059 -> Str - Array

  { Func -> }
    dq Offset @inv_op_sub               //  060 -> Func - None
    dq Offset @inv_op_sub               //  061 -> Func - Bool
    dq Offset @inv_op_sub               //  062 -> Func - Int
    dq Offset @inv_op_sub               //  063 -> Func - Str
    dq Offset @inv_op_sub               //  064 -> Func - Func
    dq Offset @inv_op_sub               //  065 -> Func - Array

  { Array -> }
    dq Offset @inv_op_sub               //  066 -> Array - None
    dq Offset @inv_op_sub               //  067 -> Array - Bool
    dq Offset @inv_op_sub               //  068 -> Array - Int
    dq Offset @inv_op_sub               //  069 -> Array - Str
    dq Offset @inv_op_sub               //  070 -> Array - Func
    dq Offset @inv_op_sub               //  071 -> Array - Array

{ Operador: Mul }
  { None -> }
    dq Offset @inv_op_mul               //  072 -> None * None
    dq Offset @inv_op_mul               //  073 -> None * Bool
    dq Offset @inv_op_mul               //  074 -> None * Int
    dq Offset @inv_op_mul               //  075 -> None * Str
    dq Offset @inv_op_mul               //  076 -> None * Func
    dq Offset @inv_op_mul               //  077 -> None * Array

  { Bool -> }
    dq Offset @inv_op_mul               //  078 -> Bool * None
    dq Offset @inv_op_mul               //  079 -> Bool * Bool
    dq Offset @inv_op_mul               //  080 -> Bool * Int
    dq Offset @inv_op_mul               //  081 -> Bool * Str
    dq Offset @inv_op_mul               //  082 -> Bool * Func
    dq Offset @inv_op_mul               //  083 -> Bool * Array

  { Int -> }
    dq Offset @inv_op_mul               //  084 -> Int * None
    dq Offset @inv_op_mul               //  085 -> Int * Bool
    dq Offset @mul_int_int              //  086 -> Int * Int
    dq Offset @inv_op_mul               //  087 -> Int * Str
    dq Offset @inv_op_mul               //  088 -> Int * Func
    dq Offset @inv_op_mul               //  089 -> Int * Array

  { Str -> }
    dq Offset @inv_op_mul               //  090 -> Str * None
    dq Offset @inv_op_mul               //  091 -> Str * Bool
    dq Offset @inv_op_mul               //  092 -> Str * Int
    dq Offset @inv_op_mul               //  093 -> Str * Str
    dq Offset @inv_op_mul               //  094 -> Str * Func
    dq Offset @inv_op_mul               //  095 -> Str * Array

  { Func -> }
    dq Offset @inv_op_mul               //  096 -> Func * None
    dq Offset @inv_op_mul               //  097 -> Func * Bool
    dq Offset @inv_op_mul               //  098 -> Func * Int
    dq Offset @inv_op_mul               //  099 -> Func * Str
    dq Offset @inv_op_mul               //  100 -> Func * Func
    dq Offset @inv_op_mul               //  101 -> Func * Array

  { Array -> }
    dq Offset @inv_op_mul               //  102 -> Array * None
    dq Offset @inv_op_mul               //  103 -> Array * Bool
    dq Offset @inv_op_mul               //  104 -> Array * Int
    dq Offset @inv_op_mul               //  105 -> Array * Str
    dq Offset @inv_op_mul               //  106 -> Array * Func
    dq Offset @inv_op_mul               //  107 -> Array * Array

{ Operador: Div }
  { None -> }
    dq Offset @inv_op_div               //  108 -> None / None
    dq Offset @inv_op_div               //  109 -> None / Bool
    dq Offset @inv_op_div               //  110 -> None / Int
    dq Offset @inv_op_div               //  111 -> None / Str
    dq Offset @inv_op_div               //  112 -> None / Func
    dq Offset @inv_op_div               //  113 -> None / Array

  { Bool -> }
    dq Offset @inv_op_div               //  114 -> Bool / None
    dq Offset @inv_op_div               //  115 -> Bool / Bool
    dq Offset @inv_op_div               //  116 -> Bool / Int
    dq Offset @inv_op_div               //  117 -> Bool / Str
    dq Offset @inv_op_div               //  118 -> Bool / Func
    dq Offset @inv_op_div               //  119 -> Bool / Array

  { Int -> }
    dq Offset @inv_op_div               //  120 -> Int / None
    dq Offset @inv_op_div               //  121 -> Int / Bool
    dq Offset @div_int_int              //  122 -> Int / Int
    dq Offset @inv_op_div               //  123 -> Int / Str
    dq Offset @inv_op_div               //  124 -> Int / Func
    dq Offset @inv_op_div               //  125 -> Int / Array

  { Str -> }
    dq Offset @inv_op_div               //  126 -> Str / None
    dq Offset @inv_op_div               //  127 -> Str / Bool
    dq Offset @inv_op_div               //  128 -> Str / Int
    dq Offset @inv_op_div               //  129 -> Str / Str
    dq Offset @inv_op_div               //  130 -> Str / Func
    dq Offset @inv_op_div               //  131 -> Str / Array

  { Func -> }
    dq Offset @inv_op_div               //  132 -> Func / None
    dq Offset @inv_op_div               //  133 -> Func / Bool
    dq Offset @inv_op_div               //  134 -> Func / Int
    dq Offset @inv_op_div               //  135 -> Func / Str
    dq Offset @inv_op_div               //  136 -> Func / Func
    dq Offset @inv_op_div               //  137 -> Func / Array

  { Array -> }
    dq Offset @inv_op_div               //  138 -> Array / None
    dq Offset @inv_op_div               //  139 -> Array / Bool
    dq Offset @inv_op_div               //  140 -> Array / Int
    dq Offset @inv_op_div               //  141 -> Array / Str
    dq Offset @inv_op_div               //  142 -> Array / Func
    dq Offset @inv_op_div               //  143 -> Array / Array

{ Operador: Rem }

  { None -> }
    dq Offset @inv_op_rem               //  144 -> None % None
    dq Offset @inv_op_rem               //  145 -> None % Bool
    dq Offset @inv_op_rem               //  146 -> None % Int
    dq Offset @inv_op_rem               //  147 -> None % Str
    dq Offset @inv_op_rem               //  148 -> None % Func
    dq Offset @inv_op_rem               //  149 -> None % Array

  { Bool -> }
    dq Offset @inv_op_rem               //  150 -> Bool % None
    dq Offset @inv_op_rem               //  151 -> Bool % Bool
    dq Offset @inv_op_rem               //  152 -> Bool % Int
    dq Offset @inv_op_rem               //  153 -> Bool % Str
    dq Offset @inv_op_rem               //  154 -> Bool % Func
    dq Offset @inv_op_rem               //  155 -> Bool % Array

  { Int -> }
    dq Offset @inv_op_rem               //  156 -> Int % None
    dq Offset @inv_op_rem               //  157 -> Int % Bool
    dq Offset @rem_int_int              //  158 -> Int % Int
    dq Offset @inv_op_rem               //  159 -> Int % Str
    dq Offset @inv_op_rem               //  160 -> Int % Func
    dq Offset @inv_op_rem               //  161 -> Int % Array

  { Str -> }
    dq Offset @inv_op_rem               //  162 -> Str % None
    dq Offset @inv_op_rem               //  163 -> Str % Bool
    dq Offset @inv_op_rem               //  164 -> Str % Int
    dq Offset @inv_op_rem               //  165 -> Str % Str
    dq Offset @inv_op_rem               //  166 -> Str % Func
    dq Offset @inv_op_rem               //  167 -> Str % Array

  { Func -> }
    dq Offset @inv_op_rem               //  168 -> Func % None
    dq Offset @inv_op_rem               //  169 -> Func % Bool
    dq Offset @inv_op_rem               //  170 -> Func % Int
    dq Offset @inv_op_rem               //  171 -> Func % Str
    dq Offset @inv_op_rem               //  172 -> Func % Func
    dq Offset @inv_op_rem               //  173 -> Func % Array

  { Array -> }
    dq Offset @inv_op_rem               //  174 -> Array % None
    dq Offset @inv_op_rem               //  175 -> Array % Bool
    dq Offset @inv_op_rem               //  176 -> Array % Int
    dq Offset @inv_op_rem               //  177 -> Array % Str
    dq Offset @inv_op_rem               //  178 -> Array % Func
    dq Offset @inv_op_rem               //  179 -> Array % Array

{ Operador: Eq }

  { None -> }
    dq Offset @ret_true                 //  180 -> None == None
    dq Offset @ret_false                //  181 -> None == Bool
    dq Offset @ret_false                //  182 -> None == Int
    dq Offset @ret_false                //  183 -> None == Str
    dq Offset @ret_false                //  184 -> None == Func
    dq Offset @ret_false                //  185 -> None == Array

  { Bool -> }
    dq Offset @ret_false                //  186 -> Bool == None
    dq Offset @eq_bool_bool             //  187 -> Bool == Bool
    dq Offset @ret_false                //  188 -> Bool == Int
    dq Offset @ret_false                //  189 -> Bool == Str
    dq Offset @ret_false                //  190 -> Bool == Func
    dq Offset @ret_false                //  191 -> Bool == Array

  { Int -> }
    dq Offset @ret_false                //  192 -> Int == None
    dq Offset @ret_false                //  193 -> Int == Bool
    dq Offset @eq_int_int               //  194 -> Int == Int
    dq Offset @ret_false                //  195 -> Int == Str
    dq Offset @ret_false                //  196 -> Int == Func
    dq Offset @ret_false                //  197 -> Int == Array

  { Str -> }
    dq Offset @ret_false                //  198 -> Str == None
    dq Offset @ret_false                //  199 -> Str == Bool
    dq Offset @ret_false                //  200 -> Str == Int
    dq Offset cInvEq_Str_Str            //  201 -> Str == Str
    dq Offset @ret_false                //  202 -> Str == Func
    dq Offset @ret_false                //  203 -> Str == Array

  { Func -> }
    dq Offset @ret_false                //  204 -> Func == None
    dq Offset @ret_false                //  205 -> Func == Bool
    dq Offset @ret_false                //  206 -> Func == Int
    dq Offset @ret_false                //  207 -> Func == Str
    dq Offset cInvEq_Func_Func,         //  208 -> Func == Func
    dq Offset @ret_false                //  209 -> Func == Array

  { Array -> }
    dq Offset @ret_false                //  210 -> Array == None
    dq Offset @ret_false                //  211 -> Array == Bool
    dq Offset @ret_false                //  212 -> Array == Int
    dq Offset @ret_false                //  213 -> Array == Str
    dq Offset @ret_false                //  214 -> Array == Func
    dq Offset cInvEq_Array_Array,       //  215 -> Array == Array

{ Operador: Neq }

  { None -> }
    dq Offset @ret_false                //  216 -> None != None
    dq Offset @ret_true                 //  217 -> None != Bool
    dq Offset @ret_true                 //  218 -> None != Int
    dq Offset @ret_true                 //  219 -> None != Str
    dq Offset @ret_true                 //  220 -> None != Func
    dq Offset @ret_true                 //  221 -> None != Array

  { Bool -> }
    dq Offset @ret_true                 //  222 -> Bool != None
    dq Offset @neq_bool_bool            //  223 -> Bool != Bool
    dq Offset @ret_true                 //  224 -> Bool != Int
    dq Offset @ret_true                 //  225 -> Bool != Str
    dq Offset @ret_true                 //  226 -> Bool != Func
    dq Offset @ret_true                 //  227 -> Bool != Array

  { Int -> }
    dq Offset @ret_true                 //  228 -> Int != None
    dq Offset @ret_true                 //  229 -> Int != Bool
    dq Offset @neq_int_int              //  230 -> Int != Int
    dq Offset @ret_true                 //  231 -> Int != Str
    dq Offset @ret_true                 //  232 -> Int != Func
    dq Offset @ret_true                 //  233 -> Int != Array

  { Str -> }
    dq Offset @ret_true                 //  234 -> Str != None
    dq Offset @ret_true                 //  235 -> Str != Bool
    dq Offset @ret_true                 //  236 -> Str != Int
    dq Offset cInvNeq_Str_Str           //  237 -> Str != Str
    dq Offset @ret_true                 //  238 -> Str != Func
    dq Offset @ret_true                 //  239 -> Str != Array

  { Func -> }
    dq Offset @ret_true                 //  240 -> Func != None
    dq Offset @ret_true                 //  241 -> Func != Bool
    dq Offset @ret_true                 //  242 -> Func != Int
    dq Offset @ret_true                 //  243 -> Func != Str
    dq Offset cInvNeq_Func_Func         //  244 -> Func != Func
    dq Offset @ret_true                 //  245 -> Func != Array

  { Array -> }
    dq Offset @ret_true                 //  246 -> Array != None
    dq Offset @ret_true                 //  247 -> Array != Bool
    dq Offset @ret_true                 //  248 -> Array != Int
    dq Offset @ret_true                 //  249 -> Array != Str
    dq Offset @ret_true                 //  250 -> Array != Func
    dq Offset cInvNeq_Array_Array       //  251 -> Array != Array

{ Operador: Lt }
  { None -> }
    dq Offset @inv_op_lt                //  252 -> None < None
    dq Offset @inv_op_lt                //  253 -> None < Bool
    dq Offset @inv_op_lt                //  254 -> None < Int
    dq Offset @inv_op_lt                //  255 -> None < Str
    dq Offset @inv_op_lt                //  256 -> None < Func
    dq Offset @inv_op_lt                //  257 -> None < Array

  { Bool -> }
    dq Offset @inv_op_lt                //  258 -> Bool < None
    dq Offset @lt_bool_bool             //  259 -> Bool < Bool
    dq Offset @inv_op_lt                //  260 -> Bool < Int
    dq Offset @inv_op_lt                //  261 -> Bool < Str
    dq Offset @inv_op_lt                //  262 -> Bool < Func
    dq Offset @inv_op_lt                //  263 -> Bool < Array

  { Int -> }
    dq Offset @inv_op_lt                //  264 -> Int < None
    dq Offset @inv_op_lt                //  265 -> Int < Bool
    dq Offset @lt_int_int               //  266 -> Int < Int
    dq Offset @inv_op_lt                //  267 -> Int < Str
    dq Offset @inv_op_lt                //  268 -> Int < Func
    dq Offset @inv_op_lt                //  269 -> Int < Array

  { Str -> }
    dq Offset @inv_op_lt                //  270 -> Str < None
    dq Offset @inv_op_lt                //  271 -> Str < Bool
    dq Offset @inv_op_lt                //  272 -> Str < Int
    dq Offset cInvLt_Str_Str,           //  273 -> Str < Str
    dq Offset @inv_op_lt                //  274 -> Str < Func
    dq Offset @inv_op_lt                //  275 -> Str < Array

  { Func -> }
    dq Offset @inv_op_lt                //  276 -> Func < None
    dq Offset @inv_op_lt                //  277 -> Func < Bool
    dq Offset @inv_op_lt                //  278 -> Func < Int
    dq Offset @inv_op_lt                //  279 -> Func < Str
    dq Offset @inv_op_lt                //  280 -> Func < Func
    dq Offset @inv_op_lt                //  281 -> Func < Array

  { Array -> }
    dq Offset @inv_op_lt                //  282 -> Array < None
    dq Offset @inv_op_lt                //  283 -> Array < Bool
    dq Offset @inv_op_lt                //  284 -> Array < Int
    dq Offset @inv_op_lt                //  285 -> Array < Str
    dq Offset @inv_op_lt                //  286 -> Array < Func
    dq Offset @inv_op_lt                //  287 -> Array < Array

{ Operador: Gt }

  { None -> }
    dq Offset @inv_op_gt                //  288 -> None > None
    dq Offset @inv_op_gt                //  289 -> None > Bool
    dq Offset @inv_op_gt                //  290 -> None > Int
    dq Offset @inv_op_gt                //  291 -> None > Str
    dq Offset @inv_op_gt                //  292 -> None > Func
    dq Offset @inv_op_gt                //  293 -> None > Array

  { Bool -> }
    dq Offset @inv_op_gt                //  294 -> Bool > None
    dq Offset @gt_bool_bool             //  295 -> Bool > Bool
    dq Offset @inv_op_gt                //  296 -> Bool > Int
    dq Offset @inv_op_gt                //  297 -> Bool > Str
    dq Offset @inv_op_gt                //  298 -> Bool > Func
    dq Offset @inv_op_gt                //  299 -> Bool > Array

  { Int -> }
    dq Offset @inv_op_gt                //  300 -> Int > None
    dq Offset @inv_op_gt                //  301 -> Int > Bool
    dq Offset @gt_int_int               //  302 -> Int > Int
    dq Offset @inv_op_gt                //  303 -> Int > Str
    dq Offset @inv_op_gt                //  304 -> Int > Func
    dq Offset @inv_op_gt                //  305 -> Int > Array

  { Str -> }
    dq Offset @inv_op_gt                //  306 -> Str > None
    dq Offset @inv_op_gt                //  307 -> Str > Bool
    dq Offset @inv_op_gt                //  308 -> Str > Int
    dq Offset cInvGt_Str_Str            //  309 -> Str > Str
    dq Offset @inv_op_gt                //  310 -> Str > Func
    dq Offset @inv_op_gt                //  311 -> Str > Array

  { Func -> }
    dq Offset @inv_op_gt                //  312 -> Func > None
    dq Offset @inv_op_gt                //  313 -> Func > Bool
    dq Offset @inv_op_gt                //  314 -> Func > Int
    dq Offset @inv_op_gt                //  315 -> Func > Str
    dq Offset @inv_op_gt                //  316 -> Func > Func
    dq Offset @inv_op_gt                //  317 -> Func > Array

  { Array -> }
    dq Offset @inv_op_gt                //  318 -> Array > None
    dq Offset @inv_op_gt                //  319 -> Array > Bool
    dq Offset @inv_op_gt                //  320 -> Array > Int
    dq Offset @inv_op_gt                //  321 -> Array > Str
    dq Offset @inv_op_gt                //  322 -> Array > Func
    dq Offset @inv_op_gt                //  323 -> Array > Array

{ Operador: Lte }

  { None -> }
    dq Offset @inv_op_lte               //  324 -> None <= None
    dq Offset @inv_op_lte               //  325 -> None <= Bool
    dq Offset @inv_op_lte               //  326 -> None <= Int
    dq Offset @inv_op_lte               //  327 -> None <= Str
    dq Offset @inv_op_lte               //  328 -> None <= Func
    dq Offset @inv_op_lte               //  329 -> None <= Array

  { Bool -> }
    dq Offset @inv_op_lte               //  330 -> Bool <= None
    dq Offset @lte_bool_bool            //  331 -> Bool <= Bool
    dq Offset @inv_op_lte               //  332 -> Bool <= Int
    dq Offset @inv_op_lte               //  333 -> Bool <= Str
    dq Offset @inv_op_lte               //  334 -> Bool <= Func
    dq Offset @inv_op_lte               //  335 -> Bool <= Array

  { Int -> }
    dq Offset @inv_op_lte               //  336 -> Int <= None
    dq Offset @inv_op_lte               //  337 -> Int <= Bool
    dq Offset @lte_int_int              //  338 -> Int <= Int
    dq Offset @inv_op_lte               //  339 -> Int <= Str
    dq Offset @inv_op_lte               //  340 -> Int <= Func
    dq Offset @inv_op_lte               //  341 -> Int <= Array

  { Str -> }
    dq Offset @inv_op_lte               //  342 -> Str <= None
    dq Offset @inv_op_lte               //  343 -> Str <= Bool
    dq Offset @inv_op_lte               //  344 -> Str <= Int
    dq Offset cInvLte_Str_Str,          //  345 -> Str <= Str
    dq Offset @inv_op_lte               //  346 -> Str <= Func
    dq Offset @inv_op_lte               //  347 -> Str <= Array

  { Func -> }
    dq Offset @inv_op_lte               //  348 -> Func <= None
    dq Offset @inv_op_lte               //  349 -> Func <= Bool
    dq Offset @inv_op_lte               //  350 -> Func <= Int
    dq Offset @inv_op_lte               //  351 -> Func <= Str
    dq Offset @inv_op_lte               //  352 -> Func <= Func
    dq Offset @inv_op_lte               //  353 -> Func <= Array

  { Array -> }
    dq Offset @inv_op_lte               //  354 -> Array <= None
    dq Offset @inv_op_lte               //  355 -> Array <= Bool
    dq Offset @inv_op_lte               //  356 -> Array <= Int
    dq Offset @inv_op_lte               //  357 -> Array <= Str
    dq Offset @inv_op_lte               //  358 -> Array <= Func
    dq Offset @inv_op_lte               //  359 -> Array <= Array

{ Operador: Gte }

  { None -> }
    dq Offset @inv_op_gte               //  360 -> None >= None
    dq Offset @inv_op_gte               //  361 -> None >= Bool
    dq Offset @inv_op_gte               //  362 -> None >= Int
    dq Offset @inv_op_gte               //  363 -> None >= Str
    dq Offset @inv_op_gte               //  364 -> None >= Func
    dq Offset @inv_op_gte               //  365 -> None >= Array

  { Bool -> }
    dq Offset @inv_op_gte               //  366 -> Bool >= None
    dq Offset @gte_bool_bool            //  367 -> Bool >= Bool
    dq Offset @inv_op_gte               //  368 -> Bool >= Int
    dq Offset @inv_op_gte               //  369 -> Bool >= Str
    dq Offset @inv_op_gte               //  370 -> Bool >= Func
    dq Offset @inv_op_gte               //  371 -> Bool >= Array

  { Int -> }
    dq Offset @inv_op_gte               //  372 -> Int >= None
    dq Offset @inv_op_gte               //  373 -> Int >= Bool
    dq Offset @gte_int_int              //  374 -> Int >= Int
    dq Offset @inv_op_gte               //  375 -> Int >= Str
    dq Offset @inv_op_gte               //  376 -> Int >= Func
    dq Offset @inv_op_gte               //  377 -> Int >= Array

  { Str -> }
    dq Offset @inv_op_gte               //  378 -> Str >= None
    dq Offset @inv_op_gte               //  379 -> Str >= Bool
    dq Offset @inv_op_gte               //  380 -> Str >= Int
    dq Offset cInvGte_Str_Str           //  381 -> Str >= Str
    dq Offset @inv_op_gte               //  382 -> Str >= Func
    dq Offset @inv_op_gte               //  383 -> Str >= Array

  { Func -> }
    dq Offset @inv_op_gte               //  384 -> Func >= None
    dq Offset @inv_op_gte               //  385 -> Func >= Bool
    dq Offset @inv_op_gte               //  386 -> Func >= Int
    dq Offset @inv_op_gte               //  387 -> Func >= Str
    dq Offset @inv_op_gte               //  388 -> Func >= Func
    dq Offset @inv_op_gte               //  389 -> Func >= Array

  { Array -> }
    dq Offset @inv_op_gte               //  390 -> Array >= None
    dq Offset @inv_op_gte               //  391 -> Array >= Bool
    dq Offset @inv_op_gte               //  392 -> Array >= Int
    dq Offset @inv_op_gte               //  393 -> Array >= Str
    dq Offset @inv_op_gte               //  394 -> Array >= Func
    dq Offset @inv_op_gte               //  395 -> Array >= Array

{ Operador: And }

  { None -> }
    dq Offset @inv_op_and               //  396 -> None && None
    dq Offset @inv_op_and               //  397 -> None && Bool
    dq Offset @inv_op_and               //  398 -> None && Int
    dq Offset @inv_op_and               //  399 -> None && Str
    dq Offset @inv_op_and               //  400 -> None && Func
    dq Offset @inv_op_and               //  401 -> None && Array

  { Bool -> }
    dq Offset @inv_op_and               //  402 -> Bool && None
    dq Offset @and_bool_bool            //  403 -> Bool && Bool
    dq Offset @inv_op_and               //  404 -> Bool && Int
    dq Offset @inv_op_and               //  405 -> Bool && Str
    dq Offset @inv_op_and               //  406 -> Bool && Func
    dq Offset @inv_op_and               //  407 -> Bool && Array

  { Int -> }
    dq Offset @inv_op_and               //  408 -> Int && None
    dq Offset @inv_op_and               //  409 -> Int && Bool
    dq Offset @inv_op_and               //  410 -> Int && Int
    dq Offset @inv_op_and               //  411 -> Int && Str
    dq Offset @inv_op_and               //  412 -> Int && Func
    dq Offset @inv_op_and               //  413 -> Int && Array

  { Str -> }
    dq Offset @inv_op_and               //  414 -> Str && None
    dq Offset @inv_op_and               //  415 -> Str && Bool
    dq Offset @inv_op_and               //  416 -> Str && Int
    dq Offset @inv_op_and               //  417 -> Str && Str
    dq Offset @inv_op_and               //  418 -> Str && Func
    dq Offset @inv_op_and               //  419 -> Str && Array

  { Func -> }
    dq Offset @inv_op_and               //  420 -> Func && None
    dq Offset @inv_op_and               //  421 -> Func && Bool
    dq Offset @inv_op_and               //  422 -> Func && Int
    dq Offset @inv_op_and               //  423 -> Func && Str
    dq Offset @inv_op_and               //  424 -> Func && Func
    dq Offset @inv_op_and               //  425 -> Func && Array

  { Array -> }
    dq Offset @inv_op_and               //  426 -> Array && None
    dq Offset @inv_op_and               //  427 -> Array && Bool
    dq Offset @inv_op_and               //  428 -> Array && Int
    dq Offset @inv_op_and               //  429 -> Array && Str
    dq Offset @inv_op_and               //  430 -> Array && Func
    dq Offset @inv_op_and               //  431 -> Array && Array

{ Operador: Or }

  { None -> }
    dq Offset @inv_op_or                //  432 -> None || None
    dq Offset @inv_op_or                //  433 -> None || Bool
    dq Offset @inv_op_or                //  434 -> None || Int
    dq Offset @inv_op_or                //  435 -> None || Str
    dq Offset @inv_op_or                //  436 -> None || Func
    dq Offset @inv_op_or                //  437 -> None || Array

  { Bool -> }
    dq Offset @inv_op_or                //  438 -> Bool || None
    dq Offset @or_bool_bool             //  439 -> Bool || Bool
    dq Offset @inv_op_or                //  440 -> Bool || Int
    dq Offset @inv_op_or                //  441 -> Bool || Str
    dq Offset @inv_op_or                //  442 -> Bool || Func
    dq Offset @inv_op_or                //  443 -> Bool || Array

  { Int -> }
    dq Offset @inv_op_or                //  444 -> Int || None
    dq Offset @inv_op_or                //  445 -> Int || Bool
    dq Offset @inv_op_or                //  446 -> Int || Int
    dq Offset @inv_op_or                //  447 -> Int || Str
    dq Offset @inv_op_or                //  448 -> Int || Func
    dq Offset @inv_op_or                //  449 -> Int || Array

  { Str -> }
    dq Offset @inv_op_or                //  450 -> Str || None
    dq Offset @inv_op_or                //  451 -> Str || Bool
    dq Offset @inv_op_or                //  452 -> Str || Int
    dq Offset @inv_op_or                //  453 -> Str || Str
    dq Offset @inv_op_or                //  454 -> Str || Func
    dq Offset @inv_op_or                //  455 -> Str || Array

  { Func -> }
    dq Offset @inv_op_or                //  456 -> Func || None
    dq Offset @inv_op_or                //  457 -> Func || Bool
    dq Offset @inv_op_or                //  458 -> Func || Int
    dq Offset @inv_op_or                //  459 -> Func || Str
    dq Offset @inv_op_or                //  460 -> Func || Func
    dq Offset @inv_op_or                //  461 -> Func || Array

  { Array -> }
    dq Offset @inv_op_or                //  462 -> Array || None
    dq Offset @inv_op_or                //  463 -> Array || Bool
    dq Offset @inv_op_or                //  464 -> Array || Int
    dq Offset @inv_op_or                //  465 -> Array || Str
    dq Offset @inv_op_or                //  466 -> Array || Func
    dq Offset @inv_op_or                //  467 -> Array || Array

{ Operador: Power }

  { None -> }
    dq Offset @inv_op_power             //  468 -> None ** None
    dq Offset @inv_op_power             //  469 -> None ** Bool
    dq Offset @inv_op_power             //  470 -> None ** Int
    dq Offset @inv_op_power             //  471 -> None ** Str
    dq Offset @inv_op_power             //  472 -> None ** Func
    dq Offset @inv_op_power             //  473 -> None ** Array

  { Bool -> }
    dq Offset @inv_op_power             //  474 -> Bool ** None
    dq Offset @inv_op_power             //  475 -> Bool ** Bool
    dq Offset @inv_op_power             //  476 -> Bool ** Int
    dq Offset @inv_op_power             //  477 -> Bool ** Str
    dq Offset @inv_op_power             //  478 -> Bool ** Func
    dq Offset @inv_op_power             //  479 -> Bool ** Array

  { Int -> }
    dq Offset @inv_op_power             //  480 -> Int ** None
    dq Offset @inv_op_power             //  481 -> Int ** Bool
    dq Offset cInvPower_Int_Int,        //  482 -> Int ** Int
    dq Offset @inv_op_power             //  483 -> Int ** Str
    dq Offset @inv_op_power             //  484 -> Int ** Func
    dq Offset @inv_op_power             //  485 -> Int ** Array

  { Str -> }
    dq Offset @inv_op_power             //  486 -> Str ** None
    dq Offset @inv_op_power             //  487 -> Str ** Bool
    dq Offset @inv_op_power             //  488 -> Str ** Int
    dq Offset @inv_op_power             //  489 -> Str ** Str
    dq Offset @inv_op_power             //  490 -> Str ** Func
    dq Offset @inv_op_power             //  491 -> Str ** Array

  { Func -> }
    dq Offset @inv_op_power             //  492 -> Func ** None
    dq Offset @inv_op_power             //  493 -> Func ** Bool
    dq Offset @inv_op_power             //  494 -> Func ** Int
    dq Offset @inv_op_power             //  495 -> Func ** Str
    dq Offset @inv_op_power             //  496 -> Func ** Func
    dq Offset @inv_op_power             //  497 -> Func ** Array

  { Array -> }
    dq Offset @inv_op_power             //  498 -> Array ** None
    dq Offset @inv_op_power             //  499 -> Array ** Bool
    dq Offset @inv_op_power             //  500 -> Array ** Int
    dq Offset @inv_op_power             //  501 -> Array ** Str
    dq Offset @inv_op_power             //  502 -> Array ** Func
    dq Offset @inv_op_power             //  503 -> Array ** Array
end;

end.

