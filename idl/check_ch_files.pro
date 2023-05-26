pro check_ch_files

  ; Checking the ch files I've made vs the default ones
  ;
  ; 26-May-2023 IGH
  ; ~~~~~~~~~~~~~~~~~~~~~`
  ;
  ;
  conversion= 12.39854
  chianti_dbase= concat_dir(getenv('SSWDB_XRAY'),'chianti/')

  ; What are the current default
  vlf=getenv('CHIANTI_LINES_FILE') ;chianti_lines_07_12_unity_v901_t41.geny
  vcf=getenv('CHIANTI_CONT_FILE')  ;chianti_cont_01_250_unity_v901.geny

  restgenx,file=chianti_dbase+vlf, zindexl,  outl, chianti_docl
  restgenx,file=chianti_dbase+vcf, zindexc,  totcontc, totcont_loc, edge_strc, ctempc, chianti_docc

  print,vlf
  print,'wvl lims [A]: ',outl.wvl_limits
  print,'wvl lims [keV]: ',conversion/outl.wvl_limits

  print,vcf
  print,'wvl lims [A]: ',minmax(edge_strc.wvledge)
  print,'wvl lims [keV]: ',conversion/minmax(edge_strc.wvledge)

  stop
  ;  ;  v7f=chianti_dbase+'chianti_lines_1_10_v71.sav'
  ;  v9f=chianti_dbase+'chianti_lines_01_12_unity_v901_t41.sav'
  ;  ;  IDL>   restore,v9f,/ver
  ;  ;  % RESTORE: Portable (XDR) compressed SAVE/RESTORE file.
  ;  ;  % RESTORE: Save file written by cepheid@max, Fri Apr 24 21:05:41 2020.
  ;  ;  % RESTORE: IDL version 8.5 (linux, x86_64).
  ;  ;  % RESTORE: Restored variable: ZINDEX.
  ;  ;  % RESTORE: Restored variable: OUT.
  ;  ;  % RESTORE: Restored variable: CHIANTI_DOC.
  ;  ;IDL> help,zindex,/str
  ;  ;ZINDEX          LONG      = Array[30]
  ;  ;IDL> help,out,/str
  ;  ;** Structure <e263c608>, 18 tags, length=123753456, data length=120720286, refs=1:
  ;  ;   LINES           STRUCT    -> <Anonymous> Array[303315]
  ;  ;   IONEQ_LOGT      FLOAT     Array[101]
  ;  ;   IONEQ_NAME      STRING    '/disks/solar/home/ssw/packages/chianti/dbase/ioneq/chianti.ioneq'
  ;  ;   IONEQ_REF       STRING    Array[3]
  ;  ;   WVL_LIMITS      FLOAT     Array[2]
  ;  ;   MODEL_FILE      STRING    ' '
  ;  ;   MODEL_NAME      STRING    'Constant density'
  ;  ;   MODEL_NE        FLOAT       1.00000e+11
  ;  ;   MODEL_PE        FLOAT           0.00000
  ;  ;   MODEL_TE        FLOAT           0.00000
  ;  ;   WVL_UNITS       STRING    'Angstroms'
  ;  ;   INT_UNITS       STRING    'photons cm-2 sr-1 s-1'
  ;  ;   ADD_PROTONS     INT              1
  ;  ;   DATE            STRING    'Fri Apr 24 21:05:40 2020'
  ;  ;   VERSION         STRING    '9.0.1'
  ;  ;   PHOTOEXCITATION INT              0
  ;  ;   LOGT_ISOTHERMAL FLOAT     Array[41]
  ;  ;   LOGEM_ISOTHERMAL
  ;  ;                   FLOAT     Array[41]
  ;  ;IDL> help,chianti_doc,/str
  ;  ;** Structure <e3af9298>, 3 tags, length=80, data length=80, refs=1:
  ;  ;   ION_FILE        STRING    '/disks/solar/home/ssw/packages/chianti/dbase/ioneq/chianti.ioneq'
  ;  ;   ION_REF         STRING    Array[3]
  ;  ;   VERSION         STRING    '9.0.1'
  ;  ;  IDL> print,out.wvl_limits
  ;  ;  0.123985      123.985
  ;  ;  IDL> print,conversion/out.wvl_limits
  ;  ;  100.000     0.100000
  ;  ;  IDL> print,out.version
  ;  ;  9.0.1
  ;
  ;  v10f='chianti_lines.sav'
  ;  ;  IDL> restore,v10f,/ver
  ;  ;  % RESTORE: Portable (XDR) compressed SAVE/RESTORE file.
  ;  ;  % RESTORE: Save file written by iain@sycorax, Thu May 25 23:03:34 2023.
  ;  ;  % RESTORE: IDL version 8.8.3 (darwin, x86_64).
  ;  ;  % RESTORE: Restored variable: ZINDEX.
  ;  ;  % RESTORE: Restored variable: OUT.
  ;  ;  % RESTORE: Restored variable: CHIANTI_DOC.
  ;  ;  IDL> help,zindex,/str
  ;  ;  ZINDEX          LONG      = Array[30]
  ;  ;  IDL> help,out,/str
  ;  ;  ** Structure <e2557408>, 19 tags, length=339363096, data length=331045378, refs=1:
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
  ;  ;  DATE            STRING    'Thu May 25 23:03:33 2023'
  ;  ;  VERSION         STRING    '10.0.2'
  ;  ;  LOOKUP          INT              0
  ;  ;  PHOTOEXCITATION INT              0
  ;  ;  LOGT_ISOTHERMAL FLOAT     Array[41]
  ;  ;  LOGEM_ISOTHERMAL
  ;  ;  FLOAT     Array[41]
  ;  ;  IDL> help,chianti_doc,/str
  ;  ;  ** Structure <c342d138>, 3 tags, length=80, data length=80, refs=1:
  ;  ;  ION_FILE        STRING    '/usr/local/ssw/packages/chianti/dbase/ioneq/chianti.ioneq'
  ;  ;  ION_REF         STRING    Array[3]
  ;  ;  VERSION         STRING    Array[1]
  ;  ;  IDL> print,out.wvl_limits
  ;  ;  1.03321      123.985
  ;  ;  IDL> print,conversion/out.wvl_limits
  ;  ;  12.0000     0.100000
  ;  ;  IDL> out.version
  ;  ;  10.0.2


  stop
end