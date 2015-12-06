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

   p     = f0->P(:,0,:,:)
   pb    = f0->PB(:,0,:,:)
   press =p+pb
   t     = f0->T(:,0,:,:)
   theta =t+300
   a_t   =CalTemp(press,theta) ;Calculate ambient temperature
   a_p=airdensity(press,a_t)
   npress=dimsizes(press)
   k=npress(0)
   m=npress(1)
   n=npress(2)
   
   so2=f0->so2(:,0,:,:)
   no=f0->no(:,0,:,:)
   no2=f0->no2(:,0,:,:)
   o3=f0->o3(:,0,:,:)
   co=f0->co(:,0,:,:)
   nh3=f0->nh3(:,0,:,:)

   ald=f0->ald(:,0,:,:)
   hcho=f0->hcho(:,0,:,:)
   eth=f0->eth(:,0,:,:)
   xyl=f0->xyl(:,0,:,:)
   iso=f0->iso(:,0,:,:)
   par=f0->par(:,0,:,:)

   so2_sim=new((/k,m,n/),float)
   so2_sim=ppbv2ugm3(so2*1000,64,press,a_t)
   no_sim=new((/k,m,n/),float)
   no_sim=ppbv2ugm3(no*1000,28,press,a_t)
   no2_sim=new((/k,m,n/),float)
   no2_sim=ppbv2ugm3(no2*1000,46,press,a_t)
   nh3_sim=new((/k,m,n/),float)
   nh3_sim=ppbv2ugm3(nh3*1000,17,press,a_t)
   o3_sim=new((/k,m,n/),float)
   o3_sim=ppbv2ugm3(o3*1000,48,press,a_t)
   co_sim=new((/k,m,n/),float)
   co_sim=ppbv2ugm3(co*1000,28,press,a_t)

   voc_sim=new((/k,m,n/),float)
   voc_sim=(ald+hcho+eth+xyl+iso+par)*1000

   fout=addfile("gas.nc","c")
   fout->lat  = lat
   fout->lon  = lon
   fout->so2  =so2_sim
   fout->no   =no_sim
   fout->no2  =no2_sim
   fout->nh3  =nh3_sim
   fout->co   =co_sim
   fout->o3   =o3_sim
   fout->voc  =voc_sim
end


