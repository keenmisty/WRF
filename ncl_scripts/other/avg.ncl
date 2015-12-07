load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin
 
  n = 5114
  data = asciiread("../../Run/fort.10",(/n,14/),"float")
  data_obs = asciiread("../../../OBS/val_daily2.dat",(/n,17/),"float")
;     write(26,'(13E12.4)')NEE,GPP,RSROOT,RSWOOD,RSLEAF,RSSTEM,&
;                 GRLEAF,GRROOT,GRWOOD,GRSTEM,HETERS,TF,RHAIR

  x = new(n,float) 
  x(:) = data(:,0)

  nee =new((/3,n/),float)
  nee(0,:) = data(:,1)    * 86400. ;+ data(:,5)    * 86400.
  nee(1,:) = data(:,2)    * 86400.
  nee(2,:) = data_obs(:,3)    * 86400. * 12.e-6  ;obs
  nee = mask(nee,(nee .gt. -999.), True)

  mrs =new((/4,n/),float)
  mrs(0,:) = data(:,3)    * 86400.
  mrs(1,:) = data(:,4)    * 86400.
  mrs(2,:) = data(:,5)    * 86400.
  mrs(3,:) = data(:,6)    * 86400.

  grs =new((/4,n/),float)
  grs(0,:) = data(:,7)    * 86400.
  grs(1,:) = data(:,8)    * 86400.
  grs(2,:) = data(:,9)    * 86400.
  grs(3,:) = data(:,10)    * 86400.

  heters =new((/1,n/),float)
  heters(0,:) = data(:,11)    * 86400.

  tf =new((/1,n/),float)
  tf(0,:) = data(:,12)

  rh =new((/1,n/),float)
  rh(0,:) = data(:,13)

  ;apar = mask(apar, (apar .ne. -9999.), True)

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
    res@tmXBTickSpacingF       = 365
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
  res@trXMinF        =365*3 ;55560
  res@trXMaxF        =365*5 ;58000

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
  res@xyExplicitLabels = (/"NEE","GPP","OBS NEE",""/)
  res@tiYAxisString          = "NEE (g C/m2/d)"
  res@trYMinF                = -4.
  res@trYMaxF                =  8.
  res@tmYLTickSpacingF       = 2.
  map = gsn_xy(wks,x,nee,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.87     ; plot on the viewport.
  res@xyExplicitLabels = (/"root","wood","leaf","stem"/)
  res@tiYAxisString          = "MRS (g C/m2/d)"
  res@trYMinF                =  0.
  res@trYMaxF                =  2.5
  res@tmYLTickSpacingF       =  0.5
  map = gsn_xy(wks,x,mrs,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.75     ; plot on the viewport.
  res@xyExplicitLabels = (/"leaf","root","wood","stem"/)
  res@trYMinF                =  0.
  res@trYMaxF                =  0.8
  res@tmYLTickSpacingF       =  0.2
  res@tiYAxisString          = "GRS (g C/m2/d)"
  map = gsn_xy(wks,x,grs,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.63    ; plot on the viewport.
  res@tiYAxisString          = "HETERS (g C/m2/d)"
  res@trYMinF                =  0.
  res@trYMaxF                =  2.5
  res@tmYLTickSpacingF       =  0.5
  map = gsn_xy(wks,x,heters,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.51     ; plot on the viewport.
  res@trYMinF                =  0.
  res@trYMaxF                =  1.0
  res@tmYLTickSpacingF       =  0.2
  res@tiYAxisString          = "TF"
  map = gsn_xy(wks,x,tf,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.39     ; plot on the viewport.

  res@tiXAxisOn    = True
  res@tmXBLabelsOn = True
  res@tiXAxisString          = "Time (day)"
  res@tiYAxisString          = "RH (-)"
  map = gsn_xy(wks,x,rh,res) ; Draw an XY plot with 2 curves.
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
