undef ("airdensity")

function airdensity(P, T)
begin

np=dimsizes(P)
k=np(0)
m=np(1)
n=np(2)

Rair=new((/k,m,n/),float)
R=287

Rair=P/T/R;
return(Rair)

end

