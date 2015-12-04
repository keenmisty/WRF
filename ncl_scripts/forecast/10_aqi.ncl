load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"

begin

; Make a list of all files we are interested in
;  DATADir = "/home/liuym/drawncl/"
;  FILES = systemfunc (" ls -1 " + DATADir + "wrfout_d03_* ")
;  numFILES = dimsizes(FILES)
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
  wks = gsn_open_wks(type,outgraphdir + "out_aqi")

  res = True                           ; Set up some basic plot resources
;  res@MainTitle = "AQI"
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
  
  PM10  = a->PM10(:,0,:,:)
  PM25   = a->PM2_5_DRY(:,0,:,:)
  so2   = a->so2(:,0,:,:)
  no2   = a->no2(:,0,:,:)
  o3    = a->o3(:,0,:,:)
  co    = a->co(:,0,:,:)

  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)
  luindex = wrf_user_getvar(a,"LU_INDEX",-1)
  ni = dimsizes(luindex(0,:,0))
  nj = dimsizes(luindex(0,0,:))
  print(ni)
  print(nj)
  T = a->T(:,0,:,:)
  P = a->P(:,0,:,:)
  PB = a->PB(:,0,:,:)
  t = (T+300)/((101325/(P+PB))^(287/1005))

  SO2 = so2*64*(P+PB)*273.15/22.4/101325/t*1000
;print(SO2)
  print(dimsizes(SO2))
  NO2 = no2*46*(P+PB)*273.15/22.4/101325/t*1000
  O3 = o3*48*(P+PB)*273.15/22.4/101325/t*1000  ; convert ppmv to mg/m3
  CO = co*28*(P+PB)*273.15/22.4/101325/t

  SO2AQI=SO2
  
; SO2
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if (SO2(tt,i,j).le.150) then
          SO2AQI(tt,i,j) = SO2(tt,i,j)*50/150
        if ((SO2(tt,i,j).gt.150).and.(SO2(tt,i,j).le.500)) then
          SO2AQI(tt,i,j) = (SO2(tt,i,j)-150)*50/350+50
        if ((SO2(tt,i,j).gt.500).and.(SO2(tt,i,j).le.650)) then
          SO2AQI(tt,i,j) = (SO2(tt,i,j)-500)*50/150+100
        else
          SO2AQI(tt,i,j) = (SO2(tt,i,j)-650)*50/150+150
        end if
        end if
        end if
      end do
    end do
  end do


  NO2AQI = NO2
; NO2
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if (NO2(tt,i,j).le.100) then
          NO2AQI(tt,i,j) = NO2(tt,i,j)*50/100
        if ((NO2(tt,i,j) .gt. 100) .and. (NO2(tt,i,j) .le. 200)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-100)*50/100+50
        if ((NO2(tt,i,j) .gt. 200) .and. (NO2(tt,i,j) .le. 700)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-200)*50/500+100
        if ((NO2(tt,i,j) .gt. 700) .and. (NO2(tt,i,j) .le. 1200)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-700)*50/500+150
        if ((NO2(tt,i,j) .gt. 1200) .and. (NO2(tt,i,j) .le. 2340)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-1200)*100/1140+200
        if ((NO2(tt,i,j) .gt. 2340) .and. (NO2(tt,i,j) .le. 3090)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-2340)*100/750+300
        else
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-30900)*100/750+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do


  COAQI = CO
; CO
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if (CO(tt,i,j).le.5) then
          COAQI(tt,i,j) = CO(tt,i,j)*50/5
        if ((CO(tt,i,j) .gt. 5) .and. (CO(tt,i,j) .le. 10)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-5)*50/5+50
        if ((CO(tt,i,j) .gt. 10) .and. (CO(tt,i,j) .le. 35)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-10)*50/25+100
        if ((CO(tt,i,j) .gt. 35) .and. (CO(tt,i,j) .le. 60)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-35)*50/25+150
        if ((CO(tt,i,j) .gt. 60) .and. (CO(tt,i,j) .le. 90)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-60)*100/30+200
        if ((CO(tt,i,j) .gt. 90) .and. (CO(tt,i,j) .le. 120)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-90)*100/30+300
        else
          COAQI(tt,i,j) = (CO(tt,i,j)-120)*100/30+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do


  O3AQI = O3
