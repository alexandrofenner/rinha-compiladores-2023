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
unit data.procs;

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
  sys.types,
  sys.procs;

function FennerData_Print(var v: TFennerData): LString; assembler;

function FennerData_TryAsInt(var v: TFennerData; var r: Int64): Boolean; assembler;
function FennerData_AsIntDefZero(var v: TFennerData): Int64;

procedure FennerDataDynArray_Clear(var p: TFennerDataDynArray);

function FennerData_SetId(var v: TFennerData; Id: Byte): Boolean; assembler;
procedure FennerData_Clear(var v: TFennerData); assembler;

procedure FennerData_InitializeArray(var v: TFennerData; ACount: Integer);

procedure FennerData_Assign(var d: TFennerData; const s: PFennerData);
  assembler;

procedure FennerData_SetAsBool(var v: TFennerData;
  const AValue: Boolean); assembler;
procedure FennerData_SetAsInteger(var v: TFennerData;
  const AValue: Int64); assembler;
procedure FennerData_SetAsString(var v: TFennerData;
  const AValue: LString); assembler;

procedure FennerData_SetAsFunction(var v: TFennerData; Id2: Byte;
  const AFunction: Pointer); assembler;
procedure FennerData_SetAsFunctionBy(var v: TFennerData;
  const s: PFennerData);

procedure FennerData_SetAsArray(var v: TFennerData; s: Pointer);

procedure FennerData_ClearArray(var v: TFennerData; c: NativeInt); assembler;

implementation

uses
  sys.utils,
  engine.procs;

procedure FennerData_StrClear(var v: TFennerData);
  assembler; nostackframe;
asm
    lea rdi, [rdi + TFennerData.vStr]
    jmp LStrRefClr
end;

procedure FennerData_FnClear(var v: TFennerData);
  assembler; nostackframe;
asm
    mov al, [rdi + TFennerData.vId2]
    cmp al, Id2_Func_Ref
    jne @sm

    push rdi
    mov rdi, [rdi + TFennerData.vFn]
    cmp rdi, 0
    je @a
    call EngineContextFunctionRef_DecRef
@a:
    pop rdi

@sm:
    xor rax, rax
    mov [rdi + TFennerData.vId2], al
    mov [rdi + TFennerData.vFn], rax
end;

procedure FennerData_ArrClear(var v: TFennerData);
  assembler; nostackframe;
asm
    lea rdi, [rdi + TFennerData.vArr]
    jmp FennerDataDynArray_Clear
end;

procedure FennerData_PtrClear(var v: TFennerData);
  assembler; nostackframe;
asm

end;

procedure FennerData_Print_None(var r: LString; var v: TFennerData);
begin
  r := '<#undefined>';
end;

procedure FennerData_Print_Bool(var r: LString; var v: TFennerData);
begin
  if v.vBool then
    r := s_True
  else
    r := s_False;
end;

procedure FennerData_Print_Int(var r: LString; var v: TFennerData);
begin
  r := Int64ToLString(v.vInt);
end;

procedure FennerData_Print_Str(var r: LString; var v: TFennerData);
begin
  r := LString(v.VStr);
end;

procedure FennerData_Print_Func(var r: LString; var v: TFennerData);
begin
  r := '<#closure>';
end;

procedure FennerData_Print_Array(var r: LString; var v: TFennerData);
var
  i, c: Integer;
  t: LString;
begin
  c := Length(TFennerDataDynArray(v.vArr));
  if (c <= 0) then
  begin
    r := '()';
    Exit;
  end;
  t := '(' + FennerData_Print(TFennerDataDynArray(v.vArr)[0]);
  for i := 1 to (c - 1) do
    t := t + ',' + FennerData_Print(TFennerDataDynArray(v.vArr)[i]);
  r := t + ')';
end;

function FennerData_Print(var v: TFennerData): LString; assembler; nostackframe;
asm
    xor rax, rax
    mov al, [rsi + TFennerData.vId]
    cmp al, 6
    ja  FennerData_Print_None
    mov rcx, Offset @a
    mov rcx, [rcx + rax * 8]
    jmp rcx
