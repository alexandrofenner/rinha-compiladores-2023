(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*                                                                            *)
(******************************************************************************)
unit MyData;

{$mode ObjFPC}{$H+}
{$pointermath on}
{$scopedenums on}
{$warnings off}
{$hints off}
{$notes off}

interface

uses
  MyTypes;

type
  TMyEngineContextVariableDataTypeId = (
    eNone, eBool, eInt, eStr, eFunc, eArray);

  PMyEngineContextVariableData = ^TMyEngineContextVariableData;
  TMyEngineContextVariableData = record

    procedure Assign(var ASource: TMyEngineContextVariableData);

    procedure SetId(const AId: TMyEngineContextVariableDataTypeId);
    procedure SetAsBoolean(const AValue: Boolean);
    procedure SetAsInteger(const AValue: Int64);
    procedure SetAsString(const AValue: LString);
    procedure SetAsFunction(const AValue: Pointer);
    procedure SetAsArray(const AValue: Pointer);
    procedure InitializeArray(const ACount: Integer);

    function ToDisplay: LString;
    function TryGetAsBool(var AValue: Boolean): Boolean;
    function TryGetAsInt(var AValue: TMyInteger): Boolean;
    function TryGetAsStr(var AValue: LString): Boolean;
    function TryGetAsArray(var AValue: Pointer): Boolean;

    function AsBoolDefFalse: Boolean;
    function AsBoolDefTrue: Boolean;
    function AsIntDefZero: Int64;
    function AsStrDefEmpty: LString;
  public
    vId: TMyEngineContextVariableDataTypeId;
    case Integer of
      0: (vBool: Boolean);
      1: (vInt: Int64);
      2: (vStr: Pointer);
      3: (vFunc: Pointer);
      4: (vArr: Pointer);
  end;

  TMyEngineContextVariableData2 = array[0..1] of TMyEngineContextVariableData;

  TMyEngineContextVariableDataDynArray = TArray<TMyEngineContextVariableData>;

procedure MyDataVars_Clear(var v: TMyEngineContextVariableDataDynArray);
procedure MyDataVars_Copy(var d, s: TMyEngineContextVariableDataDynArray);
procedure MyDataVars_SetLength(var v: TMyEngineContextVariableDataDynArray;
  const ANewLength: Integer);

const
  cs_Bool: array[Boolean] of LString = ('false', 'true');
  cs_TypeName: array[TMyEngineContextVariableDataTypeId] of LString = (
    'none', 'boolean', 'integer', 'string', 'function', 'array');

var
  gvStackVarsIndex: Integer;
  gvStackVarsArray: TMyEngineContextVariableDataDynArray;

function StackVarItem(
  const AIndex: Integer): PMyEngineContextVariableData; inline;

function StackVarsFrameBegin(
  const ACount: Integer): PMyEngineContextVariableData;
procedure StackVarsFrameEnd(const ACount: Integer); inline;

procedure AddStackVars(const ACount: Integer); inline;
procedure DecStackVars(const ACount: Integer); inline;

implementation

uses
  MySysUtils;

function StackVarItem(const AIndex: Integer): PMyEngineContextVariableData;
begin
  Result := @gvStackVarsArray[AIndex];
end;

function StackVarsFrameBegin(
  const ACount: Integer): PMyEngineContextVariableData;
var
  i: Integer;
begin
  i := gvStackVarsIndex;
  AddStackVars(ACount);
  Result := @gvStackVarsArray[i];
end;

procedure StackVarsFrameEnd(const ACount: Integer);
begin
  Dec(gvStackVarsIndex, ACount);
end;

procedure AddStackVars(const ACount: Integer);
begin
  Inc(gvStackVarsIndex, ACount);
end;

procedure DecStackVars(const ACount: Integer);
begin
  Dec(gvStackVarsIndex, ACount);
end;

