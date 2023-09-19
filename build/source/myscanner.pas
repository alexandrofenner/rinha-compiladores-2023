(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*                                                                            *)
(******************************************************************************)
unit MyScanner;

{$mode Delphi}{$H+}
{$pointermath on}
{$scopedenums on}
{$r-,i-,o-}
{$warnings off}
{$hints off}
{$notes off}

interface

uses
  MyTypes;

type
  PPMyToken = ^PMyToken;
  PMyToken = ^TMyToken;
  TMyToken = record
  public
    function GetSource: LString;
    function Display: LString;
    function ToString: LString;
  public
    Id: Byte;
    vds: LString;
    case Integer of
      0: (vdi: Int64;

          {
            Position -> Posição do caractere inicial do token
            Column -> Id da coluna
            Row -> Id da linha
            Length -> Quantidade de caracteres
          }
          Position: Integer;
          Column: Integer;
          Row: Integer;
          Length: Integer);
      1: (p: Pointer);
  end;

  TMyTokenStack = record
  public
    DynArray: TArray<PMyToken>;
    Count: Integer;
    Capacity: Integer;

    procedure Delete(const AIndex, ACount: Integer);
    procedure Exchange(const AIndex1, AIndex2: Integer);
    procedure Move(const AFromIndex, AToIndex: Integer);
    procedure CopyBy(var AFrom: TMyTokenStack; const AIndex, ACount: Integer);
    procedure Insert(const AIndex: Integer; const AToken: PMyToken);
    function ToString: LString;
  end;

  TMyScannerState = record
  strict private
    FSource: PAnsiChar;
    FCursor: PAnsiChar;
    FBgLinePos: PAnsiChar;
    FCurLineId: Integer;
    FOutOf: PAnsiChar;
    FToken: PMyToken;
    FStack: TMyTokenStack;
  public
    procedure Backup;
    procedure Restore;
  end;

procedure MyScanner_Initialize(const s: LString);
function TMyToken_CreateVirtual(const AId: Byte): PMyToken;

var
  gvTokens: TMyTokenStack;

implementation

uses
  MyErrs,
  MySysUtils;

function MyScanner_TryRead(var AToken: TMyToken): Boolean; forward;
procedure Validate_AutoTokens(var ATokens: TMyTokenStack); forward;
procedure Validate_AutoTokensQuestion(var ATokens: TMyTokenStack); forward;

var
  gvSource: PAnsiChar;
  gvCursor: PAnsiChar;
  gvBgLinePos: PAnsiChar;
  gvCurLineId: Integer;
  gvOutOf: PAnsiChar;
  gvToken: PMyToken;
  gvFreeTokens: PMyToken;

procedure AllocateNewFreeTokens;
var
  m, n: Pointer;
  r: Integer;
begin
  r := 65536;
  m := AllocMem(r);
  gvFreeTokens := m;
  repeat
    Dec(r, SizeOf(TMyToken));
    if (r < SizeOf(TMyToken)) then Break;

    n := Pointer(IntPtr(m) + SizeOf(TMyToken));
    PMyToken(m).p := n;

    Dec(r, SizeOf(TMyToken));
    if (r < SizeOf(TMyToken)) then Break;

    m := Pointer(IntPtr(n) + SizeOf(TMyToken));
    PMyToken(n).p := m;
  until False;
end;

function TMyToken_Create: PMyToken;
begin
  Result := gvFreeTokens;
  if (Result = nil) then
  begin
    AllocateNewFreeTokens;
    Result := gvFreeTokens;
  end;

  gvFreeTokens := Result.p;
  Result.p := nil;
end;

function TMyToken_CreateVirtual(const AId: Byte): PMyToken;
begin
  Result := TMyToken_Create;
  Result.Position := -1;
  Result.Column := -1;
  Result.Row := -1;
  Result.Length := -1;
  Result.Id := AId;
end;

procedure TMyToken_Free(const AToken: PMyToken);
begin
  AToken.p := gvFreeTokens;
  gvFreeTokens := AToken;
end;

procedure MyScanner_ReadTokens;
var
  Tk: PMyToken;
begin
  if (gvCursor >= gvOutOf) then Exit;

  repeat
    if (gvTokens.Count >= gvTokens.Capacity) then
    begin
      Inc(gvTokens.Capacity, 1024);
      SetLength(gvTokens.DynArray, gvTokens.Capacity);
    end;

    Tk := TMyToken_Create;
    if MyScanner_TryRead(Tk^) then
    begin
      gvTokens.DynArray[gvTokens.Count] := Tk;
      Inc(gvTokens.Count);
    end else
    begin
      TMyToken_Free(Tk);
      Break;
    end;
  until False;
