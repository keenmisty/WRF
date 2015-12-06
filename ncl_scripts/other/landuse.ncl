load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"    

begin
;  f0=addfile("/ees/users/EMG/chang/wrf/WPS/geo_em.d03.nc","r")
;  lon=f0->XLONG(0,:,:)
;  lat=f0->XLAT(0,:,:)
  f0=addfile("./glc2793/geo_em.d03.nc","r")
;   f0=addfile("/ees/users/EMG/zhiyong/wrfchem/3.4.1/WPS2/met_em.d01.2010-06-30_12:00:00.nc","r")
  lon=f0->XLONG_M(0,:,:)
  lat=f0->XLAT_M(0,:,:)
  lu=f0->LU_INDEX(0,:,:)
  lu@description = ""
  lu@units = ""
  printVarSummary(lon)
  printVarSummary(lat)
  printVarSummary(lu)

  info     = (/ " 1  Urban and Built-Up        ", \  ; n=0
                " 2  Dryland Cropland&Pasture  ", \
                " 3  Irrigated Cropland&Pasture", \
                " 4  Mixed Cropland and Pasture", \
                " 5  Cropland/Grassland Mosaic ", \
                " 6  Cropland/Woodland Mosaic  ", \
                " 7  Grassland                 ", \
                " 8  Shrubland                 ", \
                " 9  Mixed Shrubland/Grassland ", \
                "10  Savanna                   ", \
                "11  Deciduous Broadleaf       ", \
                "12  Deciduous Needleleaf      ", \
                "13  Evergreen Broadleaf       ", \
                "14  Evergreen Needleleaf      ", \
                "15  Mixed Forest              ", \
                "16  Water Bodies              ", \
                "17  Herbaceous Wetland        ", \
                "18  Wooded Wetland            ", \
                "19  Barren/Sparsely Vegetated ", \
                "20  Herbaceous Tundra         ", \
                "21  Wooded Tundra             ", \
                "22  Mixed Tundra              ", \
                "23  Bare Ground Tundra        ", \
                "24  Snow or Ice               "  /) ; n=23
colors     = (/ "white","black","purple", \  ; n=0
"coral", \      ;2
"coral2", \     ;3
"chocolate1", \ ;4
"lightgoldenrod1", \    ;5
"chocolate4", \         ;6
"darkolivegreen2", \                            ;7
"darkolivegreen1", \    ;8
"greenyellow", \                ;9
"darkolivegreen3", \
"green2", \
"darkkhaki", \
"darkolivegreen", \
"darkgreen", \
"limegreen", \
"blue", \ ; water; deepskyblue2
"orange1", \
"orange3", \
"gold1", \
"lightslategrey", \
"lightsteelblue2", \
"lightsteelblue1", \
"lightyellow3", \
"lightyellow1"  /) ; n=23

;************************************************
; create plot
;************************************************

  wks = gsn_open_wks("ps","anduse")  

 ;colors = gsn_retrieve_colormap(wks)     ; retrieve color map for editing
 ;colors(2,:) = (/ 1.0, 1.0, 1.0 /)       ; replace 1st contour color with background
 gsn_define_colormap(wks,colors)     

  res                  = True               ; plot mods desired
  res@gsnDraw          = False
  res@gsnFrame         = False
  res@gsnMaximize      = True 
  res@gsnAddCyclic     = False              ; Don't add a cyclic point, important-zhiyong
  res@cnFillOn         = True               ; color Fill 
  res@cnFillMode       = "RasterFill"       ; Raster Mode
  res@cnLinesOn        = False              ; Turn off contour lines

  res@cnLevelSelectionMode = "ExplicitLevels" ; set explict contour levels
  res@cnLevels         = integertobyte( ispan(2,24,1) )

  res@lbLabelPosition  = "Center"           ; label position
  res@lbLabelAlignment = "BoxCenters"       ; label orientation
  res@lbLabelStrings   = ispan(1,24,1)  

  res@pmLabelBarOrthogonalPosF = -0.08    ; move up smidge
  res@pmTickMarkDisplayMode = "Always"
 
  res@tmXBMode = "Automatic"
  res@tmYLMode = "Automatic"
  res@tmXTLabelsOn = False
  res@tmYRLabelsOn = False
  res@tmXTMajorLineColor  = 0
  res@tmYRMajorLineColor  = 0
 ; res@tmLabelAutoStride = True

  res@mpCenterLonF     = 0                  ; set map center
  res@mpFillOn         = False
  res@mpOutlineOn      = False              ; set default boundaries
  res@tfDoNDCOverlay   = True
