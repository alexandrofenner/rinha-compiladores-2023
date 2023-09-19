(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*                                                                            *)
(******************************************************************************)
unit MySystem;

{$mode Delphi}
{$asmmode Intel}
{$pointermath on}
{$scopedenums on}
{$warnings off}
{$hints off}
{$notes off}

interface

uses
  MyTypes,
  MyErrs;

{
  Parametros X86-64 -- (Linux)

  1 -> RDI
  2 -> RSI
  3 -> RDX
  4 -> RCX
  5 -> R8
  6 -> R9
  7 .. -> stack
}

procedure MyExit(i: Int64);

procedure MyWrite(const S: LString);
procedure MyWriteLn(const S: LString);

function MyOpen(const S: LString): THandle;
procedure MyClose(h: THandle);
function MySeek(h: THandle; Offset, Origin: Int64): Int64;
function MyRead(h: THandle; b: Pointer; c: Int64): Int64;

function MyLoadStringFromFile(const S: LString): LString;

function My_Fibonacci(const i: UInt64): UInt64;
function My_Factorial(const i: UInt64): UInt64;
function My_SumOfApTerms(const i: UInt64): UInt64;

implementation

{$ifdef Linux}
procedure __ret; assembler; nostackframe;
asm
end;

procedure __ret_1; assembler; nostackframe;
asm
    xor rax, rax
    inc rax
end;

procedure __ret_neg_one; assembler; nostackframe;
asm
    xor rax, rax
    dec rax
end;

procedure __ret_rdi; assembler; nostackframe;
asm
    mov rax, rdi
end;

procedure MyExit(i: Int64); assembler; nostackframe;
asm
    mov rax, 60
//  rdi           ExitCode
   syscall
end;

procedure MyWrite(const S: LString); assembler; nostackframe;
asm
    test rdi, rdi
    jz  __ret
    mov rsi, rdi
    mov rax, 1
    mov rdi, 1
    mov rdx, [rsi-8]
    syscall
end;

procedure MyWriteLn(const S: LString); assembler; nostackframe;
asm
    test rdi, rdi
    jz  __ret
    mov rsi, rdi           // Chars Ptr
    mov rax, 1             // Sys_Write
    mov rdi, 1             // StdOutput
    mov rdx, [rsi-8]       // Chars Count
    syscall
    mov rax, 1             // Sys_Write
    mov rdi, 1             // StdOutput
    mov rsi, offset @lb    // Chars Ptr
    mov rdx, 1             // Chars Count
    syscall
    ret
@lb: db 10
end;

function MyOpen(const S: LString): THandle; assembler; nostackframe;
asm
   mov rax, 2            // Sys_Open
// rdi                      FileName
   xor rsi, rsi          // Flags -> ReadOnly
   mov rdx, 438          // Mode
   syscall
end;

procedure MyClose(h: THandle); assembler; nostackframe;
asm
   mov rax, 3            // Sys_Close
// rdi                      FileHandle
   syscall
end;

function MySeek(h: THandle; Offset, Origin: Int64): Int64; assembler; nostackframe;
asm
    mov rax, 8           // Sys_Seek
//  rdi                     FileHandle
//  rsi                     FileOffset
//  rdx                     Origin
    syscall
end;

function MyRead(h: THandle; b: Pointer; c: Int64): Int64; assembler; nostackframe;
asm
    mov rax, 0           // Sys_Read
//  rdi                     FileHandle
//  rsi                     Buffer
//  rdx                     BytesCount
    syscall
end;

function MyLoadStringFromFile(const S: LString): LString;
var
  h: THandle;
  b: Int64;
begin
  h := MyOpen(S);
  if (h < 0) then
    raise ETryLoadFileError.Create(S, -h);
  b := MySeek(h, 0, 2);
  MySeek(h, 0, 0);
  SetLength(Result, b);
  MyRead(h, Pointer(Result), b);
  MyClose(h);
end;

function My_Fibonacci(const i: UInt64): UInt64; nostackframe; assembler;
asm
    cmp rdi, 93
    jnb __ret_neg_one

    cmp rdi, 2
    jb  __ret_rdi

    xor rcx, rcx
    xor rax, rax
    inc rcx
    dec rdi

