undef ("ppbv2ugm3")

function ppbv2ugm3(argin,mw,pres,t)
begin

np=dimsizes(argin)
k=np(0)
m=np(1)
n=np(2)

argout=new((/k,m,n/),float)
R=287

P0=101325    ; Pa
T0=273.15    ;   K
V0=22.4      ;   L/mol 

argout=argin*(mw*pres*T0/V0/P0/t); 
return(argout)

end

