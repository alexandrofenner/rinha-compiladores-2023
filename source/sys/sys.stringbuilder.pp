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
unit sys.stringbuilder;

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
  sys.types;

type

  { TStringBuilder }

  TStringBuilder = record
    Buffer: LString;
    Length: Integer;
    Capacity: Integer;

    procedure Append(const S: LString);
    procedure CheckCapacity(const AMinCapacity: Integer);
    procedure Initialize;
    function ToString: LString;
  end;

implementation

{ TStringBuilder }

procedure TStringBuilder.Append(const S: LString);
var
  i: Integer;
begin
  i := System.Length(S);
  if (i <= 0) then Exit;
  CheckCapacity(i + Length);
  System.Move(Pointer(S)^, Buffer[Length + 1], i);
  Inc(Length, i);
end;

procedure TStringBuilder.CheckCapacity(const AMinCapacity: Integer);
begin
  if (Capacity >= AMinCapacity) then Exit;
  while (Capacity < AMinCapacity) do Inc(Capacity, 1024);
  SetLength(Buffer, Capacity);
end;

procedure TStringBuilder.Initialize;
begin
  Length := 0;
  Capacity := 0;
  Buffer := '';
end;

function TStringBuilder.ToString: LString;
begin
  SetString(Result, PAnsiChar(Buffer), Length);
end;

end.

