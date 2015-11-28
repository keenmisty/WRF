function  WRFtimes_order=check_duplict_times(wrf_times);
yrs=str2num(wrf_times(:,1:4));
mns=str2num(wrf_times(:,6:7));
dys=str2num(wrf_times(:,9:10));
hrs=str2num(wrf_times(:,12:13));
%------------
tempnumber=yrs*1.0E6 + mns*1.0E4 + ...
           dys*100   + hrs;
[xx yy]=meshgrid(tempnumber, tempnumber');
delt=xx-yy; 
[flgx, flgy]=find(abs(delt)<0.000000001);
delt=flgx-flgy;
flg=find(flgx < flgy);
flgx=flgx(flg);
flgy=flgy(flg);
clear flg