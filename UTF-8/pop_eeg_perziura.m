function pop_eeg_perziura(varargin)
% eeg_perziura - EEG įrašų peržiūra naujame lange
% pop_eeg_perziura(EEG)
% pop_eeg_perziura(EEG1, EEG2)
%
% (C) 2015 Mindaugas Baranauskas

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% licencijos kopija; jei ne - rašykite Free Software Foundation, Inc., 59
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

if nargin == 0; help(mfilename); return; end;
EEG2=[];
if isstruct(varargin{1});
    EEG1=varargin{1};
    try
        if nargin > 1
            if isstruct(varargin{2});
                EEG2=varargin{2};
                g=struct(varargin{3:end});
            elseif ~isempty(varargin{2});
                g=struct(varargin{2:end});
            else
                g=struct(varargin{3:end});
            end;
        else
            g=struct;
        end;
    catch err; Pranesk_apie_klaida(err,'','',0);
        help(mfilename);
    end;
else
    help(mfilename); return;
    %g=struct(varargin{:});
end;

if isfield(g,'ICA');
    if g.ICA;
        if isfield(EEG1,'icaact');
            EEG1.data=EEG1.icaact;
        else
            disp([lokaliz('nerasta') ': EEG.icaact']);
            return;
        end;
        EEG1.nbchan=size(EEG1.data,1);
        EEG1.chanlocs=[];
        EEG2=[]; % neleisti lyginti
        g.zymeti=0; % ir žymėti
    end;
end;

if isfield(g,'title'); pvd=g.title; 
elseif isempty(EEG2)
    pvd=EEG1.setname;
else
    pvd=[ EEG1.setname ' + ' EEG2.setname ] ;
end;


f=figure('toolbar','none','menubar','none','NumberTitle','off',...
    'units','normalized','outerposition',[0 0 1 1],'tag','Darbeliai','name', pvd);
a=axes('units','normalized','position',[0.08 0.05 0.9 0.9 ]);
p=uicontrol('style','pushbutton', 'String', lokaliz('Close'),  'Tag', 'Close', ...
    'Units', 'normalized', 'position', [0.84 0.05 0.1 0.05], 'callback', ...
    'if get(gcf,''userdata''); eeg_perziura(''gauk_zymejimo_sriti''); uiresume; else delete(gcf); end;');
set(f,'Visible','off');

zymeti=isempty(EEG2);
if isfield(g,'zymeti'); zymeti=g.zymeti; end;
if zymeti; setappdata(a,'zymeti',1); end;

laukti=zymeti;
if isfield(g,'laukti'); laukti=g.laukti; end;
if laukti;
    set(f, 'UserData', 1);
end;

if isempty(EEG2)
    if zymeti;
        eeg_perziura(EEG1, EEG1, 'figure', f, 'axes', a);
    else
        eeg_perziura(EEG1, []  , 'figure', f, 'axes', a);
    end;
else
        eeg_perziura(EEG1, EEG2, 'figure', f, 'axes', a);
end;

if isempty(getappdata(a,'EEG1'));
    delete(f);
    return;
end;
    
set(f,'Visible','on');
if get(f,'userdata');
    uiwait(f);
    delete(f);
end;


