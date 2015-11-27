function [argout]=ppbv2ugm3(argin,mw,pres,t)

%PPBV2UGM3 convert ppbv to ug/m3
%Useage:
%    [argout]=ppbv2ugm3(argin,mw,pres,t)
%    argin: ppbv
%    mw: molecular weight (g/mol)
%    pres: Pa
%    t: K
%    argout: ug/m3
%
%designed by Zhiyong Wu, 2013/02

P0=1.01325e5; % Pa
T0=273.15;    % K
V0=22.4;      % L/mol 

argout=argin.*(mw.*pres.*T0./V0./P0./t); 
