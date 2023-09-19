(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*                                                                            *)
(******************************************************************************)
unit MyOperators;

{$pointermath on}
{$scopedenums on}
{$warnings off}
{$hints off}
{$notes off}

interface

uses
  MyTypes,
  MyData;

type
  TIf_Func = function(var AData: TMyEngineContextVariableData): Boolean;
  TAsInt_Func = function(var AData: TMyEngineContextVariableData): TMyInteger;
  TVerySimp_Proc = procedure(var AData: TMyEngineContextVariableData);

  TInvkProc = procedure(var AParams: TMyEngineContextVariableData2;
    var AResult: TMyEngineContextVariableData);

function If_None(var AData: TMyEngineContextVariableData): Boolean;
function If_Bool(var AData: TMyEngineContextVariableData): Boolean;
function If_Int(var AData: TMyEngineContextVariableData): Boolean;
function If_Str(var AData: TMyEngineContextVariableData): Boolean;
function If_Func(var AData: TMyEngineContextVariableData): Boolean;
function If_Array(var AData: TMyEngineContextVariableData): Boolean;

const
  cIf_FuncTable: array[TMyEngineContextVariableDataTypeId] of TIf_Func = (
    If_None,
    If_Bool,
    If_Int,
    If_Str,
    If_Func,
    If_Array);

function AsInt_None(var AData: TMyEngineContextVariableData): TMyInteger;
function AsInt_Bool(var AData: TMyEngineContextVariableData): TMyInteger;
function AsInt_Int(var AData: TMyEngineContextVariableData): TMyInteger;
function AsInt_Str(var AData: TMyEngineContextVariableData): TMyInteger;
function AsInt_Func(var AData: TMyEngineContextVariableData): TMyInteger;
function AsInt_Array(var AData: TMyEngineContextVariableData): TMyInteger;

const
  cAsInt_FuncTable: array[TMyEngineContextVariableDataTypeId] of TAsInt_Func = (
    AsInt_None,
    AsInt_Bool,
    AsInt_Int,
    AsInt_Str,
    AsInt_Func,
    AsInt_Array);

procedure vsNeg_None(var AData: TMyEngineContextVariableData);
procedure vsNeg_Bool(var AData: TMyEngineContextVariableData);
procedure vsNeg_Int(var AData: TMyEngineContextVariableData);
procedure vsNeg_Str(var AData: TMyEngineContextVariableData);
procedure vsNeg_Func(var AData: TMyEngineContextVariableData);
procedure vsNeg_Array(var AData: TMyEngineContextVariableData);

const
  cVsNeg_FuncTable: array[TMyEngineContextVariableDataTypeId] of TVerySimp_Proc = (
    vsNeg_None,
    vsNeg_Bool,
    vsNeg_Int,
    vsNeg_Str,
    vsNeg_Func,
    vsNeg_Array);

{ Operador: Add }

procedure cInvAdd_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAdd_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Sub }

procedure cInvSub_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvSub_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Mul }

procedure cInvMul_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvMul_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Div }

procedure cInvDiv_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvDiv_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Rem }

procedure cInvRem_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvRem_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Eq }

procedure cInvEq_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvEq_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Neq }

procedure cInvNeq_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvNeq_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Lt }

procedure cInvLt_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLt_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Gt }

procedure cInvGt_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGt_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Lte }

procedure cInvLte_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvLte_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Gte }

procedure cInvGte_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvGte_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: And }

procedure cInvAnd_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvAnd_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Or }

procedure cInvOr_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvOr_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

{ Operador: Power }

procedure cInvPower_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
procedure cInvPower_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);

