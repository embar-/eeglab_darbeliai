function drb_meniu(varargin)
% drb_meniu - bendrų meniu sukūrimas „Darbelių“ languose 
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
if nargin > 0; hObject=varargin{1};
else           hObject=gcf;
end;
if nargin > 1; eventdata=varargin{2};
else           eventdata=[];
end;
if nargin > 2; handles=varargin{3};
else           handles.figure1=gcf;
end;
if nargin > 3; meniu=varargin{4};
else           meniu='visas';
end;
if nargin > 4; darbas=varargin{5};
else           darbas='';
end;

if isempty(handles); 
    handles.figure1=gcf;
end;

switch lower(meniu)
    case {'darbeliai'}
        drb_meniu_darbeliai(hObject, eventdata, handles, darbas, varargin(6:end));
    case {'parinktys'}
        drb_meniu_parinktys(hObject, eventdata, handles, darbas, varargin(6:end));
    case {'veiksmai'}
        drb_meniu_veiksmai( hObject, eventdata, handles, darbas, varargin(6:end));
    case {'apie'}
        drb_meniu_apie(     hObject, eventdata, handles, darbas, varargin(6:end));
    case {'visas'}
        drb_meniu_darbeliai(hObject, eventdata, handles, darbas, varargin(6:end));
        drb_meniu_parinktys(hObject, eventdata, handles, darbas, varargin(6:end));
        drb_meniu_veiksmai( hObject, eventdata, handles, darbas, varargin(6:end));
        drb_meniu_apie(     hObject, eventdata, handles, darbas, varargin(6:end));
    otherwise
        warning(lokaliz('Netinkami parametrai'));
        help(mfilename);
end

function drb_meniu_darbeliai(hObject, eventdata, handles, darbas, varargin) %#ok
%% Darbeliai
delete(findall(handles.figure1,'type','uimenu'));
handles.meniu_darbeliai = uimenu(handles.figure1,'Label','Darbeliai','Tag','m_Darbeliai');

uimenu( handles.meniu_darbeliai, 'Label', lokaliz('Pervadinimas su info suvedimu'),  'tag','pop_pervadinimas', ...
        'Separator','off',  'Callback', {@nukreipimas_i_kita_darba, handles, darbas,       'pop_pervadinimas'});
