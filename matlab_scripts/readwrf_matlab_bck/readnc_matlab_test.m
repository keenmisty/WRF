try
    % Main block
    for i=1:1
        filename='/ees/users/EMG/ees2/pangjm/matlab/lib/TOPO-d2.nc';
        f=netcdf(filename,'nowrite');
        lat=f{'LAT'}(:);
        lon=f{'LON'}(:);
        close(f)
        rang_lon=[min(min(lon)),max(max(lon))];
        rang_lat=[min(min(lat)),max(max(lat))];
    end

    for ii=1:1
        filename1=strcat('/ees/users/EMG/ees2/pangjm/stem/stem2k3/Guangzhou-dabiao/2011base/201110/SOUT.09-30-00.nc');
        f1=netcdf(filename1,'nowrite');
    
        SO2(1:80,:,:)=squeeze(f1{'SO2'}(17:96,1,:,:));
    
        close(f1);
    
        clear f filename filename* f* 
    end


    cd ('/ees/users/EMG/ees2/pangjm/matlab_test');
    save matlab_test.mat SO2

%    exit

    
catch err
    errmsg=err.message
%    exit
end

