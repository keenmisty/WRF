load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

function daily_mean(data)

begin

   NC = 352
   mean = new((/NC/),float)

   do iday = 0,NC-1
    N    = 0
    mean(iday) = 0.

   do ih = 0,47
     if(data(iday*48+ih).ne.-999.99) then
       N = N +1
       mean(iday) = mean(iday) + data(iday*48+ih)
     end if
   end do

   if(N .ne. 0.) then
    mean(iday) = mean(iday) / N
   else
    mean(iday) = -999.99
   end if
   end do

  return(mean)
end

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
     nday = 352

;****************************************************************************
;read in data
;****************************************************************************
     data_sim1 = addfile("../output/exp1/hrly/NoahMP.hrly.nc", "r")
     data_sim2 = addfile("../output/exp2/hrly/NoahMP.hrly.nc", "r")
     data_obs = asciiread("./obs/soiltm.dat",(/n,4/),"float")
     data_co2 = asciiread("./obs/co2_2007_30min.dat",(/n,9/),"float")
     forc_obs = asciiread("./obs/forcings07.dat",(/n,10/),"float")

     x = new(nday,float)  ; Define two 1D arrays .
     do i = 0,nday-1
      x(i) = i*1.
     end do
 
     prec =new((/nday/),float)
     prec(:) = -daily_mean(forc_obs(:,3)*1800.)*48.   ;mm/day
  
     soilt_2_5cm      =  new((/2,nday/),float)
     soilt_2_5cm(0,:) = daily_mean(data_sim1->STC(0:n-1,1,0,0))
     soilt_2_5cm(1,:) = daily_mean(data_sim2->STC(0:n-1,1,0,0))

     soilm_2_5cm   =  new((/3,nday/),float)
     soilm_2_5cm(0,:)=daily_mean(data_sim1->SMC(0:n-1,1,0,0))
     soilm_2_5cm(1,:)=daily_mean(data_sim2->SMC(0:n-1,1,0,0))
     soilm_2_5cm(2,:)=daily_mean(data_obs(:,0)*0.01)

     soilt_10cm      =  new((/2,nday/),float)
     soilt_10cm(0,:) = daily_mean(data_sim1->STC(0:n-1,2,0,0))
     soilt_10cm(1,:) = daily_mean(data_sim2->STC(0:n-1,2,0,0))

     soilm_10cm    =  new((/3,nday/),float)
     soilm_10cm(0,:) =daily_mean(data_sim1->SMC(0:n-1,2,0,0))
     soilm_10cm(1,:) =daily_mean(data_sim2->SMC(0:n-1,2,0,0))
     soilm_10cm(2,:)=daily_mean(data_obs(:,1)*0.01)

     soilco2_2cm  =  new((/3,nday/),float)
     soilco2_2cm(0,:)  = daily_mean(data_sim1->SOIL_CO2(0:n-1,1,0,0))
     soilco2_2cm(1,:)  = daily_mean(data_sim2->SOIL_CO2(0:n-1,1,0,0))
     soilco2_2cm(2,:)  = daily_mean((/data_co2(:,3)/))
     
     soilco2_10cm =  new((/3,nday/),float)
     soilco2_10cm(0,:) = daily_mean(data_sim1->SOIL_CO2(0:n-1,2,0,0))
     soilco2_10cm(1,:) = daily_mean(data_sim2->SOIL_CO2(0:n-1,2,0,0))
     soilco2_10cm(2,:) = daily_mean((/data_co2(:,4)/))

     flux_co2 = new((/3,nday/),float)
     flux_co2(0,:) = daily_mean(data_sim1->EFFLUX_CO2(0:n-1,0,0)/12*1.e06*(-1.))
     flux_co2(1,:) = daily_mean(data_sim2->EFFLUX_CO2(0:n-1,0,0)/12*1.e06*(-1.))
     flux_co2(2,:) = daily_mean(data_co2(:,5))

     ;print(soilt_10cm(1,:))

     soilm_10cm(0,:) = mask(soilm_10cm(0,:),soilt_10cm(1,:).lt.(273.16+5),True)
