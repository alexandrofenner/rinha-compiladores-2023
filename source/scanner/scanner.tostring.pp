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
unit scanner.tostring;

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
  sys.types,
  sys.stringbuilder,
  sys.utils,
  scanner.types;

procedure WriteToken(var SB: TStringBuilder; Tk: PToken);
procedure WriteTokenStack(var SB: TStringBuilder; var tks: TTokenStack);

function TokenStack_ToString(var tks: TTokenStack): LString;

implementation

procedure WriteToken(var SB: TStringBuilder; Tk: PToken);
begin
  case Tk^.Id of
    tk_None: SB.Append('(#none)');
    tk_Identifier: SB.Append(Tk.vds);
    tk_String: SB.Append(QtLString(Tk.vds));
    tk_Integer: SB.Append(Int64ToLString(Tk.vdi));

    tkop_Add: SB.Append('+');
    tkop_Sub: SB.Append('-');
    tkop_Mul: SB.Append('*');
    tkop_Div: SB.Append('/');
    tkop_Rem: SB.Append('%');
    tkop_Eq: SB.Append('==');
    tkop_Neq: SB.Append('!=');
    tkop_Lt: SB.Append('<');
    tkop_Gt: SB.Append('>');
    tkop_Lte: SB.Append('<=');
    tkop_Gte: SB.Append('>=');
    tkop_And: SB.Append('&&');
    tkop_Or: SB.Append('||');
    tkop_Power: SB.Append('**');
    tkop_Fact: SB.Append('!');
    tk_pOpen: SB.Append('(');
    tk_pClose: SB.Append(')');
    tk_Comma: SB.Append(',');
    tk_SemiColon: SB.Append(';');
    tk_Assign: SB.Append('=');
    tk_AssignProc: SB.Append('=>');
    tk_bOpen: SB.Append('{');
    tk_bClose: SB.Append('}');
    tk_rOpen: SB.Append('[');
    tk_rClose: SB.Append(']');
    tk_Fatorial: SB.Append('!');
    tk_Question: SB.Append('?');
    tk_Colon: SB.Append(':');
    tk_Recursive: SB.Append('~');
    tkrw_False: SB.Append(s_False);
    tkrw_True: SB.Append(s_True);
    tkrw_Array: SB.Append('array');
    tkrw_Function: SB.Append('fn');
    tkrw_Let: SB.Append('let');
    tkrw_Set: SB.Append('');
    tkrw_If: SB.Append('if');
    tkrw_Else: SB.Append('else');
    tkrw_While: SB.Append('while');
    tkrw_Print: SB.Append('print');
    tkrw_First: SB.Append('first');
    tkrw_Second: SB.Append('second');
    tkrw_Third: SB.Append('third');
    tkrw_Fourth: SB.Append('fourth');
    tkrw_Fifth: SB.Append('fifth');
    tkrw_Sixth: SB.Append('sixth');
    tkrw_Seventh: SB.Append('seventh');
    tkrw_Eighth: SB.Append('eighth');
    tkrw_Ninth: SB.Append('ninth');
    tkrw_Tenth: SB.Append('tenth');
    tkrw_Array_GetItem: SB.Append('array_item');
    tkrw_Array_GetLength: SB.Append('array_length');
    tkrw_TypeOf: SB.Append('typeof');
    tkrw_Max: SB.Append('max');
    tkrw_Min: SB.Append('min');
    else
      SB.Append('(#unk)');
  end;
end;

procedure WriteTokenStack(var SB: TStringBuilder; var tks: TTokenStack);
var
  i, Count: Integer;
begin
  Count := tks.Count;
  if (Count <= 0) then Exit;

  WriteToken(SB, tks.DynArray[0]);
  for i := 1 to (Count - 1) do
  begin
    SB.Append(' ');
    WriteToken(SB, tks.DynArray[i]);
  end;
end;

function TokenStack_ToString(var tks: TTokenStack): LString;
var
  sb: TStringBuilder;
begin
  sb.Initialize;
  WriteTokenStack(sb, tks);
  Exit(sb.ToString);
end;

end.

