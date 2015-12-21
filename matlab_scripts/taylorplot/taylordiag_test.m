% This is a test to use the taylordiag.m ploting function.
%
% The data file taylordiag_egdata.mat is required together
% with the function "allstats" and "ptable".
% Both are available at: http://code.google.com/p/guillaumemaze/
% 
%
% This function runs the following command lines:
%
% clear
% load taylordiag_egdata.mat
%
% % Get statistics from time series:
% for ii = 2:size(BUOY,1)
%     C = allstats(BUOY(1,:),BUOY(ii,:));
%     statm(ii,:) = C(:,2);
% end
% statm(1,:) = C(:,1);
%
% % Plot:
% figure
% ax = ptable([2 3],[2 2;4 6]);
% iw=2;jw=3;
% alphab = 'ABCDEFG';
%
% subplot(iw,jw,2); 
% plot(BUOY');
% grid on,xlabel('time (day)');ylabel('heat fluxes (W/m^2)');
% title(sprintf('%s: These are the different time series of daily heat fluxes (W/m2)','A'),'fontweight','bold');
%
% subplot(iw,jw,5); hold on
% [pp tt axl] = taylordiag(squeeze(statm(:,2)),squeeze(statm(:,3)),squeeze(statm(:,4)),...
%             'tickRMS',[25:25:150],'titleRMS',0,'tickRMSangle',135,'showlabelsRMS',0,'widthRMS',1,...
%             'tickSTD',[25:25:250],'limSTD',250,...
%             'tickCOR',[.1:.1:.9 .95 .99],'showlabelsCOR',1,'titleCOR',1);
%
% for ii = 1 : length(tt)
%     set(tt(ii),'fontsize',9,'fontweight','bold')
%     set(pp(ii),'markersize',12)
%     if ii == 1
%         set(tt(ii),'String','Buoy');
%     else
%         set(tt(ii),'String',alphab(ii-1));
%     end
% end
% title(sprintf('%s: Taylor Diagram at CLIMODE Buoy','B'),'fontweight','bold');
%
% tt = axl(2).handle;
% for ii = 1 : length(tt)
%     set(tt(ii),'fontsize',10,'fontweight','normal');
% end
% set(axl(1).handle,'fontweight','normal');


clear
load taylordiag_egdata.mat

% Get statistics from time series:
for ii = 2:size(BUOY,1)
    C = allstats(BUOY(1,:),BUOY(ii,:));
    statm(ii,:) = C(:,2);
end
statm(1,:) = C(:,1);

% Plot:
figure
ax = ptable([2 3],[2 2;4 6]);
iw=2;jw=3;
alphab = 'ABCDEFG';

subplot(iw,jw,2); 
plot(BUOY');
grid on,xlabel('time (day)');ylabel('heat fluxes (W/m^2)');
title(sprintf('%s: These are the different time series of daily heat fluxes (W/m2)','A'),'fontweight','bold');

subplot(iw,jw,5); hold on
[pp tt axl] = taylordiag(squeeze(statm(:,2)),squeeze(statm(:,3)),squeeze(statm(:,4)),...
            'tickRMS',[25:25:150],'titleRMS',0,'tickRMSangle',135,'showlabelsRMS',0,'widthRMS',1,...
            'tickSTD',[25:25:250],'limSTD',250,...
            'tickCOR',[.1:.1:.9 .95 .99],'showlabelsCOR',1,'titleCOR',1);

for ii = 1 : length(tt)
    set(tt(ii),'fontsize',9,'fontweight','bold')
    set(pp(ii),'markersize',12)
    if ii == 1
        set(tt(ii),'String','Buoy');
    else
        set(tt(ii),'String',alphab(ii-1));
    end
end
title(sprintf('%s: Taylor Diagram at CLIMODE Buoy','B'),'fontweight','bold');

tt = axl(2).handle;
for ii = 1 : length(tt)
    set(tt(ii),'fontsize',10,'fontweight','normal');
end
set(axl(1).handle,'fontweight','normal');

