function [T]=CalTemp(P,Theta)

%CalTemp Calculate the temperature T(K) at pressure P (Pa) and potentialtemperature Theta (K) 
%Useage:
%       [T]=CalTemp(P,Theta)
%
% R    : Specific gas constant for dry air (287 J K-1 kg-1) 
% Cp   : Specific heat capacity at constant pressure (1005 J K-1 kg-1)
% p0   : Standard surface pressure (101325 Pa)
% k    : constant (R/Cp)
%
%designed by Zhiyong Wu, Apr 23, 2012
% 

R=287;
Cp=1005;
k=R/Cp;
p0=101325;

T=Theta./((p0./P).^k);
