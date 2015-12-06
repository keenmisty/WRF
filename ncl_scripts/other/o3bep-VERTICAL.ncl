load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

dirbep = "/ees/users/EMG/shenchong/paper/urban/megan/WRFV3-basexin2/test/test-xin/"

fbep = addfile(dirbep + "wrfout_d01_2009-10-31_00:00:00"+".nc","r")

 lat1 = fbep->XLAT(1,:,:)
 lon1 = fbep->XLONG(1,:,:)

 pm10b = fbep->vmix_o3(:,0,:,:)

 st = 149
 et = 150
 expmb = pm10b(et-1,:,:)-pm10b(st-1,:,:)

;--------------------------------------------
 drawname = expmb*1000*48/22.4
 drawname@lon2d = lon1
 drawname@lat2d = lat1
 RIGHTS = "VERTICAL MIXING_O3 13:00"
;****************************************************************************
   plot=new(1,graphic)
   poli=new(1,graphic)

   wks = gsn_open_wks("png","VERTICAL MIXINGo3")             ; open a pdf file
   colors1= (/"white","black","White","Grey","RoyalBlue","LightSkyBlue",\
          "lightseagreen","PaleGreen","Gold","Khaki","LightSalmon","red"/)
   colors4= ("wh-bl-gr-ye-re")
   colors5= ("precip3_16lev")
   colors6= ("BlueGreen14")
   colors7= ("WhBlGrYeRe")
   colors8=("BlAqGrYeOrRe")
   colors9=("BlueWhiteOrangeRed")
   gsn_define_colormap(wks,colors9)  ; choose color map

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
   res@gsnRightString       = "Unit:ug/m~S~3~N~"
   res@gsnLeftString       = RIGHTS
;   res@cnLevels            = (/30,40,50,60,80,100,120,150,200,250/)
;   res@cnFillColors        = (/2,3,5,7,11,13,14,15,16,17,18/)
   res@cnFillColors         = (/2,16,24,34,50,66,82,98,143,159,175,191,207,213,223,239/)
   res@cnLevels             = (/-150,-120,-100,-70,-50,-30,-10,0,10,30,60,90,120,150,200/)
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
