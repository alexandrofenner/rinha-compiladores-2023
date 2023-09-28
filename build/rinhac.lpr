program rinhac;

uses
  sys.types,
  sys.procs,
  sys.utils,
  sys.funcs,
  sys.func_combination,
  sys.stringbuilder,

  data.types,
  data.stack,
  data.procs,
  data._array,

  scanner.types,
  scanner.reswords,
  scanner.procs,
  scanner.tostring,

  err.classes,
  err.osmsgs,

  engine.types,
  engine.consts,
  engine.procs,
  engine.operators,
  engine.checkrecursive,
  engine.recursivecache,
  engine.recursivecache_1,
  engine.recursivecache_2,
  engine.recursivecache_3,
  engine.recursivecache_4,
  engine.recursivecache_5,
  engine.recursivecache_6,
  engine.recursivecache_7,
  engine.recursivecache_8,
  engine.recursivecache_9,
  engine.recursivecache_10,
  engine.recursivecache_11,
  engine.recursivecache_12,
  engine.recursivecache_13,
  engine.recursivecache_14,
  engine.recursivecache_15,
  engine.recursivecache_16,
  engine.recursivecache_17,
  engine.recursivecache_18,
  engine.recursivecache_19,
  engine.recursivecache_20,
  engine.recursivecache_21,
  engine.recursivecache_22,
  engine.recursivecache_23,
  engine.recursivecache_n,

  engine.optimize, engine.optimize_op2, engine.runner.executecontext,
  engine.contextvalues, engine.validatefunc, engine.context, engine.decompiler,
  engine.closureconvertion;

procedure AppRun;
var
  LFileName: LString;
begin
  LFileName := ParamStr(1);
  if (Length(LFileName) = 0) then
    LFileName := '/var/rinha/source.rinha';

  Scanner_Initialize(SysLoadStringFromFile(LFileName));
  //WriteLn(TokenStack_ToString(gvTokens));

  EngineGlobal_Execute;
end;

begin
  try
    AppRun;
    AsmSysExit(0);
  except
    AsmSysWriteLn('A execução do aplicativo falhou');
    AsmSysWriteLn(HandleException);
    AsmSysExit(1);
  end;
end.

