load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "/ees/users/EMG/shenchong/draw/ncl/share/gsn_geom.ncl"
load "/ees/users/EMG/shenchong/draw/ncl/share/read_wrf.ncl"

begin

   varname = "so2"
   fls = getenv("dir0")+getenv("fname")
   vr0 = read_wrf_nc(fls,varname)
   fls = getenv("dir1")+getenv("fname")
   vr1 = read_wrf_nc(fls,varname)
   fls = getenv("dir2")+getenv("fname")
   vr2 = read_wrf_nc(fls,varname)
   fls = getenv("dir3")+getenv("fname")
   vr3 = read_wrf_nc(fls,varname)
   fls = getenv("dir4")+getenv("fname")
   vr4 = read_wrf_nc(fls,varname)
   fnc = read_wrf_nc(fls,"nc_file")

  st = 96
  et = 191

  ex0 = dim_avg_n(vr0(st:et,0,:,:),0)
  ex1 = dim_avg_n(vr1(st:et,0,:,:),0)
  ex2 = dim_avg_n(vr2(st:et,0,:,:),0)
  ex3 = dim_avg_n(vr3(st:et,0,:,:),0)
  ex4 = dim_avg_n(vr4(st:et,0,:,:),0)

  df10 = ex1-ex0
  df20 = ex2-ex0
  df30 = ex3-ex0
  df40 = ex4-ex0


; Open graphics file
   color1 = "GreenMagenta16";"gsdtol";"BlueDarkRed18";"hotcold_18lev"
 ;  wks = gsn_open_wks("x11","test")
 ;  gsn_define_colormap(wks,color1);"BlueGreen14");nrl_sirkes");"precip3_16lev")

   wks1 = gsn_open_wks("png","so2")
   gsn_define_colormap(wks1,color1);"BlueGreen14");nrl_sirkes");"precip3_16lev")

   ; Set up some basic plot resources
   pltres = True
   pltres@PanelPlot = True
   pltres@FramePlot = False
   mpres = True
   mpres@mpProjection    = "LambertConformal"
   mpres@mpGridAndLimbOn = False

   cnres = True
   cnres@gsnFrame   = False
   cnres@gsnDraw    = False
   cnres@InitTime   = False
   cnres@Footer     = False
   cnres@vpWidthF   = 1.
   cnres@vpHeightF  = 1.
   cnres@cnFillOn   = True
   cnres@cnLinesOn  = False
   cnres@cnLevelSelectionMode = "ExplicitLevels";"ManualLevels"
   cnres@lbTitleFontHeightF = .025
   cnres@lbLabelFontHeightF = .030


   ; MAKE PLOTS
;   opts = cnres
;   opts@cnLevelSpacingF = 1
;   opts@cnMinLevelValF  = 5
;   opts@cnMaxLevelValF  = 11
;   opts@FieldTitle      = "a)BULK"
;   opts@lbTitleString   = "DTR (deg.C)"
;   DTRS = (maxs-mins)/26
;   print(max(DTRS))
;   plot = wrf_contour(fnc,wks,DTRS,opts)
;   sfc0 = wrf_map_overlays(fnc,wks,(/plot/),pltres,mpres)
;   lns0 = gsn_add_bou3(wks,sfc0)
;   lns1 = gsn_add_bou2(wks,sfc0)
;   delete(opts)

   opts = cnres
;   opts@cnLevelSpacingF = 10
;   opts@cnMinLevelValF  = -40
;   opts@cnMaxLevelValF  = 40
   opts@cnLevels        = (/-100,-85,-70,-50,-30,-10,0/)
   opts@cnFillColors     = (/2,3,4,5,6,7,8,9/)
   opts@FieldTitle      = "a)NOURB-BEP"
   opts@lbTitleString   = "so2 (ppb)"
   plot = wrf_contour(fnc,wks1,df10,opts)
   sfc1 = wrf_map_overlays(fnc,wks1,(/plot/),pltres,mpres)
   lns2 = gsn_add_bou3(wks1,sfc1)
   lns3 = gsn_add_bou2(wks1,sfc1)
   delete(opts)

   pnlres = True
   pnlres@gsnPanelYWhiteSpacePercent = 0
;   gsn_panel(wks,(/sfc0,sfc1/),(/1,2/),pnlres)

   opts = cnres
 ;  opts@cnLevelSpacingF = 10
;   opts@cnMinLevelValF  = -40
;   opts@cnMaxLevelValF  = 40
   opts@cnLevels        = (/-100,-85,-70,-50,-30,-10,0/)
   opts@cnFillColors     = (/2,3,4,5,6,7,8,9/)
   opts@FieldTitle      = "b)UCM.AH-BEP"
   opts@lbTitleString   = "so2 (ppb)"
;   codf = co_E0-co_E1
   plot = wrf_contour(fnc,wks1,df20,opts)
   sfc2 = wrf_map_overlays(fnc,wks1,(/plot/),pltres,mpres)
   lns4 = gsn_add_bou3(wks1,sfc2)
   lns5 = gsn_add_bou2(wks1,sfc2)
   delete(opts)

   opts = cnres
;   opts@cnLevelSpacingF = 10
;   opts@cnMinLevelValF  = -40
;   opts@cnMaxLevelValF  = 40
   opts@cnLevels        = (/-100,-85,-70,-50,-30,-10,0/)
   opts@cnFillColors     = (/2,3,4,5,6,7,8,9/)
   opts@FieldTitle      = "c)UCM.NOAH-BEP"
   opts@lbTitleString   = "so2 (ppb)"
;   codr = (co_E0-co_E1)/co_E1*100
   plot = wrf_contour(fnc,wks1,df30,opts)
   sfc3 = wrf_map_overlays(fnc,wks1,(/plot/),pltres,mpres)
   lns6 = gsn_add_bou3(wks1,sfc3)
   lns7 = gsn_add_bou2(wks1,sfc3)

   opts = cnres
;   opts@cnLevelSpacingF = 10
;   opts@cnMinLevelValF  = -40
;   opts@cnMaxLevelValF  = 40
   opts@cnLevels        = (/-100,-85,-70,-50,-30,-10,0/)
   opts@cnFillColors     = (/2,3,4,5,6,7,8,9/)
   opts@FieldTitle      = "d)BEM-BEP"
   opts@lbTitleString   = "so2 (ppb)"
;   codr = (co_E0-co_E1)/co_E1*100
   plot = wrf_contour(fnc,wks1,df40,opts)
   sfc4 = wrf_map_overlays(fnc,wks1,(/plot/),pltres,mpres)
   lns8 = gsn_add_bou3(wks1,sfc4)
   lns9 = gsn_add_bou2(wks1,sfc4)

   gsn_panel(wks1,(/sfc1,sfc2,sfc3,sfc4/),(/2,2/),pnlres)


end
                                                                        
