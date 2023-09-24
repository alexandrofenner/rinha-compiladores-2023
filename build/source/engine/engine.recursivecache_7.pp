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
unit engine.recursivecache_7;

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

function EngineRecursiveCacheEntry_TryGet_7(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
procedure EngineRecursiveCacheEntry_Put_7(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);

implementation

type
  PRecord7 = ^TRecord7;
  TRecord7 = record
    k0: Int64;
    k1: Int64;
    k2: Int64;
    k3: Int64;
    k4: Int64;
    k5: Int64;
    k6: Int64;
    v: Int64;
  end;

function EngineRecursiveCacheEntry_TryGet_7(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  i: Integer;
  k0, k1, k2, k3, k4, k5, k6: Int64;
  p: PRecord7;
begin
  if (Args[0].vId <> dttp_Int) then Exit(False);
  if (Args[1].vId <> dttp_Int) then Exit(False);
  if (Args[2].vId <> dttp_Int) then Exit(False);
  if (Args[3].vId <> dttp_Int) then Exit(False);
  if (Args[4].vId <> dttp_Int) then Exit(False);
  if (Args[5].vId <> dttp_Int) then Exit(False);
  if (Args[6].vId <> dttp_Int) then Exit(False);
  k0 := Args[0].vInt;
  k1 := Args[1].vInt;
  k2 := Args[2].vInt;
  k3 := Args[3].vInt;
  k4 := Args[4].vInt;
  k5 := Args[5].vInt;
  k6 := Args[6].vInt;
  for i := 0 to (This.FContentCount - 1) do
  begin
    p := This.FContentArray[i];
    if ((p.k0 = k0) and (p.k1 = k1) and (p.k2 = k2) and (p.k3 = k3)
    and (p.k4 = k4) and (p.k5 = k5) and (p.k6 = k6)) then
    begin
      FennerData_SetAsInteger(AResult, p.v);
      Exit(True);
    end;
  end;
  Exit(False);
end;

procedure EngineRecursiveCacheEntry_Put_7(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);
var
  p: PRecord7;
begin
  if ((Args[0].vId <> dttp_Int) or
      (Args[1].vId <> dttp_Int) or
      (Args[2].vId <> dttp_Int) or
      (Args[3].vId <> dttp_Int) or
      (Args[4].vId <> dttp_Int) or
      (Args[5].vId <> dttp_Int) or
      (Args[6].vId <> dttp_Int) or
      (AValue.vId <> dttp_Int)) then Exit;

  if (This.FContentCount < Length(This.FContentArray)) then
  begin
    GetMem(p, SizeOf(TRecord7));
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
  p.k2 := Args[2].vInt;
  p.k3 := Args[3].vInt;
  p.k4 := Args[4].vInt;
  p.k5 := Args[5].vInt;
  p.k6 := Args[6].vInt;
  p.v := AValue.vInt;
end;

end.

