clear all;  close all;   clc;
% check the result from read_wrfout
%---------------------------------
[wrfoutPATH, wrfout_namepre, putout_freq, hottime,varlist,fileout]=read_namelist('./namelist')
 budget_rain = 100.0;
 budget_rad = 1.0E+9;
%=====================================================
pt_ii=15; pt_jj=25; pt_kk= 2;
vname2=cell2mat(varlist(5));  
vname='T'
acc_var_flg = 0;
%
for nnms=1:length(hottime)
    yr=hottime(nnms,1); mn=hottime(nnms,2);
    disp(['   processing  >> ' num2str(yr) '  ' num2str(mn)])
    % search for valid wrfout files
    flist=dir([wrfoutPATH  wrfout_namepre  '*']);
    valid_file=find_validFILE(yr, mn, flist);
    flist=valid_file;
    % begin read data
    for ii=1:length(flist) 
        % disp(flist(ii).name);
        fid(ii)=netcdf.open([wrfoutPATH flist(ii).name], 'NC_NOWRITE');
        vid=netcdf.inqVarID(fid(ii), 'Times');
        tempd=netcdf.getVar(fid(ii),vid);
        tmp_times=permute(tempd,[2 1]); clear tempd vid
%
           varname= vname;
        if (strcmp(varname, 'RAINC') | ...
            strcmp(varname, 'RAINNC') | ...
            strncmp(varname, 'ACSW',4) | ...
            strncmp(varname, 'ACLW',4) | ...
            strcmp(varname, 'ACHFX') | ...
            strcmp(varname, 'ACLHF') | ...
            strcmp(varname, 'ACGRDFLX') | ...
            strcmp(varname, 'RAINSH') | ...
            strcmp(varname, 'GRAUPELNC') | ...
            strcmp(varname, 'HAILNC') | ...
            strcmp(varname, 'SNOWNC')  )

             if  ( strcmp(varname, 'RAINC') | strcmp(varname, 'RAINNC') )
                  budget_value = budget_rain;
             elseif  (strncmp(varname, 'ACSW',4) | strncmp(varname, 'ACLW',4))
                    budget_value = budget_rad;
             else
                    budget_value = 0;
             end
             vid=netcdf.inqVarID(fid(ii), vname);
             tempd=netcdf.getVar(fid(ii),vid, [pt_ii pt_jj 0], [1 1 size(tmp_times,1)]);
             tempd=double(squeeze(tempd));
             if budget_value>0
                vid=netcdf.inqVarID(fid(ii), ['I_' vname]);
                tempd0=netcdf.getVar(fid(ii),vid, [pt_ii pt_jj 0], [1 1 size(tmp_times,1)]);
                tempd0=double(squeeze(tempd0));
                tempd=tempd+tempd0*budget_value;clear tempd0
             end
            % tempd(2:end)=tempd(2:end)-tempd(1:end-1); tempd(1)=0; 
             acc_var_flg = 1;
             tempd=tempd';
%>>>>>>>>>>>>>>>>>>>>>>>>           
        elseif ( strcmp(varname, 'Z') | ...
              strcmp(varname, 'U') | ...
              strcmp(varname, 'V') | ...
              strcmp(varname, 'W') | ...
              strcmp(varname, 'THETA') | ...
              strcmp(varname, 'T') | ...
              strcmp(varname, 'TC') | ...
              strcmp(varname, 'TD') | ...
              strcmp(varname, 'P') | ...
              strcmp(varname, 'RH') | ...
              strcmp(varname, 'TK') | ...
              strcmp(varname, 'QVAPOR') | ...
              strcmp(varname, 'QCLOUD') | ...
              strcmp(varname, 'QRAIN') | ...
              strcmp(varname, 'CLDFRA') | ...
              strcmp(varname, 'TSLB') | ...
              strcmp(varname, 'SMOIS') | ...
              strcmp(varname, 'SH2O') | ...
              strcmp(varname, 'SMCREL') )
              if  (strcmp(varname, 'TSLB') | ...
                   strcmp(varname, 'SMOIS') | ...
                   strcmp(varname, 'SH2O') | ...
                   strcmp(varname, 'SMCREL') )
                 %  vert_layers = soil_layers;
              else
                 %  vert_layers = bottom_top;
              end
             vid=netcdf.inqVarID(fid(ii), vname);
             tempd=netcdf.getVar(fid(ii),vid, [pt_ii pt_jj pt_kk 0], [1 1 1 size(tmp_times,1)]);
             tempd=squeeze(tempd)';
