try
    % Main block
clear
clc
load pl-sta.mat
nday=31;
st=1;
perd=24;
nfile=perd*nday+st-1;
cd('/ees/eeswxm/chang/3.6.1/WRFV3.chemrun/test/wrfout/base/')
filename=textread('./file.txt','%s');
temp_lat=ncread(filename{1},'XLAT');
temp_lon=ncread(filename{1},'XLONG');
lat=double(temp_lat);
lon=double(temp_lon);

for n=st:nfile
    no2(n-(st-1),:,:)        =    double(ncread(filename{n},'no2'));
    so2(n-(st-1),:,:)        =    double(ncread(filename{n},'so2'));
    o3(n-(st-1),:,:)       =    double(ncread(filename{n},'o3'));
    pm10(n-(st-1),:,:)       =    double(ncread(filename{n},'PM10'));
end

rang_lon=[min(min(lon)),max(max(lon))];
rang_lat=[min(min(lat)),max(max(lat))];
%rh=CalRH(t2,q2,pres,2);
%es=6.112.*exp(17.67.*(t2-273.15)./(t2-29.65));
%qvs=0.622.*es./(pres./100.0-(1.0-0.622).*es);
%rh=100.*q2./qvs;
%if rh>100; 
%   rh=100; 
%end
% if rh<0;
%    rh=0.;
% end
% pv=pres.*q2./(0.622+q2);
%pv=Qv2Pv(q2,pres);
% ws10=sqrt(u10.^2+v10.^2);
a=zeros(size(lat));
A=zeros(size(lat2));
B=zeros(size(lat2));
[mcount ncount]=size(lon);
no2_interp=zeros(nday*perd,max(size(lat2)));
so2_interp=zeros(nday*perd,max(size(lat2)));
o3_interp=zeros(nday*perd,max(size(lat2)));
pm10_interp=zeros(nday*perd,max(size(lat2)));
for i=1:max(size(lat2))
for m=1:mcount
    for n=1:ncount
        a(m,n)=(lon(m,n)-lon2(i))^2+(lat(m,n)-lat2(i))^2;
    end
end
b=min(min(a));
for m=1:mcount
    for n=1:ncount
        if a(m,n)==b
            A(i)=m;
            B(i)=n;
        end

    end
end
no2_interp(:,i)=squeeze(no2(:,A(i),B(i)));
so2_interp(:,i)=squeeze(so2(:,A(i),B(i)));
o3_interp(:,i)=squeeze(o3(:,A(i),B(i)));
pm10_interp(:,i)=squeeze(pm10(:,A(i),B(i)));
end
no2_wrfchem=zeros(nday,max(size(lat2)));
so2_wrfchem=zeros(nday,max(size(lat2)));
o3_wrfchem=zeros(nday,max(size(lat2)));
pm10_wrfchem=zeros(nday,max(size(lat2)));
for i=1:nday
    no2_wrfchem(i,:)=squeeze(mean(no2_interp(perd*i-(perd-1):perd*i,:)));
    so2_wrfchem(i,:)=squeeze(mean(so2_interp(perd*i-(perd-1):perd*i,:)));
    o3_wrfchem(i,:)=squeeze(mean(o3_interp(perd*i-(perd-1):perd*i,:)));
    pm10_wrfchem(i,:)=squeeze(mean(pm10_interp(perd*i-(perd-1):perd*i,:)));
end
save('base_chem4var201010.mat','no2_wrfchem','so2_wrfchem','o3_wrfchem','pm10_wrfchem')
%    exit

    
catch err
    errmsg=err.message
%    exit
end