@a:
    dq Offset FennerData_Print_None   // None
    dq Offset FennerData_Print_Bool   // Boolean
    dq Offset FennerData_Print_Int    // Integer
    dq Offset FennerData_Print_Str    // String
    dq Offset FennerData_Print_Func   // Function
    dq Offset FennerData_Print_Array  // Array
    dq Offset FennerData_Print_None   // Ptr
end;

function FennerData_TryAsInt_Bool(var v: TFennerData; var r: Int64): Boolean;
begin
  if v.vBool then
    r := 1
  else
    r := 0;
  Exit(True);
end;

function FennerData_TryAsInt_Str(var v: TFennerData; var r: Int64): Boolean;
var
  c: Integer;
begin
  Val(LString(v.vStr), r, c);
  Exit(c = 0);
end;

function FennerData_TryAsInt(var v: TFennerData; var r: Int64): Boolean;
  assembler; nostackframe;
asm
    xor rax, rax
    mov al, [rdi + TFennerData.vId]
    cmp al, 6
    ja  AsmRet_0
    mov rcx, Offset @a
    mov rcx, [rcx + rax * 8]
    jmp rcx
@a:
    dq Offset AsmRet_0                  // None
    dq Offset FennerData_TryAsInt_Bool  // Boolean
    dq Offset @AsInt                    // Integer
    dq Offset FennerData_TryAsInt_Str   // String
    dq Offset AsmRet_0                  // Function
    dq Offset AsmRet_0                  // Array
    dq Offset AsmRet_0                  // Ptr

@AsInt:
    mov rax, [rdi + TFennerData.vInt]
    mov [rsi], rax
    jmp AsmRet_Neg_1
end;

function FennerData_AsIntDefZero(var v: TFennerData): Int64;
begin
  if (not FennerData_TryAsInt(v, Result)) then
    Result := 0;
end;

procedure FennerDataDynArray_Clear(var p: TFennerDataDynArray);
var
  r: Pointer;
  c: NativeInt;
begin
  r := Pointer(p);
  if (r = nil) then Exit;
  try
    Pointer(p) := nil;
    if (PNativeInt(IntPtr(r) - 16)^ = 1) then
    begin
      c := (PNativeInt(IntPtr(r) - 8)^ + 1);
      if (c > 0) then
        FennerData_ClearArray(PFennerData(r)^, c);
    end;
  finally
    TFennerDataDynArray(r) := nil;
  end;
end;

function FennerData_SetId(var v: TFennerData; Id: Byte): Boolean;
  assembler; nostackframe;
asm
    cmp rsi, MaxOf_dttp
    je  AsmRet_0

    mov  al, [rdi + TFennerData.vId]
    cmp  al, sil
    je   AsmRet
    and rax, $ff

    mov  r8, rdi
    mov  r9, rsi

    mov  rcx, offset @clr
    mov  rcx, [rcx + rax * 8]
    test rcx, rcx
    jz   @a

    push r8
    push r9
    call rcx
    pop  r9
    pop  r8
@a:
    mov  rax, r9
    and  rax, $ff
    mov  [r8 + TFennerData.vId], al

    mov  rcx, offset @ini
    jmp  [rcx + rax * 8]

@clr:
    dq 0                           { None }
    dq 0                           { Boolean }
    dq 0                           { Integer }
    dq Offset FennerData_StrClear  { String }
    dq Offset FennerData_FnClear   { Function }
    dq Offset FennerData_ArrClear  { Array }
    dq Offset FennerData_PtrClear  { Pointer }
@ini:
    dq Offset @z                   { None }
    dq Offset @z                   { Boolean }
    dq Offset @z                   { Integer }
    dq Offset @ptr                 { String }
    dq Offset @fn                  { Function }
    dq Offset @ptr                 { Array }
    dq Offset @ptr                 { Pointer }
@fn:
@ptr:
    xor rax, rax
    mov [r8 + TFennerData.vId2], al
    mov [r8 + TFennerData.vFn], rax
    ret
@z:
end;

procedure FennerData_Clear(var v: TFennerData); assembler; nostackframe;
asm
    xor rsi, rsi
    jmp FennerData_SetId
end;

procedure FennerData_InitializeArray(var v: TFennerData; ACount: Integer);
begin
  FennerData_SetId(v, dttp_Array);
  SetLength(TFennerDataDynArray(v.vArr), ACount);