end;

procedure MyScanner_Initialize(const s: LString);
begin
  gvSource := Pointer(s);
  gvCursor := Pointer(s);
  gvBgLinePos := Pointer(s);
  gvCurLineId := 0;
  gvOutOf := (gvCursor + Length(s));
  gvToken := nil;
  gvTokens.Count := 0;
  gvTokens.Capacity := 0;
  gvTokens.DynArray := nil;
  MyScanner_ReadTokens;
  Validate_AutoTokensQuestion(gvTokens);
  Validate_AutoTokens(gvTokens);
end;

type
  TMyScannerReadFunction = function: Boolean;

const
  sIdChars: TSysCharSet = ['a'..'z', 'A'..'Z', '_', '0'..'9'];

function ThrowUnexpectedChar: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  raise EUnexpectedChar.New(LToken, gvCursor^);
end;

procedure ThrowUnexpectedEof;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 0;

  raise EUnexpectedEof.New(LToken);
end;

procedure ThrowUnexpectedEofInComment;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 0;

  raise EUnexpectedEof.New(LToken);
end;

procedure ThrowUnexpectedEofInString;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 0;

  raise EUnexpectedEof.New(LToken);
end;

function TryGetReservedId(p: PAnsiChar; c: Integer; var AId: Byte): Boolean;
begin
  case c of
    2:
      case PWord(p)^ of
        26217{ if }:
          begin
            AId := tkrw_If;
            Exit(True);
          end;
        28262{ fn }:
          begin
            AId := tkrw_Function;
            Exit(True);
          end;
      end;
    3:
      case (PCardinal(p)^ and $ffffff) of
        7628140{ let }:
          begin
            AId := tkrw_Let;
            Exit(True);
          end;
      end;
    4:
      case PCardinal(p)^ of
        1702195828{ true }:
          begin
            AId := tkrw_True;
            Exit(True);
          end;
        1702063205{ else }:
          begin
            AId := tkrw_Else;
            Exit(True);
          end;
      end;
    5:
      case PCardinal(p)^ of
        1953391988{ tent }:
          if (p[4] = 'h') then
          begin
            AId := tkrw_Tenth;
            Exit(True);
          end;
        1953393006{ nint }:
          if (p[4] = 'h') then
          begin
            AId := tkrw_Ninth;
            Exit(True);
          end;
        1954048371{ sixt }:
          if (p[4] = 'h') then
          begin
            AId := tkrw_Sixth;
            Exit(True);
          end;
        1952868710{ fift }:
          if (p[4] = 'h') then
          begin
            AId := tkrw_Fifth;
            Exit(True);
          end;
        1936482662{ fals }:
          if (p[4] = 'e') then
          begin
            AId := tkrw_False;
            Exit(True);
          end;
        1936877926{ firs }:
          if (p[4] = 't') then
          begin
            AId := tkrw_First;
            Exit(True);
          end;
        1919510644{ thir }:
          if (p[4] = 'd') then
          begin
            AId := tkrw_Third;
            Exit(True);
          end;
        1852404336{ prin }:
          if (p[4] = 't') then
          begin
            AId := tkrw_Print;
            Exit(True);
          end;
        1634890337{ arra }:
          if (p[4] = 'y') then
          begin
            AId := tkrw_Array;
            Exit(True);
          end;
      end;
    6:
      case PCardinal(p)^ of
        1751607653: { eigh }
          if (PWord(p + 4)^ = 26740{ th }) then
          begin
            AId := tkrw_Eighth;
            Exit(True);
          end;
        1868785011: { seco }
          if (PWord(p + 4)^ = 25710{ nd }) then
          begin
            AId := tkrw_Second;
            Exit(True);
          end;
        1920298854: { four }
          if (PWord(p + 4)^ = 26740{ th }) then
          begin
            AId := tkrw_Fourth;
            Exit(True);
          end;
      end;
    7:
      case PCardinal(p)^ of
        1702258035: { seve }
          case PCardinal(p + 3)^ of
            1752460901: { + nth }
              begin
                AId := tkrw_Seventh;
                Exit(True);
              end;
          end;
      end;

  end;

  Exit(False);
end;

function SkipWhiteSpaces: Boolean;
var
  LCursor, LOutOf: PAnsiChar;
