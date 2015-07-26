function drb_meniu(hObject, eventdata, handles, varargin)
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

if nargin > 3; meniu=varargin{1};
else           meniu='visas';
end;
if nargin > 4; darbas=varargin{2};
else           darbas='';
end;

switch lower(meniu)
    case {'darbeliai'}
        drb_meniu_darbeliai(hObject, eventdata, handles, darbas, varargin(3:end));
    case {'parinktys'}
        drb_meniu_parinktys(hObject, eventdata, handles, darbas, varargin(3:end));
    case {'apie'}
        drb_meniu_apie(     hObject, eventdata, handles, darbas, varargin(3:end));
    case {'visas'}
        drb_meniu_darbeliai(hObject, eventdata, handles, darbas, varargin(3:end));
        drb_meniu_parinktys(hObject, eventdata, handles, darbas, varargin(3:end));
        drb_meniu_apie(     hObject, eventdata, handles, darbas, varargin(3:end));
end

function drb_meniu_darbeliai(hObject, eventdata, handles, darbas, varargin) %#ok
%% Darbeliai
delete(findall(handles.figure1,'type','uimenu'));
handles.meniu_darbeliai = uimenu(handles.figure1,'Label','Darbeliai','Tag','m_Darbeliai');

uimenu( handles.meniu_darbeliai, 'Label', lokaliz('Pervadinimas su info suvedimu'),  'tag','pop_pervadinimas', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_pervadinimas'});
uimenu( handles.meniu_darbeliai, 'Label', lokaliz('Nuoseklus apdorojimas'),          'tag','pop_nuoseklus_apdorojimas', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_nuoseklus_apdorojimas'});
uimenu( handles.meniu_darbeliai, 'Label', lokaliz('EEG + EKG'),                      'tag','pop_QRS_i_EEG', ...
        'Separator','off', 'Callback', {@nukreipimas_i_kita_darba, handles, darbas,        'pop_QRS_i_EEG'});
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


function nukreipimas_i_kita_darba(hObject, eventdata, handles, aktyvus_darbas, naujas_darbas) %#ok
%%
switch aktyvus_darbas
    case {'pop_pervadinimas'}
        pathin   = get(handles.edit_tikri,'String');
        pathout  = get(handles.edit_siulomi,'String');
       %flt_show = get(handles.edit_failu_filtras1,'String');
        flt_slct = get(handles.edit_filtras,'String');
        files_sh = get(handles.text_tikri,'String');
        files_sN = get(handles.text_tikri,'Value');
        if ~isempty(files_sN) && ~isequal(files_sN,0);
            files_sl = files_sh(files_sN);
            ar_filtr = strcmp(get(handles.edit_filtras,'Style'),'edit');
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
        files_sl = files_sh(files_sN);
        if ~isempty(files_sN) && ~isequal(files_sN,0);
            files_sl = files_sh(files_sN);
            ar_filtr = strcmp(get(handles.edit_failu_filtras2,'Style'),'edit');
        else
            ar_filtr = 1;
        end;
        darbeliu_param={ 'pathin',pathin, 'pathout',pathout ,'flt_show',flt_show };
end;
if ar_filtr;
    darbeliu_param=[darbeliu_param {'flt_slct',flt_slct}]; %#ok
else
    darbeliu_param=[darbeliu_param {'files',files_sl}]; %#ok
end;
eval([ naujas_darbas '(darbeliu_param{:}); ']);


function drb_meniu_apie(hObject, eventdata, handles, darbas, varargin) %#ok
%% Apie
lt=strcmp(char(java.util.Locale.getDefault()),'lt_LT');
if lt; url1='https://github.com/embar-/eeglab_darbeliai/wiki/0.%20LT';
else   url1='https://github.com/embar-/eeglab_darbeliai/wiki/0.%20EN';
end;
    
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
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
vers='Darbeliai';
try
    fid_vers=fopen(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai.versija'));
    vers=regexprep(regexprep(fgets(fid_vers),'[ ]*\n',''),'[ ]*\r','');
    fclose(fid_vers); 
catch
end;

handles.meniu_apie = uimenu(handles.figure1,'Label',lokaliz('Pagalba'));
uimenu( handles.meniu_apie, 'Accelerator','H', 'Label', lokaliz('Apie dialogo langa'), ...
    'callback', [ 'web(''' url2 ''',''-browser'') ;' ]  );
uimenu( handles.meniu_apie, 'Label', [lokaliz('Apie') ' ' vers], ...
    'callback', [ 'web(''' url1 ''',''-browser'') ;' ]  );
if exist('atnaujinimas','file') == 2;
    uimenu( handles.meniu_apie, 'Label', lokaliz('Check for updates'), 'separator','on', ...
        'Callback', 'pop_atnaujinimas ;'  );    
end;


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
    for i=1:length(par_pav);
        try
        uimenu(handles.meniu_nuostatos_ikelti,...
            'Label', ['<html><font size="-2" color="#ADD8E6">' par_dat{i} '</font> ' ...
            par_pav{i} ' <br><font size="-2" color="#ADD8E6">' par_kom{i} '</font></html>'],...
            'Separator',fastif(i==1,'on','off'),...
            'Accelerator',fastif(i<10, num2str(i), ''),...
            'Callback',{@nukreipimas_gui1, handles, 'drb_parinktys', 'ikelti',darbas,par_pav{i}});
        catch err0;
            Pranesk_apie_klaida(err0, 'pop_pervadinimas.m', '-', 0);
        end;
    end;
catch err; Pranesk_apie_klaida(err, 'pop_QRS_i_EEG.m', '-', 0);
end;
%handles.meniu_nuostatos_irasyti = uimenu(handles.meniu_nuostatos,'Label','Įrašyti');
%uimenu(handles.meniu_nuostatos_irasyti,'Label','Kaip paskutines','Callback',{@parinktis_irasyti,handles,'paskutinis',''});
uimenu(handles.meniu_nuostatos,'Label',lokaliz('Saugoti...'),...
    'Accelerator','S','Callback',{@nukreipimas_gui2, handles, darbas, 'parinktis_irasyti'});
uimenu(handles.meniu_nuostatos,'Label',lokaliz('Trinti...'),...
    'Enable',fastif(yra_isimintu_rinkiniu==1,'on','off'),'Callback',{@nukreipimas_gui1, handles, 'drb_parinktys','trinti', darbas});
uimenu(handles.meniu_nuostatos,'Label',lokaliz('Eksportuoti...'),...
    'Callback',{@nukreipimas_gui1, handles, 'drb_parinktys','eksportuoti', darbas});
uimenu(handles.meniu_nuostatos, 'Label', [lokaliz('Nuostatos') ' (kalba/language)'], ...
        'separator','on', 'callback', 'konfig; '  );


function nukreipimas_gui1(hObject, eventdata, handles, varargin) %#ok
pars='';
for i=5:nargin;
    j=num2str(i-3);
    eval([ 'par' j '=varargin{' j '};' ]);
    pars=[pars ', par' j ]; %#ok
end;
com=[ varargin{1} '(hObject, eventdata, handles' pars ');' ];
eval( com );


function nukreipimas_gui2(hObject, eventdata, handles, varargin) %#ok
pars='';
for i=5:nargin;
    j=num2str(i-3);
    eval([ 'par' j '=varargin{' j '};' ]);
    pars=[pars 'par' j ', ' ]; %#ok
end;
com=[ varargin{1} '(' pars 'hObject, eventdata, handles);' ];
eval( com );