const
  cInvProcTable: array[0..503] of TInvkProc = (

  { Operador: Add }
    cInvAdd_None_None,      //  000
    cInvAdd_None_Bool,      //  001
    cInvAdd_None_Int,       //  002
    cInvAdd_None_Str,       //  003
    cInvAdd_None_Func,      //  004
    cInvAdd_None_Array,     //  005
    cInvAdd_Bool_None,      //  006
    cInvAdd_Bool_Bool,      //  007
    cInvAdd_Bool_Int,       //  008
    cInvAdd_Bool_Str,       //  009
    cInvAdd_Bool_Func,      //  010
    cInvAdd_Bool_Array,     //  011
    cInvAdd_Int_None,       //  012
    cInvAdd_Int_Bool,       //  013
    cInvAdd_Int_Int,        //  014
    cInvAdd_Int_Str,        //  015
    cInvAdd_Int_Func,       //  016
    cInvAdd_Int_Array,      //  017
    cInvAdd_Str_None,       //  018
    cInvAdd_Str_Bool,       //  019
    cInvAdd_Str_Int,        //  020
    cInvAdd_Str_Str,        //  021
    cInvAdd_Str_Func,       //  022
    cInvAdd_Str_Array,      //  023
    cInvAdd_Func_None,      //  024
    cInvAdd_Func_Bool,      //  025
    cInvAdd_Func_Int,       //  026
    cInvAdd_Func_Str,       //  027
    cInvAdd_Func_Func,      //  028
    cInvAdd_Func_Array,     //  029
    cInvAdd_Array_None,     //  030
    cInvAdd_Array_Bool,     //  031
    cInvAdd_Array_Int,      //  032
    cInvAdd_Array_Str,      //  033
    cInvAdd_Array_Func,     //  034
    cInvAdd_Array_Array,    //  035

  { Operador: Sub }
    cInvSub_None_None,      //  036
    cInvSub_None_Bool,      //  037
    cInvSub_None_Int,       //  038
    cInvSub_None_Str,       //  039
    cInvSub_None_Func,      //  040
    cInvSub_None_Array,     //  041
    cInvSub_Bool_None,      //  042
    cInvSub_Bool_Bool,      //  043
    cInvSub_Bool_Int,       //  044
    cInvSub_Bool_Str,       //  045
    cInvSub_Bool_Func,      //  046
    cInvSub_Bool_Array,     //  047
    cInvSub_Int_None,       //  048
    cInvSub_Int_Bool,       //  049
    cInvSub_Int_Int,        //  050
    cInvSub_Int_Str,        //  051
    cInvSub_Int_Func,       //  052
    cInvSub_Int_Array,      //  053
    cInvSub_Str_None,       //  054
    cInvSub_Str_Bool,       //  055
    cInvSub_Str_Int,        //  056
    cInvSub_Str_Str,        //  057
    cInvSub_Str_Func,       //  058
    cInvSub_Str_Array,      //  059
    cInvSub_Func_None,      //  060
    cInvSub_Func_Bool,      //  061
    cInvSub_Func_Int,       //  062
    cInvSub_Func_Str,       //  063
    cInvSub_Func_Func,      //  064
    cInvSub_Func_Array,     //  065
    cInvSub_Array_None,     //  066
    cInvSub_Array_Bool,     //  067
    cInvSub_Array_Int,      //  068
    cInvSub_Array_Str,      //  069
    cInvSub_Array_Func,     //  070
    cInvSub_Array_Array,    //  071

  { Operador: Mul }
    cInvMul_None_None,      //  072
    cInvMul_None_Bool,      //  073
    cInvMul_None_Int,       //  074
    cInvMul_None_Str,       //  075
    cInvMul_None_Func,      //  076
    cInvMul_None_Array,     //  077
    cInvMul_Bool_None,      //  078
    cInvMul_Bool_Bool,      //  079
    cInvMul_Bool_Int,       //  080
    cInvMul_Bool_Str,       //  081
    cInvMul_Bool_Func,      //  082
    cInvMul_Bool_Array,     //  083
    cInvMul_Int_None,       //  084
    cInvMul_Int_Bool,       //  085
    cInvMul_Int_Int,        //  086
    cInvMul_Int_Str,        //  087
    cInvMul_Int_Func,       //  088
    cInvMul_Int_Array,      //  089
    cInvMul_Str_None,       //  090
    cInvMul_Str_Bool,       //  091
    cInvMul_Str_Int,        //  092
    cInvMul_Str_Str,        //  093
    cInvMul_Str_Func,       //  094
    cInvMul_Str_Array,      //  095
    cInvMul_Func_None,      //  096
    cInvMul_Func_Bool,      //  097
    cInvMul_Func_Int,       //  098
    cInvMul_Func_Str,       //  099
    cInvMul_Func_Func,      //  100
    cInvMul_Func_Array,     //  101
    cInvMul_Array_None,     //  102
    cInvMul_Array_Bool,     //  103
    cInvMul_Array_Int,      //  104
    cInvMul_Array_Str,      //  105
    cInvMul_Array_Func,     //  106
    cInvMul_Array_Array,    //  107

  { Operador: Div }
    cInvDiv_None_None,      //  108
    cInvDiv_None_Bool,
    cInvDiv_None_Int,
    cInvDiv_None_Str,
    cInvDiv_None_Func,
    cInvDiv_None_Array,
    cInvDiv_Bool_None,
    cInvDiv_Bool_Bool,
    cInvDiv_Bool_Int,
    cInvDiv_Bool_Str,
    cInvDiv_Bool_Func,
    cInvDiv_Bool_Array,
    cInvDiv_Int_None,
    cInvDiv_Int_Bool,
    cInvDiv_Int_Int,
    cInvDiv_Int_Str,
    cInvDiv_Int_Func,
    cInvDiv_Int_Array,
    cInvDiv_Str_None,
    cInvDiv_Str_Bool,
    cInvDiv_Str_Int,
    cInvDiv_Str_Str,
    cInvDiv_Str_Func,
    cInvDiv_Str_Array,
    cInvDiv_Func_None,
    cInvDiv_Func_Bool,
    cInvDiv_Func_Int,
    cInvDiv_Func_Str,
    cInvDiv_Func_Func,
    cInvDiv_Func_Array,
    cInvDiv_Array_None,
    cInvDiv_Array_Bool,
    cInvDiv_Array_Int,
    cInvDiv_Array_Str,
    cInvDiv_Array_Func,
    cInvDiv_Array_Array,

  { Operador: Rem }
    cInvRem_None_None,      //  144
    cInvRem_None_Bool,
    cInvRem_None_Int,
    cInvRem_None_Str,
    cInvRem_None_Func,
    cInvRem_None_Array,
    cInvRem_Bool_None,
    cInvRem_Bool_Bool,
    cInvRem_Bool_Int,
    cInvRem_Bool_Str,
    cInvRem_Bool_Func,
    cInvRem_Bool_Array,
    cInvRem_Int_None,
    cInvRem_Int_Bool,
    cInvRem_Int_Int,
    cInvRem_Int_Str,
    cInvRem_Int_Func,
    cInvRem_Int_Array,
    cInvRem_Str_None,
    cInvRem_Str_Bool,
    cInvRem_Str_Int,
    cInvRem_Str_Str,
    cInvRem_Str_Func,
    cInvRem_Str_Array,
    cInvRem_Func_None,
    cInvRem_Func_Bool,
    cInvRem_Func_Int,
    cInvRem_Func_Str,
    cInvRem_Func_Func,
    cInvRem_Func_Array,
    cInvRem_Array_None,
    cInvRem_Array_Bool,
    cInvRem_Array_Int,
    cInvRem_Array_Str,
    cInvRem_Array_Func,
    cInvRem_Array_Array,

  { Operador: Eq }
    cInvEq_None_None,       //  180
    cInvEq_None_Bool,
    cInvEq_None_Int,
    cInvEq_None_Str,
    cInvEq_None_Func,
    cInvEq_None_Array,
    cInvEq_Bool_None,
    cInvEq_Bool_Bool,
    cInvEq_Bool_Int,
    cInvEq_Bool_Str,
    cInvEq_Bool_Func,
    cInvEq_Bool_Array,
    cInvEq_Int_None,
    cInvEq_Int_Bool,
    cInvEq_Int_Int,
    cInvEq_Int_Str,
    cInvEq_Int_Func,
    cInvEq_Int_Array,
    cInvEq_Str_None,
    cInvEq_Str_Bool,
    cInvEq_Str_Int,
    cInvEq_Str_Str,
    cInvEq_Str_Func,
    cInvEq_Str_Array,
    cInvEq_Func_None,
    cInvEq_Func_Bool,
    cInvEq_Func_Int,
    cInvEq_Func_Str,
    cInvEq_Func_Func,
    cInvEq_Func_Array,
    cInvEq_Array_None,
    cInvEq_Array_Bool,
    cInvEq_Array_Int,
    cInvEq_Array_Str,
    cInvEq_Array_Func,
    cInvEq_Array_Array,

  { Operador: Neq }
    cInvNeq_None_None,      //  216
    cInvNeq_None_Bool,
    cInvNeq_None_Int,
    cInvNeq_None_Str,
    cInvNeq_None_Func,
    cInvNeq_None_Array,
    cInvNeq_Bool_None,
    cInvNeq_Bool_Bool,
    cInvNeq_Bool_Int,
    cInvNeq_Bool_Str,
    cInvNeq_Bool_Func,
    cInvNeq_Bool_Array,
    cInvNeq_Int_None,
    cInvNeq_Int_Bool,
    cInvNeq_Int_Int,
    cInvNeq_Int_Str,
    cInvNeq_Int_Func,
    cInvNeq_Int_Array,
    cInvNeq_Str_None,
    cInvNeq_Str_Bool,
    cInvNeq_Str_Int,
    cInvNeq_Str_Str,
    cInvNeq_Str_Func,
    cInvNeq_Str_Array,
    cInvNeq_Func_None,
    cInvNeq_Func_Bool,
    cInvNeq_Func_Int,
    cInvNeq_Func_Str,
    cInvNeq_Func_Func,
    cInvNeq_Func_Array,
    cInvNeq_Array_None,
    cInvNeq_Array_Bool,
    cInvNeq_Array_Int,
    cInvNeq_Array_Str,
    cInvNeq_Array_Func,
    cInvNeq_Array_Array,

  { Operador: Lt }
    cInvLt_None_None,       //  252
    cInvLt_None_Bool,
    cInvLt_None_Int,
    cInvLt_None_Str,
    cInvLt_None_Func,
    cInvLt_None_Array,
    cInvLt_Bool_None,
    cInvLt_Bool_Bool,
    cInvLt_Bool_Int,
    cInvLt_Bool_Str,
    cInvLt_Bool_Func,
    cInvLt_Bool_Array,
    cInvLt_Int_None,
    cInvLt_Int_Bool,
    cInvLt_Int_Int,
    cInvLt_Int_Str,
    cInvLt_Int_Func,
    cInvLt_Int_Array,
    cInvLt_Str_None,
    cInvLt_Str_Bool,
    cInvLt_Str_Int,
    cInvLt_Str_Str,
    cInvLt_Str_Func,
    cInvLt_Str_Array,
    cInvLt_Func_None,
    cInvLt_Func_Bool,
    cInvLt_Func_Int,
    cInvLt_Func_Str,
    cInvLt_Func_Func,
    cInvLt_Func_Array,
    cInvLt_Array_None,
    cInvLt_Array_Bool,
    cInvLt_Array_Int,
    cInvLt_Array_Str,
    cInvLt_Array_Func,
    cInvLt_Array_Array,

  { Operador: Gt }
    cInvGt_None_None,
    cInvGt_None_Bool,
    cInvGt_None_Int,
    cInvGt_None_Str,
    cInvGt_None_Func,
    cInvGt_None_Array,
    cInvGt_Bool_None,
    cInvGt_Bool_Bool,
    cInvGt_Bool_Int,
    cInvGt_Bool_Str,
    cInvGt_Bool_Func,
    cInvGt_Bool_Array,
    cInvGt_Int_None,
    cInvGt_Int_Bool,
    cInvGt_Int_Int,
    cInvGt_Int_Str,
    cInvGt_Int_Func,
    cInvGt_Int_Array,
    cInvGt_Str_None,
    cInvGt_Str_Bool,
    cInvGt_Str_Int,
    cInvGt_Str_Str,
    cInvGt_Str_Func,
    cInvGt_Str_Array,
    cInvGt_Func_None,
    cInvGt_Func_Bool,
    cInvGt_Func_Int,
    cInvGt_Func_Str,
    cInvGt_Func_Func,
    cInvGt_Func_Array,
    cInvGt_Array_None,
    cInvGt_Array_Bool,
    cInvGt_Array_Int,
    cInvGt_Array_Str,
    cInvGt_Array_Func,
    cInvGt_Array_Array,

  { Operador: Lte }
    cInvLte_None_None,
    cInvLte_None_Bool,
    cInvLte_None_Int,
    cInvLte_None_Str,
    cInvLte_None_Func,
    cInvLte_None_Array,
    cInvLte_Bool_None,
    cInvLte_Bool_Bool,
    cInvLte_Bool_Int,
    cInvLte_Bool_Str,
    cInvLte_Bool_Func,
    cInvLte_Bool_Array,
    cInvLte_Int_None,
    cInvLte_Int_Bool,
    cInvLte_Int_Int,
    cInvLte_Int_Str,
    cInvLte_Int_Func,
    cInvLte_Int_Array,
    cInvLte_Str_None,
    cInvLte_Str_Bool,
    cInvLte_Str_Int,
    cInvLte_Str_Str,
    cInvLte_Str_Func,
    cInvLte_Str_Array,
    cInvLte_Func_None,
    cInvLte_Func_Bool,
    cInvLte_Func_Int,
    cInvLte_Func_Str,
    cInvLte_Func_Func,
    cInvLte_Func_Array,
    cInvLte_Array_None,
    cInvLte_Array_Bool,
    cInvLte_Array_Int,
    cInvLte_Array_Str,
    cInvLte_Array_Func,
    cInvLte_Array_Array,

  { Operador: Gte }
    cInvGte_None_None,
    cInvGte_None_Bool,
    cInvGte_None_Int,
    cInvGte_None_Str,
    cInvGte_None_Func,
    cInvGte_None_Array,
    cInvGte_Bool_None,
    cInvGte_Bool_Bool,
    cInvGte_Bool_Int,
    cInvGte_Bool_Str,
    cInvGte_Bool_Func,
    cInvGte_Bool_Array,
    cInvGte_Int_None,
    cInvGte_Int_Bool,
    cInvGte_Int_Int,
    cInvGte_Int_Str,
    cInvGte_Int_Func,
    cInvGte_Int_Array,
    cInvGte_Str_None,
    cInvGte_Str_Bool,
    cInvGte_Str_Int,
    cInvGte_Str_Str,
    cInvGte_Str_Func,
    cInvGte_Str_Array,
    cInvGte_Func_None,
    cInvGte_Func_Bool,
    cInvGte_Func_Int,
    cInvGte_Func_Str,
    cInvGte_Func_Func,
    cInvGte_Func_Array,
    cInvGte_Array_None,
    cInvGte_Array_Bool,
    cInvGte_Array_Int,
    cInvGte_Array_Str,
    cInvGte_Array_Func,
    cInvGte_Array_Array,

  { Operador: And }
    cInvAnd_None_None,
    cInvAnd_None_Bool,
    cInvAnd_None_Int,
    cInvAnd_None_Str,
    cInvAnd_None_Func,
    cInvAnd_None_Array,
    cInvAnd_Bool_None,
    cInvAnd_Bool_Bool,
    cInvAnd_Bool_Int,
    cInvAnd_Bool_Str,
    cInvAnd_Bool_Func,
    cInvAnd_Bool_Array,
    cInvAnd_Int_None,
    cInvAnd_Int_Bool,
    cInvAnd_Int_Int,
    cInvAnd_Int_Str,
    cInvAnd_Int_Func,
    cInvAnd_Int_Array,
    cInvAnd_Str_None,
    cInvAnd_Str_Bool,
    cInvAnd_Str_Int,
    cInvAnd_Str_Str,
    cInvAnd_Str_Func,
    cInvAnd_Str_Array,
    cInvAnd_Func_None,
    cInvAnd_Func_Bool,
    cInvAnd_Func_Int,
    cInvAnd_Func_Str,
    cInvAnd_Func_Func,
    cInvAnd_Func_Array,
    cInvAnd_Array_None,
    cInvAnd_Array_Bool,
    cInvAnd_Array_Int,
    cInvAnd_Array_Str,
    cInvAnd_Array_Func,
    cInvAnd_Array_Array,

  { Operador: Or }
    cInvOr_None_None,
    cInvOr_None_Bool,
    cInvOr_None_Int,
    cInvOr_None_Str,
    cInvOr_None_Func,
    cInvOr_None_Array,
    cInvOr_Bool_None,
    cInvOr_Bool_Bool,
    cInvOr_Bool_Int,
    cInvOr_Bool_Str,
    cInvOr_Bool_Func,
    cInvOr_Bool_Array,
    cInvOr_Int_None,
    cInvOr_Int_Bool,
    cInvOr_Int_Int,
    cInvOr_Int_Str,
    cInvOr_Int_Func,
    cInvOr_Int_Array,
    cInvOr_Str_None,
    cInvOr_Str_Bool,
    cInvOr_Str_Int,
    cInvOr_Str_Str,
    cInvOr_Str_Func,
    cInvOr_Str_Array,
    cInvOr_Func_None,
    cInvOr_Func_Bool,
    cInvOr_Func_Int,
    cInvOr_Func_Str,
    cInvOr_Func_Func,
    cInvOr_Func_Array,
    cInvOr_Array_None,
    cInvOr_Array_Bool,
    cInvOr_Array_Int,
    cInvOr_Array_Str,
    cInvOr_Array_Func,
    cInvOr_Array_Array,

  { Operador: Power }
    cInvPower_None_None,
    cInvPower_None_Bool,
    cInvPower_None_Int,
    cInvPower_None_Str,
    cInvPower_None_Func,
    cInvPower_None_Array,
    cInvPower_Bool_None,
    cInvPower_Bool_Bool,
    cInvPower_Bool_Int,
    cInvPower_Bool_Str,
    cInvPower_Bool_Func,
    cInvPower_Bool_Array,
    cInvPower_Int_None,
    cInvPower_Int_Bool,
    cInvPower_Int_Int,
    cInvPower_Int_Str,
    cInvPower_Int_Func,
    cInvPower_Int_Array,
    cInvPower_Str_None,
    cInvPower_Str_Bool,
    cInvPower_Str_Int,
    cInvPower_Str_Str,
    cInvPower_Str_Func,
    cInvPower_Str_Array,
    cInvPower_Func_None,
    cInvPower_Func_Bool,
    cInvPower_Func_Int,
    cInvPower_Func_Str,
    cInvPower_Func_Func,
    cInvPower_Func_Array,
    cInvPower_Array_None,
    cInvPower_Array_Bool,
    cInvPower_Array_Int,
    cInvPower_Array_Str,
    cInvPower_Array_Func,
    cInvPower_Array_Array);

