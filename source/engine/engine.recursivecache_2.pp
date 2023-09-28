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
unit engine.recursivecache_2;

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
  sys.procs,
  data.types,
  data.procs,
  engine.types,
  engine.recursivecache;

function EngineRecursiveCacheEntry_TryGet_2(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
procedure EngineRecursiveCacheEntry_Put_2(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);

implementation

type
  PRecord2 = ^TRecord2;
  TRecord2 = record
    k0: Int64;
    k1: Int64;
    v: Int64;
  end;

function EngineRecursiveCacheEntry_TryGet_2(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
{var
  i: Integer;
  k0, k1: Int64;
  p: PRecord2;
begin
  if (Args[0].vId <> dttp_Int) then Exit(False);
  if (Args[1].vId <> dttp_Int) then Exit(False);
  k0 := Args[0].vInt;
  k1 := Args[1].vInt;
  for i := 0 to (This.FContentCount - 1) do
  begin
    p := This.FContentArray[i];
    if ((p.k0 = k0) and (p.k1 = k1)) then
    begin
      FennerData_SetAsInteger(AResult, p.v);
      Exit(True);
    end;
  end;
  Exit(False);
end;}
asm
// rdi -> This
// rsi -> Args
// rdx -> AResult

    mov cl, [rsi + TFennerData.vId]
    cmp cl, dttp_Int
    jne AsmRet_0

  // r8 -> valor que está sendo procurado (index: 0)
    mov r8, [rsi + TFennerData.vInt]

    add rsi, SizeOf(TFennerData)
    mov cl, [rsi + TFennerData.vId]
    cmp cl, dttp_Int
    jne AsmRet_0

    push rdx

  // r9 -> valor que está sendo procurado (index: 1)
    mov r9, [rsi + TFennerData.vInt]

  // r10 -> quantidade de registros no cache
    push r10
    xor r10, r10
    mov r10d, [rdi + TEngineRecursiveCacheEntry.FContentCount]

  // rdx -> índice que está sendo percorrido
    xor rdx, rdx
  // rcx -> array os registros de cache
    lea rcx, [rdi + TEngineRecursiveCacheEntry.FContentArray]

@loop:
    cmp rdx, r10
    jnb @end_loop

    mov rax, [rcx + rdx * 8]
    cmp [rax], r8             // Compara o valor (index: 0)
    jne @next
    cmp [rax + 8], r9         // Compara o valor (index: 1)
    je @found
@next:
    inc rdx
    jmp @loop

@found:
    mov rsi, [rax + 16]
    pop r10
    pop rdi

    call FennerData_SetAsInteger
    jmp AsmRet_Neg_1
@end_loop:
    pop r10
    pop rax
    jmp AsmRet_0
end;

procedure EngineRecursiveCacheEntry_Put_2(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);
var
  p: PRecord2;
begin
  if ((Args[0].vId <> dttp_Int) or
      (Args[1].vId <> dttp_Int) or
      (AValue.vId <> dttp_Int)) then Exit;

  if (This.FContentCount < Length(This.FContentArray)) then
  begin
    GetMem(p, SizeOf(TRecord2));
    This.FContentArray[This.FContentCount] := p;
    Inc(This.FContentCount);
  end else
  begin
    p := This.FContentArray[This.FContentIndex];
    Inc(This.FContentIndex);
    if (This.FContentIndex >= This.FContentCount) then
      This.FContentIndex := 0;
  end;

  p.k0 := Args[0].vInt;
  p.k1 := Args[1].vInt;
  p.v := AValue.vInt;
end;

end.