; O3
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if (O3(tt,i,j).le. 160) then
          O3AQI(tt,i,j) = O3(tt,i,j)*50/160
        if ((O3(tt,i,j) .gt. 160) .and. (O3(tt,i,j) .le. 200)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-160)*50/40+50
        if ((O3(tt,i,j) .gt. 200) .and. (O3(tt,i,j) .le. 300)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-200)*50/100+100
        if ((O3(tt,i,j) .gt. 300) .and. (O3(tt,i,j) .le. 400)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-300)*50/100+150
        if ((O3(tt,i,j) .gt. 400) .and. (O3(tt,i,j) .le. 800)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-400)*100/400+200
        if ((O3(tt,i,j) .gt. 800) .and. (O3(tt,i,j) .le. 1000)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-800)*100/200+300
        else
          O3AQI(tt,i,j) = (O3(tt,i,j)-1000)*100/200+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do


  PM10AQI = PM10
; PM10
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if (PM10(tt,i,j).le. 50) then
          PM10AQI(tt,i,j) = PM10(tt,i,j)*50/50
        if ((PM10(tt,i,j) .gt. 50) .and. (PM10(tt,i,j) .le. 150)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-50)*50/100+50
        if ((PM10(tt,i,j) .gt. 150) .and. (PM10(tt,i,j) .le. 250)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-150)*50/100+100
        if ((PM10(tt,i,j) .gt. 250) .and. (PM10(tt,i,j) .le. 350)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-250)*50/100+150
        if ((PM10(tt,i,j) .gt. 350) .and. (PM10(tt,i,j) .le. 420)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-350)*100/70+200
        if ((PM10(tt,i,j) .gt. 420) .and. (PM10(tt,i,j) .le. 500)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-420)*100/80+300
        else
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-500)*100/100+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do


  PM25AQI = PM25
; PM25
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if (PM25(tt,i,j) .le. 35) then
          PM25AQI(tt,i,j) = PM25(tt,i,j)*50/35
        if ((PM25(tt,i,j) .gt. 35) .and. (PM25(tt,i,j) .le. 75)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-35)*50/40+50
        if ((PM25(tt,i,j) .gt. 75) .and. (PM25(tt,i,j) .le. 115)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-75)*50/40+100
        if ((PM25(tt,i,j) .gt. 115) .and. (PM25(tt,i,j) .le. 150)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-115)*50/35+150
        if ((PM25(tt,i,j) .gt. 150) .and. (PM25(tt,i,j) .le. 250)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-150)*100/100+200
        if ((PM25(tt,i,j) .gt. 250) .and. (PM25(tt,i,j) .le. 350)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-250)*100/100+300
        else
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-350)*100/150+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do

  AQI=SO2
; AQI
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        f = (/SO2AQI(tt,i,j),NO2AQI(tt,i,j),COAQI(tt,i,j),O3AQI(tt,i,j),PM10AQI(tt,i,j),PM25AQI(tt,i,j)/)
        AQI(tt,i,j) = max(f)
      end do
    end do
  end do


;  AQI@description = "Air Quality Index"

;  times = a->Times
  print(times)
;  ozone@description = "O3 concentration"
;  ozone@units = "ppmv"                    ; Make sure the units match

; Plotting options for O3
  opts = res
  opts@cnFillOn = True
  opts@cnLinesOn = True
  opts@ContourParameters = (/ 0.,200,10/)  ; ensure plot levels are always the same
;  opts@cnLineLabelBackgroundColor = -1
;  opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map 
 
  do ifil = 0,ntimes-1
     pltres@CommonTitle = True
     pltres@PlotTitle = "Air Quality Index Simulation Result at " + times(ifil) + " UTC"
    contour = wrf_contour(a,wks,AQI(ifil,:,:),opts)
    plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
    chinamap = add_china_map(wks,plot,cnres)
    draw(plot)
    frame(wks)
  end do

  else

  a = addfiles(FILES+".nc","r")

  PM10  = a[:]->PM10(:,0,:,:)
  PM25   = a[:]->PM2_5_DRY(:,0,:,:)
  so2   = a[:]->so2(:,0,:,:)
  no2   = a[:]->no2(:,0,:,:)
  o3    = a[:]->o3(:,0,:,:)
  co    = a[:]->co(:,0,:,:)

  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)
  luindex = wrf_user_getvar(a,"LU_INDEX",-1)
  ni = dimsizes(luindex(0,:,0))
  nj = dimsizes(luindex(0,0,:))
  print(ni)
  print(nj)

  T = a[:]->T(:,0,:,:)
  P = a[:]->P(:,0,:,:)
  PB = a[:]->PB(:,0,:,:)
  t = (T+300)/((101325/(P+PB))^(287/1005))

  SO2 = so2*64*(P+PB)*273.15/22.4/101325/t*1000
  NO2 = no2*46*(P+PB)*273.15/22.4/101325/t*1000
  O3 = o3*48*(P+PB)*273.15/22.4/101325/t*1000  ; convert ppmv to mg/m3
  CO = co*28*(P+PB)*273.15/22.4/101325/t

  SO2AQI=SO2
  
