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
   
   so4_1=f0->so4_a01(:,0,:,:)
   so4_2=f0->so4_a02(:,0,:,:)
   so4_3=f0->so4_a03(:,0,:,:)
   so4_4=f0->so4_a04(:,0,:,:)

   no3_1=f0->no3_a01(:,0,:,:)
   no3_2=f0->no3_a02(:,0,:,:)
   no3_3=f0->no3_a03(:,0,:,:)
   no3_4=f0->no3_a04(:,0,:,:)

   nh4_1=f0->nh4_a01(:,0,:,:)
   nh4_2=f0->nh4_a02(:,0,:,:)
   nh4_3=f0->nh4_a03(:,0,:,:)
   nh4_4=f0->nh4_a04(:,0,:,:)

   oc_1=f0->oc_a01(:,0,:,:)
   oc_2=f0->oc_a02(:,0,:,:)
   oc_3=f0->oc_a03(:,0,:,:)
   oc_4=f0->oc_a04(:,0,:,:)

   bc_1=f0->bc_a01(:,0,:,:)
   bc_2=f0->bc_a02(:,0,:,:)
   bc_3=f0->bc_a03(:,0,:,:)
   bc_4=f0->bc_a04(:,0,:,:)
 
   so4_sim=new((/k,m,n/),float)
   so4_sim=(so4_1+so4_2+so4_3+so4_4)*a_p
   no3_sim=new((/k,m,n/),float)
   no3_sim=(no3_1+no3_2+no3_3+no3_4)*a_p
   nh4_sim=new((/k,m,n/),float)
   nh4_sim=(nh4_1+nh4_2+nh4_3+nh4_4)*a_p
   oc_sim=new((/k,m,n/),float)
   oc_sim=(oc_1+oc_2+oc_3+oc_4)*a_p
   bc_sim=new((/k,m,n/),float)
   bc_sim=(bc_1+bc_2+bc_3+bc_4)*a_p
  
   fout=addfile("chemical.nc","c")
   fout->lat  = lat
   fout->lon  = lon
   fout->so4  =so4_sim
   fout->no3  =no3_sim
   fout->nh4  =nh4_sim
   fout->oc   =oc_sim
   fout->bc   =bc_sim

end