begin
  LCursor := gvCursor;
  LOutOf := gvOutOf;
  if ((LCursor >= LOutOf) or (LCursor^ > ' ')) then Exit(False);

  while (LCursor < LOutOf) do
    case LCursor^ of
      #0..#9,#11,#12,#14..#32: Inc(LCursor);
      #10:
        begin
          Inc(LCursor);
          gvBgLinePos := LCursor;
          Inc(gvCurLineId);
        end;
      #13:
        begin
          Inc(LCursor);
          if ((LCursor < LOutOf) and (LCursor^ = #10)) then Inc(LCursor);
          gvBgLinePos := LCursor;
          Inc(gvCurLineId);
        end;
      else
        Break;
    end;

  gvCursor := LCursor;
  Exit(False);
end;

function ReadTkIdentifier: Boolean;
var
  LStart, LCursor, LOutOf: PAnsiChar;
  LToken: PMyToken;
  c: Integer;
begin
  LToken := gvToken;

  LCursor := gvCursor;
  LOutOf := gvOutOf;
  LStart := LCursor;
  while ((LCursor < LOutOf) and (LCursor^ in sIdChars)) do Inc(LCursor);

  c := (LCursor - LStart);
  if (not TryGetReservedId(LStart, c, LToken.Id)) then
  begin
    SetString(LToken.vds, LStart, c);
    LToken.Id := tk_Identifier;
  end;

  LToken.Position := (LStart - gvSource);
  LToken.Column := (LStart - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := (LCursor - LStart);

  gvCursor := LCursor;
  Exit(True);
end;

function ReadTkInteger: Boolean;
var
  LStart, LCursor, LOutOf: PAnsiChar;
  LToken: PMyToken;
  i: Int64;
  b: Byte;
begin
  LToken := gvToken;

  LCursor := gvCursor;
  LOutOf := gvOutOf;
  LStart := LCursor;

  i := 0;
  while (LCursor < LOutOf) do
  begin
    b := (Byte(LCursor^) - Byte('0'));
    if (b > 9) then Break;
    i := (i * 10) + b;
    Inc(LCursor);
  end;

  LToken.vdi := i;
  LToken.Id := tk_Integer;

  LToken.Position := (LStart - gvSource);
  LToken.Column := (LStart - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := (LCursor - LStart);

  gvCursor := LCursor;
  Exit(True);
end;

function ReadTkString: Boolean;
var
  LStart, LCursor, LOutOf: PAnsiChar;
  LToken: PMyToken;
begin
  LToken := gvToken;

  LCursor := gvCursor;
  LOutOf := gvOutOf;

  LToken.Position := (LCursor - gvSource);
  LToken.Column := (LCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;

  Inc(LCursor);
  LStart := LCursor;

  repeat
    if (LCursor >= LOutOf) then
      ThrowUnexpectedEofInString;

    if (LCursor^ = '"') then
    begin
      SetString(LToken.vds, LStart, (LCursor - LStart));
      LToken.Id := tk_String;
      Inc(LCursor);
      LToken.Length := ((LCursor - gvSource) - LToken.Position);

      gvCursor := LCursor;
      Exit(True);
    end;

    Inc(LCursor);
  until False;
end;

function ReadTkExclMark: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;

  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 2;

  Inc(gvCursor);
  if (gvCursor >= gvOutOf) then
  begin
    LToken.Position := (gvCursor - gvSource);
    LToken.Column := (gvCursor - gvBgLinePos);
    LToken.Length := 0;

    ThrowUnexpectedEof;
  end;

  if (gvCursor^ <> '=') then
  begin
    LToken.Position := (gvCursor - gvSource);
    LToken.Column := (gvCursor - gvBgLinePos);
    LToken.Length := 1;
    raise EUnexpectedChar.New(LToken, gvCursor^);
  end;
  Inc(gvCursor);

  { Not Equal }

  gvToken.Id := tkop_Neq;

  Exit(True);
end;

function ReadTkPercentage: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  gvToken.Id := tkop_Rem;
  Exit(True);
end;

function ReadTkAmpersand: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 2;

  Inc(gvCursor);
  if (gvCursor >= gvOutOf) then
    ThrowUnexpectedEof;

  if (gvCursor^ <> '&') then
  begin
    LToken.Position := (gvCursor - gvSource);
    LToken.Column := (gvCursor - gvBgLinePos);
    LToken.Length := 1;
    raise EUnexpectedChar.New(LToken, gvCursor^);
  end;
  Inc(gvCursor);

  { And }

  LToken.Id := tkop_And;
  Exit(True);
end;

function ReadTkOpenParanthesis: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  LToken.Id := tk_pOpen;
  Exit(True);
end;

function ReadTkCloseParanthesis: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  LToken.Id := tk_pClose;
  Exit(True);
end;

function ReadTkAsterisk: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  Inc(gvCursor);

  if ((gvCursor < gvOutOf) and (gvCursor^ = '*')) then
  begin
    Inc(gvCursor);
    LToken.Id := tkop_Power;
    LToken.Length := 2;
    Exit(True);
  end;

  LToken.Id := tkop_Mul;
  LToken.Length := 1;
  Exit(True);
end;

function ReadTkAdd: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  LToken.Id := tkop_Add;
  Exit(True);
end;

function ReadTkComma: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  LToken.Id := tk_Comma;
  Exit(True);
end;

function ReadTkSubtract: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  LToken.Id := tkop_Sub;
  Exit(True);
end;

function ReadTkDiv: Boolean;
var
  LToken: PMyToken;
  LCursor, LOutOf: PAnsiChar;
begin
  LCursor := gvCursor;
  LOutOf := gvOutOf;

  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(LCursor);
  if (LCursor < LOutOf) then
    case LCursor[0] of
      '/':
        begin
          Inc(LCursor, 2);
          while (LCursor < LOutOf) do
            case LCursor[0] of
              #10, #13: Break;
              else
                Inc(LCursor);
            end;
          gvCursor := LCursor;
          Exit(False);
        end;
      '*':
        begin
          Inc(LCursor, 2);
          repeat
            if (LCursor >= LOutOf) then
              ThrowUnexpectedEofInComment;

            if (LCursor[0] = '*') then
            begin
              Inc(LCursor);
              if ((LCursor <= LOutOf) and (LCursor[0] = '/')) then
              begin
                Inc(LCursor);
                gvCursor := LCursor;
                Exit(False);
              end;
            end else
              Inc(LCursor);
          until False;
        end;
    end;

  gvCursor := LCursor;
  gvToken.Id := tkop_Sub;
  Exit(True);
end;

function ReadTkColon: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  LToken.Id := tk_Colon;
  Exit(True);
end;

function ReadTkSemiColon: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  LToken.Id := tk_SemiColon;
  Exit(True);
end;

function ReadTkLess: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);

  if ((gvCursor < gvOutOf) and (gvCursor^ = '=')) then
  begin
    { Less Than Or Equal }
    Inc(gvCursor);
    LToken.Id := tkop_Lte;
    Exit(True);
  end;

  { Less Than }
  LToken.Id := tkop_Lt;
  Exit(True);
end;

function ReadTkEqual: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;

  Inc(gvCursor);

  if (gvCursor < gvOutOf) then
    case gvCursor^ of
      '=':
        begin
          { Less Than Or Equal }
          Inc(gvCursor);
          LToken.Id := tkop_Eq;
          LToken.Length := 2;
          Exit(True);
        end;
      '>':
        begin
          { => }
          Inc(gvCursor);
          LToken.Id := tk_AssignProc;
          LToken.Length := 2;
          Exit(True);
        end;
    end;

  { Assign }
  LToken.Id := tk_Assign;
  LToken.Length := 1;
  Exit(True);
end;

function ReadTkGreater: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;

  Inc(gvCursor);

  if ((gvCursor < gvOutOf) and (gvCursor^ = '=')) then
  begin
    { Greater Than Or Equal }
    Inc(gvCursor);
    LToken.Id := tkop_Gte;
    LToken.Length := 2;
    Exit(True);
  end;

  { Greater Than }
  LToken.Id := tkop_Gt;
  LToken.Length := 1;
  Exit(True);
end;

function ReadTkQuestion: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);
  LToken.Id := tk_Question;
  Exit(True);
end;

function ReadTkBlockOpen: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);
  LToken.Id := tk_bOpen;
  Exit(True);
end;

function ReadTkBlockClose: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);
  LToken.Id := tk_bClose;
  Exit(True);
end;

function ReadTkRecursive: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);
  LToken.Id := tk_Recursive;
  Exit(True);
