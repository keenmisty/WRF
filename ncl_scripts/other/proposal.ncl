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

function accu(data,obs,nday)

begin

   NC = nday
   acc = new((/NC/),float)

   if(obs(0) .gt. -699.) then
      acc(0) = data(0)
   else
      acc(0) = 0.0
   end if

   do iday = 1,NC-1
     if(obs(iday) .gt. -699.) then
       acc(iday) = acc(iday-1) + data(iday)
     else
       acc(iday) = acc(iday-1) + 0.
     end if
   end do

   return(acc)
end

begin
 
  nd = 365*14 + 4
  nd0 = nd-(365*10+2)


  fhist2 = addfile ("../output/exp1/hist/Noah.dailymean.nc", "r")
  fhist1 = addfile ("../output/exp2/hist/Noah.dailymean.nc", "r")
  data_obs = asciiread("../../../OBS/val_daily2.dat",(/nd,17/),"float")
;          write(10,100) itt,gpp,re,nee,fco2,par,apar,hs,le,hg,rn,
;     _       rgout,rglout,ts1,ts2,swc1,swc2
  data = asciiread("../../Run/fort.10",(/nd,14/),"float")
;     write(26,'(13E12.4)')NEE,GPP,RSROOT,RSWOOD,RSLEAF,RSSTEM,&
;                 GRLEAF,GRROOT,GRWOOD,GRSTEM,HETERS,TF,RHAIR

  x = new(nd-nd0,float)  ; Define two 1D arrays of 12 elements each.
  do i = 0,nd-nd0-1
  x(i) = i*1./365
  end do

  meff = new((/5,2/),float)

  rsleaf =new((/2,nd-nd0/),float)
  rsleaf(1,:) = data(nd0:nd-1,5)    * 86400.

  tf =new((/2,nd-nd0/),float)
  tf(1,:) = data(nd0:nd-1,12) 

  rh =new((/2,nd-nd0/),float)
  rh(1,:) = data(nd0:nd-1,13)

  st =new((/3,nd-nd0/),float)              ; soil ice & liq
  st(0,:) = data_obs(nd0:nd-1,13) + 273.16
  st(1,:) = data_obs(nd0:nd-1,14) + 273.16
  st(2,:) = fhist1->STC (nd0:nd-1,0,0,0)*0.1 \
          + fhist1->STC (nd0:nd-1,1,0,0)*0.3 \
          + fhist1->STC (nd0:nd-1,2,0,0)*0.6
  st = mask(st,(st .gt. 0.), True)

  sm =new((/3,nd-nd0/),float)              ; soil ice & liq
  sm(0,:) = data_obs(nd0:nd-1,15)/100. 
  sm(1,:) = data_obs(nd0:nd-1,16)/100.
  ;sm(2,:) = fhist1->SMC (nd0:nd-1,0,0,0)  ;*0.1 \
  ;        + fhist1->SMC (nd0:nd-1,1,0,0)*0.3 \
  ;        + fhist1->SMC (nd0:nd-1,2,0,0)*0.6
  sm(2,:) = fhist1->SH2O(nd0:nd-1,0,0,0)  ;*0.1 \
  ;        + fhist1->SH2O(nd0:nd-1,1,0,0)*0.3 \
  ;        + fhist1->SH2O(nd0:nd-1,2,0,0)*0.6
  sm = mask(sm,(sm .gt. 0.), True)

  qco2 =new((/2,nd-nd0/),float)
  qco2(0,:) = fhist1->QCO2(nd0:nd-1,0,0)*86400.  ;g/m2/d
  qco2(1,:) = fhist2->QCO2(nd0:nd-1,0,0)*86400.  ;g/m2/d

  sd =new((/2,nd-nd0/),float)
  sd(1,:) = fhist1->SNOWD(nd0:nd-1,0,0)

  prec =new((/1,nd-nd0/),float)
  prec(0,:) = fhist1->PRCP(nd0:nd-1,0,0) * 86400.  ;->day

  soc =new((/2,nd-nd0/),float)
  soc(0,:) = fhist1->SOC(nd0:nd-1,0,0)
  soc(1,:) = fhist2->SOC(nd0:nd-1,0,0)

  wdoc =new((/2,nd-nd0/),float)
  wdoc(0,:) = fhist1->WDOC(nd0:nd-1,0,0)
  wdoc(1,:) = fhist2->WDOC(nd0:nd-1,0,0)

  ddoc =new((/2,nd-nd0/),float)
  ddoc(0,:) = fhist1->DDOC(nd0:nd-1,0,0)
  ddoc(1,:) = fhist2->DDOC(nd0:nd-1,0,0)

  mic =new((/2,nd-nd0/),float)
  mic(0,:) = fhist1->MIC(nd0:nd-1,0,0)
  mic(1,:) = fhist2->MIC(nd0:nd-1,0,0)

  wenz =new((/2,nd-nd0/),float)
  wenz(0,:) = fhist1->WENZ(nd0:nd-1,0,0)
  wenz(1,:) = fhist2->WENZ(nd0:nd-1,0,0)

  denz =new((/2,nd-nd0/),float)
  denz(0,:) = fhist1->DENZ(nd0:nd-1,0,0)
  denz(1,:) = fhist2->DENZ(nd0:nd-1,0,0)

  totc =new((/2,nd-nd0/),float)
  totc(0,:) = soc(0,:) + wdoc(0,:) + ddoc(0,:) + mic(0,:) + wenz(0,:) + denz(0,:)
  totc(1,:) = soc(1,:) + wdoc(1,:) + ddoc(1,:) + mic(1,:) + wenz(1,:) + denz(1,:)

  rn =new((/2,nd-nd0/),float)
  rn(1,:) = fhist1->FSA(nd0:nd-1,0,0)- fhist1->FIRA(nd0:nd-1,0,0)
  rn(0,:) = data_obs(nd0:nd-1,10)
  meff(0,0) = model_eff(nd-nd0,rn(1,:),rn(0,:))

  rnacc =new((/2,nd-nd0/),float)
  rnacc(0,:) = accu(rn(0,:),rn(0,:),nd-nd0)/(2.5e6)*86400.  ;w/m2->mm/day
  rnacc(1,:) = accu(rn(1,:),rn(0,:),nd-nd0)/(2.5e6)*86400.  ;w/m2->mm/day
  rn = mask(rn,(rn .gt. -999.), True)

  sh =new((/2,nd-nd0/),float)
  sh(1,:) = fhist1->FSH(nd0:nd-1,0,0) * 1.
  sh(0,:) = data_obs(nd0:nd-1,7)
  meff(1,0) = model_eff(nd-nd0,sh(1,:),sh(0,:))

  shacc =new((/2,nd-nd0/),float)
  shacc(1,:) = accu(sh(1,:),sh(0,:),nd-nd0)/(2.5e6)*86400.  ;w/m2->mm/day
  shacc(0,:) = accu(sh(0,:),sh(0,:),nd-nd0)/(2.5e6)*86400.  ;w/m2->mm/day
  sh = mask(sh,(sh .gt. -999.), True)

  lh =new((/2,nd-nd0/),float)
  lh(1,:) = fhist1->FLH(nd0:nd-1,0,0) * 1.
  lh(0,:) = data_obs(nd0:nd-1,8)
  meff(2,0) = model_eff(nd-nd0,lh(1,:),lh(0,:))

  lhacc =new((/3,nd-nd0/),float)
  lhacc(2,:) = accu(prec(0,:),prec(0,:),nd-nd0)  ;w/m2->mm/day
  lhacc(1,:) = accu(lh(1,:),lh(0,:),nd-nd0)/(2.5e6)*86400.  ;w/m2->mm/day
  lhacc(0,:) = accu(lh(0,:),lh(0,:),nd-nd0)/(2.5e6)*86400.  ;w/m2->mm/day
  lh = mask(lh,(lh .gt. -999.), True)

  rglout =new((/2,nd-nd0/),float)
  rglout(1,:) = 5.678e-8*(fhist1->TRAD(nd0:nd-1,0,0))^4
  rglout(0,:) = data_obs(nd0:nd-1,12)
  meff(3,0) = model_eff(nd-nd0,rglout(1,:),rglout(0,:))
  rglout = mask(rglout,(rglout .gt. 0.), True)

  nee =new((/3,nd-nd0/),float)
  nee(2,:) = fhist2->NEE(nd0:nd-1,0,0)*86400.
  nee(1,:) = fhist1->NEE(nd0:nd-1,0,0)*86400.
  nee(0,:) = data_obs(nd0:nd-1,3) * 12.*1.e-6*86400.  ;umol/m2/s -> g/m2/d
  meff(4,0) = model_eff(nd-nd0,nee(1,:),nee(0,:))
  meff(4,1) = model_eff(nd-nd0,nee(2,:),nee(0,:))

  neeacc =new((/3,nd-nd0/),float)
  neeacc(2,:) = accu(nee(2,:),nee(0,:),nd-nd0)
  neeacc(1,:) = accu(nee(1,:),nee(0,:),nd-nd0)
  neeacc(0,:) = accu(nee(0,:),nee(0,:),nd-nd0)
  nee = mask(nee,(nee .gt. -999.), True)

  print("obs NEE")
  print(neeacc(0,nd-nd0-1))
  print("model1 NEE")
  print(neeacc(1,nd-nd0-1))
  print("model2 NEE")
  print(neeacc(2,nd-nd0-1))
  print((neeacc(1,nd-nd0-1)-neeacc(2,nd-nd0-1))/neeacc(1,nd-nd0-1))


  ;preacc =new((/1,nd-nd0/),float)
  ;preacc(0,:) = accu(prec(0,:),prec(0,:),nd-nd0)  ;w/m2->mm/day

  print("-----------------------")
  print("obs precipitation")
  print(sum(prec(0,:)))
  print("obs ET")
  print(sum(lh(0,:))/2.5e6*86400.)
  print("exp1 ET")
  print(sum(lh(1,:))/2.5e6*86400.)

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
    res@tmXBTickSpacingF       = 1. ;x(nd-nd0-1)/10
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
  res@xyDashPatterns         = (/0,0,0,0,2,2,2,2/) ; 0- solid, 1-dash.
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
  res@vpWidthF  = 0.89
  res@vpXF      = 0.10    ; 
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  res@vpYF      = 0.99     ; plot on the viewport.
  res@tiYAxisString          = "RN (W/m:S:2:N:)"
  res@trYMinF        = -20.
  res@trYMaxF        = 300.
  res@tmYLTickSpacingF       = 50.
  map = gsn_xy(wks,x,rn,res) ; 
