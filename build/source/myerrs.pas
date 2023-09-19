(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*                                                                            *)
(******************************************************************************)
unit MyErrs;

{$mode Delphi}{$H+}
{$pointermath on}
{$scopedenums on}

interface

uses
  MyTypes,
  MyScanner;

type
  Exception = class(TObject)
  public
    FMessage: LString;
  end;

  EParserException = class(Exception)
  public
    Token: PMyToken;
  end;

  EUnexpectedChar = class(EParserException)
  public
    CharValue: AnsiChar;
    CharDisplay: UString;

    { cdtor }
    constructor New(const AToken: PMyToken; const AChar: AnsiChar);
  end;

  EUnexpectedEof = class(EParserException)
  public
    { cdtor }
    constructor New(const AToken: PMyToken);
  end;

  EUnexpectedToken = class(EParserException)
  public
    { cdtor }
    constructor New(const AToken: PMyToken);
  end;

  EBuilderException = class(EParserException);

  EBuilderVariableNotFound = class(EBuilderException)
  public
    { cdtor }
    constructor New(const AToken: PMyToken);
  end;

  EBuilderUnexpectedEof = class(EBuilderException)
  public
    { cdtor }
    constructor New(const AToken: PMyToken);
    constructor New2(var ATokenStack: TMyTokenStack);
  end;

  EBuilderVariableNameExpected = class(EBuilderException)
  public
    { cdtor }
    constructor New(const AToken: PMyToken);
  end;

  EBuilderAssignExpected = class(EBuilderException)
  public
    { cdtor }
    constructor New(const AToken: PMyToken);
  end;

  EBuilderParamAlreadyDeclared = class(EBuilderException)
  public
    { cdtor }
    constructor New(const AToken: PMyToken);
  end;

  EBuilderVarIsntFunction = class(EBuilderException)
  public
    { cdtor }
    constructor New(const AToken: PMyToken);
  end;

  ETryLoadFileError = class(Exception)
  public
    FileName: LString;
    OsError: Integer;

    { cdtor }
    constructor Create(const AFileName: LString; const AOsError: Integer);
  end;

  EParamIsntArray = class(Exception)
  public
    InvMethodName: LString;
    ParamIndex: Integer;

    { cdtor }
    constructor Create(const AInvMethodName: LString;
      const AParamIndex: Integer);
  end;

  EFunctionInvalidParamCount = class(Exception)
  public
    FunctionName: LString;
    ReceivedParamCount: Integer;
    MinParamCount: Integer;
    MaxParamCount: Integer;

    { cdtor }
    constructor Create(const AFunctionName: LString;
      const AReceivedParamCount, AMinParamCount, AMaxParamCount: Integer);
  end;

  EInternalError = class(Exception)
  public
    { cdtor }
    constructor Create(const ACodeLocalId: LString);
  end;

function HandleException: LString; overload;
function HandleException(const AEObj: TObject): LString; overload;

implementation

uses
  MySysUtils,
  MyOsErrMsgs;

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

function TkPosToStr(const ATk: PMyToken): LString;
begin
  Exit(
    'Posição (' + Int32ToLString(ATk.Position) +
    '). Linha(' + Int32ToLString(ATk.Row) +
    '). Coluna(' + Int32ToLString(ATk.Column) + ')'
  );
end;

function TkPosLenToStr(const ATk: PMyToken): LString;
begin
  Exit(
    TkPosToStr(ATk) +
    '. Posição(' + Int32ToLString(ATk.Length) + ')'
  );
end;

function TkPosLenSourceToStr(const ATk: PMyToken): LString;
begin
  Exit(
    TkPosToStr(ATk) +
    '. Posição(' + Int32ToLString(ATk.Length) + ')'#10 +
    ATk.GetSource
  );
end;

{ EUnexpectedChar }

constructor EUnexpectedChar.New(const AToken: PMyToken; const AChar: AnsiChar);
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

{ EUnexpectedEof }

constructor EUnexpectedEof.New(const AToken: PMyToken);
begin
  Token := AToken;

  FMessage := 'Final do código não esperado. ' +
    TkPosToStr(AToken);
end;

{ EUnexpectedToken }

constructor EUnexpectedToken.New(const AToken: PMyToken);
begin
  Token := AToken;

  FMessage := 'Token não esperado. ' +
    TkPosToStr(AToken) + #10'Conteúdo: ' + AToken.GetSource;
end;

{ EBuilderVariableNotFound }

