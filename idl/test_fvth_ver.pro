pro test_fvth_ver

  ; Quick test of the default version of CHIANTI (which should be v9)
  ; vs me forcing the use of the older v7.
  ;
  ; 25-May-2023 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Based off of
  ;https://hesperia.gsfc.nasa.gov/ssw/packages/xray/idl/setup_f_vth_dbase_filenames.pro

  mk2kev=0.08617

  ; Default now should be v901
  ; Check the default
  print,"Lines: ",getenv('CHIANTI_LINES_FILE')
  print,"Continuum: ",getenv('CHIANTI_CONT_FILE')
  e=get_edges( findgen(2001)*.01+1., /edges_2)
  ; Make fvth spectrum for 10 and 20 MK using v9
  fv9_10=f_vth(e,[1.,10*mk2kev])
  fv9_20=f_vth(e,[1.,20*mk2kev])

  ; Change to v7
  chianti_kev_common_load, $
    linefile='chianti_lines_1_10_v70.sav', $
    contfile='chianti_cont_1_250_v70.sav', $
    /reload

  e=get_edges( findgen(2001)*.01+1., /edges_2)
  ; Make fvth spectrum for 10 and 20 MK using v7
  fv7_10=f_vth(e,[1.,10*mk2kev])
  fv7_20=f_vth(e,[1.,20*mk2kev])

  ; nice plot of it all
  clearplot
  set_plot,'x'
  device,retain=2, decomposed=0
  mydevice = !d.name
  !p.multi=[0,3,1]
  !p.thick=2
  !p.charsize=1.5
  !p.font=0
  !x.style=17
  !y.style=17
  linecolors

  set_plot,'ps'
  device, /encapsulated, /color, /HELVETICA, $
    /inches, bits=8, xsize=9, ysize=3,$
    file='test_ch_fvth.eps'

  plot_oo, avg(e,0), fv9_10, psym=10,title='10MK: v9 (rd) v7 (bl)',$
    xtit='Energy [kev]',ytit='ph/s/cm^2/keV',/nodata,xrange=[1,30],yr=[1e1,1e9]
  oplot, avg(e,0), fv9_10,color=2
  oplot,avg(e,0), fv7_10,color=10,thick=1

  plot_oo, avg(e,0), fv9_20, psym=10,title='20MK: v9 (rd) v7 (bl)',$
    xtit='Energy [kev]',ytit='ph/s/cm^2/keV',/nodata,xrange=[1,30],yr=[1e1,1e9]
  oplot, avg(e,0), fv9_20,color=2
  oplot,avg(e,0), fv7_20,color=10,thick=1

  plot,avg(e,0),fv9_20/fv7_20,xtit='Energy [kev]',ytit='v9/v7',$
    title='10MK (or) 20MK (gr)',/nodata,xrange=[1,20],yr=[0,6]
  oplot, avg(e,0), fv9_20/fv7_20,color=8
  oplot,avg(e,0), fv9_10/fv7_10,color=4

  device,/close
  set_plot, mydevice



  stop
end