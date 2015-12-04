load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

dirbep = "/ees/users/EMG/shenchong/paper/urban/megan/WRFV3-basexin2/test/test-xin/"
fbep = addfile(dirbep + "wrfout_d01_2009-10-31_00:00:00"+".nc","r")

 lat1 = fbep->XLAT(1,:,:)
 lon1 = fbep->XLONG(1,:,:)
 ni = dimsizes(lat1(:,0))
 nj = dimsizes(lon1(0,:))
 ave_wn = new((/10,ni,nj/),float)
; ave_wn = 0

; ns = 144
; ne = 147
 pm10b = fbep->chem_no(:,0,:,:)
; pm10b1 = fbep->chem_o3(ne,0,:,:)
do i = 144,153

   ave_wn(i-144,:,:) = pm10b(i+1,:,:) -pm10b(i,:,:)

end do
   expmb = dim_sum_n(ave_wn(:,:,:),0)/10
; expmb = pm10b1-pm10b
 print(max(expmb))
 print(min(expmb))
 ;-------------------------------------------------
  rang_lon = (/min(min(lon1)),max(max(lon1))/)
  rang_lat = (/min(min(lat1)),max(max(lat1))/)
;  UT = fbep->U10(:,:,:)
;  VT = fbep->V10(:,:,:)
;  u   =dim_avg_n(UT(ns:ne,:,:),0)
;  v   =dim_avg_n(VT(ns:ne,:,:),0)
  lon1@units="degrees_east"
  lat1@units="degrees_north"
;  u@lon2d=lon1
;  u@lat2d=lat1
;  v@lon2d=lon1
;  v@lat2d=lat1
;--------------------------------------------
 drawname = expmb*1000
 drawname@lon2d = lon1
 drawname@lat2d = lat1
 RIGHTS = "Chemical Process_NO"
;****************************************************************************
   plot=new(1,graphic)
   poli=new(1,graphic)
   wks = gsn_open_wks("png","chemno0426")             ; open a pdf file
   colors1= (/"white","black","White","Grey","RoyalBlue","LightSkyBlue",\
          "lightseagreen","PaleGreen","Gold","Khaki","LightSalmon","red"/)
   colors4= ("wh-bl-gr-ye-re")
   colors5= ("precip3_16lev")
   colors6= ("BlWhRe")
   colors7= ("WhBlGrYeRe")
   colors8=("BlAqGrYeOrRe")
   gsn_define_colormap(wks,colors6)  ; choose color map
;   gsn_define_colormap(wks,"GreenMagenta16")
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
  res@mpFillOn              = False
  res@mpOutlineOn           = True
  res@mpDataBaseVersion     = "HighRes"
  res@mpFillBoundarySets    = "AllBoundaries"
  res@pmTickMarkDisplayMode = "Always"
;***************************************************

;***********************************************************
   res@cnRasterModeOn        = False
   res@cnFillOn              = True                       ; turn on color for contours
   res@cnLinesOn             = False                      ; turn off contour lines
   res@cnLineLabelsOn        = False                      ; turn off contour line labels
   res@gsnScalarContour     = True               ; contours desired
   res@cnLevelSelectionMode   = "ExplicitLevels"
   res@gsnRightString       = "ppb"
   res@gsnLeftString       = RIGHTS
;   res@cnFillColors         = (/2,3,4,5,6,7,9,11,12,13,14,15,16/)
;   res@cnLevels            = (/-200,-150,-100,-50,-20,0,10,20,30,50,70/)
   res@cnLevels            = (/-100,-70,-50,-30,-10,0,10,30,50,70/)
;  res@cnFillColors         = (/8,7,6,5,4,3,2,11,13,16,17,18/)
  res@cnFillColors         = (/2,18,27,34,48,52,60,68,76,84,92/)
   res@lbOrientation         = "Vertical"                 ; vertical label bar
   res@lbLabelBarOn          = True
   res@lbBoxLinesOn          = True
   res@gsnAddCyclic          = False                      ; regional data: not cyclic
   res@tfDoNDCOverlay        = True                       ; set True for native projection
   res@gsnMaximize           = True                      ; uncomment to maximize size
   res@lbLabelFontHeightF      =0.023
   res@tmXBLabelFontHeightF = 0.025
   res@gsnLeftStringFontHeightF    =   0.025
   res@gsnRightStringFontHeightF   =   0.025
   res@tiXAxisFont   = "times-roman"  
   res@tiXAxisFont   = "times-roman"
;****************************************************************************************
;  res@vcRefMagnitudeF          = 10.0              ; make vectors larger
;  res@gsnMaximize              = True              ; Maximize plot in frame
;  res@vcMinDistanceF           = 0.02
;  res@tfDoNDCOverlay           = True              ; set True for native projection
;  res@vcRefLengthF             = 0.045
;  res@vcMinFracLengthF         = 0.25
; res@vcGlyphStyle            = "WindBarb"         ; choose wind barbs
;  res@vcGlyphStyle            = "CurlyVector"     ; turn on curley vectors
;  res@vcLineArrowColor        = "black"           ; change vector color
;  res@vcLineArrowThicknessF   = 1.0               ; change vector thickness
;  res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last


   res@gsnFrame  = False
   res@gsnDraw   = False
   latlon = asciiread("./diqujie.txt",(/31629,2/),"float")
   lon2 = latlon(:,0)
   lat2 = latlon(:,1)
   resp = True
   resp@gsLineColor = "black"
   resp@gsLineThicknessF = 2
;   plot = gsn_csm_vector_scalar_map(wks,u,v,drawname,res)                 ; Call the gsn_csm function for                                                                         ; drawing contours over a map.
;   poli = gsn_add_polyline(wks,plot,lon2,lat2,resp)
   plot = gsn_csm_contour_map(wks,drawname,res)                 ; Call the gsn_csm function for
                                                          ; drawing contours over a map.
   poli = gsn_add_polyline(wks,plot,lon2,lat2,resp)
;   latlon1 = asciiread("./shengjie.txt",(/82750,2/),"float")
;   lon3 = latlon1(:,0)
;   lat3 = latlon1(:,1)
;   poli1 = gsn_add_polyline(wks,plot,lon3,lat3,resp)

   overlay(plot,poli)
;   overlay(plot,poli1)

   draw(plot)                                  ; draw the temperature plot (with the U-wind plot overlaid)
   frame(wks)    
;-----------------------------------------------
end
