pro better_chxdb_files
  compile_opt idl2

  ; Generating new lookup files from CHIANTI for ospex and sunkit-spex thermal models.
  ; These thermal models, load the precalculated continuum and line files and then
  ; interpolate to the chosen temperature
  ;
  ; Currently sunkit-spex using the old v7.1 files, so not upto date
  ; - 'chianti_cont_1_250_v71.sav' 300 bins over logT 6-9, 1-250 keV
  ; - 'chianti_lines_1_10_v71.sav' 750 bins over logT 6-9, 1-10 keV
  ;
  ; Currenlty OSPEX is using v9.01 files, but have a small number of temperature
  ; bins which can cause problems when the models interpolate -> clustering
  ; - 'chianti_cont_01_250_unity_v901.sav' 41 bin over logT 6-8, 0.1-250 keV
  ; - 'chianti_lines_07_12_unity_v901_t41.sav' 41 bins over logT 6-8, 0.7-12 keV
  ;
  ; So this code lets you produce whatever energy range and temperature binning you want
  ; using whatever version of CHIATNI database you have installed on your system
  ;
  ; Here have used v11.02 CHIANTI database and done
  ; - continuum 100 bins over logT 6-8, 1-250 keV
  ; - lines 100 bins over logT 6-8, 1 -12 keV
  ; - lines 100 bins over logT 6-8, 2 -12 keV
  ;
  ;
  ; 13-Aug-2024 IGH
  ;
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  conversion = 12.39854
  chxdb = concat_dir(getenv('SSWDB_XRAY'), 'chianti/')
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; How big the file with 0.02 in logT and start > 2 keV
  contfile = setup_chianti_cont('CHIANTI', 1, 250, ntemp = 101, $
    genxfile = 'chianti_cont_1_250_unity_v1102_t101.geny', $
    savfile = 'chianti_cont_1_250_unity_v1102_t101.sav')

  linefile = setup_chianti_lines('CHIANTI', 1, 12, ntemp = 101, $
    genxfile = 'chianti_lines_1_12_unity_v1102_t101.geny', $
    savfile = 'chianti_lines_1_12_unity_v1102_t101.sav')

  ; ; smaller file so quicker to work with, don't need < 2keV for RHESSI/STIX/NuSTAR
  ; linefile = setup_chianti_lines('CHIANTI', 2, 12, ntemp = 101, $
  ; genxfile = 'chianti_lines_2_12_unity_v1102_t101.geny', $
  ; savfile = 'chianti_lines_2_12_unity_v1102_t101.sav')

  ; ; going fown to 0.1 keV but bigger files
  ; contfile=setup_chianti_cont('CHIANTI',0.1,250,ntemp=101,$
  ; genxfile='chianti_cont_01_250_unity_v1102_t101.geny',$
  ; savfile='chianti_cont_01_250_unity_v1102_t101.sav')

  ; linefile=setup_chianti_lines('CHIANTI',0.1,12,ntemp=101,$
  ; genxfile='chianti_lines_01_12_unity_v1102_t101.geny',$
  ; savfile='chianti_lines_01_12_unity_v1102_t101.sav')

  ; ; going fown to 0.7 keV but bigger files
  ; contfile=setup_chianti_cont('CHIANTI',0.7,250,ntemp=101,$
  ; genxfile='chianti_cont_07_250_unity_v1102_t101.geny',$
  ; savfile='chianti_cont_07_250_unity_v1102_t101.sav')

  ; linefile=setup_chianti_lines('CHIANTI',0.7,12,ntemp=101,$
  ; genxfile='chianti_lines_07_12_unity_v1102_t101.geny',$
  ; savfile='chianti_lines_07_12_unity_v1102_t101.sav')

  ; ; ; If you need a wider temperature range, here doing logT 5-8
  ; contfile = setup_chianti_cont('CHIANTI', 1, 250, [0.1, 100.] * 1e6, ntemp = 101, $
  ; genxfile = 'chianti_cont_1_250_unity_v1102_t101.geny', $
  ; savfile = 'chianti_cont_1_250_unity_v1102_t101.sav')

  ; linefile = setup_chianti_lines('CHIANTI', 1, 12, [0.1, 100.] * 1e6, ntemp = 101, $
  ; genxfile = 'chianti_lines_1_12_unity_v1102_t101.geny', $
  ; savfile = 'chianti_lines_1_12_unity_v1102_t101.sav')

  stop
end
