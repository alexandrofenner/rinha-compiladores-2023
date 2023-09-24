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
unit data.stack;

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
  data.procs;

const
  StackVarsCapacity = 16777216;

var
  gvStackVarsIndex: NativeInt;
  gvStackVarsIndexMax: NativeInt = 16777215;
  gvStackVarsArray: array[0..16777215] of TFennerData;

procedure AsmStackItem; assembler;

function StackVarsAdd(const ACount: NativeInt): NativeInt;
procedure StackVarsRemove(const ACount: NativeInt); inline;
function StackVarsItem(const AIndex: NativeInt): PFennerData; inline;
function StackVarsItemZ(const AIndex: NativeInt): PFennerData; assembler;

function StackVarsFrameBegin(const ACount: NativeInt): PFennerData; assembler;
function StackVarsFrameBeginZ(const ACount: NativeInt): PFennerData; assembler;
procedure StackVarsFrameEnd(const ACount: NativeInt); inline;

function AuxStackVarsFrameBegin(const ACount: NativeInt): PFennerData; assembler;
procedure AuxStackVarsFrameEnd(const ACount: NativeInt); inline;

implementation

procedure StackVarsOverflow;
begin

end;

procedure AsmStackItem; assembler; nostackframe;
asm
    mov rax, offset gvStackVarsArray
end;

function StackVarsAdd(const ACount: NativeInt): NativeInt;
  assembler; nostackframe;
asm
    mov  rcx, Offset gvStackVarsIndex
    mov  rax, [rcx]
    lea  rsi, [rax + rdi]
    cmp  rsi, StackVarsCapacity
    ja   StackVarsOverflow
    mov  [rcx], rsi
end;

procedure StackVarsRemove(const ACount: NativeInt);
begin
  Dec(gvStackVarsIndex, ACount);
end;

function StackVarsItem(const AIndex: NativeInt): PFennerData;
begin
  Exit(@gvStackVarsArray[AIndex]);
end;

function StackVarsItemZ(const AIndex: NativeInt): PFennerData;
  assembler; nostackframe;
asm
    mov  rsi, rdi
    mov  rax, rdi
    imul rax, SizeOf(TFennerData)
    mov  rdi, Offset gvStackVarsArray
    lea  rdi, [rax + rdi]

    push rdi
    call FennerData_ClearArray
    pop  rax
end;

function StackVarsFrameBegin(const ACount: NativeInt): PFennerData;
  assembler; nostackframe;
asm
    mov  rcx, Offset gvStackVarsIndex
    mov  rax, [rcx]
    lea  rsi, [rax + rdi]
    cmp  rsi, StackVarsCapacity
    ja   StackVarsOverflow

    imul rax, SizeOf(TFennerData)
    mov  rdx, Offset gvStackVarsArray
    lea  rax, [rax + rdx]
    mov  [rcx], rsi
end;

function StackVarsFrameBeginZ(const ACount: NativeInt): PFennerData;
  assembler; nostackframe;
asm
    push rdi
    call StackVarsFrameBegin
    pop  rsi
    mov rdi, rax

    push rax
    call FennerData_ClearArray
    pop  rax
end;

procedure StackVarsFrameEnd(const ACount: NativeInt);
begin
  Dec(gvStackVarsIndex, ACount);
end;

function AuxStackVarsFrameBegin(const ACount: NativeInt): PFennerData;
  assembler; nostackframe;
asm
    mov  rcx, Offset gvStackVarsIndexMax
    mov  rax, [rcx]
    sub  rax, rdi
    cmp  rax, 0
    jl   StackVarsOverflow
    mov  [rcx], rax

    imul rax, SizeOf(TFennerData)
    mov  rdx, Offset gvStackVarsArray
    lea  rax, [rax + rdx]
end;

procedure AuxStackVarsFrameEnd(const ACount: NativeInt);
begin
  Inc(gvStackVarsIndexMax, ACount);
end;

end.

