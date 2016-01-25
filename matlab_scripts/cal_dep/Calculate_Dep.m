clear all
clc
cd('C:\Users\AdminH\Desktop\emission_zhiyong\met')

%模拟
load('basewithmozbc_depmass201010.mat');

Fd_no_cal_monthly      =squeeze(sum(Fd_no_cal_daily,1)); 
Fd_no2_cal_monthly     =squeeze(sum(Fd_no2_cal_daily,1));
Fd_nh3_cal_monthly     =squeeze(sum(Fd_nh3_cal_daily,1));
Fd_hno3_cal_monthly    =squeeze(sum(Fd_hno3_cal_daily,1));
Fd_hno4_cal_monthly    =squeeze(sum(Fd_hno4_cal_daily,1));
Fd_pan_cal_monthly     =squeeze(sum(Fd_pan_cal_daily,1));
Fd_onit_cal_monthly    =squeeze(sum(Fd_onit_cal_daily,1));

FdN_monthly=zeros(7,144,123);
FdN_monthly(1,:,:)=Fd_no_cal_monthly;
FdN_monthly(2,:,:)=Fd_no2_cal_monthly;
FdN_monthly(7,:,:)=Fd_nh3_cal_monthly;
FdN_monthly(4,:,:)=Fd_hno3_cal_monthly;
FdN_monthly(5,:,:)=Fd_hno4_cal_monthly ;
FdN_monthly(6,:,:)=Fd_pan_cal_monthly;
FdN_monthly(3,:,:)=Fd_onit_cal_monthly;

N_oxidized_201010=squeeze(sum(FdN_monthly(1:6,:,:),1));
N_201010=squeeze(sum(FdN_monthly,1)); % kgN/ha/month
N_reduce_201010=Fd_nh3_cal_monthly;
% clear Fd_* FdN_* 
N_dhs=N_201010(33,72);
N_dhs_ox=N_oxidized_201010(33,72);
N_dhs_re=N_reduce_201010(33,72);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 制成一维的txt文档
load('basewithmozbc_latlon.mat')
[m n]=size(lat);
for j=1:n
    for i=1:m
    a(m*(j-1)+i,1)=lat(i,j); %lat
    end
end
clear i j
for j=1:n
    for i=1:m
    a(m*(j-1)+i,2)=lon(i,j); %lon
    end
end
clear i j
for j=1:n
    for i=1:m
    a(m*(j-1)+i,3)=N_201010(i,j);  %变量
    end
end
clear i j
clear m n

[m n]=size(a);
[filename pathname] = uiputfile('*.txt','Select Save file');
if ~filename
return;
else
str = [pathname filename];
end
fin = fopen(str,'wt');
fprintf(fin,'"lat","lon","N_Fd_201010"')
fprintf(fin,'\n');
for i = 1:m
for j =1:n
fprintf(fin,'%f\t',a(i,j));
end
fprintf(fin,'\n');
end
fclose(fin)
