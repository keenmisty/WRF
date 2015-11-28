function   write_static_data(fname_in,fidout,we_dimID, sn_dimID);
fidin=netcdf.open(fname_in,'NC_NOWRITE');
%
netcdf.reDef(fidout);
vname='XLONG';
vidin_lon=netcdf.inqVarID(fidin, vname);
vidout_lon=netcdf.defVar(fidout, vname, 'double', [we_dimID,sn_dimID]);
netcdf.copyAtt(fidin, vidin_lon, 'description',fidout, vidout_lon);
netcdf.copyAtt(fidin, vidin_lon, 'units',fidout, vidout_lon);
% netcdf.copyAtt(fidin, vidin_lon, 'coordinates',fidout, vidout_lon);
%
vname='XLAT';
vidin_lat=netcdf.inqVarID(fidin, vname);
vidout_lat=netcdf.defVar(fidout, vname, 'double', [we_dimID,sn_dimID]);
netcdf.copyAtt(fidin, vidin_lat, 'description',fidout, vidout_lat);
netcdf.copyAtt(fidin, vidin_lat, 'units',fidout, vidout_lat);
% netcdf.copyAtt(fidin, vidin_lat, 'coordinates',fidout, vidout_lat);
%
vname='LU_INDEX';
vidin_land=netcdf.inqVarID(fidin, vname);
vidout_land=netcdf.defVar(fidout, vname, 'double', [we_dimID,sn_dimID]);
netcdf.copyAtt(fidin, vidin_land, 'description',fidout, vidout_land);
netcdf.copyAtt(fidin, vidin_land, 'units',fidout, vidout_land);
% netcdf.copyAtt(fidin, vidin_land, 'coordinates',fidout, vidout_land);
netcdf.endDef(fidout)
%----------------------------------------------------
dd=netcdf.getVar(fidin, vidin_land);
dd=dd(:,:,6);
netcdf.putVar(fidout, vidout_land, dd);
dd=netcdf.getVar(fidin, vidin_lon);
dd=dd(:,:,6);
netcdf.putVar(fidout, vidout_lon, dd);
dd=netcdf.getVar(fidin, vidin_lat);
dd=dd(:,:,6);
netcdf.putVar(fidout, vidout_lat, dd);