uimenu( handles.meniu_darbeliai, 'Label', lokaliz('Nuoseklus apdorojimas'),          'tag','pop_nuoseklus_apdorojimas', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_nuoseklus_apdorojimas'});
if strcmp(char(java.util.Locale.getDefault()),'lt_LT');
uimenu( handles.meniu_darbeliai, 'Label', lokaliz('EEG + EKG'),                      'tag','pop_QRS_i_EEG', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_QRS_i_EEG'});
end;
uimenu( handles.meniu_darbeliai, 'Label', lokaliz('Epochavimas pg. stimulus ir atsakus'),'tag','pop_Epochavimas_ir_atrinkimas', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,            'pop_Epochavimas_ir_atrinkimas'});
uimenu( handles.meniu_darbeliai, 'Label', lokaliz('ERP properties, export...'),      'tag','pop_ERP_savybes', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_ERP_savybes'});
uimenu( handles.meniu_darbeliai, 'Label', [ lokaliz('EEG spektras ir galia') '...' ],'tag','pop_eeg_spektrine_galia', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_eeg_spektrine_galia'});
uimenu( handles.meniu_darbeliai, 'Label', lokaliz('Custom command') ,                'tag','pop_rankinis', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_rankinis'});
uimenu( handles.meniu_darbeliai, 'Label', lokaliz('Meta darbeliai...') ,             'tag','pop_meta_drb', ...
        'Separator','on',  'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_meta_drb'});
set(findobj(handles.meniu_darbeliai,'Tag',darbas),'Enable','off')


function nukreipimas_i_kita_darba(hObject, eventdata, handles, aktyvus_darbas, naujas_darbas, varargin) %#ok
%%
switch aktyvus_darbas
    case {'pop_pervadinimas'}
        pathin   = get(handles.edit_tikri,'String');
        pathout  = get(handles.edit_siulomi,'String');
       %flt_show = get(handles.edit_failu_filtras1,'String');
        flt_slct = get(handles.edit_filtras,'String');
        files_sh = get(handles.listbox_tikri,'String');
        files_sN = get(handles.listbox_tikri,'Value');
        if ~isempty(files_sN) && ~isequal(files_sN,0);
            files_sl = files_sh(files_sN);
            ar_filtr = 0 ;%strcmp(get(handles.edit_filtras,'Style'),'edit') #FIXME: pop_pervadinime failų rankinis žymėjimas neperjungia stiliaus
        else
            ar_filtr = 1;
        end;
        darbeliu_param={ 'pathin',pathin, 'pathout',pathout };
    otherwise
        pathin   = get(handles.edit1,'String');
        pathout  = get(handles.edit2,'String');
        flt_show = get(handles.edit_failu_filtras1,'String');
        flt_slct = get(handles.edit_failu_filtras2,'String');
        files_sh = get(handles.listbox1,'String');
        files_sN = get(handles.listbox1,'Value');
        if ~isempty(files_sN) && ~isequal(files_sN,0);
            files_sl = files_sh(files_sN);
        else
            files_sl = {''};
        end;
        ar_filtr = strcmp(get(handles.edit_failu_filtras2,'Style'),'edit');
        darbeliu_param={ 'pathin',pathin, 'pathout',pathout ,'flt_show',flt_show };
end;
if ar_filtr;
    darbeliu_param=[darbeliu_param {'flt_slct',flt_slct} varargin{:}]; %#ok
else
    darbeliu_param=[darbeliu_param {'files',files_sl} varargin{:}]; %#ok
end;
eval([ naujas_darbas '(darbeliu_param{:}); ']);


function drb_meniu_apie(hObject, eventdata, handles, darbas, varargin) %#ok
%% Apie
OS=fastif(ispc, 'Windows', fastif(isunix, fastif(ismac, 'MAC', 'Linux'), ''));
lc=char(java.util.Locale.getDefault());
lt=strcmp(lc,'lt_LT');
if lt; url1='https://github.com/embar-/eeglab_darbeliai/wiki/0.%20LT';
else   url1='https://github.com/embar-/eeglab_darbeliai/wiki/0.%20EN';
end;

pagr_katalog=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
konfig_rinkm=fullfile(Tikras_Kelias(fullfile(pagr_katalog,'..')),'Darbeliai_config.mat');

switch darbas
    case {'pop_pervadinimas'}
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.2.%20Pervadinimas,%20informacija';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.2.%20Renaming%20datasets';
        end;
    case {'pop_nuoseklus_apdorojimas'}
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.3.%20Nuoseklus%20apdorojimas';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.3.%20Serial%20processing';
        end;
    case {'pop_QRS_i_EEG'}
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.1.%20Bendryb%C4%97s';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.1.%20Common%20behaviour';
        end;
    case {'pop_Epochavimas_ir_atrinkimas'}
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.4.%20Sud%C4%97tingesnis%20epochavimas';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.4.%20Complex%20epoching';
        end;
    case {'pop_ERP_savybes'}
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.5.%20S%C4%AESP%20savyb%C4%97s%20ir%20eksportas';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.5.%20ERP%20properties%20and%20export';
        end;
    case {'pop_eeg_spektrine_galia'}
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.6.%20Spektrin%C4%97%20galia';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.6.%20Spectral%20power';
        end;
    case {'pop_rankinis'}
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.7.%20Savos%20komandos%20vykdymas';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.7.%20Custom%20command';
        end;
    case {'pop_meta_drb'}
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.8.%20Darb%C5%B3%20tvarkytuv%C4%97';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.8.%20Workflow%20Master';
        end;
    otherwise
        if lt; url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.1.%20Bendryb%C4%97s';
        else   url2='https://github.com/embar-/eeglab_darbeliai/wiki/3.1.%20Common%20behaviour';
        end;
end;

handles.meniu_apie = uimenu(handles.figure1,'Label',lokaliz('Pagalba'));
uimenu( handles.meniu_apie, 'Accelerator','H', 'Label', [lokaliz('Apie dialogo langa') ' ' lokaliz('(internete)')], ...
    'callback', [ 'web(''' url2 ''',''-browser'') ;' ]  );
uimenu( handles.meniu_apie, 'Label', [lokaliz('Zinynas') ' ' lokaliz('(internete)') ], ...
    'callback', [ 'web(''' url1 ''',''-browser'') ;' ]  );
uimenu( handles.meniu_apie, 'separator','on', 'Label', [lokaliz('Pranesti apie klaida') ' ' lokaliz('(internete)') ], ...
    'callback',   'web(''https://github.com/embar-/eeglab_darbeliai/issues/new'',''-browser'') ;'   );
uimenu( handles.meniu_apie, 'Label', [lokaliz('Pranesti apie klaida') ' ' lokaliz('(el. pastu)') ], ...
    'callback', [ 'web(''mailto:' [104 101 118 102 105 112 109 101 109 68 104 101 118 114 109 105 110 109 122 109 114 107 109 101 109 50 112 120] - 4 ...
    '?Subject=' Darbeliu_versija ...
    '&body=%0A%0AInfo:%0A----%0A' darbas '%0A' Darbeliu_versija  '%0A' ...
    'EEGLAB: ' eeg_getversion '%0A' 'MATLAB: ' version '%0A' OS '%0A' ...
     lc ' ' feature('DefaultCharacterSet') '%0A%0A' lokaliz('Iterpkite:') '%0A' ...
    fastif( exist(konfig_rinkm, 'file' ) == 2, ['<' konfig_rinkm '>%0A' ], '') '%0A' ...
    lokaliz('MATLAB output messages') ' (' lokaliz('Command window') '): %0A%0A%0A%0A%0A'') ;' ]  );
if exist('atnaujinimas.m','file') == 2;
    uimenu( handles.meniu_apie, 'Label', lokaliz('Check for updates'), ...
        'Callback', 'pop_atnaujinimas ;'  );    
end;
uimenu( handles.meniu_apie, 'separator','on', 'Label', lokaliz('Apie'), ...
    'callback', @apie_darbelius );


function drb_meniu_parinktys(hObject, eventdata, handles, darbas, varargin) %#ok
%% Parinktys
yra_isimintu_rinkiniu=0;
handles.meniu_nuostatos = uimenu(handles.figure1,'Label',lokaliz('Options'),'Tag','m_Nuostatos');
handles.meniu_nuostatos_ikelti = uimenu(handles.meniu_nuostatos,'Label',lokaliz('Ikelti'));
uimenu(handles.meniu_nuostatos_ikelti,'Label',lokaliz('Numatytas'),'Accelerator','R','Callback', {@nukreipimas_gui1, handles, 'drb_parinktys', 'ikelti',darbas,'numatytas'});
try
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    par_pav={ saranka.vardas };
    if ismember('paskutinis',par_pav);
        uimenu(handles.meniu_nuostatos_ikelti,'Label',lokaliz('Paskiausias'),'Separator','off',...
            'Accelerator','0','Callback',{@nukreipimas_gui1, handles, 'drb_parinktys', 'ikelti',darbas,'paskutinis'});
    end;
    ids=find(~ismember(par_pav,{'numatytas','paskutinis'}));
    par_pav=par_pav(ids);
    par_dat={ saranka.data };       par_dat=par_dat(ids);
    par_kom={ saranka.komentaras }; par_kom=par_kom(ids);
    if ~isempty(par_pav); yra_isimintu_rinkiniu=1 ; end;
    par_gr_=arrayfun(@(i) textscan(par_pav{i}, '%s', 'Delimiter', '|'), 1:length(par_pav));
    par_gr=drb_meniu_parinktys_strukturos_vizija([],par_gr_,par_pav,par_dat,par_kom);
    %assignin('base','par_gr',par_gr)
    drb_meniu_parinktys_strukturos_kurimas([], [], handles, darbas, par_gr,handles.meniu_nuostatos_ikelti,1);
catch %err; Pranesk_apie_klaida(err, darbas, '-', 0);
end;
%handles.meniu_nuostatos_irasyti = uimenu(handles.meniu_nuostatos,'Label','Įrašyti');
%uimenu(handles.meniu_nuostatos_irasyti,'Label','Kaip paskutines','Callback',{@parinktis_irasyti,handles,'paskutinis',''});
uimenu(handles.meniu_nuostatos,'Label',lokaliz('Saugoti...'),...
    'Accelerator','S','Callback',{@nukreipimas_gui2, handles, darbas, 'parinktis_irasyti'});
uimenu(handles.meniu_nuostatos,'Label',lokaliz('Trinti...'),...
    'Enable',fastif(yra_isimintu_rinkiniu==1,'on','off'),'Callback',{@nukreipimas_gui1, handles, 'drb_parinktys','trinti', darbas});
uimenu(handles.meniu_nuostatos,'Accelerator','I', 'Label',lokaliz('Importuoti...'),...
    'Callback',{@nukreipimas_gui1, handles, 'drb_parinktys','importuoti', darbas});
uimenu(handles.meniu_nuostatos,'Accelerator','E', 'Label',lokaliz('Eksportuoti...'),...
    'Callback',{@nukreipimas_gui1, handles, 'drb_parinktys','eksportuoti', darbas});
uimenu(handles.meniu_nuostatos, 'Label', [lokaliz('Nuostatos') ' (kalba/language)'], ...
        'separator','on', 'callback', 'konfig; '  );

function par_gr=drb_meniu_parinktys_strukturos_vizija(par_gr,par_gr_,par_pav,par_dat,par_kom)
try
    if isempty(par_gr)
        par_gr.grupes=struct('vrd',{},'medis',{});
        par_gr.pavieniai=struct('vrd',{},'pav',{},'dat',{},'kom',{});
    end
    for i=1:length(par_gr_)
        L=length(par_gr_{i});
        if L > 0
            P=par_gr_{i}{1};
            if L == 1
                par_gr.pavieniai(end+1).vrd=P;
                par_gr.pavieniai(end).pav=par_pav{i};
                par_gr.pavieniai(end).dat=par_dat{i};
                par_gr.pavieniai(end).kom=par_kom{i};
            else
                N=find(ismember({par_gr.grupes.vrd},{P}));
                if isempty(N)
                    par_gr.grupes(end+1).vrd=P;
                    par_gr.grupes(end).medis=drb_meniu_parinktys_strukturos_vizija([],{par_gr_{i}(2:end)},par_pav(i),par_dat(i),par_kom(i));
                else
                    par_gr.grupes(N).medis=drb_meniu_parinktys_strukturos_vizija(par_gr.grupes(N).medis,{par_gr_{i}(2:end)},par_pav(i),par_dat(i),par_kom(i));
                end;
            end;
        end;
    end;
catch
end;

function drb_meniu_parinktys_strukturos_kurimas(~, ~, handles, darbas, par_gr,meniu_nuostatos_ikelimo_grupe,lygis)
    pavieniu_N=length(par_gr.pavieniai);
    grupiu_N=length(par_gr.grupes);
    if (pavieniu_N + grupiu_N) > 20
        meniu_nuostatos_ikelimo_grupe_kita1=...
                uimenu(meniu_nuostatos_ikelimo_grupe,'Label','- - >', 'Separator', 'on');
        par_gr_kita.grupes=par_gr.grupes(21:end);
        par_gr_kita.pavieniai=par_gr.pavieniai(max(1,21-grupiu_N):end);
        par_gr.grupes(21:end)=[];
        par_gr.pavieniai(max(1,21-grupiu_N):end)=[];
        drb_meniu_parinktys_strukturos_kurimas([],[], handles, darbas, par_gr_kita,meniu_nuostatos_ikelimo_grupe_kita1,lygis+1);
    end;
    for i=1:length(par_gr.grupes);
        if i == 1
            Separator='on';
        else
            Separator='off';
        end;
        meniu_nuostatos_ikelimo_grupe_kita2=...
                uimenu(meniu_nuostatos_ikelimo_grupe,'Label',par_gr.grupes(i).vrd, 'Separator', Separator);
        drb_meniu_parinktys_strukturos_kurimas([],[], handles, darbas, par_gr.grupes(i).medis,meniu_nuostatos_ikelimo_grupe_kita2,lygis+1);
    end;
    for i=1:length(par_gr.pavieniai);
        if i == 1
            Separator='on';
        else
            Separator='off';
        end;
        if (lygis==1) && i<10
            Accelerator=num2str(i);
        else
            Accelerator='';
        end;
        try uimenu(meniu_nuostatos_ikelimo_grupe,...
            'Label', ['<html><font size="-2" color="#ADD8E6">' par_gr.pavieniai(i).dat '</font> ' ...
            par_gr.pavieniai(i).vrd ' <br><font size="-2" color="#ADD8E6">' par_gr.pavieniai(i).kom '</font></html>'],...
            'Separator',Separator, 'Accelerator',Accelerator,...
            'Callback',{@nukreipimas_gui1, handles, 'drb_parinktys', 'ikelti',darbas,par_gr.pavieniai(i).pav});
        catch err0;
            Pranesk_apie_klaida(err0, darbas, '-', 0);
        end;
    end;

function nukreipimas_gui1(hObject, eventdata, handles, varargin) %#ok
pars='';
for i=5:nargin;
    j=num2str(i-3);
    eval([ 'par' j '=varargin{' j '};' ]);
    pars=[pars ', par' j ]; %#ok
end;
com=[ varargin{1} '(hObject, eventdata, handles' pars ');' ];
try eval( com );
catch err; Pranesk_apie_klaida(err, '', '', 0) ;
end;


function nukreipimas_gui2(hObject, eventdata, handles, varargin) %#ok
pars='';
for i=5:nargin;
    j=num2str(i-3);
    eval([ 'par' j '=varargin{' j '};' ]);
    pars=[pars 'par' j ', ' ]; %#ok
end;
com=[ varargin{1} '(' pars 'hObject, eventdata, handles);' ];
try eval( com );
catch err; Pranesk_apie_klaida(err, '', '', 0) ;
end;


function nukreipimas_gui3(hObject, eventdata, handles, varargin) %#ok
pars='';
for i=6:nargin;
    j=num2str(i-3);
    eval([ 'par' j '=varargin{' j '};' ]);
    pars=[pars ', par' j ]; %#ok
end;
com=[ varargin{1} '(''' varargin{2} ''' , hObject, eventdata, handles' pars ');' ];
try eval( com );
catch err; Pranesk_apie_klaida(err, '', '', 0) ;
end;


function drb_meniu_veiksmai_vykdymas_su_perziura(hObject, eventdata, handles, darbas, varargin)
if nargin > 3; veiksena=varargin{1};
else           veiksena=0;
end;
setappdata(handles.figure1,'TIK_PERZIURA',veiksena);
nukreipimas_gui2(hObject, eventdata, handles, darbas, 'pushbutton1_Callback');
setappdata(handles.figure1,'TIK_PERZIURA',[]);


function drb_meniu_veiksmai(hObject, eventdata, handles, darbas, varargin) %#ok
%% Veiksmų meniu
handles.meniu_veiksmai = uimenu(handles.figure1,'Label',lokaliz('Veiksmai'),'Tag','m_Veiksmai');


uimenu(handles.meniu_veiksmai,'Label',lokaliz('Execute'),...
    'Accelerator','T','Callback',{@nukreipimas_gui2, handles, darbas, 'pushbutton1_Callback'});
if ismember(darbas, {'pop_nuoseklus_apdorojimas' 'pop_rankinis'})
uimenu(handles.meniu_veiksmai,'Label',lokaliz('Vykdyti ir palyginti'),...
    'Accelerator','D','Callback',{@nukreipimas_gui1, handles, 'drb_meniu_veiksmai_vykdymas_su_perziura', darbas, 0});
uimenu(handles.meniu_veiksmai,'Label',lokaliz('Vykdyti nesaugant ir palyginti'),...
    'Accelerator','W','Callback',{@nukreipimas_gui1, handles, 'drb_meniu_veiksmai_vykdymas_su_perziura', darbas, 1});
end;

handles.meniu_veiksmai_pasirinkti_pagal = uimenu(handles.meniu_veiksmai, 'separator','on',...
    'Label', [lokaliz('Pasirinkti rinkmenas pagal') '...']);
uimenu(handles.meniu_veiksmai_pasirinkti_pagal, 'Label', lokaliz('(pagal) tiriamaji'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_pagal, handles, 'subject'});
uimenu(handles.meniu_veiksmai_pasirinkti_pagal, 'Label', lokaliz('(pagal) grupe'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_pagal, handles, 'group'});
uimenu(handles.meniu_veiksmai_pasirinkti_pagal, 'Label', lokaliz('(pagal) salyga'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_pagal, handles, 'condition'});
uimenu(handles.meniu_veiksmai_pasirinkti_pagal, 'Label', lokaliz('(pagal) sesija'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_pagal, handles, 'session'});
uimenu(handles.meniu_veiksmai_pasirinkti_pagal, 'Label', lokaliz('(pagal) kanalu N'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_pagal, handles, 'nbchan'});
uimenu(handles.meniu_veiksmai_pasirinkti_pagal, 'Label', lokaliz('(pagal) epochu N'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_pagal, handles, 'trials'});
uimenu(handles.meniu_veiksmai_pasirinkti_pagal, 'Label', lokaliz('(pagal) laika nuo'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_pagal, handles, 'xmin'});
uimenu(handles.meniu_veiksmai_pasirinkti_pagal, 'Label', lokaliz('(pagal) laika iki'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_pagal, handles, 'xmax'});
uimenu(handles.meniu_veiksmai, 'Label', lokaliz('Invertuoti irasu pasirinkima'), ...
    'callback', {@drb_meniu_veiksmai_pasirinkimas_invertuotas, handles});

uimenu(handles.meniu_veiksmai, 'Accelerator','O', 'separator','on', 'Label', lokaliz('Vizualizuoti duomenis'), ...
    'callback', {@nukreipimas_i_kita_darba, handles, darbas, 'eeg_ikelk_i_eeglab', ...
    'reikia_EEGLAB', 0, 'siulomas_kiekis', 1, 'command', 'pop_eeg_perziura(EEG(end), ''zymeti'', 0, ''tik_prasmingas'', 1);' });
uimenu(handles.meniu_veiksmai, 'Accelerator','K', 'Label', lokaliz('Palyginti duomenis 2'), ...
    'callback', {@nukreipimas_i_kita_darba, handles, darbas, 'eeg_ikelk_i_eeglab', ...
    'reikia_EEGLAB', 0, 'siulomas_kiekis', 2, 'command', ...
    'if length(ALLEEG) > 1; pop_eeg_perziura(ALLEEG(end),ALLEEG(end-1), ''zymeti'', 0); end; ' });
%uimenu( handles.meniu_veiksmai, 'Label', lokaliz('Palyginti katalogus'), 'tag','pop_eeg_perziura2', ...
%        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas, 'pop_eeg_perziura', 'narsyti', 2});

if ~ismember(darbas, {'pop_pervadinimas'})
handles.meniu_veiksmai_fltr_rod=uimenu(handles.meniu_veiksmai, 'separator','on', 'Label', lokaliz('Rodyti rinkmenas is'));
uimenu(handles.meniu_veiksmai_fltr_rod, 'Accelerator','Y', 'Label', lokaliz('katalogo virs'), ...
    'callback', {@nukreipimas_gui1, handles, 'drb_meniu_veiksmai_fltr_rod', darbas, '..'}  );
uimenu(handles.meniu_veiksmai_fltr_rod, 'Accelerator','G', 'Label', lokaliz('katalogu lygiagreciai'), ...
    'callback', {@nukreipimas_gui1, handles, 'drb_meniu_veiksmai_fltr_rod', darbas, ['..' filesep '*']});
uimenu(handles.meniu_veiksmai_fltr_rod, 'Accelerator','B', 'Label', lokaliz('katalogu po'), ...
    'callback', {@nukreipimas_gui1, handles, 'drb_meniu_veiksmai_fltr_rod', darbas, '*'}  );
end;

if ismember(darbas, {'pop_ERP_savybes'})
uimenu(handles.meniu_veiksmai, 'separator','on', 'Label', lokaliz('Saugoti grafikus pagal kanalus'),...
    'Callback',{@nukreipimas_gui2, handles, darbas, 'spausdinimas_pagal_kanalus'});
uimenu(handles.meniu_veiksmai, 'separator','off', 'Label', lokaliz('Saugoti grafikus pagal tiriamuosius'),...
    'Callback',{@nukreipimas_gui2, handles, darbas, 'spausdinimas_pagal_tiriamuosius'});
end;

handles.meniu_veiksmai_eeglab=uimenu(handles.meniu_veiksmai, 'separator','on', 'Label', lokaliz('EEGLABeje'));
uimenu(handles.meniu_veiksmai_eeglab, 'Accelerator','L', 'Label', lokaliz('Ikelti'), ...
    'callback', {@nukreipimas_i_kita_darba, handles, darbas, 'eeg_ikelk_i_eeglab'}  );
if exist('eegplot_w','file')
  uimenu(handles.meniu_veiksmai_eeglab, 'Label', lokaliz('Vizualizuoti duomenis'), ...
    'callback', {@nukreipimas_i_kita_darba, handles, darbas, 'eeg_ikelk_i_eeglab', ...
    'reikia_EEGLAB', 0, 'siulomas_kiekis', 1, 'command', ...
    'eegplot( EEG(end).data, ''srate'', EEG(end).srate, ''eloc_file'', EEG(end).chanlocs, ''events'', EEG.event, ''title'', EEG(end).setname, ''submean'',''on''); ' });
  uimenu(handles.meniu_veiksmai_eeglab, 'Accelerator','P', 'Label', [ lokaliz('Vizualizuoti duomenis') ' +'], ...
    'callback', {@nukreipimas_i_kita_darba, handles, darbas, 'eeg_ikelk_i_eeglab', ...
    'reikia_EEGLAB', 0, 'siulomas_kiekis', 1, 'command', ...
    'eegplot_w( EEG(end).data, ''srate'', EEG(end).srate, ''eloc_file'', EEG(end).chanlocs, ''events'', EEG.event, ''title'', EEG(end).setname, ''submean'',''on''); ' });
else
  uimenu(handles.meniu_veiksmai_eeglab, 'Accelerator','P', 'Label', lokaliz('Vizualizuoti duomenis'), ...
    'callback', {@nukreipimas_i_kita_darba, handles, darbas, 'eeg_ikelk_i_eeglab', ...
    'reikia_EEGLAB', 0, 'siulomas_kiekis', 1, 'command', ...
    'eegplot( EEG(end).data, ''srate'', EEG(end).srate, ''eloc_file'', EEG(end).chanlocs, ''events'', EEG.event, ''title'', EEG(end).setname, ''submean'',''on''); ' });
end;
lcm=strrep(lokaliz('Custom command'),'.','');
uimenu(handles.meniu_veiksmai_eeglab, 'separator','on', 'Label', lcm, ...
    'callback', {@nukreipimas_i_kita_darba, handles, darbas, 'eeg_ikelk_i_eeglab', 'reikia_EEGLAB', 0, 'command', ...
    ['if isempty(SAVITA_KOMANDA); a=inputdlg(''' lcm ''',''' lcm ''',3, { ''disp(EEG)'' }); ' ...
    ' if iscell(a); a=a{1}; end;  SAVITA_KOMANDA=''''; for i=1:size(a,1); SAVITA_KOMANDA=[SAVITA_KOMANDA sprintf(''%s\n'',a(i,:))]; end; ' ...
    ' disp('' ''); disp([''' lcm '='' ]); disp('' ''); disp(SAVITA_KOMANDA); end; '...
    ' eval(SAVITA_KOMANDA)' ] });
% eegplot( EEG.data, 'srate', EEG.srate, 'title', 'Black = ; red =', 'limits', [EEG.xmin EEG.xmax]*1000, 'data2', EEG2.data); 

handles.meniu_veiksmai_os=uimenu(handles.meniu_veiksmai, 'Label', lokaliz('Operacineje sistemoje'));
uimenu(handles.meniu_veiksmai_os, 'Accelerator','J', 'Label', lokaliz('Atverti ikelimo kataloga'), ...
    'callback', {@nukreipimas_gui1, handles, 'drb_meniu_veiksmai_atverti_aplanka_os', darbas, 'ivestis'}  );
uimenu(handles.meniu_veiksmai_os, 'Accelerator','U', 'Label', lokaliz('Atverti saugojimo kataloga'), ...
    'callback', {@nukreipimas_gui1, handles, 'drb_meniu_veiksmai_atverti_aplanka_os', darbas, 'isvestis'}  );


function drb_meniu_veiksmai_pasirinkimas_invertuotas(hObject, eventdata, handles)
if isfield(handles,'listbox1')
    saraso_vld=handles.listbox1;
elseif isfield(handles,'listbox_tikri')
    saraso_vld=handles.listbox_tikri;
else
    warning('Not implemented')
    return
end;
visi=get(saraso_vld,'String');
seni=get(saraso_vld,'Value');
nauji=setdiff(1:length(visi),seni);
set(saraso_vld,'Value',nauji);

function drb_meniu_veiksmai_pasirinkimas_pagal(hObject, eventdata, handles, grupes_tipas)
if isfield(handles,'listbox1')
    saraso_vld=handles.listbox1;
elseif isfield(handles,'listbox_tikri')
    saraso_vld=handles.listbox_tikri;
else
    warning('Not implemented')
    return
end;
if isfield(handles,'edit1')
    kelio_vld=handles.edit1;
elseif isfield(handles,'edit_tikri')
    kelio_vld=handles.edit_tikri;
else
    warning('Not implemented')
    return
end;
tinkami_tipai_raidiniai={'subject' 'group' 'condition' 'session'};
tinkami_tipai_skaitiniai={'nbchan' 'trials' 'srate' 'xmin' 'xmax'};
tinkami_tipai=[tinkami_tipai_raidiniai tinkami_tipai_skaitiniai];
if nargin < 4 || isempty(grupes_tipas) || ~ischar(grupes_tipas) || ~ismember(grupes_tipas, tinkami_tipai)
    tinkami_tipai_sarase=cellfun(@(x) ['EEG.' x], tinkami_tipai,'UniformOutput',false);
    tipo_n=listdlg(...
        'Name', lokaliz('Pasirinkite'), ...
        'PromptString', [lokaliz('Pasirinkti rinkmenas pagal') ':'], ... 
        'ListString', tinkami_tipai_sarase,...
        'SelectionMode', 'single',...
        'InitialValue', 2,...
        'OKString', lokaliz('OK'),...
        'CancelString', lokaliz('Cancel'));
    if isempty(tipo_n); return; end;
    grupes_tipas=tinkami_tipai{tipo_n};
end;
switch grupes_tipas
    case 'subject'
        tipo_galininkas = lokaliz('(pagal) tiriamaji');
    case 'group'
        tipo_galininkas = lokaliz('(pagal) grupe');
    case 'condition'
        tipo_galininkas = lokaliz('(pagal) salyga');
    case 'session'
        tipo_galininkas = lokaliz('(pagal) sesija');
    case 'nbchan'
        tipo_galininkas = lokaliz('(pagal) kanalu N');
    case 'trials'
        tipo_galininkas = lokaliz('(pagal) epochu N');
    case 'xmin'
        tipo_galininkas = lokaliz('(pagal) laika nuo');
    case 'xmax'
        tipo_galininkas = lokaliz('(pagal) laika iki');
    otherwise
        tipo_galininkas = '';
end
kelias=get(kelio_vld,'String');
visi=get(saraso_vld,'String');
if isempty(visi); return; end;
seni_id=get(saraso_vld,'Value');
if isempty(seni_id)
    ikeliami_id=1:length(visi);
else
    ikeliami_id=seni_id;
end
fprintf('Įkelsima EEG įrašų: %d/%d\n',length(ikeliami_id),length(visi));
ikeliami=visi(ikeliami_id);
tipas_yra_raidinis=ismember(grupes_tipas, tinkami_tipai_raidiniai);
if tipas_yra_raidinis
    grupes_duomenys={};
else
    grupes_duomenys=[];
end;
for i=1:length(ikeliami)
    EEGTMP=eeg_ikelk(kelias, ikeliami{i}, 'loadmode','info');
    nario_duomenys=eval(['EEGTMP.' grupes_tipas]);
    if isnumeric(nario_duomenys) && tipas_yra_raidinis
        nario_duomenys=num2str(nario_duomenys);
    end
    if tipas_yra_raidinis
        grupes_duomenys{i}=nario_duomenys;
    else
        grupes_duomenys(i)=nario_duomenys;
    end;
end;
unik_grupes=unique(grupes_duomenys);
% Nenaudoti raidinio nuo pat pradžių tam, kad rikiavimas neiškreiptų skaičių
if ~tipas_yra_raidinis
    fprintf('N=%d, M=%f, SD=%f\n', length(grupes_duomenys), mean(grupes_duomenys), std(grupes_duomenys))
    grupes_duomenys=arrayfun(@num2str, grupes_duomenys,'UniformOutput',false );
    unik_grupes=arrayfun(@num2str, unik_grupes,'UniformOutput',false );
end
unik_grupiu_N=length(unik_grupes);
%if unik_grupiu_N > 1
pasirinkti=listdlg(...
    'Name', lokaliz('Pasirinkite'), ...
    'PromptString', [lokaliz('Pasirinkti pagal') ' ' tipo_galininkas ':'], ... % paaiškinimas
    'ListString', unik_grupes,...
    'SelectionMode', 'multiple',...
    'InitialValue', 1:unik_grupiu_N,...
    'OKString', lokaliz('OK'),...
    'CancelString', lokaliz('Cancel'));
%else pasirinkti=1;
%end
if isempty(pasirinkti); return; end;
pasirinkti_ikeliamu_id=find(ismember(grupes_duomenys,unik_grupes(pasirinkti)));
nauji_id=ikeliami_id(pasirinkti_ikeliamu_id);
disp(['EEG.' grupes_tipas ' =' sprintf(' ''%s''', unik_grupes{pasirinkti}) '; N = ' num2str(length(nauji_id))])
%if unik_grupiu_N > 1
    disp(visi(nauji_id))
    set(saraso_vld,'Value',nauji_id);
%end

function drb_meniu_veiksmai_fltr_rod(hObject, eventdata, handles, darbas, fltr_tarp, varargin) %#ok
fltr_rod = get(handles.edit_failu_filtras1, 'String');
fltr_rod2=fltr_rod;
s=find(ismember(fltr_rod,filesep),1,'first');
if ~isempty(s); 
  if s>2 && length(fltr_rod) > 2*s-3;
    if strcmp(fltr_rod(s-1),'.') && strcmp(fltr_rod(s-2),';') && strcmp(fltr_rod(1:s-3),fltr_rod(end-s+4:end));
        fltr_rod2 = fltr_rod(1:s-3);
    end;
  end;
end;
fltr_rod = [fltr_rod ';.' filesep fltr_tarp filesep fltr_rod2 ];
fltr_rod=strrep(fltr_rod,';;',';');
set(handles.edit_failu_filtras1, 'String', fltr_rod);
nukreipimas_gui2(hObject, eventdata, handles, darbas, 'atnaujink_rodomus_failus');


function drb_meniu_veiksmai_atverti_aplanka_os(hObject, eventdata, handles, darbas, ivestis_ar_isvestis, varargin) %#ok
% Katalogą atverti operacinės sistemos failų naršyklėje
% http://stackoverflow.com/questions/16808965/how-to-open-a-directory-in-the-default-file-manager-from-matlab

if ismember(darbas, {'pop_pervadinimas'});
    pathin   = get(handles.edit_tikri,'String');
    pathout  = get(handles.edit_siulomi,'String');
else
    pathin   = get(handles.edit1,'String');
    pathout  = get(handles.edit2,'String');
end;
if ismember(ivestis_ar_isvestis, {'2' 'isvestis'});
    Dir=pathout;
else
    Dir=pathin;
end;

h=statusbar2015(lokaliz('Palaukite!'));
statusbar2015(0.5,h);

if ispc; % Windows PC
    evalc(['!explorer "' Dir '"']);
elseif isunix; % Unix or derivative
    if ismac; % Mac
        evalc(['!open "' Dir '"']);
    else % Linux
        fMs = {...
            'xdg-open'   % most generic one
            %'gvfs-open'  % successor of gnome-open
            %'gnome-open' % older gnome-based systems
            %'kde-open'   % older KDE systems
           };
        for ii=1:length(fMs);
            C = evalc(['! LD_LIBRARY_PATH=/usr/lib64:/usr/lib ' fMs{ii} ' "'  Dir '"' ]);
            if isempty(C); break; end;
        end;
    end;
else warning('Unrecognized operating system.');
end;
if ishandle(h); delete(h); end;


function apie_darbelius(varargin)
%% apie_darbelius - trumpa informacija apie Darbelius
if strcmp(char(java.util.Locale.getDefault()),'lt_LT');
    antr='Apie „Darbelius“';
else
    antr=[lokaliz('Apie') ' Darbeliai'];
end;

msg={Darbeliu_versija 
    ' ' 
    '(c) 2014-2019 Mindaugas Baranauskas'
    [ '' [104 101 118 102 105 112 109 101 109 68 104 101 118 114 109 105 110 109 122 109 114 107 109 101 109 50 112 120] - 4 ] };

% % Ženkliukas
% try
%     h=msgbox(' ', antr);
%     [ic,map]=imread(... %fullfile(matlabroot, 'toolbox', 'matlab', 'icons', 'csh_icon.png'),...
%         fullfile(matlabroot, 'toolbox', 'shared', 'controllib', 'general', 'resources', 'toolstrip_icons', 'Help_24.png'),...
%         'BackgroundColor',get(h,'Color'));
%     ic={'custom',ic,map};
% catch
%    ic={'help'};
%end;

s.Interpreter='none';
s.WindowStyle='replace';
%msgbox(msg, antr, ic{:}, s);
msgbox(msg, antr, s);


