clear

% 读取文件

emisfile='C:\Users\ChangMing\Desktop\emission_zhiyong\N_dep_modeling\emis\wrfchemi_00z_d01.2010_10mergeA2';

geofile='C:\Users\ChangMing\Desktop\emission_zhiyong\N_dep_modeling\geo2010\geo_em.d02.nc';

cityfile='C:\Users\ChangMing\Desktop\emission_zhiyong\N_dep_modeling\emis\ZQregionPoint.txt';

% 读取经纬度数据

lat_domain=ncread(geofile,'XLAT_M');
lon_domain=ncread(geofile,'XLONG_M');

[lat_city,lon_city]=textread(cityfile,'%f%f','headerlines',1);

% 筛选落在city范围内的网格，在内为1，在外则为0

in=inpolygon(lon_domain,lat_domain,lon_city,lat_city);

% 确定在emisfile中挖取的位置

[X,Y,Z,T]=size(ncread(emisfile,'E_ISO'));

emisoff(X,Y,Z,T)=0;
for i=1:Z
    for j=1:T
        emisoff(:,:,i,j)=in;
    end
end

% 确定削的源类型及削的百分比

reduce_factor=0.8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% E_ISO.....................................No.1
data=ncread(emisfile,'E_ISO');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ISO',data);

%% E_SO2.....................................No.2
data=ncread(emisfile,'E_SO2');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_SO2',data);

%% E_NO.....................................No.3
data=ncread(emisfile,'E_NO');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NO',data);

%% E_NO2.....................................No.4
data=ncread(emisfile,'E_NO2');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NO2',data);

%% E_CO.....................................No.5
data=ncread(emisfile,'E_CO');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_CO',data);

%% E_ETH.....................................No.6
data=ncread(emisfile,'E_ETH');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ETH',data);

%% E_HC3.....................................No.7
data=ncread(emisfile,'E_HC3');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_HC3',data);

%% E_HC5.....................................No.8
data=ncread(emisfile,'E_HC5');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_HC5',data);

%% E_HC8.....................................No.9
data=ncread(emisfile,'E_HC8');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_HC8',data);

%% E_XYL.....................................No.10
data=ncread(emisfile,'E_XYL');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_XYL',data);

%% E_OL2.....................................No.11
data=ncread(emisfile,'E_OL2');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_OL2',data);

%% E_OLT.....................................No.12
data=ncread(emisfile,'E_OLT');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_OLT',data);

%% E_OLI.....................................No.13
data=ncread(emisfile,'E_OLI');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_OLI',data);

%% E_TOL.....................................No.14
data=ncread(emisfile,'E_TOL');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_TOL',data);

%% E_CSL.....................................No.15
data=ncread(emisfile,'E_CSL');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_CSL',data);

%% E_HCHO.....................................No.16
data=ncread(emisfile,'E_HCHO');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_HCHO',data);

%% E_ALD.....................................No.17
data=ncread(emisfile,'E_ALD');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ALD',data);

%% E_KET.....................................No.18
data=ncread(emisfile,'E_KET');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_KET',data);

%% E_ORA2.....................................No.19
data=ncread(emisfile,'E_ORA2');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORA2',data);

%% E_NH3.....................................No.20
data=ncread(emisfile,'E_NH3');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NH3',data);

%% E_PM25I.....................................No.21
data=ncread(emisfile,'E_PM25I');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_PM25I',data);

%% E_PM25J.....................................No.22
data=ncread(emisfile,'E_PM25J');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_PM25J',data);

%% E_PM_10.....................................No.23
data=ncread(emisfile,'E_PM_10');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_PM_10',data);

%% E_ECI.....................................No.24
data=ncread(emisfile,'E_ECI');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ECI',data);

%% E_ECJ.....................................No.25
data=ncread(emisfile,'E_ECJ');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ECJ',data);

%% E_ORGI.....................................No.26
data=ncread(emisfile,'E_ORGI');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGI',data);

%% E_ORGJ.....................................No.27
data=ncread(emisfile,'E_ORGJ');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGJ',data);

%% E_SO4I.....................................No.28
data=ncread(emisfile,'E_SO4I');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_SO4I',data);

%% E_SO4J.....................................No.29
data=ncread(emisfile,'E_SO4J');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_SO4J',data);

%% E_NO3I.....................................No.30
data=ncread(emisfile,'E_NO3I');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NO3I',data);

%% E_NO3J.....................................No.31
data=ncread(emisfile,'E_NO3J');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NO3J',data);

%% E_NAAJ.....................................No.32
data=ncread(emisfile,'E_NAAJ');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NAAJ',data);

%% E_NAAI.....................................No.33
data=ncread(emisfile,'E_NAAI');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NAAI',data);

%% E_ORGI_A.....................................No.34
data=ncread(emisfile,'E_ORGI_A');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGI_A',data);

%% E_ORGJ_A.....................................No.35
data=ncread(emisfile,'E_ORGJ_A');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGJ_A',data);

%% E_ORGI_BB.....................................No.36
data=ncread(emisfile,'E_ORGI_BB');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGI_BB',data);

%% E_ORGJ_BB.....................................No.37
data=ncread(emisfile,'E_ORGJ_BB');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGJ_BB',data);

% 重命名修改后的源文件

! rename "C:\Users\ChangMing\Desktop\emission_zhiyong\N_dep_modeling\emis\wrfchemi_00z_d01.2010_10mergeA2" wrfchemi_00z_d01.2010_10mergeA2.reduceZQ


clear

% 读取文件

