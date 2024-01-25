pro test_fvth_v579

;  Testing v5, vs v7 vs v9
;  
;  Files are all in  https://hesperia.gsfc.nasa.gov/ssw/packages/xray/dbase/chianti/
;  
;  25-Jan-2024

  mk2kev=0.08617
  ; Higher resolution
;  e=get_edges( findgen(2001)*.01+1., /edges_2)
  ; RHESSI resolution
  e=get_edges( findgen(101)*.3+1., /edges_2)

  ;; Default up to 2006 (v5.2)
  chianti_kev_common_load,contfile='chianti_cont_1_250_v52.sav',linefile='chianti_lines_1_10_v52.sav',/reload
  fv5_10=f_vth(e,[1.,10*mk2kev])
  fv5_15=f_vth(e,[1.,15*mk2kev])
  
  ;; Default 2012-2020 (v7.1)
  chianti_kev_common_load,contfile='chianti_cont_1_250_v71.sav',linefile='chianti_lines_1_10_v71.sav',/reload
  fv7_10=f_vth(e,[1.,10*mk2kev])
  fv7_15=f_vth(e,[1.,15*mk2kev])

  ;; Default since 2020 (v9.01)
  chianti_kev_common_load,contfile=getenv('CHIANTI_CONT_FILE'),linefile=getenv('CHIANTI_LINES_FILE'),/reload
  fv9_10=f_vth(e,[1.,10*mk2kev])
  fv9_15=f_vth(e,[1.,15*mk2kev])
  
  clearplot
  set_plot,'x'
  device,retain=2, decomposed=0
  mydevice = !d.name
  !p.multi=[0,1,4]
  !p.thick=3
  !p.charsize=1.2
  !p.font=0
  !x.style=17
  !y.style=17
  linecolors

  figname='test_ch_fvth_v579.eps'
  set_plot,'ps'
  device, /encapsulated, /color, /HELVETICA, $
    /inches, bits=8, xsize=4, ysize=6,$
    file=figname

  plot_oo, avg(e,0), fv9_10, psym=10,$
    xtit='Energy [kev]',ytit='ph/s/cm^2/keV',/nodata,xrange=[1,30],yr=[1e-1,1e10],$
    title='v5 (pink), v7 (blue), v9 (cyan), 10MK (solid), 15MK (dashed)'
  oplot, avg(e,0), fv5_10,color=9
  oplot, avg(e,0), fv7_10,color=10
  oplot, avg(e,0), fv9_10,color=3
  
  oplot, avg(e,0), fv5_15,color=9,lines=2
  oplot, avg(e,0), fv7_15,color=10,lines=2
  oplot, avg(e,0), fv9_15,color=3,lines=2
  
  plot, avg(e,0), fv9_10, psym=10,$
    xtit='Energy [kev]',ytit='Ratio',/nodata,xrange=[1,30],yr=[0,2],/xlog,$
    title='v5/v9, 10MK (solid), 15MK (dashed)'
  oplot,minmax(e),[1,1],lines=1,color=150
  oplot, avg(e,0), fv5_10/fv9_10
  oplot, avg(e,0), fv5_15/fv9_15,lines=2
  
  plot, avg(e,0), fv9_10, psym=10,$
    xtit='Energy [kev]',ytit='Ratio',/nodata,xrange=[1,30],yr=[0,2],/xlog,$
    title='v5/v7, 10MK (solid), 15MK (dashed)'
  oplot,minmax(e),[1,1],lines=1,color=150
  oplot, avg(e,0), fv5_10/fv7_10
  oplot, avg(e,0), fv5_15/fv7_15,lines=2
  
  plot, avg(e,0), fv9_10, psym=10,$
    xtit='Energy [kev]',ytit='Ratio',/nodata,xrange=[1,30],yr=[0,2],/xlog,$
    title='v7/v9, 10MK (solid), 15MK (dashed)'
  oplot,minmax(e),[1,1],lines=1,color=150
  oplot, avg(e,0), fv7_10/fv9_10
  oplot, avg(e,0), fv7_15/fv9_15,lines=2
  
  device,/close
  set_plot, mydevice
  
  convert_eps2pdf,figname,/del
  

  stop
end