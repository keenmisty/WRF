 clear all;  close all;   clc;
% function read_wrfout
%---------------------------------
% read WRFOUT
%---------------------------------
% prescribed parameters
[wrfoutPATH, wrfout_namepre, putout_freq, hottime,varlist,fileout]=read_namelist('./namelist')
%====================================================
if exist(fileout)>0; delete(fileout); end
% create a file
fidout=netcdf.create(fileout,'64BIT_OFFSET');
% define dimensions
  % read the dimensions from wrfout files
    flist=dir([wrfoutPATH  wrfout_namepre  '*']);
    fid=netcdf.open([wrfoutPATH flist(1).name], 'nc_nowrite');
    vid=netcdf.inqDimID(fid, 'west_east');
    [testname, west_east]=netcdf.inqDim(fid, vid);
    vid=netcdf.inqDimID(fid, 'south_north');
    [testname, south_north]=netcdf.inqDim(fid, vid);
    vid=netcdf.inqDimID(fid, 'soil_layers_stag');
    [testname, soil_layers]=netcdf.inqDim(fid, vid);
    vid=netcdf.inqDimID(fid, 'bottom_top');
    [testname, bottom_top]=netcdf.inqDim(fid, vid);
% west_east=117;
% south_north=120;
% soil_layers = 4 ;
% bottom_top=27;
netcdf.close(fid);
clear flist  fid  vid testname
TimeStrL = 10;
%-
budget_rain = 100.0;
budget_rad = 1.0E+9;
%
we_dimID = netcdf.defDim(fidout,'west_east',  west_east);
sn_dimID = netcdf.defDim(fidout,'south_north', south_north);
soil_dimID = netcdf.defDim(fidout,'soil_layers', soil_layers);
botp_dimID = netcdf.defDim(fidout,'bottom_top', bottom_top);
StrL_dimID = netcdf.defDim(fidout,'TimeStrL', TimeStrL);
monthly_days=[31 28 31 30 31 30 31 31 30 31 30 31];
if putout_freq==1
   nt_dimID = netcdf.defDim(fidout,'days',netcdf.getConstant('NC_UNLIMITED'));
   seg_nt0=monthly_days;%[31 28 31 30 31 30 31 31 30 31 30 31];
elseif putout_freq==15
   nt_dimID = netcdf.defDim(fidout,'bi-months',netcdf.getConstant('NC_UNLIMITED'));
   seg_nt0=2;
elseif putout_freq==30
   nt_dimID = netcdf.defDim(fidout,'months',netcdf.getConstant('NC_UNLIMITED'));
   seg_nt0=1;
end
%=====================================================
nnms=0;
for nnms=1:size(hottime,1)
% for yr=1981:1981
%    for mn=1:1
      yr=hottime(nnms,1); mn=hottime(nnms,2);
        if nnms > 2;
            delt_ctime=delt_ctime*[0 0 3600*24 3600 60 1]';
            disp(['...  using '  num2str(delt_ctime)  '  seconds'])
        end
        disp('---------------------------------------------------------------------')
        disp([' Object Year and Month: ' num2str(yr) '-' num2str(mn)]);
        disp(['    ' num2str(clock)])
        if putout_freq==1
           seg_nt=seg_nt0(mn);
           if (mod(yr,4)<1 & mn==2); seg_nt=29;end;
           monthly_Tdays=seg_nt;
        else
           seg_nt=seg_nt0;
           monthly_Tdays = monthly_days(mn);
           if (mod(yr,4)<1 & mn==2); monthly_Tdays=29;end;
        end
%        nnms=nnms+1;
        if nnms==1;
            ctime0=clock; init_times=0;
            init_times_next=init_times+seg_nt;
        else
            ctime1=clock;
            delt_ctime=ctime1-ctime0;
            ctime0=ctime1;
            init_times=init_times_next;
            init_times_next=init_times+seg_nt;
        end
        % search for valid wrfout files
        flist=dir([wrfoutPATH  wrfout_namepre  '*']);
        valid_file=find_validFILE(yr, mn, flist);
        flist=valid_file;
        % begin read data
        for ii=1:length(flist) 
            % disp(flist(ii).name);
            fid(ii)=netcdf.open([wrfoutPATH flist(ii).name], 'NC_NOWRITE');
            vname='Times';
            vid=netcdf.inqVarID(fid(ii), vname);
            tempd=netcdf.getVar(fid(ii),vid);
            tmp_times=permute(tempd,[2 1]); clear tempd vid
            if ii==1
                wrf_times=tmp_times;
            else
                wrf_times=[wrf_times; tmp_times];
            end
        end % ii loop; FodS, FodE
