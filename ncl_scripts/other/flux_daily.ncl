load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

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

function diurnal_sim(data,obs,nday)

begin

   NC = 48
   mean     = new((/NC/),float)
   mean_new = new((/NC/),float)

   do ih = 0,47
      N        = 0
      mean(ih) = 0.
   do iday = 0,nday-1

      if(obs(iday*48+ih).ne.-9999. .and. obs(iday*48+ih).ne.-6999.) then
       N = N +1
       mean(ih) = mean(ih) + data(iday*48+ih)
      end if
   end do

      if(N .ne. 0) then
       mean(ih) = mean(ih) / N
      end if
   end do

   mean_new(:) = mean(:)
   mean_new(:) = mean(:)
   ;mean_new( 0:22) = mean(25:47)
   ;mean_new(23:47) = mean( 0:24)

;   print(mean_new)

  return(mean_new)
end

function diurnal(data,nday)

begin

   NC = 48
   mean     = new((/NC/),float)
   mean_new = new((/NC/),float)

   do ih = 0,47
      N        = 0
      mean(ih) = 0.
   do iday = 0,nday-1

      if(data(iday*48+ih).ne.-9999. .and. data(iday*48+ih).ne.-6999.) then
       N = N +1
       mean(ih) = mean(ih) + data(iday*48+ih)
      end if
   end do

      if(N .ne. 0) then
       mean(ih) = mean(ih) / N
      end if
   end do

   mean_new(:) = mean(:)
   mean_new(:) = mean(:)
;   mean_new( 0:22) = mean(25:47)
;   mean_new(23:47) = mean( 0:24)

;   print(mean_new)

  return(mean_new)
end

function accu(data,nday)

begin

   NC = nday
   acc = new((/NC/),float)

   acc(0) = data(0)
   do iday = 1,NC-1
       acc(iday) = acc(iday-1) + data(iday)
   end do

   return(acc)
end

function daily_mean(data,nday)

begin

   NC = nday
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
 
  nd = 365*14 + 4
  nd0 = nd-365*7
  ;nd = nd0+365

  ;nd0 = 365
  ;nd  = 730

  n0 = nd0*48
  n  = nd *48


  fhist1 = addfile ("../output/exp2/hist/Noah.dailymean.nc", "r")
  fhrly1 = addfile ("../output/exp2/hrly/NoahMP.hrly.nc", "r")
  fhist2 = addfile ("../output/exp1/hist/Noah.dailymean.nc", "r")
  fhrly2 = addfile ("../output/exp1/hrly/NoahMP.hrly.nc", "r")
  data_obs = asciiread("../../../OBS/validation2.dat",(/n,17/),"float")
  data = asciiread("../../Run/fort.27",(/n,8/),"float")