; SO2
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if ((SO2(tt,i,j) .ge. 0) .and. (SO2(tt,i,j) .le. 150)) then
          SO2AQI(tt,i,j) = SO2(tt,i,j)*50/150
        if ((SO2(tt,i,j) .gt. 150) .and. (SO2(tt,i,j) .le. 500)) then
          SO2AQI(tt,i,j) = (SO2(tt,i,j)-150)*50/350+50
        if ((SO2(tt,i,j) .gt. 500) .and. (SO2(tt,i,j) .le. 650)) then
          SO2AQI(tt,i,j) = (SO2(tt,i,j)-500)*50/150+100
        else
          SO2AQI(tt,i,j) = (SO2(tt,i,j)-650)*50/150+150
        end if
        end if
        end if
      end do
    end do
  end do


  NO2AQI = NO2
; NO2
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if ((NO2(tt,i,j) .ge. 0) .and. (NO2(tt,i,j) .le. 100)) then
          NO2AQI(tt,i,j) = NO2(tt,i,j)*50/100
        if ((NO2(tt,i,j) .gt. 100) .and. (NO2(tt,i,j) .le. 200)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-100)*50/100+50
        if ((NO2(tt,i,j) .gt. 200) .and. (NO2(tt,i,j) .le. 700)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-200)*50/500+100
        if ((NO2(tt,i,j) .gt. 700) .and. (NO2(tt,i,j) .le. 1200)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-700)*50/500+150
        if ((NO2(tt,i,j) .gt. 1200) .and. (NO2(tt,i,j) .le. 2340)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-1200)*100/1140+200
        if ((NO2(tt,i,j) .gt. 2340) .and. (NO2(tt,i,j) .le. 3090)) then
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-2340)*100/750+300
        else
          NO2AQI(tt,i,j) = (NO2(tt,i,j)-30900)*100/750+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do


  COAQI = CO
; CO
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if ((CO(tt,i,j) .ge. 0) .and. (CO(tt,i,j) .le. 5)) then
          COAQI(tt,i,j) = CO(tt,i,j)*50/5
        if ((CO(tt,i,j) .gt. 5) .and. (CO(tt,i,j) .le. 10)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-5)*50/5+50
        if ((CO(tt,i,j) .gt. 10) .and. (CO(tt,i,j) .le. 35)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-10)*50/25+100
        if ((CO(tt,i,j) .gt. 35) .and. (CO(tt,i,j) .le. 60)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-35)*50/25+150
        if ((CO(tt,i,j) .gt. 60) .and. (CO(tt,i,j) .le. 90)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-60)*100/30+200
        if ((CO(tt,i,j) .gt. 90) .and. (CO(tt,i,j) .le. 120)) then
          COAQI(tt,i,j) = (CO(tt,i,j)-90)*100/30+300
        else
          COAQI(tt,i,j) = (CO(tt,i,j)-120)*100/30+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do


  O3AQI = O3
; O3
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if ((O3(tt,i,j) .ge. 0) .and. (O3(tt,i,j) .le. 160)) then
          O3AQI(tt,i,j) = O3(tt,i,j)*50/160
        if ((O3(tt,i,j) .gt. 160) .and. (O3(tt,i,j) .le. 200)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-160)*50/40+50
        if ((O3(tt,i,j) .gt. 200) .and. (O3(tt,i,j) .le. 300)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-200)*50/100+100
        if ((O3(tt,i,j) .gt. 300) .and. (O3(tt,i,j) .le. 400)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-300)*50/100+150
        if ((O3(tt,i,j) .gt. 400) .and. (O3(tt,i,j) .le. 800)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-400)*100/400+200
        if ((O3(tt,i,j) .gt. 800) .and. (O3(tt,i,j) .le. 1000)) then
          O3AQI(tt,i,j) = (O3(tt,i,j)-800)*100/200+300
        else
          O3AQI(tt,i,j) = (O3(tt,i,j)-1000)*100/200+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do


  PM10AQI = PM10