const
  cs_Bool: array[Boolean] of LString = ('false', 'true');

function I_F0(const i: UInt64): UInt64;
function I_F1(const i: UInt64): UInt64;
function Int2Str(const i: TMyInteger): LString;

implementation

uses
  MySysUtils;

function Bool2Str(const b: Boolean): LString; inline;
begin
  Exit(cs_Bool[b]);
end;

function Str2BoolDef(const s: LString; const ADefault: Boolean): Boolean;
begin
  if (s = cs_Bool[True]) then Exit(True);
  if (s = cs_Bool[False]) then Exit(False);
  Exit(ADefault);
end;

function Int2Str(const i: TMyInteger): LString;
begin
  Exit(_Int64ToLString(Abs(i), (i < 0)));
end;

function StrSubStr(const a, b: LString): LString;
var
  i: Integer;
begin
  Result := a;
  repeat
    i := Pos(b, Result);
    if (i = 0) then Break;
    Delete(Result, i, Length(b));
  until False;
end;

function StrMulStr(const a, b: LString): LString;
var
  scs: TSysCharSet;
  cnt: Integer;
  i: Integer;
  c: AnsiChar;
  d: PAnsiChar;
begin
  scs := [];
  cnt := 0;

  for i := 1 to Length(a) do
  begin
    c := a[i];
    if (not (c in scs)) then
    begin
      Include(scs, c);
      Inc(cnt);
    end;
  end;

  for i := 1 to Length(b) do
  begin
    c := b[i];
    if (not (c in scs)) then
    begin
      Include(scs, c);
      Inc(cnt);
    end;
  end;

  SetLength(Result, cnt);
  d := Pointer(Result);
  for c in scs do
  begin
    d^ := c;
    Inc(d);
  end;