end;

function ReadTkROpen: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);
  LToken.Id := tk_rOpen;
  Exit(True);
end;

function ReadTkRClose: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  Inc(gvCursor);
  LToken.Id := tk_rClose;
  Exit(True);
end;

function ReadTkPipe: Boolean;
var
  LToken: PMyToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 2;

  Inc(gvCursor);
  if (gvCursor >= gvOutOf) then
    ThrowUnexpectedEof;
  if (gvCursor^ <> '|') then
    ThrowUnexpectedChar;

  Inc(gvCursor);
  LToken.Id := tkop_Or;
  Exit(True);
end;

const
  MyScannerReadFuncTable: array[Byte] of TMyScannerReadFunction = (
    SkipWhiteSpaces,          //    0x00
    SkipWhiteSpaces,          //    0x01
    SkipWhiteSpaces,          //    0x02
    SkipWhiteSpaces,          //    0x03
    SkipWhiteSpaces,          //    0x04
    SkipWhiteSpaces,          //    0x05
    SkipWhiteSpaces,          //    0x06
    SkipWhiteSpaces,          //    0x07
    SkipWhiteSpaces,          //    0x08
    SkipWhiteSpaces,          //    0x09
    SkipWhiteSpaces,          //    0x0a
    SkipWhiteSpaces,          //    0x0b
    SkipWhiteSpaces,          //    0x0c
    SkipWhiteSpaces,          //    0x0d
    SkipWhiteSpaces,          //    0x0e
    SkipWhiteSpaces,          //    0x0f
    SkipWhiteSpaces,          //    0x10
    SkipWhiteSpaces,          //    0x11
    SkipWhiteSpaces,          //    0x12
    SkipWhiteSpaces,          //    0x13
    SkipWhiteSpaces,          //    0x14
    SkipWhiteSpaces,          //    0x15
    SkipWhiteSpaces,          //    0x16
    SkipWhiteSpaces,          //    0x17
    SkipWhiteSpaces,          //    0x18
    SkipWhiteSpaces,          //    0x19
    SkipWhiteSpaces,          //    0x1a
    SkipWhiteSpaces,          //    0x1b
    SkipWhiteSpaces,          //    0x1c
    SkipWhiteSpaces,          //    0x1d
    SkipWhiteSpaces,          //    0x1e
    SkipWhiteSpaces,          //    0x1f
    SkipWhiteSpaces,          //    0x20
    ReadTkExclMark,           //    !
    ReadTkString,             //    "
    ThrowUnexpectedChar,      //    #
    ThrowUnexpectedChar,      //    $
    ReadTkPercentage,         //    %
    ReadTkAmpersand,          //    &
    ThrowUnexpectedChar,      //    '
    ReadTkOpenParanthesis,    //    (
    ReadTkCloseParanthesis,   //    )
    ReadTkAsterisk,           //    *
    ReadTkAdd,                //    +
    ReadTkComma,              //    ,
    ReadTkSubtract,           //    -
    ThrowUnexpectedChar,      //    .
    ReadTkDiv,                //    /
    ReadTkInteger,            //    0
    ReadTkInteger,            //    1
    ReadTkInteger,            //    2
    ReadTkInteger,            //    3
    ReadTkInteger,            //    4
    ReadTkInteger,            //    5
    ReadTkInteger,            //    6
    ReadTkInteger,            //    7
    ReadTkInteger,            //    8
    ReadTkInteger,            //    9
    ReadTkColon,              //    :
    ReadTkSemiColon,          //    ;
    ReadTkLess,               //    <
    ReadTkEqual,              //    =
    ReadTkGreater,            //    >
    ReadTkQuestion,           //    ?
    ThrowUnexpectedChar,      //    @
    ReadTkIdentifier,         //    A
    ReadTkIdentifier,         //    B
    ReadTkIdentifier,         //    C
    ReadTkIdentifier,         //    D
    ReadTkIdentifier,         //    E
    ReadTkIdentifier,         //    F
    ReadTkIdentifier,         //    G
    ReadTkIdentifier,         //    H
    ReadTkIdentifier,         //    I
    ReadTkIdentifier,         //    J
    ReadTkIdentifier,         //    K
    ReadTkIdentifier,         //    L
    ReadTkIdentifier,         //    M
    ReadTkIdentifier,         //    N
    ReadTkIdentifier,         //    O
    ReadTkIdentifier,         //    P
    ReadTkIdentifier,         //    Q
    ReadTkIdentifier,         //    R
    ReadTkIdentifier,         //    S
    ReadTkIdentifier,         //    T
    ReadTkIdentifier,         //    U
    ReadTkIdentifier,         //    V
    ReadTkIdentifier,         //    W
    ReadTkIdentifier,         //    X
    ReadTkIdentifier,         //    Y
    ReadTkIdentifier,         //    Z
    ReadTkROpen,              //    [
    ThrowUnexpectedChar,      //    \
    ReadTkRClose,             //    ]
    ThrowUnexpectedChar,      //    ^
    ReadTkIdentifier,         //    _
    ThrowUnexpectedChar,      //    `
    ReadTkIdentifier,         //    a
    ReadTkIdentifier,         //    b
    ReadTkIdentifier,         //    c
    ReadTkIdentifier,         //    d
    ReadTkIdentifier,         //    e
    ReadTkIdentifier,         //    f
    ReadTkIdentifier,         //    g
    ReadTkIdentifier,         //    h
    ReadTkIdentifier,         //    i
    ReadTkIdentifier,         //    j
    ReadTkIdentifier,         //    k
    ReadTkIdentifier,         //    l
    ReadTkIdentifier,         //    m
    ReadTkIdentifier,         //    n
    ReadTkIdentifier,         //    o
    ReadTkIdentifier,         //    p
    ReadTkIdentifier,         //    q
    ReadTkIdentifier,         //    r
    ReadTkIdentifier,         //    s
    ReadTkIdentifier,         //    t
    ReadTkIdentifier,         //    u
    ReadTkIdentifier,         //    v
    ReadTkIdentifier,         //    w
    ReadTkIdentifier,         //    x
    ReadTkIdentifier,         //    y
    ReadTkIdentifier,         //    z
    ReadTkBlockOpen,          //    {
    ReadTkPipe,               //    |
    ReadTkBlockClose,         //    }
    ReadTkRecursive,          //    ~
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar,
    ThrowUnexpectedChar, ThrowUnexpectedChar, ThrowUnexpectedChar);

