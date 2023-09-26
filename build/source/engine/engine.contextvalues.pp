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
unit engine.contextvalues;

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
  sys.procs,
  engine.consts,
  engine.types;

function EngineContextValueConstBool_Create(
  const AValue: Boolean): PEngineContextValueConstBool; assembler;
function EngineContextValueConstInt_Create(
  const AValue: Int64): PEngineContextValueConstInt; assembler;
function EngineContextValueConstStr_Create(
  const AValue: LString): PEngineContextValueConstString; assembler;

implementation

const
  cInt_Table: array[0..199] of TEngineContextValueConstInt = (
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 0),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 1),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 2),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 3),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 4),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 5),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 6),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 7),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 8),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 9),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 10),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 11),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 12),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 13),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 14),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 15),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 16),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 17),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 18),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 19),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 20),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 21),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 22),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 23),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 24),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 25),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 26),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 27),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 28),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 29),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 30),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 31),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 32),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 33),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 34),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 35),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 36),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 37),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 38),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 39),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 40),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 41),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 42),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 43),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 44),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 45),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 46),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 47),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 48),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 49),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 50),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 51),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 52),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 53),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 54),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 55),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 56),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 57),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 58),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 59),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 60),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 61),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 62),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 63),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 64),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 65),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 66),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 67),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 68),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 69),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 70),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 71),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 72),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 73),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 74),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 75),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 76),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 77),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 78),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 79),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 80),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 81),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 82),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 83),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 84),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 85),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 86),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 87),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 88),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 89),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 90),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 91),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 92),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 93),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 94),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 95),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 96),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 97),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 98),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 99),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 100),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 101),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 102),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 103),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 104),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 105),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 106),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 107),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 108),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 109),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 110),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 111),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 112),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 113),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 114),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 115),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 116),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 117),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 118),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 119),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 120),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 121),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 122),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 123),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 124),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 125),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 126),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 127),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 128),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 129),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 130),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 131),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 132),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 133),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 134),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 135),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 136),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 137),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 138),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 139),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 140),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 141),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 142),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 143),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 144),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 145),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 146),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 147),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 148),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 149),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 150),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 151),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 152),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 153),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 154),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 155),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 156),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 157),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 158),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 159),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 160),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 161),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 162),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 163),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 164),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 165),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 166),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 167),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 168),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 169),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 170),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 171),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 172),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 173),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 174),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 175),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 176),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 177),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 178),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 179),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 180),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 181),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 182),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 183),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 184),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 185),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 186),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 187),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 188),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 189),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 190),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 191),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 192),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 193),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 194),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 195),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 196),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 197),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 198),
    (FBase: (FTypeId: EngCtxValueTpId_ConstInt); FConstValue: 199)
  );

function EngineContextValueConstBool_Create(
  const AValue: Boolean): PEngineContextValueConstBool; assembler; nostackframe;
asm
    test rdi, rdi
    jz @false
    mov rax, Offset c_EngCtxValueConstTrue
    ret
@false:
    mov rax, Offset c_EngCtxValueConstFalse
end;

function EngineContextValueConstInt_Create(
  const AValue: Int64): PEngineContextValueConstInt; assembler; nostackframe;
asm
    cmp rdi, 200
    mov rcx, Offset cInt_Table

    {$if SizeOf(TEngineContextValueConstInt) <> 16}
      {$message fatal 'É preciso que TEngineContextValueConstInt seja de 16 bytes ou alterar aqui'}
    {$endif }

    shl rdi, 4
    lea rax, [rdi + rcx]
    ret
@default:

    push rdi
    mov rdi, SizeOf(TEngineContextValueConstInt)
    call AllocMem
    mov [rax + TEngineContextValue.FTypeId], EngCtxValueTpId_ConstInt
    pop rdi
    mov [rax + TEngineContextValueConstInt.FConstValue], rdi
end;

function EngineContextValueConstStr_Create(
  const AValue: LString): PEngineContextValueConstString;
  assembler; nostackframe;
asm
    push rdi
    mov rdi, SizeOf(TEngineContextValueConstString)
    call AllocMem
    mov [rax + TEngineContextValue.FTypeId], EngCtxValueTpId_ConstString
    pop rsi
    lea rdi, [rax + TEngineContextValueConstInt.FConstValue]
    push rax
    call LStrCpy
    pop rax
end;

end.

