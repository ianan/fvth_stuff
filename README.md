# fvth_stuff
Some tests with the isothermal model in sswidl, f_vth, especially with the lookup table files created from CHIANTI, i.e.

* The model itself is in [ssw/packages/xray/idl/f_vth.pro](https://hesperia.gsfc.nasa.gov/ssw/packages/xray/idl/f_vth.pro) which in turns calls [chianti_kev.pro](https://hesperia.gsfc.nasa.gov/ssw/packages/xray/idl/chianti_kev.pro)
* The databse files are in [ssw/packages/xray/dbase/chianti/](https://hesperia.gsfc.nasa.gov/ssw/packages/xray/dbase/chianti/) and should by default be using v901 (as of late 2020)
* To generate newer files would use [ssw/packages/xray/idl/setup_chianti_cont.pro](https://hesperia.gsfc.nasa.gov/ssw/packages/xray/idl/setup_chianti_cont.pro) for continuum and [ssw/packages/xray/idl/setup_chianti_lines.pro](https://hesperia.gsfc.nasa.gov/ssw/packages/xray/idl/setup_chianti_lines.pro) for the lines.

The f_vth model in sunxspex/python is currently using the older v7 files from sswidl, though can call your own, i.e. [sunxspex/sunxspex/thermal.py](https://github.com/sunpy/sunxspex/blob/master/sunxspex/thermal.py).
