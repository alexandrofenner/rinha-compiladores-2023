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
unit sys.utils;

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

const
  cTwoDigitLookup: packed array[0..99] of array[1..2] of AnsiChar =
    ('00','01','02','03','04','05','06','07','08','09',
     '10','11','12','13','14','15','16','17','18','19',
     '20','21','22','23','24','25','26','27','28','29',
     '30','31','32','33','34','35','36','37','38','39',
     '40','41','42','43','44','45','46','47','48','49',
     '50','51','52','53','54','55','56','57','58','59',
     '60','61','62','63','64','65','66','67','68','69',
     '70','71','72','73','74','75','76','77','78','79',
     '80','81','82','83','84','85','86','87','88','89',
     '90','91','92','93','94','95','96','97','98','99');

function StrToBoolDef(const s: LString; const Default: Boolean): Boolean;

function BoolToLString(b: Boolean): LString;
function Int32ToLString(i: Integer): LString;
function Int64ToLString(i: Int64): LString;
function QtLString(const s: LString): LString;

function AsmSysOpen(const S: LString): THandle; assembler;
procedure AsmSysClose(h: THandle); assembler;
function AsmSysSeek(h: THandle; Offset, Origin: Int64): Int64; assembler;
function AsmSysRead(h: THandle; b: Pointer; c: Int64): Int64; assembler;

procedure AsmSysWrite(const s: LString); assembler;
procedure AsmSysWriteLn(const s: LString); assembler;

procedure AsmSysExit(i: Int64); assembler;

function SysLoadStringFromFile(const s: LString): LString;

implementation

uses
  sys.procs,
  err.classes;

function DivBy100(i: Cardinal): Cardinal; inline;
begin
  Exit(i div 100);
end;


function DivBy100000000(i: UInt64): UInt64; inline;
begin
  Exit(i div 100000000);
end;

function _Int32ToLString(Value: UInt32; Negative: Boolean): LString;
var
  I, K: Cardinal;
  Digits: Integer;
  P: PAnsiChar;
begin
  I := Value;
  if (I >= 10000) then
    if (I >= 1000000) then
      if (I >= 100000000) then
        Digits := (9 + Byte(Ord(I >= 1000000000)))
      else
        Digits := (7 + Byte(Ord(I >= 10000000)))
    else
      Digits := (5 + Byte(Ord(I >= 100000)))
  else
    if (I >= 100) then
      Digits := (3 + Byte(Ord(I >= 1000)))
    else
      Digits := (1 + Byte(Ord(I >= 10)));

  SetLength(Result, Digits + Ord(Negative));
  P := Pointer(Result);
  P^ := '-';
  Inc(P, Ord(Negative));
  while (Digits > 1) do
  begin
    K := I;
    I := DivBy100(I);
    Dec(K, I * 100);
    Dec(Digits, 2);
    PWord(@P[Digits])^ := Word(cTwoDigitLookup[K]);
  end;
  if (Digits <> 0) then
    P^ := AnsiChar(I or Ord('0'));
end;

function _Int64ToLString(Value: UInt64; Negative: Boolean): LString;
var
  R: packed array[0..1] of UInt32 absolute Value;

  I64, K64: UInt64;
  I32, K32: Cardinal;
  Digits: Byte;
  P: PAnsiChar;
begin
  if (R[1] = 0) then Exit(_Int32ToLString(R[0], Negative));

  I64 := Value;
  if (I64 >= 100000000000000) then
    if (I64 >= 10000000000000000) then
      if (I64 >= 1000000000000000000) then
        if (I64 >= 10000000000000000000) then
          Digits := 20
        else
          Digits := 19
      else
        Digits := (17 + Byte(Ord(I64 >= 100000000000000000)))
    else
      Digits := (15 + Byte(Ord(I64 >= 1000000000000000)))
  else
    if (I64 >= 1000000000000) then
      Digits := (13 + Byte(Ord(I64 >= 10000000000000)))
    else
      if (I64 >= 10000000000) then
        Digits := (11 + Byte(Ord(I64 >= 100000000000)))
      else
        Digits := 10;

  SetLength(Result, (Digits + Ord(Negative)));
  P := Pointer(Result);
  P^ := '-';
  Inc(P, Ord(Negative));
  if (Digits = 20) then
  begin
    P^ := '1';
    Inc(P);
    Dec(I64, 10000000000000000000);
    Dec(Digits);
  end;
  if (Digits > 17) then
  begin
    if (Digits = 19) then
    begin
      P^ := '0';
      while (I64 >= 1000000000000000000) do
      begin
        Dec(I64, 1000000000000000000);
        Inc(P^);
      end;
      Inc(P);
    end;
    P^ := '0';
    while (I64 >= 100000000000000000) do
    begin
      Dec(I64, 100000000000000000);
      Inc(P^);
    end;
    Inc(P);
    Digits := 17;
  end;
  K64 := I64;
  I64 := DivBy100000000(I64);
  Dec(K64, (I64 * 100000000));
  K32 := K64;
  I32 := DivBy100(K32);
  Dec(K32, I32 * 100);
  PWord(P + Digits - 2)^ := Word(cTwoDigitLookup[K32]);
  K32 := I32;
  I32 := DivBy100(I32);
  Dec(K32, I32 * 100);
  PWord(P + Digits - 4)^ := Word(cTwoDigitLookup[K32]);
  K32 := I32;
  I32 := DivBy100(I32);
  Dec(K32, I32 * 100);
  PWord(P + Digits - 6)^ := Word(cTwoDigitLookup[K32]);
  PWord(P + Digits - 8)^ := Word(cTwoDigitLookup[I32]);
  Dec(Digits, 8);
  I32 := I64;
  while (Digits > 1) do
  begin
    K32 := I32;
    I32 := DivBy100(I32);
    Dec(K32, I32 * 100);
    Dec(Digits, 2);
    PWord(@P[Digits])^ := Word(cTwoDigitLookup[K32]);
  end;
  if (Digits <> 0) then
    P^ := AnsiChar(I32 or Ord('0'));
