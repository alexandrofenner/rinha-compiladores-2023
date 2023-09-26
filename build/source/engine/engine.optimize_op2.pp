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
unit engine.optimize_op2;

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
  engine.types,
  engine.consts;

{ EngineContextValueOp2_TryCreate_Optimized ->
     Tenta resolver a expressão invés de criar o Op2
     Pq a expressão resolvida executa + rapido no runner }

function EngineContextValueOp2_TryCreate_Optimized(
  const ALeft, ARight: PEngineContextValue;
  const AOp: Byte): PEngineContextValue; assembler;

implementation

uses
  data.types,
  scanner.types,
  sys.procs,
  sys.funcs,
  sys.utils,
  engine.procs,
  engine.contextvalues;

function _AsmRet_ecvcb_False: PEngineContextValueConstBool;
  assembler; nostackframe;
asm
    mov rax, Offset c_EngCtxValueConstFalse
end;

function _AsmRet_ecvcb_True: PEngineContextValueConstBool;
  assembler; nostackframe;
asm
    mov rax, Offset c_EngCtxValueConstTrue
end;

function tc_bool_bool_eq(const l, r: PEngineContextValueConstBool):
  PEngineContextValueConstBool; assembler; nostackframe;
asm
    mov cl, [rdi.TEngineContextValueConstBool.FConstValue]
    mov dh, [rsi.TEngineContextValueConstBool.FConstValue]
    cmp cl, ch
    je  _AsmRet_ecvcb_True
    jmp _AsmRet_ecvcb_False
end;

function tc_bool_bool_neq(const l, r: PEngineContextValueConstBool):
  PEngineContextValueConstBool; assembler; nostackframe;
asm
    mov cl, [rdi.TEngineContextValueConstBool.FConstValue]
    mov dh, [rsi.TEngineContextValueConstBool.FConstValue]
    cmp cl, ch
    je  _AsmRet_ecvcb_False
    jmp _AsmRet_ecvcb_True
end;

function tc_bool_bool_lt(const l, r: PEngineContextValueConstBool):
  PEngineContextValueConstBool; assembler; nostackframe;
asm
    mov cl, [rdi.TEngineContextValueConstBool.FConstValue]
    mov dh, [rsi.TEngineContextValueConstBool.FConstValue]
    cmp cl, ch
    jl  _AsmRet_ecvcb_True
    jmp _AsmRet_ecvcb_False
end;

function tc_bool_bool_gt(const l, r: PEngineContextValueConstBool):
  PEngineContextValueConstBool; assembler; nostackframe;
asm
    mov cl, [rdi.TEngineContextValueConstBool.FConstValue]
    mov dh, [rsi.TEngineContextValueConstBool.FConstValue]
    cmp cl, ch
    jg  _AsmRet_ecvcb_True
    jmp _AsmRet_ecvcb_False
end;

function tc_bool_bool_lte(const l, r: PEngineContextValueConstBool):
  PEngineContextValueConstBool; assembler; nostackframe;
asm
    mov cl, [rdi.TEngineContextValueConstBool.FConstValue]
    mov dh, [rsi.TEngineContextValueConstBool.FConstValue]
    cmp cl, ch
    jle _AsmRet_ecvcb_True
    jmp _AsmRet_ecvcb_False
end;

function tc_bool_bool_gte(const l, r: PEngineContextValueConstBool):
  PEngineContextValueConstBool; assembler; nostackframe;
asm
    mov cl, [rdi.TEngineContextValueConstBool.FConstValue]
    mov dh, [rsi.TEngineContextValueConstBool.FConstValue]
    cmp cl, ch
    jge _AsmRet_ecvcb_True
    jmp _AsmRet_ecvcb_False
end;

function tc_bool_bool_and(const l, r: PEngineContextValueConstBool):
  PEngineContextValueConstBool; assembler; nostackframe;
asm
    mov cl, [rdi.TEngineContextValueConstBool.FConstValue]
    mov dh, [rsi.TEngineContextValueConstBool.FConstValue]
    and cl, dh
    jnz _AsmRet_ecvcb_True
    jmp _AsmRet_ecvcb_False
end;

function tc_bool_bool_or(const l, r: PEngineContextValueConstBool):
  PEngineContextValueConstBool; assembler; nostackframe;
asm
    mov cl, [rdi.TEngineContextValueConstBool.FConstValue]
    mov dh, [rsi.TEngineContextValueConstBool.FConstValue]
    or  cl, dh
    jnz _AsmRet_ecvcb_True
    jmp _AsmRet_ecvcb_False
end;

function tc_int_int_add(const l, r: PEngineContextValueConstInt):
  PEngineContextValueConstInt; assembler; nostackframe;
