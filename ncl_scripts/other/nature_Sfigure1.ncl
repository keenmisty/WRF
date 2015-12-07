load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

function daily_mean(data)
begin

   NC = 18250
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

     n0 = 17520

     n=n0
;****************************************************************************
;read in data
;****************************************************************************
     data_sim1 = asciiread("../../Run/fort.51",(/n0,16/),"float") ;soc
     data_sim2 = asciiread("../../Run/fort.52",(/n0,16/),"float") ;doc
     data_sim3 = asciiread("../../Run/fort.53",(/n0,16/),"float") ;ndoc
     data_sim4 = asciiread("../../Run/fort.54",(/n0,16/),"float") ;mic
     data_sim5 = asciiread("../../Run/fort.55",(/n0,16/),"float") ;enz
     data_sim6 = asciiread("../../Run/fort.56",(/n0,16/),"float") ;nenz

     data_sim1a = asciiread("../../../NoahMP4C/Run/fort.51",(/n0,16/),"float") ;soc
     data_sim2a = asciiread("../../../NoahMP4C/Run/fort.52",(/n0,16/),"float") ;doc
     data_sim3a = asciiread("../../../NoahMP4C/Run/fort.53",(/n0,16/),"float") ;ndoc
     data_sim4a = asciiread("../../../NoahMP4C/Run/fort.54",(/n0,16/),"float") ;mic
     data_sim5a = asciiread("../../../NoahMP4C/Run/fort.55",(/n0,16/),"float") ;enz
     data_sim6a = asciiread("../../../NoahMP4C/Run/fort.56",(/n0,16/),"float") ;nenz

     var1  = new((/2,n/),float)
     var1(0,:) = data_sim1(:,0)+data_sim1(:,1)+data_sim1(:,2)+data_sim1(:,2)*0.02/0.05
     var1(1,:) = data_sim1a(:,0)+data_sim1a(:,1)+data_sim1a(:,2)+data_sim1a(:,2)*0.02/0.05

     var2  = new((/2,n/),float)
     var2(0,:) = data_sim2(:,0)+data_sim2(:,1)+data_sim2(:,2)+data_sim2(:,2)*0.02/0.05
     var2(1,:) = data_sim2a(:,0)+data_sim2a(:,1)+data_sim2a(:,2)+data_sim2a(:,2)*0.02/0.05

     var3  = new((/2,n/),float)
     var3(0,:) = data_sim3(:,0)+data_sim3(:,1)+data_sim3(:,2)+data_sim3(:,2)*0.02/0.05
     var3(1,:) = data_sim3a(:,0)+data_sim3a(:,1)+data_sim3a(:,2)+data_sim3a(:,2)*0.02/0.05

     var4  = new((/2,n/),float)
     var4(0,:) = data_sim4(:,0)+data_sim4(:,1)+data_sim4(:,2)+data_sim4(:,2)*0.02/0.05
     var4(1,:) = data_sim4a(:,0)+data_sim4a(:,1)+data_sim4a(:,2)+data_sim4a(:,2)*0.02/0.05

     var5  = new((/2,n/),float)
     var5(0,:) = data_sim5(:,0)+data_sim5(:,1)+data_sim5(:,2)+data_sim5(:,2)*0.02/0.05
     var5(1,:) = data_sim5a(:,0)+data_sim5a(:,1)+data_sim5a(:,2)+data_sim5a(:,2)*0.02/0.05

     var6  = new((/2,n/),float)
     var6(0,:) = data_sim6(:,0)+data_sim6(:,1)+data_sim6(:,2)+data_sim6(:,2)*0.02/0.05
     var6(1,:) = data_sim6a(:,0)+data_sim6a(:,1)+data_sim6a(:,2)+data_sim6a(:,2)*0.02/0.05

     x = new(n,float)  ; Define two 1D arrays .
     do i = 0,n-1
        x(i) = i*1./48
     end do

       wks = gsn_open_wks("pdf","runoff")  ; Open an X11 workstation.

  cmap = (/(/1.00,1.00,1.00/),(/0.00,0.00,0.00/),(/0.,0.,0./),\
            (/1.0,0.0,0.0/),\  ; Red
            (/0.0,0.6,0.0/),\  ; Green
            (/0.0,0.0,1.0/),\  ; Blue
            (/0.0,0.0,0.0/),\  ; Black
            (/0.6,0.6,0.6/)/)  ; Black

  gsn_define_colormap(wks,cmap)

  res                        = True


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
    res@tmXBMajorLengthF       = 0.008     ; Default is 0.02.
    res@tmXBMajorThicknessF    = 1.0       ; Default is 2.
    res@tmXBMinorLengthF       = 0.0075    ; Default is 0.01.
    res@tmXBMinorPerMajor      = 0         ; # of minor tick marks per major.
    res@tmXBMode               = "Manual"  ; Set tick mark mode.
    res@tmXBTickStartF         = 0
    res@tmXBTickEndF           = n0
    res@tmXBTickSpacingF       = 30.
    res@tmXMajorGridThicknessF = 1.0       ; Default is 2.0
