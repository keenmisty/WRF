load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

; read in from lsm nc file

f_lsm = addfile("//home/research3/LSM/Noah_LSM_run/OUTPUT.0004.nc","r")

QFX_lsm_temp = f_lsm->QFX
;print(QFX_lsm_temp)
;num=dimsizes(QFX_lsm_temp)
j = 35037
do i=0,j,2
QFX_lsm_temp2=QFX_lsm_temp(i)
QFX_lsm=(QFX)
end do

SHEAT_lsm = f_lsm->SHEAT
print(QFX_lsm)

; read in from mp file

f_mp  = addfile("//home/research3/NCAR_noahmp/NoahMP_run/OUTPUT.0004.nc","r")

f_obs = asciiread("/home/research3/DHS/dinghu_2010_flux_notitle.dat",-1,"string")
LE_obs= stringtofloat(str_get_cols(f_obs,30,44))
HS_obs= stringtofloat(str_get_cols(f_obs,45,59))
;print(HS_obs)

end

