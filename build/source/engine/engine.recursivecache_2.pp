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
  var AResult: TFennerData): Boolean;
var
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