; ------------------- Y- axis ----------------------------------------------------
   res@tmYLLabelFont          = 21        ; See explanations for X axes
   res@tmYLLabelFontHeightF   = 0.01     ; res.
   res@tmYLMajorLengthF       = 0.008
   res@tmYLMajorThicknessF    = 1.0
   res@tmYLMinorPerMajor      = 0
   ;res@tmYRLabelsOn = True
   res@tmYRLabelFont          = 21        ; See explanations for X axes
   res@tmYRLabelFontHeightF   = 0.01     ; res
   res@tmYRMajorLengthF       = 0.008
   res@tmYRMajorThicknessF    = 1.0
   res@tmYRMinorPerMajor      = 0

   res@tmYLMode               = "Manual"
   res@tmYLTickStartF         =  -120000.
   res@tmYLTickEndF           = 120000.
   ;res@tmYRBorderOn           = False    ; Don't draw right axis.
   ;res@tmYROn                 = False    ; Don't draw right axis tick marks.
; ---------------------- line ---------------------------------------------------
;  res@xyLineColors           = (/6,7,5,6/)     ; Set the line colors.
  res@xyLineColors           = (/3,5,5,3,4,5/)     ; Set the line colors.
  res@xyLineThicknesses       = (/1,1,1,1,1,1/)  
  res@xyDashPatterns         = (/0,0,0,2,2,2/) ; 0- solid, 1-dash.
; ------------------ for tick ---------------------------------------------------
;  res@pmTickMarkDisplayMode = "Always"
;  res@pmTickMarkZone        = 2
; --------------for legend ------------------------------------------------------ 
  res@lgLabelsOn = True
  res@lgAutoManage = False
  res@lgLabelFontHeightF = 0.01
  res@lgBoxMajorExtentF = 0.08
  res@lgBoxMinorExtentF = 0.08
  ;res@pmLegendWidthF         = 0.35                ; Change width and
  res@pmLegendHeightF        = 0.04                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around

;--------------------------------------------------------------------------
  res@gsnFrame = False ; Don't advance frame.
; --------------------- Label line------------------------------------------------------
; -------------------- Date Range --------------------------------------------------
  res@xyMarkLineModes = (/"Lines","Lines","Lines","Lines","Lines","Lines"/)
;==============================================================================
 res@pmLegendDisplayMode    = "Always"

  res@trXMinF        = 0
  res@trXMaxF        = n0/48
  res@vpHeightF = 0.12
  res@vpWidthF  = 0.80
;================================================================================

   res@pmLegendDisplayMode    = "Always"
   res@pmLegendOrthogonalPosF = -0.45                ; move units down

  res@vpXF      = 0.10    ; Change the size and location of the
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
;================================================================================
  res@pmLegendParallelPosF   = 0.1                 ; move units right
  res@vpYF      = 0.99     ; plot on the viewport.
  res@xyExplicitLabels = (/"Model 6C", "Model 4C ","L3","L4","L5","L6"/)
;  res@trYMinF                = 740
;  res@trYMaxF                = 940
;  res@tmYLTickSpacingF       = 50
  res@tiYAxisString          = " SOC  (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var1,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendDisplayMode    = "Never"
  res@vpYF      = 0.85     ; plot on the viewport.
;  res@trYMinF                = 0
;  res@trYMaxF                = 80
;  res@tmYLTickSpacingF       = 20
  res@tiYAxisString          = " DRY DOC (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var3,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendParallelPosF   = 0.85                ; move units right
  res@vpYF      = 0.71     ; plot on the viewport.
;  res@trYMinF                = 0
;  res@trYMaxF                = 20
;  res@tmYLTickSpacingF       = 5
  res@tiYAxisString          = " WET DOC  (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var2,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendParallelPosF   = 0.85                ; move units right
  res@vpYF      = 0.57     ; plot on the viewport.
;  res@trYMinF                = 0
;  res@trYMaxF                = 20
;  res@tmYLTickSpacingF       = 5
  res@tiYAxisString          = " MIC  (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var4,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@pmLegendParallelPosF   = 0.85                ; move units right
  res@vpYF      = 0.43     ; plot on the viewport.
;  res@trYMinF                = 0
;  res@trYMaxF                = 20
;  res@tmYLTickSpacingF       = 5
  res@tiYAxisString          = " DRY ENZ  (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var6,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@tiXAxisOn    = True
  res@tmXBLabelsOn = True
  res@vpYF      = 0.29     ; plot on the viewport.
  res@tiYAxisString          = " WET ENZ  (g/m:S:2:N:)"
;  res@trYMinF                = 0
;  res@trYMaxF                = 5
;  res@tmYLTickSpacingF       = 1
  res@tiXAxisString          = "Time (day)"
  map = gsn_xy(wks,x,var5,res) ; Draw an XY plot with 2 curves.
;================================================================================
;

  frame(wks)   ; Advance the frame.
end