end;

function StrDivStr(const a, b: LString): LString;
var
  scs: TSysCharSet;
  cnt: Integer;
  i: Integer;
  c: AnsiChar;
  d: PAnsiChar;
begin
  scs := [];
  cnt := 0;

  for i := 1 to Length(a) do
  begin
    c := a[i];
    if (not (c in scs)) then
    begin
      Include(scs, c);
      Inc(cnt);
    end;
  end;

  for i := 1 to Length(b) do
  begin
    c := b[i];
    if (c in scs) then
    begin
      Exclude(scs, c);
      Dec(cnt);
    end;
  end;

  SetLength(Result, cnt);
  d := Pointer(Result);
  for c in scs do
  begin
    d^ := c;
    Inc(d);
  end;
end;

function StrRemStr(const a, b: LString): LString; inline;
begin
  Exit(StrDivStr(a, b));
end;

function StrAndStr(const a, b: LString): LString;
var
  cscA, cscB, cscC: TSysCharSet;
  i: Integer;
  Buffer: array[Byte] of AnsiChar;
  c: AnsiChar;
begin
  cscA := [];
  cscB := [];

  for i := 1 to Length(a) do
    Include(cscA, a[i]);
  for i := 1 to Length(b) do
    Include(cscB, b[i]);

  cscC := (cscA * cscB);
  i := 0;
  for c in cscC do
  begin
    Buffer[i] := c;
    Inc(i);
  end;
  SetString(Result, PAnsiChar(@Buffer[0]), i);
end;

function StrOrStr(const a, b: LString): LString; inline;
begin
  Exit(StrMulStr(a, b));
end;

function StrPowerStr(const a, b: LString): LString; inline;
begin
  Exit(StrMulStr(a, b));
end;

function IPower(const Base: TMyInteger; const Exponent: Integer): TMyInteger;
var
  Y: Integer;
  LBase: TMyInteger;
begin
  if ((Base = 0) or (Base = 1)) then Exit(Base);
  if (Exponent < 0) then Exit(0);

  Y := Exponent;
  LBase := Base;
  Result := 1;

  while (Y > 0) do
  begin
    while (not Odd(Y)) do
    begin
      Y := (Y shr 1);
      LBase := (LBase * LBase)
    end;
    Dec(Y);
    Result := (Result * LBase)
  end;
end;

function fib(i: Integer): Integer;
begin
  if (i < 2) then Exit(i);
  Exit(fib(i - 1) + fib(i - 2));
end;

function I_Fibonacci_32(i: UInt32): UInt64;
var
  a, b: UInt64;
begin
  if (i < 2) then Exit(i);

  a := 0;
  b := 1;
  Dec(i);
  repeat
    Inc(a, b);
    Dec(i);
    if (i = 0) then Exit(a);
    Inc(b, a);
    Dec(i);
    if (i = 0) then Exit(b);
  until False;
end;

function I_F0(const i: UInt64): UInt64;
var
  j: UInt32;
  a, b: UInt64;
begin
  if (i >= 93) then
    Exit(UInt64(-1));

  j := UInt32(i);
  if (j < 2) then Exit(i);

  a := 0;
  b := 1;
  Dec(j);
  repeat
    Inc(a, b);
    Dec(j);
    if (j = 0) then Exit(a);
    Inc(b, a);
    Dec(j);
    if (j = 0) then Exit(b);
  until False;
end;

function I_F1(const i: UInt64): UInt64;
var
  j: UInt32;
begin
  j := UInt32(i);
  if (j <= 1) then Exit(1);

  Result := j;
  while (j > 2) do
  begin
    Dec(j);
    Result := (Result * j);
  end;
end;

procedure Error_(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData;
  const AMethodName: LString);
begin
  AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

