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
 return(mean_new)
end

function corr(nt,simu,obs)
begin

  N = 0
  term1 = 0.
  do i = 0,nt-1
    if(obs(i).gt.-999.) then
      N = N +1
      term1 = term1 + simu(i) * obs(i)
    end if
  end do


  term2_1 = 0.
  term2_2 = 0.
  term2_3 = 0.
  term2_4 = 0.
  do i = 0,nt-1
    if(obs(i).gt.-999.) then
      term2_1 = term2_1 + simu(i)
      term2_2 = term2_2 + obs(i)
      term2_3 = term2_3 + simu(i) * simu(i)
      term2_4 = term2_4 + obs(i) * obs(i)
    end if
  end do
  term2 = term2_1*term2_2/N

  term3 = (term2_3 - term2_1*term2_1/N)
  term4 = (term2_4 - term2_2*term2_2/N)

; model efficiency

  r = (term1 - term2) / sqrt(term3*term4)

  return(r)
end

function rmse(nt,simu,obs)
begin

  N = 0
  err = 0.

  do i = 0,nt-1
    if(obs(i).gt.-999.) then
      N = N +1
      err = err + (obs(i) -simu(i)) *  (obs(i) -simu(i))
    end if
  end do
  err = sqrt(err/N)

  return(err)
end

function model_eff(nday,simu,obs)
begin

; obs mean value

  N = 0
  mean_obs= 0.

  do i = 0,nday-1
    if(obs(i).gt.-999.) then
      N = N +1
      mean_obs = mean_obs + obs(i)
    end if
  end do
  mean_obs = mean_obs / N

; Variance of observed

  var_obs = 0.

  do i = 0,nday-1
    if(obs(i).gt.-999.) then
      var_obs = var_obs + (obs(i) - mean_obs) * (obs(i) - mean_obs)
    end if
  end do

; Variance of simu and obs

  var_so = 0.
  do i = 0,nday-1
    if(obs(i).gt.-999.) then
      var_so = var_so + (simu(i) - obs(i)) * (simu(i) - obs(i))
    end if
  end do


; model efficiency

  me = (var_obs - var_so) / var_obs

  return(me)
end

begin

     n = 16991

;****************************************************************************
;read in data
;****************************************************************************
     data_sim = addfile("../output/exp1/hrly/NoahMP.hrly.nc", "r")
     data_obs = asciiread("./obs/soiltm.dat",(/n,4/),"float")
     forc_obs = asciiread("./obs/forcings07.dat",(/n,10/),"float")

     x = new(n,float)  ; Define two 1D arrays .
     do i = 0,n-1
      x(i) = i*1.
     end do

 
     atem =new((/n/),float)
     atem(:) =forc_obs(:,4)-273.15   
     prec =new((/n/),float)
     prec(:) = forc_obs(:,3)*1800
  
     soilm_2_5cm   =  new((/2,n/),float)
     soilm_2_5cm(0,:)=data_sim->SMC(0:n-1,2,0,0)
     soilm_2_5cm(1,:)=data_obs(:,0)*0.01

     soilm_10cm    =  new((/2,n/),float)
     soilm_10cm(0,:) =data_sim->SMC(0:n-1,3,0,0)
     soilm_10cm(1,:)=data_obs(:,1)*0.01

     soilt_3_6cm   =  new((/2,n/),float)
     soilt_3_6cm(0,:)  = data_sim->STC(0:n-1,4,0,0)-273.15
     soilt_3_6cm(1,:)  = data_sim->STC(0:n-1,5,0,0)-273.15

     soilt_5cm     =  new((/2,n/),float)
     soilt_5cm(0,:) =soilt_3_6cm(0,:)*0.5+soilt_3_6cm(1,:)*0.5
     soilt_5cm(1,:) =data_obs(0:n-1,2)

     soilt_10cm    =  new((/2,n/),float)
     soilt_10cm(0,:) = data_sim->STC(0:n-1,6,0,0)-273.15
     soilt_10cm(1,:)=data_obs(:,3)

