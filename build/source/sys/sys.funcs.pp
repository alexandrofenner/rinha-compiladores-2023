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
unit sys.funcs;

{$mode Delphi}{$H+}
{$asmmode Intel}
{$pointermath on}
{$scopedenums on}
{$r-,i-,o-}
{$warnings off}
{$hints off}
{$notes off}

interface

function MyFuncsAsm_Factorial(const n: UInt64): UInt64;
function MyFuncsAsm_Fibonacci(const n: UInt64): UInt64;
function MyFuncsAsm_FibonacciR3(const n, a, b: UInt64): UInt64;
function MyFuncsAsm_SumOfApTerms(const i: UInt64): UInt64;
function MyFuncsAsm_Mdc(const a, b: Int64): Int64;
function MyFuncsAsm_HanoiMovsCount(const d: Int64): Int64;

function MyFuncs_IntPower(const ABase: Int64; const AExponent: Integer): Int64;

implementation

uses
  sys.procs;

function MyFuncsAsm_Factorial(const n: UInt64): UInt64;
  assembler; nostackframe;
asm
    cmp rdi, 21
    ja AsmRet_Neg_1
    mov rax, offset @a
    mov rax, [rax + rdi * 8]
    ret

@a:
  db $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00
  db $02,$00,$00,$00,$00,$00,$00,$00,$06,$00,$00,$00,$00,$00,$00,$00
  db $18,$00,$00,$00,$00,$00,$00,$00,$78,$00,$00,$00,$00,$00,$00,$00
  db $D0,$02,$00,$00,$00,$00,$00,$00,$B0,$13,$00,$00,$00,$00,$00,$00
  db $80,$9D,$00,$00,$00,$00,$00,$00,$80,$89,$05,$00,$00,$00,$00,$00
  db $00,$5F,$37,$00,$00,$00,$00,$00,$00,$15,$61,$02,$00,$00,$00,$00
  db $00,$FC,$8C,$1C,$00,$00,$00,$00,$00,$CC,$28,$73,$01,$00,$00,$00
  db $00,$28,$3B,$4C,$14,$00,$00,$00,$00,$58,$77,$77,$30,$01,$00,$00
  db $00,$80,$75,$77,$07,$13,$00,$00,$00,$80,$CD,$EE,$7E,$43,$01,$00
  db $00,$00,$73,$CA,$EC,$BE,$16,$00,$00,$00,$89,$06,$93,$2B,$B0,$01
  db $00,$00,$B4,$82,$7C,$67,$C3,$21,$00,$00,$C4,$B8,$36,$7D,$07,$C5
  db $00,$00,$D8,$E0,$B3,$C2,$A4,$EE
end;

function MyFuncsAsm_Fibonacci(const n: UInt64): UInt64;
  assembler; nostackframe;
asm
    cmp rdi, 92
    ja  AsmRet_0
    mov rax, offset @a
    mov rax, [rax + rdi * 8]
    ret
