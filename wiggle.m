% wiggle : plot wiggle/VA/image plot 
%
% Call 
%    wiggle(Data); % wiggle plot
%    wiggle(Data,scale); % scaled wiggle plot
%    wiggle(x,t,Data); % wiggle plt
%    wiggle(x,t,Data,'VA') % variable Area
%    wiggle(x,t,Data,'wiggle',scale); % Scaled wiggle 
%    wiggle(x,t,Data,'wiggle',scale,showmax); % Scaled wiggle and max 
%                                               showmax traces.
%    wiggle(x,t,Data,'wiggle',scale,showmax,plimage); % wiggle + image
%    wiggle(x,t,Data,'wiggle',scale,showmax,plimage,caxis); % wiggle +
%                                                             scaled image 
%
% Data : [nt,ntraces]
% x : [1:ntraces] X axis (ex [SegyTraceheaders.offset])
% t : [1:nt] Y axis
% style : ['VA'] : Variable Area
%         ['wiggle'] : Wiggle plot
% scale : scaling factor, can be left empty as []
% showmax [scalar] : max number of traces to show on display [def=100]
% plimage [0/1] : Show image beneath wiggles [def=0];
% caxis [min max]/[scalar] : amplitude range for colorscale
%
%
% MAKE IT WORK FOR ANY X-AXIS !!!
%
%

%
% (C) 2001-2004, Thomas Mejer Hansen, tmh@gfy.ku.dk/thomas@cultpenguin.com
% 
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
%

function wiggle(x,t,Data,style,dmax,showmax,plImage,imageax,example_plot);

  if (nargin==9);
    np=3;
    subplot(np,np,1); wiggle(Data);    
    subplot(np,np,2); wiggle(Data,dmax);
    subplot(np,np,3); wiggle(x,t,Data);
    subplot(np,np,4); wiggle(x,t,Data,style,dmax);
    subplot(np,np,5); wiggle(x,t,Data,style,dmax,showmax);
    subplot(np,np,6); wiggle(x,t,Data,style,dmax,showmax,plImage);
    if isempty(dmax), dmax=nanmax(abs(Data(:))); end   
    subplot(np,np,7); wiggle(x,t,Data,style,dmax,showmax,plImage,dmax./10);
    return
  end
  
  showmax_def=200;%¸Ä¶¯
  style_def='wiggle';
  
  if nargin==1,
    Data=x;
    t=[1:1:size(Data,1)];
    x=[1:1:size(Data,2)];
    % dmax=nanmax(Data(:));
    dmax=max(Data(:));
    style=style_def;
    showmax=showmax_def;
  end

  
  if nargin==2,
    Data=x;
    dmax=t;
    t=[1:1:size(Data,1)];
    x=[1:1:size(Data,2)];
    style=style_def;   
    showmax=showmax_def;
  end
  
  if nargin==3,
    style=style_def;
    dmax=nanmax(abs(Data(:)));    
    showmax=showmax_def;
  end
  
  if nargin==4, 
    dmax=nanmax(abs(Data(:)));
    showmax=showmax_def;
  end

  if nargin==5, 
    showmax=showmax_def;
  end

  if nargin<7
    plImage=0;
  end

    
  if isempty(dmax),
    % Set scaling factor dmax if empty
    dmax=nanmax(abs(Data(:)));
  end

  if isempty(showmax),
    showmax=100;
  end  

  if nargin==7,
    imageax=[-1 1].*dmax;
  end

     
  if plImage==1,
    imagesc(x,t,Data);
    if (length(imageax)==1)
      imageax=[-1 1].*abs(imageax);
    end    
    caxis(imageax);
    hold on
  end
  
  if (showmax>0)
    if length(x)>1, dx=x(2)-x(1); end
    ntraces=length(x);
    d=ntraces/showmax;
    if d<=1; d=1; end
    d=round(d);
    
    dmax=dmax/d;
    
    for i=1:d:length(x)
      xt=dx*Data(:,i)'./dmax;
      %      if (strmatch(style,'VA','exact')==1)
      %        xt1=xt;xt1(find(xt1>0))=0;
      %        fill(x(i)+[xt,fliplr(xt1)],[t,fliplr(t)],[0 0 0])
      %      else
      
      % MATLAB PLOT
      plot(xt+x(i),t,'k-','linewidth',0.5);
      %OCTAVE PLOT
      %plot(xt+x(i),t,'k-')
      %      end   
      if i==1, hold on;end
      
    end
    
    axis([x(1) x(i)+1 min(t) max(t)])    
  end
  hold off;  
set(gca,'Ydir','revers')