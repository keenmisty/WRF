try
    % Main block

ncpath=strcat('/ees/users/EMG/ees2/weihua/WRF/3.4.1/wrfchem/test/haze.201210.22-31/'); 
file_stru=dir(strcat(ncpath,'wrfout_d01_*')); 

%%%met of single layer
for i=1:length(file_stru)   
    filename=strcat(ncpath,file_stru(i).name);
    f=netcdf(filename,'nowrite');
    q2(i,:,:)=squeeze(f{'Q2'}(:));
    t2(i,:,:)=squeeze(f{'T2'}(:));
    pres(i,:,:)=squeeze(f{'PSFC'}(:));   
    u10(i,:,:)=squeeze(f{'U10'}(:));
    v10(i,:,:)=squeeze(f{'V10'}(:));
    swdown(i,:,:)=squeeze(f{'SWDOWN'}(:));
end
q2=q2(:,:,:);
t2=t2(:,:,:);
press=pres(:,:,:);
u10=u10(:,:,:);
v10=v10(:,:,:);
sw=swdown(:,:,:);
rh=CalRH(t2,q2,press,2);
pv=Qv2Pv(q2,press);
ws=sqrt(u10.^2+v10.^2);
save('22-31mettime.mat','t2','ws','u10','v10','press','pv','sw','rh');

for i=1:length(file_stru)
    filename=strcat(ncpath,file_stru(i).name);
    f=netcdf(filename,'nowrite');
so2(i,:,:,:)=squeeze(f{'so2'}(:,1,:,:));
no2(i,:,:,:)=squeeze(f{'no2'}(:,1,:,:));
no(i,:,:,:)=squeeze(f{'no'}(:,1,:,:));
o3(i,:,:,:)=squeeze(f{'o3'}(:,1,:,:));  
co(i,:,:,:)=squeeze(f{'co'}(:,1,:,:)); 
end
so2=so2(:,:,:,:);
no2=no2(:,:,:,:);
no=no(:,:,:,:);
o3=o3(:,:,:,:);
co=co(:,:,:,:);
%ppmv to ug/m3
o3(:,:,:)=ppbv2ugm3((squeeze(o3(:,:,:))).*1000,48,press,t2);
no(:,:,:)=ppbv2ugm3((squeeze(no(:,:,:))).*1000,30,press,t2);
no2(:,:,:)=ppbv2ugm3((squeeze(no2(:,:,:))).*1000,46,press,t2);
so2(:,:,:)=ppbv2ugm3((squeeze(so2(:,:,:))).*1000,64,press,t2);
co(:,:,:)=ppbv2ugm3((squeeze(co(:,:,:))).*1000,28,press,t2);
save('22-31gas.mat','so2','no2','no','o3','co');  

%%%%particle
for i=1:length(file_stru)   
    filename=strcat(ncpath,file_stru(i).name);
    f=netcdf(filename,'nowrite');
pm10(i,:,:,:)=squeeze(f{'PM10'}(:,1,:,:));
pm25(i,:,:,:)=squeeze(f{'PM2_5_DRY'}(:,1,:,:));
pm25_p1(i,:,:,:)=squeeze(f{'p25j'}(:,1,:,:));
pm25_p2(i,:,:,:)=squeeze(f{'p25i'}(:,1,:,:));
end
pm10=pm10(:,:,:,:);
pm25=pm25(:,:,:,:);
pm25_p1=pm25_p1(:,:,:,:);
pm25_p2=pm25_p2(:,:,:,:);
save('22-31particle.mat','pm10','pm25','pm25_p1','pm25_p2');

%%%%thirdary chemical 
% air_p=airdensity(press, t2);
for i=1:length(file_stru)   
    filename=strcat(ncpath,file_stru(i).name);
    f=netcdf(filename,'nowrite');
so4_1(i,:,:)=squeeze(f{'so4_a01'}(:,1,:,:));
so4_2(i,:,:)=squeeze(f{'so4_a02'}(:,1,:,:));
so4_3(i,:,:)=squeeze(f{'so4_a03'}(:,1,:,:));
so4_4(i,:,:)=squeeze(f{'so4_a04'}(:,1,:,:));

