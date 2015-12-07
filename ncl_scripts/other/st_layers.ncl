load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

function diurnal_sim(data,obs)

begin

   NC = 48
   mean     = new((/NC/),float)
   mean_new = new((/NC/),float)

   do ih = 0,47
      N        = 0
      mean(ih) = 0.
   do iday = 0,1455-1 ;2551-1

      if(obs(iday*48+ih).ne.-9999. .and. obs(iday*48+ih).ne.-6999.) then
       N = N +1
       mean(ih) = mean(ih) + data(iday*48+ih)
      end if
   end do

      if(N .ne. 0) then
       mean(ih) = mean(ih) / N
      end if
   end do

   mean_new( 0:22) = mean(25:47)
   mean_new(23:47) = mean( 0:24)

;   mean_new( 0:23) = mean(24:47)
;   mean_new(24:47) = mean( 0:23)

;   print(mean_new)

  return(mean_new)
end

function diurnal(data)

begin

   NC = 48
   mean     = new((/NC/),float)
   mean_new = new((/NC/),float)

   do ih = 0,47
      N        = 0
      mean(ih) = 0.
   do iday = 0,1455-1 ;2551-1

      if(data(iday*48+ih).ne.-9999. .and. data(iday*48+ih).ne.-6999.) then
       N = N +1
       mean(ih) = mean(ih) + data(iday*48+ih)
      end if
   end do

      if(N .ne. 0) then
       mean(ih) = mean(ih) / N
      end if
   end do

   mean_new( 0:22) = mean(25:47)
   mean_new(23:47) = mean( 0:24)

;   mean_new( 0:23) = mean(24:47)
;   mean_new(24:47) = mean( 0:23)

;   print(mean_new)

  return(mean_new)
end

function daily_mean(data)

begin

   NC = 1455 ;2551
   mean = new((/NC/),float)

   do iday = 0,NC-1
    N    = 0
    mean(iday) = 0.

   do ih = 0,47
     if(data(iday*48+ih).ne.-9999. .and. data(iday*48+ih).ne.-6999.) then
       N = N +1
       mean(iday) = mean(iday) + data(iday*48+ih)
     end if
   end do

   if(N .ne. 0) then
    mean(iday) = mean(iday) / N
   else
    mean(iday) = -999.
   end if
   end do

  return(mean)
end

