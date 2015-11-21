;   Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"

begin
;
; Make a list of all files we are interested in
;******************************************************************
; change the wrf-output dir & name here. by changming
  if (.not.isvar("wrfoutdir")) then
  wrfoutdir = "result/wrf-output/"
  end if
  if (.not.isvar("domain")) then
  domain = 1
  end if
  if (.not.isvar("outgraphdir")) then
  outgraphdir = "./"
  end if
  FILES = systemfunc (" ls -1 " + wrfoutdir + "wrfout_d0" + domain + "_*")
  numFILES = dimsizes(FILES)
  print("numFILES = " + numFILES)
  print(FILES)
  print (" ")
  type = "png"
  wks = gsn_open_wks(type,outgraphdir + "out_Precip_multi_files")            ;*
;****************************************************************

; Set some basic resources
  res = True
;  res@MainTitle = "Total Precipitation Tendency Simulation Result"
  res@Footer = False
  res@InitTime = False
  pltres = True
  mpres = True
  mpres@mpGeophysicalLineColor = "Black"
  mpres@mpNationalLineColor    = "Black"
  mpres@mpUSStateLineColor     = "Black"
  mpres@mpGridLineColor        = "Black"
  mpres@mpLimbLineColor        = "Black"
  mpres@mpPerimLineColor       = "Black"

  pltres@FramePlot            = False
  mpres@mpOutlineOn             = False  ;
  mpres@mpDataBaseVersion       = "MediumRes"
  mpres@mpDataSetName           = "Earth..4"

  cnres           = True
  cnres@china     = True       ;draw china map or not
  cnres@river     = True       ;draw changjiang&huanghe or not
  cnres@province  = True       ;draw province boundary or not
  cnres@nanhai    = False       ;draw nanhai or not
  cnres@diqu      = True       ; draw diqujie or not

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  if (numFILES.eq.1) then
  a = addfile(FILES+".nc","r")
  else 
  a = addfiles(FILES+".nc","r")
  end if

  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

  slp = wrf_user_getvar(a,"slp",-1)  ; slp
  wrf_smooth_2d( slp, 3 )            ; smooth slp

  ; Get non-convective, convective and total precipitation
  rain_exp = wrf_user_getvar(a,"RAINNC",-1)
  rain_con = wrf_user_getvar(a,"RAINC",-1)
  rain_tot = rain_exp + rain_con
  rain_tot@description = "Total Precipitation"

  ; just creating new arrays here
  rain_exp_tend = rain_exp 
  rain_con_tend = rain_con 
  rain_tot_tend = rain_tot 
  rain_exp_tend = 0.0 
  rain_con_tend = 0.0 
  rain_tot_tend = 0.0 
  rain_exp_tend@description = "Explicit Precipitation Tendency"
  rain_con_tend@description = "Param  Precipitation Tendency"
  rain_tot_tend@description = "Precipitation Tendency"

;*********************************************************************************************************************************
  ; Calculate tendency values 
  ; We know our data is available every 3 hours, so setting tend_int to 1 gives 
  ; tendencies for 3 hours, setting it to 2, gives 6hourly tendencies                               
  ; change the tend_int here, if your output data time is not per 3 hours. 
  if (.not.isvar("tend_int")) then
  tend_int = 1
  end if

  do it = tend_int,ntimes-1,tend_int    ; Let's skip the first time as rain is 0 here

  rain_exp_tend(tend_int:ntimes-1:tend_int,:,:) = rain_exp(tend_int:ntimes-1:tend_int,:,:) - rain_exp(0:ntimes-2:tend_int,:,:)
  rain_con_tend(tend_int:ntimes-1:tend_int,:,:) = rain_con(tend_int:ntimes-1:tend_int,:,:) - rain_con(0:ntimes-2:tend_int,:,:)
  rain_tot_tend(tend_int:ntimes-1:tend_int,:,:) = rain_tot(tend_int:ntimes-1:tend_int,:,:) - rain_tot(0:ntimes-2:tend_int,:,:)

    print("Working on time: " + times(it) )
