;+
; :Description:
;    Describe the procedure.
;
; :Params:
;    ioneq
;    kmin
;    kmax
;    temp_range
;
; :Keywords:
;    ntemp
;    nelem
;    savfile
;    overwrite
;
; :Author: rschwartz70@gmail.com, updated defaults in ntemp and kmin and kmax
;-
;  25-May-2023 IGH - Fixed chianti_version bug
;                    Changed to save out geny (like actual chianti_kev files), via genxfile
;                    ioneq default shouldn't be MAZZOTTA?
;
;  31-Jul-2025 IGH - ch_synthetic has changed to default to advanced_model not needing a ionization fraction file
;                    turns this off via advanced_model=0 to just use previous approach (best way???);

function setup_chianti_lines, ioneq,  kmin, kmax, temp_range,$
  ntemp=ntemp, nelem=nelem, savfile=savfile, genxfile=genxfile, $
  overwrite=overwrite

  default, savfile, ''
  default, genxfile, 'chianti_lines.geny'
  default, overwrite, 0
  default, nelem, 30
  fcount = 0
  If not overwrite then begin
    foundfile = loc_file(path=[curdir(),'$SSWDB_XRAY'], genxfile,count=fcount)
    overwrite = 1 - (fcount < 1)
  endif

  if overwrite then begin
    default,ioneq, 'MAZZOTTA'

    abund='sun_coronal_1992_feldman_ext.abund'
    chianti_dbase= concat_dir('SSW_CHIANTI','dbase')
    ioneq_file = loc_file(path=concat_dir(chianti_dbase,'ioneq'),'*.ioneq')
    select = where( strpos(STRLOWCASE(ioneq_file),STRLOWCASE(ioneq)) ne -1)
    ioneq_name = ioneq_file[ select[0] ]
    abund_file = loc_file(path=concat_dir(chianti_dbase,'abundance'),'*.abund')
    select = where( strpos(STRLOWCASE(abund_file),STRLOWCASE(abund)) ne -1)
    abund_file = abund_file[ select[0] ]

    COMMON elements,abundcom,abund_ref,ioneqcom,ioneq_logt,ioneq_ref


    read_abund,abund_file,abundances,abundance_ref
    select = where( abundances gt 0, nselect)
    ord  = sort( abundances[select] )
    nord = n_elements(ord)
    ord = ord[ nord-nelem:*]
    select = select[ord]
    zindex = select
    abundances = abundances * 0.0
    abundances[zindex] =  1.0 ;set all abundances to 1 and set abundances as needed in chianti_kev

    abundcom = abundances
    abund_ref = 'abundances set to 1'

    read_ioneq,ioneq_name,iont,ioneq,ion_ref
    ioneqcom = ioneq
    ioneq_logt = iont
    ioneq_ref = ion_ref

    conversion= 12.39854
    default,kmin, 0.1
    default,kmax,  12.0
    wmin = conversion/kmax
    wmax = conversion/kmin
    edensity = 1.e11 ;cm-3
    verbose = 0
    default,temp_range, [1., 100.]*1e6
    default, ntemp, 41
    temp = temp_range[0] * 10^(findgen(ntemp)/(ntemp-1)*alog10((temp_range[1]/temp_range[0])))


    n=n_elements(edensity)
    nt=n_elements(temp)
    IF nt NE 1 THEN no_sum_int=1
    IF keyword_set(ergs) THEN photons=0 ELSE photons=1

    ch_synthetic,wmin,wmax,out=out, press=pressure, err_msg=err_msg, $
      sngl_ion=sngl_ion,ioneq_name=ioneq_name,dem_name=dem_name, $
      photons=photons, masterlist=masterlist, noprot=noprot, $
      radtemp=radtemp, rphot=rphot, verbose=verbose, progress=progress, $
      density=edensity, no_sum_int=no_sum_int, logt_isothermal=alog10(temp), $
      logem_isothermal=dblarr(nt),advanced_model=0

    ;yohkoh_rel_abun = mk_rel_abun() ;default is yohkoh-mewe/chianti-solar-coronal
    ; Change the next couple of lines as chianti_version is a program not a function
    chianti_version, cversion
    cversion = cversion[0]

    chianti_doc = {ion_file: ioneq_name, ion_ref: ion_ref, version: cversion}

    if savfile ne '' then $
      save,/compress, zindex, out, chianti_doc, file=savfile
    ;    Using genx here as that is what f_vth/chianti_kev calls by default
    savegenx, zindex,  out, chianti_doc, $
      file=genxfile, /overwrite
  endif

  return, fcount ge 1 ? foundfile[0] : savfile

end