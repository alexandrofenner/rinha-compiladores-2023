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
unit engine.recursivecache_n;

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

function EngineRecursiveCacheEntry_TryGet_n(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
procedure EngineRecursiveCacheEntry_Put_n(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);

implementation

function IsEqBuffer(l, r: PInt64; c: Integer): Boolean; assembler; nostackframe;
asm
    mov rax, [rdi]
    mov rcx, [rsi]

@a:
    cmp rax, rcx
    jne AsmRet_0
    dec rdx
    jz  AsmRet_Neg_1
    add rdi, 8
    add rsi, 8
    jmp @a
end;

function EngineRecursiveCacheEntry_TryGet_n(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  i, c: Integer;
  p: PInt64;
  TempBuffer: Pointer;
begin
  c := This.FCache.FIndex;

  TempBuffer := This.FTempBuffer;
  if (TempBuffer = nil) then
  begin
    GetMem(TempBuffer, (c * 8));
    This.FTempBuffer := TempBuffer;
  end;

  p := TempBuffer;
  for i := 0 to (c - 1) do
  begin
    if (Args[i].vId <> dttp_Int) then Exit(False);
    p^ := Args[i].vInt;
    Inc(p);
  end;

  for i := 0 to (This.FContentCount - 1) do
  begin
    p := This.FContentArray[i];
    if IsEqBuffer(TempBuffer, p, c) then
    begin
      FennerData_SetAsInteger(AResult, p[c]);
      Exit(True);
    end;
  end;

  Exit(False);
end;

procedure EngineRecursiveCacheEntry_Put_n(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);
var
  i, c: Integer;
  p: PInt64;
  TempBuffer: Pointer;
begin
  if (AValue.vId <> dttp_Int) then Exit;

  c := This.FCache.FIndex;

  TempBuffer := This.FTempBuffer;
  if (TempBuffer = nil) then
  begin
    GetMem(TempBuffer, (c * 8));
    This.FTempBuffer := TempBuffer;
  end;

  p := TempBuffer;
  for i := 0 to (c - 1) do
  begin
    if (Args[i].vId <> dttp_Int) then Exit;
    p^ := Args[i].vInt;
    Inc(p);
  end;

  if (This.FContentCount < Length(This.FContentArray)) then
  begin
    GetMem(p, (c + 1) * 8);
    This.FContentArray[This.FContentCount] := p;
    Inc(This.FContentCount);
  end else
  begin
    p := This.FContentArray[This.FContentIndex];
    Inc(This.FContentIndex);
    if (This.FContentIndex >= This.FContentCount) then
      This.FContentIndex := 0;
  end;

  Move(TempBuffer^, p^, (c * 8));
  p[c] := AValue.vInt;
end;

end.

