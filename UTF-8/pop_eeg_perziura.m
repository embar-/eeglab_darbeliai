function pop_eeg_perziura(varargin)
% eeg_perziura - EEG įrašų peržiūra naujame lange
% pop_eeg_perziura(EEG)
% pop_eeg_perziura(EEG1, EEG2)
% pop_eeg_perziura(EEG1, EEG2, 'title', 'Savitas lango pavadinimas')
% pop_eeg_perziura(EEG1, [], 'ICA', 1) - rodyti ne kanalo signalą, bet NKA kompoenentes
% pop_eeg_perziura(EEG1, EEG2, 'zymeti', 1) - eksperimentinis laiko atkarpų žymėjimas
% pop_eeg_perziura(EEG1, EEG2, 'narsyti', 1) - eksperimentinis rinkmenų naršymo langelis
%
% (C) 2015-2016 Mindaugas Baranauskas

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


f=figure('ToolBar','none','MenuBar','none','Name', pvd, 'NumberTitle','off',...
    'Units','normalized','OuterPosition',[0 0 1 1],'Tag','Darbeliai',...
    'Color',[0.9400 0.9400 0.9400]);

narsyti=0;
if isfield(g,'narsyti'); narsyti=g.narsyti; end;
if narsyti;
    a=axes('units','normalized','position',[0.08 0.05 0.72 0.9 ]);
    handles.listbox1=...
        uicontrol('style','listbox', 'Tag', 'listbox1',...
        'Units', 'normalized', 'position', [0.8 0.18 0.19 0.77]);
%     handles.text_failu_filtras1=...(
%         uicontrol('style','text', 'String',lokaliz('Show_filenames_filter:'),...
%         'Units', 'normalized', 'position', [0.8 0.13 0.09 0.04],...
%         'HorizontalAlignment', 'left');
    handles.edit_failu_filtras1=...
        uicontrol('style','edit', 'Tag', 'edit_failu_filtras1',...
        'Units', 'normalized', 'position', [0.8 0.14 0.19 0.04],...
        'String', '*.set;*.cnt');
    handles.edit1=uicontrol('style','edit', 'Tag', 'edit1',...
        'Units', 'normalized', 'position', [0.8 0.955 0.16 0.04],...
        'HorizontalAlignment', 'left', 'String', pwd);
    handles.pushbutton_v1=...
        uicontrol('style','pushbutton', 'String','v', 'Tag', 'pushbutton_v1',...
        'Units', 'normalized', 'position', [0.96 0.955 0.015 0.04]);
    handles.pushbutton_1=uicontrol('style','pushbutton', 'String','...', 'Tag', 'pushbutton_1',...
        'Units', 'normalized', 'position', [0.975 0.955 0.015 0.04]);
    handles.figure1=f;
    handles.axes1=a;
    set(handles.pushbutton_1, 'callback', {@pushbutton_1_Callback, handles} );
    set(handles.pushbutton_v1, 'callback', {@pushbutton_v1_Callback, handles} );
    set(handles.edit_failu_filtras1, 'callback', {@atnaujink_rodoma_kelia_ir_failus, handles} );
    set(handles.edit1, 'callback', {@atnaujink_rodoma_kelia_ir_failus, handles} );
    set(handles.listbox1, 'callback', {@listbox1_Callback, handles} );
    atnaujink_rodoma_kelia_ir_failus(handles.edit1, [], handles);
else
    a=axes('units','normalized','position',[0.08 0.05 0.9 0.9 ]);
end;

p=uicontrol('style','pushbutton', 'String', lokaliz('Close'),  'Tag', 'Close', ...
    'Units', 'normalized', 'position', [0.84 0.05 0.1 0.05], 'callback', ...
    'if get(gcf,''userdata''); eeg_perziura(''gauk_zymejimo_sriti''); uiresume; else delete(gcf); end;');
set(f,'Visible','off');

zymeti=0; % isempty(EEG2);
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
    try delete(f); catch ; end;
end;


function listbox1_Callback(hObject, eventdata, handles)
id=get(handles.listbox1,'Value');
if isempty(id); return; end;
Kelias=get(handles.edit1,'String');
Rinkmenos=get(handles.listbox1,'String');
Rinkmena=Rinkmenos{id};
[EEG]=eeg_ikelk(Kelias, Rinkmena);
if isempty(EEG); return; end;
eeg_perziura('perkurti', EEG, [], 'f', handles.figure1, 'a', handles.axes1);
set(handles.figure1,'Name',Rinkmena);

function pushbutton_v1_Callback(hObject, eventdata, handles)
i=get(handles.edit1,'String'); % įkėlimo
n=get(hObject,'UserData'); % naudotieji
a=drb_uzklausa('katalogas','atverimui',i, n);
if isempty(a); return; end;
set(handles.edit1,'String',a);
atnaujink_rodoma_kelia_ir_failus(hObject, eventdata, handles);

function pushbutton_1_Callback(hObject, eventdata, handles)
dbr_kelias=pwd;
try cd(get(handles.edit1,'String')); catch; end;
KELIAS=uigetdir;
set(handles.edit1,'String',Tikras_Kelias(KELIAS));
cd(dbr_kelias);
atnaujink_rodoma_kelia_ir_failus(hObject, eventdata, handles);

function atnaujink_rodoma_kelia_ir_failus(hObject, eventdata, handles)
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);

% Atnaujink rodoma kelia
function atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles)
kelias_orig=pwd;
try
    cd(get(handles.edit1,'String'));
catch err;
    try
        cd(Tikras_Kelias(get(handles.edit1,'TooltipString')));
    catch err;
    end;
end;
set(handles.edit1,'String',pwd);
set(handles.edit1,'TooltipString',pwd);
set(handles.pushbutton_v1,'UserData',...
    unique([get(handles.pushbutton_v1,'UserData') kelias_orig {pwd}]));
cd(kelias_orig);
set(handles.edit1,'BackgroundColor',[1 1 1]);

% Atnaujink rodomus failus
function atnaujink_rodomus_failus(hObject, eventdata, handles)
Kelias_dabar=pwd;
cd(get(handles.edit1,'String'));
FAILAI=filter_filenames(get(handles.edit_failu_filtras1,'String'));
if isempty(FAILAI);
    %FAILAI(1).name='';
    set(handles.listbox1,'Max',0);
    set(handles.listbox1,'Value',[]);
    set(handles.listbox1,'SelectionHighlight','off');
else
    set(handles.listbox1,'Max',1);
    set(handles.listbox1,'Value',1);
    set(handles.listbox1,'SelectionHighlight','on');
end;
set(handles.listbox1,'String',FAILAI);
cd(Kelias_dabar);

