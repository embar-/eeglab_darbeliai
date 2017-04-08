function h=Pranesk_apie_klaida(varargin)
% h=Pranesk_apie_klaida(err, Darbelis, Rinkmena, dialogas)
%
%
% Ši programa yra laisva. Jūs galite ją platinti ir/arba modifikuoti
% remdamiesi Free Software Foundation paskelbtomis GNU Bendrosios
% Viešosios licencijos sąlygomis: 2 licencijos versija, arba (savo
% nuožiūra) bet kuria vėlesne versija.
%
% Ši programa platinama su viltimi, kad ji bus naudinga, bet BE JOKIOS
% GARANTIJOS; be jokios numanomos PERKAMUMO ar TINKAMUMO KONKRETIEMS
% TIKSLAMS garantijos. Žiūrėkite GNU Bendrąją Viešąją licenciją norėdami
% sužinoti smulkmenas.
%
% Jūs turėjote kartu su šia programa gauti ir GNU Bendrosios Viešosios
% licencijos kopiją; jei ne - rašykite Free Software Foundation, Inc., 59
% Temple Place - Suite 330, Boston, MA 02111-1307, USA.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
%%
%
% (C) 2014,2017 Mindaugas Baranauskas
%

if nargin > 0
    err = varargin{1};
else
    err = lasterror ;%#ok
end;

if nargin > 1
    Darbelis = varargin{2};
else
    Darbelis = '?' ;
end;

if nargin > 2
    Rinkmena = varargin{3};
else
    Rinkmena = '?' ;
end;

if nargin > 3
    dialogas = varargin{4};
else
    dialogas = 1 ;
end;

if nargin > 4
    laukti  = varargin{5};
else
    laukti  = 0 ;
end;

%assignin('base', 'err', err)
disp(' ');

h=[];
t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
if ischar(err)
    err=struct('identifier','','message',err,'stack','');
end;
msg=sprintf('%s\n\n%s\n',err.identifier, err.message);
if ~isempty(err.stack)
    for i=1:(length(err.stack)-1)
        msg=sprintf('%s\n> <a href="matlab:opentoline(''%s'',%d,1)">%s:%d</a>', msg, ...
            err.stack(i).file, ...
            err.stack(i).line, ...
            err.stack(i).name, ...
            err.stack(i).line ) ;
    end;
    msg=sprintf('%s\n\n  %s\n\n',msg,err.stack(end).name);
end;
%msg=sprintf('%s\n\n',msg);
s=warning('off','backtrace');
warning(msg);

if strcmp('MATLAB:binder:loadFailure',err.identifier)
   warning(['<a href="matlab:web http://stackoverflow.com/questions/19268293/matlab-error-cannot-open-with-static-tls -browser">' ...
            'http://stackoverflow.com/questions/19268293/matlab-error-cannot-open-with-static-tls</a> ' ...
            fullfile(matlabroot,'toolbox','local','startup.m')  ...
            ' webutils.htmlrenderer(''basic''); ' ]);
   
   h=errordlg([ lokaliz('You must restart MATLAB because of internal error.') ...
       ' http://stackoverflow.com/questions/19268293/matlab-error-cannot-open-with-static-tls' ], ...
       'MATLAB','replace') ;
   set(h,'DeleteFcn', 'exit');
   %set(allchild(h),'Callback', 'exit');   
   waitfor(h); h=[];
   
   error(lokaliz('You must restart MATLAB because of internal error.'));
end;

warning(s.state,'backtrace');


if ~dialogas
    return;
end;
msg2=sprintf('%s\n',strrep(regexprep(err.message,'<a href="[^<]*">','"'),'</a>','"'));
for i=1:(length(err.stack)-1)
    msg2=sprintf('%s\n> %s:%d', msg2, ...
        err.stack(i).name, ... %err.stack(i).file, ...
        err.stack(i).line ) ; 
end;
if ~isempty(err.stack)
    msg2=sprintf('%s\n %s\n',msg2,err.stack(end).name);
end;

h=findobj('tag','EEGLAB Darbeliu klaidos langas');
m=findobj('tag','EEGLAB Darbeliu klaidos tekstas');
if or(isempty(h),isempty(m))
    %disp('Naujas klaidos langas')
    h=figure('position', [100 100 440 440], 'units','pixels',...
        'toolbar','none','menubar','none', 'NumberTitle','off', ...
        'tag','EEGLAB Darbeliu klaidos langas', ...
        'Name', ['Darbeliai: ' lokaliz('Error')]);
    hsp=get(h,'color');
    m=uicontrol('style','edit','max',100,...
        'position', [20 70 400 350], 'units','pixels',...
        'enable','inactive','HorizontalAlignment','left',...
        'BackgroundColor', [max(1, hsp(1)+0.01) hsp([2 3])],...
        'tag','EEGLAB Darbeliu klaidos tekstas',...
        'string',{' '});
    uicontrol('style','pushbutton','string',lokaliz('Copy'),...
        'position', [20 20 190 30], 'callback', {@kopijuoti,m});
    uicontrol('style','pushbutton','string',lokaliz('Close'),...
        'position', [220 20 190 30], 'callback', 'delete(gcf)');
    set(m,'units','normalized');
end;
mt=get(m,'string');
set(m,'string', [ mt ; ...
    [lokaliz('Time:') ' ' t] ; ...
    [lokaliz('Darbelis:') ' ' Darbelis] ; ...
    [lokaliz('Failas:') ' ' Rinkmena] ; ...
    {' '} ; err.identifier ; msg2 ; { ' '; '---------------'; ' '}  ] )

if laukti
   waitfor(h); h=[];
end;

function kopijuoti(~,~,m)
tekstas = get(m,'string');
OS=fastif(ispc, 'Windows', fastif(isunix, fastif(ismac, 'MAC', 'Linux'), ''));
lc=char(java.util.Locale.getDefault());
tekstas = [ Darbeliu_versija ; ['EEGLAB ' eeg_getversion ]; [ 'MATLAB ' version ' ' OS ' ' lc]; ' '; '---------------'; tekstas ];
clipboard('copy',sprintf('%s\n',tekstas{:}));