@loop:
    add rax, rcx
    dec rdi
    jz  __ret
    add rcx, rax
    dec rdi
    jnz @loop
    mov rax, rcx
end;

function My_Factorial(const i: UInt64): UInt64; assembler; nostackframe;
asm
    cmp rdi, 1
    jna __ret_1

    mov rax, rdi
@loop:
    dec rdi
    jz  __ret
    imul rax, rdi
    jmp @loop
end;

function My_SumOfApTerms(const i: UInt64): UInt64; assembler; nostackframe;
asm
    mov rax, rdi
    inc rax
    imul rax, rdi
    shr rax, 1
end;

{$endif Linux}

{$ifdef MSWindows}

const
  kernel32 = 'kernel32.dll';

function CreateFileA(AFileName: PAnsiChar;
  ADesiredAccess, AShareMode: Cardinal;
  ASecurityAttributes: Pointer;
  ACreationDisposition, AFlagsAndAttributes: Cardinal;
  ATemplateFile: THandle): THandle; stdcall;
  external kernel32 name 'CreateFileA';
function CloseHandle(AObject: THandle): LongBool; stdcall;
  external kernel32 name 'CloseHandle';
function SetFilePointerEx(AFile: THandle; ADistanceToMove: Int64;
  var ANewFilePointer: Int64; AMoveMethod: Cardinal): LongBool; stdcall;
  external kernel32 name 'SetFilePointerEx';
function ReadFile(AFile: THandle; ABuffer: Pointer;
  ANumberOfBytesToRead: Cardinal; var ANumberOfBytesRead: Cardinal;
  AOverlapped: Pointer): LongBool; stdcall;
  external kernel32 name 'ReadFile';

procedure MyExit(i: Int64);
begin
  System.Halt(i);
end;

procedure MyWrite(const S: LString);
begin
  System.Write(S);
end;

procedure MyWriteLn(const S: LString);
begin
  System.WriteLn(S);
end;

function MyOpen(const S: LString): THandle;
begin
  Exit(CreateFileA(Pointer(S), $80000000, $1, nil, 3, $80, 0));
end;

procedure MyClose(h: THandle);
begin
  CloseHandle(h);
end;

function MySeek(h: THandle; Offset, Origin: Int64): Int64;
begin
  Result := 0;
  SetFilePointerEx(h, Offset, Result, Origin);
end;

function MyRead(h: THandle; b: Pointer; c: Int64): Int64;
var
  r: Cardinal;
begin
  r := 0;
  ReadFile(h, b, c, r, nil);
  Exit(r);
end;

function MyLoadStringFromFile(const S: LString): LString;
var
  h: THandle;
  b: Int64;
begin
  h := MyOpen(S);
  if (h = THandle(-1)) then
    raise ETryLoadFileError.Create(S, GetLastError);
  b := MySeek(h, 0, 2);
  MySeek(h, 0, 0);
  SetLength(Result, b);
  MyRead(h, Pointer(Result), b);
  MyClose(h);
end;


procedure __ret;
asm
    .noframe
end;

procedure __ret_1;
asm
    .noframe

    xor rax, rax
    inc rax
end;

procedure __ret_neg_one;
asm
    .noframe

    xor rax, rax
    dec rax
end;

procedure __ret_rcx;
asm
    .noframe

    mov rax, rcx
end;

function My_Fibonacci(const i: UInt64): UInt64;
asm
    .noframe

    cmp rcx, 93
    jnb __ret_neg_one

    cmp rcx, 2
    jb  __ret_rcx

    xor rdx, rdx
    xor rax, rax
    inc rdx
    dec rcx

@loop:
    add rax, rdx
    dec rcx
    jz  __ret
    add rdx, rax
    dec rcx
    jnz @loop
    mov rax, rdx
end;

function My_Factorial(const i: UInt64): UInt64;
asm
    .noframe

    cmp rcx, 1
    jna __ret_1

    mov rax, rcx
@loop:
    dec rcx
    jz  __ret
    imul rax, rcx
    jmp @loop
end;

function My_SumOfApTerms(const i: UInt64): UInt64;
asm
    .noframe

    mov rax, rcx
    inc rax
    imul rax, rcx
    shr rax, 1
end;
{$endif MSWindows}


end.
