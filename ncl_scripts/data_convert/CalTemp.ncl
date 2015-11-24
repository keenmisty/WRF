undef ("CalTemp")

function CalTemp(P,Theta)
begin
;;;Claculate temperatue 
P0=101325
Rd=287
Cp=1005
temp_index=Rd/Cp

np=dimsizes(P)
k=np(0)
m=np(1)
n=np(2)

Temp=new((/k,m,n/),float)
Temp=Theta/((P0/P)^(temp_index))

return(Temp)

end