function If_None(var AData: TMyEngineContextVariableData): Boolean;
begin
  Exit(False);
end;

function If_Bool(var AData: TMyEngineContextVariableData): Boolean;
begin
  Exit(AData.vBool);
end;

function If_Int(var AData: TMyEngineContextVariableData): Boolean;
begin
  Exit(AData.vInt <> 0);
end;

function If_Str(var AData: TMyEngineContextVariableData): Boolean;
begin
  Exit(Str2BoolDef(LString(AData.vStr), False));
end;

function If_Func(var AData: TMyEngineContextVariableData): Boolean;
begin
  Exit(AData.vFunc <> nil);
end;

function If_Array(var AData: TMyEngineContextVariableData): Boolean;
begin
  Exit(AData.vArr <> nil);
end;

function AsInt_None(var AData: TMyEngineContextVariableData): TMyInteger;
begin
  Exit(0);
end;

function AsInt_Bool(var AData: TMyEngineContextVariableData): TMyInteger;
begin
  if AData.vBool then
    Exit(1)
  else
    Exit(0);
end;

function AsInt_Int(var AData: TMyEngineContextVariableData): TMyInteger;
begin
  Exit(AData.vInt);
end;

function AsInt_Str(var AData: TMyEngineContextVariableData): TMyInteger;
var
  c: Integer;
begin
  System.Val(LString(AData.vStr), Result, c);
  if (c <> 0) then Exit(0);
end;

function AsInt_Func(var AData: TMyEngineContextVariableData): TMyInteger;
begin
  Exit(0);
end;

function AsInt_Array(var AData: TMyEngineContextVariableData): TMyInteger;
begin
  Exit(0);
end;

procedure vsNeg_None(var AData: TMyEngineContextVariableData);
begin
end;

procedure vsNeg_Bool(var AData: TMyEngineContextVariableData);
begin
  AData.vBool := (not AData.vBool);
end;

procedure vsNeg_Int(var AData: TMyEngineContextVariableData);
begin
  AData.vInt := (-AData.vInt);
end;

procedure vsNeg_Str(var AData: TMyEngineContextVariableData);
begin
end;

procedure vsNeg_Func(var AData: TMyEngineContextVariableData);
begin
end;

procedure vsNeg_Array(var AData: TMyEngineContextVariableData);
begin
end;

procedure cInvAdd_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvAdd_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[1].vBool);
end;

procedure cInvAdd_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[1].vInt);
end;

procedure cInvAdd_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[1].vStr));
end;

procedure cInvAdd_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsFunction(AParams[1].vFunc);
end;

procedure cInvAdd_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_None_Array');
end;

procedure cInvAdd_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool);
end;

procedure cInvAdd_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
  begin
    if AParams[1].vBool then
      AResult.SetAsInteger(2)
    else
      AResult.SetAsInteger(1);
  end else
  begin
    if AParams[1].vBool then
      AResult.SetAsInteger(1)
    else
      AResult.SetAsInteger(0);
  end;
end;

procedure cInvAdd_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsInteger(AParams[1].vInt + 1)
  else
    AResult.SetAsInteger(AParams[1].vInt);
end;

procedure cInvAdd_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(Bool2Str(AParams[0].vBool) + LString(AParams[1].vStr));
end;

procedure cInvAdd_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Bool_Func');
end;

procedure cInvAdd_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Bool_Array');
end;

procedure cInvAdd_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt);
end;

procedure cInvAdd_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsInteger(AParams[0].vInt + 1)
  else
    AResult.SetAsInteger(AParams[0].vInt);
end;

procedure cInvAdd_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt + AParams[1].vInt);
end;

procedure cInvAdd_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(Int2Str(AParams[0].vInt) + LString(AParams[1].vStr));
end;

procedure cInvAdd_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Int_Func');
end;

procedure cInvAdd_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Int_Array');
end;

procedure cInvAdd_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[0].vStr));
end;

procedure cInvAdd_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[0].vStr) + Bool2Str(AParams[1].vBool));
end;

procedure cInvAdd_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[0].vStr) + Int2Str(AParams[1].vInt));
end;

procedure cInvAdd_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[0].vStr) + LString(AParams[1].vStr));
end;

procedure cInvAdd_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Str_Func');
end;

procedure cInvAdd_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Str_Array');
end;

procedure cInvAdd_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsFunction(AParams[0].vFunc);
end;

procedure cInvAdd_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsFunction(AParams[0].vFunc)
  else
    AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvAdd_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Func_Int');
end;

procedure cInvAdd_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Func_Str');
end;

procedure cInvAdd_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Func_Func');
end;

procedure cInvAdd_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Func_Array');
end;

procedure cInvAdd_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Array_None');
end;

procedure cInvAdd_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Array_Bool');
end;

procedure cInvAdd_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Array_Int');
end;

procedure cInvAdd_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Array_Str');
end;

procedure cInvAdd_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Array_Func');
end;

procedure cInvAdd_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Add_Array_Array');
end;

{ Operador: Sub }

procedure cInvSub_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvSub_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsInteger(-1)
  else
    AResult.SetAsInteger(0);
end;

procedure cInvSub_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(-AParams[1].vInt);
end;

procedure cInvSub_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString('');
end;

procedure cInvSub_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_None_Func');
end;

procedure cInvSub_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_None_Array');
end;

procedure cInvSub_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool);
end;

procedure cInvSub_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
  begin
    if AParams[1].vBool then
      AResult.SetAsInteger(0)
    else
      AResult.SetAsInteger(1);
  end else
  begin
    if AParams[1].vBool then
      AResult.SetAsInteger(-1)
    else
      AResult.SetAsInteger(0);
  end;
end;

procedure cInvSub_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsInteger(1 - AParams[1].vInt)
  else
    AResult.SetAsInteger(- AParams[1].vInt);
end;

procedure cInvSub_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrSubStr(
    Bool2Str(AParams[0].vBool), LString(AParams[1].vStr)));
end;

procedure cInvSub_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsFunction(AParams[1].vFunc)
  else
    AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvSub_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Bool_Array');
end;

procedure cInvSub_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt);
end;

procedure cInvSub_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsInteger(AParams[0].vInt - 1)
  else
    AResult.SetAsInteger(AParams[0].vInt);
end;

procedure cInvSub_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt - AParams[1].vInt);
end;

procedure cInvSub_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrSubStr(Int2Str(AParams[0].vInt),
    LString(AParams[1].vStr)));
end;

procedure cInvSub_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Int_Func');
end;

procedure cInvSub_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
end;

procedure cInvSub_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[0].vStr));
end;

procedure cInvSub_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrSubStr(LString(AParams[0].vStr),
    Bool2Str(AParams[1].vBool)));
end;

procedure cInvSub_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrSubStr(LString(AParams[0].vStr),
    Int2Str(AParams[1].vInt)));
end;

procedure cInvSub_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrSubStr(LString(AParams[0].vStr),
    LString(AParams[1].vStr)));
end;

procedure cInvSub_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Str_Func');
end;

procedure cInvSub_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Str_Array');
end;

procedure cInvSub_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsFunction(AParams[0].vFunc);
end;

