;   Example script to produce plots for a WRF real-data run,
;   with the ARW coordinate dynamics option.
;   Interpolating to specified pressure levels

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"

begin
;
; change the wrf-output dir & name here. by changming            ;*
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
  wks = gsn_open_wks(type,outgraphdir + "out_850hPa_Level")

; Set some Basic Plot options
  res = True
;  res@MainTitle                   = "REAL-TIME WRF"
  res@Footer = False
  res@InitTime = False

  pltres = True
  mpres = True
  mpres@mpGeophysicalLineColor      = "Black"
  mpres@mpNationalLineColor         = "Black"
  mpres@mpUSStateLineColor          = "Black"
  mpres@mpGridLineColor             = "Black"
  mpres@mpLimbLineColor             = "Black"
  mpres@mpPerimLineColor            = "Black"
  mpres@mpGeophysicalLineThicknessF = 2.0
  mpres@mpGridLineThicknessF        = 2.0
  mpres@mpLimbLineThicknessF        = 2.0
  mpres@mpNationalLineThicknessF    = 2.0
  mpres@mpUSStateLineThicknessF     = 2.0

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What times and how many time steps are in the data set?
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

; The specific pressure levels that we want the data interpolated to.
;  pressure_levels = (/ 850., 700., 500., 300./)   ; pressure levels to plot
  pressure_levels = (/ 850./)
  nlevels         = dimsizes(pressure_levels)     ; number of pressure levels

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  do it = 0,ntimes-1             ; TIME LOOP

    print("Working on time: " + times(it) )
;    res@TimeLabel = times(it)   ; Set Valid time to use on plots
     pltres@CommonTitle = True
     pltres@PlotTitle = "Wind, T, RH Simulation Result at 850hPa & " + times(it) + " UTC"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need        

    tc = wrf_user_getvar(a,"tc",it)        ; T in C
    u  = wrf_user_getvar(a,"ua",it)        ; u averaged to mass points
    v  = wrf_user_getvar(a,"va",it)        ; v averaged to mass points
    p  = wrf_user_getvar(a, "pressure",it) ; pressure is our vertical coordinate
    z  = wrf_user_getvar(a, "z",it)        ; grid point height
    rh = wrf_user_getvar(a,"rh",it)        ; relative humidity

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    do level = 0,nlevels-1                 ; LOOP OVER LEVELS

      pressure = pressure_levels(level)

      tc_plane = wrf_user_intrp3d(tc,p,"h",pressure,0.,False)
      z_plane  = wrf_user_intrp3d( z,p,"h",pressure,0.,False)
      rh_plane = wrf_user_intrp3d(rh,p,"h",pressure,0.,False)
      u_plane  = wrf_user_intrp3d( u,p,"h",pressure,0.,False)
      v_plane  = wrf_user_intrp3d( v,p,"h",pressure,0.,False)

      spd     = (u_plane*u_plane + v_plane*v_plane)^(0.5) ; m/sec
      spd@description = "Wind Speed"
      spd@units = "m/s"
;      u_plane = u_plane*1.94386     ; kts
;      v_plane = v_plane*1.94386     ; kts
      u_plane@units = "m/s"
      v_plane@units = "m/s"


      ; Plotting options for T                
        opts = res                          
        opts@cnLineColor = "Red"
        opts@ContourParameters = (/ 5.0 /)
        opts@cnInfoLabelOrthogonalPosF = 0.07  ; offset second label information
        opts@gsnContourLineThicknessesScale = 2.0
        if (numFILES.eq.1) then
        contour_tc = wrf_contour(a,wks,tc_plane,opts)
        else
        contour_tc = wrf_contour(a[it],wks,tc_plane,opts)
        end if
        delete(opts)


      ; Plotting options for RH                
        opts = res                          
        opts@cnFillOn = True  
        opts@pmLabelBarOrthogonalPosF = -0.1
        opts@ContourParameters = (/ 10., 90., 10./)
        opts@cnFillColors = (/"White","White","White", \
                              "White","Chartreuse","Green",\
                              "Green3","Green4", \
                              "ForestGreen","PaleGreen4"/)
        if (numFILES.eq.1) then
        contour_rh = wrf_contour(a,wks,rh_plane,opts)
        else
        contour_rh = wrf_contour(a[it],wks,rh_plane,opts)
        end if
        delete(opts)


      ; Plotting options for Wind Speed                
        opts = res                          
        opts@cnLineColor = "MediumSeaGreen"
        opts@ContourParameters = (/ 10. /)
        opts@cnInfoLabelOrthogonalPosF = 0.07  ; offset second label information
        opts@gsnContourLineThicknessesScale = 3.0
        if (numFILES.eq.1) then
        contour_spd = wrf_contour(a,wks,spd,opts)
        else
        contour_spd = wrf_contour(a[it],wks,spd,opts)
        end if
        delete(opts)


      ; Plotting options for Wind Vectors                 
        opts = res          
        opts@FieldTitle = "Wind"   ; overwrite Field Title
        opts@NumVectors = 47       ; wind barb density
        if (numFILES.eq.1) then
        vector = wrf_vector(a,wks,u_plane,v_plane,opts)
        else
        vector = wrf_vector(a[it],wks,u_plane,v_plane,opts)
        end if
        delete(opts)


      ; Plotting options for Geopotential Heigh
        opts_z = res                          
        opts_z@cnLineColor = "Blue"
        opts_z@gsnContourLineThicknessesScale = 3.0


      ; MAKE PLOTS                                       

        if ( pressure .eq. 850 ) then   ; plot temp, rh, height, wind barbs
          opts_z@ContourParameters = (/ 20.0 /)
          if (numFILES.eq.1) then
          contour_height = wrf_contour(a,wks,z_plane,opts_z)
          plot = wrf_map_overlays(a,wks,(/contour_rh,contour_tc,contour_height, \
                                    vector/),pltres,mpres)
          else
          contour_height = wrf_contour(a[it],wks,z_plane,opts_z)
          plot = wrf_map_overlays(a[it],wks,(/contour_rh,contour_tc,contour_height, \
                                    vector/),pltres,mpres)
          end if
        end if

;        if ( pressure .eq. 700 ) then   ; plot temp, height, wind barbs
;          opts_z@ContourParameters = (/ 30.0 /)
;          contour_height = wrf_contour(a[it],wks, z_plane,opts_z)
;          plot = wrf_map_overlays(a[it],wks,(/contour_tc,contour_height, \
;                                    vector/),pltres,mpres)
;        end if

;        if ( pressure .eq. 500 ) then   ; plot temp, height, wind barbs
;          opts_z@ContourParameters = (/ 60.0 /)
;          contour_height = wrf_contour(a[it],wks, z_plane,opts_z)
;          plot = wrf_map_overlays(a[it],wks,(/contour_tc,contour_height, \
;                                    vector/),pltres,mpres)
;        end if

;       if ( pressure .eq. 300 ) then   ; plot windspeed, height, wind barbs
;          opts_z@ContourParameters = (/ 60.0 /)
;          contour_height = wrf_contour(a[it],wks, z_plane,opts_z)
;          plot = wrf_map_overlays(a[it],wks,(/contour_spd,contour_height, \
;                                    vector/),pltres,mpres)
;        end if
        chinamap = add_china_map(wks,plot,cnres)
        draw(plot)
        frame(wks)
        delete(opts_z)
    end do      ; END OF LEVEL LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  end do        ; END OF TIME LOOP

end

