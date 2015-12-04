load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
  if (.not.isvar("wrfoutdir")) then
  wrfoutdir = "/ees/users/EMG/ees2/daijn/djn/WRF3.4.1/wrfchem_bu/test/em_real/data/"
  end if
  if (.not.isvar("domain")) then
  domain = 1
  end if
  if (.not.isvar("outgraphdir")) then
  outgraphdir = "./"
  end if
  FILES = systemfunc (" ls -1 " + wrfoutdir + "wrfout_d0" + domain + "_*")
  numFILES = dimsizes(FILES)
  print("numFILES = " + numFILES)
;  print(FILES)
  print (" ")

;dirbep = "/ees/users/EMG/ees2/daijn/djn/WRF3.4.1/wrfchem_bu/test/em_real/data/"
;fbep = addfile(dirbep + "wrfout_d01_2014-10-31_00:00:00" + ".nc","r")

  if (numFILES.eq.1) then
  fbep = addfile(FILES+".nc","r")
  else
  fbep = addfiles(FILES+".nc","r")
  end if

  times = wrf_user_getvar(fbep,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file
;print(times)
 lat1 = fbep[1]->XLAT(0,:,:)
 lon1 = fbep[1]->XLONG(0,:,:)
;print(lat1)

do it = 0,ntimes-1
 print("Working on time: " + times(it) )

 nday = 0
; ns = 0 + nday*24
; ne = 23 + nday*24
  ns = 0
  ne = 0
 pm10b=fbep[it]->o3(:,0,:,:)
print(pm10b) 
 expmb=dim_avg_n(pm10b(ns:ne,:,:),0)
 ;-------------------------------------------------
  rang_lon = (/min(min(lon1)),max(max(lon1))/)
  rang_lat = (/min(min(lat1)),max(max(lat1))/)
  UT = fbep[it]->U10(:,:,:)
  VT = fbep[it]->V10(:,:,:)
  u   =dim_avg_n(UT(ns:ne,:,:),0)
  v   =dim_avg_n(VT(ns:ne,:,:),0)
  lon1@units="degrees_east"
  lat1@units="degrees_north"
  u@lon2d=lon1
  u@lat2d=lat1
  v@lon2d=lon1
  v@lat2d=lat1
;--------------------------------------------
 drawname = expmb*1000*48/22.4
; drawname = expmb*10000*48/22.4
 drawname@lon2d = lon1
 drawname@lat2d = lat1
 RIGHTS = "AVERAGE_O3"
;****************************************************************************

   plot=new(1,graphic)
   poli=new(1,graphic)
   wks = gsn_open_wks("png","totalo3-wind")             ; open a pdf file
   colors1= (/"white","black","White","Grey","RoyalBlue","LightSkyBlue",\
          "lightseagreen","PaleGreen","Gold","Khaki","LightSalmon","red"/)
   colors4= ("wh-bl-gr-ye-re")
   colors5= ("precip3_16lev")
   colors6= ("BlueGreen14")
   colors7= ("WhBlGrYeRe")
   colors8=("BlAqGrYeOrRe")
   gsn_define_colormap(wks,colors7)  ; choose color map

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
   res@gsnRightString       = "ug/m3"
   res@gsnLeftString       = RIGHTS
   res@cnFillColors         = (/2,5,10,15,58,68,78,88,98/)
   res@cnLevels            = (/50,100,150,170,200,230,250,270/)
;  res@cnFillColors         = (/58,48,15,10,5,2,68,78,88,98/)
   res@lbOrientation         = "Vertical"                 ; vertical label bar
   res@lbLabelBarOn          = True
   res@lbBoxLinesOn          = True
   res@gsnAddCyclic          = False                      ; regional data: not cyclic
   res@tfDoNDCOverlay        = True                       ; set True for native projection
   res@gsnMaximize           = True                      ; uncomment to maximize size
   res@lbLabelFontHeightF      =0.02
;****************************************************************************************
  res@vcRefMagnitudeF          = 10.0              ; make vectors larger
  res@gsnMaximize              = True              ; Maximize plot in frame
  res@vcMinDistanceF           = 0.02
  res@tfDoNDCOverlay           = True              ; set True for native projection
  res@vcRefLengthF             = 0.045
  res@vcMinFracLengthF         = 0.25
; res@vcGlyphStyle            = "WindBarb"         ; choose wind barbs
  res@vcGlyphStyle            = "CurlyVector"     ; turn on curley vectors
  res@vcLineArrowColor        = "black"           ; change vector color
  res@vcLineArrowThicknessF   = 1.0               ; change vector thickness
  res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last

;  res@PlotTitle = "Wind and O3 Simulation Result at " + times(it) + " UTC"

   res@gsnFrame  = False
   res@gsnDraw   = False
   latlon = asciiread("./diqujie.txt",(/31629,2/),"float")
   lon2 = latlon(:,0)
   lat2 = latlon(:,1)
   resp = True
   resp@gsLineColor = "black"
   resp@gsLineThicknessF = 2

if (numFILES.eq.1) then
   plot = gsn_csm_vector_scalar_map(wks,u,v,drawname,res)                 ; Call the gsn_csm function for      ; drawing contours over a map.
   poli = gsn_add_polyline(wks,plot,lon2,lat2,resp)
else
   plot = gsn_csm_vector_scalar_map(wks,u,v,drawname,res)                 ; Call the gsn_csm function for      ; drawing contours over a map.
   poli = gsn_add_polyline(wks,plot,lon2,lat2,resp)
end if
;   latlon1 = asciiread("./shengjie.txt",(/82750,2/),"float")
;   lon3 = latlon1(:,0)
;   lat3 = latlon1(:,1)
;   poli1 = gsn_add_polyline(wks,plot,lon3,lat3,resp)

   overlay(plot,poli)
;   overlay(plot,poli1)

   draw(plot)                                  ; draw the temperature plot (with the U-wind plot overlaid)
   frame(wks)    
  print(it)
end do
;-----------------------------------------------
end