;     soilm_10cm(0,:) = mask(soilm_10cm(0,:),soilt_10cm(1,:).lt.(273.16+30),True)

     ;soilm_2_5cm = mask(soilm_2_5cm,(flux_co2(2,:).gt.0.),True)
     ;print(flux_co2(2,:))
     ;print(soilm_2_5cm(2,:))
  
     
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
;   res@tmXTOn                 = False     ; Don't draw top axis tick marks.
    res@tmBorderThicknessF     = 2.0       ; Default thickness is 2.0
    res@tmXBLabelFont          = 21        ; Change font and size of
    res@tmXBLabelFontHeightF   = 0.01     ; X axis labels.
    res@tmXBMajorLengthF       = 0.008     ; Default is 0.02.
    res@tmXBMajorThicknessF    = 1.0       ; Default is 2.
    res@tmXBMinorLengthF       = 0.006    ; Default is 0.01.
    res@tmXBMinorPerMajor      = 0         ; # of minor tick marks per major.
    res@tmXBMode               = "Manual"  ; Set tick mark mode.
    res@tmXBTickStartF         = 0
    res@tmXBTickEndF           = 0.5
    res@tmXBTickSpacingF       = 0.05
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
  res@xyLineColors           = (/3,4,5,6/)     ; Set the line colors.
  res@xyLineThicknesses       = (/1.5,1.5,1.5,1.0/)
  res@xyDashPatterns         = (/0,0,2,1,0/) ; 0- solid, 1-dash.
; ------------------ for tick ---------------------------------------------------
;  res@pmTickMarkDisplayMode = "Always"
;  res@pmTickMarkZone        = 2
; --------------for legend ------------------------------------------------------
   res@lgLabelsOn = True
   res@lgAutoManage = False
   res@lgLabelFontHeightF = 0.01
   res@lgBoxMajorExtentF = 0.08
   res@lgBoxMinorExtentF = 0.08
   res@pmLegendOrthogonalPosF = -0.35
   res@pmLegendParallelPosF   = 0.3
   res@pmLegendHeightF        = 0.04
;--------------------------------------------------------------------------
  res@gsnFrame = False ; Don't advance frame.
; --------------------- marker ----------------------------------------------------
    res@xyMarkerColors   =(/3,5,5,5,5/)            ; Marker color
    res@xyMarkers       = (/4,7,7,7,7/)   ;
           ;  4 - circle,  5- corss , 6-square ,7 - triangle
           ;  0 - none  ,  1- dot   , 2 - plus ,3 - asterisk
           ;  9 - lingxi,  12 -star , 14 - dotted cirle , 16 - full cirlce
    res@xyMarkerSizeF   = 0.003        ; Marker size (default
                                            ; is 0.01)
; --------------------- Label line------------------------------------------------------
; -------------------- Date Range --------------------------------------------------
  res@xyMarkLineModes = (/"Markers","Lines","Lines","Lines"/)
;================================================================================

  ;res@tiXAxisOn    = False
  ;res@tmXBLabelsOn = False
  res@pmLegendDisplayMode    = "Always"
  res@xyExplicitLabels = (/"Model1","Model2","Measured",""/)

  res@vpWidthF  = 0.5
  res@vpHeightF = 0.5
  res@vpXF      = 0.08    ; Change the size and location of the
;================================================================================

  res@trXMinF        = 0
  res@trXMaxF        = 0.15
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  res@vpYF      = 0.95    ; plot on the viewport.
  res@trYMinF                = 0
  res@trYMaxF                = 6
  res@tmYLTickSpacingF       = 2
  res@tiYAxisString          = "Efflux (umol m:S:-2:N:s:S:-1:N:)"
  res@tiXAxisString          = "soil moisture (m3/m3)"

  map = gsn_xy(wks,soilm_10cm(0,:),flux_co2(0,:),res) ; Draw an XY plot with 2 curves.
;===================================================================


   txres = True
   txres@txFontColor = 6
   txres@txFontHeightF = 0.01
   txres@txJust        = "CenterLeft"
   txres@txFuncCode    = "~"          ; Default is ":"

   ;gsn_text_ndc(wks,"a",0.91,0.98,txres)
   ;gsn_text_ndc(wks,"b",0.91,0.98-0.13*1,txres)
   ;gsn_text_ndc(wks,"c",0.91,0.98-0.13*2,txres)
   ;gsn_text_ndc(wks,"d",0.91,0.98-0.13*3,txres)
   ;gsn_text_ndc(wks,"e",0.91,0.98-0.13*4,txres)


frame(wks)   ; Advance the frame.
end