no3_1(i,:,:)=squeeze(f{'no3_a01'}(:,1,:,:));
no3_2(i,:,:)=squeeze(f{'no3_a02'}(:,1,:,:));
no3_3(i,:,:)=squeeze(f{'no3_a03'}(:,1,:,:));
no3_4(i,:,:)=squeeze(f{'no3_a04'}(:,1,:,:));

nh4_1(i,:,:)=squeeze(f{'nh4_a01'}(:,1,:,:));
nh4_2(i,:,:)=squeeze(f{'nh4_a02'}(:,1,:,:));
nh4_3(i,:,:)=squeeze(f{'nh4_a03'}(:,1,:,:));
nh4_4(i,:,:)=squeeze(f{'nh4_a04'}(:,1,:,:));

so4_5(i,:,:)=squeeze(f{'so4_a05'}(:,1,:,:));
so4_6(i,:,:)=squeeze(f{'so4_a06'}(:,1,:,:));
so4_7(i,:,:)=squeeze(f{'so4_a07'}(:,1,:,:));
so4_8(i,:,:)=squeeze(f{'so4_a08'}(:,1,:,:));

no3_5(i,:,:)=squeeze(f{'no3_a05'}(:,1,:,:));
no3_6(i,:,:)=squeeze(f{'no3_a06'}(:,1,:,:));
no3_7(i,:,:)=squeeze(f{'no3_a07'}(:,1,:,:));
no3_8(i,:,:)=squeeze(f{'no3_a08'}(:,1,:,:));

nh4_5(i,:,:)=squeeze(f{'nh4_a05'}(:,1,:,:));
nh4_6(i,:,:)=squeeze(f{'nh4_a06'}(:,1,:,:));
nh4_7(i,:,:)=squeeze(f{'nh4_a07'}(:,1,:,:));
nh4_8(i,:,:)=squeeze(f{'nh4_a08'}(:,1,:,:));
end
save('22-31seconadarychemical.mat','so4_1','so4_2','so4_3','so4_4','so4_5','so4_6','so4_7','so4_8',...
    'no3_1','no3_2','no3_3','no3_4','no3_5','no3_6','no3_7','no3_8',...
    'nh4_1','nh4_2','nh4_3','nh4_4','nh4_5','nh4_6','nh4_7','nh4_8');

for i=1:length(file_stru)   
    filename=strcat(ncpath,file_stru(i).name);
    f=netcdf(filename,'nowrite');
bc_1(i,:,:)=squeeze(f{'bc_a01'}(:,1,:,:));
bc_2(i,:,:)=squeeze(f{'bc_a02'}(:,1,:,:));
bc_3(i,:,:)=squeeze(f{'bc_a03'}(:,1,:,:));
bc_4(i,:,:)=squeeze(f{'bc_a04'}(:,1,:,:));

oc_1(i,:,:)=squeeze(f{'oc_a01'}(:,1,:,:));
oc_2(i,:,:)=squeeze(f{'oc_a02'}(:,1,:,:));
oc_3(i,:,:)=squeeze(f{'oc_a03'}(:,1,:,:));
oc_4(i,:,:)=squeeze(f{'oc_a04'}(:,1,:,:));

bc_5(i,:,:)=squeeze(f{'bc_a05'}(:,1,:,:));
bc_6(i,:,:)=squeeze(f{'bc_a06'}(:,1,:,:));
bc_7(i,:,:)=squeeze(f{'bc_a07'}(:,1,:,:));
bc_8(i,:,:)=squeeze(f{'bc_a08'}(:,1,:,:));

oc_5(i,:,:)=squeeze(f{'oc_a05'}(:,1,:,:));
oc_6(i,:,:)=squeeze(f{'oc_a06'}(:,1,:,:));
oc_7(i,:,:)=squeeze(f{'oc_a07'}(:,1,:,:));
oc_8(i,:,:)=squeeze(f{'oc_a08'}(:,1,:,:));
end
save('22-31OCECchemical.mat','bc_1','bc_2','bc_3','bc_4','bc_5','bc_6','bc_7','bc_8',...
    'oc_1','oc_2','oc_3','oc_4','oc_5','oc_6','oc_7','oc_8');



    exit

    
catch err
    errmsg=err.message
    exit
end