;================================================================================
  res@trYMinF        = -100.
  res@trYMaxF        = 200.
  res@tmYLTickSpacingF       = 50.
  res@vpYF      = 0.87     ; plot on the viewport.
  res@tiYAxisString          = "SH (W/m:S:2:N:)"
  map = gsn_xy(wks,x,sh,res) ; 
;================================================================================
  res@pmLegendDisplayMode    = "Always"
  res@xyExplicitLabels = (/"Obs","Model1","Model2"/)
  res@trYMinF        = -10.
  res@trYMaxF        = 200.
  res@tmYLTickSpacingF       = 40.
  res@vpYF      = 0.75     ; plot on the viewport.
  res@tiYAxisString          = "LH (W/m:S:2:N:)"
  map = gsn_xy(wks,x,lh,res) ; 
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  ;res@trYMinF        = -40.
  ;res@trYMaxF        =  40.
  ;res@tmYLTickSpacingF       = 20.
  ;res@vpYF      = 0.63    ; plot on the viewport.
  ;res@tiYAxisString          = "GH (W/m:S:2:N:)"
  ;map = gsn_xy(wks,x,gh,res) ; 
;================================================================================
  res@vpYF      = 0.63     ; plot on the viewport.
  res@trYMinF        = 200.
  res@trYMaxF        = 450.
  res@tmYLTickSpacingF       = 50.
  res@tiYAxisString          = "LWup (W/m:S:2:N:)"
  map = gsn_xy(wks,x,rglout,res) ; 
