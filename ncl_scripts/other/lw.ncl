load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin
 
  n = 70128
  data_obs = asciiread("./fort.11",(/n,4/),"float")
  x = new(n,float)  ; Define two 1D arrays of 12 elements each.
  do i=0,n-1
  x(i) = i*1.
  end do

  lw =new((/3,n/),float)
  lw(0,:) = data_obs(:,1)  ;obs
  lw(1,:) = data_obs(:,2)  ;model
  lw(2,:) = data_obs(:,3)  ;model
  ;lw(0,:) = mask(lw(0,:), (lw(0,:) .ne. -9999.), True)
  ;lw(1,:) = mask(lw(1,:), (lw(0,:) .ne. -9999.), True)

  wks = gsn_open_wks("pdf","runoff")  ; Open an X11 workstation.

  cmap = (/(/1.00,1.00,1.00/),(/0.00,0.00,0.00/),(/0.,0.,0./),\
            (/1.0,0.0,0.0/),\  ; Red
            (/0.0,0.6,0.0/),\  ; Green
            (/0.0,0.0,1.0/),\  ; Blue
            (/0.0,0.0,0.0/),\  ; Black
            (/0.6,0.6,0.6/)/)  ; Black

  gsn_define_colormap(wks,cmap)

  resources                        = True

;  resources@tiMainString           = "snow"
  resources@tiXAxisFont     = 21        ; Change the font size.
  resources@tiYAxisFont     = 21 
  resources@tiXAxisFontHeightF     = 0.011       ; Change the font size.
  resources@tiYAxisFontHeightF     = 0.011
; ------------------- X- axis ----------------------------------------------------
;   resources@tmXTBorderOn           = False     ; Don't draw top axis.
;    resources@tmXTOn                 = False     ; Don't draw top axis tick marks.
    resources@tmBorderThicknessF     = 1.0       ; Default thickness is 2.0
    resources@tmXBLabelFont          = 21        ; Change font and size of 
    resources@tmXBLabelFontHeightF   = 0.01     ; X axis labels.
    resources@tmXBMajorLengthF       = 0.006     ; Default is 0.02.
    resources@tmXBMajorThicknessF    = 1.0       ; Default is 2.
    resources@tmXBMinorLengthF       = 0.0075    ; Default is 0.01.
    resources@tmXBMinorPerMajor      = 0         ; # of minor tick marks per major.
    resources@tmXBMode               = "Manual"  ; Set tick mark mode.
    resources@tmXBTickStartF         = 0
    resources@tmXBTickEndF           = n
    resources@tmXBTickSpacingF       = n/12
    resources@tmXMajorGridThicknessF = 1.0       ; Default is 2.0
; ------------------- Y- axis ----------------------------------------------------
   resources@tmYLLabelFont          = 21        ; See explanations for X axes
   resources@tmYLLabelFontHeightF   = 0.01     ; resources.
   resources@tmYLMajorLengthF       = 0.006
   resources@tmYLMajorThicknessF    = 1.0
   resources@tmYLMinorPerMajor      = 0
  resources@tmYLMode               = "Manual"
  resources@tmYLTickStartF         = -12000.0
  resources@tmYLTickEndF           = 12000.
;   resources@tmYRBorderOn           = False    ; Don't draw right axis.
;   resources@tmYROn                 = False    ; Don't draw right axis tick marks.
; ---------------------- line ---------------------------------------------------
  resources@xyLineColors           = (/3,4,5,6/)     ; Set the line colors.
  resources@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0/)  
  resources@xyDashPatterns         = (/0,0,0,1,0/) ; 0- solid, 1-dash.

; ------------------ for tick ---------------------------------------------------
;  resources@pmTickMarkDisplayMode = "Always"
;  resources@pmTickMarkZone        = 2
; --------------for legend ------------------------------------------------------ 
   resources@lgLabelsOn = True
   resources@lgAutoManage = False
   resources@lgLabelFontHeightF = 0.01
   resources@lgBoxMajorExtentF = 0.08
   resources@lgBoxMinorExtentF = 0.08
   resources@pmLegendOrthogonalPosF = -0.45
   resources@pmLegendParallelPosF   = 0.15
   resources@pmLegendHeightF        = 0.05
