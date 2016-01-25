try
    % Main block
clear
clc
load chang-sta.mat
nday=31;
st=1;
perd=24;
nfile=perd*nday+st-1;
cd('/ees/eeswxm/chang/3.6.1/WRFV3.chemrun/test/wrfout/reduceGZ/')
filename=textread('./file.txt','%s');
temp_lat=ncread(filename{1},'XLAT');
temp_lon=ncread(filename{1},'XLONG');
lat=double(temp_lat);
lon=double(temp_lon);
for n=st:nfile
    q2 (n-(st-1),:,:)        =    double(ncread(filename{n},'Q2'));
    t2(n-(st-1),:,:)        =    double(ncread(filename{n},'T2'));
    u10(n-(st-1),:,:)       =    double(ncread(filename{n},'U10'));
    v10(n-(st-1),:,:)       =    double(ncread(filename{n},'V10'));
    pres(n-(st-1),:,:)       =    double(ncread(filename{n},'PSFC'));
end
rang_lon=[min(min(lon)),max(max(lon))];
rang_lat=[min(min(lat)),max(max(lat))];
%rh=CalRH(t2,q2,pres,2);
es=6.112.*exp(17.67.*(t2-273.15)./(t2-29.65));
qvs=0.622.*es./(pres./100.0-(1.0-0.622).*es);
rh=100.*q2./qvs;
if rh>100; 
   rh=100; 
end
if rh<0;
   rh=0.;
end
pv=pres.*q2./(0.622+q2);
%pv=Qv2Pv(q2,pres);
ws10=sqrt(u10.^2+v10.^2);
a=zeros(size(lat));
A=zeros(size(lat1));
B=zeros(size(lat1));
[mcount ncount]=size(lon);
t2_interp=zeros(nday*perd,max(size(lat1)));
ws10_interp=zeros(nday*perd,max(size(lat1)));
rh_interp=zeros(nday*perd,max(size(lat1)));
pv_interp=zeros(nday*perd,max(size(lat1)));
for i=1:max(size(lat1))
for m=1:mcount
    for n=1:ncount
        a(m,n)=(lon(m,n)-lon1(i))^2+(lat(m,n)-lat1(i))^2;
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
t2_interp(:,i)=squeeze(t2(:,A(i),B(i)));
ws10_interp(:,i)=squeeze(ws10(:,A(i),B(i)));
rh_interp(:,i)=squeeze(rh(:,A(i),B(i)));
pv_interp(:,i)=squeeze(pv(:,A(i),B(i)));
end
t2_wrfchem=zeros(nday,max(size(lat1)));
ws10_wrfchem=zeros(nday,max(size(lat1)));
rh_wrfchem=zeros(nday,max(size(lat1)));
pv_wrfchem=zeros(nday,max(size(lat1)));
for i=1:nday
    t2_wrfchem(i,:)=squeeze(mean(t2_interp(perd*i-(perd-1):perd*i,:)));
    ws10_wrfchem(i,:)=squeeze(mean(ws10_interp(perd*i-(perd-1):perd*i,:)));
    rh_wrfchem(i,:)=squeeze(mean(rh_interp(perd*i-(perd-1):perd*i,:)));
    pv_wrfchem(i,:)=squeeze(mean(pv_interp(perd*i-(perd-1):perd*i,:)));
end
save('reduceGZ_met201010.mat','t2_wrfchem','ws10_wrfchem','rh_wrfchem','pv_wrfchem')
%    exit

    
catch err
    errmsg=err.message
%    exit
end

