%Display a status/progress bar and inform about the elapsed
%as well as the remaining time (linear estimation).
%
%Synopsis:
%
%  f=statusbar2015
%     Get all status/progress bar handles.
%
%  f=statusbar2015(title)
%     Create a new status/progress bar. If title is an empty
%     string, the default 'Progress ...' will be used.
%
%  f=statusbar2015(title,f)
%     Reset an existing status/progress bar or create a new
%     if the handle became invalid.
%
%  f=statusbar2015(done,f)
%     For 0 < done < 1, update the progress bar and the elap-
%     sed time. Estimate the remaining time until completion.
%     On user abort, return an empty handle.
%
%  v=statusbar2015('on')
%  v=statusbar2015('off')
%     Set default visibility for new statusbars and return
%     the previous setting.
%
%  v=statusbar2015('on',f)
%  v=statusbar2015('off',f)
%     Show or hide an existing statusbar and return the last
%     visibility setting.
%
%  delete(statusbar2015)
%     Remove all status/progress bars.
%
%  drawnow
%     Refresh all GUI windows.
%
%Example:
%
%     f=statusbar2015('Wait some seconds ...');
%     for p=0:0.01:1
%        pause(0.2);
%        if isempty(statusbar2015(p,f))
%           break;
%        end
%     end
%     if ishandle(f)
%        delete(f);
%     end
%
%            Main author:
%        (c) 2007, Marcel Leutenegger
%
%            Contributor
%        (c) 2015, Mindaugas Baranauskas
%
function f=statusbar2015(varargin)

if nargin > 0;
    p=varargin{1};
elseif exist('lokaliz.m','file')
    p=lokaliz('Palaukite!');
else
    p=lokalizuoki('Please wait!');
end;

if nargin > 1;
    f=varargin{2};
else
    f=[];
end;

persistent visible;
if nargin < nargout           % get handles
   o='ShowHiddenHandles';
   t=get(0,o);
   set(0,o,'on');
   f=findobj(get(0,'Children'),'flat','Tag','StatusBar');
   set(0,o,t);
   return;
end
curtime=86400*now;
if and(nargin, ischar(p))
   if isequal(p,'on') || isequal(p,'off')
      if nargin == 2
         if ~isempty(check(f))    % show/hide
            v=get(f,'Visible');
            set(f,'Visible',p);
         end
      else
         v=visible;
         visible=p;              % default
         if ~strcmp(v,'off')
            v='on';
         end
      end
      if nargout
         f=v;
      end
   else
      if and((nargin == 2), ~isempty(check(f)));  % reset
         modify(f,'Line','XData',[4 4 4]);
         modify(f,'Rect','Position',[4 54 0.1 22]);
         modify(f,'Done','String','0');
         modify(f,'Time','String','0:00:00');
         modify(f,'Task','String','0:00:00');
      else
         f=create(visible);      % create
      end
      if p
         set(f,'Name',p);
      end
      set(f,'CloseRequestFcn', @close_do_not_close ,... 
            'UserData',[curtime curtime 0]);
   end
   drawnow;
elseif nargin == 2 && ~isempty(check(f)) % update
   t=get(f,'UserData');
   if any(t < 0)              % confirm
      if p >= 1 || isequal(...
              questdlg({lokalizuoki('Are you sure to stop the execution now?'),''},...
                        lokalizuoki('Abort requested'),...
                        lokalizuoki('Stop'),...
                        lokalizuoki('Resume'),...
                        lokalizuoki('Resume')),...
                        lokalizuoki('Stop'))
         delete(f);
         f=[];                % interrupt
         return;
      end
      t=abs(t);
      set(f,'UserData',t);    % continue
   end
   p=min(1,max([0 p]));
   %
   % Refresh display if
   %
   %  1. still computing
   %  2. computation just finished
   %    or
   %     more than a second passed since last refresh
   %    or
   %     more than 0.4% computed since last refresh
   %
   if and(any(t), or(p >= 1, or(curtime-t(2) > 1, p-t(3) > 0.004)))
      set(f,'UserData',[t(1) curtime p]);
      t=round(curtime-t(1));
      h=floor(t/60);
      modify(f,'Line','XData',[4 4+248*p 4+248*p]);
      modify(f,'Rect','Position',[4 54 max(0.1,248*p) 22]);
      modify(f,'Done','String',sprintf('%u',floor(p*100+0.5)));
      modify(f,'Time','String',sprintf('%u:%02u:%02u',[floor(h/60);mod(h,60);mod(t,60)]));
      if or(p > 0.05, t > 60)
         t=ceil(t/p-t);
         if t < 1e7
            h=floor(t/60);
            modify(f,'Task','String',sprintf('%u:%02u:%02u',[floor(h/60);mod(h,60);mod(t,60)]));
         end
      end
      if p == 1
         set(f,'CloseRequestFcn','delete(gcbo);','UserData',[]);
      end
      drawnow;
   end
