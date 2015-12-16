try

clear;clc;
cd ('/ees/users/EMG/ees2/shaofen/wrf3.4.1/WRFV3/test/run1/pjm/test3')
file=dir('wrfout*');
for n=1:length(file)
    filename=file(n).name;
    f=netcdf(filename,'nowrite');
    T2_temp=squeeze(f{'T2'}(:,:,:));
    SW_temp=squeeze(f{'SWDOWN'}(:,:,:));
    
    T2(n,:,:)=T2_temp;
    SW(n,:,:)=SW_temp;
    
    clear T2_temp SW_temp filename f
end
save MET_DATA.mat T2 SW
    
exit

catch err
    errmsg=err.message
    exit
end

