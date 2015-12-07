load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin
 
  n = 10*365*48+3*48
  print(n)
  ;data_obs = asciiread("./data/forc0.dat",(/n,12/),"float")
  data_obs = asciiread("./data/forc1.dat",(/n,13/),"float")
  ;data_obs = asciiread("./forcings.dat",(/n,9/),"float")

  x = new(n,float)  ; Define two 1D arrays of 12 elements each.
  do i = 0,n-1
  x(i) = i*1.
  end do

  var =new((/8,n/),float)
  do iv = 0,7
  var(iv,:) = data_obs(:,iv+5)
  end do

  ;var =new((/8,n/),float)
  ;do iv = 0,7
  ;var(iv,:) = data_obs(:,iv+1)
  ;end do

  ;var = mask(var, (var .gt. -6999.), True)

  wks = gsn_open_wks("pdf","runoff")  ; Open an X11 workstation.

  cmap = (/(/1.00,1.00,1.00/),(/0.00,0.00,0.00/),(/0.,0.,0./),\
            (/1.0,0.0,0.0/),\  ; Red
            (/0.0,0.6,0.0/),\  ; Green
            (/0.0,0.0,1.0/),\  ; Blue
            (/0.0,0.0,0.0/),\  ; Black
            (/0.6,0.6,0.6/)/)  ; Black

  gsn_define_colormap(wks,cmap)

  res                        = True

;  res@tiMainString           = "snow"
  res@tiXAxisFont     = 21        ; Change the font size.
  res@tiYAxisFont     = 21 
  res@tiXAxisFontHeightF     = 0.011       ; Change the font size.
  res@tiYAxisFontHeightF     = 0.011
; ------------------- X- axis ----------------------------------------------------
;   res@tmXTBorderOn           = False     ; Don't draw top axis.
;    res@tmXTOn                 = False     ; Don't draw top axis tick marks.
    res@tmBorderThicknessF     = 1.0       ; Default thickness is 2.0
    res@tmXBLabelFont          = 21        ; Change font and size of 
    res@tmXBLabelFontHeightF   = 0.01     ; X axis labels.
    res@tmXBMajorLengthF       = 0.006     ; Default is 0.02.
    res@tmXBMajorThicknessF    = 1.0       ; Default is 2.
    res@tmXBMinorLengthF       = 0.0075    ; Default is 0.01.
    res@tmXBMinorPerMajor      = 0         ; # of minor tick marks per major.
    res@tmXBMode               = "Manual"  ; Set tick mark mode.
    res@tmXBTickStartF         = 0
    res@tmXBTickEndF           = n
    res@tmXBTickSpacingF       = n/10
    res@tmXMajorGridThicknessF = 1.0       ; Default is 2.0
; ------------------- Y- axis ----------------------------------------------------
   res@tmYLLabelFont          = 21        ; See explanations for X axes
   res@tmYLLabelFontHeightF   = 0.01     ; res.
   res@tmYLMajorLengthF       = 0.006
   res@tmYLMajorThicknessF    = 1.0
   res@tmYLMinorPerMajor      = 0
  res@tmYLMode               = "Manual"
  res@tmYLTickStartF         = -12000.0
  res@tmYLTickEndF           = 12000.
;   res@tmYRBorderOn           = False    ; Don't draw right axis.
;   res@tmYROn                 = False    ; Don't draw right axis tick marks.
; ---------------------- line ---------------------------------------------------
  res@xyLineColors           = (/3,4,5,6/)     ; Set the line colors.
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0/)  
  res@xyDashPatterns         = (/0,0,0,1,0/) ; 0- solid, 1-dash.

; ------------------ for tick ---------------------------------------------------
;  res@pmTickMarkDisplayMode = "Always"
;  res@pmTickMarkZone        = 2
; --------------for legend ------------------------------------------------------ 
   res@lgLabelsOn = True
   res@lgAutoManage = False
   res@lgLabelFontHeightF = 0.01
   res@lgBoxMajorExtentF = 0.08
   res@lgBoxMinorExtentF = 0.08
   res@pmLegendOrthogonalPosF = -0.45
   res@pmLegendParallelPosF   = 0.15
   res@pmLegendHeightF        = 0.05
