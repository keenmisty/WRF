clear

% set wrf path
wrffile=cell(744,1);
for i=1:31
    for j=0:23
        tmp=num2str(100+j);
        wrffile{(i-1)*24+j+1}=['../data_old/201007/wrfout_d01_',datestr(734319+i,29),'_',tmp(2:3),'_00_00'];
    end
end

% get lon and lat from wrf file
nlon=squeeze(ncread(wrffile{1},'XLONG',[1,1,1],[inf,inf,1]));
nlat=squeeze(ncread(wrffile{1},'XLAT',[1,1,1],[inf,inf,1]));

[nx,ny]=size(nlon);

pm25(nx,ny,744)=0;
u10(nx,ny,744)=0;
v10(nx,ny,744)=0;
for i=1:744
    pm25(:,:,i)=ncread(wrffile{i},'PM2_5_DRY',[1,1,1,1],[inf,inf,1,1]);
    u10(:,:,i)=ncread(wrffile{i},'U10',[1,1,1],[inf,inf,1]);
    v10(:,:,i)=ncread(wrffile{i},'V10',[1,1,1],[inf,inf,1]);
    disp(i)
end
pm25a=squeeze(mean(pm25,3));
u10a=squeeze(mean(u10,3));
v10a=squeeze(mean(v10,3));

load my

%% base
figure
m_proj('Lambert','lon',[111.9 115.5],'lat',[21.3 24.1],'par',[20,26],'fal',[113.7,23.5],'rec','on');
[~,H1]=m_contourf(nlon,nlat,pm25a,0:2:140);
set(H1,'edgecolor','none');
% caxis([0,250])
m_plotbndry('shengjie','color','k');
m_plotbndry('diqujie','color','k');
colormap(mycolor_noblue);

hold on
spacing=7;
m_quiver(nlon(1:spacing:end,1:spacing:end),nlat(1:spacing:end,1:spacing:end),u10a(1:spacing:end,1:spacing:end)/20,v10a(1:spacing:end,1:spacing:end)/20,'k','AutoScale','off');
% ah=annotation('textarrow',[0.88,0.92],[0.1,0.1],'string','5m/s ','headstyle','vback3','headwidth',4,'headlength',4,'fontsize',13);

% xlabel('Longitude','fontsize',15)
% ylabel('Latitude','fontsize',15);
hc=colorbar('fontsize',15);
% ylabel(hc,'PM_2_._5 (¦Ìg/m^3)','fontsize',18);
% set(hc,'ytick',[0:4:36],'yticklabel',{0:4:36})
m_grid('linestyle','none','box','on','tickdir','in','xtick',[112,113,114,115],'fontsize',14,'fontname','Times New Roman')