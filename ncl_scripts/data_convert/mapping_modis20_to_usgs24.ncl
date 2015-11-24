load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

H1=systemfunc("/bin/rm geo_em.d02.nc")
H2=systemfunc("/bin/cp geo_em.d02.nc_modis24 geo_em.d02.nc")

f0 = addfile("geo_em.d02.nc","rw")

f1 = addfile("geo_em.d02.nc_modis20.nc","rw")
lu_modis20=f1->LU_INDEX
nNames = dimsizes(lu_modis20)
print(nNames)

lu_map=lu_modis20

do n=0,nNames(1)-1
   do m=0,nNames(2)-1

      if (lu_modis20(0,n,m).eq.1) then
         lu_map(0,n,m)=14
      else if (lu_modis20(0,n,m).eq.2) then
         lu_map(0,n,m)=13
      else if (lu_modis20(0,n,m).eq.3) then
         lu_map(0,n,m)=12
      else if (lu_modis20(0,n,m).eq.4) then
         lu_map(0,n,m)=11
      else if (lu_modis20(0,n,m).eq.5) then
         lu_map(0,n,m)=15
      else if (lu_modis20(0,n,m).eq.6) then
         lu_map(0,n,m)=8
      else if (lu_modis20(0,n,m).eq.7) then
         lu_map(0,n,m)=9
      else if (lu_modis20(0,n,m).eq.8) then
         lu_map(0,n,m)=10
      else if (lu_modis20(0,n,m).eq.9) then
         lu_map(0,n,m)=10
      else if (lu_modis20(0,n,m).eq.10) then
         lu_map(0,n,m)=7
      else if (lu_modis20(0,n,m).eq.11) then
         lu_map(0,n,m)=17
      else if (lu_modis20(0,n,m).eq.12) then
         lu_map(0,n,m)=3
      else if (lu_modis20(0,n,m).eq.13) then
         lu_map(0,n,m)=1
      else if (lu_modis20(0,n,m).eq.14) then
         lu_map(0,n,m)=4
      else if (lu_modis20(0,n,m).eq.15) then
         lu_map(0,n,m)=24
      else if (lu_modis20(0,n,m).eq.16) then
         lu_map(0,n,m)=19
      else if (lu_modis20(0,n,m).eq.17) then
         lu_map(0,n,m)=16
      else if (lu_modis20(0,n,m).eq.18) then
         lu_map(0,n,m)=21
      else if (lu_modis20(0,n,m).eq.19) then
         lu_map(0,n,m)=22
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
   end do
end do
       
f0->LU_INDEX=lu_map
end