;  res@mpLimitMode       = "LatLon"        ; method to zoom
  res@mpProjection      = "LambertConformal"
  res@mpLambertParallel1F = 30.0
  res@mpLambertParallel2F = 60.0
  res@mpLambertMeridianF  = 113.0        ; central meridian
  res@mpLimitMode         = "LatLon"
;  res@mpMinLatF           = min(lat)        ; map area
;  res@mpMaxLatF           = max(lat)         ; latitudes
;  res@mpMinLonF           = min(lon)       ; and
;  res@mpMaxLonF           = max(lon)        ; longitudes
;  res@mpLeftCornerLatF  = min(lat)
;  res@mpLeftCornerLonF  = min(lon)
;  res@mpRightCornerLatF = max(lat)
;  res@mpRightCornerLonF = max(lon)

  res@sfXArray =lon
  res@sfYArray =lat
  
  res@mpMinLatF =  min(lat)
  res@mpMaxLatF =  max(lat)
  res@mpMinLonF =  min(lon)
  res@mpMaxLonF =  max(lon)
  
  res@tmXBMode = "Automatic"
  res@tmYLMode = "Automatic"
  res@tmXBLabelFontHeightF  = 0.01 

;  plot = gsn_csm_contour_map_ce(wks, lu, res) ; create plot
   plot = gsn_csm_contour_map(wks, lu, res)

;
;add text 
;
  rtxt = True
  rtxt@txJust        = "CenterLeft"
  rtxt@txFontHeightF = 0.011

                            ; 4 rows x 6 columns of text
  n  = -1
  xx = 0.05   
  do ncol=0,3
     yy = 0.15 
    do nrow=0,5
       n = n+1
       gsn_text_ndc (wks,info(n),xx,yy,rtxt)
       yy = yy - 1.5*rtxt@txFontHeightF
    end do
     xx = xx + 0.24 
  end do

;
;add boundaries
;
  lonlat = asciiread("/ees/users/EMG/zhiyong/ncl/shengjie.dat",(/82750,2/),"float")
  resp = True
  resp@gsLineColor = "black"
  resp@gsLineThicknessF = 1.5
  polbou = gsn_add_polyline(wks,plot,lonlat(:,0),lonlat(:,1),resp)
  delete(lonlat)
  delete(resp)

  lonlat = asciiread("/ees/users/EMG/zhiyong/ncl/diqujie.dat",(/32149,2/),"float")
  resp = True
  resp@gsLineColor = "black"
  resp@gsLineThicknessF = 1.5
  polbou2 = gsn_add_polyline(wks,plot,lonlat(:,0),lonlat(:,1),resp)
  delete(lonlat)
  delete(resp)

  lonlat = asciiread("/ees/users/EMG/zhiyong/ncl/prd_boundary.dat",(/2626,2/),"float")
  resp = True
  resp@gsLineColor = "black"
  resp@gsLineThicknessF = 3
  polbou3 = gsn_add_polyline(wks,plot,lonlat(:,0),lonlat(:,1),resp)
  delete(lonlat)
  delete(resp)

  draw(plot)
  frame(wks)

;---------------------------------------------------------------------
; pure land/sea mask
;---------------------------------------------------------------------
;  y = lu                                     ; land sea mask
;  y = where (y.eq.integertobyte(16), integertobyte(0), integertobyte(1))
;  y = where (y.eq.17, 0, 1)                 ; this works too!

;  delete(res)

;  res                  = True                ; plot mods desired
;  res@gsnMaximize      = True 
;  res@gsnAddCyclic    = False

;  res@cnFillOn         = True               ; color Fill 
;  res@cnFillMode       = "RasterFill"       ; Raster Mode
;  res@cnLinesOn        =  False             ; Turn off contour lines

;  res@cnLevelSelectionMode = "ExplicitLevels" ; set explict contour levels
;  res@cnLevels         = (/1/)

;  res@lbLabelPosition  = "Center"           ; label position
;  res@lbLabelAlignment = "BoxCenters"       ; label orientation
;  res@lbLabelStrings   = (/ "0", "1"/)

;  res@mpCenterLonF     = 0                  ; set map center at 180
;  res@mpFillOn         = False

;  res@sfXArray =lon
;  res@sfYArray =lat

;  res@mpMinLatF = min(lat)
;  res@mpMaxLatF = max(lat)
;  res@mpMinLonF = min(lon)
;  res@mpMaxLonF = max(lon)

;  res@gsnLeftString  = "CERES: Pure Land-Sea Mask"

;  plot = gsn_csm_contour_map_ce(wks, y, res) ; create plot
;   plot = gsn_csm_contour_map(wks, y, res)
end
