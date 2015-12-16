try

clear;clc;
cd ('/ees/users/EMG/ees2/shaofen/wrf3.4.1/WRFV3/test/runpjm07')
file=dir('wrfout*');
for n=1:length(file)
    filename=file(n).name;
    f=netcdf(filename,'nowrite');
    T2_temp=squeeze(f{'T2'}(:,:,:));
    SW_temp=squeeze(f{'SWDOWN'}(:,:,:));
    
    T2_201007(n,:,:)=T2_temp;
    SW_201007(n,:,:)=SW_temp;
    
    clear T2_temp SW_temp filename f
end
cd ('/ees/users/EMG/ees2/pangjm/data/wrf')
save MET_DATA_201007.mat T2_201007 SW_201007
    
exit

catch err
    errmsg=err.message
    exit
end

