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
unit scanner.reswords;

{$mode Delphi}{$H+}
{$asmmode Intel}
{$pointermath on}
{$scopedenums on}
{$r-,i-,o-}
{$warnings off}
{$hints off}
{$notes off}

interface

function AsmTryGetReservedId(const p: PAnsiChar; c: Integer): Byte;

implementation

uses
  scanner.types,
  sys.procs;

procedure _AsmTryGetReservedId2; {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif}

    {$ifdef Linux}
    mov cx, [rdi]
    {$else}
    mov cx, [rcx]
    {$endif}
    cmp cx, 26217     { 'if' }
    je  @if
    jb  AsmRet_0
    cmp cx, 28262     { 'fn' }
    jne AsmRet_0
    mov al, tkrw_Function
    ret

@if:
    mov al, tkrw_If
end;

procedure _AsmTryGetReservedId3; {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif}

    {$ifdef Linux}
    mov ecx, [rdi]
    {$else}
    mov ecx, [rcx]
    {$endif}

    and ecx, $ffffff

    cmp ecx, 7628140  { 'let' }
    jne AsmRet_0

    mov al, tkrw_Let
end;

procedure _AsmTryGetReservedId4; {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef delphi}
.noframe
{$endif}

    {$ifdef Linux}
    mov ecx, [rdi]
    {$else}
    mov ecx, [rcx]
    {$endif}
    cmp ecx, 1702063205   { 'else' }
    je  @_else
    jb  AsmRet_0

    cmp ecx, 1702195828   { 'true' }
    jne AsmRet_0
    mov al, tkrw_True
    ret

@_else:
    mov al, tkrw_Else
end;

procedure _AsmTryGetReservedId5; {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef delphi}
.noframe
{$endif}

    {$ifdef Linux}
    mov rcx, [rdi]
    {$else}
    mov rcx, [rcx]
    {$endif}

    cmp ecx, 1852404336 { 'prin' }
    je @_prin

    cmp ecx, 1936482662 { 'fals' }
    je @_fals

    cmp ecx, 1936877926 { 'firs' }
    je @_firs

    cmp ecx, 1634890337 { 'arra' }
    je @_arra

    cmp ecx, 1818847351 { 'whil' }
    je @_whil

    cmp ecx, 1919510644 { 'thir' }
    je @_thir

    cmp ecx, 1952868710 { 'fift' }
    je @_fift

    cmp ecx, 1954048371 { 'sixt' }
    je @_sixt

    cmp ecx, 1953393006 { 'nint' }
    je @_nint

    cmp ecx, 1953391988 { 'tent' }
    je @_tent

    jmp AsmRet_0

@_prin:
    mov al, tkrw_print
    jmp @check_5t

@_firs:
    mov al, tkrw_first
    jmp @check_5t

@_fals:
    mov al, tkrw_false
    jmp @check_5e

@_arra:
    mov al, tkrw_array
    jmp @check_5y

@_whil:
    mov al, tkrw_while
    jmp @check_5e

@_thir:
    mov al, tkrw_third
    jmp @check_5d

@_fift:
    mov al, tkrw_fifth
    jmp @check_5h

@_sixt:
    mov al, tkrw_sixth
    jmp @check_5h

@_nint:
    mov al, tkrw_ninth
    jmp @check_5h

@_tent:
    mov al, tkrw_tenth
    jmp @check_5h

@check_5d:
    shr rcx, 32
    cmp cl, 100   { 'd' }
    je  AsmRet
    jmp AsmRet_0

@check_5e:
    shr rcx, 32
    cmp cl, 101   { 'e' }
    je  AsmRet
    jmp AsmRet_0

@check_5h:
    shr rcx, 32
    cmp cl, 104   { 'h' }
    je  AsmRet
    jmp AsmRet_0

@check_5t:
    shr rcx, 32
    cmp cl, 116   { 't' }
    je  AsmRet
    jmp AsmRet_0

@check_5y:
    shr rcx, 32
    cmp cl, 121   { 'y' }
    je  AsmRet
    jmp AsmRet_0
end;

