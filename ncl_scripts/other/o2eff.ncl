load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin
 
  n = 365*1*48
  data1 = asciiread("../../Run/fort.89.4C",(/n,5/),"float")
  data2 = asciiread("../../Run/fort.89",(/n,5/),"float")

;  write(89,*) soil_o2,soil_o2/(kmupo2+soil_o2),up_rate,resp,mic

  x = new(n,float) 
  do i=0,n-1
  x(i) = i*1.
  end do

  o2 =new((/2,n/),float)
  o2(0,:) = data1(:,0)
  o2(1,:) = data2(:,0)

  ro2 =new((/2,n/),float)
  ro2(0,:) = data1(:,1)
  ro2(1,:) = data2(:,1)

  rup =new((/2,n/),float)
  rup(0,:) = data1(:,2)*86400.
  rup(1,:) = data2(:,2)*86400.

  resp =new((/2,n/),float)
  resp(0,:) = data1(:,3)*86400.
  resp(1,:) = data2(:,3)*86400.

  mic =new((/2,n/),float)
  mic(0,:) = data1(:,4)
  mic(1,:) = data2(:,4)

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
    res@tmXBTickSpacingF       = 365*48
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
  res@xyDashPatterns         = (/0,0,0,0,0/) ; 0- solid, 1-dash.

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
   res@pmLegendHeightF        = 0.07
;--------------------------------------------------------------------------
  res@gsnFrame = False ; Don't advance frame.
; --------------------- marker ----------------------------------------------------
    res@xyMarkerColors   =(/7,5,5,5,5/)            ; Marker color
    res@xyMarkers       = (/4,4,7,7,7/)   ; 
           ;  4 - circle,  5- corss , 6-square ,7 - triangle
           ;  0 - none  ,  1- dot   , 2 - plus ,3 - asterisk
           ;  9 - lingxi,  12 -star , 14 - dotted cirle , 16 - full cirlce
    res@xyMarkerSizeF   = 0.003        ; Marker size (default 
                                            ; is 0.01)
; --------------------- Label line------------------------------------------------------
; -------------------- Date Range --------------------------------------------------
;  res@tiYAxisString          = " Runoff (mm d:S:-1:N:)"
  res@xyMarkLineModes = (/"Lines","Lines","Lines","Lines"/)
;================================================================================
  res@trXMinF        =0
  res@trXMaxF        =n

   res@vpXF      = 0.08    ; Change the size and location of the
   res@vpWidthF  = 0.9
   res@vpHeightF = 0.10

  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False

 res@pmLegendDisplayMode    = "Always"
;     write(26,'(13E12.4)')NEE,GPP,RSROOT,RSWOOD,RSLEAF,RSSTEM,&
;                 GRLEAF,GRROOT,GRWOOD,GRSTEM,HETERS,TF,RHAIR
;================================================================================
  res@vpYF      = 0.99     ; plot on the viewport.
  res@xyExplicitLabels = (/"4C","4C /O2","OBS NEE",""/)
  res@tiYAxisString          = "O2"
  map = gsn_xy(wks,x,o2,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.87     ; plot on the viewport.
  res@tiYAxisString          = "(O2 ratio)"
  map = gsn_xy(wks,x,ro2,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.75     ; plot on the viewport.
  res@tiYAxisString          = "uptake rate"
  map = gsn_xy(wks,x,rup,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.63    ; plot on the viewport.
  res@tiYAxisString          = "resp"
  ;res@trYMinF                =  0.
  ;res@trYMaxF                =  2.5
  ;res@tmYLTickSpacingF       =  0.5
  map = gsn_xy(wks,x,resp,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.51     ; plot on the viewport.
  res@tiYAxisString          = "MIC"
  map = gsn_xy(wks,x,mic,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.39     ; plot on the viewport.
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
