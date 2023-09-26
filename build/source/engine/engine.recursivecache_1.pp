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
unit engine.recursivecache_1;

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

function EngineRecursiveCacheEntry_TryGet_1(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
procedure EngineRecursiveCacheEntry_Put_1(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);

implementation

type
  PRecord1 = ^TRecord1;
  TRecord1 = record
    k: Int64;
    v: Int64;
  end;

function EngineRecursiveCacheEntry_TryGet_1(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean; assembler; nostackframe;
//var
//  i: Integer;
//  k: Int64;
//  p: PRecord1;
//begin
//  if (Args[0].vId <> dttp_Int) then Exit(False);
//  k := Args[0].vInt;
//  for i := 0 to (This.FContentCount - 1) do
//  begin
//    p := This.FContentArray[i];
//    if (p.k = k) then
//    begin
//      FennerData_SetAsInteger(AResult, p.v);
//      Exit(True);
//    end;
//  end;
//  Exit(False);
asm
  // rdi -> This
  // rsi -> Args
  // rdx -> AResult

    mov cl, [rsi + TFennerData.vId]
    cmp cl, dttp_Int
    jne AsmRet_0

    push rdx

  // r8 -> valor que está sendo procurado
    mov r8, [rsi + TFennerData.vInt]

  // r9 -> Quantidade de itens no registro de cache
    xor r9, r9
    mov r9d, [rdi + TEngineRecursiveCacheEntry.FContentCount]

  // rdx -> índice que está sendo percorrido
    xor rdx, rdx
  // rcx -> array os registros de cache
    lea rcx, [rdi + TEngineRecursiveCacheEntry.FContentArray]

@loop:
    cmp rdx, r9
    jnb @end_loop

    mov rax, [rcx + rdx * 8]
    cmp [rax], r8
    je  @found

    inc rdx
    jmp @loop
@found:
    mov rsi, [rax + 8]
    pop rdi

    call FennerData_SetAsInteger
    jmp AsmRet_Neg_1
@end_loop:
    pop rax
    jmp AsmRet_0
end;

procedure EngineRecursiveCacheEntry_Put_1(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);
var
  p: PRecord1;
begin
  if ((Args[0].vId <> dttp_Int) or (AValue.vId <> dttp_Int)) then Exit;

  if (This.FContentCount < Length(This.FContentArray)) then
  begin
    GetMem(p, SizeOf(TRecord1));
    This.FContentArray[This.FContentCount] := p;
    Inc(This.FContentCount);
  end else
  begin
    p := This.FContentArray[This.FContentIndex];
    Inc(This.FContentIndex);
    if (This.FContentIndex >= This.FContentCount) then
      This.FContentIndex := 0;
  end;

  p.k := Args[0].vInt;
  p.v := AValue.vInt;
end;

end.

