load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"

begin

; Make a list of all files we are interested in
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
  type = "png"    
  wks = gsn_open_wks(type,outgraphdir + "out_no2")

  res = True                           ; Set up some basic plot resources
;  res@MainTitle = "O3"
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


  if (numFILES.eq.1) then
  a = addfile(FILES+".nc","r")
  else
  a = addfiles(FILES+".nc","r")
  end if

  T2 = wrf_user_getvar(a,"T2",-1)
  PSFC = wrf_user_getvar(a,"PSFC",-1)
  slp = wrf_user_getvar(a,"slp",-1)    ; slp
    wrf_smooth_2d( slp, 3 )            ; smooth slp
  tc = wrf_user_getvar(a,"tc",-1)      ; 3D tc
  u10 = wrf_user_getvar(a,"U10",-1)    ; u at 10 m, mass point
  v10 = wrf_user_getvar(a,"V10",-1)    ; v at 10 m, mass point
    u10@units = "m/s"
    v10@units = "m/s"
;  PM10  = a[:]->PM10
;  PM2   = a[:]->PM2_5_DRY
;  SO2   = a[:]->so2
;  NO2   = a[:]->no2(:,0,:,:)
  if (numFILES.eq.1) then
  NO2 = a->no2(:,0,:,:)
  else
  NO2 = a[:]->no2(:,0,:,:)
  end if
;  O3    = a[:]->o3(1:139,0,:,:)
;  O3 = a[:]->o3(:,0,:,:)
  notwo = 1000*46/22.4*NO2*(273.15/T2)*(PSFC/101325)  ; convert ppmv to mg/m3
;  times = a[:]->Times
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)
  print(times)
;  ozone = a->o3   ; Get sea level pressure from file
  notwo@units = "ug/m3"                    ; Make sure the units match

  do ifil = 0,ntimes-1
;    print("Working on time: " + times(ifil) )
;    res@TimeLabel = times(ifil)
     pltres@CommonTitle = True
     pltres@PlotTitle = "Nitrogen Dioxide Simulation Result at " + times(ifil) + " UTC"

  if (numFILES.eq.1) then

    opts = res
    opts@cnFillOn = True
    opts@ContourParameters = (/ 0.,200.,2. /)  ; ensure plot levels are always the same
    contour = wrf_contour(a,wks,notwo(ifil,:,:),opts)
    delete(opts)

    ; Plotting options for Wind Vectors
      opts = res
      opts@FieldTitle = "Wind"       ; overwrite Field Title
      opts@NumVectors = 47           ; density of wind barbs
      vector = wrf_vector(a,wks,u10(ifil,:,:),v10(ifil,:,:),opts)
      delete(opts)

    plot = wrf_map_overlays(a,wks,(/contour,vector/),pltres,mpres)
    chinamap = add_china_map(wks,plot,cnres)
    draw(plot)
    frame(wks)

  else

    opts = res
    opts@cnFillOn = True
    opts@ContourParameters = (/ 0.,200.,2. /)  ; ensure plot levels are always the same
    contour = wrf_contour(a[ifil],wks,notwo(ifil,:,:),opts)
    delete(opts)

    ; Plotting options for Wind Vectors
      opts = res
      opts@FieldTitle = "Wind"       ; overwrite Field Title
      opts@NumVectors = 47           ; density of wind barbs
      vector = wrf_vector(a[ifil],wks,u10(ifil,:,:),v10(ifil,:,:),opts)
      delete(opts)

    plot = wrf_map_overlays(a[ifil],wks,(/contour,vector/),pltres,mpres)
    chinamap = add_china_map(wks,plot,cnres)
    draw(plot)
    frame(wks)

  end if
  end do
   
end