type
  TMyDataProcClear = procedure(var v: TMyEngineContextVariableData);

  { d -> Destino
    s -> Origem }
  TMyDataProcAssign = procedure(var d, s: TMyEngineContextVariableData);

  { Converter para uma string a ser exibida }
  TMyDataProcToDisplay = function(var v: TMyEngineContextVariableData): LString;

  { Retornar como boolean }
  TMyDataProcAsBool = function(var v: TMyEngineContextVariableData;
    var d: Boolean): Boolean;

  { Retornar como inteiro }
  TMyDataProcAsInt = function(var v: TMyEngineContextVariableData;
    var d: TMyInteger): Boolean;

  { Retornar como string }
  TMyDataProcAsStr = function(var v: TMyEngineContextVariableData;
    var d: LString): Boolean;

  { Retornar como array }
  TMyDataProcAsArray = function(var v: TMyEngineContextVariableData;
    var d: Pointer): Boolean;

procedure MyDataVars_Clear(var v: TMyEngineContextVariableDataDynArray);
var
  i: Integer;
begin
  for i := High(v) downto Low(v) do
    v[i].SetId(TMyEngineContextVariableDataTypeId.eNone);
  v := nil;
end;

procedure MyDataVars_Copy(var d, s: TMyEngineContextVariableDataDynArray);
var
  i, LCount: Integer;
begin
  LCount := Length(s);
  MyDataVars_SetLength(d, LCount);

  for i := 0 to (LCount - 1) do
    d[i].Assign(s[i]);
end;

procedure MyDataVars_SetLength(
  var v: TMyEngineContextVariableDataDynArray;
  const ANewLength: Integer);
var
  vCount, i: Integer;
begin
  vCount := Length(v);
  if (vCount > ANewLength) then
  begin
    for i := ANewLength to (vCount - 1) do
      v[i].SetId(TMyEngineContextVariableDataTypeId.eNone);
    SetLength(v, ANewLength);
  end else
  begin
    if (vCount < ANewLength) then
      SetLength(v, ANewLength);
  end;
end;

procedure MyData_NopClear(var v: TMyEngineContextVariableData);
begin
end;

procedure MyData_StrClear(var v: TMyEngineContextVariableData);
begin
  LString(v.vStr) := '';
end;

procedure MyData_ArrClear(var v: TMyEngineContextVariableData);
begin
  MyDataVars_Clear(TMyEngineContextVariableDataDynArray(v.vArr));
end;

procedure MyData_PtrInit(var v: TMyEngineContextVariableData);
begin
  v.vFunc := nil;
end;

procedure MyData_AssignNone(var d, s: TMyEngineContextVariableData);
begin
end;

procedure MyData_AssignBool(var d, s: TMyEngineContextVariableData);
begin
  d.vBool := s.vBool;
end;

procedure MyData_AssignInt(var d, s: TMyEngineContextVariableData);
begin
  d.vInt := s.vInt;
end;

procedure MyData_AssignStr(var d, s: TMyEngineContextVariableData);
begin
  LString(d.vStr) := LString(s.vStr);
end;

procedure MyData_AssignFunc(var d, s: TMyEngineContextVariableData);
begin
  d.vFunc := s.vFunc;
end;

procedure MyData_AssignArray(var d, s: TMyEngineContextVariableData);
begin
  MyDataVars_Copy(TMyEngineContextVariableDataDynArray(d.vArr),
    TMyEngineContextVariableDataDynArray(s.vArr));
end;

function MyDataToDisplay_None(var v: TMyEngineContextVariableData): LString;
begin
  Exit('´none´');
end;

function MyDataToDisplay_Bool(var v: TMyEngineContextVariableData): LString;
begin
  Exit(cs_Bool[v.vBool]);
end;

function MyDataToDisplay_Int(var v: TMyEngineContextVariableData): LString;
begin
  Exit(Int64ToLString(v.vInt));
end;

function MyDataToDisplay_Str(var v: TMyEngineContextVariableData): LString;
begin
  Exit(QtString(LString(v.vStr), '"'));
end;

function MyDataToDisplay_Func(var v: TMyEngineContextVariableData): LString;
begin
  Exit('´function´');
end;

function MyDataToDisplay_Array(var v: TMyEngineContextVariableData): LString;
var
  p: PMyEngineContextVariableData;
  LCount: Integer;