;    res@TimeLabel = times(it)   ; Set Valid time to use on plots
;    res@tiMainString = "Total Precipitation Tendency at" + times(it) + "UTC"
     pltres@CommonTitle = True
     pltres@PlotTitle = "Total Precipitation Tendency at " + times(it) + " UTC"

  ; Plotting options for Sea Level Pressure
    opts_psl = res          
    opts_psl@ContourParameters = (/ 900., 1100., 2. /)
    opts_psl@cnLineColor       = "Blue"
    opts_psl@cnInfoLabelOn     = False
    opts_psl@cnLineLabelFontHeightF = 0.01
    opts_psl@cnLineLabelPerimOn = False
    opts_psl@gsnContourLineThicknessesScale = 1.5
    if (numFILES.eq.1) then
    contour_psl = wrf_contour(a,wks,slp(it,:,:),opts_psl)
    else
    contour_psl = wrf_contour(a[it],wks,slp(it,:,:),opts_psl)
    end if
    delete(opts_psl)
    

  ; Plotting options for Precipitation
    opts_r = res                        
    opts_r@UnitLabel            = "mm"
    opts_r@cnLevelSelectionMode = "ExplicitLevels"
    opts_r@cnLevels             = (/ .1, .2, .4, .8, 1.6, 3.2, 6.4, \
                                    12.8, 25.6, 51.2, 102.4/)
    opts_r@cnFillColors         = (/"White","White","DarkOliveGreen1", \
                                "DarkOliveGreen3","Chartreuse", \
                                    "Chartreuse3","Green","ForestGreen", \
                                    "Yellow","Orange","Red","Violet"/)
    opts_r@cnInfoLabelOn        = False
    opts_r@cnConstFLabelOn      = False
    opts_r@cnFillOn             = True
    

  ; Total Precipitation (color fill)
    if (numFILES.eq.1) then
    contour_tot = wrf_contour(a,wks, rain_tot(it,:,:), opts_r)
    opts_r@SubFieldTitle = "from " + times(it-tend_int) + " to " + times(it)

    contour_tend = wrf_contour(a,wks, rain_tot_tend(it,:,:),opts_r) ; total (color)
    contour_res = wrf_contour(a,wks,rain_exp_tend(it,:,:),opts_r)   ; exp (color)
    opts_r@cnFillOn = False
    opts_r@cnLineColor = "Red4"
    contour_prm = wrf_contour(a,wks,rain_con_tend(it,:,:),opts_r)   ; con (red lines)
    delete(opts_r)
    else
    contour_tot = wrf_contour(a[it],wks, rain_tot(it,:,:), opts_r)

  ; Precipitation Tendencies 
    opts_r@SubFieldTitle = "from " + times(it-tend_int) + " to " + times(it)

    contour_tend = wrf_contour(a[it],wks, rain_tot_tend(it,:,:),opts_r) ; total (color)
    contour_res = wrf_contour(a[it],wks,rain_exp_tend(it,:,:),opts_r)   ; exp (color)
    opts_r@cnFillOn = False
    opts_r@cnLineColor = "Red4"
    contour_prm = wrf_contour(a[it],wks,rain_con_tend(it,:,:),opts_r)   ; con (red lines)
    delete(opts_r)
    end if


  ; MAKE PLOTS                                       

    ; Total Precipitation 
    ;  plot = wrf_map_overlays(a[it],wks,contour_tot,pltres,mpres)
    ;  chinamap = add_china_map(wks,plot,cnres)  
    ;  draw(plot)
    ;  frame(wks)
    ; Total Precipitation Tendency
      if (numFILES.eq.1) then
      plot = wrf_map_overlays(a,wks,(/contour_tend,contour_psl/),pltres,mpres)
      else
      plot = wrf_map_overlays(a[it],wks,(/contour_tend,contour_psl/),pltres,mpres)
      end if
    ;  plot = wrf_map_overlays(a[it],wks,contour_tend,pltres,mpres)
      chinamap = add_china_map(wks,plot,cnres)  
      draw(plot)
      frame(wks)
    ; Non-Convective and Convective Precipiation Tendencies
    ;  plot = wrf_map_overlays(a[it],wks,(/contour_res,contour_prm/),pltres,mpres)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  end do        ; END OF TIME LOOP

end