% write static data to OUTPUT dataset
       if nnms==1;
          varid = netcdf.defVar(fidout,'Times','CHAR', [StrL_dimID, nt_dimID]);
          netcdf.endDef(fidout)
          write_static_data([wrfoutPATH flist(1).name],fidout, ... 
             we_dimID, sn_dimID); 
       else
          varid = netcdf.inqVarID(fidout,'Times');
       end
%-- put Times
       write_time(fidout,varid,yr,mn,TimeStrL, seg_nt,init_times)
%-- check the duplict Times
%        WRFtimes_order=check_duplict_times(wrf_times);
        %-- read variables
        for vii=1:length(varlist)
            disp(['varname:  '  cell2mat(varlist(vii))])
           varname= cell2mat(varlist(vii));
            if ( strcmp(varname, 'RAINC') | ...
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

                temp_2d=readwrf_2d_accmu(fid, wrf_times, varname, yr, mn, budget_value, seg_nt,monthly_Tdays);
                if nnms==1; 
                      netcdf.reDef(fidout); 
                       varid = netcdf.defVar(fidout,varname,'double', [we_dimID,sn_dimID,nt_dimID]);
                       copy_att([wrfoutPATH flist(1).name],fidout,varname,varid)
                       netcdf.endDef(fidout)
                 else
                        varid = netcdf.inqVarID(fidout, varname);
                end
                  netcdf.putVar(fidout,varid, [0 0 init_times], ... 
                                            [west_east  south_north seg_nt],temp_2d);
                clear temp_2d
%           
           elseif ( strcmp(varname, 'Z') | ...
                 strcmp(varname, 'U') | ...
                 strcmp(varname, 'V') | ...
                 strcmp(varname, 'W') | ...
                 strcmp(varname, 'THETA') | ...
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
                      vert_dimID=soil_dimID;
                      vert_layers = soil_layers;
                 else
                     vert_dimID = botp_dimID;
                     vert_layers = bottom_top;
                 end
                 temp_3d=readwrf_3d(fid, wrf_times, varname, yr, mn,seg_nt, monthly_Tdays);
                 if nnms==1; 
                    netcdf.reDef(fidout);
                     varid = netcdf.defVar(fidout,varname,'double', [we_dimID,sn_dimID,vert_dimID,nt_dimID]);
                      copy_att([wrfoutPATH flist(1).name],fidout,varname,varid)
                      netcdf.endDef(fidout)
                 else
                     varid = netcdf.inqVarID(fidout, varname);
                 end
                  netcdf.putVar(fidout,varid, [0 0 0 init_times], ... 
                                            [west_east  south_north vert_layers seg_nt],temp_3d);
            else % normal 2d variable

                 temp_2d=readwrf_2d(fid, wrf_times, varname, yr, mn,seg_nt, monthly_Tdays);
                 if nnms==1; 
                       netcdf.reDef(fidout); 
                       varid = netcdf.defVar(fidout,varname,'double', [we_dimID,sn_dimID,nt_dimID]);
                       copy_att([wrfoutPATH flist(1).name],fidout,varname,varid)
                       netcdf.endDef(fidout)
                 else
                       varid = netcdf.inqVarID(fidout, varname);
                 end
                  netcdf.putVar(fidout,varid, [0 0 init_times], ... 
                                            [west_east  south_north seg_nt],temp_2d);
            end               
        end
        %-------- close the files
        for ii=1:length(flist)
            netcdf.close(fid(ii));
        end
        clear fid
%    end % end mn-loop
%end % end yr-loop
end
netcdf.close(fidout)
disp('. . . . . . . . .  close read wrfout .. ..')
%=============================