begin
 
  nday = 1455 ;2551
  n    = 69864 ;122471

  forc_obs = asciiread("./obs/forcings04-10.dat",(/n,10/),"float")
  data_obs = asciiread("./obs/st_obs.dat",(/nday,18/),"float")
  data_sim1 = asciiread("../output/exp1/hist/soil_t.dat",(/nday,16/),"float")
  data_sim2 = asciiread("../output/exp2/hist/soil_t.dat",(/nday,16/),"float")

  x = new(nday,float)  ; Define two 1D arrays of 12 elements each.
  do i = 0,nday-1
  x(i) = i*1.
  end do

  xd = new(48,float)  ; Define two 1D arrays of 12 elements each.
  do i = 0,47
  xd(i) = i*1/2.
  end do

  sm_5cm =new((/3,nday/),float)
  sm_5cm(0,:) = (data_obs(:, 2) + data_obs(:,3))*0.5*0.5 + data_obs(:,10) * 0.5
  sm_5cm(1,:) =  data_sim1(:,1) ;- 273.16
  sm_5cm(2,:) =  data_sim2(:,1) ;- 273.16

  sm_10cm =new((/3,nday/),float)
  sm_10cm(0,:) = data_obs(:, 4)*0.5 + data_obs(:,11) * 0.5   ;
  sm_10cm(1,:) = data_sim1(:,2) ; 273.16 ;
  sm_10cm(2,:) = data_sim2(:,2) ; 273.16 ;

  sm_20cm =new((/3,nday/),float)
  sm_20cm(0,:) = data_obs(:, 5)*0.5 + 0.5*data_obs(:,12)  ;
  sm_20cm(1,:) = data_sim1(:,4) ; 273.16 ;
  sm_20cm(2,:) = data_sim2(:,4) ; 273.16 ;

  sm_30cm =new((/3,nday/),float)
  sm_30cm(0,:) = data_obs(:, 6)*0.5 + 0.5*data_obs(:,13)  ;
  sm_30cm(1,:) = data_sim1(:,6) ; 273.16 ;
  sm_30cm(2,:) = data_sim2(:,6) ; 273.16 ;

  sm_50cm =new((/3,nday/),float)
  sm_50cm(0,:) = data_obs(:, 7)*0.5 + 0.5*data_obs(:,14)  ;
  sm_50cm(1,:) = data_sim1(:,8) ; 273.16 ;
  sm_50cm(2,:) = data_sim2(:,8) ; 273.16 ;

  sm_70cm =new((/3,nday/),float)
  sm_70cm(0,:) = data_obs(:, 8)*0.5 + 0.5*data_obs(:,15)  ;
  sm_70cm(1,:) = data_sim1(:,10) ; 273.16 ;
  sm_70cm(2,:) = data_sim2(:,10) ; 273.16 ;

  sm_100cm =new((/3,nday/),float)
  sm_100cm(0,:) = data_obs(:, 9)*0.5 + 0.5*data_obs(:,16)  ;
  sm_100cm(1,:) = data_sim1(:,12) ; 273.16 ;
  sm_100cm(2,:) = data_sim2(:,12) ; 273.16 ;

  prec =new((/2,nday/),float)
  prec(0,:) = -daily_mean(forc_obs(:,3)) * 86400.
  prec(1,:) = 0.

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
    res@tmXBTickEndF           = nday
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
;  res@xyLineColors          = (/6,7,5,6/)     ; Set the line colors.
  res@xyLineColors           = (/3,5,5,6/)     ; Set the line colors.
  res@xyLineThicknesses      = (/1.0,1.0,0.5,1.0,1.0/)  
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
   res@pmLegendOrthogonalPosF = -0.18
   res@pmLegendParallelPosF   = 0.22
   res@pmLegendHeightF        = 0.04
;--------------------------------------------------------------------------
  res@gsnFrame = False ; Don't advance frame.
; --------------------- marker ----------------------------------------------------
    res@xyMarkerColors   =(/7,5,5,5,5/)            ; Marker color
    res@xyMarkers       = (/4,7,7,7,7/)   ; 
           ;  4 - circle,  5- corss , 6-square ,7 - triangle
           ;  0 - none  ,  1- dot   , 2 - plus ,3 - asterisk
           ;  9 - lingxi,  12 -star , 14 - dotted cirle , 16 - full cirlce
    res@xyMarkerSizeF   = 0.003        ; Marker size (default 
                                            ; is 0.01)
; --------------------- Label line------------------------------------------------------
; -------------------- Date Range --------------------------------------------------
  res@xyMarkLineModes = (/"Lines","Lines","Lines","Lines"/)
;================================================================================
  res@trXMinF        = 0
  res@trXMaxF        = nday

  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
  res@pmLegendDisplayMode    = "Always"
  res@xyExplicitLabels = (/"Obs","exp 1","exp 2"/)
  res@vpWidthF  = 0.85
  res@vpXF      = 0.08    ; Change the size and location of the
  res@trYMinF                = 0
;  res@tiYAxisString          = "ST (m:S:3:N:/m:S:3:N:)"
  res@tmYLTickSpacingF       = 10
