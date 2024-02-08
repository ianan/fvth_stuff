pro better_v10_ch_files

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
  ; 06-Feb-2024 IGH
  ;
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  conversion= 12.39854
  chxdb= concat_dir(getenv('SSWDB_XRAY'),'chianti/')
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ;;   OK files: 26MB (geny) and 23MB (sav)
  ;  contfile=setup_chianti_cont('CHIANTI',1,250,ntemp=200,$
  ;    genxfile='chianti_cont_1_250_unity_v101_t200.geny',$
  ;    savfile='chianti_cont_1_250_unity_v101_t200.sav')
  ;
  ;;   Big files: 606MB (geny) and 545MB (sav)
  ;  linefile=setup_chianti_lines('CHIANTI',1,12,ntemp=500,$
  ;    genxfile='chianti_lines_1_12_unity_v101_t500.geny',$
  ;    savfile='chianti_lines_1_12_unity_v101_t500.sav')
  ;
  ;;   Big files: 601MB (geny) and 541MB (sav)
  ;  linefile=setup_chianti_lines('CHIANTI',1,10,ntemp=500,$
  ;    genxfile='chianti_lines_1_10_unity_v101_t500.geny',$
  ;    savfile='chianti_lines_1_10_unity_v101_t500.sav')

  ;;   OK files: 13MB (geny) and 12MB (sav)
  contfile=setup_chianti_cont('CHIANTI',1,250,ntemp=100,$
    genxfile='chianti_cont_1_250_unity_v101_t100.geny',$
    savfile='chianti_cont_1_250_unity_v101_t100.sav')
  ;;   OK (?) files: 138MB (geny) and 111MB (sav)
  linefile=setup_chianti_lines('CHIANTI',1,12,ntemp=100,$
    genxfile='chianti_lines_1_12_unity_v101_t100.geny',$
    savfile='chianti_lines_1_12_unity_v101_t100.sav')

  stop
end