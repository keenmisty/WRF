try

clear;clc;
cd ('/ees/users/EMG/ees2/daijn/djn/WRF3.4.1/wrfchem.kpp.bk/test/em_real/data_7')

for n=1:1
    file=dir('wrfout*')
    filename=file(n).name;
    f=netcdf(filename,'nowrite');
    lat=squeeze(f{'XLAT'}(:,:,:));
    lon=squeeze(f{'XLONG'}(:,:,:));
    close(f)
end
whos
save LAT_LON.mat lat lon
    
%exit

catch err
    whos
    errmsg=err.message
%    exit
end

