load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"

begin

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
  wks = gsn_open_wks(type,outgraphdir + "out_vis")

  res = True                           ; Set up some basic plot resources
  res@MainTitle = "Visibility"
  res@Footer = False
  res@InitTime = False
  res@cnFillOn = True
  res@gsnSpreadColors = True

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

 colors10=("WhBlGrYeRe")
 gsn_define_colormap(wks,colors10)  ; choose color map

  if (numFILES.eq.1) then
  a = addfile(FILES+".nc","r")
  else
  a = addfiles(FILES+".nc","r")
  end if

  
;  PM10  = a[:]->PM10
;  PM2   = a[:]->PM2_5_DRY
;  SO2   = a[:]->so2
;  NO2   = a[:]->no2
;  O3    = a[:]->o3(1:139,0,:,:)

if (numFILES.eq.1) then

  T = wrf_user_getvar(a,"T",-1)
  P = wrf_user_getvar(a,"P",-1)
  PB = wrf_user_getvar(a,"PB",-1)
  t = (T+300)/((101325/(P+PB))^(287/1005))

  RH = wrf_user_getvar(a,"rh",-1)

  so4aj = wrf_user_getvar(a,"so4aj",-1)
  so4ai = wrf_user_getvar(a,"so4ai",-1)
  ASO4 = (so4aj+so4ai)*(P+PB)/t/287

  no3aj = wrf_user_getvar(a,"no3aj",-1)
  no3ai = wrf_user_getvar(a,"no3ai",-1)
  ANO3 = (no3aj+no3ai)*(P+PB)/t/287

  orgpaj = wrf_user_getvar(a,"orgpaj",-1)
  orgpai = wrf_user_getvar(a,"orgpai",-1)
  APOC = (orgpaj+orgpai)*(P+PB)/t/287

  orgaro1j = wrf_user_getvar(a,"orgaro1j",-1)
  orgaro1i = wrf_user_getvar(a,"orgaro1i",-1)
  orgaro2j = wrf_user_getvar(a,"orgaro2j",-1)
  orgaro2i = wrf_user_getvar(a,"orgaro2i",-1)
  orgalk1j = wrf_user_getvar(a,"orgalk1j",-1)
  orgalk1i = wrf_user_getvar(a,"orgalk1i",-1)
  orgole1j = wrf_user_getvar(a,"orgole1j",-1)
  orgole1i = wrf_user_getvar(a,"orgole1i",-1)
  orgba1j = wrf_user_getvar(a,"orgba1j",-1)
  orgba1i = wrf_user_getvar(a,"orgba1i",-1)
  orgba2j = wrf_user_getvar(a,"orgba2j",-1)
  orgba2i = wrf_user_getvar(a,"orgba2i",-1)
  orgba3j = wrf_user_getvar(a,"orgba3j",-1)
  orgba3i = wrf_user_getvar(a,"orgba3i",-1)
  orgba4j = wrf_user_getvar(a,"orgba4j",-1)
  orgba4i = wrf_user_getvar(a,"orgba4i",-1)
  ASOC = (orgaro1j+orgaro1i+orgaro2j+orgaro2i+orgalk1j+orgalk1i+orgole1j+orgole1i+orgba1j+orgba1i+orgba2j+orgba2i+orgba3j+orgba3i+orgba4j+orgba4i)*(P+PB)/t/287

  ecj = wrf_user_getvar(a,"ecj",-1)
  eci = wrf_user_getvar(a,"eci",-1)
  AEC = (ecj+eci)*(P+PB)/t/287

  soila = wrf_user_getvar(a,"soila",-1)
  ASOIL = soila*(P+PB)/t/287

  antha = wrf_user_getvar(a,"antha",-1)
  ACORS = antha*(P+PB)/t/287

  beta = 2.56*(0.8+0.195*(1-RH/100)^(-1.581))*(ASO4+ANO3)+4.4*(APOC*1.8+ASOC*1.4)^0.7+10*AEC+ASOIL+0.6*ACORS+10

  vis = 3.9/beta*1000
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)
  print(times)
  vis@description = "Visibility"
  vis@units = "km"                    ; Make sure the units match

; Plotting options for O3
  opts = res
  opts@cnFillOn = True
  opts@cnLinesOn = True