function MyScanner_TryRead(var AToken: TMyToken): Boolean;
begin
  gvToken := @AToken;
  repeat
    if (gvCursor >= gvOutOf) then Exit(False);
    if MyScannerReadFuncTable[PByte(gvCursor)^] then Exit(True);
  until False;
end;

procedure Validate_AutoTokens(var ATokens: TMyTokenStack);
label lb_Let, lb_AssignProc, lb_Function;
var
  i, j, p: Integer;
  Tk: PMyToken;
begin
  i := 0;
  while (i < ATokens.Count) do
  begin
    Tk := ATokens.DynArray[i];
    case Tk.Id of
      tk_Assign:
        begin
          j := (i - 1);
          if (j < 0) then
          begin
            Inc(i);
            Continue;
          end;
          Tk := ATokens.DynArray[j];
          if (Tk.Id in SetOf_rw_Funcs_AndId) then
          begin
            Dec(j);
            if (j >= 0) then
            begin
              Tk := ATokens.DynArray[j];
              if (tk.Id = tkrw_Let) then
              begin
                Inc(i);
                Continue;
              end;
            end;
            ATokens.Insert((j + 1), TMyToken_CreateVirtual(tkrw_Let));
            Inc(i);
          end;
          Inc(i);
        end;
      tkrw_Let:
        begin
