try
    % Main block
clear
clc
% calculate variables from NoahMP results
cd ('/ees/eeswxm/chang/Noah/arizona/NCAR_noahmp/test_dveg/result')
load ext_heats1.mat
fcev1=fcev;
%fgev1=fgev;
%fctr1=fctr;
%ssoil1=ssoil;
%fsr1=fsr;
%fira1=fira;
clear fcev fgev fctr ssoil fsr fira
load ext_heats2.mat
fcev2=fcev;
%fgev2=fgev;
%fctr2=fctr;
%ssoil2=ssoil;
%fsr2=fsr;
%fira2=fira;
clear fcev fgev fctr ssoil fsr fira
load ext_heats3.mat
fcev3=fcev;
%fgev3=fgev;
%fctr3=fctr;
%ssoil3=ssoil;
%fsr3=fsr;
%fira3=fira;
clear fcev fgev fctr ssoil fsr fira
load ext_heats4.mat
fcev4=fcev;
%fgev4=fgev;
%fctr4=fctr;
%ssoil4=ssoil;
%fsr4=fsr;
%fira4=fira;
clear fcev fgev fctr ssoil fsr fira
load Ilost.mat

fcev=[fcev1,fcev2,fcev3,fcev4];
%fgev=[fgev1,fgev2,fgev3,fgev4];
%fctr=[fctr1,fctr2,fctr3,fctr4];
%ssoil=[ssoil1,ssoil2,ssoil3,ssoil4];
%fsr=[fsr1,fsr2,fsr3,fsr4];
%fira=[fira1,fira2,fira3,fira4];
clear fcev1 %fgev1 fctr1 ssoil1 fsr1 fira1
clear fcev2 %fgev2 fctr2 ssoil2 fsr2 fira2
clear fcev3 %fgev3 fctr3 ssoil3 fsr3 fira3
clear fcev4 %fgev4 fctr4 ssoil4 fsr4 fira4

%obs=xlsread('tongliangyz.xlsx','gc');
%lengthobs=length(obs)-1;
%obsm=obs(1:end-1,3:4);
load obsm.mat
%clear obs
[yyyy mm dd HH MIN windspeed winddir temperature humidity pressure shortwave longwave precipitation]=textread('2010tltzl_utc.dat','%s%s%s%s%s%f%f%f%f%f%f%f%f','headerlines',1);
clear yyyy mm dd HH MIN windspeed winddir temperature humidity pressure shortwave longwave;
for i =1:17519-3;
    if obsm(i,1)>500;%潜热观测异常
        fcev(i,:)=NaN;
%        fgev(i,:)=NaN;
%        fctr(i,:)=NaN;
%        ssoil(i,:)=NaN;
%        fsr(i,:)=NaN;
%        fira(i,:)=NaN;
%        obsm(i,:)=NaN;         
    end
    if obsm(i,1)<-100;%潜热观测异常
        fcev(i,:)=NaN;
%        fgev(i,:)=NaN;
%        fctr(i,:)=NaN;
%        ssoil(i,:)=NaN;
%        fsr(i,:)=NaN;
%        fira(i,:)=NaN;     
%        obsm(i,:)=NaN;
    end
    if obsm(i,2)>500;%显热观测异常
        fcev(i,:)=NaN;
%        fgev(i,:)=NaN;
%        fctr(i,:)=NaN;
%        ssoil(i,:)=NaN;
%        fsr(i,:)=NaN;
%        fira(i,:)=NaN;
%        obsm(i,:)=NaN;
    end
    if obsm(i,2)<-100;%显热观测异常
        fcev(i,:)=NaN;
%        fgev(i,:)=NaN;
%        fctr(i,:)=NaN;
%        ssoil(i,:)=NaN;
%        fsr(i,:)=NaN;
%        fira(i,:)=NaN;
%        obsm(i,:)=NaN;
    end
    if find(i==Ilost);%气象及通量塔缺失值
        fcev(i,:)=NaN;
