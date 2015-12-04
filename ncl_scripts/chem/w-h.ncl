
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
dirbep = "/ees/users/EMG/shenchong/paper/urban/megan/WRFV3-basexin2/test/test-xin/"
dirucm1 = "/ees/users/EMG/ees2/shenchong/urban/WRFV3-UCM/test/20091121-29/" ;UCM-AH
dirucm2 = "/ees/users/EMG/ees2/shenchong/urban/WRFV3-UCMnoah/test/20091121-29/" ;UCM-NOAH
dirslab = "/ees/users/EMG/ees2/shenchong/urban/WRFV3-NOURBAN/test/20091121-29/"

fbep = addfile(dirbep + "wrfout_d01_2009-10-31_00:00:00.nc","r")
;fucm1 = addfile(dirucm1 + "wrfout_d01_2009-11-21_00:00:00.nc","r")
;fucm2 = addfile(dirucm2 + "wrfout_d01_2009-11-21_00:00:00.nc","r")
;fslab = addfile(dirslab + "wrfout_d01_2009-11-21_00:00:00.nc","r")

 nts = 136
 nte = 160
 a = 0
 b = 10
 
 pm10b = fbep->W(:,:,:,:)
; pm10u1 = fucm1->o3(:,:,:,:)
; pm10u2 = fucm2->o3(:,:,:,:)
; pm10s = fslab->o3(:,:,:,:) 

;--------------------------------------------
 lon1=fbep->XLONG(0,0,:)
 lat1=fbep->XLAT(0,:,0)
 pm = pm10b(:,:,:,:)
 drawname = pm10b
 drawname@lon2d = lon1
 drawname@ilat2d = lat1
 RIGHTS = "BEP_W Wanqingsha"

;*****************************************

 p  =fbep->P(:,a:b,:,:)
 pb =fbep->PB(:,a:b,:,:)
  ;latitude
   lat1!0     = "lat"
   lat1&lat   =  lat1
   lat1@units = "degrees_north"
  ;longitude
   lon1!0     = "lon"
   lon1&lon   =  lon1
   lon1@units = "degrees_east"
   pm!2 = "lat"
   pm!3 = "lon"
   pm&lat  =  lat1
   pm&lon  =  lon1
;pressure
   p_total = (p+pb)*0.01
   p_total!2 = "lat"
   p_total!3 = "lon"
   p_total&lat  =  lat1
   p_total&lon  =  lon1

   temp     = dim_avg_n(p_total,2)
   temp1    = dim_avg_n(temp,2)
   pres     = dim_avg_n(temp1,0)
   pres@units = "mb"
   printVarSummary(pres)
   print(pres)

;   pmmean = pm(nts-1:nte-1,a:b,{23.16},{113.28}) ;luhu
;   pmmean = pm(nts-1:nte-1,a:b,{22.71},{113.55}) ;wqs
   pmmean = pm(nts-1:nte-1,a:b,{22.94},{114.38}) ;jgw
   printVarSummary(pmmean)
 ;  temp2 = dim_avg_n(pmmean,2)
 ;  qrmean = dim_avg_n(temp2,2)*1000*48/22.4
   qrmean = pmmean*100
   qrplot   = transpose(qrmean)
   qrplot!0 = "lev"
   qrplot!1 = "time"
   qrplot&lev = pres
   qrplot@units = "cm/s"
   printVarSummary(qrplot)
   print(max(qrplot))
   print(min(qrplot))
;****************************************************************************

   wks = gsn_open_wks("png","whbepjgw")             ; open a pdf file
   colors1= (/"white","black","White","Grey","RoyalBlue","LightSkyBlue",\
          "lightseagreen","PaleGreen","Gold","Khaki","LightSalmon","red"/)
   colors4= ("wh-bl-gr-ye-re")
   colors5= ("precip3_16lev")
   colors6= ("BlueGreen14")
   colors7= ("WhBlGrYeRe")
   gsn_define_colormap(wks,"GreenMagenta16")  ; choose color map

;***************************************************
   res                      = True                  ; plot mods desired
   res@vpXF = 0.15                    ;top
   res@vpYF = 0.7                     ;left
   res@vpWidthF  = 0.65              ; height and width of plot
   res@vpHeightF = 0.45
   res@cnRasterModeOn        = False
   res@cnFillOn              = True                       ; turn on color for contours
   res@cnLinesOn             = False                      ; turn off contour lines
   res@cnLineLabelsOn        = False                      ; turn off contour line labels
   res@cnLevelSelectionMode   = "ExplicitLevels"
   res@gsnRightString       = "cm/s"
   res@gsnLeftString       = RIGHTS
   res@cnLevels              = (/-20,-16,-12,-8,-4,0,2,4,6,8,10/)
;    res@cnLevels              = (/-5,-3,-1,0,2,5,10,15,20,25,30/)
;   res@cnLevels              = (/-15,-12,-9,-6,-3,0,1,3,5/)
   res@cnFillColors         = (/3,4,5,6,7,8,9,11,12,13,14,15/)
;  res@gsnScalarContour     = True                       ; contours desired
;    res@cnLevelSelectionMode   = "ManualLevels"     ;"ExplicitLevels"
;   res@cnLevelSpacingF = 2
;   res@cnMinLevelValF  = -15
;   res@cnMaxLevelValF  = 15
;   res@gsnSpreadColors = True
   res@lbOrientation         = "Vertical"                 ; vertical label bar
   res@lbLabelBarOn          = True
   res@lbLabelPosition      ="Right"
   res@pmLabelBarOrthogonalPosF = 0.1    ; set label bar offset  (for horizontal label bar)
   res@pmLabelBarWidthF       =0.07
   res@pmLabelBarHeightF      =0.45
   res@lbBoxLinesOn          = True
   res@gsnAddCyclic          = False                      ; regional data: not cyclic
   res@tfDoNDCOverlay        = False                       ; set True for native projection
   res@gsnMaximize           = True                      ; uncomment to maximize size
   res@tmYLMode          = "Explicit"
   res@tmYLValues        = ispan(1000,800,50)
   res@tmYLLabels        = (/1000,950,900,850,800/)
   res@tmXBMode          = "Explicit"
   res@tmXBValues        = ispan(0,23,4)
   res@tmXBLabels        = (/00,04,08,12,16,20/)
   res@tiYAxisString     = "Pressure (mb)"      ; y-axis label
   res@tiXAxisString     = "06,November,2009"
;   res@tmXBMode = "Explicit"
;  res@tmXBValues = ispan(112,115,1)
;  res@tmXBLabels = ispan(112,115,1)+"E"
;   res@tiXAxisString     = "East Longitude (Degs)"
   res@tiXAxisFontHeightF =0.025
   res@tiYAxisFontHeightF =0.025
   res@tmYRTickSpacingF     = 1.0
;   res@tiMainFont          ="helvetica-bold"             ; and the font type
;   res@tiXAxisFont         ="helvetica-bold"
;   res@tiYAxisFont         ="helvetica-bold"
;   plot = gsn_csm_hgt (wks,qrplot,res)
    plot = gsn_csm_pres_hgt (wks,qrplot,res)

    end  