procedure cInvSub_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsFunction(AParams[0].vFunc)
  else
    AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvSub_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Func_Int');
end;

procedure cInvSub_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Func_Str');
end;

procedure cInvSub_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Func_Func');
end;

procedure cInvSub_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Func_Array');
end;

procedure cInvSub_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Array_None');
end;

procedure cInvSub_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Array_Bool');
end;

procedure cInvSub_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Array_Int');
end;

procedure cInvSub_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Array_Str');
end;

procedure cInvSub_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Array_Func');
end;

procedure cInvSub_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Sub_Array_Array');
end;

{ Operador: Mul }

procedure cInvMul_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvMul_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[1].vBool);
end;

procedure cInvMul_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[1].vInt);
end;

procedure cInvMul_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[1].vStr));
end;

procedure cInvMul_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsFunction(AParams[1].vFunc);
end;

procedure cInvMul_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_None_Array');
end;

procedure cInvMul_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool);
end;

procedure cInvMul_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool and AParams[1].vBool);
end;

procedure cInvMul_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsInteger(AParams[1].vInt)
  else
    AResult.SetAsInteger(0);
end;

procedure cInvMul_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsString(LString(AParams[1].vStr))
  else
    AResult.SetAsString('');
end;

procedure cInvMul_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsFunction(AParams[1].vFunc)
  else
    AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvMul_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Bool_Array');
end;

procedure cInvMul_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt);
end;

procedure cInvMul_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsInteger(AParams[0].vInt)
  else
    AResult.SetAsInteger(0);
end;

procedure cInvMul_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt * AParams[1].vInt);
end;

procedure cInvMul_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrMulStr(LString(AParams[0].vStr),
    LString(AParams[1].vStr)));
end;

procedure cInvMul_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Int_Func');
end;

procedure cInvMul_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Int_Array');
end;

procedure cInvMul_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[0].vStr));
end;

procedure cInvMul_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrMulStr(LString(AParams[0].vStr),
    Bool2Str(AParams[1].vBool)));
end;

procedure cInvMul_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrMulStr(LString(AParams[0].vStr),
    Int2Str(AParams[1].vInt)));
end;

procedure cInvMul_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrMulStr(LString(AParams[0].vStr),
    LString(AParams[1].vStr)));
end;

procedure cInvMul_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Str_Func');
end;

procedure cInvMul_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Str_Array');
end;

procedure cInvMul_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Func_None');
end;

procedure cInvMul_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsFunction(AParams[0].vFunc)
  else
    AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvMul_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Func_Int');
end;

procedure cInvMul_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Func_Str');
end;

procedure cInvMul_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Func_Func');
end;

procedure cInvMul_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Func_Array');
end;

procedure cInvMul_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Array_None');
end;

procedure cInvMul_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Array_Bool');
end;

procedure cInvMul_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Array_Int');
end;

procedure cInvMul_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Array_Str');
end;

procedure cInvMul_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Array_Func');
end;

procedure cInvMul_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Mul_Array_Array');
end;

{ Operador: Div }

procedure cInvDiv_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvDiv_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_None_Bool');
end;

procedure cInvDiv_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_None_Int');
end;

procedure cInvDiv_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_None_Str');
end;

procedure cInvDiv_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_None_Func');
end;

procedure cInvDiv_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_None_Array');
end;

procedure cInvDiv_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool);
end;

procedure cInvDiv_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool or AParams[1].vBool);
end;

procedure cInvDiv_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Bool_Int');
end;

procedure cInvDiv_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Bool_Str');
end;

procedure cInvDiv_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Bool_Func');
end;

procedure cInvDiv_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Bool_Array');
end;

procedure cInvDiv_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Int_None');
end;

procedure cInvDiv_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Int_Bool');
end;

procedure cInvDiv_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt div AParams[1].vInt);
end;

procedure cInvDiv_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrDivStr(Int2Str(AParams[0].vInt),
    LString(AParams[1].vStr)));
end;

procedure cInvDiv_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Int_Func');
end;

procedure cInvDiv_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Int_Array');
end;

procedure cInvDiv_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Str_None');
end;

procedure cInvDiv_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrDivStr(LString(AParams[0].vStr),
    Bool2Str(AParams[1].vBool)));
end;

procedure cInvDiv_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrDivStr(LString(AParams[0].vStr),
    Int2Str(AParams[1].vInt)));
end;

procedure cInvDiv_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrDivStr(LString(AParams[0].vStr),
    LString(AParams[1].vStr)));
end;

procedure cInvDiv_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Str_Func');
end;

procedure cInvDiv_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Str_Array');
end;

procedure cInvDiv_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Func_None');
end;

procedure cInvDiv_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Func_Bool');
end;

procedure cInvDiv_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Func_Int');
end;

procedure cInvDiv_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Func_Str');
end;

procedure cInvDiv_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Func_Func');
end;

procedure cInvDiv_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Func_Array');
end;

procedure cInvDiv_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Array_None');
end;

procedure cInvDiv_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Array_Bool');
end;

procedure cInvDiv_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Array_Int');
end;

procedure cInvDiv_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Array_Str');
end;

procedure cInvDiv_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Array_Func');
end;

procedure cInvDiv_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Div_Array_Array');
end;

{ Operador: Rem }

procedure cInvRem_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetId(TMyEngineContextVariableDataTypeId.eNone);
end;

procedure cInvRem_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_None_Bool');
end;

procedure cInvRem_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_None_Int');
end;

procedure cInvRem_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_None_Str');
end;

procedure cInvRem_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_None_Func');
end;

procedure cInvRem_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_None_Array');
end;

procedure cInvRem_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Bool_None');
end;

procedure cInvRem_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool xor AParams[1].vBool);
end;

procedure cInvRem_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Bool_Int');
end;

procedure cInvRem_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Bool_Str');
end;

procedure cInvRem_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Bool_Func');
end;

procedure cInvRem_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Bool_Array');
end;

procedure cInvRem_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Int_None');
end;

procedure cInvRem_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Int_Bool');
end;

procedure cInvRem_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt mod AParams[1].vInt);
end;

procedure cInvRem_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrRemStr(Int2Str(AParams[0].vInt),
    LString(AParams[1].vStr)));
end;

procedure cInvRem_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Int_Func');
end;

procedure cInvRem_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Int_Array');
end;

procedure cInvRem_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Str_None');
end;

procedure cInvRem_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrRemStr(LString(AParams[0].vStr),
    Bool2Str(AParams[1].vBool)));
end;

procedure cInvRem_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrRemStr(LString(AParams[0].vStr),
    Int2Str(AParams[1].vInt)));
end;

procedure cInvRem_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrRemStr(LString(AParams[0].vStr),
    LString(AParams[1].vStr)));
end;

procedure cInvRem_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Str_Func');
end;

procedure cInvRem_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Str_Array');
end;

procedure cInvRem_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Func_None');
end;

procedure cInvRem_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Func_Bool');
end;

procedure cInvRem_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Func_Int');
end;

procedure cInvRem_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Func_Str');
end;

procedure cInvRem_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Func_Func');
end;

procedure cInvRem_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Func_Array');
end;

procedure cInvRem_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Array_None');
end;

