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
unit scanner.procs;

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
  scanner.types;

function Token_CreateVirtual(const AId: Byte): PToken;

function Token_GetSource(var Token: TToken): LString;

procedure TokenStack_CopyBy(var SubTokenStack, From: TTokenStack;
  const Index, Count: Integer);

procedure TokenStack_Delete(var TokenStack: TTokenStack; Index, Count: Integer);

procedure TokenStack_Exchange(var TokenStack: TTokenStack;
  Index0, Index1: Integer);
procedure TokenStack_Insert(var TokenStack: TTokenStack;
  Index: Integer; const Token: PToken);

procedure TokenStack_Move(var TokenStack: TTokenStack;
  FromIndex, ToIndex: Integer);

procedure Scanner_Initialize(const s: LString);

var
  gvTokens: TTokenStack;

implementation

uses
  scanner.reswords,
  err.classes;

function Scanner_TryRead(var AToken: TToken): Boolean; forward;
procedure Validate_AutoTokens(var ATokens: TTokenStack); forward;
procedure Validate_AutoTokensQuestion(var ATokens: TTokenStack); forward;
procedure Validate_AutoTokens_p_Fn(var ATokens: TTokenStack); forward;

var
  gvSource: PAnsiChar;
  gvCursor: PAnsiChar;
  gvBgLinePos: PAnsiChar;
  gvCurLineId: Integer;
  gvOutOf: PAnsiChar;
  gvToken: PToken;
  gvFreeTokens: PToken;

procedure AllocateNewFreeTokens;
var
  m, n: Pointer;
  r: Integer;
begin
  r := 65536;
  m := AllocMem(r);
  gvFreeTokens := m;
  repeat
    Dec(r, SizeOf(TToken));
    if (r < SizeOf(TToken)) then Break;

    n := Pointer(IntPtr(m) + SizeOf(TToken));
    PToken(m).p := n;

    Dec(r, SizeOf(TToken));
    if (r < SizeOf(TToken)) then Break;

    m := Pointer(IntPtr(n) + SizeOf(TToken));
    PToken(n).p := m;
  until False;
end;

function Token_Create: PToken;
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

function Token_CreateVirtual(const AId: Byte): PToken;
begin
  Result := Token_Create;
  Result.Position := -1;
  Result.Column := -1;
  Result.Row := -1;
  Result.Length := -1;
  Result.Id := AId;
end;

procedure Token_Free(const AToken: PToken);
begin
  AToken.p := gvFreeTokens;
  gvFreeTokens := AToken;
end;

procedure Scanner_ReadTokens;
var
  Tk: PToken;
begin
  if (gvCursor >= gvOutOf) then Exit;
  repeat
    if (gvTokens.Count >= gvTokens.Capacity) then
    begin
      Inc(gvTokens.Capacity, 1024);
      SetLength(gvTokens.DynArray, gvTokens.Capacity);
    end;

    Tk := Token_Create;
    if Scanner_TryRead(Tk^) then
    begin
      gvTokens.DynArray[gvTokens.Count] := Tk;
      Inc(gvTokens.Count);
    end else
    begin
      Token_Free(Tk);
      Break;
    end;
  until False;
end;

function Token_GetSource(var Token: TToken): LString;
begin
  SetString(Result, (gvSource + Token.Position), Token.Length);
end;

procedure TokenStack_CopyBy(var SubTokenStack, From: TTokenStack;
  const Index, Count: Integer);
var
  LCount: Integer;
begin
  LCount := (From.Count - Index);
  if (LCount > Count) then LCount := Count;

  if (LCount > 0) then
  begin
    SetLength(SubTokenStack.DynArray, LCount);
    SubTokenStack.Count := LCount;
    SubTokenStack.Capacity := LCount;
    System.Move(From.DynArray[Index],
      SubTokenStack.DynArray[0], (LCount * SizeOf(PToken)));
  end else
  begin
    SubTokenStack.Count := 0;
    SubTokenStack.Capacity := 0;
    SubTokenStack.DynArray := nil;
  end;
end;

procedure TokenStack_Delete(var TokenStack: TTokenStack; Index, Count: Integer);
begin
  if (Count <= 0) then Exit;

  Dec(TokenStack.Count, Count);
  if (Index >= TokenStack.Count) then Exit;

  System.Move(TokenStack.DynArray[Index + Count],
    TokenStack.DynArray[Index],
    ((TokenStack.Count - Index) * SizeOf(PToken)));
end;

procedure TokenStack_Exchange(var TokenStack: TTokenStack;
  Index0, Index1: Integer);
var
  p: PToken;
begin
  if (Cardinal(Index0) >= Cardinal(TokenStack.Count)) then
    raise EInternalError.Create('50F419E2BA284EF0A64B780ACD027A2B');
  if (Cardinal(Index1) >= Cardinal(TokenStack.Count)) then
    raise EInternalError.Create('6E3D4DCA797B409D8F3B3EBF98108288');

  p := TokenStack.DynArray[Index0];
  TokenStack.DynArray[Index0] := TokenStack.DynArray[Index1];
  TokenStack.DynArray[Index1] := p;