@a:
  db $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01
  db $00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$03,$00
  db $00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00
  db $00,$00,$00,$00,$00,$0D,$00,$00,$00,$00,$00,$00,$00,$15,$00,$00,$00
  db $00,$00,$00,$00,$22,$00,$00,$00,$00,$00,$00,$00,$37,$00,$00,$00,$00
  db $00,$00,$00,$59,$00,$00,$00,$00,$00,$00,$00,$90,$00,$00,$00,$00,$00
  db $00,$00,$E9,$00,$00,$00,$00,$00,$00,$00,$79,$01,$00,$00,$00,$00,$00
  db $00,$62,$02,$00,$00,$00,$00,$00,$00,$DB,$03,$00,$00,$00,$00,$00,$00
  db $3D,$06,$00,$00,$00,$00,$00,$00,$18,$0A,$00,$00,$00,$00,$00,$00,$55
  db $10,$00,$00,$00,$00,$00,$00,$6D,$1A,$00,$00,$00,$00,$00,$00,$C2,$2A
  db $00,$00,$00,$00,$00,$00,$2F,$45,$00,$00,$00,$00,$00,$00,$F1,$6F,$00
  db $00,$00,$00,$00,$00,$20,$B5,$00,$00,$00,$00,$00,$00,$11,$25,$01,$00
  db $00,$00,$00,$00,$31,$DA,$01,$00,$00,$00,$00,$00,$42,$FF,$02,$00,$00
  db $00,$00,$00,$73,$D9,$04,$00,$00,$00,$00,$00,$B5,$D8,$07,$00,$00,$00
  db $00,$00,$28,$B2,$0C,$00,$00,$00,$00,$00,$DD,$8A,$14,$00,$00,$00,$00
  db $00,$05,$3D,$21,$00,$00,$00,$00,$00,$E2,$C7,$35,$00,$00,$00,$00,$00
  db $E7,$04,$57,$00,$00,$00,$00,$00,$C9,$CC,$8C,$00,$00,$00,$00,$00,$B0
  db $D1,$E3,$00,$00,$00,$00,$00,$79,$9E,$70,$01,$00,$00,$00,$00,$29,$70
  db $54,$02,$00,$00,$00,$00,$A2,$0E,$C5,$03,$00,$00,$00,$00,$CB,$7E,$19
  db $06,$00,$00,$00,$00,$6D,$8D,$DE,$09,$00,$00,$00,$00,$38,$0C,$F8,$0F
  db $00,$00,$00,$00,$A5,$99,$D6,$19,$00,$00,$00,$00,$DD,$A5,$CE,$29,$00
  db $00,$00,$00,$82,$3F,$A5,$43,$00,$00,$00,$00,$5F,$E5,$73,$6D,$00,$00
  db $00,$00,$E1,$24,$19,$B1,$00,$00,$00,$00,$40,$0A,$8D,$1E,$01,$00,$00
  db $00,$21,$2F,$A6,$CF,$01,$00,$00,$00,$61,$39,$33,$EE,$02,$00,$00,$00
  db $82,$68,$D9,$BD,$04,$00,$00,$00,$E3,$A1,$0C,$AC,$07,$00,$00,$00,$65
  db $0A,$E6,$69,$0C,$00,$00,$00,$48,$AC,$F2,$15,$14,$00,$00,$00,$AD,$B6
  db $D8,$7F,$20,$00,$00,$00,$F5,$62,$CB,$95,$34,$00,$00,$00,$A2,$19,$A4
  db $15,$55,$00,$00,$00,$97,$7C,$6F,$AB,$89,$00,$00,$00,$39,$96,$13,$C1
  db $DE,$00,$00,$00,$D0,$12,$83,$6C,$68,$01,$00,$00,$09,$A9,$96,$2D,$47
  db $02,$00,$00,$D9,$BB,$19,$9A,$AF,$03,$00,$00,$E2,$64,$B0,$C7,$F6,$05
  db $00,$00,$BB,$20,$CA,$61,$A6,$09,$00,$00,$9D,$85,$7A,$29,$9D,$0F,$00
  db $00,$58,$A6,$44,$8B,$43,$19,$00,$00,$F5,$2B,$BF,$B4,$E0,$28,$00,$00
  db $4D,$D2,$03,$40,$24,$42,$00,$00,$42,$FE,$C2,$F4,$04,$6B,$00,$00,$8F
  db $D0,$C6,$34,$29,$AD,$00,$00,$D1,$CE,$89,$29,$2E,$18,$01,$00,$60,$9F
  db $50,$5E,$57,$C5,$01,$00,$31,$6E,$DA,$87,$85,$DD,$02,$00,$91,$0D,$2B
  db $E6,$DC,$A2,$04,$00,$C2,$7B,$05,$6E,$62,$80,$07,$00,$53,$89,$30,$54
  db $3F,$23,$0C,$00,$15,$05,$36,$C2,$A1,$A3,$13,$00,$68,$8E,$66,$16,$E1
  db $C6,$1F,$00,$7D,$93,$9C,$D8,$82,$6A,$33,$00,$E5,$21,$03,$EF,$63,$31
  db $53,$00,$62,$B5,$9F,$C7,$E6,$9B,$86,$00,$47,$D7,$A2,$B6,$4A,$CD,$D9
  db $00,$A9,$8C,$42,$7E,$31,$69,$60,$01,$F0,$63,$E5,$34,$7C,$36,$3A,$02
  db $99,$F0,$27,$B3,$AD,$9F,$9A,$03,$89,$54,$0D,$E8,$29,$D6,$D4,$05,$22
  db $45,$35,$9B,$D7,$75,$6F,$09,$AB,$99,$42,$83,$01,$4C,$44,$0F,$CD,$DE
  db $77,$1E,$D9,$C1,$B3,$18,$78,$78,$BA,$A1,$DA,$0D,$F8,$27,$45,$57,$32
  db $C0,$B3,$CF,$AB,$40,$BD,$CF,$EC,$61,$8E,$DD,$A3,$68