%>>>>>>>>>>>>>>>>>>>>>           
         else % normal 2d variable
             vid=netcdf.inqVarID(fid(ii), vname);
             tempd=netcdf.getVar(fid(ii),vid, [pt_ii pt_jj 0], [1 1 size(tmp_times,1)]);
             tempd=squeeze(tempd)';
         end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ii==1
            wrf_temp_times=tmp_times;
            month_temp_data=tempd;
        else
            wrf_temp_times=[wrf_temp_times; tmp_times];
            month_temp_data=[month_temp_data tempd];
        end
        netcdf.close(fid(ii));
        clear tmp_times  tempd vid
    end % ii loop; FodS, FodE
    clear fid
    wrfdate=[str2num(wrf_temp_times(:,1:4)) ...
             str2num(wrf_temp_times(:,6:7)) ...
             str2num(wrf_temp_times(:,9:10)) ...
             str2num(wrf_temp_times(:,12:13))];
    dd=wrfdate(:,1)*1.0E+8+wrfdate(:,2)*1.0E+4+wrfdate(:,3)*1.0E+2+wrfdate(:,4);
%
    if ~(all(diff(dd)>0))
        [dd BI]=sort(dd,'ascend');
        wrfdate=wrfdate(BI,:);
        wrf_temp_times = wrf_temp_times(BI,:);
        month_temp_data = month_temp_data(BI);
        diff_dd=dd ;
        diff_dd(2:end)=dd(2:end)-dd(1:end-1);
%
        flg=find(diff_dd<0.1);
        disp(['  >>>>>> ' num2str(length(flg)) ' duplicate time exist ..'])
%        wrf_temp_times(max(1,min(flg)-10):min(max(flg)+10,length(wrf_temp_times)),:)
        disp( wrfdate(flg,:) );
%
        flg0=find(diff_dd>0);
        wrfdate=wrfdate(flg0, :);
        wrf_temp_times = wrf_temp_times(flg0,:);
        month_temp_data = month_temp_data(flg0); clear flg0
    end
    if acc_var_flg > 0;
       month_temp_data(2:end)=diff(month_temp_data);
       month_temp_data(1)=0;
    end
%
    flg=find(wrfdate(:,1)==yr & wrfdate(:,2)==mn); % length(flg)
    if nnms==1
        wrf_time = wrf_temp_times(flg,:);
        wrf_data = mean( month_temp_data(flg) );
    else
        wrf_time = [wrf_time;wrf_temp_times(flg,:)];
        wrf_data = [wrf_data mean( month_temp_data(flg))];
    end
    clear wrf_temp_times  month_temp_data 
end
check_data=mean(reshape(wrf_data,[4 length(wrf_data)/4]))+300;
%=============================
 fid=netcdf.open(fileout, 'NC_NOWRITE');
 vid=netcdf.inqVarID(fid, vname2);
 tempd=netcdf.getVar(fid,vid);
 ncout_data=squeeze(tempd(pt_ii+1, pt_jj+1, pt_kk+1,:));clear tempd vid vname
 netcdf.close(fid); clear fid
%---
figure(1);
%subplot(2,1,1); plot(ncout_data,'r-');  hold on;  plot(check_data,'g--')
%subplot(2,1,2); plot(ncout_data-check_data','r-')
