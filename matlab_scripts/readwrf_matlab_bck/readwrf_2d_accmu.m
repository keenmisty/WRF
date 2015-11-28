function temp_2d=readwrf_2d_accmu(fid, wrf_times, varname, yr, mn, budget_value, seg_nt, monthly_Tdays);
for ii=1:length(fid)
   vid=netcdf.inqVarID(fid(ii),varname);
   dd=netcdf.getVar(fid(ii), vid);
   dd=double(dd);
   %
   if (budget_value>0)
       vid=netcdf.inqVarID(fid(ii),['I_' varname]);
       int_dd=netcdf.getVar(fid(ii), vid);
       int_dd=double(int_dd);
       int_dd=int_dd*budget_value;
       dd=dd+int_dd;
   end
   %
   if ii==1
       tempd=dd;
   else
       ss=size(tempd,3);
       tempd(:,:,ss+1:ss+size(dd,3))=dd;
   end
   clear dd vid
end
yrs=str2num(wrf_times(:,1:4));
mns=str2num(wrf_times(:,6:7));
dys=str2num(wrf_times(:,9:10));
hrs=str2num(wrf_times(:,12:13));
%hp=pcolor(mean(tempd,3));set(hp,'edgecolor','none');colorbar
 dd=yrs*1.0E+8+mns*10000+dys*100+hrs;
% search the interval of hours
hourID=unique(hrs);day_times=length(hourID);
%--------------------------------  process day by day
tempd_mod=nan*tempd(:,:,1);
for ii=1:monthly_Tdays
    flg = find(yrs==yr & mns==mn & dys==ii & hrs==0);
    if length(flg)>0
       flg = min(flg);
       if flg==1 % the first one
          tempd_mod=tempd(:,:,flg+day_times-1);
       else
          tempd_mod=tempd(:,:,flg+day_times-1)-tempd(:,:,flg-1);
       end
    end
    if ii==1
       tempd_daily=tempd_mod;
    else
       tempd_daily(:,:,ii)=tempd_mod;
    end
    tempd_mod(:,:)=nan;
end
clear tempd_mod
%----------------------------------------------------
%----------------------------
%disp(' in readwrf_2d_accmu')
if seg_nt==1 % monthly
   temp_2d=nanmean(tempd_daily,3);
elseif seg_nt==2 % bi-monthly
   tempd(:,:,1)=nanmean(tempd_daily(:,:,1:15),3);
   tempd(:,:,2)=nanmean(tempd_daily(:,:,16:end),3);
   temp_2d       =tempd(:,:,1:2);
else %  daily
   temp_2d=tempd_daily;
end
