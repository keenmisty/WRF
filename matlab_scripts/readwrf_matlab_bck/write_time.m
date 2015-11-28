function  write_time(fidout,varid,yr,mn,TimeStrL, seg_nt,init_times)
 if seg_nt>1
    mnc=num2str(mn); 
    if mn<10; mnc=['0' mnc]; end;
    for ii=1:seg_nt
        ddc=num2str(ii); 
        if ii<10; ddc=['0' ddc]; end;
         ttms=[num2str(yr) '-' mnc  '-' ddc];
        netcdf.putVar(fidout,varid,[0 init_times+ii-1],[TimeStrL 1],ttms)
    end
 else
     ttms=[num2str(yr) '-' num2str(mn) '-00'];
     if mn<10; ttms=[num2str(yr) '-0' num2str(mn) '-00']; end
     netcdf.putVar(fidout,varid,[0 init_times],[TimeStrL 1],ttms)
 end