;--------------------------------------------------------------------------
  resources@gsnFrame = False ; Don't advance frame.
; --------------------- marker ----------------------------------------------------
    resources@xyMarkerColors   =(/7,5,5,5,5/)            ; Marker color
    resources@xyMarkers       = (/5,4,7,7,7/)   ; 
           ;  4 - circle,  5- corss , 6-square ,7 - triangle
           ;  0 - none  ,  1- dot   , 2 - plus ,3 - asterisk
           ;  9 - lingxi,  12 -star , 14 - dotted cirle , 16 - full cirlce
    resources@xyMarkerSizeF   = 0.002        ; Marker size (default 
                                            ; is 0.01)
; --------------------- Label line------------------------------------------------------
; -------------------- Date Range --------------------------------------------------
;  resources@tiYAxisString          = " Runoff (mm d:S:-1:N:)"
;  resources@xyMarkLineModes = (/"Markers","Lines","Lines","Lines"/)
  resources@xyMarkLineModes = (/"Lines","Lines","Lines","Lines"/)
;================================================================================
  resources@trXMinF        =1 ;55560
  resources@trXMaxF        =n ;58000

   resources@vpXF      = 0.08    ; Change the size and location of the
   resources@vpWidthF  = 0.9
   resources@vpHeightF = 0.4

;  resources@tmYLTickSpacingF       = 3.
 resources@pmLegendDisplayMode    = "Always"
 resources@xyExplicitLabels = (/"Obs","Model","DLW"/)
;================================================================================
  resources@vpYF      = 0.99     ; plot on the viewport.
  resources@tiYAxisString          = "LW (W/m2)"
  resources@tmYLTickSpacingF       = 20.
  resources@trYMinF        = 0.
  resources@trYMaxF        = 400.
  map = gsn_xy(wks,x,lw,resources) ; Draw an XY plot with 2 curves.
;================================================================================
  resources@vpWidthF  = 0.4
  resources@vpHeightF = 0.4
  resources@vpYF      = 0.49     ; plot on the viewport.
  resources@xyMarkLineModes = (/"Markers","Lines","Lines","Lines"/)
  resources@tmXBTickSpacingF       = 100
  resources@trYMinF        = 100.
  resources@trYMaxF        = 400.
  resources@trXMinF        = 100
  resources@trXMaxF        = 400
  resources@tiYAxisString          = "Model LW (W/m2)"
  resources@tiXAxisString          = "Obs LW (W/m2)"
  map = gsn_xy(wks,lw(0,:),lw(1,:),resources) ; Draw an XY plot with 2 curves.
;================================================================================
; frame(wks)   ; Advance the frame.
; resources@gsnFrame = False ; Don't advance frame.
; delete(resources@tiXAxisString)
;================================================================================
;  resources@vpYF      = 0.99     ; plot on the viewport.
; resources@tiYAxisString          = "Soil L1 ice (m3/m3)"
; map = gsn_xy(wks,x,sice1,resources) ; Draw an XY plot with 2 curves.
;================================================================================

   txresources = True
   txresources@txFontHeightF = 0.011
   txresources@txFuncCode    = "~"          ; Default is ":"
;   gsn_text_ndc(wks,"Number of days from Nov. 1, 1969",0.5,0.64,txresources)
;   gsn_text_ndc(wks,"a",0.96,0.98,txresources)
;   gsn_text_ndc(wks,"b",0.96,0.81,txresources)

;   gsn_text_ndc(wks,"(c)",0.96,0.56,txresources)
;   gsn_text_ndc(wks,"ME=0.442",0.14,0.97,txresources)
;   gsn_text_ndc(wks,"ME=0.816",0.14,0.76,txresources)
;   gsn_text_ndc(wks,"ME=0.816",0.14,0.55,txresources)

  frame(wks)   ; Advance the frame.
end