;calculate the statistical error and model efficency
     meffm=new(4,float)
     rmsem=new(4,float)
     corrm=new(4,float)

     meffm(0) = model_eff(n,soilm_2_5cm(0,:),soilm_2_5cm(1,:))
     rmsem(0) = rmse(n,soilm_2_5cm(0,:),soilm_2_5cm(1,:))
     corrm(0) = corr(n,soilm_2_5cm(0,:),soilm_2_5cm(1,:))

     meffm(1) = model_eff(n,soilm_10cm(0,:),soilm_10cm(1,:))
     rmsem(1) = rmse(n,soilm_10cm(0,:),soilm_10cm(1,:))
     corrm(1) = corr(n,soilm_10cm(0,:),soilm_10cm(1,:))

     meffm(2) = model_eff(n,soilt_5cm(0,:),soilt_5cm(1,:))
     rmsem(2) = rmse(n,soilt_5cm(0,:),soilt_5cm(1,:))
     corrm(2) = corr(n,soilt_5cm(0,:),soilt_5cm(1,:))
 
     meffm(3) = model_eff(n,soilt_10cm(0,:),soilt_10cm(1,:))
     rmsem(3) = rmse(n,soilt_10cm(0,:),soilt_10cm(1,:))
     corrm(3) = corr(n,soilt_10cm(0,:),soilt_10cm(1,:))


     soilm_2_5cm = mask(soilm_2_5cm,(soilm_2_5cm.gt.-99.99),True)
     soilm_10cm = mask(soilm_10cm,(soilm_10cm.gt.-99.99),True)
;     flux_co2 = mask(flux_co2,(flux_co2.gt.-99.99),True)
     
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
    res@tmBorderThicknessF     = 2.0       ; Default thickness is 2.0
    res@tmXBLabelFont          = 21        ; Change font and size of
    res@tmXBLabelFontHeightF   = 0.01     ; X axis labels.
    res@tmXBMajorLengthF       = 0.006     ; Default is 0.02.
    res@tmXBMajorThicknessF    = 1.0       ; Default is 2.
    res@tmXBMinorLengthF       = 0.0075    ; Default is 0.01.
    res@tmXBMinorPerMajor      = 0         ; # of minor tick marks per major.
    res@tmXBMode               = "Manual"  ; Set tick mark mode.
    res@tmXBTickStartF         = 0
    res@tmXBTickEndF           = 16991
    res@tmXBTickSpacingF       = 2880
    res@tmXMajorGridThicknessF = 1.0       ; Default is 2.0
; ------------------- Y- axis ----------------------------------------------------
   res@tmYLLabelFont          = 21        ; See explanations for X axes
   res@tmYLLabelFontHeightF   = 0.01     ; res.
   res@tmYLMajorLengthF       = 0.006
   res@tmYLMajorThicknessF    = 2.0
   res@tmYLMinorPerMajor      = 0
  res@tmYLMode               = "Manual"
  res@tmYLTickStartF         = -12000.0
  res@tmYLTickEndF           = 12000.
;   res@tmYRBorderOn           = False    ; Don't draw right axis.
;   res@tmYROn                 = False    ; Don't draw right axis tick marks.
; ---------------------- line ---------------------------------------------------
;  res@xyLineColors           = (/3,4,5,6/)     ; Set the line colors.
;  res@xyLineThicknesses      = (/1.0,1,1.0,1.0,1.0/)
;  res@xyDashPatterns         = (/0,0,0,1,0/) ; 0- solid, 1-dash.
  res@xyLineColors           = (/3,4,5,6/)     ; Set the line colors.
  res@xyLineThicknesses       = (/1.0,1.2,0.5,1.0/)
  res@xyDashPatterns         = (/0,2,0,1,0/) ; 0- solid, 1-dash.
; ------------------ for tick ---------------------------------------------------
;  res@pmTickMarkDisplayMode = "Always"
;  res@pmTickMarkZone        = 2
; --------------for legend ------------------------------------------------------
   res@lgLabelsOn = True
   res@lgAutoManage = False
   res@lgLabelFontHeightF = 0.01
   res@lgBoxMajorExtentF = 0.08
   res@lgBoxMinorExtentF = 0.08
;   res@pmLegendOrthogonalPosF = 0.18
;   res@pmLegendParallelPosF   = 0.1
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

  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
  res@pmLegendDisplayMode    = "Always"
 res@pmLegendSide           = "Top"               ; Change location of
  res@pmLegendParallelPosF   = 0.1                  ; move units right
  res@pmLegendOrthogonalPosF = -0.5                ; move units down
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .01                 ; label font height
  res@xyExplicitLabels = (/"Sim","Obs",""/)

  res@vpWidthF  = 0.85
  res@vpXF      = 0.08    ; Change the size and location of the
;================================================================================

  res@trXMinF        = 0
  res@trXMaxF        =16991

  res@tmXBTickSpacingF       = 2880
;  res@pmLegendDisplayMode    = "Never"





;================================================================================
  res@vpYF      = 0.80     ; plot on the viewport.
  res@vpHeightF = 0.18

