load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin


f0 = addfile("geo_em.d01.nc","rw")
lu_map=f0->LU_INDEX
lu_map=0;

printVarSummary(luf_map)

f1 = addfile("geo_em.d01.modis20pjm.nc","r")
lu_modis20=f1->LU_INDEX

printVarSummary(luf_modis20)

nNames = dimsizes(lu_modis20)
print(nNames)

do n=0,nNames(1)-1
   do m=0,nNames(2)-1

      if (lu_modis20(0,n,m).eq.1) then
         lu_map(0,n,m)=8
      else if (lu_modis20(0,n,m).eq.2) then
         lu_map(0,n,m)=4
      else if (lu_modis20(0,n,m).eq.3) then
         lu_map(0,n,m)=4
      else if (lu_modis20(0,n,m).eq.4) then
         lu_map(0,n,m)=4
      else if (lu_modis20(0,n,m).eq.5) then
         lu_map(0,n,m)=6
      else if (lu_modis20(0,n,m).eq.6) then
         lu_map(0,n,m)=6
      else if (lu_modis20(0,n,m).eq.7) then
         lu_map(0,n,m)=7
      else if (lu_modis20(0,n,m).eq.8) then
         lu_map(0,n,m)=4
      else if (lu_modis20(0,n,m).eq.9) then
         lu_map(0,n,m)=7
      else if (lu_modis20(0,n,m).eq.10) then
         lu_map(0,n,m)=5
      else if (lu_modis20(0,n,m).eq.11) then
         lu_map(0,n,m)=2
      else if (lu_modis20(0,n,m).eq.12) then
         lu_map(0,n,m)=2
      else if (lu_modis20(0,n,m).eq.13) then
         lu_map(0,n,m)=1
      else if (lu_modis20(0,n,m).eq.14) then
         lu_map(0,n,m)=1
      else if (lu_modis20(0,n,m).eq.15) then
         lu_map(0,n,m)=3
      else if (lu_modis20(0,n,m).eq.16) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.17) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.18) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.19) then
         lu_map(0,n,m)=8
      else if (lu_modis20(0,n,m).eq.20) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.21) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.22) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.23) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.24) then
         lu_map(0,n,m)=8
      else if (lu_modis20(0,n,m).eq.25) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.26) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.27) then
         lu_map(0,n,m)=9
      else 
         lu_map(0,n,m)=23
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
      end if
   end do
end do
       
f0->LU_INDEX=lu_map


end