;================================================================================
  res@vpYF      = 0.99     ; plot on the viewport.
  res@vpHeightF = 0.20
  res@trYMaxF                = 60
  res@tmYROn                 = False     ; Don't draw top axis tick marks.
  res@tiYAxisString          = "5cm (C)"
  map = gsn_xy(wks,x,sm_5cm,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpHeightF = 0.105
  res@trYMaxF                = 40
  res@pmLegendDisplayMode    = "Never"
;================================================================================
  res@vpYF      = 0.78     ; plot on the viewport.
  res@tiYAxisString          = "10cm (C)"
  map = gsn_xy(wks,x,sm_10cm,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.66     ; plot on the viewport.
  res@tiYAxisString          = "20cm (C)"
  map = gsn_xy(wks,x,sm_20cm,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.54     ; plot on the viewport.
  res@tiYAxisString          = "30cm (C)"
  map = gsn_xy(wks,x,sm_30cm,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.42     ; plot on the viewport.
  res@tiYAxisString          = "50cm (C)"
  map = gsn_xy(wks,x,sm_50cm,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.30     ; plot on the viewport.
  res@tiYAxisString          = "70cm (C)"
  map = gsn_xy(wks,x,sm_70cm,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.18     ; plot on the viewport.
  res@tiXAxisOn              = True     
  res@tmXBLabelsOn           = True
  res@tiXAxisString          = "Time (day from Jan. 6, 2004)"
  res@tiYAxisString          = "100cm (C)"
  map = gsn_xy(wks,x,sm_100cm,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
  resL = True
  resR = True

  resL@gsnFrame = False ; Don't advance frame.
  resR@gsnFrame = False ; Don't advance frame.

  resR@tmYRLabelDeltaF        = -0.9    ;
  resL@tmYLLabelFontHeightF   = 0.01     ;
  resL@tmYLMajorLengthF       = 0.006    ;

  resL@pmLegendDisplayMode    = "Never"
  resR@pmLegendDisplayMode    = "Never"

  resL@vpYF      = 0.99     ; plot on the viewport.
  resL@vpHeightF = 0.20
  resL@vpXF      = 0.08    ; Change the size and location of the
  resL@vpWidthF  = 0.85

  resR@tmBorderThicknessF     = 0.01       ; Default thickness is 2.0
  resL@tmBorderThicknessF     = 0.01       ; Default thickness is 2.0
  resL@tiYAxisOn    = False
  resL@tmYLLabelsOn = False
  resL@tiXAxisOn    = False
  resL@tmXBLabelsOn = False
  resL@tmXTOn       = False     ; Don't draw top axis tick marks.
  resL@tmXBOn       = False     ; Don't draw top axis tick marks.
  resL@tmYLOn       = False     ; Don't draw top axis tick marks.

  resR@xyMarkLineModes   = (/"Lines","Lines","Lines","Lines"/)
  resR@xyLineColors      = (/4,5,5,6/)     ; Set the line colors.
  resR@xyLineThicknesses = (/1.5,1.0,0.5,1.0,1.0/)

  resR@tmYRMode     = "Explicit"  ; Set tick mark mode.
  resR@tmYRValues    =(/0,-10,-20,-30,-40,-50/)
  resR@tmYRLabels    =(/"0","10","20","30","40","50"/)

  res@tmXTBorderOn           = False     ; Don't draw top axis.
  res@tmXBBorderOn           = False     ; Don't draw top axis.
  res@tmYLBorderOn           = False     ; Don't draw top axis.
  res@tmYRBorderOn           = False     ; Don't draw top axis.

  resR@tiYAxisFontHeightF     = 0.012    ; label size
  resR@tmYRMajorThicknessF    = 1.0      ;yes
  resR@tmYRMinorPerMajor      = 0        ;yes

  resR@trXMinF        =0
  resR@trXMaxF        =nday
  resL@trYMinF        = 2.0
  resL@trYMaxF        = 3.8
  resR@trYMinF        = -50.
  resR@trYMaxF        = 0.
  resR@tmYLTickSpacingF       = 10.
  resR@tiYAxisString          = "P (mm/day)"

  resL@gsnFrame = False ; Don't advance frame.
  resR@gsnFrame = False ; Don't advance frame.
  map = gsn_csm_xy2(wks,x,prec(1,:),prec(0,:),resL,resR) ;
;================================================================================

   txres = True
   txres@txFontHeightF = 0.011
   txres@txFuncCode    = "~"          ; Default is ":"
;   gsn_text_ndc(wks,"Number of days from Nov. 1, 1969",0.5,0.64,txres)
;   gsn_text_ndc(wks,"a",0.96,0.98,txres)
   gsn_text_ndc(wks,"Soil Temperature",0.5,0.02,txres)

  frame(wks)   ; Advance the frame.
end
