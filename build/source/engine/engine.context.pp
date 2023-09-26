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
unit engine.context;

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
  engine.types,
  engine.consts;

function EngineContext_CreateBlock(
  var AContext: TEngineContext): PEngineContextBlock;

implementation

function EngineContext_CreateBlock(
  var AContext: TEngineContext): PEngineContextBlock;
var
  LCurrent, LNext: PEngineContextBlock;
begin
  LCurrent := AContext.FBlocks;
  if (LCurrent = nil) then
  begin
    LCurrent := AllocMem(SizeOf(TEngineContextBlock));
    LCurrent.FContext := @AContext;
    AContext.FBlocks := LCurrent;
    Exit(LCurrent);
  end;

  repeat
    LNext := LCurrent.FNext;
    if (LNext = nil) then
    begin
      LNext := AllocMem(SizeOf(TEngineContextBlock));
      LNext.FContext := @AContext;
      LCurrent.FNext := LNext;
      Exit(LNext);
    end;
    LCurrent := LNext;
  until False;
end;

end.

