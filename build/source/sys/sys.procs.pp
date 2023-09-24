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

unit sys.procs;

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
  sys.types;

procedure AsmRet; assembler;
procedure AsmRet_0; assembler;
procedure AsmRet_Neg_1; assembler;
procedure AsmRet_Rdx; assembler;
procedure AsmRet_Rdi; assembler;
procedure AsmRet_Rsi; assembler;

procedure LStrRefClr(var s: Pointer);
procedure LStrCpy(var d: Pointer; const s: Pointer);

implementation

procedure AsmRet; assembler; nostackframe;
asm
end;

procedure AsmRet_0; assembler; nostackframe;
asm
    xor rax, rax
end;

procedure AsmRet_Neg_1; assembler; nostackframe;
asm
    xor rax, rax
    dec rax
end;

procedure AsmRet_Rdx; assembler; nostackframe;
asm
    mov rax, rdx
end;

procedure AsmRet_Rdi; assembler; assembler;
asm
    mov rax, rdi
end;

procedure AsmRet_Rsi; assembler; assembler;
asm
    mov rax, rsi
end;

procedure LStrRefClr(var s: Pointer);
begin
  LString(s) := '';
end;

procedure LStrCpy(var d: Pointer; const s: Pointer);
begin
  LString(d) := LString(s);
end;

end.

