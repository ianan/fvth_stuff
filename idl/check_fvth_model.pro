pro check_fvth_model

  ; Check_f_vth using different CHIANTI files
  ;
  ; 26-May-2023 IGH
  ;
  ;---------------------------

  mk2kev=0.08617
  chlv9=getenv('CHIANTI_LINES_FILE')
  chcv9=getenv('CHIANTI_CONT_FILE')

  ; Just make sure the default is being used (after multiple runs)
  chianti_kev_common_load,     $
    linefile=chlv9, $
    contfile=chcv9, $
    /reload

  e=get_edges( findgen(2001)*.01+1., /edges_2)
  ; Make fvth spectrum for 10 and 20 MK using v9
  fv9_10=f_vth(e,[1.,10*mk2kev])
  fv9_20=f_vth(e,[1.,20*mk2kev])

  ; Change to v10
  chianti_kev_common_load, $
    linefile='chianti_lines_07_12_unity_v1002_t41.geny', $
    contfile='chianti_cont_01_250_unity_v1002.geny', $
    /reload
  ; Make fvth spectrum for 10 and 20 MK using v9
  fv10_10=f_vth(e,[1.,10*mk2kev])
  fv10_20=f_vth(e,[1.,20*mk2kev])

  ; Change to v7
  chianti_kev_common_load, $
    linefile='chianti_lines_1_10_v71.sav', $
    contfile='chianti_cont_1_250_v71.sav', $
    /reload
  fv7_10=f_vth(e,[1.,10*mk2kev])
  fv7_20=f_vth(e,[1.,20*mk2kev])

  ; nice plot of it all
  clearplot
  set_plot,'x'
  device,retain=2, decomposed=0
  mydevice = !d.name
  !p.multi=[0,2,2]
  !p.thick=2
  !p.charsize=1.2
  !p.font=0
  !x.style=17
  !y.style=17
  linecolors

  figname='test_ch_fvth_v7910.eps'
  set_plot,'ps'
  device, /encapsulated, /color, /HELVETICA, $
    /inches, bits=8, xsize=9, ysize=9,$
    file=figname

  plot_oo, avg(e,0), fv9_10, psym=10,title='10MK',$
    xtit='Energy [kev]',ytit='ph/s/cm^2/keV',/nodata,xrange=[1,30],yr=[1e1,1e10]
  oplot, avg(e,0), fv7_10*.1,color=8
  oplot, avg(e,0), fv9_10,color=2
  oplot,avg(e,0), fv10_10*10.,color=10

  xyouts, 28,10^(9.0),'v7.1 (x 0.1)',color=8,/data,align=1
  xyouts, 28,10^(8.3),'v9.0.1 ',color=2,/data,align=1
  xyouts, 28,10^(7.6),'v10.0.2 (x 10)',color=10,/data,align=1

  plot_oo, avg(e,0), fv9_20, psym=10,title='20MK',$
    xtit='Energy [kev]',ytit='ph/s/cm^2/keV',/nodata,xrange=[1,30],yr=[1e1,1e10]
  oplot, avg(e,0), fv7_20*.1,color=8
  oplot, avg(e,0), fv9_20,color=2
  oplot,avg(e,0), fv10_20*10,color=10

  xyouts, 28,10^(9.0),'v7.1 (x 0.1)',color=8,/data,align=1
  xyouts, 28,10^(8.3),'v9.0.1 ',color=2,/data,align=1
  xyouts, 28,10^(7.6),'v10.0.2 (x 10)',color=10,/data,align=1

  plot,avg(e,0),fv9_10/fv10_10,xtit='Energy [kev]',ytit='Ratio',$
    title='10MK',/nodata,xrange=[1,30],yr=[0,6],/xlog
  oplot,avg(e,0), fv10_10/fv9_10,color=4,thick=3
  oplot,avg(e,0), fv10_10/fv7_10,color=13
  
  xyouts, 1.5,5.5,'v10.0.2/v9.0.1',color=4,/data,align=0
  xyouts, 1.5,5,'v10.0.2/v7.1',color=13,/data,align=0

  plot,avg(e,0),fv9_20/fv10_20,xtit='Energy [kev]',ytit='Ratio',$
    title='20MK',/nodata,xrange=[1,30],yr=[0,6],/xlog
  oplot,avg(e,0), fv10_20/fv9_20,color=4,thick=3
  oplot,avg(e,0), fv10_20/fv7_20,color=13
  
  xyouts, 1.5,5.5,'v10.0.2/v9.0.1',color=4,/data,align=0
  xyouts, 1.5,5,'v10.0.2/v7.1',color=13,/data,align=0

  device,/close
  set_plot, mydevice

  convert_eps2pdf,figname,/del



  stop
end