begin
  LCount := Length(TMyEngineContextVariableDataDynArray(v.vArr));
  if (LCount = 0) then Exit('array()');
  p := PMyEngineContextVariableData(
    TMyEngineContextVariableDataDynArray(v.vArr));

  if (LCount = 1) then
    Exit('array(' + p^.ToDisplay + ')');

  Result := '(' + p^.ToDisplay;

  repeat
    Dec(LCount);
    if (LCount = 0) then
    begin
      Result := Result + ')';
      Break;
    end;
    Inc(p);
    Result := Result + ',' + p^.ToDisplay;
  until False;
end;

function MyDataAsBool_None(var v: TMyEngineContextVariableData;
  var d: Boolean): Boolean;
begin
  d := False;
  Exit(True);
end;

function MyDataAsBool_Bool(var v: TMyEngineContextVariableData;
  var d: Boolean): Boolean;
begin
  d := v.vBool;
  Exit(True);
end;

function MyDataAsBool_Int(var v: TMyEngineContextVariableData;
  var d: Boolean): Boolean;
begin
  d := (v.vInt <> 0);
  Exit(True);
end;

function MyDataAsBool_Str(var v: TMyEngineContextVariableData;
  var d: Boolean): Boolean;
begin
  if (LString(v.vStr) = cs_Bool[True]) then
  begin
    d := True;
    Exit(True);
  end;
  if (LString(v.vStr) = cs_Bool[False]) then
  begin
    d := False;
    Exit(True);
  end;
  Exit(False);
end;

function MyDataAsBool_Func(var v: TMyEngineContextVariableData;
  var d: Boolean): Boolean;
begin
  Exit(False);
end;

function MyDataAsBool_Array(var v: TMyEngineContextVariableData;
  var d: Boolean): Boolean;
begin
  Exit(False);
end;

function MyDataAsInt_None(var v: TMyEngineContextVariableData;
  var d: TMyInteger): Boolean;
begin
  d := 0;
  Exit(True);
end;

function MyDataAsInt_Bool(var v: TMyEngineContextVariableData;
  var d: TMyInteger): Boolean;
begin
  if v.vBool then
    d := 1
  else
    d := 0;
  Exit(True);
end;

function MyDataAsInt_Int(var v: TMyEngineContextVariableData;
  var d: TMyInteger): Boolean;
begin
  d := v.vInt;
  Exit(True);
end;

function MyDataAsInt_Str(var v: TMyEngineContextVariableData;
  var d: TMyInteger): Boolean;
var
  c: Integer;
begin
  System.Val(LString(v.vStr), d, c);
  Exit(c = 0);
end;

function MyDataAsInt_Func(var v: TMyEngineContextVariableData;
  var d: TMyInteger): Boolean;
begin
  Exit(False);
end;

function MyDataAsInt_Array(var v: TMyEngineContextVariableData;
  var d: TMyInteger): Boolean;
begin
  Exit(False);
end;

function MyDataAsStr_None(var v: TMyEngineContextVariableData;
  var d: LString): Boolean;
begin
  d := '';
  Exit(True);
end;

function MyDataAsStr_Bool(var v: TMyEngineContextVariableData;
  var d: LString): Boolean;
begin
  d := cs_Bool[v.vBool];
  Exit(True);
end;

function MyDataAsStr_Int(var v: TMyEngineContextVariableData;
  var d: LString): Boolean;
begin
  d := Int64ToLString(v.vInt);
  Exit(True);
end;

function MyDataAsStr_Str(var v: TMyEngineContextVariableData;
  var d: LString): Boolean;
begin
  d := LString(v.vStr);
  Exit(True);
end;

function MyDataAsStr_Func(var v: TMyEngineContextVariableData;
  var d: LString): Boolean;
begin
  Exit(False);
end;

function MyDataAsStr_Array(var v: TMyEngineContextVariableData;
  var d: LString): Boolean;
begin
  Exit(False);
end;

function MyDataAsArray_None(var v: TMyEngineContextVariableData;
  var d: Pointer): Boolean;
begin
  MyDataVars_Clear(TMyEngineContextVariableDataDynArray(d));
  Exit(True);
end;

function MyDataAsArray_Bool(var v: TMyEngineContextVariableData;
  var d: Pointer): Boolean;
begin
  MyDataVars_SetLength(TMyEngineContextVariableDataDynArray(d), 1);
  TMyEngineContextVariableDataDynArray(d)[0].SetAsBoolean(v.vBool);
  Exit(True);