lb_Let: ;
          Inc(i);
          if (i >= ATokens.Count) then Exit;
          Tk := ATokens.DynArray[i];

          if (Tk.Id in SetOf_rw_Funcs_AndId) then
          begin
            Inc(i);
            if (i >= ATokens.Count) then Exit;

            Tk := ATokens.DynArray[i];
            if (Tk.Id <> tk_Assign) then
            begin
              Tk := TMyToken_CreateVirtual(tk_Assign);
              ATokens.Insert(i, Tk);
            end;
            Inc(i);

            if (i >= ATokens.Count) then Exit;
            Tk := ATokens.DynArray[i];

            if (Tk.Id = tk_AssignProc) then
            begin
              Tk := TMyToken_CreateVirtual(tkrw_Function);
              ATokens.Insert(i, Tk);
            end;
          end;
        end;
      tkrw_Function:
        begin
lb_Function:;
          p := 0;

          Inc(i);
          if (i >= ATokens.Count) then Exit;
          Tk := ATokens.DynArray[i];

          if (Tk.Id = tk_pOpen) then
          begin
            Inc(p);
            repeat
              Inc(i);
              if (i >= ATokens.Count) then Exit;
              Tk := ATokens.DynArray[i];
              case Tk.Id of
                tk_pOpen: Inc(p);
                tk_pClose:
                  begin
                    Dec(p);
                    if (p = 0) then
                    begin
                      Inc(i);
                      if (i >= ATokens.Count) then Exit;
                      Tk := ATokens.DynArray[i];
                      Break;
                    end;
                  end;
              end;
            until False;
          end else
          if (Tk.Id in SetOf_rw_Funcs_AndId) then
          begin
            ATokens.Exchange(i, (i - 1));
            ATokens.Insert(i, TMyToken_CreateVirtual(tk_Assign));
            ATokens.Insert(i - 1, TMyToken_CreateVirtual(tkrw_Let));
            Continue;
          end;

          if (Tk.Id = tk_AssignProc) then
          begin
            Inc(i);
            if (i >= ATokens.Count) then Exit;

            Tk := ATokens.DynArray[i];
            if (Tk.Id = tk_bOpen) then Continue;

            j := (i + 1);
            while (j < ATokens.Count) do
              if (ATokens.DynArray[j].Id = tk_SemiColon) then
              begin
                Inc(j);
                Break;
              end else
                Inc(j);

            ATokens.Insert(j, TMyToken_CreateVirtual(tk_SemiColon));
            ATokens.Insert(j, TMyToken_CreateVirtual(tk_bClose));
            ATokens.Insert(i, TMyToken_CreateVirtual(tk_bOpen));
            i := j + 2;
            Continue;
          end;

          if (Tk.Id = tk_bOpen) then
          begin
            ATokens.Insert(i, TMyToken_CreateVirtual(tk_AssignProc));
            Inc(i);
            Continue;
          end;

          Inc(i);
        end;
      tk_AssignProc:
        begin