;          write(10,100) itt,gpp,re,nee,fco2,par,apar,hs,le,hg,rn,
;     _       rgout,rglout,ts1,ts2,swc1,swc2

  x = new(nd-nd0,float)  ; Define two 1D arrays of 12 elements each.
  do i = 0,nd-nd0-1
  x(i) = i*1.
  end do

  xd = new(48,float)  ; Define two 1D arrays of 12 elements each.
  do i = 0,47
  xd(i) = i*1/2.
  end do

  meff = new((/5,2/),float)

  st =new((/2,nd-nd0/),float)              ; soil T & lead T
  st(0,:) = daily_mean(data(n0:n-1,4),nd-nd0)
  st(1,:) = daily_mean(data(n0:n-1,7),nd-nd0)

  sm =new((/4,nd-nd0/),float)              ; soil ice & liq
  sm(0,:) = fhist1->SMC(nd0:nd-1,0,0,0)
  sm(1,:) = fhist1->SMC(nd0:nd-1,2,0,0)
  sm(2,:) = fhist1->SH2O(nd0:nd-1,0,0,0)
  sm(3,:) = fhist1->SH2O(nd0:nd-1,2,0,0)

  sd =new((/3,nd-nd0/),float)
  sd(1,:) = fhist1->SNOWD(nd0:nd-1,0,0)

  rn =new((/3,nd-nd0/),float)
  rn(1,:) = fhist1->FSA(nd0:nd-1,0,0)- fhist1->FIRA(nd0:nd-1,0,0)
  rn(0,:) = daily_mean(data_obs(n0:n-1,10),nd-nd0)
  meff(0,0) = model_eff(nd-nd0,rn(1,:),rn(0,:))
  rn = mask(rn,(rn .gt. -999.), True)

  rn_dur =new((/3,48/),float)
  rn_dur(1,:) = diurnal_sim(fhrly1->FSA(n0:n-1,0,0)-fhrly1->FIRA(n0:n-1,0,0),\
                            data_obs(n0:n-1,10),nd-nd0)
  ;rn_dur(2,:) = diurnal_sim(fhrly2->FSA(:,0,0)- fhrly2->FIRA(:,0,0),data_obs(:,10),nd)
  rn_dur(0,:) = diurnal(data_obs(n0:n-1,10),nd-nd0)

  sh =new((/3,nd-nd0/),float)
  sh(1,:) = fhist1->FSH(nd0:nd-1,0,0) * 1.
  sh(0,:) = daily_mean(data_obs(n0:n-1,7),nd-nd0)
  meff(1,0) = model_eff(nd-nd0,sh(1,:),sh(0,:))
  sh = mask(sh,(sh .gt. -999.), True)

  sh_dur =new((/3,48/),float)
  sh_dur(1,:) = diurnal_sim(fhrly1->FSH(n0:n-1,0,0),data_obs(n0:n-1,7),nd-nd0)
  sh_dur(0,:) = diurnal(data_obs(n0:n-1,7),nd-nd0)

  lh =new((/3,nd-nd0/),float)
  ;lh(1,:) = fhist1->ETRAN(:,0,0) * 2.5e6
  ;lh(1,:) = fhist1->ESOIL(:,0,0) * 2.5e6
  ;lh(1,:) = (fhist1->ETRAN(:,0,0)+fhist1->ECAN(:,0,0)) * 2.5e6
  lh(1,:) = fhist1->FLH(nd0:nd-1,0,0) * 1.
  lh(0,:) = daily_mean(data_obs(n0:n-1,8),nd-nd0)
  meff(2,0) = model_eff(nd-nd0,lh(1,:),lh(0,:))
  lh = mask(lh,(lh .gt. -999.), True)

  lh_dur =new((/3,48/),float)
  lh_dur(1,:) = diurnal_sim(fhrly1->FLH(n0:n-1,0,0),data_obs(n0:n-1,8),nd-nd0)
  lh_dur(0,:) = diurnal(data_obs(n0:n-1,8),nd-nd0)

  gh =new((/3,nd-nd0/),float)
  gh(1,:) = fhist1->FGH(nd0:nd-1,0,0) *1.
  gh(0,:) = daily_mean(data_obs(n0:n-1,9),nd-nd0)
  meff(3,0) = model_eff(nd-nd0,gh(1,:),gh(0,:))
  gh = mask(gh,(gh .gt. -999.), True)

  gh_dur =new((/3,48/),float)
  gh_dur(1,:) = diurnal_sim(fhrly1->FGH(n0:n-1,0,0),data_obs(n0:n-1,9),nd-nd0)
  ;gh_dur(2,:) = diurnal_sim(fhrly2->FGH(:,0,0),data_obs(:,9),nd)
  gh_dur(0,:) = diurnal(data_obs(n0:n-1,9),nd-nd0)

  ;balance_dur =new((/1,48/),float)
  ;balance_dur(0,:) = rn_dur(0,:) - sh_dur(0,:) - lh_dur(0,:) - gh_dur(0,:)
  ;sh_dur(0,:) = sh_dur(0,:) + balance_dur(0,:)

  ;balance =new((/1,nd-nd0/),float)
  ;balance(0,:) = rn(0,:) - sh(0,:) - lh(0,:) - gh(0,:)
  ;sh(0,:) = sh(0,:) + balance(0,:)

  rglout =new((/3,nd-nd0/),float)
  rglout(1,:) = 5.678e-8*(fhist1->TRAD(nd0:nd-1,0,0))^4
  ;rglout(2,:) = 5.678e-8*(fhist2->TRAD(:,0,0))^4
  rglout(0,:) = daily_mean(data_obs(n0:n-1,12),nd-nd0)
  meff(3,0) = model_eff(nd-nd0,rglout(1,:),rglout(0,:))
  rglout = mask(rglout,(rglout .gt. 0.), True)

  rglout_dur =new((/3,48/),float)
  rglout_dur(1,:) = 5.678e-8*diurnal_sim(fhrly1->TRAD(n0:n-1,0,0),data_obs(n0:n-1,12),nd-nd0)^4
  rglout_dur(0,:) = diurnal(data_obs(n0:n-1,12),nd-nd0)

  nee =new((/3,nd-nd0/),float)
  nee(1,:) = fhist1->NEE(nd0:nd-1,0,0)*86400.
  ;nee(2,:) = fhist2->NEE(:,0,0)*86400.
  nee(0,:) = daily_mean(data_obs(n0:n-1,3),nd-nd0) * 12.*1.e-6*86400.  ;umol/m2/s -> g/m2/d
  meff(4,0) = model_eff(nd-nd0,nee(1,:),nee(0,:))
  nee = mask(nee,(nee .gt. -999.), True)

  out = new((/nd-nd0,4/),float)
  out(:,0) = nee(0,:)
  out(:,1) = nee(1,:)

  acc_nee =new((/2,nd-nd0/),float)
  acc_nee(0,:) = accu(nee(0,:),nd-nd0)
  out(:,2) = acc_nee(0,:)
  out(:,3) = acc_nee(1,:)

  opt = True
  ;opt@title  = "obs model obs model"
  ;write_matrix (out, "4f12.6", opt)


  nee_dur =new((/2,48/),float)
  nee_dur(1,:) = diurnal_sim(fhrly1->NEE(n0:n-1,0,0),data_obs(n0:n-1,3),nd-nd0)*86400.
  nee_dur(0,:) = diurnal(data_obs(n0:n-1,3),nd-nd0) * 12.*1.e-6*86400.

  prec =new((/2,nd-nd0/),float)
  prec(0,:) = -fhist1->PRCP(nd0:nd-1,0,0) * 86400.
  prec(1,:) = 0.

  print("obs precipitation")
  print(sum(prec(0,:)))

  print("obs ET")
  print(sum(lh(0,:))/2.5e6*86400.)
  print("exp2 ET")
 ; print(sum(lh(2,:))/2.5e6*86400.)
  print("exp1 ET")
  print(sum(lh(1,:))/2.5e6*86400.)

  print("-------------------")

  print("obs NEE")
  print(avg(nee_dur(0,:))*(nd-nd0))
  print(acc_nee(0,nd-nd0-1))
  print("exp2 NEE")
  ;print(avg(nee_dur(2,:))*(nd-nd0))
  print("exp1 NEE")
  print(avg(nee_dur(1,:))*(nd-nd0))

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
    res@tmXBTickEndF           = x(nd-nd0-1)
    res@tmXBTickSpacingF       = x(nd-nd0-1)/10
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
  res@xyLineColors           = (/5,3,4,6,5,3,4,6/)     ; Set the line colors.
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0/)  
  res@xyDashPatterns         = (/0,0,2,2,2,2,2,2/) ; 0- solid, 1-dash.