procedure _AsmTryGetReservedId6; {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif}

    {$ifdef Linux}
    mov rcx, [rdi]
    {$else}
    mov rcx, [rcx]
    {$endif}

    cmp ecx, 1868785011 { 'seco' }
    je @_seco

    cmp ecx, 1920298854 { 'four' }
    je @_four

    cmp ecx, 1751607653 { 'eigh' }
    je @_eigh

    cmp ecx, 1701869940 { 'type' }
    je @_type

    jmp AsmRet_0

@_seco:
    mov al, tkrw_Second
    jmp @check_6nt

@_four:
    mov al, tkrw_Fourth
    jmp @check_6th

@_eigh:
    mov al, tkrw_Eighth
    jmp @check_6th

@_type:
    mov al, tkrw_TypeOf
    jmp @check_6of

@check_6nt:
    shr rcx, 32
    cmp cx, 25710   { 'nt' }
    je  AsmRet
    jmp AsmRet_0

@check_6th:
    shr rcx, 32
    cmp cx, 26740   { 'th' }
    je  AsmRet
    jmp AsmRet_0

@check_6of:
    shr rcx, 32
    cmp cx, 26223   { 'of' }
    je  AsmRet
    jmp AsmRet_0
end;

procedure _AsmTryGetReservedId7; {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif}

    {$ifdef Linux}
    mov rcx, [rdi]
    {$else}
    mov rcx, [rcx]
    {$endif}

    cmp ecx, 1702258035   { 'seve' }
    je @_seve

    jmp AsmRet_0

@_seve:
    mov al, tkrw_seventh
    jmp @check_6nth

@check_6nth:
    shr rcx, 32
    cmp ecx, 6845550    { 'nth' }
    je  AsmRet
    jmp AsmRet_0
end;

procedure _AsmTryGetReservedId10; {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif}

    {$ifdef Linux}
    mov dx, [rdi + 8]
    {$else}
    mov dx, [rcx + 8]
    {$endif}
    cmp dx, 28005       { 'em' }
    jne AsmRet_0

    {$ifdef Linux}
    mov rcx, [rdi]
    {$else}
    mov rcx, [rcx]
    {$endif}

    cmp ecx, 1634890337 { 'arra' }
    jne AsmRet_0

    shr rcx, 32
    cmp ecx, 1953062777 { 'y_it' }
    jne AsmRet_0

    mov al, tkrw_Array_GetItem
end;

procedure _AsmTryGetReservedId12; {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif}

    {$ifdef Linux}
    mov edx, [rdi + 8]
    {$else}
    mov edx, [rcx + 8]
    {$endif}
    cmp edx, 1752459118 { 'ngth' }
    jne AsmRet_0

    {$ifdef Linux}
    mov rcx, [rdi]
    {$else}
    mov rcx, [rcx]
    {$endif}

    cmp ecx, 1634890337 { 'arra' }
    jne AsmRet_0

    shr rcx, 32
    cmp ecx, 1701601145 { 'y_le' }
    jne AsmRet_0

    mov al, tkrw_Array_GetLength
end;

function AsmTryGetReservedId(const p: PAnsiChar; c: Integer): Byte;
  {$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif}

    {$ifdef Linux}
    cmp rsi, 12
    ja  AsmRet_0
    mov rax, offset @table
    jmp [rax + rsi * 8]
    {$else}
    cmp rdx, 12
    ja  AsmRet_0
    mov rax, offset @table
    jmp [rax + rdx * 8]
    {$endif}

@table:
    dq offset AsmRet_0
    dq offset AsmRet_0
    dq offset _AsmTryGetReservedId2
    dq offset _AsmTryGetReservedId3
    dq offset _AsmTryGetReservedId4
    dq offset _AsmTryGetReservedId5
    dq offset _AsmTryGetReservedId6
    dq offset _AsmTryGetReservedId7
    dq offset AsmRet_0
    dq offset AsmRet_0
    dq offset _AsmTryGetReservedId10
    dq offset AsmRet_0
    dq offset _AsmTryGetReservedId12
end;

end.