;  opts@ContourParameters = (/ 0.,10,1/)  ; ensure plot levels are always the same
;  opts@cnLineLabelBackgroundColor = -1
;  opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map

  do ifil = 0,ntimes-1
    contour = wrf_contour(a,wks,vis(5,0,:,:),opts)
    plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)  
    chinamap = add_china_map(wks,plot,cnres)
    draw(plot)
    frame(wks)
  end do

else
  
  T = wrf_user_getvar(a[:],"T",-1)
  P = wrf_user_getvar(a[:],"P",-1)
  PB = wrf_user_getvar(a[:],"PB",-1)
  t = (T+300)/((101325/(P+PB))^(287/1005))

  RH = wrf_user_getvar(a[:],"rh",-1)

  so4aj = wrf_user_getvar(a[:],"so4aj",-1)
  so4ai = wrf_user_getvar(a[:],"so4ai",-1)
  ASO4 = (so4aj+so4ai)*(P+PB)/t/287

  no3aj = wrf_user_getvar(a[:],"no3aj",-1)
  no3ai = wrf_user_getvar(a[:],"no3ai",-1)
  ANO3 = (no3aj+no3ai)*(P+PB)/t/287

  orgpaj = wrf_user_getvar(a[:],"orgpaj",-1)
  orgpai = wrf_user_getvar(a[:],"orgpai",-1)
  APOC = (orgpaj+orgpai)*(P+PB)/t/287

  orgaro1j = wrf_user_getvar(a[:],"orgaro1j",-1)
  orgaro1i = wrf_user_getvar(a[:],"orgaro1i",-1)
  orgaro2j = wrf_user_getvar(a[:],"orgaro2j",-1)
  orgaro2i = wrf_user_getvar(a[:],"orgaro2i",-1)
  orgalk1j = wrf_user_getvar(a[:],"orgalk1j",-1)
  orgalk1i = wrf_user_getvar(a[:],"orgalk1i",-1)
  orgole1j = wrf_user_getvar(a[:],"orgole1j",-1)
  orgole1i = wrf_user_getvar(a[:],"orgole1i",-1)
  orgba1j = wrf_user_getvar(a[:],"orgba1j",-1)
  orgba1i = wrf_user_getvar(a[:],"orgba1i",-1)
  orgba2j = wrf_user_getvar(a[:],"orgba2j",-1)
  orgba2i = wrf_user_getvar(a[:],"orgba2i",-1)
  orgba3j = wrf_user_getvar(a[:],"orgba3j",-1)
  orgba3i = wrf_user_getvar(a[:],"orgba3i",-1)
  orgba4j = wrf_user_getvar(a[:],"orgba4j",-1)
  orgba4i = wrf_user_getvar(a[:],"orgba4i",-1)
  ASOC = (orgaro1j+orgaro1i+orgaro2j+orgaro2i+orgalk1j+orgalk1i+orgole1j+orgole1i+orgba1j+orgba1i+orgba2j+orgba2i+orgba3j+orgba3i+orgba4j+orgba4i)*(P+PB)/t/287

  ecj = wrf_user_getvar(a[:],"ecj",-1)
  eci = wrf_user_getvar(a[:],"eci",-1)
  AEC = (ecj+eci)*(P+PB)/t/287

  soila = wrf_user_getvar(a[:],"soila",-1)
  ASOIL = soila*(P+PB)/t/287

  antha = wrf_user_getvar(a[:],"antha",-1)
  ACORS = antha*(P+PB)/t/287

  beta = 2.56*(0.8+0.195*(1-RH/100)^(-1.581))*(ASO4+ANO3)+4.4*(APOC*1.8+ASOC*1.4)^0.7+10*AEC+ASOIL+0.6*ACORS+10

  vis = 3.9/beta*1000
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)
  print(times)
  vis@description = "Visibility"
  vis@units = "km"                    ; Make sure the units match

; Plotting options for O3
  opts = res
  opts@cnFillOn = True
  opts@cnLinesOn = True
;  opts@ContourParameters = (/ 0.,10,1/)  ; ensure plot levels are always the same
;  opts@cnLineLabelBackgroundColor = -1
;  opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map 
 
  do ifil = 0,ntimes-1
    contour = wrf_contour(a[ifil],wks,vis(5,0,:,:),opts)
    plot = wrf_map_overlays(a[ifil],wks,(/contour/),pltres,mpres)
    chinamap = add_china_map(wks,plot,cnres)
    draw(plot)
    frame(wks)
  end do

end if

 cmd = "convert -trim +repage out_vis.png out_vis.png"
 system(cmd)
 
end

