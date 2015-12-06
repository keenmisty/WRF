; Written by Ziqiang Jiang in Dec. 2010
; Atmosphere Environment Research Center (AERC)
; School of Atmospheric Sciences, Nanjing University

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;load "$HOME/ees2/weihua/ncl/share/gsn_geom.ncl"
load "$HOME/ees2/shenchong/draw/ncl/share/gsn_geom.ncl"
begin

   ; Open the data file
 d2 = addfile ("/ees/users/EMG/liao/WRFV3/test/urb_7/wrfinput_d02"+".nc", "r")
;   dir = "/ees/users/EMG/ees2/weihua/WRF/3.1.1/WRFV3/test/rain0514-1/case1-kf/"
;   fnm = systemfunc ("ls "+dir+"wrfinput_d02")+".nc"
;   print(d2)
;   d1 = addfile(fnm(0),"r")
 ;  d2 = addfile(fnm(1),"r")
   ;d3 = addfile(fnm(2),"r")

   ; Open graphics file
   wks  = gsn_open_wks("png","sc7sites1")   ; Set some basic contouring resources
   res =True
   res@gsnDraw         = False                ; Don't draw plot (will do later)
   res@gsnFrame        = False                ; Don't advance framce  (will do later)
   res@gsnMaximize     = True                 ; Maximize plot in frame
   res@cnInfoLabelOn   = False
   res@cnFillOn        = True
   res@cnFillMode      = "AreaFill" 
   res@cnLevelSelectionMode = "ExplicitLevels"
   res@cnLevels             = (/10,50,100,200,500,800,1000,1200,1500/)
   gsn_define_colormap(wks,"perc2_9lev")
   res@cnLinesOn            = False
   res@cnLineLabelsOn       = False
   res@lbTitleString        ="Terrain Height (m)"
   res@lbTitleFontHeightF   = 0.015
 ;  res@lbLabelDirection     ="vertical"
;   res@lbTitlePosition  = "Right"  

   ; Read terrain height for each dataset
 ;  d1hgt = d1->HGT(0,:,:)       ; Coarse dataset
   d2hgt = d2->HGT(0,:,:)       ; Finer resolution
  ; d3hgt = d3->HGT(0,:,:)       ; Finest resolution
;   d1hgt@description =""
;   d1hgt@units =""
   d2hgt@description =""
   d2hgt@units =""
  ; d3hgt@description =""
  ; d3hgt@units =""

   ; Read lat/lon coordinates for each dataset
  ; d1lat = d1->XLAT(0,:,:)
  ; d1lon = d1->XLONG(0,:,:)
   d2lat = d2->XLAT(0,:,:)
   d2lon = d2->XLONG(0,:,:)
  ; d3lat = d3->XLAT(0,:,:)
  ; d3lon = d3->XLONG(0,:,:)

   ; Special method for setting 2D lat/lon coords
 ;  d1hgt@lat2d = d1lat    
 ;  d1hgt@lon2d = d1lon
   d2hgt@lat2d = d2lat    
   d2hgt@lon2d = d2lon
  ; d3hgt@lat2d = d3lat    
  ; d3hgt@lon2d = d3lon

 ;  dims = dimsizes(d1hgt)
  ; d1ny = dims(0)-1
 ;  d1nx = dims(1)-1
   dims = dimsizes(d2hgt)
   d2ny = dims(0)-1
   d2nx = dims(1)-1
;   dims = dimsizes(d3hgt)
  ; d3ny = dims(0)-1
  ; d3nx = dims(1)-1

   ; Create 1st set of contours (coarsest resolution) over a map
   opts = res 
   opts@tfDoNDCOverlay        = True
   opts@mpProjection          = "LambertConformal"
;  opts@mpDataBaseVersion     = "MediumRes"
;  opts@mpDataSetName         = "Earth..4"
   opts@mpLimitMode           = "Corners"           
   opts@mpLeftCornerLatF      = d2lat(0,0)       
   opts@mpLeftCornerLonF      = d2lon(0,0)
   opts@mpRightCornerLatF     = d2lat(d2ny,d2nx)
   opts@mpRightCornerLonF     = d2lon(d2ny,d2nx)
   opts@mpLambertParallel1F   = 30.
   opts@mpLambertParallel2F   = 60.
   opts@mpLambertMeridianF    = (max(d2lon)+min(d2lon))/2
;  opts@mpOutlineBoundarySets = "NoBoundaries"
   opts@mpGridAndLimbOn       = True
   opts@mpGridSpacingF        = 1.           
   opts@mpGridLineColor       = "Gray12"
   opts@mpGridLineDashPattern = 11	; 2
   opts@pmTickMarkDisplayMode = "Always"
   opts@pmLabelBarHeightF     = 0.065
   plot = gsn_csm_contour_map(wks,d2hgt,opts)


  ;read site's name and lon&lat
  ;station = asciiread("./15sites1.txt",(/15,3/),"string")
  site_lonlat = asciiread("./7siteslonlat.txt",(/7,2/),"float")
  site_lon = site_lonlat(:,0)
  site_lat = site_lonlat(:,1)
  site_name=(/"GZ","DG","ZS","SZ","ZH","FS","HZ"/)
  
  ;add markers to the plot
  mkres               = True
  mkres@gsMarkerIndex = 1
  mkres@gsMarkerColor = 11
  mkres@gsMarkerSizeF = 33.        ; Increase marker sizes
;  gsn_polymarker(wks,plot,site_lon,site_lat,mkres)
  
  ;add site's name to the plot
  ress                      = True                ; text mods desired
  ress@txFontHeightF        = 0.020               ; make smaller
  ress@txFontThicknessF     = 5.0
  ress@txFont        = "helvetica-bold"
  ress@txFontColor =11

  ; read txt's lon&lat
  site_lonlat1=asciiread("./7sitestxtlonlat.txt",(/7,2/),"float")
  site_lon1 = site_lonlat1(:,0)
  site_lat1 = site_lonlat1(:,1)
 
  do i=0,6
   text=gsn_add_text(wks,plot,site_name(i),site_lon1(i)+0.0,site_lat1(i)+0.0,ress)
  end do

  ;add diqujie&shengjie lines
   latlon = asciiread("$HOME/ees2/weihua/ncl/share/diqujie.txt",(/31629,2/),"float")
   lon2 = latlon(:,0)
   lat2 = latlon(:,1)
   resp = True
   resp@gsLineColor = "black"
   resp@gsLineThicknessF = 1.5
   poli=  gsn_add_polyline(wks,plot,lon2,lat2,resp)

   latlon1 = asciiread("$HOME/ees2/weihua/ncl/share/shengjie.txt",(/82750,2/),"float")
   lon3 = latlon1(:,0)
   lat3 = latlon1(:,1)
   poli1 = gsn_add_polyline(wks,plot,lon3,lat3,resp)

   overlay(plot,poli)
   overlay(plot,poli1)

   ; Now advance the frame
   draw(plot)
   gsn_polymarker(wks,plot,site_lon,site_lat,mkres) 
   frame(wks)

end
