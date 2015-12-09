try

clear;clc;
cd ('/ees/users/EMG/davidce/shunde_result/drawScript/data/10')
file=dir('wrfout*');
for n=1:length(file)
    filename=file(n).name;
    f=netcdf(filename,'nowrite');
    lat=squeeze(f{'XLAT'}(:,:,:));
    lon=squeeze(f{'XLONG'}(:,:,:));

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


  clear T2_temp SW_temp filename f
end
save MET_DATA.mat T2 U10 V10 Q2 PSFC lat lon 
    
exit

catch err
    errmsg=err.message
    exit
end

