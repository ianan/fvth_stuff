pro make_new_ch_files


  ; Try generating new files from CHIANTI for f_vth using
  ; https://hesperia.gsfc.nasa.gov/ssw/packages/xray/idl/setup_chianti_cont.pro
  ; and
  ; https://hesperia.gsfc.nasa.gov/ssw/packages/xray/idl/setup_chianti_lines.pro
  ;
  ; 25-May-2023 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;
  ;

  ; Using parameters to match current v901 defaults in ssw
  ; For continuum
  ; These keV values are the defaults anyway 
  TIC
  contfile=setup_chianti_cont('CHIANTI',0.1,250,genxfile='chianti_cont_01_250_unity_v1002.geny')
  TOC
  
  ; For lines using my modified/bug fixed version of setup_chinait_lines.pro
  ; as chianti_version bug and by default was saving a savfile
  ; Also default is MOZZATTA ioneq but should be CHIANTI?
  TIC
  linefile=setup_chianti_lines('CHIANTI',0.7,12,ntemp=41,genxfile='chianti_lines_07_12_unity_v1002_t41.geny')
  TOC

  stop

  ;  ;
  ;  ;~~~~~~~~~~~ Lines ~~~~~~~~~~~~~~~~~~~~~~~~
  ;  ; Just run with the deafult parameters?
  ;  ;  And time how long it takes..
  ;  TIC
  ;  ;  Note that this version calls chianti_version as a function when its a routine
  ;  ; Has a save at the end which produces a big file - different config to previous ones?
  ;  ; save to geny has been commented out, so easy to change
  ;  res=setup_chianti_lines()
  ;  TOC
  ;
  ;  ;  On M1 Pro MacBook Pro
  ;  ;% Time elapsed: 802.56872 seconds.
  ;
  ;  ; Outputs a file called chianti_setup_cont.geny to current working directory,
  ;  ; i.e. what the function returns
  ;  ; help,res,/str
  ;  ; RES             STRING    = 'chianti_lines.sav'
  ;
  ;  ; Load it back in to see what was produced
  ;  ;  restore,res,/v
  ;  ;  % RESTORE: Portable (XDR) compressed SAVE/RESTORE file.
  ;  ;  % RESTORE: Save file written by iain@sycorax, Thu May 25 22:24:53 2023.
  ;  ;  % RESTORE: IDL version 8.8.3 (darwin, x86_64).
  ;  ;  % RESTORE: Restored variable: ZINDEX.
  ;  ;  % RESTORE: Restored variable: OUT.
  ;  ;  % RESTORE: Restored variable: CHIANTI_DOC.
  ;  ;  ;
  ;  ;  help,zindex,/str
  ;  ;  ZINDEX          LONG      = Array[30]
  ;  ;  help,out,/str
  ;  ;  ** Structure <1269aa08>, 19 tags, length=339363096, data length=331045378, refs=1:
  ;  ;  LINES           STRUCT    -> <Anonymous> Array[831770]
  ;  ;  IONEQ_LOGT      FLOAT     Array[101]
  ;  ;  IONEQ_NAME      STRING    '/usr/local/ssw/packages/chianti/dbase/ioneq/chianti.ioneq'
  ;  ;  IONEQ_REF       STRING    Array[3]
  ;  ;  WVL_LIMITS      FLOAT     Array[2]
  ;  ;  MODEL_FILE      STRING    ' '
  ;  ;  MODEL_NAME      STRING    'Constant density'
  ;  ;  MODEL_NE        FLOAT       1.00000e+11
  ;  ;  MODEL_PE        FLOAT           0.00000
  ;  ;  MODEL_TE        FLOAT           0.00000
  ;  ;  WVL_UNITS       STRING    'Angstroms'
  ;  ;  INT_UNITS       STRING    'photons cm-2 sr-1 s-1'
  ;  ;  ADD_PROTONS     INT              1
  ;  ;  DATE            STRING    'Thu May 25 22:24:52 2023'
  ;  ;  VERSION         STRING    '10.0.2'
  ;  ;  LOOKUP          INT              0
  ;  ;  PHOTOEXCITATION INT              0
  ;  ;  LOGT_ISOTHERMAL FLOAT     Array[41]
  ;  ;  LOGEM_ISOTHERMAL
  ;  ;  FLOAT     Array[41]
  ;  ;  help,chianti_doc,/str
  ;  ;  ** Structure <d244cac8>, 3 tags, length=80, data length=80, refs=1:
  ;  ;  ION_FILE        STRING    '/usr/local/ssw/packages/chianti/dbase/ioneq/chianti.ioneq'
  ;  ;  ION_REF         STRING    Array[3]
  ;  ;  VERSION         STRING    Array[1]
  ;  ;
  ;
  ;
  ;
  ;
  ;  ;
  ;  ;  ;~~~~~~~~~~~ Continuum ~~~~~~~~~~~~~~~~~~~~~~~~
  ;  ;  ; Just run with the deafult parameters?
  ;  ;  ;  And time how long it takes..
  ;  ;  TIC
  ;  ;  res=setup_chianti_cont()
  ;  ;  TOC
  ;  ;
  ;  ;  ;  On M1 Pro MacBook Pro
  ;  ;  ;  % Time elapsed: 321.27735 seconds.
  ;  ;
  ;  ;  ; Outputs a file called chianti_setup_cont.geny to current working directory,
  ;  ;  ; i.e. what the function returns
  ;  ;  ; help,res,/str
  ;  ;  ;  RES             STRING    = 'chianti_setup_cont.geny'
  ;  ;
  ;  ;  ; Load it back in to see what was produced
  ;  ;  restgenx,file=res,zindex,  totcont, totcont_lo, edge_str, ctemp, chianti_doc
  ;  ;
  ;  ;  help, zindex, totcont, totcont_lo, edge_str, ctemp, chianti_doc,/str
  ;  ;  ;  ZINDEX          LONG      = Array[30]
  ;  ;  ;  TOTCONT         FLOAT     = Array[1002, 41, 30]
  ;  ;  ;  TOTCONT_LO      DOUBLE    = Array[8, 41, 30]
  ;  ;  ;  ** Structure <f6dbf588>, 4 tags, length=12128, data length=12128, refs=1:
  ;  ;  ;  CONVERSION      FLOAT           12.3985
  ;  ;  ;  WVLEDGE         FLOAT     Array[1011]
  ;  ;  ;  WVL             FLOAT     Array[1010]
  ;  ;  ;  WAVESTEP        FLOAT     Array[1010]
  ;  ;  ;  CTEMP           DOUBLE    = Array[41]
  ;  ;  ;  ** Structure <f6d68818>, 3 tags, length=80, data length=80, refs=1:
  ;  ;  ;  ION_FILE        STRING    '/usr/local/ssw/packages/chianti/dbase/ioneq/chianti.ioneq'
  ;  ;  ;  ION_REF         STRING    Array[3]
  ;  ;  ;  VERSION         STRING    Array[1]
  ;  ;  print,chianti_doc.version
  ;  ;  ;10.0.2
  ;
  ;

  stop
end