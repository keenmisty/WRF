% check the wrf out file from 'read_wrfout.m'
clear all; clc; close all;
%--
BD=shaperead('~/mydata/mapdata/province_bdy/bou2_4l.shp');
%--
fileout='./WRFOUTtest_d01.nc';
fid=netcdf.open(fileout, 'NC_NOWRITE');
dd=netcdf.inqVarID(fid, 'XLONG');
dd =netcdf.getVar(fid,dd); 
xlong=double(permute(dd,[2 1]));clear dd
dd=netcdf.inqVarID(fid, 'XLAT');
dd =netcdf.getVar(fid,dd); 
xlat=double(permute(dd,[2 1]));clear dd
map_lon=[min(min(xlong))-2  max(max(xlong))+2];
map_lat=[min(min(xlat))-2   max(max(xlat))+2];
%--
dd=netcdf.inqVarID(fid, 'LU_INDEX');
dd =netcdf.getVar(fid,dd); 
landuse=double(permute(dd,[2 1]));clear dd
figure(1);
worldmap(map_lat, map_lon);
hp=pcolorm(xlat, xlong, landuse); 
set(hp,'edgecolor','none');
colorbar
hold on
for ii=1:length(BD)
     plotm(BD(ii).Y, BD(ii).X, 'k-');
end
%--
dd=netcdf.inqVarID(fid, 'ACHFX');
dd =netcdf.getVar(fid,dd); 
hfx=double(permute(dd,[2 1 3]));clear dd
dd=netcdf.inqVarID(fid, 'ACLHF');
dd =netcdf.getVar(fid,dd); 
lhf=double(permute(dd,[2 1 3]));clear dd
figure(2);
subplot(2,2,1)
worldmap(map_lat, map_lon);
hp=pcolorm(xlat, xlong, mean(hfx, 3)/(24*3600)); 
set(hp,'edgecolor','none');
colorbar
hold on
for ii=1:length(BD)
     plotm(BD(ii).Y, BD(ii).X, 'k-');
end
subplot(2,2,2)
worldmap(map_lat, map_lon);
hp=pcolorm(xlat, xlong, mean(lhf, 3)/(24*3600)); 
set(hp,'edgecolor','none');
colorbar
hold on
for ii=1:length(BD)
     plotm(BD(ii).Y, BD(ii).X, 'k-');
end
subplot(2,2,3)
plot(squeeze(hfx(55,55,:))/(24*3600), 'r--'); hold on
plot(squeeze(lhf(55,55,:))/(24*3600), 'b-');
legend('HFX','LHF')
subplot(2,2,4)
plot(squeeze(hfx(65,65,:))/(24*3600), 'r--'); hold on
plot(squeeze(lhf(65,65,:))/(24*3600), 'b-');
legend('HFX','LHF')
%%%%
dd=netcdf.inqVarID(fid, 'RAINC');
dd =netcdf.getVar(fid,dd); 
rainc=double(permute(dd,[2 1 3]));clear dd
dd=netcdf.inqVarID(fid, 'RAINNC');
dd =netcdf.getVar(fid,dd); 
rainnc=double(permute(dd,[2 1 3]));clear dd
figure(3);
subplot(2,2,1)
worldmap(map_lat, map_lon);
hp=pcolorm(xlat, xlong, mean(rainc, 3)*30); 
set(hp,'edgecolor','none');
colorbar
hold on
for ii=1:length(BD)
     plotm(BD(ii).Y, BD(ii).X, 'k-');
end
subplot(2,2,2)
worldmap(map_lat, map_lon);
hp=pcolorm(xlat, xlong, mean(rainnc, 3)*30); 
set(hp,'edgecolor','none');
colorbar
hold on
for ii=1:length(BD)
     plotm(BD(ii).Y, BD(ii).X, 'k-');
end
subplot(2,2,3)
plot(squeeze(rainc(55,55,:)),'r--'); hold  on
plot(squeeze(rainnc(55,55,:)),'b-');
legend('Cumul R','Grid R')
subplot(2,2,4)
plot(squeeze(rainc(65,65,:)),'r--'); hold  on
plot(squeeze(rainnc(65,65,:)),'b-');
legend('Cumul R','Grid R')
% %--
% 
dd=netcdf.inqVarID(fid, 'Z');
dd =netcdf.getVar(fid,dd); 
z=double(permute(dd,[2 1 3 4]));clear dd
dd=netcdf.inqVarID(fid, 'P');
dd =netcdf.getVar(fid,dd); 
p=double(permute(dd,[2 1 3 4]));clear dd
obj_lev=500;

for tt=1:size(z,4)
     temp_z=z(:, :, :, tt);
     temp_p=p(:, :, :, tt);
 %    dd=dd(:,:,1:end-1).*dd(:,:,2:end);
      obj_p1=nan*xlong;
      obj_p2=nan*xlong;
      obj_z1=nan*xlong;
      obj_z2=nan*xlong;
 %
     for plv=1:size(z,3)-1
           zz1=temp_z(:, :, plv);
           zz2=temp_z(:, :, plv+1);
           pp1=temp_p(:, :, plv);
           pp2=temp_p(:, :, plv+1);
           %
           ppflg=find(((pp1-obj_lev).*(pp2-obj_lev))<0);
           if length(ppflg)>0
              obj_p1(ppflg)=pp1(ppflg);
              obj_p2(ppflg)=pp2(ppflg);
              obj_z1(ppflg)=zz1(ppflg);
              obj_z2(ppflg)=zz2(ppflg);
           end
           clear ppflg zz1 zz2 pp1 pp2
     end
     aa1=abs(obj_p1-obj_lev)./abs(obj_p1-obj_p2);
     aa2=abs(obj_p2-obj_lev)./abs(obj_p1-obj_p2);
     temp_z=obj_z1.*aa2+obj_z2.*aa1;
     % clear obj_p1  obj_p2 obj_z1 obj_z2  aa1  aa2
%
     if tt==1
         obj_z=temp_z;
     else
         obj_z(:,:,tt)=temp_z;
     end
     clear temp_z
end
% 
figure(4);
worldmap(map_lat, map_lon);
[hh cc]=contourfm( xlat,xlong, mean(obj_z(:,:,3:4),3)*0.1); 
colorbar
hold on
for ii=1:length(BD)
     plotm(BD(ii).Y, BD(ii).X, 'k-','color',[1 1 1]);
end
% 
figure(5);
worldmap(map_lat, map_lon);
[hh cc]=contourfm( xlat,xlong, mean(obj_z(:,:,13:14),3)*0.1); 
colorbar
hold on
for ii=1:length(BD)
     plotm(BD(ii).Y, BD(ii).X, 'k-','color',[1 1 1]);
end
% dd=netcdf.inqVarID(fid, 'SMOIS');
% dd =netcdf.getVar(fid,dd); 
% smois=double(permute(dd,[2 1 3 4]));clear dd
% dd=netcdf.inqVarID(fid, 'T2');
% dd =netcdf.getVar(fid,dd); 
% t2=double(permute(dd,[2 1 3]));clear dd
%------------------------------------
netcdf.close(fid)