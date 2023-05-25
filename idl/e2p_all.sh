#!/bin/csh
#
foreach f (*.eps)
  echo $f
 ps2pdf -dPDFSETTINGS=/prepress -sEPSCrop $f 
end
#EOF
