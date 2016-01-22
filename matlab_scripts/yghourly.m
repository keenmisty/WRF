clear all
clc
cd('E:\met')
% nsta=10;
% dayst=1;
% dayend=31;

load gzhourly2010.mat
% 
% %广雅中学 第五中学 市监测站 天河职幼 麓湖 广东商学院 市86中学 番禺中学 花都师范 九龙镇镇龙
% %10个站点，6个污染物
% %SO2	NO2	CO	NO	NOX	O3 mg/m3
% % sta_time=datevec(gzhourly2010(6565;7309,1));
gzhourly2010_10=gzhourly2010(6565:7308,:);
% 
% Time=datestr(gzhourly2010_10(:,1),'mmm.dd HH:MM');

Time=gzhourly2010_10(:,1);
% clear gz*
so2_obs_gz=[gzhourly2010_10(:,2),gzhourly2010_10(:,8),gzhourly2010_10(:,14),gzhourly2010_10(:,20),...
    gzhourly2010_10(:,26),gzhourly2010_10(:,32),gzhourly2010_10(:,38),gzhourly2010_10(:,44),gzhourly2010_10(:,50),gzhourly2010_10(:,56)];
no2_obs_gz=[gzhourly2010_10(:,3),gzhourly2010_10(:,9),gzhourly2010_10(:,15),gzhourly2010_10(:,21),...
    gzhourly2010_10(:,27),gzhourly2010_10(:,33),gzhourly2010_10(:,39),gzhourly2010_10(:,45),gzhourly2010_10(:,51),gzhourly2010_10(:,57)];
co_obs_gz=[gzhourly2010_10(:,4),gzhourly2010_10(:,10),gzhourly2010_10(:,16),gzhourly2010_10(:,22),...
    gzhourly2010_10(:,28),gzhourly2010_10(:,34),gzhourly2010_10(:,40),gzhourly2010_10(:,46),gzhourly2010_10(:,52),gzhourly2010_10(:,58)];
no_obs_gz=[gzhourly2010_10(:,5),gzhourly2010_10(:,11),gzhourly2010_10(:,17),gzhourly2010_10(:,23),...
    gzhourly2010_10(:,29),gzhourly2010_10(:,35),gzhourly2010_10(:,41),gzhourly2010_10(:,47),gzhourly2010_10(:,53),gzhourly2010_10(:,59)];
nox_obs_gz=[gzhourly2010_10(:,6),gzhourly2010_10(:,12),gzhourly2010_10(:,18),gzhourly2010_10(:,24),...
    gzhourly2010_10(:,30),gzhourly2010_10(:,36),gzhourly2010_10(:,42),gzhourly2010_10(:,48),gzhourly2010_10(:,54),gzhourly2010_10(:,60)];
o3_obs_gz=[gzhourly2010_10(:,7),gzhourly2010_10(:,13),gzhourly2010_10(:,19),gzhourly2010_10(:,25),...
    gzhourly2010_10(:,31),gzhourly2010_10(:,37),gzhourly2010_10(:,43),gzhourly2010_10(:,49),gzhourly2010_10(:,55),gzhourly2010_10(:,61)];

clear gzhourly2010 gzhourly2010_10
% 
load racm43_allen4_201010_gzhourly.mat

gz_no2_interp=no2_interp;
gz_no_interp=no_interp;
gz_so2_interp=so2_interp;
gz_o3_interp=o3_interp;
gz_pm10_interp=pm10_interp;

clear no2_interp no_interp so2_interp o3_interp pm10_interp
% % pl-sta.mat 顺序
% 1    % 麓湖公园       
% 2   % 南沙万顷沙站   
% 3    % 天湖           
% 4    % 荔园
% 5    % 唐家
% 6    % 金桔咀
% 7    % 惠景城
% 8    % 东湖
% 9    % 城中子站
% 10    % 下埔
% 11    % 金果湾
% 12    % 豪岗小学
% 13    % 紫马岭站
% 14    % 荃湾
% 15    % 塔門
% 16    % 東涌

% % % "CO(mg/m3)"	"NO(mg/m3)"	"NO2(mg/m3)"	"NOX(mg/m3)"	"O3(mg/m3)"	"PM10(mg/m3)"	"PM2.5(mg/m3)"	"SO2(mg/m3)"

obs_data_cz=xlsread('201010粤港网小时值数据.xls','城中','C2:J745');
obs_data_jjj=xlsread('201010粤港网小时值数据.xls','金桔咀','C2:J746');
obs_data_hjc=xlsread('201010粤港网小时值数据.xls','惠景城','C2:J746');
obs_data_dh=xlsread('201010粤港网小时值数据.xls','东湖','C2:J746');
obs_data_zml=xlsread('201010粤港网小时值数据.xls','紫马岭','C2:J746');
obs_data_tj=xlsread('201010粤港网小时值数据.xls','唐家','C2:J746');
obs_data_hg=xlsread('201010粤港网小时值数据.xls','豪岗','C2:J746');
obs_data_jgw=xlsread('201010粤港网小时值数据.xls','金果湾','C2:J746');
obs_data_xp=xlsread('201010粤港网小时值数据.xls','下埔','C2:J746');
obs_data_ly=xlsread('201010粤港网小时值数据.xls','荔园','C2:J746');
obs_data_lh=xlsread('201010粤港网小时值数据.xls','麓湖','C2:J746');
obs_data_wqs=xlsread('201010粤港网小时值数据.xls','万顷沙','C2:J746');
obs_data_th=xlsread('201010粤港网小时值数据.xls','天湖','C2:J746');
obs_data=zeros(744,8,13);
obs_data(obs_data==0)=NaN;
obs_data(:,:,9)=obs_data_cz;
obs_data(:,:,6)=obs_data_jjj;
obs_data(:,:,7)=obs_data_hjc;
obs_data(:,:,8)=obs_data_dh;
obs_data(:,:,13)=obs_data_zml;
obs_data(:,:,5)=obs_data_tj;
obs_data(:,:,12)=obs_data_hg;
obs_data(:,:,11)=obs_data_jgw;
obs_data(:,:,10)=obs_data_xp;
obs_data(:,:,4)=obs_data_ly;
obs_data(:,:,1)=obs_data_lh;
obs_data(:,:,2)=obs_data_wqs;
obs_data(:,:,3)=obs_data_th;

