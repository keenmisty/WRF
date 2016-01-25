clear

% grid name
gridname='CN27EC';

% set mcip ncip file
gridcrofile=['../data/mcip/',gridname,'/2014294/GRIDCRO2D_2014294'];
mcipfile=cell(30,1);
for i=1:30
    mcipfile{i}=['../data/mcip/',gridname,'/',num2str(2014293+i),'/METCRO2D_',num2str(2014293+i)];
end

% get lon and lat
nlon=ncread(gridcrofile,'LON');
nlat=ncread(gridcrofile,'LAT');

% location of Heshan station
lon=112.9266;
lat=22.7109;

% get x and y in grid
[ix,iy]=findpoint(lon,lat,nlon,nlat);

% get t2, rh2, wdir, wspd, rain, pres in simulation
t2_sim(30*24+1)=0;
rh2_sim(30*24+1)=0;
wdir_sim(30*24+1)=0;
wspd_sim(30*24+1)=0;
rain_sim(30*24+1)=0;
pres_sim(30*24+1)=0;
for i=1:30
    t2_sim((i-1)*24+1:i*24+1)=ncread(mcipfile{i},'TEMP2',[ix,iy,1,1],[1,1,1,inf]);
    rh2_sim((i-1)*24+1:i*24+1)=get_crh2(mcipfile{i},[ix,iy,1,1],[1,1,1,inf]);
    wdir_sim((i-1)*24+1:i*24+1)=ncread(mcipfile{i},'WDIR10',[ix,iy,1,1],[1,1,1,inf]);
    wspd_sim((i-1)*24+1:i*24+1)=ncread(mcipfile{i},'WSPD10',[ix,iy,1,1],[1,1,1,inf]);
    rain_sim((i-1)*24+1:i*24+1)=ncread(mcipfile{i},'RN',[ix,iy,1,1],[1,1,1,inf])+ncread(mcipfile{i},'RC',[ix,iy,1,1],[1,1,1,inf]);
    pres_sim((i-1)*24+1:i*24+1)=ncread(mcipfile{i},'PRSFC',[ix,iy,1,1],[1,1,1,inf]);
end
t2_sim=t2_sim(17:end)'-273.15;
rh2_sim=rh2_sim(17:end)';
wdir_sim=wdir_sim(17:end)';
wspd_sim=wspd_sim(17:end)';
rain_sim=rain_sim(17:end)';
pres_sim=pres_sim(17:end)'/100;

% get t2, rh2, wdir, wspd, rain, pres in observation
[num,~]=xlsread('f:/vocs研究/中间产物/鹤山数据汇总_final.xlsx','meteo','b2:g706');
t2_obs=num(:,3);
rh2_obs=num(:,4);
wdir_obs=num(:,2);
wspd_obs=num(:,1);
pres_obs=num(:,5)*10;
rain_obs=num(:,6);

% set ttag
ttag=cell(15,1);
ttag(:)='';
for i=1:30
    ttag{i}=datestr(735892+2*i,'dd');
end

% statistic result
stat(7)=0;
stat(:)=0;

% compare t2
figure
plot(t2_sim,'b-','linewidth',4);
hold on
plot(t2_obs,'r-','linewidth',4);
set(gca,'xtick',1:48:705,'xticklabel',ttag,'xlim',[1 705],'fontsize',25);
ylabel('2m Temperature/℃','fontsize',25);
xlabel('Time','fontsize',25)
title('2m Temperature','fontsize',30);
stat(1)=nanmean(t2_obs);
stat(2)=nanmean(t2_sim);
stat(3)=get_mage(t2_obs,t2_sim);
stat(4)=get_mb(t2_obs,t2_sim);
stat(5)=get_rmse(t2_obs,t2_sim);
stat(6)=get_ioa(t2_obs,t2_sim);
stat(7)=get_cor(t2_obs,t2_sim);
disp(stat)