lb_AssignProc: ;
          if (i > 0) then
          begin
            Tk := ATokens.DynArray[i - 1];
            if (Tk.Id = tk_pClose) then
            begin
              p := 1;
              j := (i - 2);
              repeat
                if (j < 0) then Break;
                Tk := ATokens.DynArray[j];
                case Tk.Id of
                  tk_pClose: Inc(p);
                  tk_pOpen:
                    begin
                      Dec(p);
                      if (p = 0) then
                      begin
                        Dec(j);
                        if (j < 0) then Break;
                        Tk := ATokens.DynArray[j];
                        if (Tk.Id in SetOf_rw_Funcs_AndId) then
                        begin
                          ATokens.Insert(j, TMyToken_CreateVirtual(tkrw_Function));
                          i := j;
                          goto lb_Function;
                        end;
                      end;
                    end;
                end;
                Dec(j);
              until False;
              Inc(i);
              Continue;
            end;
          end;
          Inc(i);
        end;
      else
        Inc(i);
    end;
  end;
end;

procedure Validate_AutoTokensQuestion(var ATokens: TMyTokenStack);
var
  i, j, p: Integer;
  Tk: PMyToken;
begin
  i := 0;
  while (i < ATokens.Count) do
    case ATokens.DynArray[i].Id of
      tk_Question:
        begin
          j := (i - 1);
          if (j < 0) then
          begin
            Inc(i);
            Continue;
          end;

          if (ATokens.DynArray[j].Id <> tk_pClose) then
          begin
            Inc(i);
            Continue;
          end;

          p := 1;
          Dec(j);

          while (j >= 0) do
          begin
            Tk := ATokens.DynArray[j];
            case Tk.Id of
              tk_pOpen:
                begin
                  Dec(j);
                  Dec(p);
                  if (p = 0) then
                  begin
                    Tk := ATokens.DynArray[i];
                    Tk.Id := tkrw_If;
                    ATokens.Move(i, j + 1);
                    Break;
                  end;
                end;
              tk_pClose:
                begin
                  Inc(p);
                  Dec(j);
                end;
              else
                Dec(j);
            end;
          end;
        end;
      tk_Colon:
        begin
          ATokens.DynArray[i].Id := tkrw_Else;
          Inc(i);
        end;
      else
        Inc(i);
    end;
end;

procedure ValidateToken_Is(var AToken: TMyToken; const AId: Byte);
begin
  if (AToken.Id <> AId) then
    raise EUnexpectedToken.New(@AToken);
end;

{ TMyToken }

function TMyToken.Display: LString;
begin
  Exit(
    'Id(' + Int32ToLString(Id) + '). Pos(' +
    Int32ToLString(Position) + '). Col(' +
    Int32ToLString(Column) + '). Row(' +
    Int32ToLString(Row) + '). Len(' +
    Int32ToLString(Length) + '). ' + GetSource
  );
end;

function TMyToken.GetSource: LString;
begin
  SetString(Result, (gvSource + Position), Length);
end;

function TMyToken.ToString: LString;
begin
  case Id of
    tk_None: Exit('');
    tk_Identifier: Exit(vds);
    tk_String: Exit('"' + vds + '"');
    tk_Integer: Exit(Int64ToLString(vdi));
    tkop_Add: Exit('+');
    tkop_Sub: Exit('-');
    tkop_Mul: Exit('*');
    tkop_Div: Exit('/');
    tkop_Rem: Exit('%');
    tkop_Eq: Exit('==');
    tkop_Neq: Exit('!=');
    tkop_Lt: Exit('<');
    tkop_Gt: Exit('>');
    tkop_Lte: Exit('<=');
    tkop_Gte: Exit('>=');
    tkop_And: Exit('&&');
    tkop_Or: Exit('||');
    tkop_Power: Exit('**');
    tk_pOpen: Exit('(');
    tk_pClose: Exit(')');
    tk_Comma: Exit(',');
    tk_SemiColon: Exit(';');
    tk_Assign: Exit('=');
    tk_AssignProc: Exit('=>');
    tk_bOpen: Exit('{');
    tk_bClose: Exit('}');
    tk_rOpen: Exit('[');
    tk_rClose: Exit(']');
    tk_Fatorial: Exit('!');
    tk_Question: Exit('?');
    tk_Colon: Exit(':');
    tk_Recursive: Exit('~');

    tkrw_False: Exit(sFalse);
    tkrw_True: Exit(sTrue);
    tkrw_Array: Exit(sArray);
    tkrw_Function: Exit('fn');
    tkrw_Let: Exit('let');
    tkrw_If: Exit('if');
    tkrw_Else: Exit('else');
    tkrw_Print..tkrw_Array_GetLength: Exit(sPrints[Id]);
    else
      Exit('(#unk#)');
  end;
