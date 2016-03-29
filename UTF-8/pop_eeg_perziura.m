function pop_eeg_perziura(varargin)
% eeg_perziura - EEG įrašų peržiūra naujame lange
% pop_eeg_perziura(EEG)
% pop_eeg_perziura(EEG1, EEG2)
% pop_eeg_perziura(EEG1, EEG2, 'title', 'Savitas lango pavadinimas')
% pop_eeg_perziura(EEG1, [], 'ICA', 1) - rodyti ne kanalo signalą, bet NKA kompoenentes
% pop_eeg_perziura(EEG1, EEG2, 'zymeti', 1) - eksperimentinis laiko atkarpų žymėjimas
% pop_eeg_perziura('narsyti', 1) - eksperimentinė rinkmenų naršyklė šone (vieno įkeltino įrašo pasirinkimas)
% pop_eeg_perziura('narsyti', 2) - dvi eksperimentinės rinkmenų naršyklės šone (dviejų palygintinų įrašų pasirinkimas)
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
    try
        g=struct(varargin{:});
        [~,EEG1]=pop_newset([],[],[]);
    catch
        help(mfilename); return;
    end;
end;

if isfield(g,'ICA');
    if g.ICA;
        if ~isfield(EEG1,'icaact');
            disp([lokaliz('nerasta') ': EEG.icaact']);
            return;
        end;
        if isempty(EEG1.icaact);
            disp([lokaliz('nerasta') ': EEG.icaact']);
            return;
        end;
        EEG1.data=EEG1.icaact;
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
    handles.edit1=uicontrol('style','edit', 'Tag', 'edit1',...
        'Units', 'normalized', 'position', [0.8 0.955 0.16 0.04],...
        'HorizontalAlignment', 'left', 'String', pwd);
    handles.pushbutton_v1=...
        uicontrol('style','pushbutton', 'String','v', 'Tag', 'pushbutton_v1',...
        'Units', 'normalized', 'position', [0.96 0.955 0.015 0.04]);
    handles.pushbutton_1=uicontrol('style','pushbutton', 'String','...', 'Tag', 'pushbutton_1',...
        'Units', 'normalized', 'position', [0.975 0.955 0.015 0.04]);
    if narsyti == 2
        handles.listbox1=...
            uicontrol('style','listbox', 'Tag', 'listbox1',...
            'Units', 'normalized', 'position', [0.8 0.59 0.19 0.36]);
        handles.listbox2=...
            uicontrol('style','listbox', 'Tag', 'listbox2',...
            'Units', 'normalized', 'position', [0.8 0.18 0.19 0.36]);
        handles.edit_failu_filtras1=...
            uicontrol('style','edit', 'Tag', 'edit_failu_filtras1',...
            'Units', 'normalized', 'position', [0.8 0.545 0.19 0.04],...
            'String', '*.set;*.cnt');
        handles.edit2=uicontrol('style','edit', 'Tag', 'edit2',...
            'Units', 'normalized', 'position', [0.8 0.14 0.16 0.04],...
            'HorizontalAlignment', 'left', 'String', pwd);
        handles.pushbutton_v2=...
            uicontrol('style','pushbutton', 'String','v', 'Tag', 'pushbutton_v2',...
            'Units', 'normalized', 'position', [0.96 0.14 0.015 0.04]);
        handles.pushbutton_2=uicontrol('style','pushbutton', 'String','...', 'Tag', 'pushbutton_2',...
            'Units', 'normalized', 'position', [0.975 0.14 0.015 0.04]);
    else
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
    end;
    handles.figure1=f;
    handles.axes1=a;
    set(handles.pushbutton_1, 'callback', {@pushbutton_1_Callback, handles} );
    set(handles.pushbutton_v1, 'callback', {@pushbutton_v1_Callback, handles} );
    set(handles.edit_failu_filtras1, 'callback', {@atnaujink_rodoma_kelia_ir_failus, handles} );
    try set(handles.edit_failu_filtras1,'String',g(1).flt_show); catch; end;
    set(handles.edit1, 'callback', {@atnaujink_rodoma_kelia_ir_failus1, handles} );
    try set(handles.edit1,'String',g(1).path);   catch; end;
    try set(handles.edit1,'String',g(1).pathin); catch; end;
    if narsyti == 2
        set(handles.listbox1, 'callback', {@listbox1B_Callback, handles} );
        set(handles.pushbutton_2, 'callback', {@pushbutton_2_Callback, handles} );
        set(handles.pushbutton_v2, 'callback', {@pushbutton_v2_Callback, handles} );
        set(handles.listbox2, 'callback', {@listbox2_Callback, handles} );
        set(handles.edit2, 'callback', {@atnaujink_rodoma_kelia_ir_failus2, handles} );
        try set(handles.edit2,'String',g(1).path);    catch; end;
        try set(handles.edit2,'String',g(1).pathout); catch; end;
        atnaujink_rodoma_kelia_ir_failus2(handles.edit2, [], handles);
    else
        set(handles.listbox1, 'callback', {@listbox1A_Callback, handles} );
    end;
    atnaujink_rodoma_kelia_ir_failus1(handles.edit1, [], handles);
    try tmp=find(ismember(get(handles.listbox1,'String'), {g.files})); 
        set(handles.listbox1,'Value',tmp(1));
    catch
    end;
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

