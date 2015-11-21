try
    % Main block
clear
clc
%st=1;
%st=13825;
%st=27649;
st=41472;
%nfile=13824;
%nfile=27648;
%nfile=41472;
nfile=55296;
cd('/ees/eeswxm/chang/Noah/arizona/NCAR_noahmp/test_dveg/result/1/')
filename=textread('../list.log','%s');
for n=st:nfile
%    qfx1(n-(st-1),:)         =    double(ncread(filename{n},'QFX'));
%    sheat1(n-(st-1),:)       =    double(ncread(filename{n},'FSH'));
%    fcev1(n-(st-1),:)        =    double(ncread(filename{n},'FCEV'));
%    fgev1(n-(st-1),:)        =    double(ncread(filename{n},'FGEV'));
%    fctr1(n-(st-1),:)        =    double(ncread(filename{n},'FCTR'));
%    ssoil1(n-(st-1),:)       =    double(ncread(filename{n},'SSOIL'));
%    fsr1(n-(st-1),:)         =    double(ncread(filename{n},'FSR'));
%    fira1(n-(st-1),:)        =    double(ncread(filename{n},'FIRA'));
    ch1(n-(st-1),:)          =    double(ncread(filename{n},'CH'));
    cm1(n-(st-1),:)          =    double(ncread(filename{n},'CM'));
    ra1(n-(st-1),:)          =    double(ncread(filename{n},'RA'));
    rb1(n-(st-1),:)          =    double(ncread(filename{n},'RB'));
    rc1(n-(st-1),:)          =    double(ncread(filename{n},'RC'));
    rcs1(n-(st-1),:)         =    double(ncread(filename{n},'RCS'));
    rct1(n-(st-1),:)         =    double(ncread(filename{n},'RCT'));
    rcq1(n-(st-1),:)         =    double(ncread(filename{n},'RCQ'));
    rcsoil1(n-(st-1),:)      =    double(ncread(filename{n},'RCSOIL'));
disp(n)
end

%qfx=(qfx1(:,1:2:end))';
%sheat=(sheat1(:,1:2:end))';
%fcev=(fcev1(:,1:2:end))';
%fgev=(fgev1(:,1:2:end))';
%fctr=(fctr1(:,1:2:end))';
%ssoil=(ssoil1(:,1:2:end))';
%fsr=(fsr1(:,1:2:end))';
%fira=(fira1(:,1:2:end))';
ch=(ch1(:,1:2:end))';
cm=(cm1(:,1:2:end))';
ra=(ra1(:,1:2:end))';
rb=(rb1(:,1:2:end))';
rcs=(rcs1(:,1:2:end))';
rct=(rct1(:,1:2:end))';
rcq=(rcq1(:,1:2:end))';
rcsoil=(rcsoil1(:,1:2:end))';

%save('../ext_heats3.mat','fcev','fgev','fctr','ssoil','fsr','fira');
save('../ext_coefficients4.mat','ch','cm','ra','rb','rcs','rct','rcq','rcsoil');
%    exit
    
catch err
    errmsg=err.message
%    exit
end

