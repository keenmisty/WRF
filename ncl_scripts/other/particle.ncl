load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "./function/bilinear.ncl"
load "./function/airdensity.ncl"
load "./function/ppbv2ugm3.ncl"
load "./function/Qv2Pv.ncl"
load "./function/CalTemp.ncl"

begin
  ;read lat&lon
;  files = addfile("../wrfout_d01_2009-10-31_00:00:00")+".nc"
  f0 = addfile("../wrfout_d01_2009-10-31_00:00:00.nc","r") 
  lat = f0->XLAT(0,:,:)
  lon = f0->XLONG(0,:,:)
  rang_lon = (/min(min(lon)),max(max(lon))/)
  rang_lat = (/min(min(lat)),max(max(lat))/)

  ;read files
;  diri="../"
;  files=systemfunc("ls "+diri+"wrfout_d01_*")+".nc"
;  f1=addfiles(files,"r")

   
   pm10=f0->PM10(:,0,:,:)
   pm25=f0->PM2_5_DRY(:,0,:,:)


   fout=addfile("particle.nc","c")
   fout->lat  = lat
   fout->lon  = lon
   fout->pm10 =pm10
   fout->pm25 =pm25
end


