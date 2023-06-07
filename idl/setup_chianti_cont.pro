;+
; :Description:
;    Describe the procedure.
;
; :Params:
;    ioneq
;    kmin  - min database range in KeV, default is 0.1
;    kmax  - max database range in keV, default is 250.
;    temp_range - temp range of database in Kelvin
;    
;
; :Keywords:
;    nelem  - number of elements to use
;    ntemp  - number of temperatures default, ntemp, 41
;    nedge  - 
;    genxfile - .geny filename
;    overwrite - overwrite any pre-existing filename 
;
; History:
; Circa 2002, ras
; 31-aug-2012, ras, leave dem_int undefined for chianti_version 7 or greater
; 1-sep-2012, ras, fixed two photon error thanks to Jim McTiernan
; 9-mar-2020, ac, revised calls to chianti procedures to deal with
;     v9 changes in abundances
; 6-jun-2023, igh, made sure chianti_version is a string, not array and 
;                  option to sav file out
;-
function setup_chianti_cont, ioneq, kmin, kmax, temp_range, nelem=nelem,$
  ntemp=ntemp, nedge=nedge, genxfile=genxfile, overwrite=overwrite,savfile=savfile

  default, genxfile, 'chianti_setup_cont.geny'
  default, savfile, ''
  default, overwrite, 0
  fcount = 0
  If not overwrite then begin
    foundfile = loc_file(path=[curdir(),'$SSWDB_XRAY'], genxfile,count=fcount)
    overwrite = 1 - (fcount < 1)
  endif

  conversion= 12.39854  ; Converts between angstrom & keV as lambda = conversion / energy
  default, kmin, 0.1 ;keV
  default, kmax, 250.;keV
  wmin = conversion/kmax
  wmax = conversion/kmin
  edensity = 1.e11 ;cm-3
  verbose = 0
  default,temp_range, [1., 100.]*1e6
  ;default, ntemp, 400
  ; AC -- Use 41 temperatures from logT = 6 to 8, to match chianti.ioneq file
  default, ntemp, 41
  temp = temp_range[0] * 10^(findgen(ntemp)/(ntemp-1)*alog10((temp_range[1]/temp_range[0])))


  n=n_elements(edensity)
  nt=n_elements(temp)
  IF nt NE 1 THEN no_sum_int=1
  chianti_version, cversion
  cversion=cversion[0]

  if overwrite then begin
    default,ioneq, 'CHIANTI'
    
    ; AC -- Use all 30 elements
    default, nelem, 30         ; choose 30 most abundant elements from following list
    nelem_orig = nelem
    ;abundances saved will be 1 relative to hydrogen, actual abundances applied as needed
    ;this has the coronal abundance of the first 30 elements
    ; AC -- Start with Feldman to get sorted zindex, but use unity later...
    abund='sun_coronal_1992_feldman_ext.abund'
    chianti_dbase= concat_dir('SSW_CHIANTI','dbase') ; !xuvtop
    ioneq_file = loc_file(path=concat_dir(chianti_dbase,'ioneq'),'*.ioneq')
    select = where( strpos(STRLOWCASE(ioneq_file),STRLOWCASE(ioneq)) ne -1)
    ioneq_name = ioneq_file[ select[0] ]
    ; AC -- This is now required to get it to work properly in CHIANTI v9
    ; AC -- 2020/05/24, !file may now be obsoleted in recent Peter Young updates, here for backwards compatibility
    !ioneq_file = ioneq_name
    read_ioneq,ioneq_name,iont,ioneq,ion_ref


    abund_file = loc_file(path=concat_dir(chianti_dbase,'abundance'),'*.abund')
    select = where( strpos(STRLOWCASE(abund_file),STRLOWCASE(abund)) ne -1)
    abund_file = abund_file[ select[0] ]
    ; AC -- This is now required to get it to work properly in CHIANTI v9
    ; AC -- 2020/05/24, !file may now be obsoleted in recent Peter Young updates, here for backwards compatibility
    !abund_file = abund_file
    read_abund,abund_file,abundances,abundance_ref
    select = where( abundances gt 0, nselect)
    ord  = sort( abundances[select] )
    nord = n_elements(ord)
    ; AC -- get ALL the elements for now (ignore nelem), save zindex later
    ;ord = ord[ nord-nelem:*]
    select = select[ord]
    zindex = select[nord-nelem:*]
    ; AC -- no longer needed if using unity abundances ... keep zindex for later
    ;abundances = abundances * 0.0
    ;abundances[zindex] =  1.0 ;set all abundances to 1 and set abundances as needed in chianti_kev

    ; AC -- RELOAD -- Use unity abundances since freebound/freefree/two_photon no longer use common block
    ; AC -- This also works with the common block too
    abund='unity.abund'
    abund_file = loc_file(path=concat_dir(chianti_dbase,'abundance'),'*.abund')
    select = where( strpos(STRLOWCASE(abund_file),STRLOWCASE(abund)) ne -1)
    abund_file = abund_file[ select[0] ]
    read_abund,abund_file,abundances,abundance_ref
    ; AC -- This is now required to get it to work properly in CHIANTI v9
    ; AC -- 2020/05/24, !file may now be obsoleted in recent Peter Young updates, here for backwards compatibility
    !abund_file = abund_file

    ; AC -- common block has been deprecated for v9, retaining this for backwards compatibility
    COMMON elements, abundcom, abund_ref, ioneqcom, ioneq_logt, ioneq_ref
    abundcom = abundances
    abund_ref = 'abundances set to 1'
    ioneqcom = ioneq
    ioneq_logt = iont
    ioneq_ref = ion_ref

    default, nedge, 1000
    wavestep= float(wmax-wmin)/nedge
    nw=fix((wmax-wmin)/wavestep+0.1)
    lambda1=findgen(nedge+1)*wavestep+wmin
    ;;add in wavelengths around 8.81 kev
    ; AC -- TODO -- Add wavelengths around Mg, Si, and Ca K-edge, and Fe L-edge
    lambda1 = get_uniq( [lambda1, 1.4025+findgen(10)*.001/2])
    wvl = get_edges(lambda1,/mean)
    wavestep = get_edges(lambda1, /width)
    nw = n_elements(wvl)
    lambda = wvl
    edge_str = {conversion:conversion, wvledge: lambda1, wvl: wvl, wavestep: wavestep}

    ;From isothermal
    if float(cversion) lt 7.0 then dem_int=1d0/0.1/alog(10.)/temp
    abund_arr =  abundcom
    select= where( abundcom gt 0.0, nelem)
    totcont= dblarr(nw, ntemp, nelem)
    ;Build continua for all ions separately
    for i=0,nelem-1 do begin
      min_abund = 1.0
      ; AC -- Next two lines are no longer needed in v9 since already using unity abundances and specifying individual elements
      ;    abundcom = abundcom * 0.0
      ;    abundcom[select[i]] = 1.0

      freebound, temp, lambda,fb,min_abund=min_abund, abund_file=abund_file, $
        /photons, dem_int=dem_int, iz=select[i]+1 ; single element
      print,'FREEBOUND,  select[i]+1, abundcom ',I, select[i]+1, abundcom
      print,'Total',total(fb)
      freefree,temp, lambda,ff,min_abund=min_abund, abund_file=abund_file, $
        /photons, dem_int=dem_int, element=select[i]+1 ; single element
      print,'FREEFREE ',I
      print,'total',total(ff)
      two_photon, temp,  lambda, two_phot,min_abund=min_abund, abund_file=abund_file, $
        edensity=edensity, /photons, dem_int=dem_int, element=select[i]+1 ; single element
      print,'2PHOTON', I
      print,'total',total(two_phot)
      totcont[0,0,i]=(fb+ff+two_phot)/1d40*$
        ((wavestep + lambda*0.0)#(1.+temp*0.0))
    endfor
    ;Restore original abundance
    abundcom = abund_arr
    ; AC -- Not sure what this separation is still needed for...
    lobound = where( lambda lt 1.0, nlo)
    totcont_lo  = totcont[lobound,*,*]
    totcont  = float(totcont[nlo:*,*,*])

    chianti_doc = {ion_file: ioneq_name, ion_ref: ion_ref, version: cversion}
    ctemp = temp
    savegenx, zindex,  totcont, totcont_lo, $
      edge_str, ctemp, chianti_doc, $
      file=genxfile, /overwrite
    
    if savfile ne '' then $
      save,/compress, zindex,  totcont, totcont_lo, $
      edge_str, ctemp, chianti_doc, file=savfile  
;      IDL> help, zindex, totcont, totcont_lo, edge_str, ctemp, chianti_doc,/st
;    ZINDEX          LONG      = Array[30]
;    TOTCONT         FLOAT     = Array[1002, 41, 30]
;    TOTCONT_LO      DOUBLE    = Array[8, 41, 30]
;    ** Structure <1567aff0>, 4 tags, length=12128, data length=12128, refs=1:
;    CONVERSION      FLOAT           12.3985 ( conversion/e(kev) = wavelength (angstrom) )
;    WVLEDGE         FLOAT     Array[1011] in Angstrom
;    WVL             FLOAT     Array[1010] in Angstrom
;    WAVESTEP        FLOAT     Array[1010] in Angstrom
;    CTEMP           DOUBLE    = Array[41] in Kelvin
;    ** Structure <152a10d0>, 3 tags, length=80, data length=80, refs=1:
;    ION_FILE        STRING    '/disks/solar/home/ssw/packages/chianti/dbase/ioneq/chianti.ioneq'
;    ION_REF         STRING    Array[3]
;    VERSION         STRING    '9.0.1'  ;chianti version

  endif

  return, fcount ge 1 ? foundfile[0] : genxfile

end