end;

function MyDataAsArray_Int(var v: TMyEngineContextVariableData;
  var d: Pointer): Boolean;
begin
  MyDataVars_SetLength(TMyEngineContextVariableDataDynArray(d), 1);
  TMyEngineContextVariableDataDynArray(d)[0].SetAsInteger(v.vInt);
  Exit(True);
end;

function MyDataAsArray_Str(var v: TMyEngineContextVariableData;
  var d: Pointer): Boolean;
begin
  MyDataVars_SetLength(TMyEngineContextVariableDataDynArray(d), 1);
  TMyEngineContextVariableDataDynArray(d)[0].SetAsString(LString(v.vStr));
  Exit(True);
end;

function MyDataAsArray_Func(var v: TMyEngineContextVariableData;
  var d: Pointer): Boolean;
begin
  MyDataVars_SetLength(TMyEngineContextVariableDataDynArray(d), 1);
  TMyEngineContextVariableDataDynArray(d)[0].SetAsFunction(v.vFunc);
  Exit(True);
end;

function MyDataAsArray_Array(var v: TMyEngineContextVariableData;
  var d: Pointer): Boolean;
begin
  MyDataVars_Copy(TMyEngineContextVariableDataDynArray(d),
    TMyEngineContextVariableDataDynArray(v.vArr));
  Exit(True);
end;

const
  TableMyDataProcToDisplay:
    array[TMyEngineContextVariableDataTypeId] of TMyDataProcToDisplay = (
      MyDataToDisplay_None,   { None }
      MyDataToDisplay_Bool,   { Boolean }
      MyDataToDisplay_Int,    { Integer }
      MyDataToDisplay_Str,    { String }
      MyDataToDisplay_Func,   { Function }
      MyDataToDisplay_Array   { Array }
    );

  TableMyDataProcClear:
    array[TMyEngineContextVariableDataTypeId] of TMyDataProcClear = (
      MyData_NopClear,    { None }
      MyData_NopClear,    { Boolean }
      MyData_NopClear,    { Integer }
      MyData_StrClear,    { String }
      MyData_NopClear,    { Function }
      MyData_ArrClear     { Array }
  );

  TableMyDataProcInit:
    array[TMyEngineContextVariableDataTypeId] of TMyDataProcClear = (
      MyData_NopClear,    { None }
      MyData_NopClear,    { Boolean }
      MyData_NopClear,    { Integer }
      MyData_PtrInit,     { String }
      MyData_PtrInit,     { Function }
      MyData_PtrInit      { Array }
  );

  TableMyDataProcAssign:
    array[TMyEngineContextVariableDataTypeId] of TMyDataProcAssign = (
      MyData_AssignNone,  { None }
      MyData_AssignBool,  { Boolean }
      MyData_AssignInt,   { Integer }
      MyData_AssignStr,   { String }
      MyData_AssignFunc,  { Function }
      MyData_AssignArray  { Array }
  );

  TableMyDataProcAsBool:
    array[TMyEngineContextVariableDataTypeId] of TMyDataProcAsBool = (
       MyDataAsBool_None, { None }
       MyDataAsBool_Bool, { Boolean }
       MyDataAsBool_Int,  { Integer }
       MyDataAsBool_Str,  { String }
       MyDataAsBool_Func, { Function }
       MyDataAsBool_Array { Array }
    );

  TableMyDataProcAsInt:
    array[TMyEngineContextVariableDataTypeId] of TMyDataProcAsInt = (
       MyDataAsInt_None,  { None }
       MyDataAsInt_Bool,  { Boolean }
       MyDataAsInt_Int,   { Integer }
       MyDataAsInt_Str,   { String }
       MyDataAsInt_Func,  { Function }
       MyDataAsInt_Array  { Array }
    );

  TableMyDataProcAsStr:
    array[TMyEngineContextVariableDataTypeId] of TMyDataProcAsStr = (
       MyDataAsStr_None,  { None }
       MyDataAsStr_Bool,  { Boolean }
       MyDataAsStr_Int,   { Integer }
       MyDataAsStr_Str,   { String }
       MyDataAsStr_Func,  { Function }
       MyDataAsStr_Array  { Array }
    );

  TableMyDataProcAsArray:
    array[TMyEngineContextVariableDataTypeId] of TMyDataProcAsArray = (
       MyDataAsArray_None,  { None }
       MyDataAsArray_Bool,  { Boolean }
       MyDataAsArray_Int,   { Integer }
       MyDataAsArray_Str,   { String }
       MyDataAsArray_Func,  { Function }
       MyDataAsArray_Array  { Array }
    );

