function [rh]=CalRH(t,qv,pres,opt)
% CALRH calculate relative humidity (%) as a function of temperature (K), Water
% vapor mixing ratio (kg kg-1), and pressure (Pa)
% There are two methods and you can switch them using opt(1 or 2).
% opt=2 is the algorithm used in ncl (wrf_rh) 
%
%Usage:
%      [rh]=CalRH(t,qv,pres,opt)
%
%Designed by Zhiyong Wu, Jan 2013
%
switch (opt)
    case {1},    
        e=pres.*qv./(0.622+qv);
        E=610.78*10.^(7.5*(t-273.15)./(t-36.16));
        rh=e./E*100;
    case {2}
        es=6.112.*exp(17.67.*(t-273.15)./(t-29.65));
        qvs=0.622.*es./(pres./100.0-(1.0-0.622).*es);
        rh=100.*qv./qvs; 
    otherwise
        disp('The opt value MUST be 1 or 2');
end

if rh > 100; rh=100; end
if rh<0; rh=0.; end
