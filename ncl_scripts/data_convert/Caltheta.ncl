undef ("Caltheta")

function Caltheta(P,T)
begin
;;;Claculate theta
P0=101325
Rd=287
Cp=1005

temp_index=Rd/Cp

np=dimsizes(P)
k=np(0)
m=np(1)
n=np(2)

temp=new((/k,m,n/),float)
temp=(P0/P)^(temp_index)
theta=T*temp

return(theta)

end

