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
unit engine.recursivecache_23;

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

function EngineRecursiveCacheEntry_TryGet_23(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
procedure EngineRecursiveCacheEntry_Put_23(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);

implementation

type
  PRecord23 = ^TRecord23;
  TRecord23 = record
    k0: Int64;
    k1: Int64;
    k2: Int64;
    k3: Int64;
    k4: Int64;
    k5: Int64;
    k6: Int64;
    k7: Int64;
    k8: Int64;
    k9: Int64;
    k10: Int64;
    k11: Int64;
    k12: Int64;
    k13: Int64;
    k14: Int64;
    k15: Int64;
    k16: Int64;
    k17: Int64;
    k18: Int64;
    k19: Int64;
    k20: Int64;
    k21: Int64;
    k22: Int64;
    v: Int64;
  end;

function EngineRecursiveCacheEntry_TryGet_23(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  var AResult: TFennerData): Boolean;
var
  i: Integer;
  k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12,
  k13, k14, k15, k16, k17, k18, k19, k20, k21, k22: Int64;
  p: PRecord23;
begin
  if (Args[0].vId <> dttp_Int) then Exit(False);
  if (Args[1].vId <> dttp_Int) then Exit(False);
  if (Args[2].vId <> dttp_Int) then Exit(False);
  if (Args[3].vId <> dttp_Int) then Exit(False);
  if (Args[4].vId <> dttp_Int) then Exit(False);
  if (Args[5].vId <> dttp_Int) then Exit(False);
  if (Args[6].vId <> dttp_Int) then Exit(False);
  if (Args[7].vId <> dttp_Int) then Exit(False);
  if (Args[8].vId <> dttp_Int) then Exit(False);
  if (Args[9].vId <> dttp_Int) then Exit(False);
  if (Args[10].vId <> dttp_Int) then Exit(False);
  if (Args[11].vId <> dttp_Int) then Exit(False);
  if (Args[12].vId <> dttp_Int) then Exit(False);
  if (Args[13].vId <> dttp_Int) then Exit(False);
  if (Args[14].vId <> dttp_Int) then Exit(False);
  if (Args[15].vId <> dttp_Int) then Exit(False);
  if (Args[16].vId <> dttp_Int) then Exit(False);
  if (Args[17].vId <> dttp_Int) then Exit(False);
  if (Args[18].vId <> dttp_Int) then Exit(False);
  if (Args[19].vId <> dttp_Int) then Exit(False);
  if (Args[20].vId <> dttp_Int) then Exit(False);
  if (Args[21].vId <> dttp_Int) then Exit(False);
  if (Args[22].vId <> dttp_Int) then Exit(False);
  k0 := Args[0].vInt;
  k1 := Args[1].vInt;
  k2 := Args[2].vInt;
  k3 := Args[3].vInt;
  k4 := Args[4].vInt;
  k5 := Args[5].vInt;
  k6 := Args[6].vInt;
  k7 := Args[7].vInt;
  k8 := Args[8].vInt;
  k9 := Args[9].vInt;
  k10 := Args[10].vInt;
  k11 := Args[11].vInt;
  k12 := Args[12].vInt;
  k13 := Args[13].vInt;
  k14 := Args[14].vInt;
  k15 := Args[15].vInt;
  k16 := Args[16].vInt;
  k17 := Args[17].vInt;
  k18 := Args[18].vInt;
  k19 := Args[19].vInt;
  k20 := Args[20].vInt;
  k21 := Args[21].vInt;
  k22 := Args[22].vInt;
  for i := 0 to (This.FContentCount - 1) do
  begin
    p := This.FContentArray[i];
    if ((p.k0 = k0) and (p.k1 = k1) and (p.k2 = k2) and (p.k3 = k3)
    and (p.k4 = k4) and (p.k5 = k5) and (p.k6 = k6) and (p.k7 = k7)
    and (p.k8 = k8) and (p.k9 = k9) and (p.k10 = k10) and (p.k11 = k11)
    and (p.k12 = k12) and (p.k13 = k13) and (p.k14 = k14)
    and (p.k15 = k15) and (p.k16 = k16) and (p.k17 = k17)
    and (p.k18 = k18) and (p.k19 = k19) and (p.k20 = k20)
    and (p.k21 = k21) and (p.k22 = k22)) then
    begin
      FennerData_SetAsInteger(AResult, p.v);
      Exit(True);
    end;
  end;
  Exit(False);
end;

procedure EngineRecursiveCacheEntry_Put_23(
  var This: TEngineRecursiveCacheEntry;
  const Args: TFennerDataDynArray;
  const AValue: TFennerData);
var
  p: PRecord23;
begin
  if ((Args[0].vId <> dttp_Int) or
      (Args[1].vId <> dttp_Int) or
      (Args[2].vId <> dttp_Int) or
      (Args[3].vId <> dttp_Int) or
      (Args[4].vId <> dttp_Int) or
      (Args[5].vId <> dttp_Int) or
      (Args[6].vId <> dttp_Int) or
      (Args[7].vId <> dttp_Int) or
      (Args[8].vId <> dttp_Int) or
      (Args[9].vId <> dttp_Int) or
      (Args[10].vId <> dttp_Int) or
      (Args[11].vId <> dttp_Int) or
      (Args[12].vId <> dttp_Int) or
      (Args[13].vId <> dttp_Int) or
      (Args[14].vId <> dttp_Int) or
      (Args[15].vId <> dttp_Int) or
      (Args[16].vId <> dttp_Int) or
      (Args[17].vId <> dttp_Int) or
      (Args[18].vId <> dttp_Int) or
      (Args[19].vId <> dttp_Int) or
      (Args[20].vId <> dttp_Int) or
      (Args[21].vId <> dttp_Int) or
      (Args[22].vId <> dttp_Int) or
      (AValue.vId <> dttp_Int)) then Exit;

  if (This.FContentCount < Length(This.FContentArray)) then
  begin
    GetMem(p, SizeOf(TRecord23));
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
  p.k7 := Args[7].vInt;
  p.k8 := Args[8].vInt;
  p.k9 := Args[9].vInt;
  p.k10 := Args[10].vInt;
  p.k11 := Args[11].vInt;
  p.k12 := Args[12].vInt;
  p.k13 := Args[13].vInt;
  p.k14 := Args[14].vInt;
  p.k15 := Args[15].vInt;
  p.k16 := Args[16].vInt;
  p.k17 := Args[17].vInt;
  p.k18 := Args[18].vInt;
  p.k19 := Args[19].vInt;
  p.k20 := Args[20].vInt;
  p.k21 := Args[21].vInt;
  p.k22 := Args[21].vInt;
  p.v := AValue.vInt;
end;

end.

