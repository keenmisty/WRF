function temp_3d=readwrf_3d(fid, wrf_times, varname, yr, mn, seg_nt, monthly_Tdays);
%---------------------
% define the constants
g=9.81;
r_d=287.0;
cp=7.0*r_d/2;
rcp=r_d/cp;
p1000mb  = 100000.0;
T0=273.16;
%=====================
[tempd WRFTM]=read3d(fid, wrf_times, varname, yr, mn); 
dys=str2num(WRFTM(:,9:10));
%------------------------
if strcmp(varname, 'U')
    tempd=0.5*(tempd(1:end-1,:,:,:)+tempd(2:end,:,:,:));
elseif strcmp(varname, 'V')
    tempd=0.5*(tempd(:, 1:end-1,:,:)+tempd(:, 2:end,:,:));
elseif strcmp(varname,'W')
     tempd=0.5*(tempd(:, :, 1:end-1, :)+tempd(:, :, 2:end, :));
elseif strcmp(varname, 'P')
     [tempd1 WRFTM2]=read3d(fid, wrf_times, 'PB' , yr, mn); clear WRFTM2
     tempd = (tempd+tempd1)*0.01; clear tempd1
elseif strcmp(varname, 'Z')
     [tempd1 WRFTM2]=read3d(fid, wrf_times, 'PHB', yr, mn); clear WRFTM2
     tempd= (tempd + tempd1)/9.81;
     tempd=0.5*(tempd(:, :, 1:end-1, :)+tempd(:, :, 2:end, :));  clear tempd1
elseif strcmp(varname,'THETA')
     tempd=tempd+300.0;
elseif strcmp(varname, 'TK')
     [PP WRFTM2]=read3d(fid, wrf_times, 'P', yr, mn); clear WRFTM2
     [PBPB WRFTM2]=read3d(fid, wrf_times, 'PB', yr, mn); clear WRFTM2
     PP=PP+PBPB;
     tempd= (tempd +300.0).* (PP/p1000mb).^rcp;    clear PP PBPB
elseif strcmp(varname, 'TC')
     [PP WRFTM2]=read3d(fid, wrf_times, 'P', yr, mn); clear WRFTM2
     [PBPB WRFTM2]=read3d(fid, wrf_times, 'PB', yr, mn); clear WRFTM2
     PP=PP+PBPB;
     tempd= (tempd +300.0).* (PP/p1000mb).^rcp - T0;    clear PP PBPB
elseif strcmp(varname, 'TD')
     [PP WRFTM2]=read3d(fid, wrf_times, 'P', yr, mn); clear WRFTM2
     [PBPB WRFTM2]=read3d(fid, wrf_times, 'PB', yr, mn); clear WRFTM2
     PP=PP+PBPB;
     tempd = tempd .* (PP/100.0) ./ (0.622+tempd);  clear PP PBPB
     tempd (tempd < 0.001) =0.001;
     tempd=(243.5*log(tempd)-440.8)./(19.48-log(tempd));
elseif strcmp(varname, 'RH')
     [PP WRFTM2]=read3d(fid, wrf_times, 'P', yr, mn); clear WRFTM2
     [PBPB WRFTM2]=read3d(fid, wrf_times, 'PB', yr, mn); clear WRFTM2
     PP=PP+PBPB;
     [TT WRFTM2]=read3d(fid, wrf_times, 'T', yr, mn); clear WRFTM2
     TT = (TT+300.0).*(PP/p1000mb).^rcp;
     tmp2=10*0.6112*exp(17.67*(TT-T0)./(TT-29.65));
     tmp2= 0.622*tmp2./(0.01*PP - (1-0.622)*tmp2);
     tempd = tempd./tmp2; clear tmp2 TT PP PBPB
     tempd(tempd>1) = 1;
     tempd(tempd<0) = 0;
     tempd=tempd*100.0;
end
%------------------------------
hrs=str2num(WRFTM(:,12:13));
%hp=pcolor(mean(tempd,3));set(hp,'edgecolor','none');colorbar
% search the interval of hours
hourID=unique(hrs);day_times=length(hourID);
%--------------------------------  process day by day
tempd_mod=nan*tempd(:,:,:,1);
for ii=1:monthly_Tdays
    flg = find(dys==ii & hrs==0);
    if length(flg)>0
       flg = min(flg);
       tempd_mod=mean(tempd(:,:,:,flg:flg+day_times-1),4);
    end
    if ii==1
       tempd_daily=tempd_mod;
    else
       tempd_daily(:,:,:,ii)=tempd_mod;
    end
    tempd_mod(:,:,:)=nan;
end
clear tempd_mod
%----------------------------------------------------
%----------------------------
%disp(' in readwrf_2d_accmu')
if seg_nt==1 % monthly
   temp_3d=nanmean(tempd_daily,4);
elseif seg_nt==2 % bi-monthly
   tempd(:,:,1)=nanmean(tempd_daily(:,:,:,1:15),4);
   tempd(:,:,2)=nanmean(tempd_daily(:,:,:,16:end),4);
   temp_3d       =tempd(:,:,:,1:2);
else %  daily
   temp_3d=tempd_daily;
end

%= ====================
function  [tempd WRFTM]=read3d(fid , wrf_times,  varname, yr, mn); 
%
if strcmp(varname, 'Z'); varname='PH'; end
if strcmp(varname, 'THETA'); varname='T'; end
if strcmp(varname, 'TK'); varname='T'; end
if strcmp(varname, 'TC'); varname='T'; end
if strcmp(varname, 'TD'); varname='QVAPOR'; end
if strcmp(varname, 'RH'); varname='QVAPOR'; end
%
for ii=1:length(fid)
   vid=netcdf.inqVarID(fid(ii),varname);
   dd=netcdf.getVar(fid(ii), vid);
   % dd=permute(dd,[2 1 3 4]);
   dd=double(dd);
   if ii==1
       tempd=dd;
   else
       ss=size(tempd,4);
       tempd(:,:,:,ss+1:ss+size(dd,4))=dd;
   end
   clear dd vid
end
yrs=str2num(wrf_times(:,1:4));
mns=str2num(wrf_times(:,6:7));
flg=find(yrs==yr & mns==mn );
tempd=tempd(:,:,:,flg);
WRFTM=wrf_times(flg, :);