emisfile='C:\Users\ChangMing\Desktop\emission_zhiyong\N_dep_modeling\emis\wrfchemi_12z_d01.2010_10mergeA2';

geofile='C:\Users\ChangMing\Desktop\emission_zhiyong\N_dep_modeling\geo2010\geo_em.d02.nc';

cityfile='C:\Users\ChangMing\Desktop\emission_zhiyong\N_dep_modeling\emis\ZQregionPoint.txt';

% 读取经纬度数据

lat_domain=ncread(geofile,'XLAT_M');
lon_domain=ncread(geofile,'XLONG_M');

[lat_city,lon_city]=textread(cityfile,'%f%f','headerlines',1);

% 筛选落在city范围内的网格，在内为1，在外则为0

in=inpolygon(lon_domain,lat_domain,lon_city,lat_city);

% 确定在emisfile中挖取的位置

[X,Y,Z,T]=size(ncread(emisfile,'E_ISO'));

emisoff(X,Y,Z,T)=0;
for i=1:Z
    for j=1:T
        emisoff(:,:,i,j)=in;
    end
end

% 确定削的源类型及削的百分比

reduce_factor=0.8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% E_ISO.....................................No.1
data=ncread(emisfile,'E_ISO');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ISO',data);

%% E_SO2.....................................No.2
data=ncread(emisfile,'E_SO2');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_SO2',data);

%% E_NO.....................................No.3
data=ncread(emisfile,'E_NO');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NO',data);

%% E_NO2.....................................No.4
data=ncread(emisfile,'E_NO2');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NO2',data);

%% E_CO.....................................No.5
data=ncread(emisfile,'E_CO');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_CO',data);

%% E_ETH.....................................No.6
data=ncread(emisfile,'E_ETH');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ETH',data);

%% E_HC3.....................................No.7
data=ncread(emisfile,'E_HC3');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_HC3',data);

%% E_HC5.....................................No.8
data=ncread(emisfile,'E_HC5');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_HC5',data);

%% E_HC8.....................................No.9
data=ncread(emisfile,'E_HC8');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_HC8',data);

%% E_XYL.....................................No.10
data=ncread(emisfile,'E_XYL');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_XYL',data);

%% E_OL2.....................................No.11
data=ncread(emisfile,'E_OL2');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_OL2',data);

%% E_OLT.....................................No.12
data=ncread(emisfile,'E_OLT');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_OLT',data);

%% E_OLI.....................................No.13
data=ncread(emisfile,'E_OLI');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_OLI',data);

%% E_TOL.....................................No.14
data=ncread(emisfile,'E_TOL');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_TOL',data);

%% E_CSL.....................................No.15
data=ncread(emisfile,'E_CSL');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_CSL',data);

%% E_HCHO.....................................No.16
data=ncread(emisfile,'E_HCHO');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_HCHO',data);

%% E_ALD.....................................No.17
data=ncread(emisfile,'E_ALD');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ALD',data);

%% E_KET.....................................No.18
data=ncread(emisfile,'E_KET');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_KET',data);

%% E_ORA2.....................................No.19
data=ncread(emisfile,'E_ORA2');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORA2',data);

%% E_NH3.....................................No.20
data=ncread(emisfile,'E_NH3');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NH3',data);

%% E_PM25I.....................................No.21
data=ncread(emisfile,'E_PM25I');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_PM25I',data);

%% E_PM25J.....................................No.22
data=ncread(emisfile,'E_PM25J');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_PM25J',data);

%% E_PM_10.....................................No.23
data=ncread(emisfile,'E_PM_10');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_PM_10',data);

%% E_ECI.....................................No.24
data=ncread(emisfile,'E_ECI');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ECI',data);

%% E_ECJ.....................................No.25
data=ncread(emisfile,'E_ECJ');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ECJ',data);

%% E_ORGI.....................................No.26
data=ncread(emisfile,'E_ORGI');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGI',data);

%% E_ORGJ.....................................No.27
data=ncread(emisfile,'E_ORGJ');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGJ',data);

%% E_SO4I.....................................No.28
data=ncread(emisfile,'E_SO4I');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_SO4I',data);

%% E_SO4J.....................................No.29
data=ncread(emisfile,'E_SO4J');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_SO4J',data);

%% E_NO3I.....................................No.30
data=ncread(emisfile,'E_NO3I');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NO3I',data);

%% E_NO3J.....................................No.31
data=ncread(emisfile,'E_NO3J');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NO3J',data);

%% E_NAAJ.....................................No.32
data=ncread(emisfile,'E_NAAJ');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NAAJ',data);

%% E_NAAI.....................................No.33
data=ncread(emisfile,'E_NAAI');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_NAAI',data);

%% E_ORGI_A.....................................No.34
data=ncread(emisfile,'E_ORGI_A');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGI_A',data);

%% E_ORGJ_A.....................................No.35
data=ncread(emisfile,'E_ORGJ_A');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGJ_A',data);

%% E_ORGI_BB.....................................No.36
data=ncread(emisfile,'E_ORGI_BB');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGI_BB',data);

%% E_ORGJ_BB.....................................No.37
data=ncread(emisfile,'E_ORGJ_BB');
data(emisoff==1)=data(emisoff==1)*reduce_factor;
ncwrite(emisfile,'E_ORGJ_BB',data);

% 重命名修改后的源文件

! rename "C:\Users\ChangMing\Desktop\emission_zhiyong\N_dep_modeling\emis\wrfchemi_12z_d01.2010_10mergeA2" wrfchemi_12z_d01.2010_10mergeA2.reduceZQ
