try

clear;clc;
cd ('/ees/users/EMG/ees2/daijn/djn/WRF3.4.1/wrfchem_bu/test/em_real/data')
file=dir('wrfout*');
for n=1:length(file)
    filename=file(n).name;
    f=netcdf(filename,'nowrite');
    lat=squeeze(f{'XLAT'}(:,:,:));
    lon=squeeze(f{'XLONG'}(:,:,:));

#    PM2_5_DRY_temp=squeeze(f{'PM2_5_DRY'}(:,1,:,:));
    T2_temp=squeeze(f{'T2'}(:,:,:));
    U10_temp=squeeze(f{'U10'}(:,:,:));
    V10_temp=squeeze(f{'V10'}(:,:,:));
    Q2_temp=squeeze(f{'Q2'}(:,:,:));
    PSFC_temp=squeeze(f{'PSFC'}(:,:,:));

    T2(n,:,:)=T2_temp;
    U10(n,:,:)= U10_temp;
    V10(n,:,:)= V10_temp;
    Q2(n,:,:)=Q2_temp;
    PSFC(n,:,:)=PSFC_temp;
 #   PM2_5_DRY(n,:,:)=PM2_5_DRY_temp;

   clear   T2_temp  V10_temp U10_temp  Q2_temp  PSFC_temp filename f
end
save MET_DATA1.mat  PM2_5_DRY T2  U10 V10 Q2 PSFC  lat lon
whos
    
exit

catch err
errmsg=err.message
whos
exit
end

