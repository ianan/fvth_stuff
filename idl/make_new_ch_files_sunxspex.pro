pro make_new_ch_files_sunxspex


  ; Try generating new files from CHIANTI for sunxspex thermal models
  ;   https://github.com/sunpy/sunxspex/blob/master/sunxspex/thermal.py
  ; which have been using
  ;   'chianti_cont_1_250_v71.sav' and 'chianti_lines_1_10_v71.sav'
  ;
  ;   Note that newer IDL ones
  ;   'chianti_cont_01_250_unity_v901.geny' and chianti_lines_07_12_unity_v901_t41.geny
  ;   use 41 temeprature bins over logT 6-8
  ;
  ;   But older IDL (sunxspex ones)
  ;   'chianti_cont_1_250_v71.sav' and 'chianti_lines_1_10_v71.sav'
  ;   use 300 (cont) or 750 (lines) over logT 6-9 !!!!
  ;
  ; Presumably changed made as v7->v9 adds a lot more lines and files would be huge?
  ;
  ; Stick with consistent with newer IDL/f_vth and check if that works......
  ;
  ; 02-Jun-2023 IGH
  ; 06-Jun-2023 IGH, changed setup*.pro to save out, and chianti_version is str not array
  ; 11-Jul-2023 IGH, now with CHIANTI 10.1 (dbase/VERSION, though 10.2 idl/VERSION ???)
  ;
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  conversion= 12.39854
  chxdb= concat_dir(getenv('SSWDB_XRAY'),'chianti/')
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; For continuum
  ; First check what the existing files are like
  ;
  ;  restore,chxdb+'chianti_cont_1_250_v71.sav',/v
  ;;  % RESTORE: Restored variable: ZINDEX.
  ;;  % RESTORE: Restored variable: TOTCONT.
  ;;  % RESTORE: Restored variable: TOTCONT_LO.
  ;;  % RESTORE: Restored variable: EDGE_STR.
  ;;  % RESTORE: Restored variable: CTEMP.
  ;;  % RESTORE: Restored variable: CHIANTI_DOC.

  ; Now make new version and save geny and savfil using my version
  ; which also makes sure chianti_verion in the output is a string not array
  ;  contfile=setup_chianti_cont('CHIANTI',1,250,$
  ;    genxfile='chianti_cont_1_250_unity_v1002_t41.geny',$
  ;    savfile='chianti_cont_1_250_unity_v1002_t41.sav')

  contfile=setup_chianti_cont('CHIANTI',1,250,$
    genxfile='chianti_cont_1_250_unity_v101_t41.geny',$
    savfile='chianti_cont_1_250_unity_v101_t41.sav')

  ;  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;  ; For Lines
  ;  ; First check the existing file
  ;  restore,chxdb+'chianti_lines_1_10_v71.sav',/v
  ;  % RESTORE: Restored variable: ZINDEX.
  ;  % RESTORE: Restored variable: OUT.
  ;  % RESTORE: Restored variable: CHIANTI_DOC.
  ; Although filename suggest 1-10 keV is actually 1-12 keV
  ; Old file also did logT range of 6 to 9, with 750 bins
  ; New ones doing logT range of 6 to 8 with 41 bins
  ; See how big the file is even with the old one
  ;
  ;  ; For lines using my modified/bug fixed version of setup_chinait_lines.pro
  ;  ; as chianti_version bug and by default was saving a savfile
  ;  ; Also default is MOZZATTA ioneq but should be CHIANTI?
  ;  linefile=setup_chianti_lines('CHIANTI',1,12,ntemp=41,$
  ;    genxfile='chianti_lines_1_12_unity_v1002_t41.geny',$
  ;    savfile='chianti_lines_1_12_unity_v1002_t41.sav')

  linefile=setup_chianti_lines('CHIANTI',1,12,ntemp=41,$
    genxfile='chianti_lines_1_12_unity_v101_t41.geny',$
    savfile='chianti_lines_1_12_unity_v101_t41.sav')

  stop
end