%在集群上提取数据
clear
clc
filename='/ees/users/EMG/ees2/shaofen/useful/domain/geo_em.d03.modis2usgs.nc';
f=netcdf(filename,'nowrite');
lat=squeeze(f{'XLAT_M'}(1,:,:));
lon=squeeze(f{'XLONG_M'}(1,:,:));
lu=squeeze(f{'LU_INDEX'}(1,:,:));
rang_lon=[min(min(lon)),max(max(lon))];    
rang_lat=[min(min(lat)),max(max(lat))];  
save('lu_sta.mat','lon','lat','lu','rang_lon','rang_lat');
%%
%在本地机子上面画图
clear
clc
cd('O:\毕业论文脚本')
load lu_sta.mat %打开数据文件（按实际情况填写）
figure(1)
clf
set(gcf,'Position',[150,150,800,600])
axes('Position',[0.1 0.1 0.8 0.8])
cd('H:\Program Files\MATLAB\R2008a\work\m_map') %去到m_proj、m_pcolor、m_plotbndry、m_grid等m文件的存放目录（按实际情况填写）
r1=lu-1;
 pcolorvalue=r1;
a=[255  25  25 
 178 184 255
 255 136  76 
 237 230 133
 205 198 115 
  125  37 205
  84  26 139 
 150 150 150
 170 255 255
 29  0 255
  237   0 237
  0 255   0
  78 204  67
  46 178  57
  30 153  61
  85 160 255
 255 204 102
 255 255 102
 255  255  0   
 255  85   0
 204  61  61
 165  49  49
 137 103 205
 128 128 128];
bb=a./255;
colormap(bb)
pcolor([1:24;1:24])
rang=[0 24];
rang_lon1=[rang_lon(1)+0.3 rang_lon(2)-0.3];
rang_lat1=[rang_lat(1)+0.2 rang_lat(2)-0.2];
m_proj('Lambert Conformal Conic','lon',rang_lon1,'lat',rang_lat1,'clo',113.7,'par',[20 25.7],'rec','on');%按实际情况设定投影情况
m_pcolor(lon,lat,pcolorvalue);
shading flat
%针对以下4行，分别启用前2行或后2行，来生成图像，最终将两张图合成得到好看的colorbar数值标示结果
%labels={'0','','2','','4','','6','','8','','10','','12','','14','','16','','18','','20','','22','','24'};
%caxis(rang),colorbar('YLim',rang,'YTick',0:1:24,'YTickLabel',labels,'FontSize',15);
labels={'','2','','4','','6','','8','','10','','12','','14','','16','','18','','20','','22','','24'};
caxis(rang),colorbar('YLim',rang,'YTick',0.5:1:23.5,'YTickLabel',labels,'FontSize',15);
set(gca,'LineStyle','-','LineWidth',1,'FontName','Times New Roman','FontWeight','bold','FontSize',20);
hold on,
m_plotbndry('shengjie','color','k','Linewidth',1);
m_plotbndry('diqujie','color','k','Linewidth',1);
m_plotbndry('prd_boundary','color','k','Linewidth',2);
m_grid('box','fancy','xtick',5)
title(strcat('Landuse Index '),'FontName','Times New Roman','FontWeight','bold','FontSize',25);
cd('O:\毕业论文脚本\') %保存图片的目录（按实际情况填写）
saveas(gcf,strcat('lu_','index1'),'png'); 