end
if ~nargout
   clear;
end


%Check if a given handle is a progress bar.
%
function f=check(f)
if isempty(f); return; end;
if ishandle(f(1))
    if isequal(get(f(1),'Tag'),'StatusBar'); 
        f=f(1);
    else
        f=[];
    end;
else
   f=[];
end


%Create the progress bar.
%
function f=create(visible)
if or(~nargin, isempty(visible))
   visible='on';
end
s=[256 80];
t=get(0,'ScreenSize');
f=figure('DoubleBuffer','on','HandleVisibility','off','MenuBar','none','Name','Progress ...','IntegerHandle','off','NumberTitle','off','Resize','off','Position',[floor((t(3:4)-s)/2) s],'Tag','StatusBar','ToolBar','none','Visible',visible);
a=struct;
a.Parent=axes('Parent',f,'Position',[0 0 1 1],'Visible','off','XLim',[0 256],'YLim',[0 80]);
%
%Horizontal bar
%
rectangle('Position',[4 54 248 22],'EdgeColor','white','FaceColor',[0.7 0.7 0.7],a);
line([4 4 252],[55 76 76],'Color',[0.5 0.5 0.5],a);
rectangle('Position',[4 54 0.1 22],'EdgeColor','white','FaceColor','red','Tag','Rect',a);
line([4 4 4],[54 54 77],'Color',[0.2 0.2 0.2],'Tag','Line',a);
%
%Description texts
%
a.FontWeight='bold';
a.Units='pixels';
a.VerticalAlignment='middle';
text(136,70,'%',a);
text(16,36,lokalizuoki('Elapsed time:'),a);
text(16,20,lokalizuoki('Remaining:'),a);
text(200,36,'',a);
text(200,20,'',a);
%
%Information texts
%
a.HorizontalAlignment='right';
a.Tag='Done';
text(136,70,'0',a);
a.Tag='Time';
text(198,36,'0:00:00',a);
a.Tag='Task';
text(198,20,'0:00:00',a);


%Modify an object property.
%
function modify(f,t,p,v)
set(findobj(f,'Tag',t),p,v);

function close_do_not_close(~,~,~)
modifiers=get(gcbo,'currentModifier');
if ismember('control',modifiers) && ismember('shift',modifiers) ;
    delete(gcbo);
else
    set(gcbo,'UserData',-abs(get(gcbo,'UserData')));
    s=warning('off','backtrace');
    warning(['Parent function will know about your inquiry to terminate operation. ' ...
        'If you really need to close this dialog, hold both Ctrl and Shift keys. ' ...
        'Note: prematurely closing statusbar may lead to unexpected errors in parent function.']);
    warning(s);
end;

function tekstas=lokalizuoki(pradinis_tekstas)
persistent LANG
if exist('lokaliz.m','file')
    tekstas=lokaliz(pradinis_tekstas);
else
    if isempty(LANG);
       if usejava('awt');
           LC=javaObject ('java.util.Locale','');
           LC_current_locale=LC.getDefault();
           LANG=char(LC_current_locale.getLanguage());
       else
           %LANG='lt';
           LANG='en';
       end
    end
    if strcmp(LANG,'lt')
        if strcmp(pradinis_tekstas,'Please wait!')
            tekstas='Palaukite!';
        elseif strcmp(pradinis_tekstas,'Elapsed time:')
            tekstas='Dirbama:';
        elseif strcmp(pradinis_tekstas,'Remaining:')
            tekstas='Liko:';
        elseif strcmp(pradinis_tekstas,'Are you sure to stop the execution now?')
            tekstas='Norite sustabdyti darbus?';
        elseif strcmp(pradinis_tekstas,'Abort requested')
            tekstas='Ketinimas nutraukti';
        elseif strcmp(pradinis_tekstas,'Stop')
            tekstas='Nutraukti';
        elseif strcmp(pradinis_tekstas,'Resume')
            tekstas='Vykdyti toliau';
        else
            tekstas=pradinis_tekstas;
        end
    else
        tekstas=pradinis_tekstas;
    end
end
