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

     nb = 0
     ne = 100
     n0 = 366 *ne


     n=n0
;****************************************************************************
;read in data
;****************************************************************************
     data_sim1 = asciiread("../../Run/fort.50",(/n0,1/),"float")
     data_sim2 = asciiread("../../Run/fort.51",(/n0,4/),"float")
     data_sim3 = asciiread("../../Run/fort.52",(/n0,4/),"float")
     data_sim4 = asciiread("../../Run/fort.53",(/n0,4/),"float")
     data_sim5 = asciiread("../../Run/fort.54",(/n0,4/),"float")
     data_sim6 = asciiread("../../Run/fort.55",(/n0,4/),"float")
     data_sim7 = asciiread("../../Run/fort.56",(/n0,4/),"float")

     stock  = new((/1,n/),float)
     stock(0,:) = data_sim1(:,0) 

     var1  = new((/4,n/),float)
     var1(0,:) = data_sim2(:,0) 
     var1(1,:) = data_sim2(:,1) 
     var1(2,:) = data_sim2(:,2) 
     var1(3,:) = data_sim2(:,3) 
     ;var1(1,:) = data_sim2(:,4) 
     ;var1(2,:) = data_sim2(:,5) 

     var2  = new((/4,n/),float)
     var2(0,:) = data_sim3(:,0) 
     var2(1,:) = data_sim3(:,1) 
     var2(2,:) = data_sim3(:,2) 
     var2(3,:) = data_sim3(:,3) 
     ;var2(1,:) = data_sim3(:,4) 
     ;var2(2,:) = data_sim3(:,5) 

     var3  = new((/4,n/),float)
     var3(0,:) = data_sim4(:,0) 
     var3(1,:) = data_sim4(:,1) 
     var3(2,:) = data_sim4(:,2) 
     var3(3,:) = data_sim4(:,3) 
     ;var3(1,:) = data_sim4(:,4) 
     ;var3(2,:) = data_sim4(:,5) 

     var4  = new((/4,n/),float)
     var4(0,:) = data_sim5(:,0) 
     var4(1,:) = data_sim5(:,1) 
     var4(2,:) = data_sim5(:,2) 
     var4(3,:) = data_sim5(:,3) 
     ;var4(1,:) = data_sim5(:,4) 
     ;var4(2,:) = data_sim5(:,5) 

     var5  = new((/4,n/),float)
     var5(0,:) = data_sim6(:,0) 
     var5(1,:) = data_sim6(:,1) 
     var5(2,:) = data_sim6(:,2) 
     var5(3,:) = data_sim6(:,3) 
     ;var5(1,:) = data_sim6(:,4) 
     ;var5(2,:) = data_sim6(:,5) 

     var6  = new((/4,n/),float)
     var6(0,:) = data_sim7(:,0) 
     var6(1,:) = data_sim7(:,1) 
     var6(2,:) = data_sim7(:,2) 
     var6(3,:) = data_sim7(:,3) 
     ;var6(1,:) = data_sim7(:,4) 
     ;var6(2,:) = data_sim7(:,5) 

     x = new(n,float)  ; Define two 1D arrays .
     do i = 0,n-1
        x(i) = i*1./366.
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
  res@tiXAxisFontHeightF     = 0.012       ; Change the font size.
  res@tiYAxisFontHeightF     = 0.012
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
    res@tmXBTickEndF           = n0/366
    res@tmXBTickSpacingF       = n0/366/5.
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
  res@xyLineColors           = (/3,4,5,3,4,5/)     ; Set the line colors.
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
  res@pmLegendSide           = "Top"               ; Change location of
  res@pmLegendParallelPosF   = 0.1                  ; move units right
  res@pmLegendOrthogonalPosF = -0.5                ; move units down
  res@pmLegendWidthF         = 0.35                ; Change width and
  res@pmLegendHeightF        = 0.05               ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .01                 ; label font height

;--------------------------------------------------------------------------
  res@gsnFrame = False ; Don't advance frame.
