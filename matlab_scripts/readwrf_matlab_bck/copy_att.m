function copy_att(fname_in,fidout,varname,varid_out)
%-
if strcmp(varname, 'Z'); varname='PH'; end
if strcmp(varname, 'THETA'); varname='T'; end
if strcmp(varname, 'TK'); varname='T'; end
if strcmp(varname, 'TC'); varname='T'; end
if strcmp(varname, 'TD'); varname='QVAPOR'; end
if strcmp(varname, 'RH'); varname='QVAPOR'; end
%
fidin=netcdf.open(fname_in, 'NC_NOWRITE');
varid_in=netcdf.inqVarID(fidin, varname);
netcdf.copyAtt(fidin, varid_in, 'description',fidout, varid_out);
netcdf.copyAtt(fidin, varid_in, 'units',fidout, varid_out);
netcdf.copyAtt(fidin, varid_in, 'coordinates',fidout, varid_out);
%----------------
if strcmp(varname, 'RH')
   netcdf.putAtt(fidout, varid_out, 'description','Relative Humidity (%)')
   netcdf.putAtt(fidout, varid_out, 'units','fraction (%)')
end