procedure cInvRem_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Array_Bool');
end;

procedure cInvRem_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Array_Int');
end;

procedure cInvRem_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Array_Str');
end;

procedure cInvRem_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Array_Func');
end;

procedure cInvRem_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Rem_Array_Array');
end;

{ Operador: Eq }

procedure cInvEq_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvEq_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool = AParams[1].vBool);
end;

procedure cInvEq_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsBoolean(AParams[1].vInt = 1)
  else
    AResult.SetAsBoolean(AParams[1].vInt = 0);
end;

procedure cInvEq_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(cs_Bool[AParams[0].vBool] = LString(AParams[1].vStr));
end;

procedure cInvEq_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool = (AParams[1].vFunc <> nil));
end;

procedure cInvEq_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool = (AParams[1].vArr <> nil));
end;

procedure cInvEq_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsBoolean(AParams[0].vInt = 1)
  else
    AResult.SetAsBoolean(AParams[0].vInt = 0);
end;

procedure cInvEq_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vInt = AParams[1].vInt);
end;

procedure cInvEq_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(Int2Str(AParams[0].vInt) = LString(AParams[1].vStr));
end;

procedure cInvEq_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) = cs_Bool[AParams[1].vBool]);
end;

procedure cInvEq_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(
    LString(AParams[0].vStr) = Int2Str(AParams[1].vInt));
end;

procedure cInvEq_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) = LString(AParams[1].vStr));
end;

procedure cInvEq_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vFunc = AParams[1].vFunc);
end;

procedure cInvEq_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvEq_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vArr = AParams[1].vArr);
end;

{ Operador: Neq }

procedure cInvNeq_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvNeq_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool <> AParams[1].vBool);
end;

procedure cInvNeq_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsBoolean(AParams[1].vInt <> 1)
  else
    AResult.SetAsBoolean(AParams[1].vInt <> 0);
end;

procedure cInvNeq_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(cs_Bool[AParams[0].vBool] <> LString(AParams[1].vStr));
end;

procedure cInvNeq_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsBoolean(AParams[0].vInt <> 1)
  else
    AResult.SetAsBoolean(AParams[0].vInt <> 0);
end;

procedure cInvNeq_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vInt <> AParams[1].vInt);
end;

procedure cInvNeq_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(Int2Str(AParams[0].vInt) <> LString(AParams[1].vStr));
end;

procedure cInvNeq_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) <> cs_Bool[AParams[1].vBool]);
end;

procedure cInvNeq_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) <> Int2Str(AParams[1].vInt));
end;

procedure cInvNeq_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) <> LString(AParams[1].vStr));
end;

procedure cInvNeq_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vFunc <> AParams[1].vFunc);
end;

procedure cInvNeq_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvNeq_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vArr <> AParams[1].vArr);
end;

{ Operador: Lt }

procedure cInvLt_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool < AParams[1].vBool);
end;

procedure cInvLt_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsBoolean(1 < AParams[1].vInt)
  else
    AResult.SetAsBoolean(0 < AParams[1].vInt);
end;

procedure cInvLt_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(
    cs_Bool[AParams[0].vBool] <= LString(AParams[1].vStr));
end;

procedure cInvLt_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsBoolean(AParams[0].vInt < 1)
  else
    AResult.SetAsBoolean(AParams[0].vInt < 0);
end;

procedure cInvLt_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vInt < AParams[1].vInt);
end;

procedure cInvLt_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(
    Int2Str(AParams[0].vInt) < LString(AParams[1].vStr));
end;

procedure cInvLt_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(
    LString(AParams[0].vStr) < cs_Bool[AParams[1].vBool]);
end;

procedure cInvLt_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(
    LString(AParams[0].vStr) < Int2Str(AParams[1].vInt));
end;

procedure cInvLt_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) < LString(AParams[1].vStr));
end;

procedure cInvLt_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLt_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

{ Operador: Gt }

procedure cInvGt_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool > AParams[1].vBool);
end;

procedure cInvGt_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsBoolean(AParams[1].vInt > 1)
  else
    AResult.SetAsBoolean(AParams[1].vInt > 0);
end;

procedure cInvGt_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(cs_Bool[AParams[0].vBool] > LString(AParams[1].vStr));
end;

procedure cInvGt_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsBoolean(AParams[0].vInt > 1)
  else
    AResult.SetAsBoolean(AParams[0].vInt > 0);
end;

procedure cInvGt_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vInt > AParams[1].vInt);
end;

procedure cInvGt_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(Int2Str(AParams[0].vInt) > LString(AParams[1].vStr));
end;

procedure cInvGt_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) > cs_Bool[AParams[1].vBool]);
end;

procedure cInvGt_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) > Int2Str(AParams[1].vInt));
end;

procedure cInvGt_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) > LString(AParams[1].vStr));
end;

procedure cInvGt_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGt_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

{ Operador: Lte }

procedure cInvLte_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvLte_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool <= AParams[1].vBool);
end;

procedure cInvLte_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsBoolean(1 <= AParams[1].vInt)
  else
    AResult.SetAsBoolean(0 <= AParams[1].vInt);
end;

procedure cInvLte_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(cs_Bool[AParams[0].vBool] <= LString(AParams[1].vStr));
end;

procedure cInvLte_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsBoolean(AParams[0].vInt <= 1)
  else
    AResult.SetAsBoolean(AParams[0].vInt <= 0);
end;

procedure cInvLte_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vInt <= AParams[1].vInt);
end;

procedure cInvLte_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(Int2Str(AParams[0].vInt) <= LString(AParams[1].vStr));
end;

procedure cInvLte_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) <= cs_Bool[AParams[1].vBool]);
end;

procedure cInvLte_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) <= Int2Str(AParams[1].vInt));
end;

procedure cInvLte_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) <= LString(AParams[1].vStr));
end;

procedure cInvLte_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vFunc = AParams[1].vFunc);
end;

procedure cInvLte_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvLte_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vArr = AParams[1].vArr);
end;

{ Operador: Gte }

procedure cInvGte_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(True);
end;

procedure cInvGte_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool >= AParams[1].vBool);
end;

procedure cInvGte_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[0].vBool then
    AResult.SetAsBoolean(1 >= AParams[1].vInt)
  else
    AResult.SetAsBoolean(0 >= AParams[1].vInt);
end;

procedure cInvGte_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(cs_Bool[AParams[0].vBool] >= LString(AParams[1].vStr));
end;

procedure cInvGte_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  if AParams[1].vBool then
    AResult.SetAsBoolean(AParams[0].vInt >= 1)
  else
    AResult.SetAsBoolean(AParams[0].vInt >= 0);
end;

procedure cInvGte_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vInt >= AParams[1].vInt);
end;

procedure cInvGte_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(Int2Str(AParams[0].vInt) >= LString(AParams[1].vStr));
end;

procedure cInvGte_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) >= cs_Bool[AParams[1].vBool]);
end;

procedure cInvGte_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) >= Int2Str(AParams[1].vInt));
end;

procedure cInvGte_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(LString(AParams[0].vStr) >= LString(AParams[1].vStr));
end;