; PM10
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        if ((PM10(tt,i,j) .ge. 0) .and. (PM10(tt,i,j) .le. 50)) then
          PM10AQI(tt,i,j) = PM10(tt,i,j)*50/50
        if ((PM10(tt,i,j) .gt. 50) .and. (PM10(tt,i,j) .le. 150)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-50)*50/100+50
        if ((PM10(tt,i,j) .gt. 150) .and. (PM10(tt,i,j) .le. 250)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-150)*50/100+100
        if ((PM10(tt,i,j) .gt. 250) .and. (PM10(tt,i,j) .le. 350)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-250)*50/100+150
        if ((PM10(tt,i,j) .gt. 350) .and. (PM10(tt,i,j) .le. 420)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-350)*100/70+200
        if ((PM10(tt,i,j) .gt. 420) .and. (PM10(tt,i,j) .le. 500)) then
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-420)*100/80+300
        else
          PM10AQI(tt,i,j) = (PM10(tt,i,j)-500)*100/100+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do


  PM25AQI = PM25
; PM25
  do tt=0,ntimes-1
    do i=0,ni
      do j=0,nj
        if ((PM25(tt,i,j) .ge. 0) .and. (PM25(tt,i,j) .le. 35)) then
          PM25AQI(tt,i,j) = PM25(tt,i,j)*50/35
        if ((PM25(tt,i,j) .gt. 35) .and. (PM25(tt,i,j) .le. 75)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-35)*50/40+50
        if ((PM25(tt,i,j) .gt. 75) .and. (PM25(tt,i,j) .le. 115)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-75)*50/40+100
        if ((PM25(tt,i,j) .gt. 115) .and. (PM25(tt,i,j) .le. 150)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-115)*50/35+150
        if ((PM25(tt,i,j) .gt. 150) .and. (PM25(tt,i,j) .le. 250)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-150)*100/100+200
        if ((PM25(tt,i,j) .gt. 250) .and. (PM25(tt,i,j) .le. 350)) then
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-250)*100/100+300
        else
          PM25AQI(tt,i,j) = (PM25(tt,i,j)-350)*100/150+400
        end if
        end if
        end if
        end if
        end if
        end if
      end do
    end do
  end do

  AQI=SO2
; AQI
  do tt=0,ntimes-1
    do i=0,ni-1
      do j=0,nj-1
        f = (/SO2AQI(tt,i,j),NO2AQI(tt,i,j),COAQI(tt,i,j),O3AQI(tt,i,j),PM10AQI(tt,i,j),PM25AQI(tt,i,j)/)
        AQI(tt,i,j) = max(f)
      end do
    end do
  end do


;  AQI@description = "Air Quality Index"

;  times = a[:]->Times
  print(times)
;  ozone@description = "O3 concentration"
;  ozone@units = "ppmv"                    ; Make sure the units match

; Plotting options for O3
  opts = res
  opts@cnFillOn = True
  opts@cnLinesOn = True
  opts@ContourParameters = (/ 0.,200,10/)  ; ensure plot levels are always the same
;  opts@cnLineLabelBackgroundColor = -1
;  opts@gsnSpreadColorEnd = -3  ; End third from the last color in color map 
 
  do ifil = 0,ntimes-1
     pltres@CommonTitle = True
     pltres@PlotTitle = "Air Quality Index Simulation Result at " + times(ifil) + " UTC"
    contour = wrf_contour(a[ifil],wks,AQI(ifil,:,:),opts)
    plot = wrf_map_overlays(a[ifil],wks,(/contour/),pltres,mpres)
    chinamap = add_china_map(wks,plot,cnres)
    draw(plot)
    frame(wks)
  end do

  end if

 cmd = "convert -trim +repage out_aqi.png out_aqi.png"
 system(cmd)
 
end
