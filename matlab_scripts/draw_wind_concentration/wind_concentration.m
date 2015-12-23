try

clear;clc;
filename=textread('/ees/users/EMG/ees2/daijn/djn/WRF3.4.1/wrfchem.kpp.bk/test/em_real/data_7/file.txt','%s');
for n=1:168
    f=netcdf(filename{n},'nowrite');
    lat=squeeze(f{'XLAT'}(1,:,:));
    lon=squeeze(f{'XLONG'}(1,:,:));
    media_NO2(n,:,:)         =    squeeze(f{'no2'}(:,1,:,:));
    media_O3(n,:,:)          =    squeeze(f{'o3'}(:,1,:,:));
    media_NO(n,:,:)          =    squeeze(f{'no'}(:,1,:,:));
    media_u10(n,:,:)       =    squeeze(f{'U10'}(:,:,:));
    media_v10(n,:,:)       =    squeeze(f{'V10'}(:,:,:));
end
rang_lon=[min(min(lon)),max(max(lon))];    
rang_lat=[min(min(lat)),max(max(lat))]; 
for i=1:7
    O3((i-1)*12+1:(i-1)*12+12,:,:)=media_O3((i-1)*24+9:(i-1)*24+20,:,:);
end
o3_base=squeeze(mean(O3));
for i=1:7
    NO2((i-1)*12+1:(i-1)*12+12,:,:)=media_NO2((i-1)*24+9:(i-1)*24+20,:,:);
end
no2_base=squeeze(mean(NO2));
for i=1:7
    NO((i-1)*12+1:(i-1)*12+12,:,:)=media_NO((i-1)*24+9:(i-1)*24+20,:,:);
end
no_base=squeeze(mean(NO));
for i=1:7
    u10((i-1)*12+1:(i-1)*12+12,:,:)=media_u10((i-1)*24+9:(i-1)*24+20,:,:);
end
u10=squeeze(mean(u10));
for i=1:7
    v10((i-1)*12+1:(i-1)*12+12,:,:)=media_v10((i-1)*24+9:(i-1)*24+20,:,:);
end
v10=squeeze(mean(v10));
save('base_daytime.mat','lon','lat','rang_lon','rang_lat','no2_base','no_base','o3_base','u10','v10');

exit

catch err
    errmsg=err.message
    exit
end