end;

procedure TokenStack_Insert(var TokenStack: TTokenStack;
  Index: Integer; const Token: PToken);
begin
  if (Cardinal(Index) > Cardinal(TokenStack.Count)) then
    raise EInternalError.Create('E3385E784ECC4B9A8E9BFADD2DDD9363');

  if (TokenStack.Count = TokenStack.Capacity) then
  begin
    Inc(TokenStack.Capacity, 32);
    SetLength(TokenStack.DynArray, TokenStack.Capacity);
  end;

  if (Index < TokenStack.Count) then
    System.Move(TokenStack.DynArray[Index], TokenStack.DynArray[Index + 1],
      (TokenStack.Count - Index) * SizeOf(PToken));
  TokenStack.DynArray[Index] := Token;
  Inc(TokenStack.Count);
end;

procedure TokenStack_Move(var TokenStack: TTokenStack;
  FromIndex, ToIndex: Integer);
var
  p: PToken;
begin
  if (Cardinal(FromIndex) >= Cardinal(TokenStack.Count)) then
    raise EInternalError.Create('BA0045DBA8C44B128DC1CD58EA23ADFD');
  if (Cardinal(ToIndex) >= Cardinal(TokenStack.Count)) then
    raise EInternalError.Create('B6CAF415EBDA4903818A01B0DBCF52E6');

  if (FromIndex = ToIndex) then Exit;

  p := TokenStack.DynArray[FromIndex];

  if (FromIndex > ToIndex) then
    System.Move(TokenStack.DynArray[ToIndex], TokenStack.DynArray[ToIndex + 1],
      (FromIndex - ToIndex) * SizeOf(PToken))
  else
    System.Move(TokenStack.DynArray[FromIndex + 1],
      TokenStack.DynArray[FromIndex],
      (ToIndex - FromIndex) * SizeOf(PToken));

  TokenStack.DynArray[ToIndex] := p;
end;

procedure Scanner_Initialize(const s: LString);
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
  Scanner_ReadTokens;
  //Validate_AutoTokensQuestion(gvTokens);
  //Validate_AutoTokens(gvTokens);
  Validate_AutoTokens_p_Fn(gvTokens);
end;

type
  TMyScannerReadFunction = function: Boolean;

const
  sIdChars: TSysCharSet = ['a'..'z', 'A'..'Z', '_', '0'..'9'];

function ThrowUnexpectedChar: Boolean;
var
  LToken: PToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 1;

  raise EUnexpectedChar.Create(LToken, gvCursor^);
end;

procedure ThrowUnexpectedEof;
var
  LToken: PToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 0;

  raise EUnexpectedEof.Create(LToken);
end;

procedure ThrowUnexpectedEofInComment;
var
  LToken: PToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 0;

  raise EUnexpectedEof.Create(LToken);
end;

procedure ThrowUnexpectedEofInString;
var
  LToken: PToken;
begin
  LToken := gvToken;
  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Row := gvCurLineId;
  LToken.Length := 0;

  raise EUnexpectedEof.Create(LToken);
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
  LToken: PToken;
  c: Integer;
  v: Byte;
begin
  LToken := gvToken;

  LCursor := gvCursor;
  LOutOf := gvOutOf;
  LStart := LCursor;
  while ((LCursor < LOutOf) and (LCursor^ in sIdChars)) do Inc(LCursor);

  c := (LCursor - LStart);
  v := AsmTryGetReservedId(LStart, c);
  if (v = 0) then
  begin
    SetString(LToken.vds, LStart, c);
    LToken.Id := tk_Identifier;
  end else
    LToken.Id := v;

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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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

  if (gvCursor^ = '=') then
  begin
    { Not Equal }
    Inc(gvCursor);
    LToken.Id := tkop_Neq;
    Exit(True);
  end;

  LToken.Position := (gvCursor - gvSource);
  LToken.Column := (gvCursor - gvBgLinePos);
  LToken.Length := 1;
  LToken.Id := tkop_Fact;
  Exit(True);
end;

function ReadTkPercentage: Boolean;
var
  LToken: PToken;
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
  LToken: PToken;
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
    raise EUnexpectedChar.Create(LToken, gvCursor^);
  end;
  Inc(gvCursor);

  { And }

  LToken.Id := tkop_And;
  Exit(True);
end;

function ReadTkOpenParanthesis: Boolean;
var
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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

            case LCursor[0] of
              '*':
                begin
                  Inc(LCursor);
                  if ((LCursor <= LOutOf) and (LCursor[0] = '/')) then
                  begin
                    Inc(LCursor);
                    gvCursor := LCursor;
                    Exit(False);
                  end;
                end;
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
                Inc(LCursor);
            end;
          until False;
        end;
    end;

  gvCursor := LCursor;
  gvToken.Id := tkop_Div;
  Exit(True);
end;

function ReadTkColon: Boolean;
var
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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
  LToken: PToken;
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

function Scanner_TryRead(var AToken: TToken): Boolean;
begin
  gvToken := @AToken;
  repeat
    if (gvCursor >= gvOutOf) then Exit(False);
    if MyScannerReadFuncTable[PByte(gvCursor)^] then Exit(True);
  until False;
