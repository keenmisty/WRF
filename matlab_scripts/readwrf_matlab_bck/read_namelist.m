% clear all; close all; clc;
function [wrfoutPATH, wrfout_namepre, putout_freq,hottime, varlist,outfile]=read_namelist(var_list_fname);
disp('  >>>>>   open the var_list FILE')
fid=fopen(var_list_fname,'r');
%
  ss=fgetl(fid);  
  ss=ss(find(~isspace(ss)));
while ~feof(fid) & length(findstr(ss,'var_list'))<1
  ss=fgetl(fid);  
  ss=ss(find(~isspace(ss)));
  if strncmp(ss,'wrfoutPATH',10)
     wrfoutPATH=ss(12:end);
  elseif strncmp(ss,'wrfout_namepre',14)
     wrfout_namepre=ss(16:end);
  elseif strncmp(ss,'putout_freq',11)
     putout_freq=str2num(ss(13:end));
  elseif strncmp(ss,'starttime',9)
     starttime=ss(11:end);
  elseif strncmp(ss,'endtime',7)
     endtime=ss(9:end);
  elseif strncmp(ss,'output_file',11)
     outfile=ss(13:end);
  end
end
%
kk=0;
while ~feof(fid)
  ss=fgetl(fid);  
  ss=ss(find(~isspace(ss)));
  if ~ strncmp(ss,'%',1)
     kk=kk+1;
     varlist(kk)={ss};
  end
end
fclose(fid);
disp('  >>>>>   close the var_list FILE')
%==============================
 start_yr=str2num(starttime(1:4));start_mn=str2num(starttime(5:6));
 end_yr=str2num(endtime(1:4));    end_mn=str2num(endtime(5:6));
 kk=0;
 for yr=start_yr:end_yr
     for mn=1:12
         if yr*10000+mn>start_yr*10000+start_mn-1 & yr*10000+mn<end_yr*10000+end_mn+1
            kk = kk+1;
            if kk == 1
               hottime=[yr mn];
            else
               hottime=[hottime
                        [yr mn]];
            end
         end
     end
 end
