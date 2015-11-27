function [pv]=Qv2Pv(qv,pres)

% Qv2Pv convert water vapor mixing ratio (Qv, kg/kg) to water vapor pressure (Pv, Pa) 
%
%Usage:
%      [pv]=Qv2Pv(qv,pres)
%      pres: atmospheric pressure (Pa)
%
%Designed by Zhiyong Wu, 2013/02

pv=pres.*qv./(0.622+qv);