;  res@pmLegendDisplayMode    = "Never"
 res@trYMaxF                = 0.35
  res@trYMinF                = 0
  res@tiYAxisString          = "SM (m:S:3:N:/m:S:3:N:)"
  res@tmYLTickSpacingF       = 0.05
  res@tmYROn                 = False     ; Don't draw top axis tick marks.
  res@tiYAxisString          = "5cm SM (m:S:3:N:/m:S:3:N:)"

  map = gsn_xy(wks,x,soilm_2_5cm,res) ; Draw an XY plot with 1 curves.
;================================================================================

 res@vpHeightF = 0.18

  res@vpYF      = 0.61     ; plot on the viewport.
res@tiYAxisString          = "10cm SM (m:S:3:N:/m:S:3:N:)"

  map = gsn_xy(wks,x,soilm_10cm,res) ; Draw an XY plot with 1 curves.
;
;================================================================================
  res@vpYF      = 0.42    ; plot on the viewport.
  res@trYMaxF                = 55
  res@trYMinF                = 0
  res@tmYLTickSpacingF       = 10
  res@tmYROn                 = False     ; Don't draw top axis tick marks.
; res@tiXAxisOn              = True
;  res@tmXBLabelsOn           = True

  res@tiYAxisString          = "5cm ST (:S:0:N:C)"

  map = gsn_xy(wks,x,soilt_5cm,res) ; Draw an XY plot with 2 curves.
;================================================================================
;================================================================================
  res@vpYF      = 0.23     ; plot on the viewport.
  res@trYMaxF                = 55
  res@trYMinF                = 0
  res@tmYLTickSpacingF       = 10
  res@tmYROn                 = False     ; Don't draw top axis tick marks.
; res@tiXAxisOn              = True
;  res@tmXBLabelsOn           = True

  res@tiYAxisString          = "10cm ST (:S:0:N:C)"

  res@tiXAxisString          = "Time (day)"
  res@tmXBMode     = "Explicit"  ; Set tick mark mode.
  res@tmXBValues    =(/0,2880,5760,8640,11520,14400/)
  res@tmXBLabels    =(/"0","60","120","180","240","300"/)

  map = gsn_xy(wks,x,soilt_10cm,res) ; Draw an XY plot with 2 curves.

;================================================================================
;  res@vpYF      = 0.99     ; plot on the viewport.
;  res@vpHeightF = 0.18
;  res@pmLegendDisplayMode    = "Never"
;  res@trYMaxF                = 40   
;  res@trYMinF                = -10
;  res@tiYAxisString          = "SM (m:S:3:N:/m:S:3:N:)"
;  res@tmYLTickSpacingF       = 10
;  res@tmYROn                 = False     ; Don't draw top axis tick marks.
;  res@tiYAxisString          = " Air T (:S:0:N:C)"
 ;res@tiXAxisOn              = True
 ; res@tmXBLabelsOn           = True
;  map = gsn_xy(wks,x,atem,res) ; Draw an XY plot with 2 curves.

;==================================================================================  
 res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
  resL = True
  resR = True

  resL@gsnFrame = False ; Don't advance frame.
  resR@gsnFrame = False ; Don't advance frame.

;  resR@tmYRLabelDeltaF        = -0.9    ;
;  resL@tmYLLabelFontHeightF   = 0.01     ;
;  resL@tmYLMajorLengthF       = 0.006    ;

  resL@pmLegendDisplayMode    = "Never"
  resR@pmLegendDisplayMode    = "Never"

  resL@vpYF      = 0.99     ; plot on the viewport.
  resL@vpHeightF = 0.18
  resL@vpXF      = 0.08    ; Change the size and location of the
  resL@vpWidthF  = 0.85
  resR@vpYF      = 0.99     ; plot on the viewport.
  resR@vpHeightF = 0.18
  resR@vpXF      = 0.08    ; Change the size and location of the
  resR@vpWidthF  = 0.85

  resR@tmBorderThicknessF     = 2       ; Default thickness is 2.0
  resL@tmBorderThicknessF     = 2       ; Default thickness is 2.0
;  resL@tiYAxisOn    = False
;  resL@tmYLLabelsOn = False
;  resL@tiXAxisOn    = False
;  resL@tmXBLabelsOn = False
  resL@tmXTOn       = False     ; Don't draw top axis tick marks.
  resL@tmXBOn       = False     ; Don't draw top axis tick marks.
  resR@tmXTOn       = False     ; Don't draw top axis tick marks.
  resR@tmXBOn       = False     ; Don't draw top axis tick marks.