;================================================================================
  res@vpYF      = 0.51     ; plot on the viewport.
  res@trYMinF        = -6.0
  res@trYMaxF        = 3.0
  res@tmYLTickSpacingF       = 3.
  res@tiYAxisString          = "NEE (gC/m:S:2:N:/d)"
  map = gsn_xy(wks,x,nee(0:1,:),res) ; 
;================================================================================
  res@vpYF      = 0.39     ; plot on the viewport.
  res@trYMinF        = 0.0
  res@trYMaxF        = 0.3
  res@tmYLTickSpacingF       = 0.05
  delete(res@trYMinF);        = -8.0
  delete(res@trYMaxF);        = 5.0
  delete(res@tmYLTickSpacingF);       = 3.
  res@tiYAxisString          = "SNOWH (m)"
  map = gsn_xy(wks,x,sd,res) ; 
;================================================================================
  res@vpYF      = 0.27     ; plot on the viewport.
  res@tiYAxisString          = "SM (m3/m3)"
  res@tiXAxisOn    = True
  res@tmXBLabelsOn = True
  res@tiXAxisString          = "Time (year)"
  map = gsn_xy(wks,x,sm,res) ; 
;================================================================================
   txres = True
   txres@txFontHeightF = 0.011
   txres@txFontColor = 6
   txres@txFontHeightF = 0.01
   txres@txJust        = "CenterLeft"
   txres@txFuncCode    = "~"          ; Default is ":"

   gsn_text_ndc(wks,"a",0.97,0.98,txres)
   gsn_text_ndc(wks,"b",0.97,0.98-0.12*1,txres)
   gsn_text_ndc(wks,"c",0.97,0.98-0.12*2,txres)
   gsn_text_ndc(wks,"d",0.97,0.98-0.12*3,txres)
   gsn_text_ndc(wks,"e",0.97,0.98-0.12*4,txres)
   gsn_text_ndc(wks,"f",0.97,0.98-0.12*5,txres)

  do i=0,4
     gsn_text_ndc(wks,"~F8~e1= ~F21~" + sprintf("%4.2f",meff(i,0))\
     +";  ~F8~e2= ~F21~ "+sprintf("%4.2f",meff(i,1)),0.12,0.98-i*0.12,txres)
  ;   gsn_text_ndc(wks,"~F8~e1= ~F21~" + sprintf("%4.2f",meff(i,0))\
  ;   +";  ~F8~e2= ~F21~ "+sprintf("%4.2f",meff(i,1)),0.12,0.98-i*0.12,txres)
  end do

  frame(wks)   ; Advance the frame.

