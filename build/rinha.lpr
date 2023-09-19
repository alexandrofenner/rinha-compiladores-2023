program rinha;

uses
  MyTypes,
  MySysUtils,
  MyOsErrMsgs,
  MyScanner,
  MyErrs,
  MyData,
  MyOperators,
  MySystem,
  MyCombinationUnit,
  MyEngine;

procedure AppRun;
var
  LFileName: LString;
begin
  LFileName := ParamStr(1);
  if (Length(LFileName) = 0) then
    LFileName := '/var/rinha/source.rinha';

  MyScanner_Initialize(MyLoadStringFromFile(LFileName));
  MyEngine_Execute;
end;

begin
  try
    AppRun;
    MyExit(0);
  except
    MyWriteLn('A execução do aplicativo falhou');
    MyWriteLn(HandleException);
    MyExit(1);
  end;
end.