;  resL@tmYLOn       = False     ; Don't draw top axis tick marks.
 resL@xyMarkLineModes   = (/"Lines","Lines","Lines","Lines"/)
 resL@xyLineColors      = (/4,5,5,6/)     ; Set the line colors.
  resL@xyLineThicknesses = (/1,1.0,0.5,1.0,1.0/)

  resR@xyMarkLineModes   = (/"Lines","Lines","Lines","Lines"/)
 resR@xyLineColors      = (/4,5,5,6/)     ; Set the line colors.
  resR@xyLineThicknesses = (/1.5,1.0,0.5,1.0,1.0/)

;  resR@tmYRMode     = "Explicit"  ; Set tick mark mode.
;  resR@tmYRValues    =(/0,10,20,30,40/)
;  resR@tmYRLabels    =(/"0","10","20","30","40"/)

  res@tmXTBorderOn           = False     ; Don't draw top axis.
  res@tmXBBorderOn           = False     ; Don't draw top axis.
  res@tmYLBorderOn           = False     ; Don't draw top axis.
  res@tmYRBorderOn           = False     ; Don't draw top axis.

  resL@tiYAxisFont     = 21
  resL@tmYLLabelFontHeightF   = 0.01     ; res.
  resL@tiYAxisFontHeightF     = 0.01    ; label size
  resL@tmYRMajorThicknessF    = 1.0      ;yes
  resL@tmYRMinorPerMajor      = 0        ;yes
   resL@tmYLMajorLengthF       = 0.006
   resL@tmYLMajorThicknessF    = 1.0
   resL@tmYLMinorPerMajor      = 0
 resL@tmYLLabelFont          = 21        ; See explanations for X axes

 resR@tiYAxisFont     = 21
  resR@tmYLLabelFontHeightF   = 0.01     ; res.
   resR@tmYLLabelFont          = 21        ; See explanations for X axes
  resR@tiYAxisFontHeightF     = 0.01    ; label size
  resR@tmYRMajorThicknessF    = 1.0      ;yes
  resR@tmYRMinorPerMajor      = 0        ;yes
   resR@tmYLMajorLengthF       = 0.006
   resR@tmYLMajorThicknessF    = 1.0
   resR@tmYLMinorPerMajor      = 0

  resL@trXMinF                = 0
  resL@trXMaxF                = 16991
;  resR@tmXLTickSpacingF       = 2880

 resR@trXMinF                = 0
  resR@trXMaxF                = 16991


  resR@trYMinF        = 0
  resR@trYMaxF        = 35
  resR@tmYLTickSpacingF       = 10.
;  resR@tmYROn                 = False     ; Don't draw top axis tick marks.
  resR@tiYAxisString          = "P (mm/30min)"

 resL@trYMaxF                = 40
  resL@trYMinF                = -10
  resL@tmYLTickSpacingF       = 10
;  resL@tmYROn                 = False     ; Don't draw top axis tick marks.
  resL@tiYAxisString          = " Air T (:S:0:N:C)"

; res@gsnScale = True
; res@gsnYRefLine           = 0.              ; reference line
  resL@gsnFrame = False ; Don't advance frame.
  resR@gsnFrame = False ; Don't advance frame.

 map = gsn_csm_xy2(wks,x,atem,prec,resL,resR) ; Draw an XY plot with 2 curves.

;===================================================================


   txres = True
   txres@txFontColor = 6
   txres@txFontHeightF = 0.011
   txres@txJust        = "CenterLeft"
   txres@txFuncCode    = "~"          ; Default is ":"

   gsn_text_ndc(wks,"a",0.09,0.98,txres)
   gsn_text_ndc(wks,"b",0.09,0.98-0.19*1,txres)
   gsn_text_ndc(wks,"c",0.090,0.98-0.19*2,txres)
   gsn_text_ndc(wks,"d",0.090,0.98-0.19*3,txres)
   gsn_text_ndc(wks,"e",0.090,0.98-0.19*4,txres)
;   gsn_text_ndc(wks,"f",0.970,0.97-0.12*5,txres)

  do i=0,3
     gsn_text_ndc(wks,"~F8~e= ~F21~" + sprintf("%4.2f",meffm(i))\
     +"; RMSE = "+sprintf("%4.2f",rmsem(i))\
     +"; R = "+sprintf("%4.2f",corrm(i)),0.69,0.79-i*0.19,txres)
   end do

frame(wks)   ; Advance the frame.
end