constructor EBuilderVariableNotFound.New(const AToken: PMyToken);
begin
  Token := AToken;

  FMessage := 'Variável não encontrada ''' +
    AToken.vds + '''. ' + TkPosToStr(AToken);
end;

{ EBuilderUnexpectedEof }

constructor EBuilderUnexpectedEof.New(const AToken: PMyToken);
begin
  Token := AToken;

  FMessage := 'Final do código não esperado. ' +
    TkPosToStr(AToken);
end;

constructor EBuilderUnexpectedEof.New2(var ATokenStack: TMyTokenStack);
begin
  if (ATokenStack.Count > 0) then
    New(ATokenStack.DynArray[ATokenStack.Count - 1])
  else
    FMessage := 'Final do código não esperado';
end;

{ EBuilderVariableNameExpected }

constructor EBuilderVariableNameExpected.New(const AToken: PMyToken);
begin
  Token := AToken;

  FMessage := 'Esperado nome da variável. ' +
    TkPosLenToStr(AToken) + #10 +
    AToken.GetSource;
end;

{ EBuilderAssignExpected }

constructor EBuilderAssignExpected.New(const AToken: PMyToken);
begin
  Token := AToken;

  FMessage := 'Esperado "=". ' + TkPosLenSourceToStr(AToken);
end;

{ EBuilderParamAlreadyDeclared }

constructor EBuilderParamAlreadyDeclared.New(const AToken: PMyToken);
begin
  Token := AToken;

  FMessage := 'Parâmetro duplicado: ''' + AToken.vds + '''. ' +
    TkPosToStr(AToken);
end;

{ EBuilderVarIsntFunction }

constructor EBuilderVarIsntFunction.New(const AToken: PMyToken);
begin
  Token := AToken;

  FMessage := 'A variável ''' + AToken.vds + ''' não é uma função. ' +
    TkPosToStr(AToken);
end;

{ ETryLoadFileError }

constructor ETryLoadFileError.Create(const AFileName: LString;
  const AOsError: Integer);
begin
  FileName := AFileName;
  OsError := AOsError;

  FMessage := 'Não foi possível abrir o arquivo ''' + AFileName + '''.'#10 +
    'OsError: ' + Int32ToLString(AOsError) + ' - ' + MyGetOsErrMsg(AOsError);
end;

{ EParamIsntArray }

constructor EParamIsntArray.Create(const AInvMethodName: LString;
  const AParamIndex: Integer);
begin
  InvMethodName := AInvMethodName;
  ParamIndex := AParamIndex;

  FMessage := 'O ' + Int32ToLString(ParamIndex) + 'º parâmetro passado ' +
    'para o método ''' + AInvMethodName + ''' não é um array';
end;

{ EFunctionInvalidParamCount }

constructor EFunctionInvalidParamCount.Create(const AFunctionName: LString;
  const AReceivedParamCount, AMinParamCount, AMaxParamCount: Integer);
var
  LPart1, LPart2: LString;
begin
  FunctionName := AFunctionName;
  ReceivedParamCount := AReceivedParamCount;
  MinParamCount := AMinParamCount;
  MaxParamCount:= AMaxParamCount;

  if (AReceivedParamCount <= 0) then
    LPart1 := 'Nenhum parâmetro foi recebido.'
  else if (AReceivedParamCount = 1) then
    LPart1 := 'Um parâmetro foi recebido.'
  else
    LPart1 := 'Foram recebidos (' + Int32ToLString(AReceivedParamCount) + ') parâmetros.';

  if (AMinParamCount = AMaxParamCount) then
  begin
    if (AMinParamCount <= 0) then
      LPart2 := 'A função não aceita parâmetros.'
    else if (AMinParamCount = 1) then
      LPart2 := 'A função aceita apenas um parâmetro'
    else
      LPart2 := 'A função aceita (' + Int32ToLString(AMinParamCount) + ') parâmetros';
  end else
    LPart2 := 'A função aceita entre (' + Int32ToLString(AMinParamCount) +
      ') e (' + Int32ToLString(AMaxParamCount) + ') parâmetros';

  FMessage := 'A chamada para a função ''' + AFunctionName + ''' é inválida. ' +
    LPart1 + ' ' + LPart2;
end;

{ EInternalError }

constructor EInternalError.Create(const ACodeLocalId: LString);
begin
  FMessage := 'Erro interno. (' + ACodeLocalId + ')';
end;

end.
