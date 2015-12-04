;********************************************
; h_long_5.ncl
;********************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;********************************************
begin
   f0     = addfile ("/ees/users/EMG/shenchong/paper/urban/megan/WRFV3-basexin2/test/test-xin/wrfout_d01_2009-10-31_00:00:00.nc" , "r")   
;  f0     = addfile ("/ees/users/EMG/ees2/shenchong/urban/WRFV3-UCM/test/em_real/wrfout_d01_2009-11-01_00:00:00.nc" , "r")   
;  f0     = addfile ("/ees/users/EMG/ees2/shenchong/urban/WRFV3-UCMnoah/test/em_real/wrfout_d01_2009-11-01_00:00:00.nc" , "r") 
;  f0     = addfile ("/ees/users/EMG/ees2/shenchong/urban/WRFV3-BEP/test/em_real/wrfout_d01_2009-11-01_00:00:00.nc" , "r") 
   lon1=f0->XLONG(0,0,:)
   lat1=f0->XLAT(0,:,0)
   qr  =f0->o3(144:154,0:22,:,:)
   p  =f0->P(144:154,0:22,:,:)
   pb =f0->PB(144:154,0:22,:,:)
   printVarSummary(qr)
  ;latitude
   lat1!0     = "lat"
   lat1&lat   =  lat1
   lat1@units = "degrees_north"
  ;longitude
   lon1!0     = "lon"
   lon1&lon   =  lon1
   lon1@units = "degrees_east"
   qr!2 = "lat"
   qr!3 = "lon"
   qr&lat  =  lat1
   qr&lon  =  lon1
   qrtime = qr(:,0:22,{23},{111.5:115.5})
;pressure
   p_total = (p+pb)*0.01
   p_total!2 = "lat"
   p_total!3 = "lon"
   p_total&lat  =  lat1
   p_total&lon  =  lon1
   p_time = p_total(:,0:22,:,:)
   temp     = dim_avg_n(p_total,0)
   temp1    = dim_avg_n(temp,1)
   pres     = dim_avg_n(temp1,1)
   pres@units = "mb"
    printVarSummary(pres) 
;  caculate average 
   qrmean = dim_avg_n(qrtime,0)
;  qrmean = dim_avg_n(temp2,0)
   printVarSummary(qrmean)

   qrplot   = 1000*48*qrmean/22.4
   qrplot!0 = "lev"
   qrplot!1 = "lon"
   qrplot&lon = lon1({111.5:115.5})
   qrplot&lev = pres
   qrplot@units = "ug/m3"
   printVarSummary(qrplot)
   print(max(qrplot))
   print(min(qrplot))

;   a = ispan(111,115,1)
;   b = (/111,112,113,114,115/)

; ===========================
; color plot
; ===========================
  wks   = gsn_open_wks ("png", "o3_hightdayxin" )           ; open workstation
  gsn_define_colormap(wks,"BlWhRe")                ; choose colormap
  
  res                      = True                  ; plot mods desired
   res@vpXF = 0.15                    ;top
   res@vpYF = 0.7                     ;left
   res@vpWidthF  = 0.65              ; height and width of plot
   res@vpHeightF = 0.45
  res@gsnLeftString        = "O3 DAYTIME"        ; title
  res@cnLineLabelsOn       = False                  ; turn on line labels
  res@cnFillOn             = True                  ; turn on color fill
  res@cnLinesOn            = True                 ; no contour lines
  res@gsnSpreadColors      = False                  ; use full range of color
  
  res@lbLabelAutoStride    = True                  ; optimal labels
  res@lbOrientation        = "vertical"
  res@lbLabelPosition      ="Right"
  res@pmLabelBarOrthogonalPosF = 0.1    ; set label bar offset  (for horizontal label bar)
  res@pmLabelBarWidthF       =0.07
  res@pmLabelBarHeightF      =0.45
  
  res@tmYLMode          = "Explicit"
  res@tmYLValues        = ispan(950,50,100)
  res@tmYLLabels        = (/950,850,750,650,550,450,350,250,150,50/)
  res@tiYAxisString     = "Pressure (mb)"      ; y-axis label
;  res@tiXAxisString     = "Longitude (Degs)"
  res@tiXAxisFontHeightF =0.02
  res@tiYAxisFontHeightF =0.02
   res@gsnLeftStringFontHeightF    =   0.02
   res@gsnRightStringFontHeightF   =   0.02
;    res@tiMainFont          ="helvetica-bold"             ; and the font type
     res@tiXAxisFont         ="helvetica-bold"
;    res@tiYAxisFont         ="helvetica-bold"
   res@tmYRTickSpacingF     = 1.0

   res@tmXBMode             = "Explicit"
 
   res@tmXBValues = ispan(112,115,1)
   res@tmXBLabels = ispan(112,115,1)+"E" 
   res@cnLevelSelectionMode = "ExplicitLevels"
; res@cnLevels = (/-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6/)
  res@cnFillColors  = (/52,57,62,67,72,77,82,87/)

  res@cnLevels = (/50,70,100,130,160,200,250/)
;  res@cnFillColors  = (/52,54,57,60,63,65,67,70,75,77,79,82,85,87/)
; note this data is already on pressure levels. If this were model data,
; it would be necessary to interpolate the data from hybrid coordinates
; to pressure levels.

  plot = gsn_csm_pres_hgt(wks,qrplot(:,:),res)
  
; the "{}" allows you to use coordinate subscripting to select a particular 
; latitude vice array indice of the latitude you want. 
  end