end;

{ TMyTokenStack }

procedure TMyTokenStack.CopyBy(var AFrom: TMyTokenStack;
  const AIndex, ACount: Integer);
begin
  if (ACount > 0) then
  begin
    SetLength(DynArray, ACount);
    Count := ACount;
    Capacity := ACount;
    System.Move(AFrom.DynArray[AIndex],
      DynArray[0], (ACount * SizeOf(PMyToken)));
  end else
  begin
    Count := 0;
    Capacity := 0;
    DynArray := nil;
  end;
end;

procedure TMyTokenStack.Delete(const AIndex, ACount: Integer);
begin
  if (ACount <= 0) then Exit;

  Dec(Count, ACount);
  if (AIndex < Count) then
    System.Move(DynArray[AIndex + ACount],
      DynArray[AIndex], (Count * Sizeof(PMyToken)));
end;

procedure TMyTokenStack.Exchange(const AIndex1, AIndex2: Integer);
var
  p: PMyToken;
begin
  if (Cardinal(AIndex1) >= Cardinal(Count)) then
    raise EInternalError.Create('50F419E2BA284EF0A64B780ACD027A2B');
  if (Cardinal(AIndex2) >= Cardinal(Count)) then
    raise EInternalError.Create('6E3D4DCA797B409D8F3B3EBF98108288');

  p := DynArray[AIndex1];
  DynArray[AIndex1] := DynArray[AIndex2];
  DynArray[AIndex2] := p;
end;

procedure TMyTokenStack.Insert(const AIndex: Integer; const AToken: PMyToken);
begin
  if (Cardinal(AIndex) > Cardinal(Count)) then
    raise EInternalError.Create('E3385E784ECC4B9A8E9BFADD2DDD9363');

  if (Count = Capacity) then
  begin
    Inc(Capacity, 32);
    SetLength(DynArray, Capacity);
  end;

  if (AIndex < Count) then
    System.Move(DynArray[AIndex], DynArray[AIndex + 1],
      (Count - AIndex) * SizeOf(PMyToken));
  DynArray[AIndex] := AToken;
  Inc(Count);
end;

procedure TMyTokenStack.Move(const AFromIndex, AToIndex: Integer);
var
  p: PMyToken;
begin
  if (Cardinal(AFromIndex) >= Cardinal(Count)) then
    raise EInternalError.Create('BA0045DBA8C44B128DC1CD58EA23ADFD');
  if (Cardinal(AToIndex) >= Cardinal(Count)) then
    raise EInternalError.Create('B6CAF415EBDA4903818A01B0DBCF52E6');

  if (AFromIndex = AToIndex) then Exit;

  p := DynArray[AFromIndex];

  if (AFromIndex > AToIndex) then
    System.Move(DynArray[AToIndex], DynArray[AToIndex + 1],
      (AFromIndex - AToIndex) * SizeOf(PMyToken))
  else
    System.Move(DynArray[AFromIndex + 1], DynArray[AFromIndex],
      (AToIndex - AFromIndex) * SizeOf(PMyToken));

  DynArray[AToIndex] := p;
end;

function TMyTokenStack.ToString: LString;
var
  i: Integer;
begin
  if (Count <= 0) then Exit('');

  Result := DynArray[0].ToString;
  for i := 1 to (Count - 1) do
    Result := Result + ' ' + DynArray[i].ToString;
end;

{ TMyScannerState }

procedure TMyScannerState.Backup;
begin
  FSource := gvSource;
  FCursor := gvCursor;
  FBgLinePos := gvBgLinePos;
  FCurLineId := gvCurLineId;
  FOutOf := gvOutOf;
  FToken := gvToken;
  FStack := gvTokens;
end;

procedure TMyScannerState.Restore;
begin
  gvSource := FSource;
  gvCursor := FCursor;
  gvBgLinePos := FBgLinePos;
  gvCurLineId := FCurLineId;
  gvOutOf := FOutOf;
  gvToken := FToken;
  gvTokens := FStack;
end;

end.
