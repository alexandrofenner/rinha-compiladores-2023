(******************************************************************************)
(*                                                                            *)
(*  Interpretador escrito em Pascal                                           *)
(*  Autor: Alexandro Landmann Fenner                                          *)
(*                                                                            *)
(*  alexandrofenner@gmail.com                                                 *)
(*  https://www.linkedin.com/in/alexandro-fenner-67842960/                    *)
(*                                                                            *)
(******************************************************************************)
unit MyCombinationUnit;

{$mode Delphi}
{$pointermath on}
{$scopedenums on}
{$warnings off}
{$hints off}
{$notes off}

interface

function My_Combination(n, k: UInt64): UInt64;

implementation

uses
  MySystem;

function Combination_1(n: UInt64): UInt64;
begin
  Exit(1);
end;

function Combination_2(n: UInt64): UInt64;
begin
  if (n <= 2) then Exit(1);
  Exit(My_SumOfApTerms(n-1));
end;

{******************************************************************************
*                                                                             *
*     O código abaixo foi gerado com um gerador de código-fonte               *
*     Por isso é meio estranho..                                              *
*                                                                             *
*     Alexandro Landmann Fenner (2023-09-16)                                  *
*                                                                             *
*******************************************************************************}
function Combination_3(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
begin
  if (n <= 3) then Exit(1);
  Result := 4;
  v0 := 6;
  v1 := 4;
  while (n > 3) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1);
    Dec(n);
  end;
end;
function Combination_4(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
begin
  if (n <= 4) then Exit(1);
  Result := 5;
  v0 := 10;
  v1 := 10;
  v2 := 5;
  while (n > 4) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2);
    Dec(n);
  end;
end;
function Combination_5(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
begin
  if (n <= 5) then Exit(1);
  Result := 6;
  v0 := 15;
  v1 := 20;
  v2 := 15;
  v3 := 6;
  while (n > 5) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3);
    Dec(n);
  end;
end;
function Combination_6(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
begin
  if (n <= 6) then Exit(1);
  Result := 7;
  v0 := 21;
  v1 := 35;
  v2 := 35;
  v3 := 21;
  v4 := 7;
  while (n > 6) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4);
    Dec(n);
  end;
end;
function Combination_7(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
begin
  if (n <= 7) then Exit(1);
  Result := 8;
  v0 := 28;
  v1 := 56;
  v2 := 70;
  v3 := 56;
  v4 := 28;
  v5 := 8;
  while (n > 7) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5);
    Dec(n);
  end;
end;
function Combination_8(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
begin
  if (n <= 8) then Exit(1);
  Result := 9;
  v0 := 36;
  v1 := 84;
  v2 := 126;
  v3 := 126;
  v4 := 84;
  v5 := 36;
  v6 := 9;
  while (n > 8) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6);
    Dec(n);
  end;
end;
function Combination_9(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
begin
  if (n <= 9) then Exit(1);
  Result := 10;
  v0 := 45;
  v1 := 120;
  v2 := 210;
  v3 := 252;
  v4 := 210;
  v5 := 120;
  v6 := 45;
  v7 := 10;
  while (n > 9) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7);
    Dec(n);
  end;
end;
function Combination_10(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
begin
  if (n <= 10) then Exit(1);
  Result := 11;
  v0 := 55;
  v1 := 165;
  v2 := 330;
  v3 := 462;
  v4 := 462;
  v5 := 330;
  v6 := 165;
  v7 := 55;
  v8 := 11;
  while (n > 10) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8);
    Dec(n);
  end;
end;
function Combination_11(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
begin
  if (n <= 11) then Exit(1);
  Result := 12;
  v0 := 66;
  v1 := 220;
  v2 := 495;
  v3 := 792;
  v4 := 924;
  v5 := 792;
  v6 := 495;
  v7 := 220;
  v8 := 66;
  v9 := 12;
  while (n > 11) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9);
    Dec(n);
  end;
end;
function Combination_12(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
begin
  if (n <= 12) then Exit(1);
  Result := 13;
  v0 := 78;
  v1 := 286;
  v2 := 715;
  v3 := 1287;
  v4 := 1716;
  v5 := 1716;
  v6 := 1287;
  v7 := 715;
  v8 := 286;
  v9 := 78;
  v10 := 13;
  while (n > 12) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10);
    Dec(n);
  end;
end;
function Combination_13(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
begin
  if (n <= 13) then Exit(1);
  Result := 14;
  v0 := 91;
  v1 := 364;
  v2 := 1001;
  v3 := 2002;
  v4 := 3003;
  v5 := 3432;
  v6 := 3003;
  v7 := 2002;
  v8 := 1001;
  v9 := 364;
  v10 := 91;
  v11 := 14;
  while (n > 13) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11);
    Dec(n);
  end;
end;
function Combination_14(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
begin
  if (n <= 14) then Exit(1);
  Result := 15;
  v0 := 105;
  v1 := 455;
  v2 := 1365;
  v3 := 3003;
  v4 := 5005;
  v5 := 6435;
  v6 := 6435;
  v7 := 5005;
  v8 := 3003;
  v9 := 1365;
  v10 := 455;
  v11 := 105;
  v12 := 15;
  while (n > 14) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12);
    Dec(n);
  end;
end;
function Combination_15(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
begin
  if (n <= 15) then Exit(1);
  Result := 16;
  v0 := 120;
  v1 := 560;
  v2 := 1820;
  v3 := 4368;
  v4 := 8008;
  v5 := 11440;
  v6 := 12870;
  v7 := 11440;
  v8 := 8008;
  v9 := 4368;
  v10 := 1820;
  v11 := 560;
  v12 := 120;
  v13 := 16;
  while (n > 15) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13);
    Dec(n);
  end;
end;
function Combination_16(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
begin
  if (n <= 16) then Exit(1);
  Result := 17;
  v0 := 136;
  v1 := 680;
  v2 := 2380;
  v3 := 6188;
  v4 := 12376;
  v5 := 19448;
  v6 := 24310;
  v7 := 24310;
  v8 := 19448;
  v9 := 12376;
  v10 := 6188;
  v11 := 2380;
  v12 := 680;
  v13 := 136;
  v14 := 17;
  while (n > 16) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14);
    Dec(n);
  end;
end;
function Combination_17(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
begin
  if (n <= 17) then Exit(1);
  Result := 18;
  v0 := 153;
  v1 := 816;
  v2 := 3060;
  v3 := 8568;
  v4 := 18564;
  v5 := 31824;
  v6 := 43758;
  v7 := 48620;
  v8 := 43758;
  v9 := 31824;
  v10 := 18564;
  v11 := 8568;
  v12 := 3060;
  v13 := 816;
  v14 := 153;
  v15 := 18;
  while (n > 17) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15);
    Dec(n);
  end;
end;
function Combination_18(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
begin
  if (n <= 18) then Exit(1);
  Result := 19;
  v0 := 171;
  v1 := 969;
  v2 := 3876;
  v3 := 11628;
  v4 := 27132;
  v5 := 50388;
  v6 := 75582;
  v7 := 92378;
  v8 := 92378;
  v9 := 75582;
  v10 := 50388;
  v11 := 27132;
  v12 := 11628;
  v13 := 3876;
  v14 := 969;
  v15 := 171;
  v16 := 19;
  while (n > 18) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16);
    Dec(n);
  end;
end;

function Combination_19(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
begin
  if (n <= 19) then Exit(1);
  Result := 191;
  v0 := 1330;
  v1 := 5985;
  v2 := 20349;
  v3 := 54264;
  v4 := 116280;
  v5 := 203490;
  v6 := 293930;
  v7 := 352716;
  v8 := 352716;
  v9 := 293930;
  v10 := 203490;
  v11 := 116280;
  v12 := 54264;
  v13 := 20349;
  v14 := 5985;
  v15 := 1330;
  v16 := 210;
  v17 := 21;
  while (n > 19) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17);
    Dec(n);
  end;
end;
function Combination_20(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
begin
  if (n <= 20) then Exit(1);
  Result := 192;
  v0 := 1521;
  v1 := 7315;
  v2 := 26334;
  v3 := 74613;
  v4 := 170544;
  v5 := 319770;
  v6 := 497420;
  v7 := 646646;
  v8 := 705432;
  v9 := 646646;
  v10 := 497420;
  v11 := 319770;
  v12 := 170544;
  v13 := 74613;
  v14 := 26334;
  v15 := 7315;
  v16 := 1540;
  v17 := 231;
  v18 := 22;
  while (n > 20) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18);
    Dec(n);
  end;
end;
function Combination_21(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
begin
  if (n <= 21) then Exit(1);
  Result := 193;
  v0 := 1713;
  v1 := 8836;
  v2 := 33649;
  v3 := 100947;
  v4 := 245157;
  v5 := 490314;
  v6 := 817190;
  v7 := 1144066;
  v8 := 1352078;
  v9 := 1352078;
  v10 := 1144066;
  v11 := 817190;
  v12 := 490314;
  v13 := 245157;
  v14 := 100947;
  v15 := 33649;
  v16 := 8855;
  v17 := 1771;
  v18 := 253;
  v19 := 23;
  while (n > 21) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19);
    Dec(n);
  end;
end;
function Combination_22(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
begin
  if (n <= 22) then Exit(1);
  Result := 194;
  v0 := 1906;
  v1 := 10549;
  v2 := 42485;
  v3 := 134596;
  v4 := 346104;
  v5 := 735471;
  v6 := 1307504;
  v7 := 1961256;
  v8 := 2496144;
  v9 := 2704156;
  v10 := 2496144;
  v11 := 1961256;
  v12 := 1307504;
  v13 := 735471;
  v14 := 346104;
  v15 := 134596;
  v16 := 42504;
  v17 := 10626;
  v18 := 2024;
  v19 := 276;
  v20 := 24;
  while (n > 22) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20);
    Dec(n);
  end;
end;
function Combination_23(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
begin
  if (n <= 23) then Exit(1);
  Result := 195;
  v0 := 2100;
  v1 := 12455;
  v2 := 53034;
  v3 := 177081;
  v4 := 480700;
  v5 := 1081575;
  v6 := 2042975;
  v7 := 3268760;
  v8 := 4457400;
  v9 := 5200300;
  v10 := 5200300;
  v11 := 4457400;
  v12 := 3268760;
  v13 := 2042975;
  v14 := 1081575;
  v15 := 480700;
  v16 := 177100;
  v17 := 53130;
  v18 := 12650;
  v19 := 2300;
  v20 := 300;
  v21 := 25;
  while (n > 23) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21);
    Dec(n);
  end;
end;
function Combination_24(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
begin
  if (n <= 24) then Exit(1);
  Result := 196;
  v0 := 2295;
  v1 := 14555;
  v2 := 65489;
  v3 := 230115;
  v4 := 657781;
  v5 := 1562275;
  v6 := 3124550;
  v7 := 5311735;
  v8 := 7726160;
  v9 := 9657700;
  v10 := 10400600;
  v11 := 9657700;
  v12 := 7726160;
  v13 := 5311735;
  v14 := 3124550;
  v15 := 1562275;
  v16 := 657800;
  v17 := 230230;
  v18 := 65780;
  v19 := 14950;
  v20 := 2600;
  v21 := 325;
  v22 := 26;
  while (n > 24) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22);
    Dec(n);
  end;
end;
function Combination_25(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
  v23: UInt64;
begin
  if (n <= 25) then Exit(1);
  Result := 197;
  v0 := 2491;
  v1 := 16850;
  v2 := 80044;
  v3 := 295604;
  v4 := 887896;
  v5 := 2220056;
  v6 := 4686825;
  v7 := 8436285;
  v8 := 13037895;
  v9 := 17383860;
  v10 := 20058300;
  v11 := 20058300;
  v12 := 17383860;
  v13 := 13037895;
  v14 := 8436285;
  v15 := 4686825;
  v16 := 2220075;
  v17 := 888030;
  v18 := 296010;
  v19 := 80730;
  v20 := 17550;
  v21 := 2925;
  v22 := 351;
  v23 := 27;
  while (n > 25) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22, v23);
    Inc(v23);
    Dec(n);
  end;
end;
function Combination_26(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
  v23: UInt64;
  v24: UInt64;
begin
  if (n <= 26) then Exit(1);
  Result := 198;
  v0 := 2688;
  v1 := 19341;
  v2 := 96894;
  v3 := 375648;
  v4 := 1183500;
  v5 := 3107952;
  v6 := 6906881;
  v7 := 13123110;
  v8 := 21474180;
  v9 := 30421755;
  v10 := 37442160;
  v11 := 40116600;
  v12 := 37442160;
  v13 := 30421755;
  v14 := 21474180;
  v15 := 13123110;
  v16 := 6906900;
  v17 := 3108105;
  v18 := 1184040;
  v19 := 376740;
  v20 := 98280;
  v21 := 20475;
  v22 := 3276;
  v23 := 378;
  v24 := 28;
  while (n > 26) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22, v23);
    Inc(v23, v24);
    Inc(v24);
    Dec(n);
  end;
end;
function Combination_27(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
  v23: UInt64;
  v24: UInt64;
  v25: UInt64;
begin
  if (n <= 27) then Exit(1);
  Result := 2887;
  v0 := 24915;
  v1 := 138264;
  v2 := 588777;
  v3 := 2031690;
  v4 := 5850600;
  v5 := 14306285;
  v6 := 30044824;
  v7 := 54627281;
  v8 := 86493225;
  v9 := 119759850;
  v10 := 145422675;
  v11 := 155117520;
  v12 := 145422675;
  v13 := 119759850;
  v14 := 86493225;
  v15 := 54627300;
  v16 := 30045015;
  v17 := 14307150;
  v18 := 5852925;
  v19 := 2035800;
  v20 := 593775;
  v21 := 142506;
  v22 := 27405;
  v23 := 4060;
  v24 := 435;
  v25 := 30;
  while (n > 27) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22, v23);
    Inc(v23, v24);
    Inc(v24, v25);
    Inc(v25);
    Dec(n);
  end;
end;
function Combination_28(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
  v23: UInt64;
  v24: UInt64;
  v25: UInt64;
  v26: UInt64;
begin
  if (n <= 28) then Exit(1);
  Result := 2888;
  v0 := 27802;
  v1 := 163179;
  v2 := 727041;
  v3 := 2620467;
  v4 := 7882290;
  v5 := 20156885;
  v6 := 44351109;
  v7 := 84672105;
  v8 := 141120506;
  v9 := 206253075;
  v10 := 265182525;
  v11 := 300540195;
  v12 := 300540195;
  v13 := 265182525;
  v14 := 206253075;
  v15 := 141120525;
  v16 := 84672315;
  v17 := 44352165;
  v18 := 20160075;
  v19 := 7888725;
  v20 := 2629575;
  v21 := 736281;
  v22 := 169911;
  v23 := 31465;
  v24 := 4495;
  v25 := 465;
  v26 := 31;
  while (n > 28) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22, v23);
    Inc(v23, v24);
    Inc(v24, v25);
    Inc(v25, v26);
    Inc(v26);
    Dec(n);
  end;
end;
function Combination_29(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
  v23: UInt64;
  v24: UInt64;
  v25: UInt64;
  v26: UInt64;
  v27: UInt64;
begin
  if (n <= 29) then Exit(1);
  Result := 2889;
  v0 := 30690;
  v1 := 190981;
  v2 := 890220;
  v3 := 3347508;
  v4 := 10502757;
  v5 := 28039175;
  v6 := 64507994;
  v7 := 129023214;
  v8 := 225792611;
  v9 := 347373581;
  v10 := 471435600;
  v11 := 565722720;
  v12 := 601080390;
  v13 := 565722720;
  v14 := 471435600;
  v15 := 347373600;
  v16 := 225792840;
  v17 := 129024480;
  v18 := 64512240;
  v19 := 28048800;
  v20 := 10518300;
  v21 := 3365856;
  v22 := 906192;
  v23 := 201376;
  v24 := 35960;
  v25 := 4960;
  v26 := 496;
  v27 := 32;
  while (n > 29) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22, v23);
    Inc(v23, v24);
    Inc(v24, v25);
    Inc(v25, v26);
    Inc(v26, v27);
    Inc(v27);
    Dec(n);
  end;
end;
function Combination_30(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
  v23: UInt64;
  v24: UInt64;
  v25: UInt64;
  v26: UInt64;
  v27: UInt64;
  v28: UInt64;
begin
  if (n <= 30) then Exit(1);
  Result := 2890;
  v0 := 33579;
  v1 := 221671;
  v2 := 1081201;
  v3 := 4237728;
  v4 := 13850265;
  v5 := 38541932;
  v6 := 92547169;
  v7 := 193531208;
  v8 := 354815825;
  v9 := 573166192;
  v10 := 818809181;
  v11 := 1037158320;
  v12 := 1166803110;
  v13 := 1166803110;
  v14 := 1037158320;
  v15 := 818809200;
  v16 := 573166440;
  v17 := 354817320;
  v18 := 193536720;
  v19 := 92561040;
  v20 := 38567100;
  v21 := 13884156;
  v22 := 4272048;
  v23 := 1107568;
  v24 := 237336;
  v25 := 40920;
  v26 := 5456;
  v27 := 528;
  v28 := 33;
  while (n > 30) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22, v23);
    Inc(v23, v24);
    Inc(v24, v25);
    Inc(v25, v26);
    Inc(v26, v27);
    Inc(v27, v28);
    Inc(v28);
    Dec(n);
  end;
end;
function Combination_31(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
  v23: UInt64;
  v24: UInt64;
  v25: UInt64;
  v26: UInt64;
  v27: UInt64;
  v28: UInt64;
  v29: UInt64;
begin
  if (n <= 31) then Exit(1);
  Result := 2891;
  v0 := 36469;
  v1 := 255250;
  v2 := 1302872;
  v3 := 5318929;
  v4 := 18087993;
  v5 := 52392197;
  v6 := 131089101;
  v7 := 286078377;
  v8 := 548347033;
  v9 := 927982017;
  v10 := 1391975373;
  v11 := 1855967501;
  v12 := 2203961430;
  v13 := 2333606220;
  v14 := 2203961430;
  v15 := 1855967520;
  v16 := 1391975640;
  v17 := 927983760;
  v18 := 548354040;
  v19 := 286097760;
  v20 := 131128140;
  v21 := 52451256;
  v22 := 18156204;
  v23 := 5379616;
  v24 := 1344904;
  v25 := 278256;
  v26 := 46376;
  v27 := 5984;
  v28 := 561;
  v29 := 34;
  while (n > 31) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22, v23);
    Inc(v23, v24);
    Inc(v24, v25);
    Inc(v25, v26);
    Inc(v26, v27);
    Inc(v27, v28);
    Inc(v28, v29);
    Inc(v29);
    Dec(n);
  end;
end;
function Combination_32(n: UInt64): UInt64;
var
  v0: UInt64;
  v1: UInt64;
  v2: UInt64;
  v3: UInt64;
  v4: UInt64;
  v5: UInt64;
  v6: UInt64;
  v7: UInt64;
  v8: UInt64;
  v9: UInt64;
  v10: UInt64;
  v11: UInt64;
  v12: UInt64;
  v13: UInt64;
  v14: UInt64;
  v15: UInt64;
  v16: UInt64;
  v17: UInt64;
  v18: UInt64;
  v19: UInt64;
  v20: UInt64;
  v21: UInt64;
  v22: UInt64;
  v23: UInt64;
  v24: UInt64;
  v25: UInt64;
  v26: UInt64;
  v27: UInt64;
  v28: UInt64;
  v29: UInt64;
  v30: UInt64;
begin
  if (n <= 32) then Exit(1);
  Result := 2892;
  v0 := 39360;
  v1 := 291719;
  v2 := 1558122;
  v3 := 6621801;
  v4 := 23406922;
  v5 := 70480190;
  v6 := 183481298;
  v7 := 417167478;
  v8 := 834425410;
  v9 := 1476329050;
  v10 := 2319957390;
  v11 := 3247942874;
  v12 := 4059928931;
  v13 := 4537567650;
  v14 := 4537567650;
  v15 := 4059928950;
  v16 := 3247943160;
  v17 := 2319959400;
  v18 := 1476337800;
  v19 := 834451800;
  v20 := 417225900;
  v21 := 183579396;
  v22 := 70607460;
  v23 := 23535820;
  v24 := 6724520;
  v25 := 1623160;
  v26 := 324632;
  v27 := 52360;
  v28 := 6545;
  v29 := 595;
  v30 := 35;
  while (n > 32) do
  begin
    Inc(Result, v0);
    Inc(v0, v1);
    Inc(v1, v2);
    Inc(v2, v3);
    Inc(v3, v4);
    Inc(v4, v5);
    Inc(v5, v6);
    Inc(v6, v7);
    Inc(v7, v8);
    Inc(v8, v9);
    Inc(v9, v10);
    Inc(v10, v11);
    Inc(v11, v12);
    Inc(v12, v13);
    Inc(v13, v14);
    Inc(v14, v15);
    Inc(v15, v16);
    Inc(v16, v17);
    Inc(v17, v18);
    Inc(v18, v19);
    Inc(v19, v20);
    Inc(v20, v21);
    Inc(v21, v22);
    Inc(v22, v23);
    Inc(v23, v24);
    Inc(v24, v25);
    Inc(v25, v26);
    Inc(v26, v27);
    Inc(v27, v28);
    Inc(v28, v29);
    Inc(v29, v30);
    Inc(v30);
    Dec(n);
  end;
end;

type
  TFuncCombination = function(n: UInt64): UInt64;

const
  cFuncTable: array[0..32] of TFuncCombination = (
    Combination_1,
    Combination_1,
    Combination_2,
    Combination_3,
    Combination_4,
    Combination_5,
    Combination_6,
    Combination_7,
    Combination_8,
    Combination_9,
    Combination_10,
    Combination_11,
    Combination_12,
    Combination_13,
    Combination_14,
    Combination_15,
    Combination_16,
    Combination_17,
    Combination_18,
    Combination_19,
    Combination_20,
    Combination_21,
    Combination_22,
    Combination_23,
    Combination_24,
    Combination_25,
    Combination_26,
    Combination_27,
    Combination_28,
    Combination_29,
    Combination_30,
    Combination_31,
    Combination_32
  );

function My_Combination(n, k: UInt64): UInt64;
begin
  if (k >= 33) then Exit(0);
  Exit(cFuncTable[k](n));
end;

end.