%        fgev(i,:)=NaN;
%        fctr(i,:)=NaN;
%        ssoil(i,:)=NaN;
%        fsr(i,:)=NaN;
%        fira(i,:)=NaN;
%        obsm(i,:)=NaN;
    end
    if precipitation(i)>0;%去除降水时及降水后三小时值
        fcev(i:i+3,:)=NaN;
%        fgev(i:i+3,:)=NaN;
%        fctr(i:i+3,:)=NaN;
%        ssoil(i:i+3,:)=NaN;
%        fsr(i:i+3,:)=NaN;
%        fira(i:i+3,:)=NaN;
%        obsm(i:i+3,:)=NaN;
    end
    disp(i);
end
clear precipitation Ilost i;

   for  i =1:17519;
       if isnan(obsm(i,1));%气象及通量塔缺失值
        fcev(i,:)=NaN;
%        fgev(i,:)=NaN;
%        fctr(i,:)=NaN;
%        ssoil(i,:)=NaN;
%        fsr(i,:)=NaN;
%        fira(i,:)=NaN;
%        obsm(i,2)=NaN;
       end;
       if isnan(obsm(i,2));%气象及通量塔缺失值
        fcev(i,:)=NaN;
%        fgev(i,:)=NaN;
%        fctr(i,:)=NaN;
%        ssoil(i,:)=NaN;
%        fsr(i,:)=NaN;
%        fira(i,:)=NaN;
%        obsm(i,1)=NaN;
       end;
       disp(i)
   end;
clear i;

save('ext_heat_fl.mat','fcev');%,'fgev','fctr','ssoil','fsr','fira');

%clear all



%cm1=[];
%for i =1:55296
% z=find(~isnan(fcev(:,i)));
% MN30min_mpd=[fcev(z,i),fgev(z,i),fgev(z,i),fgev(z,i),fgev(z,i),fgev(z,i)];
% zd=find(~isnan(obsm(:,1)));
% obsmd=obsm(zd,:);
% MBE1=MN30min_mpd-obsmd;
% MBE=[mean(MBE1(:,1)),mean(MBE1(:,2))];%均方误差
% SD=[abs(1-std(MN30min_mpd(:,1))/std(obsmd(:,1))),abs(1-std(MN30min_mpd(:,2))/std(obsmd(:,2)))];%标准差比
% CORRCOEF=[corrcoef(MN30min_mpd(:,1),obsmd(:,1)),corrcoef(MN30min_mpd(:,2),obsmd(:,2))];%相关系数
% NMEd=[sum(abs(MBE1(:,1))),sum(abs(MBE1(:,2)))];
% lwh=[sum(abs(mean(obsmd(:,1)).*ones(length(obsmd(:,1)),1)-obsmd(:,1))),sum(abs(mean(obsmd(:,2)).*ones(length(obsmd(:,2)),1)-obsmd(:,2)))];
% NME=[NMEd(1)/lwh(1),NMEd(2)/lwh(2)];%normalised mean error;
%smmn15=prctile(MN30min_mpd(:,1),5);
%smmn25=prctile(MN30min_mpd(:,2),5);
%smob15=prctile(obsmd(:,1),5);
%smob25=prctile(obsmd(:,2),5);
%fweishu5=[abs(smmn15-smob15),abs(smmn25-smob25)];%5百分位数;
%smmn195=prctile(MN30min_mpd(:,1),95);
%smmn295=prctile(MN30min_mpd(:,2),95);
%smob195=prctile(obsmd(:,1),95);
%smob295=prctile(obsmd(:,2),95);
%fweishu95=[abs(smmn195-smob195),abs(smmn295-smob295)];%95百分位数;

%lwhlwh=[MBE,SD,CORRCOEF(1,2),CORRCOEF(1,4),NME,fweishu5,fweishu95];
% cm1=[cm1;lwhlwh];
% disp(i)
%end
%clear qfx sheat z zd M* sm* lw* fw* obs* NM* SD COR* i
%save('result1.mat','cm1');

catch err
    errmsg=err.message
%    exit
end