end;

function MyFuncsAsm_FibonacciR3(const n, a, b: UInt64): UInt64;
  assembler; nostackframe;
asm
    cmp rsi, 0
    jne @start
    cmp rdx, 1
    jne @start
    jmp MyFuncsAsm_Fibonacci

@start:

@loop:
    cmp rdi, 1
    jb AsmRet_rsi
    je AsmRet_rdx

    xchg rsi, rdx
    add rdx, rsi
    dec rdi
    jmp @loop

{$ifdef MSWindows}
@exit:
    pop rsi
    pop rdi
    ret
@ret_rsi:
    mov rax, rsi
    jmp @exit
@ret_rdx:
    mov rax, rdx
    jmp @exit
{$endif MSWindows}
end;

function MyFuncsAsm_SumOfApTerms(const i: UInt64): UInt64;
{$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif Delphi}

    {$ifdef Linux}
    mov rax, rdi
    inc rax
    imul rax, rdi
    shr rax, 1
    {$else}
    mov rax, rcx
    inc rax
    imul rax, rcx
    shr rax, 1
    {$endif}
end;

function MyFuncsAsm_Mdc(const a, b: Int64): Int64;
{$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif Delphi}

    {$ifdef MSWindows}
    push rdi
    push rsi
    mov rdi, rcx
    mov rsi, rdx
    {$endif MSWindows}

    cmp rdi, rsi
    jnl @a
    xchg rdi, rsi
@a:
    cmp rsi, 0
    {$ifdef MSWindows}
    jl @Win_Neg1
    je @Win_Ret_Rdi
    {$else}
    jl AsmRet_Neg_1
    je AsmRet_Rsi
    {$endif}

@b:
    { max -> rdi
      min -> rsi }
    xor rdx, rdx
    mov rax, rdi
    idiv rsi

    cmp rdx, 0
    {$ifdef MSWindows}
    je @Win_Ret_Rsi
    {$else}
    je AsmRet_Rsi
    {$endif}
    mov rdi, rdx

    { max -> rsi
      min -> rdi }
    xor rdx, rdx
    mov rax, rsi
    idiv rdi

    cmp rdx, 0
    je AsmRet_Rdi
    mov rsi, rdi
    jmp @b

    {$ifdef MSWindows}
@Win_Ret:
    pop rsi
    pop rdi
    ret
@Win_Neg1:
    xor rax, rax
    jmp @Win_Ret
@Win_Ret_Rdi:
    mov rax, rdi
    jmp @Win_Ret
@Win_Ret_Rsi:
    mov rax, rsi
    jmp @Win_Ret
    {$endif MSWindows}
end;

function MyFuncsAsm_HanoiMovsCount(const d: Int64): Int64;
{$ifdef fpc} assembler; nostackframe; {$endif}
asm
{$ifdef Delphi}
.noframe
{$endif Delphi}

{$ifdef Linux}
    cmp rdi, 0
    jle AsmRet_0
    cmp rdi, 64
    ja AsmRet_0
    je AsmRet_Neg_1
    xor rax, rax
    mov al, 1
    mov cl, dil
    shl rax, cl
    dec rax
{$else}
    cmp rcx, 0
    jle AsmRet_0
    cmp rcx, 64
    ja AsmRet_0
    je AsmRet_Neg_1
    xor rax, rax
    mov al, 1
    shl rax, cl
    dec rax
{$endif Linux}
end;

function MyFuncs_IntPower(const ABase: Int64; const AExponent: Integer): Int64;
var
  Y: Integer;
  LBase: Int64;
begin
  if (AExponent < 0) then Exit(0);

  Y := Abs(AExponent);
  LBase := ABase;
  Result := 1;
  while (Y > 0) do
  begin
    while not Odd(Y) do
    begin
      Y := (Y shr 1);
      LBase := (LBase * LBase)
    end;
    Dec(Y);
    Result := (Result * LBase)
  end;
end;

end.