end;

procedure Validate_AutoTokens(var ATokens: TTokenStack);
label lb_Let, lb_AssignProc, lb_Function, lb_Function_AssignProc;
var
  i, j, p: Integer;
  Tk: PToken;
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
              if (tk.Id in [tkrw_Let, tkrw_Set]) then
              begin
                Inc(i);
                Continue;
              end;
            end;
            TokenStack_Insert(ATokens, (j + 1), Token_CreateVirtual(tkrw_Set));
            Inc(i);
          end;
          Inc(i);
        end;
      tkrw_Let, tkrw_Set:
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
              Tk := Token_CreateVirtual(tk_Assign);
              TokenStack_Insert(ATokens, i, Tk);
            end;
            Inc(i);

            if (i >= ATokens.Count) then Exit;
            Tk := ATokens.DynArray[i];

            if (Tk.Id = tk_AssignProc) then
            begin
              Tk := Token_CreateVirtual(tkrw_Function);
              TokenStack_Insert(ATokens, i, Tk);
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
            TokenStack_Exchange(ATokens, i, (i - 1));
            TokenStack_Insert(ATokens, i, Token_CreateVirtual(tk_Assign));
            TokenStack_Insert(ATokens, (i - 1), Token_CreateVirtual(tkrw_Set));

            j := (i + 3);
            if (j >= ATokens.Count) then Continue;

            Tk := ATokens.DynArray[j];
            if (Tk.Id = tk_pOpen) then
            begin
              i := (j - 1);
              goto lb_Function;
            end;

            Continue;
          end;

          if (Tk.Id = tk_AssignProc) then
          begin
lb_Function_AssignProc: ;
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

            TokenStack_Insert(ATokens, j, Token_CreateVirtual(tk_SemiColon));
            TokenStack_Insert(ATokens, j, Token_CreateVirtual(tk_bClose));
            TokenStack_Insert(ATokens, i, Token_CreateVirtual(tk_bOpen));
            i := j + 2;
            Continue;
          end;

          if (Tk.Id = tk_bOpen) then
          begin
            TokenStack_Insert(ATokens, i, Token_CreateVirtual(tk_AssignProc));
            Inc(i);
            Continue;
          end;

          TokenStack_Insert(ATokens, i, Token_CreateVirtual(tk_AssignProc));
//          Tk := ATokens.DynArray[i];
          goto lb_Function_AssignProc;
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
                          TokenStack_Insert(ATokens, j,
                            Token_CreateVirtual(tkrw_Function));
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

procedure Validate_AutoTokensQuestion(var ATokens: TTokenStack);
var
  i, j, p: Integer;
  Tk: PToken;
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
            if (ATokens.DynArray[j].Id in SetOf_rw_Funcs_AndId) then
            begin
              TokenStack_Insert(ATokens, j, Token_CreateVirtual(tk_pOpen));
              TokenStack_Insert(ATokens, j + 2, Token_CreateVirtual(tk_pClose));
              Inc(i, 2);
            end else
            begin
              Inc(i);
              Continue;
            end;
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
                    TokenStack_Move(ATokens, i, j + 1);
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

procedure Validate_AutoTokens_p_Fn(var ATokens: TTokenStack);
label lbNext;
var
  i, j, b, p: Integer;
  Tk: PToken;
  IdTk: Byte;
  CanRemoveTks: Boolean;
begin
  i := (ATokens.Count - 1);
  while (i > 0) do
  begin
    if ((ATokens.DynArray[i].Id = tk_pClose) and
      (ATokens.DynArray[i - 1].Id = tk_bClose)) then
    begin
      j := (i - 2);
      b := 1;
      p := 1;
      while (j >= 1) do
      begin
        Tk := ATokens.DynArray[j];
        case Tk.Id of
          tk_pOpen: Dec(p);
          tk_bOpen: Dec(b);
          tk_pClose: Inc(p);
          tk_bClose: Inc(b);
          tkrw_Function:
            if ((p = 1) and (b = 0)) then
            begin
              IdTk := ATokens.DynArray[j - 1].Id;
              if (IdTk = tk_pOpen) then
              begin
                if (j >= 2) then
                  case ATokens.DynArray[j - 2].Id of
                    tk_Identifier,
                    tk_bClose,
                    tk_Assign: CanRemoveTks := False;
                    else
                      CanRemoveTks := True;
                  end
                else
                  CanRemoveTks := True;

                if CanRemoveTks then
                begin
                  TokenStack_Delete(ATokens, i, 1);
                  TokenStack_Delete(ATokens, (j - 1), 1);
                end;
                i := (j - 1);
                goto lbNext;
              end else
              begin
                i := (j - 1);
                goto lbNext;
              end;
            end;
        end;
        Dec(j);
      end;
      i := j;
    end else
      Dec(i);
lbNext: ;
  end;
end;

procedure ValidateToken_Is(var AToken: TToken; const AId: Byte);
begin
  if (AToken.Id <> AId) then
    raise EUnexpectedToken.Create(@AToken);
end;

end.