asm
    mov  rdi, [rdi + TEngineContextValueConstInt.FConstValue]
    add  rdi, [rsi + TEngineContextValueConstInt.FConstValue]
    jmp  EngineContextValueConstInt_Create
end;

function tc_int_int_sub(const l, r: PEngineContextValueConstInt):
  PEngineContextValueConstInt; assembler; nostackframe;
asm
    mov  rdi, [rdi + TEngineContextValueConstInt.FConstValue]
    sub  rdi, [rsi + TEngineContextValueConstInt.FConstValue]
    jmp  EngineContextValueConstInt_Create
end;

function tc_int_int_mul(const l, r: PEngineContextValueConstInt):
  PEngineContextValueConstInt; assembler; nostackframe;
asm
    mov  rax, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    imul rsi
    mov  rdi, rax
    jmp  EngineContextValueConstInt_Create
end;

function tc_int_int_div(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstInt;
  assembler; nostackframe;
asm
    mov  rax, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    xor  rdx, rdx
    idiv rsi
    mov  rdi, rax
    jmp  EngineContextValueConstInt_Create
end;

function tc_int_int_mod(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstInt;
  assembler; nostackframe;
asm
    mov  rax, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    xor  rdx, rdx
    idiv rsi
    mov  rdi, rdx
    jmp  EngineContextValueConstInt_Create
end;

function tc_int_int_Eq(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstBool;
  assembler; nostackframe;
asm
    mov  rdi, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    cmp  rdi, rsi
    je   _AsmRet_ecvcb_True
    jmp  _AsmRet_ecvcb_False
end;

function tc_int_int_NEq(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstBool;
  assembler; nostackframe;
asm
    mov  rdi, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    cmp  rdi, rsi
    je   _AsmRet_ecvcb_False
    jmp  _AsmRet_ecvcb_True
end;

function tc_int_int_Lt(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstBool;
  assembler; nostackframe;
asm
    mov  rdi, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    cmp  rdi, rsi
    jl   _AsmRet_ecvcb_True
    jmp  _AsmRet_ecvcb_False
end;

function tc_int_int_Gt(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstBool;
  assembler; nostackframe;
asm
    mov  rdi, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    cmp  rdi, rsi
    jg   _AsmRet_ecvcb_True
    jmp  _AsmRet_ecvcb_False
end;

function tc_int_int_Lte(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstBool;
  assembler; nostackframe;
asm
    mov  rdi, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    cmp  rdi, rsi
    jle  _AsmRet_ecvcb_True
    jmp  _AsmRet_ecvcb_False
end;

function tc_int_int_Gte(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstBool;
  assembler; nostackframe;
asm
    mov  rdi, [rdi + TEngineContextValueConstInt.FConstValue]
    mov  rsi, [rsi + TEngineContextValueConstInt.FConstValue]
    cmp  rdi, rsi
    jge  _AsmRet_ecvcb_True
    jmp  _AsmRet_ecvcb_False
end;

function tc_int_int_Power(
  const l, r: PEngineContextValueConstInt): PEngineContextValueConstInt;
begin
  Exit(EngineContextValueConstInt_Create(
    MyFuncs_IntPower(l.FConstValue, r.FConstValue)));
end;

function tc_int_str_Add(const l: PEngineContextValueConstInt;
  const r: PEngineContextValueConstString): PEngineContextValueConstString;
begin
  Exit(EngineContextValueConstStr_Create(
    Int64ToLString(l.FConstValue) + r.FConstValue));
end;

function tc_str_bool_Add(const l: PEngineContextValueConstString;
  const r: PEngineContextValueConstBool): PEngineContextValueConstString;
begin
  Exit(EngineContextValueConstStr_Create(l.FConstValue +
    BoolToLString(r.FConstValue)));
end;

function tc_str_int_Add(const l: PEngineContextValueConstString;
  const r: PEngineContextValueConstInt): PEngineContextValueConstString;
begin
  Exit(EngineContextValueConstStr_Create(l.FConstValue +
    Int64ToLString(r.FConstValue)));
end;

function tc_str_str_Add(const l, r: PEngineContextValueConstString):
    PEngineContextValueConstString;
begin
  Exit(EngineContextValueConstStr_Create(l.FConstValue + r.FConstValue));
end;

function tc_str_str_Eq(const l, r: PEngineContextValueConstString):
    PEngineContextValueConstBool;
begin
  Exit(EngineContextValueConstBool_Create(l.FConstValue = r.FConstValue));
end;

function tc_str_str_NEq(const l, r: PEngineContextValueConstString):
    PEngineContextValueConstBool;
begin
  Exit(EngineContextValueConstBool_Create(l.FConstValue <> r.FConstValue));
end;

function tc_str_str_Lt(const l, r: PEngineContextValueConstString):
    PEngineContextValueConstBool;
begin
  Exit(EngineContextValueConstBool_Create(l.FConstValue < r.FConstValue));
end;

function tc_str_str_Gt(const l, r: PEngineContextValueConstString):
    PEngineContextValueConstBool;
begin
  Exit(EngineContextValueConstBool_Create(l.FConstValue > r.FConstValue));
end;

function tc_str_str_Lte(const l, r: PEngineContextValueConstString):
    PEngineContextValueConstBool;
begin
  Exit(EngineContextValueConstBool_Create(l.FConstValue <= r.FConstValue));
end;

function tc_str_str_Gte(const l, r: PEngineContextValueConstString):
  PEngineContextValueConstBool;
begin
  Exit(EngineContextValueConstBool_Create(l.FConstValue >= r.FConstValue));
end;

function EngineContextValueOp2_TryCreate_Optimized(
  const ALeft, ARight: PEngineContextValue;
  const AOp: Byte): PEngineContextValue; assembler; nostackframe;
asm
    xor rax, rax

    sub dl, 4
    cmp dl, 13
    ja  AsmRet_0

    mov cl, [rdi + TEngineContextValue.FTypeId]
    dec cl
    cmp cl, 2
    ja  AsmRet_0
    mov ch, [rsi + TEngineContextValue.FTypeId]
    dec ch
    cmp ch, 2
    ja  AsmRet_0

    mov al, 3
    imul cl
    add al, ch

    mov cl, 14
    imul cl
    add al, dl

    mov rcx, Offset @a
    mov rcx, [rcx + rax * 8]
    jmp rcx

@a:
    dq AsmRet_0                   //   0 -> bool + bool
    dq AsmRet_0                   //   1 -> bool - bool
    dq AsmRet_0                   //   2 -> bool * bool
    dq AsmRet_0                   //   3 -> bool / bool
    dq AsmRet_0                   //   4 -> bool % bool
    dq tc_bool_bool_Eq            //   5 -> bool == bool
    dq tc_bool_bool_NEq           //   6 -> bool != bool
    dq tc_bool_bool_Lt            //   7 -> bool < bool
    dq tc_bool_bool_Gt            //   8 -> bool > bool
    dq tc_bool_bool_Lte           //   9 -> bool <= bool
    dq tc_bool_bool_Gte           //  10 -> bool >= bool
    dq tc_bool_bool_And           //  11 -> bool && bool
    dq tc_bool_bool_Or            //  12 -> bool || bool
    dq AsmRet_0                   //  13 -> bool ** bool

    dq AsmRet_0                   //  14 -> bool + int
    dq AsmRet_0                   //  15 -> bool - int
    dq AsmRet_0                   //  16 -> bool * int
    dq AsmRet_0                   //  17 -> bool / int
    dq AsmRet_0                   //  18 -> bool % int
    dq AsmRet_0                   //  19 -> bool == int
    dq AsmRet_0                   //  20 -> bool != int
    dq AsmRet_0                   //  21 -> bool < int
    dq AsmRet_0                   //  22 -> bool > int
    dq AsmRet_0                   //  23 -> bool <= int
    dq AsmRet_0                   //  24 -> bool >= int
    dq AsmRet_0                   //  25 -> bool && int
    dq AsmRet_0                   //  26 -> bool || int
    dq AsmRet_0                   //  27 -> bool ** int

    dq AsmRet_0                   //  28 -> bool + str
    dq AsmRet_0                   //  29 -> bool - str
    dq AsmRet_0                   //  30 -> bool * str
    dq AsmRet_0                   //  31 -> bool / str
    dq AsmRet_0                   //  32 -> bool % str
    dq AsmRet_0                   //  33 -> bool == str
    dq AsmRet_0                   //  34 -> bool != str
    dq AsmRet_0                   //  35 -> bool < str
    dq AsmRet_0                   //  36 -> bool > str
    dq AsmRet_0                   //  37 -> bool <= str
    dq AsmRet_0                   //  38 -> bool >= str
    dq AsmRet_0                   //  39 -> bool && str
    dq AsmRet_0                   //  40 -> bool || str
    dq AsmRet_0                   //  41 -> bool ** str

    dq AsmRet_0                   //  42 -> int + bool
    dq AsmRet_0                   //  43 -> int - bool
    dq AsmRet_0                   //  44 -> int * bool
    dq AsmRet_0                   //  45 -> int / bool
    dq AsmRet_0                   //  46 -> int % bool
    dq AsmRet_0                   //  47 -> int == bool
    dq AsmRet_0                   //  48 -> int != bool
    dq AsmRet_0                   //  49 -> int < bool
    dq AsmRet_0                   //  50 -> int > bool
    dq AsmRet_0                   //  51 -> int <= bool
    dq AsmRet_0                   //  52 -> int >= bool
    dq AsmRet_0                   //  53 -> int && bool
    dq AsmRet_0                   //  54 -> int || bool
    dq AsmRet_0                   //  55 -> int ** bool

    dq tc_int_int_Add             //  56 -> int + int
    dq tc_int_int_Sub             //  57 -> int - int
    dq tc_int_int_Mul             //  58 -> int * int
    dq tc_int_int_Div             //  59 -> int / int
    dq tc_int_int_Mod             //  60 -> int % int
    dq tc_int_int_Eq              //  61 -> int == int
    dq tc_int_int_NEq             //  62 -> int != int
    dq tc_int_int_Lt              //  63 -> int < int
    dq tc_int_int_Gt              //  64 -> int > int
    dq tc_int_int_Lte             //  65 -> int <= int
    dq tc_int_int_Gte             //  66 -> int >= int
    dq AsmRet_0                   //  67 -> int && int
    dq AsmRet_0                   //  68 -> int || int
    dq tc_int_int_Power           //  69 -> int ** int

    dq tc_int_str_Add             //  70 -> int + str
    dq AsmRet_0                   //  71 -> int - str
    dq AsmRet_0                   //  72 -> int * str
    dq AsmRet_0                   //  73 -> int / str
    dq AsmRet_0                   //  74 -> int % str
    dq AsmRet_0                   //  75 -> int == str
    dq AsmRet_0                   //  76 -> int != str
    dq AsmRet_0                   //  77 -> int < str
    dq AsmRet_0                   //  78 -> int > str
    dq AsmRet_0                   //  79 -> int <= str
    dq AsmRet_0                   //  80 -> int >= str
    dq AsmRet_0                   //  81 -> int && str
    dq AsmRet_0                   //  82 -> int || str
    dq AsmRet_0                   //  83 -> int ** str

    dq tc_str_bool_Add            //  84 -> str + bool
    dq AsmRet_0                   //  85 -> str - bool
    dq AsmRet_0                   //  86 -> str * bool
    dq AsmRet_0                   //  87 -> str / bool
    dq AsmRet_0                   //  88 -> str % bool
    dq AsmRet_0                   //  89 -> str == bool
    dq AsmRet_0                   //  90 -> str != bool
    dq AsmRet_0                   //  91 -> str < bool
    dq AsmRet_0                   //  92 -> str > bool
    dq AsmRet_0                   //  93 -> str <= bool
    dq AsmRet_0                   //  94 -> str >= bool
    dq AsmRet_0                   //  95 -> str && bool
    dq AsmRet_0                   //  96 -> str || bool
    dq AsmRet_0                   //  97 -> str ** bool

    dq tc_str_int_Add             //  98 -> str + int
    dq AsmRet_0                   //  99 -> str - int
    dq AsmRet_0                   // 100 -> str * int
    dq AsmRet_0                   // 101 -> str / int
    dq AsmRet_0                   // 102 -> str % int
    dq AsmRet_0                   // 103 -> str == int
    dq AsmRet_0                   // 104 -> str != int
    dq AsmRet_0                   // 105 -> str < int
    dq AsmRet_0                   // 106 -> str > int
    dq AsmRet_0                   // 107 -> str <= int
    dq AsmRet_0                   // 108 -> str >= int
    dq AsmRet_0                   // 109 -> str && int
    dq AsmRet_0                   // 110 -> str || int
    dq AsmRet_0                   // 111 -> str ** int

    dq tc_str_str_Add             // 112 -> str + str
    dq AsmRet_0                   // 113 -> str - str
    dq AsmRet_0                   // 114 -> str * str
    dq AsmRet_0                   // 115 -> str / str
    dq AsmRet_0                   // 116 -> str % str
    dq tc_str_str_Eq              // 117 -> str == str
    dq tc_str_str_NEq             // 118 -> str != str
    dq tc_str_str_Lt              // 119 -> str < str
    dq tc_str_str_Gt              // 120 -> str > str
    dq tc_str_str_Lte             // 121 -> str <= str
    dq tc_str_str_Gte             // 122 -> str >= str
    dq AsmRet_0                   // 123 -> str && str
    dq AsmRet_0                   // 124 -> str || str
    dq AsmRet_0                   // 125 -> str ** str
end;

end.

