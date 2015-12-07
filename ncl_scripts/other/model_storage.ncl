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
 
  nd0 = 0
  nd = 365*14 + 4
  n0   = nd0*48
  n    = nd*48

  data   = asciiread("../../Run/fort.400",(/n,8/),"float")

  x = new(n-n0,float)  ; Define two 1D arrays of 12 elements each.
  do i = 0,n-n0-1
  x(i) = i/48.
  end do

  xd = new(48,float)  ; Define two 1D arrays of 12 elements each.
  do i = 0,47
  xd(i) = i*1/2.
  end do

;        write(400,'(i8,2f8.1,5f7.1)') it,soilcgm,&
;               socgm,wdocgm,ddocgm,micgm,wenzgm,denzgm

  var1 =new((/1,n-n0/),float)
  var1(0,:) = data(n0:n-1,1) 

  var2 =new((/1,n-n0/),float)
  var2(0,:) = data(n0:n-1,2) 

  var3 =new((/1,n-n0/),float)
  var3(0,:) = data(n0:n-1,3) 

  var4=new((/1,n-n0/),float)
  var4(0,:) = data(n0:n-1,4) 

  var5=new((/1,n-n0/),float)
  var5(0,:) = data(n0:n-1,5) 

  var6 =new((/1,n-n0/),float)
  var6(0,:) = data(n0:n-1,6) 

  var7 =new((/1,n-n0/),float)
  var7(0,:) = data(n0:n-1,7)

  ;opt = True
  ;opt@title  = "obs model obs model"
  ;write_matrix (out, "4f12.6", opt)

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
    res@tmXBTickEndF           = nd-nd0-1
    res@tmXBTickSpacingF       = (nd-nd0-1)/10
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
  res@xyLineColors           = (/5,3,5,3/)     ; Set the line colors.
  res@xyLineThicknesses       = (/1.0,1.0,1.0,1.0,1.0/)  
  res@xyDashPatterns         = (/0,0,2,2,0/) ; 0- solid, 1-dash.
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
  res@trXMinF        = 0
  res@trXMaxF        = x(n-n0-1)

  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
  res@vpHeightF = 0.105
  res@vpWidthF  = 0.88
  res@vpXF      = 0.10    ; Change the size and location of the
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  res@vpYF      = 0.99     ; plot on the viewport.
  res@tiYAxisString          = "TOT C (g/m2)"
  ;res@trYMinF        = -20.
  ;res@trYMaxF        = 200.
  ;res@tmYLTickSpacingF       = 50.
  map = gsn_xy(wks,x,var1,res) ; Draw an XY plot with 2 curves.
;================================================================================
  ;res@trYMinF        = -20.
  ;res@trYMaxF        = 200.
  ;res@tmYLTickSpacingF       = 50.
  res@vpYF      = 0.87     ; plot on the viewport.
  res@tiYAxisString          = "SOC (g/m2)"
  map = gsn_xy(wks,x,var2,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendDisplayMode    = "Always"
  res@xyExplicitLabels = (/"Model1","Model2"/)
  ;res@trYMinF        = -10.
  ;res@trYMaxF        = 150.
  ;res@tmYLTickSpacingF       = 40.
  res@vpYF      = 0.75     ; plot on the viewport.
  res@tiYAxisString          = "W DOC (g/m2)"
  map = gsn_xy(wks,x,var3,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  ;res@trYMinF        = -35.
  ;res@trYMaxF        =  35.
  ;res@tmYLTickSpacingF       = 10.
  res@tiYAxisString          = "D DOC (g/m2)"
  res@vpYF      = 0.63    ; plot on the viewport.
  map = gsn_xy(wks,x,var4,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.51     ; plot on the viewport.
  ;res@trYMinF        = 300.
  ;res@trYMaxF        = 550.
  ;res@tmYLTickSpacingF       = 50.
  res@tiYAxisString          = "MIC (g/m2)"
  map = gsn_xy(wks,x,var5,res) ; Draw an XY plot with 2 curves.
;================================================================================
  ;res@trYMinF        = 0.
  ;res@trYMaxF        = 0.4
  ;res@tmYLTickSpacingF       = 0.1
  res@vpYF      = 0.39     ; plot on the viewport.
  res@tiYAxisString          = "W ENZ (g/m2)"
  map = gsn_xy(wks,x,var6,res) ; Draw an XY plot with 2 curves.
;================================================================================
  delete(res@trYMinF) ;        = -6.0
  delete(res@trYMaxF) ;        = 6.0
  delete(res@tmYLTickSpacingF) ;       = 2.
  ;res@trYMinF        = -6.0
  ;res@trYMaxF        = 6.0
  ;res@tmYLTickSpacingF       = 2.
  res@tiYAxisString          = "D ENZ (g/m2)"
  res@vpYF      = 0.15     ; plot on the viewport.
  res@tiXAxisOn    = True
  res@tmXBLabelsOn = True
  res@tiXAxisString          = "Time (day Jan. 1, 2007)"
  map = gsn_xy(wks,x,var7,res) ; Draw an XY plot with 2 curves.
;================================================================================
  ;res@tiYAxisOn    = False
  ;res@tmYLLabelsOn = False
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
;================================================================================
;  frame(wks)   ; Advance the frame.
;  res@gsnFrame = False ; Don't advance frame.
;================================================================================
;  res@vpYF      = 0.99     ; plot on the viewport.
;  res@tiYAxisString          = "SM/ICE (m3/m3)"
;  map = gsn_xy(wks,x,var7,res) ; Draw an XY plot with 2 curves.
;================================================================================
   txres = True
   txres@txFontHeightF = 0.011
   txres@txFontColor = 6
   txres@txFontHeightF = 0.01
   txres@txJust        = "CenterLeft"
   txres@txFuncCode    = "~"          ; Default is ":"

   gsn_text_ndc(wks,"a",0.96,0.98,txres)
   gsn_text_ndc(wks,"b",0.96,0.98-0.12*1,txres)
   gsn_text_ndc(wks,"c",0.96,0.98-0.12*2,txres)
   gsn_text_ndc(wks,"d",0.96,0.98-0.12*3,txres)
   gsn_text_ndc(wks,"e",0.96,0.98-0.12*4,txres)
   gsn_text_ndc(wks,"f",0.96,0.98-0.12*5,txres)

;  do i=0,5
;     gsn_text_ndc(wks,"~F8~e1= ~F21~" + sprintf("%4.2f",meff(i,0))\
;     +";  ~F8~e2= ~F21~ "+sprintf("%4.2f",meff(i,1)),0.12,0.98-i*0.12,txres)
;   end do

  frame(wks)   ; Advance the frame.
end