end;

function StrToBoolDef(const s: LString; const Default: Boolean): Boolean;
begin
  if (s = s_True) then Exit(True);
  if (s = s_False) then Exit(False);
  Exit(Default);
end;

function BoolToLString(b: Boolean): LString;
begin
  if b then
    Exit(s_True)
  else
    Exit(s_False);
end;

function Int32ToLString(i: Integer): LString;
begin
  if (i < 0) then
    Exit(_Int32ToLString(-i, True))
  else
    Exit(_Int32ToLString(i, False));
end;

function Int64ToLString(i: Int64): LString;
begin
  if (i < 0) then
    Exit(_Int64ToLString(-i, True))
  else
    Exit(_Int64ToLString(i, False));
end;

function QtLString(const s: LString): LString;
begin
  Exit('''' + s + '''');
end;

function AsmSysOpen(const S: LString): THandle; assembler; nostackframe;
asm
    mov rax, 2           // Sys_Open
//  rdi                     FileName
    xor rsi, rsi         // Flags -> ReadOnly
    mov rdx, 438         // Mode
    syscall
end;

procedure AsmSysClose(h: THandle); assembler; nostackframe;
asm
    mov rax, 3           // Sys_Close
//  rdi                     FileHandle
    syscall
end;

function AsmSysSeek(h: THandle; Offset, Origin: Int64): Int64;
  assembler; nostackframe;
asm
    mov rax, 8           // Sys_Seek
//  rdi                     FileHandle
//  rsi                     FileOffset
//  rdx                     Origin
    syscall
end;

function AsmSysRead(h: THandle; b: Pointer; c: Int64): Int64;
  assembler; nostackframe;
asm
    xor rax, rax         // Sys_Read
//  rdi                     FileHandle
//  rsi                     Buffer
//  rdx                     BytesCount
    syscall
end;

procedure AsmSysWrite(const s: LString); assembler; nostackframe;
asm
    test rdi, rdi
    jz   AsmRet
    mov  rsi, rdi
    mov  rax, 1
    mov  rdi, 1
    mov  rdx, [rsi-8]
    syscall
end;

procedure AsmSysWriteLn(const s: LString); assembler; nostackframe;
asm
    test rdi, rdi
    jz   AsmRet
    mov  rsi, rdi           // Chars Ptr
    mov  rax, 1             // Sys_Write
    mov  rdi, 1             // StdOutput
    mov  rdx, [rsi-8]       // Chars Count
    syscall
    mov  rax, 1             // Sys_Write
    mov  rdi, 1             // StdOutput
    mov  rsi, offset @lb    // Chars Ptr
    mov  rdx, 1             // Chars Count
    syscall
    ret
@lb:
    db  10
end;

procedure AsmSysExit(i: Int64); assembler; nostackframe;
asm
    mov rax, 60
    //  rdi           ExitCode
    syscall
end;

function SysLoadStringFromFile(const s: LString): LString;
var
  h: THandle;
  b: Int64;
begin
  h := AsmSysOpen(s);
  if (h < 0) then
    raise ETryLoadFileError.Create(s, -h);
  b := AsmSysSeek(h, 0, 2);
  AsmSysSeek(h, 0, 0);
  SetLength(Result, b);
  AsmSysRead(h, Pointer(Result), b);
  AsmSysClose(h);
end;

end.