;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@pmLegendDisplayMode    = "Never"
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
; --------------------------
  res@vpYF      = 0.99     ; plot on the viewport.
  res@tiYAxisString          = "SOC (g C/m:S:2:N:)"
  map = gsn_xy(wks,x,soc,res) ; 
; --------------------------
  res@vpYF      = 0.87     ; plot on the viewport.
  res@tiYAxisString          = "WDOC (g C/m:S:2:N:)"
  map = gsn_xy(wks,x,wdoc,res) ; 
; --------------------------
  res@vpYF      = 0.75     ; plot on the viewport.
  res@tiYAxisString          = "DDOC (g C/m:S:2:N:)"
  map = gsn_xy(wks,x,ddoc,res) ; 
; --------------------------
  res@vpYF      = 0.63     ; plot on the viewport.
  res@tiYAxisString          = "MIC (g C/m:S:2:N:)"
  map = gsn_xy(wks,x,mic,res) ; 
; --------------------------
  res@vpYF      = 0.51     ; plot on the viewport.
  res@tiYAxisString          = "WENZ (g C/m:S:2:N:)"
  map = gsn_xy(wks,x,wenz,res) ; 
; --------------------------
  res@vpYF      = 0.39     ; plot on the viewport.
  res@tiYAxisString          = "DENZ (g C/m:S:2:N:)"
  map = gsn_xy(wks,x,denz,res) ; 
; --------------------------
  res@vpYF      = 0.27     ; plot on the viewport.
  res@tiYAxisString          = "TOTC (g C/m:S:2:N:)"
  res@tiXAxisOn    = True
  res@tmXBLabelsOn = True
  res@tiXAxisString          = "Time (year)"
  map = gsn_xy(wks,x,totc,res) ; 
;================================================================================
  frame(wks)   ; Advance the frame.
;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@pmLegendDisplayMode    = "Always"
; --------------------------
  res@vpHeightF = 0.25
  res@vpWidthF  = 0.25
  res@vpYF      = 0.99    ; 
  res@xyLineThicknesses       = (/2.0,2.0,2.0,1.0,1.0,1.0,1.0,1.0/)  
  ;res@tiXAxisOn    = False
  ;res@tmXBLabelsOn = False
  res@tmXBPrecision = 2
; --------------------------
  ;res@trYMinF        = -100.0
  ;res@trYMaxF        = 10000.
  res@tiYAxisString          = "Rn (mm)"
  res@xyExplicitLabels = (/"OBS","Model","Prec"/)
  res@vpXF      = 0.08    ; 
  map = gsn_xy(wks,x,rnacc,res) ; 
; --------------------------
  res@xyExplicitLabels = (/"OBS ET","Model ET","Prec"/)
  res@vpXF      = 0.41    ; 
  res@tiYAxisString          = "ET (mm)"
  map = gsn_xy(wks,x,lhacc,res) ; 
; --------------------------
  res@xyExplicitLabels = (/"OBS","Model","P"/)
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  res@vpXF      = 0.74    ; 
  ;res@trYMinF        = -2000.0
  ;res@trYMaxF        = 100.
  map = gsn_xy(wks,x,neeacc,res) ; 
; --------------------------
  res@vpXF      = 0.08    ; 
  res@vpYF      = 0.68    ; 
  res@tiYAxisString          = "Sh (mm)"
  map = gsn_xy(wks,x,shacc,res) ; 
