undef ("bilinear")

function bilinear(lon,lat,lon_site,lat_site,argin)
begin

nargin=dimsizes(argin)
k=nargin(0)
m=nargin(1)
n=nargin(2)

argout=new((/k/),float)
if (lon_site.ge.min(min(lon))).and.(lon_site.le.max(max(lon))).and.(lat_site.ge.min(min(lat))).and.(lat_site.le.max(max(lat)))

  do kk=0,k-1 
   do mm=0,m-2
      do nn=0,n-2
;          aa=(lon_site(kk)-lon(mm,nn+1))*(lon_site(kk)-lon(mm,nn))
;          bb=(lat_site(kk)-lat(mm+1,nn))*(lat_site(kk)-lat(mm,nn))
          if (((lon_site(kk)-lon(mm,nn+1))*(lon_site(kk)-lon(mm,nn))).lt.0).and.(((lat_site(kk)-lat(mm+1,nn))*(lat_site(kk)-lat(mm,nn))).lt.0)
             im=mm
             in=nn
              A=argin(kk,im,in)*(lon(im,in+1)-lon_site)*(lat(im+1,in)-lat_site)/(lon(im,in+1)-lon(im,in))/(lat(im+1,in)-lat(im,in))
              B=argin(kk,im,in+1)*(lon_site-lon(im,in))*(lat(im+1,in)-lat_site)/(lon(im,in+1)-lon(im,in))/(lat(im+1,in)-lat(im,in))
              C=argin(kk,im+1,in)*(lon(im,in+1)-lon_site)*(lat_site-lat(im,in))/(lon(im,in+1)-lon(im,in))/(lat(im+1,in)-lat(im,in))
              D=argin(kk,im+1,in+1)*(lon_site-lon(im,in))*(lat_site-lat(im,in))/(lon(im,in+1)-lon(im,in))/(lat(im+1,in)-lat(im,in))
              argout(kk)=A+B+C+D
          end if
       end do
      end do
   end do
else
    print(error)
end if
   return(argout)
end

