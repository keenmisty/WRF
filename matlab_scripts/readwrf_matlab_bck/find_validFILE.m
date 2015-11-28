function valid_file=find_validFILE(yr, mn, filelist);

 for ii=1:length(filelist);
      if ii==1
         fname=filelist(ii).name;
      else
         fname=[fname
                filelist(ii).name];
      end
 end % end ii--loop
  wrfout_date=[str2num(fname(:,12:15)) ...
               str2num(fname(:,17:18)) ...
               str2num(fname(:,20:21))];
  Ndays=(wrfout_date(:,1)-1)*365+ ...
         (wrfout_date(:,2)-1)*30+wrfout_date(:,3);
  ObjDayS=(yr-1)*365+(mn-1)*30+1;
  ObjDayE=(yr-1)*365+mn*30;
  FodS=max(find((Ndays-ObjDayS)<0.00001));
  if FodS>1; FodS=FodS-1; end
   FodE=max(find((Ndays-ObjDayE)<0.000001)); 
  if FodE<length(filelist); FodE=FodE+1; end
   valid_file=filelist(FodS:FodE);
        %clear wrfout_date Ndays ObjDayS ObjDayE
        % end search valid wrfout file