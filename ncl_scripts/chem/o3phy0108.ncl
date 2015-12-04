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


 pm10b = fbep->chem_o3(:,0,:,:)
 pm10b1 = fbep->o3(:,0,:,:)
;do i = 144,153
;do i = 168,177
;do i = 192,201
;do i = 120,129
;do i = 96,105
;do i = 72,81
;do i = 48,57
;do i = 24,33

    expmb =pm10b1(168,:,:)-(pm10b(168,:,:) -pm10b(167,:,:))

;end do
;   expmb = dim_sum_n(ave_wn(:,:,:),0)/10

 print(max(expmb))
 print(min(expmb))
 ;-------------------------------------------------
  rang_lon = (/min(min(lon1)),max(max(lon1))/)
  rang_lat = (/min(min(lat1)),max(max(lat1))/)
  lon1@units="degrees_east"
  lat1@units="degrees_north"

;--------------------------------------------
 drawname = expmb*1000*48/22.4
 drawname@lon2d = lon1
 drawname@lat2d = lat1
 RIGHTS = "PHYSICAL_O3 12:00"
;****************************************************************************
   plot=new(1,graphic)
   poli=new(1,graphic)
   wks = gsn_open_wks("x11","phyo3_05")             ; open a pdf file
   colors1= (/"white","black","White","Grey","RoyalBlue","LightSkyBlue",\
          "lightseagreen","PaleGreen","Gold","Khaki","LightSalmon","red"/)
   colors4= ("wh-bl-gr-ye-re")
   colors5= ("precip3_16lev")
   colors6= ("BlueGreen14")
   colors7= ("WhBlGrYeRe")
   colors8=("BlAqGrYeOrRe")
;   gsn_define_colormap(wks,colors7)  ; choose color map
   gsn_define_colormap(wks,"GreenMagenta16")
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
   res@cnFillColors         = (/2,3,4,5,6,7,9,11,12,13,14,15,16/)
   res@cnLevels            = (/-30,-20,-10,-5,-2,0,50,70,100,150,200/)
;  res@cnFillColors         = (/10,11,12,13,14,15/)
   res@lbOrientation         = "Vertical"                 ; vertical label bar
   res@lbLabelBarOn          = True
   res@lbBoxLinesOn          = True
   res@gsnAddCyclic          = False                      ; regional data: not cyclic
   res@tfDoNDCOverlay        = True                       ; set True for native projection
   res@gsnMaximize           = True                      ; uncomment to maximize size
   res@lbLabelFontHeightF      =0.02

   res@gsnFrame  = False
   res@gsnDraw   = False
   latlon = asciiread("./diqujie.txt",(/31629,2/),"float")
   lon2 = latlon(:,0)
   lat2 = latlon(:,1)
   resp = True
   resp@gsLineColor = "black"
   resp@gsLineThicknessF = 2

   plot = gsn_csm_contour_map(wks,drawname,res)                 ; Call the gsn_csm function for
                                                          ; drawing contours over a map.
   poli = gsn_add_polyline(wks,plot,lon2,lat2,resp)

   overlay(plot,poli)


   draw(plot)                                  ; draw the temperature plot (with the U-wind plot overlaid)
   frame(wks)    
;-----------------------------------------------
end