; --------------------- Label line------------------------------------------------------
; -------------------- Date Range --------------------------------------------------
  res@xyMarkLineModes = (/"Lines","Lines","Lines","Lines","Lines","Lines"/)
;==============================================================================
 res@pmLegendDisplayMode    = "Always"

  res@trXMinF        = nb ;0
  res@trXMaxF        = ne ;n/366
  res@tiXAxisOn    = False
  res@tmXBLabelsOn = False
  res@tiXAxisOn    = True
  res@tmXBLabelsOn = True
  res@vpHeightF = 0.19
  res@vpWidthF  = 0.40
;================================================================================

;  res@pmLegendDisplayMode    = "Never"
   res@pmLegendDisplayMode    = "Always"
   res@pmLegendParallelPosF   = 0.5                ; move units right
   res@pmLegendOrthogonalPosF = 0.45                ; move units down


 

;  res@tmXBMode     = "Explicit"  ; Set tick mark mode.
;  res@tmXBValues    =(/0,365,730,1095,1460,1825/)
;  res@tmXBLabels    =(/"0","1","2","3","4","5"/)

  res@tiXAxisString          = "Time (year)"
;================================================================================
;  res@trYMinF                = 8000
;  res@trYMaxF                = 12000
;  res@tmYLTickSpacingF       = 1000
  res@vpYF      = 0.24     ; plot on the viewport.
  res@vpXF      = 0.10    ; Change the size and location of the
  res@xyExplicitLabels = (/"total C pool", " ","","","",""/)
  res@tiYAxisString          = " Total C (g/m:S:2:N:)"
  map = gsn_xy(wks,x,stock,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@xyExplicitLabels = (/"L1", "L2 ","L3","L4","L5","L6"/)
;  res@trYMinF                = 0
;  res@trYMaxF                = 500
;  res@tmYLTickSpacingF       = 100
  res@vpYF      = 0.99     ; plot on the viewport.
  res@vpXF      = 0.10    ; Change the size and location of the
  res@tiYAxisString          = " SOC  (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var1,res) ; Draw an XY plot with 2 curves.
;------------------------------------------
;  res@trYMinF                = 0
;  res@trYMaxF                = 20
;  res@tmYLTickSpacingF       = 5
  res@vpXF      = 0.58    ; Change the size and location of the
  res@tiYAxisString          = " Wet DOC  (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var2,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.74     ; plot on the viewport.
  res@vpXF      = 0.10    ; Change the size and location of the
;  res@trYMinF                = 0
;  res@trYMaxF                = 100
;  res@tmYLTickSpacingF       = 20
  res@tiYAxisString          = " Dry DOC  (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var3,res) ; Draw an XY plot with 2 curves.
;------------------------------------------
  res@vpXF      = 0.58    ; Change the size and location of the
  res@tiYAxisString          = " MIC  (g/m:S:2:N:)"
;  res@trYMinF                = 0
;  res@trYMaxF                = 20
;  res@tmYLTickSpacingF       = 5
  map = gsn_xy(wks,x,var4,res) ; Draw an XY plot with 2 curves.
;================================================================================
  res@vpYF      = 0.49     ; plot on the viewport.
  res@vpXF      = 0.10    ; Change the size and location of the
;  res@trYMinF                = 0
;  res@trYMaxF                = 5
;  res@tmYLTickSpacingF       = 1
  res@tiYAxisString          = " Wet ENZ  (g/m:S:2:N:)"
  map = gsn_xy(wks,x,var5,res) ; Draw an XY plot with 2 curves.
;------------------------------------------
  res@vpXF      = 0.58    ; Change the size and location of the
  res@tiYAxisString          = " Dry ENZ  (g/m:S:2:N:)"
;  res@trYMinF                = 0
;  res@trYMaxF                = 15
;  res@tmYLTickSpacingF       = 3
  map = gsn_xy(wks,x,var6,res) ; Draw an XY plot with 2 curves.
;================================================================================
;

  frame(wks)   ; Advance the frame.
end

