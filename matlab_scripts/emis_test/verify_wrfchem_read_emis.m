clear

f=netcdf('/parastor/users/eeswxm/zhiyong/wrfchem/3.4.1/WRFV3/test/em_real/wrfchemi_00z_d01','nowrite'); % 00-11 UTC
EMIS(1:12,:,:,:)=squeeze(f{'E_NO2'}(:));
close(f)

f=netcdf('/parastor/users/eeswxm/zhiyong/wrfchem/3.4.1/WRFV3/test/em_real/wrfchemi_12z_d01','nowrite'); % 12-23 UTC
EMIS(13:24,:,:,:)=squeeze(f{'E_NO2'}(:));
close(f)

ncpath=strcat('/parastor/users/eeswxm/zhiyong/wrfchem/3.4.1/WRFV3/test/em_real/'); 
file_stru=dir(strcat(ncpath,'wrfout_d01_2009-12-31*')); 

for n=1:length(file_stru) 
    filename=strcat(ncpath,file_stru(n).name)
    f=netcdf(filename,'nowrite');
    emis(n,:,:,:)=squeeze(f{'E_NO2'}(:));
    close(f)
end


emis_wrf(1:23,:,:,:)=emis(2:24,:,:,:);
emis_wrf(24,:,:,:)=emis(1,:,:,:);

issame(EMIS,emis_wrf)
