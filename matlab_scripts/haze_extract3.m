try
    % Main block

ncpath=strcat('/ees/users/EMG/ees2/weihua/WRF/3.4.1/wrfchem/test/haze.201210.15-22/'); 
file_stru=dir(strcat(ncpath,'wrfout_d01_*')); 

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
save('15-22seconadarychemical.mat','so4_1','so4_2','so4_3','so4_4','so4_5','so4_6','so4_7','so4_8',...
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
save('15-22OCECchemical.mat','bc_1','bc_2','bc_3','bc_4','bc_5','bc_6','bc_7','bc_8',...
    'oc_1','oc_2','oc_3','oc_4','oc_5','oc_6','oc_7','oc_8');



    exit

    
catch err
    errmsg=err.message
    exit
end

