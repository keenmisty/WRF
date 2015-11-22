undef ("Qv2Pv")

function Qv2Pv(qv,pres)
begin

np=dimsizes(qv)
k=np(0)
m=np(1)
n=np(2)

pv=new((/k,m,n/),float)
pv=pres*qv/(0.622+qv);


return(pv)

end

