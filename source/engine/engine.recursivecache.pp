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
unit engine.recursivecache;

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
  engine.types;

function EngineRecursiveCache_GetEntry(var This: TEngineRecursiveCache;
  const AContext: PEngineContext): PEngineRecursiveCacheEntry;
procedure EngineRecursiveCacheEntry_DecRef(var This: TEngineRecursiveCacheEntry);

function EngineRecursiveCacheEntry_TryGet(var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray; var AResult: TFennerData): Boolean; assembler;
procedure EngineRecursiveCacheEntry_Put(var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray; const AValue: TFennerData); assembler;

implementation

uses
  engine.recursivecache_1,
  engine.recursivecache_2,
  engine.recursivecache_3,
  engine.recursivecache_4,
  engine.recursivecache_5,
  engine.recursivecache_6,
  engine.recursivecache_7,
  engine.recursivecache_8,
  engine.recursivecache_9,
  engine.recursivecache_10,
  engine.recursivecache_11,
  engine.recursivecache_12,
  engine.recursivecache_13,
  engine.recursivecache_14,
  engine.recursivecache_15,
  engine.recursivecache_16,
  engine.recursivecache_17,
  engine.recursivecache_18,
  engine.recursivecache_19,
  engine.recursivecache_20,
  engine.recursivecache_21,
  engine.recursivecache_22,
  engine.recursivecache_23,
  engine.recursivecache_n;

type
  TFn_TryGet = function(var This: TEngineRecursiveCacheEntry;
    const Args: TFennerDataDynArray; var AResult: TFennerData): Boolean;
  TFn_Put = procedure(var This: TEngineRecursiveCacheEntry;
    const Args: TFennerDataDynArray; const AValue: TFennerData);

  PRecordFn = ^TRecordFn;
  TRecordFn = record
    TryGet: TFn_TryGet;
    Put: TFn_Put;
  end;

function EngineRecursiveCacheEntry_TryGet_0(var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray; var AResult: TFennerData): Boolean;
  assembler; nostackframe;
asm
   xor rax, rax
end;

procedure EngineRecursiveCacheEntry_Put_0(var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray; const AValue: TFennerData);
  assembler; nostackframe;
asm
end;

const
  cTabRecords: array[0..24] of TRecordFn = (
    (TryGet: EngineRecursiveCacheEntry_TryGet_0;
     Put: EngineRecursiveCacheEntry_Put_0),
    (TryGet: EngineRecursiveCacheEntry_TryGet_1;
     Put: EngineRecursiveCacheEntry_Put_1),
    (TryGet: EngineRecursiveCacheEntry_TryGet_2;
     Put: EngineRecursiveCacheEntry_Put_2),
    (TryGet: EngineRecursiveCacheEntry_TryGet_3;
     Put: EngineRecursiveCacheEntry_Put_3),
    (TryGet: EngineRecursiveCacheEntry_TryGet_4;
     Put: EngineRecursiveCacheEntry_Put_4),
    (TryGet: EngineRecursiveCacheEntry_TryGet_5;
     Put: EngineRecursiveCacheEntry_Put_5),
    (TryGet: EngineRecursiveCacheEntry_TryGet_6;
     Put: EngineRecursiveCacheEntry_Put_6),
    (TryGet: EngineRecursiveCacheEntry_TryGet_7;
     Put: EngineRecursiveCacheEntry_Put_7),
    (TryGet: EngineRecursiveCacheEntry_TryGet_8;
     Put: EngineRecursiveCacheEntry_Put_8),
    (TryGet: EngineRecursiveCacheEntry_TryGet_9;
     Put: EngineRecursiveCacheEntry_Put_9),
    (TryGet: EngineRecursiveCacheEntry_TryGet_10;
     Put: EngineRecursiveCacheEntry_Put_10),
    (TryGet: EngineRecursiveCacheEntry_TryGet_11;
     Put: EngineRecursiveCacheEntry_Put_11),
    (TryGet: EngineRecursiveCacheEntry_TryGet_12;
     Put: EngineRecursiveCacheEntry_Put_12),
    (TryGet: EngineRecursiveCacheEntry_TryGet_13;
     Put: EngineRecursiveCacheEntry_Put_13),
    (TryGet: EngineRecursiveCacheEntry_TryGet_14;
     Put: EngineRecursiveCacheEntry_Put_14),
    (TryGet: EngineRecursiveCacheEntry_TryGet_15;
     Put: EngineRecursiveCacheEntry_Put_15),
    (TryGet: EngineRecursiveCacheEntry_TryGet_16;
     Put: EngineRecursiveCacheEntry_Put_16),
    (TryGet: EngineRecursiveCacheEntry_TryGet_17;
     Put: EngineRecursiveCacheEntry_Put_17),
    (TryGet: EngineRecursiveCacheEntry_TryGet_18;
     Put: EngineRecursiveCacheEntry_Put_18),
    (TryGet: EngineRecursiveCacheEntry_TryGet_19;
     Put: EngineRecursiveCacheEntry_Put_19),
    (TryGet: EngineRecursiveCacheEntry_TryGet_20;
     Put: EngineRecursiveCacheEntry_Put_20),
    (TryGet: EngineRecursiveCacheEntry_TryGet_21;
     Put: EngineRecursiveCacheEntry_Put_21),
    (TryGet: EngineRecursiveCacheEntry_TryGet_22;
     Put: EngineRecursiveCacheEntry_Put_22),
    (TryGet: EngineRecursiveCacheEntry_TryGet_23;
     Put: EngineRecursiveCacheEntry_Put_23),
    (TryGet: EngineRecursiveCacheEntry_TryGet_n;
     Put: EngineRecursiveCacheEntry_Put_n)
   );

