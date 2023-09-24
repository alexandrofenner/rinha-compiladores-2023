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
unit err.classes;

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

type
  Exception = class
  public
    FMessage: LString;
  end;

  { EInternalError }

  EInternalError = class(Exception)
  public
    { cdtor }
    constructor Create(const ACodeLocalId: LString);
  end;

  EParserException = class(Exception)
  public
    Token: PToken;
  end;

  EBuilderException = class(EParserException);

  { EUnexpectedChar }

  EUnexpectedChar = class(EParserException)
  public
    CharValue: AnsiChar;
    CharDisplay: LString;

    { cdtor }
    constructor Create(const AToken: PToken; const AChar: AnsiChar);
  end;

  { EUnexpectedEof }

  EUnexpectedEof = class(EParserException)
  public
    { cdtor }
    constructor Create(const AToken: PToken);
  end;

  { EUnexpectedToken }

  EUnexpectedToken = class(EParserException)
  public
    { cdtor }
    constructor Create(const AToken: PToken);
  end;

  { EFunctionInvalidParamCount }

  EFunctionInvalidParamCount = class(Exception)
  public
    { cdtor }
    constructor Create(const AFunctionName: LString;
      const AReceivedParamCount, AMinExpectedParams,
      AMaxExpectedParams: Integer);
  end;

  { EBuilderUnexpectedEof }

  EBuilderUnexpectedEof = class(EBuilderException)
  public
    { cdtor }
    constructor Create(const AToken: PToken);
    constructor Create2(var ATokenStack: TTokenStack);
  end;

  { EBuilderVariableNameExpected }

  EBuilderVariableNameExpected = class(EBuilderException)
  public
    { cdtor }
    constructor Create(const AToken: PToken);
  end;

  { EBuilderAssignExpected }

  EBuilderAssignExpected = class(EBuilderException)
  public
    { cdtor }
    constructor Create(const AToken: PToken);
  end;

  { EBuilderVariableNotFound }

  EBuilderVariableNotFound = class(EBuilderException)
  public
    { cdtor }
    constructor Create(const AToken: PToken);
  end;

  { ETryLoadFileError }

  ETryLoadFileError = class(Exception)
  public
    FileName: LString;
    OsError: Integer;

    { cdtor }
    constructor Create(const AFileName: LString; const AOsError: Integer);
  end;

  { EIfIsntBoolean }

  EIfIsntBoolean = class(Exception)
  public
    { cdtor }
    constructor Create;
  end;

  { ETryCallNotFunction }

  ETryCallNotFunction = class(Exception)
  public
    { cdtor }
    constructor Create;
  end;

  { EParamIsntArray }

  EParamIsntArray = class(Exception)
  public
    { cdtor }
    constructor Create;
  end;

  { EParamIsntInteger }

  EParamIsntInteger = class(Exception)
  public
    { cdtor }
    constructor Create;
  end;

function HandleException: LString; overload;
function HandleException(const AEObj: TObject): LString; overload;

implementation

uses
  sys.utils,
  scanner.procs,
  err.osmsgs;

function HandleException: LString;
var
  P: PExceptObject;
  LEObj: TObject;
begin
  P := System.RaiseList;
  if (P <> nil) then
    LEObj := P^.FObject
  else
    LEObj := nil;
  Exit(HandleException(LEObj));
end;

function HandleException(const AEObj: TObject): LString;
begin
  if ((AEObj <> nil) and AEObj.InheritsFrom(Exception)) then
      Exit(Exception(AEObj).FMessage);
    Exit('Erro desconhecido');
end;

function TkPosToStr(const ATk: PToken): LString;
begin
  Exit(
    'Posição (' + Int32ToLString(ATk.Position) +
    '). Linha(' + Int32ToLString(ATk.Row) +
    '). Coluna(' + Int32ToLString(ATk.Column) + ')'
  );
end;

function TkPosLenToStr(const ATk: PToken): LString;
begin
  Exit(
    TkPosToStr(ATk) +
    '. Posição(' + Int32ToLString(ATk.Length) + ')'
  );
end;