;--------------------------------------------------------------------------
  res@gsnFrame = False ; Don't advance frame.
; --------------------- marker ----------------------------------------------------
    res@xyMarkerColors   =(/7,5,5,5,5/)            ; Marker color
    res@xyMarkers       = (/5,4,7,7,7/)   ; 
           ;  4 - circle,  5- corss , 6-square ,7 - triangle
           ;  0 - none  ,  1- dot   , 2 - plus ,3 - asterisk
           ;  9 - lingxi,  12 -star , 14 - dotted cirle , 16 - full cirlce
    res@xyMarkerSizeF   = 0.002        ; Marker size (default 
                                            ; is 0.01)
; --------------------- Label line------------------------------------------------------
; -------------------- Date Range --------------------------------------------------
;  res@tiYAxisString          = " Runoff (mm d:S:-1:N:)"
;  res@xyMarkLineModes = (/"Markers","Lines","Lines","Lines"/)
  res@xyMarkLineModes = (/"Lines","Lines","Lines","Lines"/)
;================================================================================
  res@trXMinF        = 1
  res@trXMaxF        = n ;17520

   res@vpXF      = 0.08    ; Change the size and location of the
   res@vpWidthF  = 0.9
   res@vpHeightF = 0.10

;  res@tmYLTickSpacingF       = 3.
; res@pmLegendDisplayMode    = "Never"
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
 res@xyExplicitLabels = (/"Obs","Model"/)
;================================================================================
  res@vpYF      = 0.99     ; plot on the viewport.
  res@tiYAxisString          = "SW (W/m2)"
;  res@trYMinF        = -10.
;  res@trYMaxF        = 1200.
  map = gsn_xy(wks,x,var(0,:),res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.87     ; plot on the viewport.
  res@tiYAxisString          = "LW (W/m2)"
;  res@trYMinF        = 100.
;  res@trYMaxF        = 400.
  map = gsn_xy(wks,x,var(1,:),res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.75     ; plot on the viewport.
  res@tiYAxisString          = "Prec (mm)"
  map = gsn_xy(wks,x,var(2,:),res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.63     ; plot on the viewport.
  res@tiYAxisString          = "Ta (C)"
  map = gsn_xy(wks,x,var(3,:),res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.51     ; plot on the viewport.
  res@tiYAxisString          = "Wind (m/s)"
  map = gsn_xy(wks,x,var(4,:),res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.39     ; plot on the viewport.
  res@tiYAxisString          = "Press (Pa)"
  map = gsn_xy(wks,x,var(5,:),res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.27     ; plot on the viewport.
  res@tiYAxisString          = "rh (%)"
  map = gsn_xy(wks,x,var(6,:),res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.15     ; plot on the viewport.
  res@tiYAxisString          = "CO2 (ppm)"
  map = gsn_xy(wks,x,var(7,:),res) ; Draw an XY plot with 2 curves.
;================================================================================
; frame(wks)   ; Advance the frame.
; res@gsnFrame = False ; Don't advance frame.
; delete(res@tiXAxisString)
;================================================================================
;  res@vpYF      = 0.99     ; plot on the viewport.
; res@tiYAxisString          = "Soil L1 ice (m3/m3)"
; map = gsn_xy(wks,x,sice1,res) ; Draw an XY plot with 2 curves.
;================================================================================

   txres = True
   txres@txFontHeightF = 0.011
   txres@txFuncCode    = "~"          ; Default is ":"
;   gsn_text_ndc(wks,"Number of days from Nov. 1, 1969",0.5,0.64,txres)
;   gsn_text_ndc(wks,"a",0.96,0.98,txres)
;   gsn_text_ndc(wks,"b",0.96,0.81,txres)

;   gsn_text_ndc(wks,"(c)",0.96,0.56,txres)
;   gsn_text_ndc(wks,"ME=0.442",0.14,0.97,txres)
;   gsn_text_ndc(wks,"ME=0.816",0.14,0.76,txres)
;   gsn_text_ndc(wks,"ME=0.816",0.14,0.55,txres)

  frame(wks)   ; Advance the frame.
end
