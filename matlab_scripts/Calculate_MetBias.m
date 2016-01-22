clear
clc
nsta=18;
dayst=1;
dayend=31;
cd('C:\Users\AdminH\Desktop\emission_zhiyong\met')
load met201010_obs.mat
load cbmz_met201010_change.mat
OBS_rain=(squeeze(met(:,dayst:dayend,5)))';
OBS_rain(OBS_rain==32700)=0;
OBS_t2=(squeeze(met(:,dayst:dayend,10)))';
OBS_rh=(squeeze(met(:,dayst:dayend,12)))';
OBS_pv=(squeeze(met(:,dayst:dayend,11)))';
OBS_ws=(squeeze(met(:,dayst:dayend,9)))';
OBS_t2(OBS_rain>0)=NaN;
OBS_rh(OBS_rain>0)=NaN;
OBS_pv(OBS_rain>0)=NaN;
OBS_ws(OBS_rain>0)=NaN;
% cd('H:\Program Files\MATLAB\R2008a\work')
OBS_t2_1(:,:)=0.1*OBS_t2(:,:);
t2_wrfchem_1(:,:)=t2_wrfchem-273.15;
for ii = 1:nsta %站点数
T2C_obs_hour=squeeze(OBS_t2_1(:,ii));
T2C_sim_hour=squeeze(t2_wrfchem_1(:,ii));
for i=1
%%平均绝对偏差Bias
Call_Bias_t2=nanmean(T2C_sim_hour-T2C_obs_hour);
%%平均相对偏差MRB
Call_MRB_t2=nanmean((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour);
%%平均绝对误差MAE
Call_MAE_t2=nanmean(abs(T2C_sim_hour-T2C_obs_hour));
%%平均相对误差MRE
Call_MRE_t2=nanmean(abs((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour));
%%平方根误差（标准差）RMSE
Call_RMSE_t2=sqrt(nanmean((T2C_sim_hour-T2C_obs_hour).^2));
%%观测平均 OBSave
Call_OBSAVE_t2=nanmean(T2C_obs_hour);
%%模拟平均 SIMave
Call_SIMAVE_t2=mean(T2C_sim_hour);
%%相关系数R
Call_R.x=nancorrcoef(T2C_obs_hour,T2C_sim_hour);
Call_COR_t2=Call_R.x;
%%命中率
% T2Call_HR=HR(T2C_sim_hour,T2C_obs_hour,2);
%total_t2data(ii,:)= [mean(Call_OBSAVE_t2),mean(Call_SIMAVE_t2),mean(Call_Bias_t2),mean(Call_MRB_t2),mean(Call_MAE_t2),mean(Call_MRE_t2),mean(Call_RMSE_t2),mean(Call_COR_t2)];
total_t2data(ii,:)= [Call_OBSAVE_t2,Call_SIMAVE_t2,Call_Bias_t2,Call_MRB_t2,Call_MAE_t2,Call_MRE_t2,Call_RMSE_t2,Call_COR_t2];
end
end
clear T2C_obs_hour T2C_sim_hour Call_*

for ii = 1:nsta
T2C_obs_hour=squeeze(OBS_rh(:,ii));
T2C_sim_hour=squeeze(rh_wrfchem(:,ii));
for i=1
%%平均绝对偏差Bias
Call_Bias_rh=nanmean(T2C_sim_hour-T2C_obs_hour);
%%平均相对偏差MRB
Call_MRB_rh=nanmean((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour);
%%平均绝对误差MAE
Call_MAE_rh=nanmean(abs(T2C_sim_hour-T2C_obs_hour));
%%平均相对误差MRE
Call_MRE_rh=nanmean(abs((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour));
%%平方根误差（标准差）RMSE
Call_RMSE_rh=sqrt(nanmean((T2C_sim_hour-T2C_obs_hour).^2));
%%观测平均 OBSave
Call_OBSAVE_rh=nanmean(T2C_obs_hour);
%%模拟平均 SIMave
Call_SIMAVE_rh=mean(T2C_sim_hour);
%%相关系数R
Call_R.x=nancorrcoef(T2C_obs_hour,T2C_sim_hour);
Call_COR_rh=Call_R.x;
%%命中率
% T2Call_HR=HR(T2C_sim_hour,T2C_obs_hour,10);
total_rhdata(ii,:) = [Call_OBSAVE_rh,Call_SIMAVE_rh,Call_Bias_rh,Call_MRB_rh,Call_MAE_rh,Call_MRE_rh,Call_RMSE_rh,Call_COR_rh];
end
end
clear T2C_obs_hour T2C_sim_hour Call_*

OBS_ws_1(:,:)=0.1*OBS_ws(:,:);
for ii = 1:nsta
T2C_obs_hour=squeeze(OBS_ws_1(:,ii));
T2C_sim_hour=squeeze(ws10_wrfchem(:,ii));
T2C_obs_hour(find(T2C_obs_hour==0))=NaN;
for i=1
%%平均绝对偏差Bias
Call_Bias_ws=nanmean(T2C_sim_hour-T2C_obs_hour);
%%平均相对偏差MRB
Call_MRB_ws=nanmean((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour);
%%平均绝对误差MAE
Call_MAE_ws=nanmean(abs(T2C_sim_hour-T2C_obs_hour));
%%平均相对误差MRE
Call_MRE_ws=nanmean(abs((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour));
%%平方根误差（标准差）RMSE
Call_RMSE_ws=sqrt(nanmean((T2C_sim_hour-T2C_obs_hour).^2));
%%观测平均 OBSave
Call_OBSAVE_ws=nanmean(T2C_obs_hour);
%%模拟平均 SIMave
Call_SIMAVE_ws=mean(T2C_sim_hour);
%%相关系数R
Call_R.x=nancorrcoef(T2C_obs_hour,T2C_sim_hour);
Call_COR_ws=Call_R.x;
%%命中率
% T2Call_HR=HR(T2C_sim_hour,T2C_obs_hour,1.5);
total_wsdata(ii,:) = [Call_OBSAVE_ws,Call_SIMAVE_ws,Call_Bias_ws,Call_MRB_ws,Call_MAE_ws,Call_MRE_ws,Call_RMSE_ws,Call_COR_ws];
end
end
clear T2C_obs_hour T2C_sim_hour Call_*

OBS_pv_1(:,:)=0.1*OBS_pv(:,:);
pv_wrfchem_1=0.01*pv_wrfchem;
for ii = 1:nsta
T2C_obs_hour=squeeze(OBS_pv_1(:,ii));
T2C_sim_hour=squeeze(pv_wrfchem_1(:,ii));
T2C_obs_hour(find(T2C_obs_hour==0))=NaN;
for i=1
%%平均绝对偏差Bias
Call_Bias_pv=nanmean(T2C_sim_hour-T2C_obs_hour);
%%平均相对偏差MRB
Call_MRB_pv=nanmean((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour);
%%平均绝对误差MAE
Call_MAE_pv=nanmean(abs(T2C_sim_hour-T2C_obs_hour));
%%平均相对误差MRE
Call_MRE_pv=nanmean(abs((T2C_sim_hour-T2C_obs_hour)./T2C_obs_hour));
%%平方根误差（标准差）RMSE
Call_RMSE_pv=sqrt(nanmean((T2C_sim_hour-T2C_obs_hour).^2));
%%观测平均 OBSave
Call_OBSAVE_pv=nanmean(T2C_obs_hour);
%%模拟平均 SIMave
Call_SIMAVE_pv=mean(T2C_sim_hour);
%%相关系数R
Call_R.x=nancorrcoef(T2C_obs_hour,T2C_sim_hour);
Call_COR_pv=Call_R.x;
%%命中率
% T2Call_HR=HR(T2C_sim_hour,T2C_obs_hour,1.5);
total_pvdata(ii,:) = [Call_OBSAVE_pv,Call_SIMAVE_pv,Call_Bias_pv,Call_MRB_pv,Call_MAE_pv,Call_MRE_pv,Call_RMSE_pv,Call_COR_pv];
end
end
clear T2C_obs_hour T2C_sim_hour Call_*