; --------------------------
  res@vpXF      = 0.41    ; 
  res@vpYF      = 0.68    ; 
  res@tiYAxisString          = "SOC (g C/m:S:2:N:)"
  map = gsn_xy(wks,x,totc,res) ; 
;================================================================================
  frame(wks)   ; Advance the frame.
;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@vpHeightF = 0.10
  res@vpWidthF  = 0.42
  res@pmLegendDisplayMode    = "Never"
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0/)  
  res@trXMinF        =0
  res@trXMaxF        =1
  res@tmXBTickSpacingF       = 1/10. ;x(nd-nd0-1)/10
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
; -------------------------
  res@vpXF      = 0.08    ; 
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,0:364),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,0:364),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,0:364),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,0:364),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,0:364),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,0:364),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,0:364),res) ; 
; -------------------------
  res@vpXF      = 0.57    ; 
  b=1
  e=2
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
;================================================================================
  frame(wks)   ; Advance the frame.
;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@vpHeightF = 0.10
  res@vpWidthF  = 0.42
  res@pmLegendDisplayMode    = "Never"
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0/)  
  res@tmXBTickSpacingF       = 1/10. ;x(nd-nd0-1)/10
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
; -------------------------
  res@vpXF      = 0.08    ; 
  b=2
  e=3
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpXF      = 0.57    ; 
  b=3
  e=4
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
;================================================================================
  frame(wks)   ; Advance the frame.
;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@vpHeightF = 0.10
  res@vpWidthF  = 0.42
  res@pmLegendDisplayMode    = "Never"
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0/)  
  res@tmXBTickSpacingF       = 1/10. ;x(nd-nd0-1)/10
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
; -------------------------
  res@vpXF      = 0.08    ; 
  b=4
  e=5
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpXF      = 0.57    ; 
  b=5
  e=6
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
;================================================================================
  frame(wks)   ; Advance the frame.
;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@vpHeightF = 0.10
  res@vpWidthF  = 0.42
  res@pmLegendDisplayMode    = "Never"
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0/)  
  res@tmXBTickSpacingF       = 1/10. ;x(nd-nd0-1)/10
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
; -------------------------
  res@vpXF      = 0.08    ; 
  b=6
  e=7
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpXF      = 0.57    ; 
  b=7
  e=8
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
;================================================================================
  frame(wks)   ; Advance the frame.
;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@vpHeightF = 0.10
  res@vpWidthF  = 0.42
  res@pmLegendDisplayMode    = "Never"
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0/)  
  res@tmXBTickSpacingF       = 1/10. ;x(nd-nd0-1)/10
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
; -------------------------
  res@vpXF      = 0.08    ; 
  b=8
  e=9
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpXF      = 0.57    ; 
  b=9
  e=10
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
;================================================================================
  frame(wks)   ; Advance the frame.
;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@vpHeightF = 0.10
  res@vpWidthF  = 0.42
  res@pmLegendDisplayMode    = "Never"
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0/)  
  res@tmXBTickSpacingF       = 1/10. ;x(nd-nd0-1)/10
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
; -------------------------
  res@vpXF      = 0.08    ; 
  b=10
  e=11
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpXF      = 0.57    ; 
  b=11
  e=12
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
;================================================================================
  frame(wks)   ; Advance the frame.
;================================================================================
  res@gsnFrame = False ; Don't advance frame.
  res@vpHeightF = 0.10
  res@vpWidthF  = 0.42
  res@pmLegendDisplayMode    = "Never"
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0/)  
  res@tmXBTickSpacingF       = 1/10. ;x(nd-nd0-1)/10
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
; -------------------------
  res@vpXF      = 0.08    ; 
  b=12
  e=13
; -------------------------
  res@vpYF      = 0.99    ; 
  res@tiYAxisString          = "NEE (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,nee(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.87    ; 
  res@tiYAxisString          = "RL (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rsleaf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.75    ; 
  res@tiYAxisString          = "TF (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,tf(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.63    ; 
  res@tiYAxisString          = "RH (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,rh(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.51    ; 
  res@tiYAxisString          = "QCO2 (gC/m:S:2:N:)"
  map = gsn_xy(wks,x,qco2(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.39    ; 
  res@tiYAxisString          = "SM 3L (m3/m3)"
  map = gsn_xy(wks,x,sm(:,365*b-1:365*e-1),res) ; 
; -------------------------
  res@vpYF      = 0.27    ; 
  res@tiYAxisString          = "ST 3L (K)"
  map = gsn_xy(wks,x,st(:,365*b-1:365*e-1),res) ; 
; -------------------------
;================================================================================
  frame(wks)   ; Advance the frame.
end