function EngineRecursiveCache_GetEntry(var This: TEngineRecursiveCache;
  const AContext: PEngineContext): PEngineRecursiveCacheEntry;
var
  LCurrent, LNext: PEngineRecursiveCacheEntry;
  P: PRecordFn;
begin
  LCurrent := This.FEntriesLast;
  if (LCurrent = nil) then
  begin
    if (This.FIndex <= 23) then
      P := @cTabRecords[This.FIndex]
    else
      P := @cTabRecords[24];

    LCurrent := AllocMem(SizeOf(TEngineRecursiveCacheEntry));
    LCurrent.FContext := AContext;
    LCurrent.FCache := @This;
    LCurrent.FRefCount := 1;
    LCurrent.FFnTryGet := @P.TryGet;
    LCurrent.FFnPut := @P.Put;
    This.FEntriesFirst := LCurrent;
    This.FEntriesLast := LCurrent;
    Exit(LCurrent);
  end;

  repeat
    if (LCurrent.FContext = AContext) then
    begin
      Inc(LCurrent.FRefCount);
      Exit(LCurrent);
    end;

    LNext := LCurrent.FNext;
    if (LNext = nil) then
    begin
      if (This.FIndex <= 23) then
        P := @cTabRecords[This.FIndex]
      else
        P := @cTabRecords[24];

      LNext := AllocMem(SizeOf(TEngineRecursiveCacheEntry));
      LNext.FContext := AContext;
      LNext.FCache := @This;
      LNext.FRefCount := 1;
      LNext.FPrevious := This.FEntriesLast;
      LNext.FFnTryGet := @P.TryGet;
      LNext.FFnPut := @P.Put;
      LCurrent.FNext := LNext;
      This.FEntriesLast := LNext;
      Exit(LNext);
    end;
  until False;
end;

procedure EngineRecursiveCacheEntry_DecRef(
  var This: TEngineRecursiveCacheEntry);
begin
  Dec(This.FRefCount);
end;

function EngineRecursiveCacheEntry_TryGet(var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray; var AResult: TFennerData): Boolean;
  assembler; nostackframe;
asm
    mov rax, [rdi + TEngineRecursiveCacheEntry.FFnTryGet]
    jmp rax
end;

procedure EngineRecursiveCacheEntry_Put(var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray; const AValue: TFennerData);
  assembler; nostackframe;
asm
    mov rax, [rdi + TEngineRecursiveCacheEntry.FFnPut]
    jmp rax
end;

end.

