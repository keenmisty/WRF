try

clear;clc;
cd ('/ees/users/EMG/ees2/daijn/djn/WRF3.4.1/wrfchem_bu/test/em_real/data_1007')
file=dir('wrfout*');
for n=1:length(file)
    filename=file(n).name;
    f=netcdf(filename,'nowrite');
    lat=squeeze(f{'XLAT'}(:,:,:));
    lon=squeeze(f{'XLONG'}(:,:,:));

    T_temp=squeeze(f{'T'}(:,1,:,:));
    U_temp=squeeze(f{'U'}(:,1,:,:));
    V_temp=squeeze(f{'V'}(:,1,:,:));
    P_temp=squeeze(f{'P'}(:,1,:,:));
    PB_temp=squeeze(f{'PB'}(:,1,:,:));
    PHB_temp=squeeze(f{'PHB'}(:,1,:,:));
    PH_temp=squeeze(f{'PH'}(:,1,:,:));
    H_temp=squeeze(f{'HGT'}(:,:,:));
    LU_temp=squeeze(f{'LU_INDEX'}(:,:,:));
    
    T(n,:,:)=T_temp;
    U(n,:,:)= U_temp;
    V(n,:,:)= V_temp;
    P(n,:,:)=P_temp;
    PB(n,:,:)=PB_temp;
    PH(n,:,:)=PH_temp;
    PHB(n,:,:)=PHB_temp;   
    H(n,:,:)=H_temp;
    LU(n,:,:)=LU_temp;

   clear  T_temp  V_temp U_temp filename f P_temp PB_temp PH_temp PHB_temp H_temp LU_temp
end
save MET_DATA_2.mat T U V P PB PH PHB H LU lon lat
whos
    
exit

catch err
errmsg=err.message
whos
exit
end