end;

procedure FennerData_Assign(var d: TFennerData; const s: PFennerData);
  assembler; nostackframe;
asm
    xor rax, rax
    mov al, [rsi + TFennerData.vId]
    cmp al, dttp_Ptr
    ja  @z
    mov rcx, offset @a
    mov rcx, [rcx + rax * 8]
    jmp rcx
@a:
    dq Offset @none
    dq Offset @bool
    dq Offset @int
    dq Offset @str
    dq Offset @func
    dq Offset @array
    dq Offset @ptr

@none:
    mov rsi, rax
    jmp FennerData_SetId
@bool:
@int:
    mov rcx, [rsi + TFennerData.vInt]

    push rdi
    push rcx
    mov rsi, rax
    call FennerData_SetId
    pop rsi
    pop rdi
    mov [rdi + TFennerData.vInt], rsi
    ret

@str:
    mov rcx, [rsi + TFennerData.vStr]

    push rdi
    push rcx
    mov  rsi, rax
    call FennerData_SetId
    pop  rsi
    pop  rdi
    lea  rdi, [rdi + TFennerData.vStr]
    jmp  LStrCpy

@func:
    mov  rdx, [rsi + TFennerData.vFn]
    mov  rsi, [rsi + TFennerData.vId2]
    and  rsi, $ff
    jmp  FennerData_SetAsFunction

@array:
    mov  rsi, [rsi + TFennerData.vArr]
    jmp  FennerData_SetAsArray
@ptr:
@z:
end;

procedure FennerData_SetAsBool(var v: TFennerData;
  const AValue: Boolean); assembler; nostackframe;
asm
    push rdi
    push rsi

    mov  rsi, dttp_Bool
    call FennerData_SetId

    pop  rax
    pop  rdi

    mov  [rdi + TFennerData.vBool], al
end;

procedure FennerData_SetAsInteger(var v: TFennerData; const AValue: Int64);
  assembler; nostackframe;
asm
    push rdi
    push rsi

    mov  rsi, dttp_Int
    call FennerData_SetId

    pop  rsi
    pop  rdi

    mov  [rdi + TFennerData.vInt], rsi
end;

procedure FennerData_SetAsString(var v: TFennerData; const AValue: LString);
  assembler; nostackframe;
asm
    push rdi
    push rsi

    mov  rsi, dttp_Str
    call FennerData_SetId

    pop  rsi
    pop  rdi

    lea  rdi, [rdi + TFennerData.vStr]
    jmp  LStrCpy
end;

procedure FennerData_SetAsFunction(var v: TFennerData; Id2: Byte;
  const AFunction: Pointer); assembler; nostackframe;
asm
    push rdi
    push rsi
    push rdx

    mov  rsi, dttp_Func
    call FennerData_SetId

    pop rdx
    pop rsi
    pop rdi

    mov  rax, rsi
    cmp  al, Id2_Func_Ref
    jne  @direct

    cmp  rdx, 0
    jz   @direct

    push rdi
    push rdx

    mov  rdi, rdx
    call EngineContextFunctionRef_IncRef
    pop  rdx
    pop  rdi

    mov  al, Id2_Func_Ref
@direct:
    mov [rdi + TFennerData.vId2], al
    mov [rdi + TFennerData.vFn], rdx
end;

procedure FennerData_SetAsFunctionBy(var v: TFennerData; const s: PFennerData);
begin
  FennerData_SetAsFunction(v, s.vId2, s.vFn);
end;

procedure FennerData_SetAsArray(var v: TFennerData; s: Pointer);
begin
  FennerData_SetId(v, dttp_Array);
  TFennerDataDynArray(v.vArr) := TFennerDataDynArray(s);
end;

procedure FennerData_ClearArray(var v: TFennerData; c: NativeInt);
  assembler; nostackframe;
asm
    cmp rsi, 0
    jna AsmRet

    push rbx
    push rbp

    mov rbp, rdi
    mov rbx, rsi

@a:
    xor rsi, rsi
    call FennerData_SetId

    dec rbx
    jz @z
    add rbp, SizeOf(TFennerData)
    mov rdi, rbp
    jmp @a
@z:
   pop rbp
   pop rbx
end;

end.

