clear all
clc
cd('C:\Users\AdminH\Desktop\emission_zhiyong\met')
nsta=16;
dayst=1;
dayend=31;
%观测
load obs_sitedata.mat
%模拟
load cbmz_chem4var_change201010.mat

so2_obs=obs_so2.*1000;
no2_obs=obs_no2.*1000;
o3_obs=obs_o3.*1000;
pm10_obs=obs_pm10.*1000;
clear obs_*
no2_average_obs=nanmean(no2_obs,2);
no2_average_sim=nanmean(no2_wrfchem,2);
no2_compare=[no2_average_obs,no2_average_sim];
o3_average_obs=nanmean(o3_obs,2);
o3_average_sim=nanmean(o3_wrfchem,2);
o3_compare=[o3_average_obs,o3_average_sim];

clear no2_average_*
for ii = 1:nsta
T2C_obs_hour=squeeze(so2_obs(:,ii));
T2C_sim_hour=squeeze(so2_wrfchem(:,ii));
for i=1
%%平均绝对偏差Bias
Call_Bias_so2=nanmean(T2C_sim_hour-T2C_obs_hour);
%%平均相对偏差MRB
Call_MRB_so2=nanmean((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour);
%%平均绝对误差MAE
Call_MAE_so2=nanmean(abs(T2C_sim_hour-T2C_obs_hour));
%%平均相对误差MRE
Call_MRE_so2=nanmean(abs((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour));
%%平方根误差（标准差）RMSE
Call_RMSE_so2=sqrt(nanmean((T2C_sim_hour-T2C_obs_hour).^2));
%%观测平均 OBSave
Call_OBSAVE_so2=nanmean(T2C_obs_hour);
%%模拟平均 SIMave
Call_SIMAVE_so2=mean(T2C_sim_hour);
%%相关系数R
Call_R.x=nancorrcoef(T2C_obs_hour,T2C_sim_hour);
Call_COR_so2=Call_R.x;
%%命中率
% T2Call_HR=HR(T2C_sim_hour,T2C_obs_hour,10);
total_so2data(ii,:) = [Call_OBSAVE_so2,Call_SIMAVE_so2,Call_Bias_so2,Call_MRB_so2,Call_MAE_so2,Call_MRE_so2,Call_RMSE_so2,Call_COR_so2];
end
end
clear T2C_obs_hour T2C_sim_hour Call_*

for ii = 1:nsta
T2C_obs_hour=squeeze(no2_obs(:,ii));
T2C_sim_hour=squeeze(no2_wrfchem(:,ii));
for i=1
%%平均绝对偏差Bias
Call_Bias_no2=nanmean(T2C_sim_hour-T2C_obs_hour);
%%平均相对偏差MRB
Call_MRB_no2=nanmean((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour);
%%平均绝对误差MAE
Call_MAE_no2=nanmean(abs(T2C_sim_hour-T2C_obs_hour));
%%平均相对误差MRE
Call_MRE_no2=nanmean(abs((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour));
%%平方根误差（标准差）RMSE
Call_RMSE_no2=sqrt(nanmean((T2C_sim_hour-T2C_obs_hour).^2));
%%观测平均 OBSave
Call_OBSAVE_no2=nanmean(T2C_obs_hour);
%%模拟平均 SIMave
Call_SIMAVE_no2=mean(T2C_sim_hour);
%%相关系数R
Call_R.x=nancorrcoef(T2C_obs_hour,T2C_sim_hour);
Call_COR_no2=Call_R.x;
%%命中率
% T2Call_HR=HR(T2C_sim_hour,T2C_obs_hour,10);
total_no2data(ii,:) = [Call_OBSAVE_no2,Call_SIMAVE_no2,Call_Bias_no2,Call_MRB_no2,Call_MAE_no2,Call_MRE_no2,Call_RMSE_no2,Call_COR_no2];
end
end
clear T2C_obs_hour T2C_sim_hour Call_*

for ii = 1:nsta
T2C_obs_hour=squeeze(o3_obs(:,ii));
T2C_sim_hour=squeeze(o3_wrfchem(:,ii));
for i=1
%%平均绝对偏差Bias
Call_Bias_o3=nanmean(T2C_sim_hour-T2C_obs_hour);
%%平均相对偏差MRB
Call_MRB_o3=nanmean((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour);
%%平均绝对误差MAE
Call_MAE_o3=nanmean(abs(T2C_sim_hour-T2C_obs_hour));
%%平均相对误差MRE
Call_MRE_o3=nanmean(abs((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour));
%%平方根误差（标准差）RMSE
Call_RMSE_o3=sqrt(nanmean((T2C_sim_hour-T2C_obs_hour).^2));
%%观测平均 OBSave
Call_OBSAVE_o3=nanmean(T2C_obs_hour);
%%模拟平均 SIMave
Call_SIMAVE_o3=mean(T2C_sim_hour);
%%相关系数R
Call_R.x=nancorrcoef(T2C_obs_hour,T2C_sim_hour);
Call_COR_o3=Call_R.x;
%%命中率
% T2Call_HR=HR(T2C_sim_hour,T2C_obs_hour,10);
total_o3data(ii,:) = [Call_OBSAVE_o3,Call_SIMAVE_o3,Call_Bias_o3,Call_MRB_o3,Call_MAE_o3,Call_MRE_o3,Call_RMSE_o3,Call_COR_o3];
end
end
clear T2C_obs_hour T2C_sim_hour Call_*

for ii = 1:nsta
T2C_obs_hour=squeeze(pm10_obs(:,ii));
T2C_sim_hour=squeeze(pm10_wrfchem(:,ii));
for i=1
%%平均绝对偏差Bias
Call_Bias_pm10=nanmean(T2C_sim_hour-T2C_obs_hour);
%%平均相对偏差MRB
Call_MRB_pm10=nanmean((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour);
%%平均绝对误差MAE
Call_MAE_pm10=nanmean(abs(T2C_sim_hour-T2C_obs_hour));
%%平均相对误差MRE
Call_MRE_pm10=nanmean(abs((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour));
%%平方根误差（标准差）RMSE
Call_RMSE_pm10=sqrt(nanmean((T2C_sim_hour-T2C_obs_hour).^2));
%%观测平均 OBSave
Call_OBSAVE_pm10=nanmean(T2C_obs_hour);
%%模拟平均 SIMave
Call_SIMAVE_pm10=mean(T2C_sim_hour);
%%相关系数R
Call_R.x=nancorrcoef(T2C_obs_hour,T2C_sim_hour);
Call_COR_pm10=Call_R.x;
%%命中率
% T2Call_HR=HR(T2C_sim_hour,T2C_obs_hour,10);
total_pm10data(ii,:) = [Call_OBSAVE_pm10,Call_SIMAVE_pm10,Call_Bias_pm10,Call_MRB_pm10,Call_MAE_pm10,Call_MRE_pm10,Call_RMSE_pm10,Call_COR_pm10];
end
end
clear T2C_obs_hour T2C_sim_hour Call_* i ii dayst dayend nsta 