{ TMyEngineContextVariableData }

function TMyEngineContextVariableData.AsBoolDefFalse: Boolean;
begin
  if (not TryGetAsBool(Result)) then
    Exit(False);
end;

function TMyEngineContextVariableData.AsBoolDefTrue: Boolean;
begin
  if (not TryGetAsBool(Result)) then
    Exit(True);
end;

function TMyEngineContextVariableData.AsIntDefZero: Int64;
begin
  if (not TryGetAsInt(Result)) then
    Result := 0;
end;

procedure TMyEngineContextVariableData.Assign(
  var ASource: TMyEngineContextVariableData);
begin
  SetId(ASource.vId);
  TableMyDataProcAssign[ASource.vId](Self, ASource);
end;

function TMyEngineContextVariableData.AsStrDefEmpty: LString;
begin
  if (not TryGetAsStr(Result)) then
    Result := '';
end;

procedure TMyEngineContextVariableData.InitializeArray(const ACount: Integer);
begin
  SetId(TMyEngineContextVariableDataTypeId.eArray);
  SetLength(TMyEngineContextVariableDataDynArray(vArr), ACount);
end;

procedure TMyEngineContextVariableData.SetAsArray(const AValue: Pointer);
var
  i, LCount: Integer;
begin
  LCount := System.Length(TMyEngineContextVariableDataDynArray(AValue));
  InitializeArray(LCount);
  for i := 0 to (LCount - 1) do
    TMyEngineContextVariableDataDynArray(vArr)[i]
      .Assign(TMyEngineContextVariableDataDynArray(AValue)[i]);
end;

procedure TMyEngineContextVariableData.SetAsBoolean(const AValue: Boolean);
begin
  SetId(TMyEngineContextVariableDataTypeId.eBool);
  vBool := AValue;
end;

procedure TMyEngineContextVariableData.SetAsFunction(const AValue: Pointer);
begin
  SetId(TMyEngineContextVariableDataTypeId.eFunc);
  vFunc := AValue;
end;

procedure TMyEngineContextVariableData.SetAsInteger(const AValue: Int64);
begin
  SetId(TMyEngineContextVariableDataTypeId.eInt);
  vInt := AValue;
end;

procedure TMyEngineContextVariableData.SetAsString(const AValue: LString);
begin
  SetId(TMyEngineContextVariableDataTypeId.eStr);
  LString(vStr) := AValue;
end;

procedure TMyEngineContextVariableData.SetId(
  const AId: TMyEngineContextVariableDataTypeId);
begin
  if (vId = AId) then Exit;
  TableMyDataProcClear[vId](Self);
  TableMyDataProcInit[AId](Self);
  vId := AId;
end;

function TMyEngineContextVariableData.ToDisplay: LString;
begin
  Exit(TableMyDataProcToDisplay[vId](Self));
end;

function TMyEngineContextVariableData.TryGetAsArray(
  var AValue: Pointer): Boolean;
begin
  Exit(TableMyDataProcAsArray[vId](Self, AValue));
end;

function TMyEngineContextVariableData.TryGetAsBool(
  var AValue: Boolean): Boolean;
begin
  Exit(TableMyDataProcAsBool[vId](Self, AValue));
end;

function TMyEngineContextVariableData.TryGetAsInt(
  var AValue: TMyInteger): Boolean;
begin
  Exit(TableMyDataProcAsInt[vId](Self, AValue));
end;

function TMyEngineContextVariableData.TryGetAsStr(var AValue: LString): Boolean;
begin
  Exit(TableMyDataProcAsStr[vId](Self, AValue));
end;

initialization
  SetLength(gvStackVarsArray, 16777216);

end.
