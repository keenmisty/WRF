clear
load E:\Share\360\Papers\Assimilation\Script\mat\location.mat
SPEC={'NO2' 'SO2' 'PM10' 'O3'};
OBS2=[];
SIM2=[];
for sp=1:3
    sp=1;
MONTH={'01','04','07','11'};mo=4;
%% 读入11月站点观测值
eval(['load E:\Share\360\Papers\Assimilation\Script\mat\2010',MONTH{mo},'sites.mat OBS_',SPEC{sp},'_2010_',MONTH{mo}])
eval(['OBS=OBS_',SPEC{sp},'_2010_',MONTH{mo},';']);
n=0;
%% 读入11月站点模拟值
eval(['load E:\Share\360\Papers\Assimilation\Script\mat\2010',MONTH{mo},'sites.mat SIM_',SPEC{sp},'_2010_',MONTH{mo}])
eval(['SIM=SIM_',SPEC{sp},'_2010_',MONTH{mo},';']);
ALL=[SIM', OBS'];
A=ALL(1:10,:);
B=[ALL(13,:);ALL(15:17,:);ALL(19:22,:)];
% SIM_A=reshape(A(:,1:30),300,1);
% OBS_A=reshape(A(:,31:60),300,1);
% SIM_B=reshape(B(:,1:30),240,1);
% OBS_B=reshape(B(:,31:60),240,1);
SIM=[A(:,1:30);B(:,1:30)];
OBS=[A(:,31:60);B(:,31:60)];
for i=1:18
    x=OBS(i,:);
    OBS(i,:)=OBS(i,:)/nanstd(x,1);
    SIM(i,:)=SIM(i,:)/nanstd(x,1);
end
OBS2=[OBS2;OBS(1:18,:)];
SIM2=[SIM2;SIM(1:18,:)];
end
clear C statm
statm(1,:)=[0,1,0,1];
for i=2:55
C = allstats(OBS2(i-1,:)',SIM2(i-1,:)');
statm(i,:) = C(:,2);
end

% for ii = 2:2
%     C = allstats(OBS(i-1,:)',SIM(i-1,:)');
%     statm(ii,:) = C(:,2);
% end
% statm(1,:) = C(:,1);

% [pp tt axl] = taylordiag(squeeze(statm(:,2)),squeeze(statm(:,3)),squeeze(statm(:,4)),...
%             'tickRMS',[25:25:150],'titleRMS',0,'tickRMSangle',135,'showlabelsRMS',0,'widthRMS',1,...
%             'tickSTD',[25:25:250],'limSTD',250,...
%             'tickCOR',[.1:.1:.9 .95 .99],'showlabelsCOR',1,'titleCOR',1);
figure(2)
[pp tt axl] = taylordiag(squeeze(statm(:,2)),squeeze(statm(:,3)),squeeze(statm(:,4)),'tickSTD',[0.5:0.5:1.5],'limSTD',1.5);

% 
% SO2=data(1:3:end,:); 
% NO2=data(2:3:end,:); 
% PM10=data(3:3:end,:); 
% [pp tt axl] = taylordiag(SO2(:,2),SO2(:,1),SO2(:,7));
% 
% 
% load E:\Share\360\Papers\Assimilation\Script\mat\location.mat
% SPEC={'NO2' 'SO2' 'PM10' 'O3'};sp=1;
% MONTH={'01','04','07','11'};mo=4;
% %% 读入11月站点观测值
% eval(['load E:\Share\360\Papers\Assimilation\Script\mat\2010',MONTH{mo},'sites.mat OBS_',SPEC{sp},'_2010_',MONTH{mo}])
% eval(['OBS=OBS_',SPEC{sp},'_2010_',MONTH{mo},';']);
% n=0;
% %% 读入11月站点模拟值
% eval(['load E:\Share\360\Papers\Assimilation\Script\mat\2010',MONTH{mo},'sites.mat SIM_',SPEC{sp},'_2010_',MONTH{mo}])
% eval(['SIM=SIM_',SPEC{sp},'_2010_',MONTH{mo},';']);
% ALL=[SITE, SIM', OBS'];
% [ALL(5,:),ALL(10,:)]=fexch(ALL(5,:),ALL(10,:));
% ALL=[ALL(10:22,:);ALL(1:9,:);ALL(23:57,:)];
% SITE=[ALL(:,1:2),(1:57)'];
% SITE2=SITE;
% SIM=ALL(:,3:32);
% OBS=ALL(:,33:62);
