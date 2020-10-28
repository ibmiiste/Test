**FREE
//=====================================================================*
//  Empty Unit Test Case. Prints a protocol of the execution flow.     *
//=====================================================================*
//  Command to create the service program:                             *
//  RUCRTTST TSTPGM(RPGUNIT/TEMPLATE) SRCFILE(RPGUNIT/RPGUNIT1)        *
//=====================================================================*
//  Tools/400 STRPREPRC instructions:                                  *
//   >>PRE-COMPILER<<                                                  *
//     >>CRTCMD<<  RUCRTTST    TSTPGM(&LI/&OB) +                       *
//                             SRCFILE(&SL/&SF);                       *
//     >>COMPILE<<                                                     *
//       >>PARM<< COPTION(*SRCSTMT);                                   *
//       >>PARM<< DBGVIEW(*ALL);                                       *
//     >>END-COMPILE<<                                                 *
//     >>EXECUTE<<                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain option(*srcstmt) Bnddir('SERVICE');
dcl-f QSYSPRT printer(80) usropn oflind(*in70);

/copy QINCLUDE,TESTCASE                 //iRPGUnit Test Suite


// ============================================================
//  Opens the printer.
// ============================================================
dcl-proc openPrinter export;
  dcl-pi *n end-pi;

  open QSYSPRT;

end-proc;

// ============================================================
//  Prints a message.
// ============================================================
dcl-proc print export;
  dcl-pi *n;
    text varchar(128) value  options(*nopass);
  end-pi;

  dcl-ds lineOutput len(80) inz end-ds;

  if (%parms() >= 1);
    lineOutput = text;
  else;
    lineOutput = '';
  endif;
  write QSYSPRT lineOutput;

end-proc;

// ============================================================
//  Closes the printer.
// ============================================================
dcl-proc closePrinter export;
  dcl-pi *n end-pi;

  if (%open(QSYSPRT));
    close QSYSPRT;
  endif;

end-proc;

// ============================================================
//  Set up test suite. Executed once per RUCALLTST.
// ============================================================
dcl-proc setUpSuite export;
  dcl-pi *n end-pi;

  dcl-s rc char(1);

  runCmd('OVRPRTF FILE(QSYSPRT) TOFILE(*FILE) +
          SPLFNAME(PROC_FLOW) OVRSCOPE(*JOB)');
  monitor;
    openPrinter();
    print('Executing:   setUpSuite()');
  on-error;
  // ignore errors ...
  endmon;

  // ... but try to remove the override.
  monitor;
    runCmd('DLTOVR FILE(QSYSPRT) LVL(*JOB)');
  on-error;
    dsply '*** Failed to delete QSYSPRT override! ***' rc;
  endmon;

end-proc;

// ============================================================
//  Tear down test suite.
// ============================================================
dcl-proc tearDownSuite export;
  dcl-pi *n end-pi;

  print('Executing:   tearDownSuite()');
  closePrinter();

end-proc;

// ============================================================
//  Set up test case.
// ============================================================
dcl-proc setUp export;
  dcl-pi *n end-pi;

  print('Executing:   - setUp()');

end-proc;

// ============================================================
//  Tear down test case.
// ============================================================
dcl-proc tearDown export;
  dcl-pi *n end-pi;

  print('Executing:   - tearDown()');

end-proc;

// ============================================================
//  RPGUnit test case.
// ============================================================
dcl-proc testConvert_seconde_to_hhmm_1 export;
  dcl-pi *n end-pi;

  Dcl-s l_duree_seconde Packed(10:0) Inz(61154);
  Dcl-s l_duree_hhmm Time inz;
  Dcl-s l_duree_hhmm_char Char(5);

  print('Executing:       * testWhatever_1()');

// Place your assertions here.
l_duree_hhmm = l_duree_hhmm + %Seconds(l_duree_seconde);

l_duree_hhmm_char = %Char(l_duree_hhmm:*HMS);
Dsply l_duree_hhmm_char;

Aequal('16:59':l_duree_hhmm_char);

end-proc;

// ============================================================
//  RPGUnit test case.
// ============================================================
dcl-proc testWhatever_2 export;
  dcl-pi *n end-pi;

  print('Executing:       * testWhatever_2()');

// Place your assertions here.

end-proc;
