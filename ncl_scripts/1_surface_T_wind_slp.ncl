load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"

begin
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
;******************************************************************
  numFILES = dimsizes(FILES)
  print("numFILES = " + numFILES)
  print(FILES)
  print (" ")
  if (numFILES.eq.1) then
  a = addfile(FILES+".nc","r")
  else
  a = addfiles(FILES+".nc","r")
  end if
  type = "png"
  wks = gsn_open_wks(type,outgraphdir + "out_Surface_multi_files")          
;****************************************************************
  res = True
;  res@MainTitle                   = "Surface Wind,T,SLP Simulation Result"
  res@Footer = False
  res@InitTime = False
  pltres = True
  mpres = True

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

  colors10=("precip3_16lev")
  gsn_define_colormap(wks,colors10)  ; choose color map

;  a = addfiles(FILES+".nc","r")
;  a = addfile(FILES+".nc","r")
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file
  slp = wrf_user_getvar(a,"slp",-1)    ; slp
  wrf_smooth_2d( slp, 3 )            ; smooth slp
  tc = wrf_user_getvar(a,"tc",-1)      ; 3D tc 
  u  = wrf_user_getvar(a,"ua",-1)      ; 3D U at mass points
  v  = wrf_user_getvar(a,"va",-1)      ; 3D V at mass points
  td2 =  wrf_user_getvar(a,"td2",-1)   ; Td2 in C
  tc2 = wrf_user_getvar(a,"T2",-1)     ; T2 in Kelvin
  u10 = wrf_user_getvar(a,"U10",-1)    ; u at 10 m, mass point
  v10 = wrf_user_getvar(a,"V10",-1)    ; v at 10 m, mass point
  tc2@description = "Surface Temperature"
  tc2@units = "K"
  u10@units = "m/s"
  v10@units = "m/s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  do it = 0,ntimes-1             ; TIME LOOP
    print("Working on time: " + times(it) )
;    res@TimeLabel = times(it)   ; Set Valid time to use on plots
     pltres@CommonTitle = True
     pltres@PlotTitle = "Surface Wind, T, SLP Simulation Result at " + times(it) + " UTC"
 
; Plotting options for T                
      opts = res                         
      opts@cnFillOn = True
;     opts@cnLevelSelectionMode = ""
      opts@ContourParameters = (/ 260., 310., 1./)
;     opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map
      if (numFILES.eq.1) then 
      contour_tc = wrf_contour(a,wks,tc2(it,:,:),opts)
      else
      contour_tc = wrf_contour(a[it],wks,tc2(it,:,:),opts)
      end if
      delete(opts)


; Plotting options for SLP                     
      opts = res         
      opts@cnLineColor = "Blue"
      opts@cnHighLabelsOn = True
      opts@cnLowLabelsOn = True
      opts@ContourParameters = (/ 900., 1100., 4. /)
      opts@cnLineLabelBackgroundColor = -1
      opts@gsnContourLineThicknessesScale = 2.0
      if (numFILES.eq.1) then
      contour_psl = wrf_contour(a,wks,slp(it,:,:),opts)
      else
      contour_psl = wrf_contour(a[it],wks,slp(it,:,:),opts)
      end if
      delete(opts)

; Plotting options for Wind Vectors                 
      opts = res         
      opts@FieldTitle = "Wind"       ; overwrite Field Title
      opts@NumVectors = 47           ; density of wind barbs
      if (numFILES.eq.1) then
      vector = wrf_vector(a,wks,u10(it,:,:),v10(it,:,:),opts)
      else
      vector = wrf_vector(a[it],wks,u10(it,:,:),v10(it,:,:),opts)
      end if
      delete(opts)
  

; MAKE PLOTS
      if (numFILES.eq.1) then                                       
      plot = wrf_map_overlays(a,wks,(/contour_tc,contour_psl,vector/),pltres,mpres)
      else
      plot = wrf_map_overlays(a[it],wks,(/contour_tc,contour_psl,vector/),pltres,mpres)
      end if
      chinamap = add_china_map(wks,plot,cnres)  
      draw(plot)
      frame(wks)
  print(it)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  end do        ; END OF TIME LOOP

end