if isempty(EEG1.data);
    if narsyti == 1;
        listbox1A_Callback(handles.listbox1, [], handles);
    elseif narsyti == 2;
        listbox1B_Callback(handles.listbox1, [], handles)
    end;
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


function listbox1A_Callback(hObject, eventdata, handles)
id=get(handles.listbox1,'Value');
if isempty(id); return; end;
Kelias=get(handles.edit1,'String');
Rinkmenos=get(handles.listbox1,'String');
Rinkmena=Rinkmenos{id};
[EEG]=eeg_ikelk(Kelias, Rinkmena);
if isempty(EEG); return; end;
eeg_perziura('perkurti', EEG, [], 'f', handles.figure1, 'a', handles.axes1);
set(handles.figure1,'Name',Rinkmena);

function listbox1B_Callback(hObject, eventdata, handles)
id=get(handles.listbox1,'Value');
if isempty(id); return; end;
Kelias=get(handles.edit1,'String');
Rinkmenos=get(handles.listbox1,'String');
Rinkmena=Rinkmenos{id};
Kelias2=get(handles.edit2,'String');
Rinkmenos2=get(handles.listbox2,'String');
[Rinkmena2,id2]=rask_panasiausia(Rinkmena,Rinkmenos2);
[EEG]=eeg_ikelk(Kelias, Rinkmena);
if isempty(EEG); return; end;
if isempty(Rinkmena2);
    EEG2=[];
else
    [EEG2]=eeg_ikelk(Kelias2, Rinkmena2);
    set(handles.listbox2,'Value',id2(1));
end;

eeg_perziura('perkurti', EEG, EEG2, 'f', handles.figure1, 'a', handles.axes1);
if isempty(Rinkmena2);
    set(handles.figure1,'Name',Rinkmena);
else
    set(handles.figure1,'Name', [Rinkmena ' + ' Rinkmena2]);
end;

function listbox2_Callback(hObject, eventdata, handles)
id2=get(handles.listbox2,'Value');
if isempty(id2); return; end;
Kelias2=get(handles.edit2,'String');
Rinkmenos2=get(handles.listbox2,'String');
Rinkmena2=Rinkmenos2{id2};
[EEG2]=eeg_ikelk(Kelias2, Rinkmena2);
if isempty(EEG2); return; end;

id=get(handles.listbox1,'Value');
if isempty(id);
    EEG=[];
    Rinkmena='';
else
    Kelias=get(handles.edit1,'String');
    Rinkmenos=get(handles.listbox1,'String');
    Rinkmena=Rinkmenos{id};
    [EEG]=eeg_ikelk(Kelias, Rinkmena);
end;

eeg_perziura('perkurti', EEG, EEG2, 'f', handles.figure1, 'a', handles.axes1);
set(handles.figure1,'Name', [Rinkmena ' + ' Rinkmena2]);

