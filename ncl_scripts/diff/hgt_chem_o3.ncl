; Written by Ziqiang Jiang in Jul. 2011
; Atmosphere Environment Research Center (AERC)
; School of Atmospheric Sciences, Nanjing University

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$HOME/ncl/share/read_wrf.ncl"

begin

   ist = 0    ; Start from 0
   sta = (/"CCM",  "PK"/)
   lon = (/118.75, 118.706/)
   lat = (/32.26,   32.177/)

   ; Read data from WRF output
   varname = "o3"
   fls = getenv("dir0")+getenv("fname")
   o3_E0 = read_wrf_nc(fls,varname)
   fls = getenv("dir1")+getenv("fname")
   o3_E1 = read_wrf_nc(fls,varname)

   tms = read_wrf_nc(fls,"Times")
   nt  = dimsizes(tms(:,1))
   print("Times number: " + nt)

   loc = get_loc_sta(fls,lon,lat)
   locx = loc(0,ist)
   locy = loc(1,ist)
   xlat = read_wrf_nc(fls,"xlat")
   xlon = read_wrf_nc(fls,"xlon")
   pres = read_wrf_nc(fls,"pres")
   pres@description = "Pressure (hpa)"

   o3hx_E0 = dim_avg_n(o3_E0(:,:,locy,:),0)
   o3hx_E0!0 = "plev"
   o3hx_E0!1 = "lon"
   o3hx_E0&plev = pres(:,locy,locx)
   o3hx_E0&lon  = xlon(locy,:)

   o3hx_E1 = dim_avg_n(o3_E1(:,:,locy,:),0)
   o3hx_E1!0 = "plev"
   o3hx_E1!1 = "lon"
   o3hx_E1&plev = pres(:,locy,locx)
   o3hx_E1&lon  = xlon(locy,:)

   o3hy_E0 = dim_avg_n(o3_E0(:,:,:,locx),0)
   o3hy_E0!0 = "plev"
   o3hy_E0!1 = "lat"
   o3hy_E0&plev = pres(:,locy,locx)
   o3hy_E0&lat  = xlat(:,locx)

   o3hy_E1 = dim_avg_n(o3_E1(:,:,:,locx),0)
   o3hy_E1!0 = "plev"
   o3hy_E1!1 = "lat"
   o3hy_E1&plev = pres(:,locy,locx)
   o3hy_E1&lat  = xlat(:,locx)

   o3ht_E0 = transpose(o3_E0(:,:,locy,locx))
   o3ht_E0!0 = "plev"
   o3ht_E0&plev = pres(:,locy,locx)

   o3ht_E1 = transpose(o3_E1(:,:,locy,locx))
   o3ht_E1!0 = "plev"
   o3ht_E1&plev = pres(:,locy,locx)


   ; Open graphics file
   wks = gsn_open_wks("png","hgt_chem_"+varname)
   gsn_define_colormap(wks,"precip3_16lev")

   ; Set up some basic plot resources
   cnres = True   						
   cnres@gsnFrame   = False
   cnres@gsnDraw    = False
   cnres@vpWidthF   = 1
   cnres@vpHeightF  = .6
   cnres@cnFillOn   = True
   cnres@cnLinesOn  = False
   cnres@cnLevelSelectionMode = "ManualLevels"
   cnres@cnLevelSpacingF = 10
   cnres@cnMinLevelValF  = 10
   cnres@cnMaxLevelValF  = 70
   cnres@cnLineLabelsOn  = False
   cnres@cnInfoLabelOn   = False
   cnres@gsnSpreadColors = True
   cnres@trYMinF          = 700 
   cnres@tmYRTickSpacingF = 1
   cnres@lbLabelBarOn     = False

   ; MAKE PLOTS
   hgt = new(6,"graphic")
   opts = cnres
   opts@tmXBMode   = "Explicit"
   opts@tmXBValues = ispan(116,123,1)
   opts@tmXBLabels = ispan(116,123,1)+"E"
   opts@gsnLeftStringOrthogonalPosF = .05
   opts@gsnLeftString = "NOBC" 
   hgt(0) = gsn_csm_pres_hgt(wks,o3hx_E0,opts)
   opts@gsnLeftString = "BC"
   hgt(1) = gsn_csm_pres_hgt(wks,o3hx_E1,opts)
   delete(opts)

   opts = cnres
   opts@tmXBMode   = "Explicit"
   opts@tmXBValues = ispan(28,35,1)
   opts@tmXBLabels = ispan(28,35,1)+"N"
   hgt(2) = gsn_csm_pres_hgt(wks,o3hy_E0,opts)
   hgt(3) = gsn_csm_pres_hgt(wks,o3hy_E1,opts)
   delete(opts)

   opts = cnres
   taus  = ispan(0,nt-1,1)
   lbTms = tms(:,8:9)+"/"+tms(:,5:6)
   opts@tmXBMode         = "Explicit" 
   opts@tmXBValues       = taus(0::48)
   opts@tmXBMinorValues  = taus(0::24)
   opts@tmXBLabels       = lbTms(0::48)
   hgt(4) = gsn_csm_pres_hgt(wks,o3ht_E0,opts)    
   hgt(5) = gsn_csm_pres_hgt(wks,o3ht_E1,opts)
   delete(opts)

   pnlres = True
   pnlres@gsnPanelYWhiteSpacePercent = 0
   pnlres@gsnPanelLabelBar   = True
   pnlres@lbTitleString      = "O3 (ppb)"
   pnlres@lbTitleFontHeightF = .012
   pnlres@pmLabelBarOrthogonalPosF = 0
   gsn_panel(wks,(/hgt/),(/3,2/),pnlres)


end