obs_data(obs_data==-999)=NaN;

obs_co_mgm3=squeeze(obs_data(:,1,:));
obs_no_mgm3=squeeze(obs_data(:,2,:));
obs_no2_mgm3=squeeze(obs_data(:,3,:));
obs_nox_mgm3=squeeze(obs_data(:,4,:));
obs_o3_mgm3=squeeze(obs_data(:,5,:));
obs_pm10_mgm3=squeeze(obs_data(:,6,:));
obs_pm25=squeeze(obs_data(:,7,:));
obs_so2_mgm3=squeeze(obs_data(:,8,:));
clear obs_data_*

obs_so2=obs_so2_mgm3.*1000;
obs_no2=obs_no2_mgm3.*1000;
obs_o3=obs_o3_mgm3.*1000;
obs_no=obs_no_mgm3.*1000;
obs_nox=obs_nox_mgm3.*1000;
obs_pm10=obs_pm10_mgm3.*1000;
clear *_mgm3

load racm43_allen4_201010_lu2010_yghourly.mat
% no2_interp_lu2010=no2_interp;
% load racm43_allen4_201010_lu1990_yghourly.mat
% no2_interp_lu1990=no2_interp;

% nox_interp=no_interp+no2_interp;
% X2=0:73;
%     X2_rang=[min(X2),max(X2)];
%     X1_interal=1;
    X2_interal=48;
% Title_TABLE_1={'广雅中学','第五中学','市监测站','天河职幼','麓湖','广东商学院','市86中学','番禺中学','花都师范','九龙镇镇龙'};
% Title_TABLE_1={'麓湖公园','万顷沙站','天湖','荔园','唐家','金桔咀','惠景城','东湖','城中子站','下埔','金果湾','豪岗小学','紫马岭站'};

Title_TABLE_1={'麓湖公园','万顷沙站','天湖','荔园','唐家','金桔咀','惠景城','东湖','城中子站','下埔','金果湾','豪岗小学','紫马岭站','广雅中学','第五中学','市监测站','天河职幼','麓湖','广东商学院','市86中学','番禺中学','花都师范','九龙镇镇龙'};
%逐个跑，逐个保存
for i=1:13   % Draw O3 concentration plots
    figure(1)
 %   clf
%     set(gcf,'Position',[20,150,1000,450])
%     axes('Position',[0.13 0.20 0.85 0.70])
    
    subplot(7,2,i);
%     p1=plot(Time(1:744),obs_no2(1:744,i),'.k',Time(1:744),no2_interp_lu2010(1:744,i),'r-',Time(1:744),no2_interp_lu1990(1:744,i),'b-','LineWidth',0.2);
    p1=plot(Time(1:744),obs_so2(1:744,i),'.k',Time(1:744),so2_interp(1:744,i),'r-','LineWidth',0.2);
    hold on; 
    %     p1=plot(X2(1:360),OBS_O3(1:360,i),'kp-',X2(1:360),1000*48/22.4*SIM_O3_newship(1:360,i),'gs-',X2(1:360),1000*48/22.4*SIM_O3_newnoship_up(1:360,i),'r*-','MarkerSize',3,'LineWidth',1);
    %xlim(X2_rang);
    ylim([0 250])
    hold on;
    set(gca,'XTick',Time(1:X2_interal:744));
    hold on;

%     hold on;
%     label={'8','16','0','8','16','0','8','16','0','8'};
%     hold on;
%     set(gca,'XTickLabel',label);
      
   datetick('x','dd','keeplimits','keepticks');    
    set(gca,'FontWeight','bold','FontSize',8,'TickDir','out');hold on
    xlabel(strcat(Title_TABLE_1(i),'   2010, Oct'),'FontWeight','bold','FontSize',10);
    ylabel(strcat('SO_2','    ',' ug/m^3'),'FontWeight','bold','FontSize',10);
    hold on;
    legend1=legend ('OBS','SIM');
%          legend1=legend ('OBS','SIM-lu2010','SIM-lu1990');
    set(legend1,'Orientation','horizontal','EdgeColor',[1 1 1],'YColor',[1 1 1],'XColor',[1 1 1],...
        'FontSize',6);
     box(subplot(7,2,i),'on');
    hold(subplot(7,2,i),'all');
    hold on
%     cd ('E:\Scripts\污染验证\O3\')
 %   saveas(gcf,strcat('O3_','hourave'),'emf');
 %   close(i)
end