; ------------------ for tick ---------------------------------------------------
;  res@pmTickMarkDisplayMode = "Always"
;  res@pmTickMarkZone        = 2
; --------------for legend ------------------------------------------------------ 
   res@lgLabelsOn = True
   res@lgAutoManage = False
   res@lgLabelFontHeightF = 0.012
   res@lgBoxMajorExtentF = 0.08
   res@lgBoxMinorExtentF = 0.08
   res@pmLegendOrthogonalPosF = -0.48
   res@pmLegendParallelPosF   = 0.35
   res@pmLegendHeightF        = 0.05
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
;  res@tiYAxisString          = " Runoff (mm d:S:-1:N:)"
  res@xyMarkLineModes = (/"Lines","Lines","Lines","Lines"/)
;================================================================================
  res@trXMinF        =0
  res@trXMaxF        =x(nd-nd0-1)

  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
  res@vpHeightF = 0.105
  res@vpWidthF  = 0.68
  res@vpXF      = 0.10    ; Change the size and location of the
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  res@vpYF      = 0.99     ; plot on the viewport.
  res@tiYAxisString          = "RN (W/m:S:2:N:)"
  res@trYMinF        = -20.
  res@trYMaxF        = 300.
  res@tmYLTickSpacingF       = 50.
  map = gsn_xy(wks,x,rn,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@trYMinF        = -100.
  res@trYMaxF        = 200.
  res@tmYLTickSpacingF       = 50.
  res@vpYF      = 0.87     ; plot on the viewport.
  res@tiYAxisString          = "SH (W/m:S:2:N:)"
  map = gsn_xy(wks,x,sh,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendDisplayMode    = "Always"
  res@xyExplicitLabels = (/"Obs","Model1","Model2"/)
  res@trYMinF        = -10.
  res@trYMaxF        = 200.
  res@tmYLTickSpacingF       = 40.
  res@vpYF      = 0.75     ; plot on the viewport.
  res@tiYAxisString          = "LH (W/m:S:2:N:)"
  map = gsn_xy(wks,x,lh,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  ;res@trYMinF        = -40.
  ;res@trYMaxF        =  40.
  ;res@tmYLTickSpacingF       = 20.
  ;res@vpYF      = 0.63    ; plot on the viewport.
  ;res@tiYAxisString          = "GH (W/m:S:2:N:)"
  ;map = gsn_xy(wks,x,gh,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.63     ; plot on the viewport.
  res@trYMinF        = 200.
  res@trYMaxF        = 450.
  res@tmYLTickSpacingF       = 50.
  res@tiYAxisString          = "LWup (W/m:S:2:N:)"
  map = gsn_xy(wks,x,rglout,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.51     ; plot on the viewport.
  res@trYMinF        = -6.0
  res@trYMaxF        = 3.0
  res@tmYLTickSpacingF       = 3.
  res@tiYAxisString          = "NEE (gC/m:S:2:N:/d)"
  map = gsn_xy(wks,x,nee,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.39     ; plot on the viewport.
  res@trYMinF        = 0.0
  res@trYMaxF        = 0.3
  res@tmYLTickSpacingF       = 0.05
  delete(res@trYMinF);        = -8.0
  delete(res@trYMaxF);        = 5.0
  delete(res@tmYLTickSpacingF);       = 3.
  res@tiYAxisString          = "SM (m3/m3)"
  map = gsn_xy(wks,x,st,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.27     ; plot on the viewport.
  res@tiYAxisString          = "SNOWH (m)"
  res@tiXAxisOn    = True
  res@tmXBLabelsOn = True
  res@tiXAxisString          = "Time (day Jan. 1, 2007)"
  map = gsn_xy(wks,x,sm,res) ; Draw an XY plot with 2 curves.
  ;map = gsn_xy(wks,x,sd,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@tiYAxisOn    = False
  ;res@tmYLLabelsOn = False
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
  res@vpXF      = 0.83    ; Change the size and location of the
  res@vpWidthF  = 0.14
  res@trXMinF        =1
  res@trXMaxF        =24
  res@tmXBTickSpacingF       = 6
;  res@xyMarkLineModes = (/"Lines","Markers","Lines","Lines"/)
  res@xyMarkLineModes = (/"Lines","Lines","Lines","Lines"/)
;================================================================================
  res@vpYF      = 0.99     ; plot on the viewport.
  res@tiYAxisString          = "RN (W/m:S:2:N:)"
  ;res@trYMinF        = -150.
  ;res@trYMaxF        =  550.
  ;res@tmYLTickSpacingF       = 200.
  map = gsn_xy(wks,xd,rn_dur,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  ;res@trYMinF        = -80.
  ;res@trYMaxF        = 400.
  ;res@tmYLTickSpacingF       = 100.
  res@vpYF      = 0.87     ; plot on the viewport.
  res@tiYAxisString          = "SH (W/m:S:2:N:)"
  map = gsn_xy(wks,xd,sh_dur,res) ; Draw an XY plot with 2 curves.
;================================================================================
  ;res@trYMinF        = -10.
  ;res@trYMaxF        =  80.
  ;res@tmYLTickSpacingF       = 30.
  res@vpYF      = 0.75     ; plot on the viewport.
  res@tiYAxisString          = "LH (W/m:S:2:N:)"
  map = gsn_xy(wks,xd,lh_dur,res) ; Draw an XY plot with 2 curves.
;================================================================================
  ;res@trYMinF        = -80.
  ;res@trYMaxF        = 160.
  ;res@tmYLTickSpacingF       = 50.
  ;res@vpYF      = 0.63    ; plot on the viewport.
  ;res@tiYAxisString          = "GH (W/m:S:2:N:)"
  ;map = gsn_xy(wks,xd,gh_dur,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.63     ; plot on the viewport.
  ;res@trYMinF         = 340.
  ;res@trYMaxF         = 520.
  ;res@tmYLTickSpacingF       = 50.
  res@tiYAxisString          = "LWup (W/m:S:2:N:)"
  map = gsn_xy(wks,xd,rglout_dur,res) ; Draw an XY plot with 2 curves.
;================================================================================
  ;res@trYMinF        = -2.
  ;res@trYMaxF        =  1.
  ;res@tmYLTickSpacingF       = 1.
  res@vpYF      = 0.51     ; plot on the viewport.
  res@tiYAxisString          = "NEE (gC/m:S:2:N:/d)"
  res@tiXAxisOn    = True
  res@tmXBLabelsOn = True
  res@tiXAxisString          = "Time (hour)"
  map = gsn_xy(wks,xd,nee_dur,res) ; Draw an XY plot with 2 curves.
;================================================================================

   txres = True
   txres@txFontHeightF = 0.011
   txres@txFontColor = 6
   txres@txFontHeightF = 0.01
   txres@txJust        = "CenterLeft"
   txres@txFuncCode    = "~"          ; Default is ":"

   gsn_text_ndc(wks,"a",0.76,0.98,txres)
   gsn_text_ndc(wks,"b",0.76,0.98-0.12*1,txres)
   gsn_text_ndc(wks,"c",0.76,0.98-0.12*2,txres)
   gsn_text_ndc(wks,"d",0.76,0.98-0.12*3,txres)
   gsn_text_ndc(wks,"e",0.76,0.98-0.12*4,txres)
   gsn_text_ndc(wks,"f",0.76,0.98-0.12*5,txres)

  do i=0,4
     gsn_text_ndc(wks,"~F8~e1= ~F21~" + sprintf("%4.2f",meff(i,0))\
     +";  ~F8~e2= ~F21~ "+sprintf("%4.2f",meff(i,0)),0.12,0.98-i*0.12,txres)
  ;   gsn_text_ndc(wks,"~F8~e1= ~F21~" + sprintf("%4.2f",meff(i,0))\
  ;   +";  ~F8~e2= ~F21~ "+sprintf("%4.2f",meff(i,1)),0.12,0.98-i*0.12,txres)
  end do

  frame(wks)   ; Advance the frame.
end