function TkPosLenSourceToStr(const ATk: PToken): LString;
begin
  Exit(
    TkPosToStr(ATk) +
    '. Posição(' + Int32ToLString(ATk.Length) + ')'#10 +
    Token_GetSource(ATk^)
  );
end;

{ EParamIsntInteger }

constructor EParamIsntInteger.Create;
begin
  FMessage := 'O parâmetro deve ser do tipo "inteiro"';
end;

{ EParamIsntArray }

constructor EParamIsntArray.Create;
begin
  FMessage := 'O parâmetro deve ser do tipo "array"';
end;

{ ETryCallNotFunction }

constructor ETryCallNotFunction.Create;
begin
  FMessage := 'Somente funções podem ser executadas';
end;

{ EIfIsntBoolean }

constructor EIfIsntBoolean.Create;
begin
  FMessage := 'O comando If só pode ser efetuado com expressões boleânicas';
end;

{ ETryLoadFileError }

constructor ETryLoadFileError.Create(const AFileName: LString;
  const AOsError: Integer);
begin
  FileName := AFileName;
  OsError := AOsError;

  FMessage := 'Não foi possível abrir o arquivo ''' + AFileName + '''.'#10 +
    'OsError: ' + Int32ToLString(AOsError) + ' - ' + SysGetOsErrMsg(AOsError);
end;

{ EBuilderVariableNotFound }

constructor EBuilderVariableNotFound.Create(const AToken: PToken);
begin
  Token := AToken;

  FMessage := 'Variável não encontrada ''' +
    AToken.vds + '''. ' + TkPosToStr(AToken);
end;

{ EBuilderAssignExpected }

constructor EBuilderAssignExpected.Create(const AToken: PToken);
begin
  Token := AToken;

  FMessage := 'Esperado "=". ' + TkPosLenSourceToStr(AToken);
end;

{ EBuilderVariableNameExpected }

constructor EBuilderVariableNameExpected.Create(const AToken: PToken);
begin
  Token := AToken;

  FMessage := 'Variável não encontrada ''' +
    AToken.vds + '''. ' + TkPosToStr(AToken);
end;

{ EBuilderUnexpectedEof }

constructor EBuilderUnexpectedEof.Create(const AToken: PToken);
begin
  Token := AToken;

  FMessage := 'Final do código não esperado. ' +
    TkPosToStr(AToken);
end;

constructor EBuilderUnexpectedEof.Create2(var ATokenStack: TTokenStack);
begin
  if (ATokenStack.Count > 0) then
    Create(ATokenStack.DynArray[ATokenStack.Count - 1])
  else
    FMessage := 'Final do código não esperado';
end;

{ EInternalError }

constructor EInternalError.Create(const ACodeLocalId: LString);
begin
  FMessage := 'Erro interno. ' + ACodeLocalId;
end;

{ EUnexpectedToken }

constructor EUnexpectedToken.Create(const AToken: PToken);
begin
  Token := AToken;

  FMessage := 'Token não esperado. ' +
    TkPosToStr(AToken) + #10'Conteúdo: ' +
    Token_GetSource(AToken^);
end;

{ EUnexpectedEof }

constructor EUnexpectedEof.Create(const AToken: PToken);
begin
  Token := AToken;

  FMessage := 'Final do código não esperado. ' +
    TkPosToStr(AToken);
end;

{ EUnexpectedChar }

constructor EUnexpectedChar.Create(const AToken: PToken; const AChar: AnsiChar);
begin
  Token := AToken;

  CharValue := AChar;
  if (AChar >= ' ') and (AChar <> '''') then
    CharDisplay := '''' + WideChar(AChar) + ''''
  else
    CharDisplay := '#(' + Int32ToLString(Ord(AChar)) + ')';

  FMessage := 'Caractere não esperado (' + Int32ToLString(Ord(AChar)) + ' - ' +
    CharDisplay + '). ' + TkPosToStr(AToken);
end;

{ EFunctionInvalidParamCount }

constructor EFunctionInvalidParamCount.Create(const AFunctionName: LString;
  const AReceivedParamCount, AMinExpectedParams, AMaxExpectedParams: Integer);
begin

end;

end.