function pushbutton_v1_Callback(hObject, eventdata, handles)
i=get(handles.edit1,'String'); % įkėlimo
n=get(handles.pushbutton_v1,'UserData'); % naudotieji
a=drb_uzklausa('katalogas','atverimui',i, n);
if isempty(a); return; end;
set(handles.edit1,'String',a);
atnaujink_rodoma_kelia_ir_failus1(hObject, eventdata, handles);

function pushbutton_v2_Callback(hObject, eventdata, handles)
i=get(handles.edit2,'String'); % įkėlimo
n=get(handles.pushbutton_v2,'UserData'); % naudotieji
a=drb_uzklausa('katalogas','atverimui',i, n);
if isempty(a); return; end;
set(handles.edit2,'String',a);
atnaujink_rodoma_kelia_ir_failus2(hObject, eventdata, handles);

function pushbutton_1_Callback(hObject, eventdata, handles)
pushbutton_N_Callback(handles.edit1);
atnaujink_rodoma_kelia_ir_failus1(hObject, eventdata, handles);

function pushbutton_2_Callback(hObject, eventdata, handles)
pushbutton_N_Callback(handles.edit2);
atnaujink_rodoma_kelia_ir_failus2(hObject, eventdata, handles)

function pushbutton_N_Callback(h_edit)
dbr_kelias=pwd;
try cd(get(h_edit,'String')); catch; end;
KELIAS=uigetdir;
set(h_edit,'String',Tikras_Kelias(KELIAS));
cd(dbr_kelias);

function atnaujink_rodoma_kelia_ir_failus1(hObject, eventdata, handles)
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles.edit1, handles.pushbutton_v1);
atnaujink_rodomus_failus(hObject, eventdata, handles.edit1, handles.listbox1, handles.edit_failu_filtras1);

function atnaujink_rodoma_kelia_ir_failus2(hObject, eventdata, handles)
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles.edit2, handles.pushbutton_v2);
atnaujink_rodomus_failus(hObject, eventdata, handles.edit2, handles.listbox2, handles.edit_failu_filtras1);

function atnaujink_rodoma_kelia_ir_failus(hObject, eventdata, handles)
atnaujink_rodoma_kelia_ir_failus1(hObject, eventdata, handles);
atnaujink_rodoma_kelia_ir_failus2(hObject, eventdata, handles);

% Atnaujink rodoma kelia
function atnaujink_rodoma_darbini_kelia(hObject, eventdata, h_edit, h_pushbutton_v)
kelias_orig=pwd;
try
    cd(get(h_edit,'String'));
catch err; %#ok
    try
        cd(Tikras_Kelias(get(h_edit,'TooltipString')));
    catch err; %#ok
    end;
end;
set(h_edit,'String',pwd);
set(h_edit,'TooltipString',pwd);
set(h_pushbutton_v,'UserData',...
    unique([get(h_pushbutton_v,'UserData') kelias_orig {pwd}]));
cd(kelias_orig);
set(h_edit,'BackgroundColor',[1 1 1]);

% Atnaujink rodomus failus
function atnaujink_rodomus_failus(hObject, eventdata, h_edit, h_listbox, h_edit_failu_filtras)
Kelias_dabar=pwd;
cd(get(h_edit,'String'));
FAILAI=filter_filenames(get(h_edit_failu_filtras,'String'));
if isempty(FAILAI);
    %FAILAI(1).name='';
    set(h_listbox,'Max',0);
    set(h_listbox,'Value',[]);
    set(h_listbox,'SelectionHighlight','off');
else
    set(h_listbox,'Max',1);
    set(h_listbox,'Value',1);
    set(h_listbox,'SelectionHighlight','on');
end;
set(h_listbox,'String',FAILAI);
cd(Kelias_dabar);

function [panasiausias,nr]=rask_panasiausia(zodis,sarasas)
panasiausias='';
nr=0;
if isempty(zodis) || isempty(sarasas);
    return;
end;
ats=regexp(sarasas, [ '^' zodis '.*' ]);
nr=find(arrayfun(@(x) ~isempty(ats{x}), 1:length(ats)));
if isempty(nr);
    [panasiausias,nr]=rask_panasiausia(regexprep(zodis,'.$',''),sarasas);
elseif (length(nr) == 1) || length(zodis) > 1 ;
    panasiausias=sarasas{nr(1)};
end;
