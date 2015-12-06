load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

dirbep = "$HOME/ees2/shenchong/urban/WRFV3-BEP/test/20091121-29/"
dirucm1 = "$HOME/ees2/shenchong/urban/WRFV3-UCM/test/20091121-29/" ;UCM-AH
dirucm2 = "$HOME/ees2/shenchong/urban/WRFV3-UCMnoah/test/20091121-29/" ;UCM-NOAH
dirslab = "$HOME/ees2/shenchong/urban/WRFV3-NOURBAN/test/20091121-29/"

fbep = addfile(dirbep + "wrfout_d01_2009-11-21_00:00:00"+".nc","r")
fucm1 = addfile(dirucm1 + "wrfout_d01_2009-11-21_00:00:00"+".nc","r")
fucm2 = addfile(dirucm2 + "wrfout_d01_2009-11-21_00:00:00"+".nc","r")
fslab = addfile(dirslab + "wrfout_d01_2009-11-21_00:00:00"+".nc","r")

 lat1 = fbep->XLAT(1,:,:)
 lon1 = fbep->XLONG(1,:,:)

 pm10b = fbep->o3(:,0,:,:)
 pm10u1 = fucm1->o3(:,0,:,:)
 pm10u2 = fucm2->o3(:,0,:,:)
 pm10s = fslab->o3(:,0,:,:)

 nts = 97
 nte = 193
 expmb = dim_avg_n(pm10b(nts-1:nte-1,:,:),0)
 expmu1 = dim_avg_n(pm10u1(nts-1:nte-1,:,:),0)
 expmu2 = dim_avg_n(pm10u2(nts-1:nte-1,:,:),0)
 expms = dim_avg_n(pm10s(nts-1:nte-1,:,:),0)

;--------------------------------------------
 pmbu1 = expmb - expmu1
 pmbu2 = expmb - expmu2
 pmbs  = expmb - expms
 drawname = expmb*1000*48/22.4
 drawname@lon2d = lon1
 drawname@lat2d = lat1
 RIGHTS = "BEP_O3"
;****************************************************************************
   plot=new(1,graphic)
   poli=new(1,graphic)

   wks = gsn_open_wks("png","bepo3")             ; open a pdf file
   colors1= (/"white","black","White","Grey","RoyalBlue","LightSkyBlue",\
          "lightseagreen","PaleGreen","Gold","Khaki","LightSalmon","red"/)
   colors4= ("wh-bl-gr-ye-re")
   colors5= ("precip3_16lev")
   colors6= ("BlueGreen14")
   colors7= ("WhBlGrYeRe")
   colors8=("BlAqGrYeOrRe")
   gsn_define_colormap(wks,colors5)  ; choose color map

;****************************************************************************
   res                       = True               ; plot mods desired
  res@sfXArray =lon1
  res@sfYArray =lat1
   res@mpProjection          = "Mercator"
  res@mpMinLatF = min(lat1)
  res@mpMaxLatF = max(lat1)
  res@mpMinLonF = min(lon1)
  res@mpMaxLonF = max(lon1)
   res@mpLimitMode            = "Corners"
   res@mpLeftCornerLatF       = min(lat1)
   res@mpLeftCornerLonF       = min(lon1)
   res@mpRightCornerLatF      = max(lat1)
   res@mpRightCornerLonF      = max(lon1)
   res@mpFillOn               = False
   res@mpOutlineOn            = False
   res@pmTickMarkDisplayMode  = "Always"
;***************************************************
   res@cnRasterModeOn        = False
   res@cnFillOn              = True                       ; turn on color for contours
   res@cnLinesOn             = False                      ; turn off contour lines
   res@cnLineLabelsOn        = False                      ; turn off contour line labels
   res@cnLevelSelectionMode   = "ExplicitLevels"
   res@gsnRightString       = "ug/m~S~3~N~"
   res@gsnLeftString       = RIGHTS
   res@cnLevels            = (/30,40,50,60,70,80,100,120,140,160/)
   res@cnFillColors         = (/2,3,5,7,11,13,14,15,16,17,18/)
;  res@gsnScalarContour     = True                       ; contours desired
   res@lbOrientation         = "Vertical"                 ; vertical label bar
   res@lbLabelBarOn          = True
   res@lbBoxLinesOn          = True
   res@gsnAddCyclic          = False                      ; regional data: not cyclic
   res@tfDoNDCOverlay        = True                       ; set True for native projection
   res@gsnMaximize           = True                      ; uncomment to maximize size
   res@gsnFrame              = False
   latlon = asciiread("./diqujie.txt",(/31629,2/),"float")
   lon2 = latlon(:,0)
   lat2 = latlon(:,1)
   resp = True
   resp@gsLineColor = "black"
   resp@gsLineThicknessF = 1.5
;   resp@tfDoNDCOverlay        = True                       ; set True for native projection
;   resp@gsnAttachPlotsXAxis   =True


   plot = gsn_csm_contour_map(wks,drawname,res)                 ; Call the gsn_csm function for
                                                          ; drawing contours over a map.
   poli = gsn_add_polyline(wks,plot,lon2,lat2,resp)

   latlon1 = asciiread("./shengjie.txt",(/82750,2/),"float")
   lon3 = latlon1(:,0)
   lat3 = latlon1(:,1)
   poli1 = gsn_add_polyline(wks,plot,lon3,lat3,resp)

;  reso                     = True
;  reso@gsnMaximize          = False    ; Maximize plot in frame
; reso@tiMainString         = "No resources set"
;  reso@vcRefMagnitudeF          = 10.0
;  reso@vcLineArrowThicknessF     = 2
;  reso@vcLineArrowColor    = 255
;  reso@vcMinDistanceF  = 0.015
; reso@vcRefAnnoString2 = "zhangjian"
;  reso@vcMinDistanceF           = 0.02
;  reso@vcLabelsUseVectorColor  = False
;  reso@vcLabelFontColor      = -1
;   reso@vcLineArrowColor      = -1

; reso@tfDoNDCOverlay        = True                       ; set True for native projection
;  reso@vcRefLengthF         = 0.045
;  reso@vcMinFracLengthF     = 0.25
;  vector = gsn_vector(wks,u2,v2,reso)

   overlay(plot,poli)
   overlay(plot,poli1)
;   overlay(plot,vector)
;   gsn_panel(wks,plot,(/1,1/),False)
   draw(plot)                                  ; draw the temperature plot (with the U-wind plot overlaid)
   frame(wks)    
;-----------------------------------------------
end
