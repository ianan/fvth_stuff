pro ospex_fit_example

  ; ; Fit a RHESSI microflare spectra (attenuator out) using the
  ; ; new v11.02 N_T=101 CHIANTI database files
  ; ;
  ; ;
  ; ; 13-Aug-2025 IGH
  ; ;
  ; ;------------------------------------------------------------

  ; ; Want to use the new files not the default ones
  chianti_kev_common_load, contfile = 'chianti_cont_1_250_unity_v1102_t101.sav', $
    linefile = 'chianti_lines_2_12_unity_v1102_t101.sav', /reload
  ; ; To change back to the default ones would do
  ; chianti_kev_common_load,contfile=getenv('CHIANTI_CONT_FILE'),linefile=getenv('CHIANTI_LINES_FILE'),/reload

  tmk2kev = 0.086164
  default, tolerance, 1e-4
  default, max_iter, 75
  default, uncert, 0.02

  ; f_vth
  ; a[0]  em_49, emission measure units of 10^49
  ; a[1]  KT, plasma temperature in keV, restricted to a range from 1.01 MegaKelvin to <998 MegaKelvin in keV
  ; i.e.  0.0870317 - 86.0 keV
  ; a[2]  Relative abundance for Fe, Ni, Si, and Ca. S as well at half the deviation from 1 as Fe.
  ; f_thick2
  ; a(0) - Total integrated electron flux, in units of 10^35 electrons sec^-1.
  ; a(1) - Power-law index of the electron flux distribution function below
  ; eebrk.
  ; a(2) - Break energy in the electron flux distribution function (in keV)
  ; a(3) - Power-law index of the electron flux distribution function above
  ; eebrk.
  ; a(4) - Low energy cutoff in the electron flux distribution function
  ; (in keV).
  ; a(5) - High energy cutoff in the electron flux distribution function (in keV).
  default, fitstart, [1e-2, 11.0 * tmk2kev, 1, 1e-2, 6, 1000, 20, 15, 1000]
  default, fitmin, [1e-5, 5.0 * tmk2kev, 1, 1e-4, 2, 1000, 20, 6, 1000]
  default, fitmax, [1e2, 30. * tmk2kev, 1, 1e2, 13, 1000, 20, 30, 1000]

  btims = ['25-Jul-03 08:22:54', '25-Jul-03 08:23:10']
  ftims = ['25-Jul-03 08:26:34', '25-Jul-03 08:26:50']
  tr = ['25-Jul-03 08:22:54', '25-Jul-03 08:34:42']
  fpeak = '2003-07-25T08:26:42.000'

  set_logenv, 'OSPEX_NOINTERACTIVE', '1'
  o = ospex()
  o->set, spex_fit_manual = 0, spex_fit_reverse = 0, spex_fit_start_method = 'previous_int'
  o->set, spex_autoplot_enable = 0, spex_fitcomp_plot_resid = 0, spex_fit_progbar = 0

  o->set, fit_function = 'vth+thick2'
  o->set, fit_comp_spectrum = ['full', '']
  o->set, fit_comp_model = ['chianti', '']

  o->set, spex_summ_uncert = uncert
  o->set, mcurvefit_itmax = max_iter
  o->set, mcurvefit_tol = tolerance

  fitsdir = '../../rhessi_spectra/mfstats9_fits/'

  o->set, spex_specfile = fitsdir + break_time(fpeak) + '_spec_sum_org.fits'
  o->set, spex_drmfile = fitsdir + break_time(fpeak) + '_srm_sum_org.fits'
  o->set, spex_fit_time_interval = ftims
  o->set, spex_bk_time_interval = btims
  o->set, spex_bk_order = 0
  o->set, fit_comp_minima = fitmin
  o->set, fit_comp_maxima = fitmax

  o->set, spex_erange = [4, 8]
  o->set, fit_comp_free = [1, 1, 0, 0, 0, 0, 0, 0, 0]
  o->set, fit_comp_param = fitstart
  o->dofit

  o->set, spex_erange = [9, 20]
  o->set, fit_comp_free = [0, 0, 0, 1, 1, 0, 0, 1, 0]
  o->dofit
  o->set, spex_erange = [4, 20]
  o->set, fit_comp_free = [1, 1, 0, 1, 1, 0, 0, 1, 0]
  o->dofit

  p = o->get(/spex_summ_params)
  perr = o->get(/spex_summ_sigmas)

  tmkstr = string(p[1] / tmk2kev, format = '(f5.2)') + ' MK'
  em49 = p[0] * 1d49
  em49pow = floor(alog10(em49))
  emstr = string(p[0] * 1e3, format = '(f5.2)') + 'x10!U46!N cm!U-3!N'

  nstr = string(p[3], format = '(f5.2)') + 'x10!U35!N e!U-!Ns!U-1!N'
  delstr = '!Md!3: ' + string(p[4], format = '(f5.2)')
  ecstr = string(p[7], format = '(f5.2)') + ' keV'

  dd = o->getdata(class = 'spex_fitint', spex_units = 'flux')
  fit = o->calc_func_components(spex_units = 'flux', /all_func)
  ee = fit.ct_energy
  chisq = o->get(/spex_summ_chisq)
  mide = o->getaxis(/ct_energy)
  erange = o->get(/spex_erange)

  ftot = fit.yvals[*, 0]
  fth = fit.yvals[*, 1]
  fnn = fit.yvals[*, 2]

  ; Make a nice plot
  @post_outset
  !p.multi = 0
  !p.charsize = 1.2
  figname = 'ospex_' + break_time(ftims[0]) + '.eps'
  set_plot, 'ps'
  device, /encapsulated, /color, /isolatin1, /inches, $
    bits = 8, xsize = 6, ysize = 5, file = figname

  !p.thick = 4
  tlc_igh
  ; hsi_linecolors

  yr = [3e-4, 7e1]
  xr = [3, 30]
  plot_oo, mide, dd.data, psym = 1, yrange = yr, ystyle = 17, xstyle = 17, xrange = xr, ytickf = 'exp1', $
    xtitle = 'Energy [keV]', ytitle = 'counts s!U-1!N cm!U-2!N keV!U-1!N', /nodata, $
    title = ftims[0] + ' to ' + anytim(ftims[1], /time, /trunc, /yoh)

  nengs = n_elements(ee[0, *])
  oplot, mide, dd.bkdata, color = 10, psym = 10
  oplot, mide, dd.data, color = 0, psym = 10

  oplot, erange[0] * [1, 1], yr, lines = 1, thick = 2
  oplot, erange[1] * [1, 1], [yr[0], 10 ^ (alog10(yr[1]) - 1.5)], lines = 1, thick = 2

  xyouts, xr[1] - 2, 10 ^ (alog10(yr[1]) - .4), tmkstr + ', ' + emstr, align = 1, color = 25, /data, chars = 1.2
  xyouts, xr[1] - 2, 10 ^ (alog10(yr[1]) - .8), nstr + ', ' + $
    delstr + ', ' + ecstr, align = 1, color = 26, /data, chars = 1.2
  xyouts, xr[1] - 2, 10 ^ (alog10(yr[1]) - 1.2), '!Mc!3!U2!N: ' + string(chisq, format = '(f6.2)'), align = 1, color = 27, /data, chars = 1.2

  oplot, mide, fth, color = 25, psym = 10
  oplot, mide, fnn, color = 26, psym = 10
  oplot, mide, ftot, color = 27, psym = 10

  xyouts, 5e2, 7e2, 'data-back', /device, color = 0
  xyouts, 5e2, 2e2, 'back', /device, color = 10

  device, /close
  set_plot, mydevice
  convert_eps2pdf, figname, /del

  obj_destroy, o

  stop
end