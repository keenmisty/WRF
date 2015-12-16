function [Rair]=airdensity(P, T)

%AIRDENSITY Calculate air density(kg/m3) at pressure P (Pa) and temperature T(K)
%Useage:
%       [Rair]=airdensity(P, T)
%
% R: Specific gas constant for dry air (287 J K-1 kg-1) 
%
%designed by Zhiyong Wu, Apr 22, 2011

R=287;

Rair=P./T./R;