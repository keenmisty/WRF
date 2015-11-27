function argout=bilinear_m(lon,lat,lon_site,lat_site,argin)
%
%BILINEAR_M bilinear interpolation
%
%USEAGE
%   argout=bilinear_m(lon,lat,lon_site,lat_site,argin)
%
%argin should be a 3D variable,as argin(time,x,y)
%
%'lon' and 'lat' are the horizontal coordinate of domain
%'lon_site' and 'lat_site' are the location of site
%                                        Wu Zhiyong,2009.4

[k,m,n]=size(argin);

if lon_site>=min(min(lon))&&lon_site<=max(max(lon))&&lat_site>=min(min(lat))&&lat_site<=max(max(lat))
    
   for mm=1:m-1
      for nn=1:n-1
          if (lon(mm,nn)-lon_site)*(lon(mm,nn+1)-lon_site)<0 && (lat(mm,nn)-lat_site)*(lat(mm+1,nn)-lat_site)<0
             im=mm;
             in=nn;
          end
      end
   end

   for kk=1:k
      A=argin(kk,im,in)*(lon(im,in+1)-lon_site)*(lat(im+1,in)-lat_site)/(lon(im,in+1)-lon(im,in))/(lat(im+1,in)-lat(im,in));
      B=argin(kk,im,in+1)*(lon_site-lon(im,in))*(lat(im+1,in)-lat_site)/(lon(im,in+1)-lon(im,in))/(lat(im+1,in)-lat(im,in));
      C=argin(kk,im+1,in)*(lon(im,in+1)-lon_site)*(lat_site-lat(im,in))/(lon(im,in+1)-lon(im,in))/(lat(im+1,in)-lat(im,in));
      D=argin(kk,im+1,in+1)*(lon_site-lon(im,in))*(lat_site-lat(im,in))/(lon(im,in+1)-lon(im,in))/(lat(im+1,in)-lat(im,in));
      argout(kk)=A+B+C+D;
   end
   
else
    disp('Sorry! The site is not within the domain, please check!')
    argout=NaN;
end