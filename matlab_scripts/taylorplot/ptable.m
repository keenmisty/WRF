% PTABLE Creates non uniform subplot handles
%
% SUBPLOT_HANDLE = ptable(TSIZE,PCOORD)
%
% This function creates subplot handles according to
% TSIZE and PCOORD.
% TSIZE(2) is the underlying TABLE of subplots: TSIZE(1)
%	is the number of lines, TSIZE(2) the number of rows
% PCOORD(:,2) indicates the coordinates of the subplots, ie
% 	for each PCOORD(i,2), the subplot i extends from
%	initial subplot PCOORD(i,1) to subplot PCOORD(i,2)
%
% Example: 
%	figure
% 	subp = ptable([3 4],[1 6 ; 3 4 ; 9 11; 8 8]);
%	x = 0:pi/180:2*pi;
%	axes(subp(1));plot(x,cos(x));
%	axes(subp(2));plot(x,sin(x));
%	axes(subp(3));plot(x,sin(x.^2));
%	axes(subp(4));plot(x,sin(x).*cos(x));
%
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

% TO DO: 
%		- insert input check

function varargout = ptable(varargin)
	

tsize  = varargin{1}; % [iw jw] of the underlying table
pcoord = varargin{2};

%figure
iw  = tsize(1);
jw  = tsize(2);
tbl = reshape(1:iw*jw,[jw iw])';
for ip = 1 : iw*jw
	subp(ip) = subplot(iw,jw,ip);
end

% INITIAL POSITIONS:
for ip = 1 : iw*jw
	posi0(ip,:) = get(subp(ip),'position');	
end

% HIDE UNNCESSARY PLOTS:
for ip = 1 : iw*jw
	if isempty(find(pcoord(:,1)==ip))
		set(subp(ip),'visible','off');
%		set(subp(ip),'color','w');
	else
%		set(subp(ip),'color','r');
	end
end

% CHANGE SUBPLOT WIDTH:
for ip = 1 : size(pcoord,1)
	ip1 = pcoord(ip,1);
	ip2 = pcoord(ip,2);
	wi = posi0(ip2,1) + posi0(ip2,3) - posi0(ip1,1);
	set(subp(ip1),'position',[posi0(ip1,1:2) wi posi0(ip1,4)]);
end

% CHANGE SUBPLOT HEIGHT:
for ip = 1 : size(pcoord,1)
	ip1 = pcoord(ip,1);
	ip2 = pcoord(ip,2);
	
	% Find the lines we are in:
	[l1 c1] = find(tbl==ip1);
	[l2 c2] = find(tbl==ip2);
	% Eventually extent the plot:
	if l1 ~= l2
		wi = posi0(ip2,1) + posi0(ip2,3) - posi0(ip1,1);
		hg = posi0(ip1,2) + posi0(ip1,4) - posi0(ip2,2);
		bt = posi0(ip2,2);
		set(subp(ip1),'position',[posi0(ip1,1) bt wi hg]);
	end
end



if nargout >=1
	varargout(1) = {subp(pcoord(:,1))};
end