% compare rh2
figure
plot(rh2_sim,'b-','linewidth',4);
hold on
plot(rh2_obs,'r-','linewidth',4);
set(gca,'xtick',1:48:705,'xticklabel',ttag,'xlim',[1 705],'fontsize',25);
ylabel('2m Relative Humidity/%','fontsize',25);
xlabel('Time','fontsize',25)
title('2m Relative Humidity','fontsize',30);
stat(1)=nanmean(rh2_obs);
stat(2)=nanmean(rh2_sim);
stat(3)=get_mage(rh2_obs,rh2_sim);
stat(4)=get_mb(rh2_obs,rh2_sim);
stat(5)=get_rmse(rh2_obs,rh2_sim);
stat(6)=get_ioa(rh2_obs,rh2_sim);
stat(7)=get_cor(rh2_obs,rh2_sim);
disp(stat)

% compare wdir
figure
plot(wdir_sim,'b-','linewidth',4);
hold on
plot(wdir_obs,'r-','linewidth',4);
set(gca,'xtick',1:48:705,'xticklabel',ttag,'xlim',[1 705],'fontsize',25);
ylabel('10m Wind Direction/ °','fontsize',25);
xlabel('Time','fontsize',25)
title('10m Wind Direction','fontsize',30);
stat(1)=nanmean(wdir_obs);
stat(2)=nanmean(wdir_sim);
stat(3)=get_mage(wdir_obs,wdir_sim);
stat(4)=get_mb(wdir_obs,wdir_sim);
stat(5)=get_rmse(wdir_obs,wdir_sim);
stat(6)=get_ioa(wdir_obs,wdir_sim);
stat(7)=get_cor(wdir_obs,wdir_sim);
disp(stat)

% compare wspd
figure
plot(wspd_sim,'b-','linewidth',4);
hold on
plot(wspd_obs,'r-','linewidth',4);
set(gca,'xtick',1:48:705,'xticklabel',ttag,'xlim',[1 705],'fontsize',25);
ylabel('10m Wind Speed/m/s','fontsize',25);
xlabel('Time','fontsize',25)
title('10m Wind Speed','fontsize',30);
stat(1)=nanmean(wspd_obs);
stat(2)=nanmean(wspd_sim);
stat(3)=get_mage(wspd_obs,wspd_sim);
stat(4)=get_mb(wspd_obs,wspd_sim);
stat(5)=get_rmse(wspd_obs,wspd_sim);
stat(6)=get_ioa(wspd_obs,wspd_sim);
stat(7)=get_cor(wspd_obs,wspd_sim);
disp(stat)

% compare rain
figure
plot(rain_sim,'b-','linewidth',4);
hold on
plot(rain_obs,'r-','linewidth',4);
set(gca,'xtick',1:48:705,'xticklabel',ttag,'xlim',[1 705],'fontsize',25);
ylabel('Precipitation/cm','fontsize',25);
xlabel('Time','fontsize',25)
title('Precipitation','fontsize',30);
stat(1)=nanmean(rain_obs);
stat(2)=nanmean(rain_sim);
stat(3)=get_mage(rain_obs,rain_sim);
stat(4)=get_mb(rain_obs,rain_sim);
stat(5)=get_rmse(rain_obs,rain_sim);
stat(6)=get_ioa(rain_obs,rain_sim);
stat(7)=get_cor(rain_obs,rain_sim);
disp(stat)

% compare pres
figure
plot(pres_sim,'b-','linewidth',4);
hold on
plot(pres_obs,'r-','linewidth',4);
set(gca,'xtick',1:48:705,'xticklabel',ttag,'xlim',[1 705],'fontsize',25);
ylabel('Surface Pressure/hPa','fontsize',25);
xlabel('Time','fontsize',25)
title('Surface Pressure','fontsize',30);
stat(1)=nanmean(pres_obs);
stat(2)=nanmean(pres_sim);
stat(3)=get_mage(pres_obs,pres_sim);
stat(4)=get_mb(pres_obs,pres_sim);
stat(5)=get_rmse(pres_obs,pres_sim);
stat(6)=get_ioa(pres_obs,pres_sim);
stat(7)=get_cor(pres_obs,pres_sim);
disp(stat)