procedure cInvGte_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vFunc = AParams[1].vFunc);
end;

procedure cInvGte_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvGte_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vArr = AParams[1].vArr);
end;

{ Operador: And }

procedure cInvAnd_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool and AParams[1].vBool);
end;

procedure cInvAnd_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool and (AParams[1].vInt <> 0));
end;

procedure cInvAnd_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool and
    Str2BoolDef(LString(AParams[1].vStr), False));
end;

procedure cInvAnd_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vInt <> 0) and AParams[1].vBool);
end;

procedure cInvAnd_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt and AParams[1].vInt);
end;

procedure cInvAnd_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrAndStr(Int2Str(AParams[1].vInt), LString(AParams[1].vStr)));
end;

procedure cInvAnd_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrAndStr(LString(AParams[0].vStr), cs_Bool[AParams[1].vBool]));
end;

procedure cInvAnd_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrAndStr(LString(AParams[0].vStr), Int2Str(AParams[1].vInt)));
end;

procedure cInvAnd_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrAndStr(LString(AParams[0].vStr), LString(AParams[1].vStr)));
end;

procedure cInvAnd_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvAnd_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

{ Operador: Or }

procedure cInvOr_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(False);
end;

procedure cInvOr_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[1].vBool);
end;

procedure cInvOr_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[1].vInt);
end;

procedure cInvOr_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(LString(AParams[1].vStr));
end;

procedure cInvOr_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsFunction(AParams[1].vFunc);
end;

procedure cInvOr_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[1].vArr <> nil);
end;

procedure cInvOr_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool);
end;

procedure cInvOr_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool or AParams[1].vBool);
end;

procedure cInvOr_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool or (AParams[1].vInt <> 0));
end;

procedure cInvOr_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrOrStr(Bool2Str(AParams[0].vBool), LString(AParams[1].vStr)));
end;

procedure cInvOr_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool or (AParams[1].vFunc <> nil));
end;

procedure cInvOr_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vBool or (AParams[1].vArr <> nil));
end;

procedure cInvOr_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt);
end;

procedure cInvOr_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vInt <> 0) or AParams[1].vBool);
end;

procedure cInvOr_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(AParams[0].vInt or AParams[1].vInt);
end;

procedure cInvOr_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrOrStr(Int2Str(AParams[0].vInt), LString(AParams[1].vStr)));
end;

procedure cInvOr_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vInt <> 0) or (AParams[1].vFunc <> nil));
end;

procedure cInvOr_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vInt <> 0) or (AParams[1].vArr <> nil));
end;

procedure cInvOr_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(Str2BoolDef(LString(AParams[0].vStr), False));
end;

procedure cInvOr_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrOrStr(LString(AParams[0].vStr),
    cs_Bool[AParams[1].vBool]));
end;

procedure cInvOr_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrOrStr(LString(AParams[0].vStr),
    Int2Str(AParams[1].vInt)));
end;

procedure cInvOr_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(StrOrStr(LString(AParams[0].vStr),
    LString(AParams[1].vStr)));
end;

procedure cInvOr_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(Str2BoolDef(LString(AParams[0].vStr), False)
    or (AParams[1].vFunc <> nil));
end;

procedure cInvOr_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(Str2BoolDef(LString(AParams[0].vStr), False)
    or (AParams[1].vArr <> nil));
end;

procedure cInvOr_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vFunc <> nil);
end;

procedure cInvOr_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vFunc <> nil) or AParams[1].vBool);
end;

procedure cInvOr_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vFunc <> nil) and (AParams[1].vInt <> 0));
end;

procedure cInvOr_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vFunc <> nil)
    or Str2BoolDef(LString(AParams[1].vStr), False));
end;

procedure cInvOr_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vFunc <> nil) or (AParams[1].vFunc <> nil));
end;

procedure cInvOr_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vFunc <> nil) or (AParams[1].vArr <> nil));
end;

procedure cInvOr_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean(AParams[0].vArr <> nil);
end;

procedure cInvOr_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vArr <> nil) and AParams[1].vBool);
end;

procedure cInvOr_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vArr <> nil) or (AParams[1].vInt <> 0));
end;

procedure cInvOr_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vArr <> nil) or
    Str2BoolDef(LString(AParams[1].vStr), False));
end;

procedure cInvOr_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vArr <> nil) or (AParams[1].vFunc <> nil));
end;

procedure cInvOr_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsBoolean((AParams[0].vArr <> nil) or (AParams[1].vArr <> nil));
end;

{ Operador: Power }

procedure cInvPower_None_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_None_None');
end;

procedure cInvPower_None_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_None_Bool');
end;

procedure cInvPower_None_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_None_Int');
end;

procedure cInvPower_None_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_None_Str');
end;

procedure cInvPower_None_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_None_Func');
end;

procedure cInvPower_None_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_None_Array');
end;

procedure cInvPower_Bool_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Bool_None');
end;

procedure cInvPower_Bool_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Bool_Bool');
end;

procedure cInvPower_Bool_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Bool_Int');
end;

procedure cInvPower_Bool_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Bool_Str');
end;

procedure cInvPower_Bool_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Bool_Func');
end;

procedure cInvPower_Bool_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Bool_Array');
end;

procedure cInvPower_Int_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Int_None');
end;

procedure cInvPower_Int_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Int_Bool');
end;

procedure cInvPower_Int_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsInteger(IPower(AParams[0].vInt, AParams[1].vInt));
end;

procedure cInvPower_Int_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrPowerStr(Int2Str(AParams[0].vInt), LString(AParams[1].vStr)));
end;

procedure cInvPower_Int_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Int_Func');
end;

procedure cInvPower_Int_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Int_Array');
end;

procedure cInvPower_Str_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Str_None');
end;

procedure cInvPower_Str_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrPowerStr(LString(AParams[0].vStr), cs_Bool[AParams[1].vBool]));
end;

procedure cInvPower_Str_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrPowerStr(LString(AParams[0].vStr), Int2Str(AParams[1].vInt)));
end;

procedure cInvPower_Str_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  AResult.SetAsString(
    StrPowerStr(LString(AParams[0].vStr), LString(AParams[1].vStr)));
end;

procedure cInvPower_Str_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Str_Func');
end;

procedure cInvPower_Str_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Str_Array');
end;

procedure cInvPower_Func_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Func_None');
end;

procedure cInvPower_Func_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Func_Bool');
end;

procedure cInvPower_Func_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Func_Int');
end;

procedure cInvPower_Func_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Func_Str');
end;

procedure cInvPower_Func_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Func_Func');
end;

procedure cInvPower_Func_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Func_Array');
end;

procedure cInvPower_Array_None(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Array_None');
end;

procedure cInvPower_Array_Bool(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Array_Bool');
end;

procedure cInvPower_Array_Int(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Array_Int');
end;

procedure cInvPower_Array_Str(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Array_Str');
end;

procedure cInvPower_Array_Func(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Array_Func');
end;

procedure cInvPower_Array_Array(var AParams: TMyEngineContextVariableData2;
  var AResult: TMyEngineContextVariableData);
begin
  Error_(AParams, AResult, 'Power_Array_Array');
end;

end.
