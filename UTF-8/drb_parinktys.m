function drb_parinktys(hObject, eventdata, handles, veiksmas, darbas, varargin)
% drb_parinktys - „Darbelių“ langų parinkčių valdymas
%
% drb_parinktys(hObject, eventdata, handles, 'ikelti',  darbas)
% drb_parinktys(hObject, eventdata, handles, 'trinti',  darbas)
% drb_parinktys(hObject, eventdata, handles, 'irasyti', darbas)
% drb_parinktys(hObject, eventdata, handles, 'importuoti',  darbas)
% drb_parinktys(hObject, eventdata, handles, 'eksportuoti', darbas)
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

if nargin > 5; rinkinys=varargin{1};
else           rinkinys='paskutinis';
end;

pagr_katalog=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
konfig_rinkm=fullfile(Tikras_Kelias(fullfile(pagr_katalog,'..')),'Darbeliai_config.mat');

switch lower(veiksmas)
    case {'ikelti'}
        drb_parinktis_ikelti(hObject, eventdata, handles, konfig_rinkm, darbas, rinkinys, varargin{2:end});
    case {'trinti'}
        drb_parinktis_trinti(hObject, eventdata, handles, konfig_rinkm, darbas, varargin{:});
    case {'irasyti'}
        drb_parinktis_irasyti(hObject, eventdata, handles, konfig_rinkm, darbas, rinkinys, varargin{2:end});
    case {'importuoti'}
        drb_parinktis_importuoti(hObject, eventdata, handles, konfig_rinkm, darbas, varargin);
    case {'eksportuoti'}
        drb_parinktis_eksportuoti(hObject, eventdata, handles, konfig_rinkm, darbas, varargin);
end;


function drb_parinktis_ikelti(hObject, eventdata, handles, konfig_rinkm, darbas, rinkinys, varargin) %#ok
%% Įkelti
versija_par='';
versija_plg='';
try
    load(konfig_rinkm);   
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    esami={saranka.vardas}; 
    i=find(ismember(esami,rinkinys));
    if isempty(i); error([lokaliz('Neradome parinkciu rinkinio') ': ' rinkinys ]); end;
    Parinktys=saranka(i).parinktys;
    try versija_par=saranka(i).versija; catch; end;
    Laukai1=fieldnames(Parinktys);
    Laukai2=unique(regexprep(setdiff(Laukai1,{'id'}),'_$',''));
catch err; Pranesk_apie_klaida(err, darbas, konfig_rinkm, 1);
    return;
end;
try eval([ darbas '(''susaldyk'',hObject, eventdata, handles);' ]) ; catch; end;
% Naujų reikšmių priskyrimas
for j=1:length(Parinktys);
    for l=1:length(Laukai2);
        Laukas=Laukai2{l};
        try
            skirti=0;
            if ismember([Laukas '_'], Laukai1);
                try eval([ 'skirti=Parinktys(j).' Laukas '_;' ]); catch; end;
            elseif ismember(Laukas, {'Value' 'UserData'}); % suderinamumui su Darbeliais <= 2015.07.18
                skirti=1;
            end;
            if skirti;
                eval([ 'rksm=Parinktys(j).' Laukas ';' ]);
                set(eval(['handles.' Parinktys(j).id ]), Laukas, rksm);
            end;
        catch err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
            disp([ Parinktys(j).id ': ' Laukas ]);
        end;
    end;
end;
guidata(hObject, handles);
switch darbas
    case {'pop_pervadinimas'}
        try eval([ darbas '(''edit4_Callback'',hObject, eventdata, handles);' ]) ; catch; end;
        try eval([ darbas '(''checkbox2_Callback'',hObject, eventdata, handles);' ]) ; catch; end;
    case {'pop_nuoseklus_apdorojimas'}
        try eval([ darbas '(''popupmenu12_Callback'',hObject, eventdata, handles);' ]) ; catch; end;
        if ar_senesne_versija(versija_par,'Darbeliai v2015.10.05.3');
            try if get(handles.popupmenu8, 'Value') == 3 && length(get(handles.popupmenu8, 'String')) > 3 ;
                    set(handles.popupmenu8, 'Value', 4);
                end;
            catch err; Pranesk_apie_klaida(err,'','',0);
            end;
        end;
        if ar_senesne_versija(versija_par,'Darbeliai v2015.10.21.1');
            try set(handles.checkbox_atrink_kanalus2A, 'Value', 1);
            catch err; Pranesk_apie_klaida(err,'','',0);
            end;
        end;
    case {'pop_eeg_spektrine_galia'}
        try eval([ darbas '(''checkbox_perziura_Callback'',hObject, eventdata, handles);' ]) ; catch; end;
    case {'pop_ERP_savybes'}
        try eval([ darbas '(''ERP_perziura'',hObject, eventdata, handles);' ]) ; catch; end;
    case {'pop_meta_drb'}
        versija_plg='Darbeliai v2015.07.26';
end;
try eval([ darbas '(''susildyk'',hObject, eventdata, handles);' ]) ; 
catch err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
end;
if ar_senesne_versija(versija_par,versija_plg);
    warndlg({lokaliz('Senos parinktys:') rinkinys ' ' ...
        lokaliz('Patariame is naujo issaugoti ka tik ikeltas parinktis!')},...
        lokaliz('Galimai pasenusios parinktys'));
end;


function [senesne]=ar_senesne_versija(versija1,versija2)
% Ar versija1 < versija2
if isempty(versija2);
   senesne=0; return;
end;
if isempty(versija1);
   senesne=1; return;
end;
versija1=versija1(ismember(versija1,'1234567890.')); versija1=textscan(strrep(versija1,'.',' '),'%d','delimiter',' '); versija1=versija1{1};
versija2=versija2(ismember(versija2,'1234567890.')); versija2=textscan(strrep(versija2,'.',' '),'%d','delimiter',' '); versija2=versija2{1};
if isequal(versija1,versija2);
    senesne=0; return;
end;
for i=1:min(length(versija1),length(versija2));
    if     versija1(i) < versija2(i);
        senesne=1; return;
    elseif versija1(i) > versija2(i);
        senesne=0; return;
    end;
end;
if length(versija1) < length(versija2);
    senesne=1; return;
end;
senesne=0;


function drb_parinktis_trinti(hObject, eventdata, handles, konfig_rinkm, darbas, varargin)
%% Trinti
try
    load(konfig_rinkm);
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    esami={saranka.vardas}; %#ok
    esami_N=length(esami);
    esami_nr=find(~ismember(esami,{'numatytas','paskutinis'}));
    esami=esami(esami_nr);
    if isempty(esami); return; end;
catch %err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
    return;
end;
if nargin > 5; trintini_rinkiniai = varargin{1};
else           trintini_rinkiniai = '';
end;
if isempty(trintini_rinkiniai);
    pasirinkti=listdlg('ListString', esami,...
        'SelectionMode','multiple',...
        'PromptString', lokaliz('Trinti:'),...
        'InitialValue',length(esami),...
        'OKString',lokaliz('Trinti'),...
        'CancelString',lokaliz('Cancel'));
else
    pasirinkti=find(ismember(trintini_rinkiniai,esami));
end;
if isempty(pasirinkti); return; end;
saranka=saranka(setdiff([1:esami_N], esami_nr(pasirinkti))); %#ok
eval(['Darbeliai.dialogai.' darbas '.saranka=saranka ;']);

% Įrašymas
try   movefile([konfig_rinkm '~'], [konfig_rinkm '~~' ], 'f'); catch; end;
try   movefile(konfig_rinkm, [konfig_rinkm '~' ], 'f'); catch; end;
try   save(konfig_rinkm,'Darbeliai');
catch err; Pranesk_apie_klaida(err, darbas, konfig_rinkm, 0);
end;

% meniu
drb_meniu(hObject, eventdata, handles, 'visas', darbas);


function drb_parinktis_irasyti(hObject, eventdata, handles, konfig_rinkm, darbas, vardas, komentaras, isimintini)
%% Įrašyti
try load(konfig_rinkm);
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    esami={saranka.vardas}; %#ok
catch %err; Pranesk_apie_klaida(err, mfilename, konfig_rinkm, 0);
    saranka=struct; esami={};
end;
[vardas, komentaras, pavyko]=parinkciu_rinkinio_uzvadinimas(vardas, komentaras, darbas, saranka, [], ~isempty(vardas));
if ~pavyko; return; end;
if isempty(vardas);
    vardas='paskutinis';
    komentaras='';
end;

% Užduočių parinktys
Parinktys=struct('id','','Value_','','Value','','UserData_','','UserData','','String_','','String','',...
    'TooltipString_','','TooltipString','','Data_','','Data','','ColumnName_','','ColumnName','');
j=1;
for b=1:length(isimintini);
    isimintini_raktai=lower(isimintini(b).raktai);
    isimintini_nariai=isimintini(b).nariai;
    for i=1:length(isimintini_nariai);
        try
            Parinktys(j).id = isimintini_nariai{i} ; 
            
            if ismember({'value'}, isimintini_raktai);
                 Parinktys(j).Value_  = 1;
                 Parinktys(j).Value    = get(eval(['handles.' isimintini_nariai{i}]), 'Value');
            else Parinktys(j).Value_  = 0;
            end;
            if ismember({'userdata'}, isimintini_raktai);
                 Parinktys(j).UserData_  = 1;
                 Parinktys(j).UserData = get(eval(['handles.' isimintini_nariai{i}]), 'UserData');
            else Parinktys(j).UserData_  = 0;
            end;
            if ismember({'string'}, isimintini_raktai);
                 Parinktys(j).String_  = 1;
                 Parinktys(j).String   = get(eval(['handles.' isimintini_nariai{i}]), 'String');
            else Parinktys(j).String_  = 0;
            end;
            if ismember({'tooltipstring'}, isimintini_raktai);
                 Parinktys(j).TooltipString_ = 1;
                 Parinktys(j).TooltipString   = get(eval(['handles.' isimintini_nariai{i}]), 'TooltipString');
            else Parinktys(j).TooltipString_ = 0;
            end;
            if ismember({'data'}, isimintini_raktai);
                 Parinktys(j).Data_  = 1;
                 Parinktys(j).Data = get(eval(['handles.' isimintini_nariai{i}]), 'Data');
            else Parinktys(j).Data_  = 0;
            end;
            if ismember({'columnname'}, isimintini_raktai);
                 Parinktys(j).ColumnName_  = 1;
                 Parinktys(j).ColumnName = get(eval(['handles.' isimintini_nariai{i}]), 'ColumnName');
            else Parinktys(j).ColumnName_  = 0;
            end;
            
            j=j+1;
            
        catch err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
        end;
    end;
end;

try p=find(ismember(esami,vardas));
    if isempty(p);
        p=length(esami)+1; 
    else p=p(1);
    end;
catch
    p=1;
end;

% Darbelių versija
vers='Darbeliai';
try
    fid_vers=fopen(fullfile(fileparts(konfig_rinkm),'Darbeliai.versija'));
    vers=regexprep(regexprep(fgets(fid_vers),'[ ]*\n',''),'[ ]*\r','');
    fclose(fid_vers); 
catch
end;

saranka(p).vardas    = vardas ;
saranka(p).data      = datestr(now,'yyyy-mm-dd HH:MM:SS') ;
saranka(p).komentaras= [ komentaras ' ' ] ;
saranka(p).parinktys = Parinktys ;
saranka(p).versija   = vers ;
eval(['Darbeliai.dialogai.' darbas '.saranka=saranka; ']);

% Įrašymas
try   movefile([konfig_rinkm '~'], [konfig_rinkm '~~' ], 'f'); catch; end;
try   movefile(konfig_rinkm, [konfig_rinkm '~' ], 'f'); catch; end;
try   save(konfig_rinkm,'Darbeliai');
catch err; Pranesk_apie_klaida(err, darbas, konfig_rinkm, 0);
end;

% meniu
drb_meniu(hObject, eventdata, handles, 'visas', darbas);


function [vardas, komentaras, pavyko]=parinkciu_rinkinio_uzvadinimas(pradinis_vardas, pradinis_komentaras, darbas, saranka1, saranka2, neklausti)
%% Dialogas parinkčių rinkinio pavadinimui įvesti
% sąranka2 nurodoma eksportuojant kaip aptiktoji
vardas='';
komentaras='';
pavyko=0;
if isempty(saranka2);
    try draudziami_vardai=setdiff({saranka1.vardas}, {'numatytas','paskutinis'});
    catch
        draudziami_vardai={};
        saranka1=struct('vardas','','komentaras','','data','','versija',''); saranka1=saranka1([]);
    end;
else
    try draudziami_vardai=[{saranka2.vardas} {'' ' '}];
    catch
        draudziami_vardai={'' ' '};
        saranka2=struct('vardas','','komentaras','','data','','versija',''); saranka2=saranka2([]);
    end;
end;
if neklausti;
    a={pradinis_vardas pradinis_komentaras};
else
    a=inputdlg({lokaliz('Pavadinimas:'),lokaliz('Komentaras:')},lokaliz('Options'),1,...
        {pradinis_vardas pradinis_komentaras});
end;
if ~isempty(a) && iscell(a);
    if ismember(a{1},draudziami_vardai);
        klsm=sprintf('%s\n\n%s: %s\n\n', lokaliz('Parinkciu rinkinys jau yra!'), lokaliz('Darbas'), darbas);
        if isempty(saranka2);
            persidengia_i1=find(ismember({saranka1.vardas},a{1}));
            persidengia_i1=persidengia_i1(1);
            klsm=[klsm sprintf('%s\n%s\n%s', ...
                lokaliz('Aptiktos parinktys:'), saranka1(persidengia_i1).data, saranka1(persidengia_i1).vardas)];
            kom=saranka1(persidengia_i1).komentaras; if ~isempty(kom); klsm=[klsm sprintf('\n%s', kom)]; end;
        else
            persidengia_i1=find(ismember({saranka1.vardas},pradinis_vardas));
            persidengia_i2=find(ismember({saranka2.vardas},a{1}));
            persidengia_i2=persidengia_i2(1);
            if isempty(persidengia_i1);
              klsm=[klsm sprintf('%s\n%s\n%s', ...
                lokaliz('Aptiktos parinktys:'), saranka2(persidengia_i2).data, saranka2(persidengia_i2).vardas)];
              kom=saranka2(persidengia_i2).komentaras; if ~isempty(kom); klsm=[klsm sprintf('\n%s', kom)]; end;
            else
              persidengia_i1=persidengia_i1(1);
              klsm=[klsm sprintf('%s\n%s\n%s', ...
                lokaliz('Siulomos parinktys:'), saranka1(persidengia_i1).data, saranka1(persidengia_i1).vardas)];
              kom=saranka1(persidengia_i1).komentaras; if ~isempty(kom); klsm=[klsm sprintf('\n%s', kom)]; end;
              klsm=[klsm sprintf('\n\n%s\n%s\n%s', ...
                lokaliz('Aptiktos parinktys:'), saranka2(persidengia_i2).data, saranka2(persidengia_i2).vardas)];
              kom=saranka2(persidengia_i2).komentaras; if ~isempty(kom); klsm=[klsm sprintf('\n%s', kom)]; end;
            end;
        end;
        klsm=[klsm sprintf('\n\n%s', lokaliz('Perrasyti parinkciu rinkini?'))];
        mgtk={lokaliz('Yes'), lokaliz('Rename'), lokaliz('No'),lokaliz('Rename')};
        ats=questdlg(klsm, lokaliz('Parinkciu rinkinys jau yra!'), mgtk{:});
        switch ats
            case {lokaliz('Rename')}
                if isempty(saranka2);
                    [vardas, komentaras, pavyko]=parinkciu_rinkinio_uzvadinimas(a{1}, a{2}, darbas, saranka1, saranka2, 0);
                else
                    [vardas, komentaras, pavyko]=parinkciu_rinkinio_uzvadinimas(pradinis_vardas, pradinis_komentaras, darbas, saranka1, saranka2, 0);
                end;
            case {lokaliz('Yes')}
                vardas=a{1};
                komentaras=a{2};
                pavyko=2;
        end;
    else
        vardas=a{1};
        komentaras=a{2};
        pavyko=1;
    end;
end;


function drb_parinktis_eksportuoti(hObject, eventdata, handles, konfig_rinkm, darbas, varargin) 
%% Eksportuoti
try
g=struct(varargin{:}); % rinkiniai, eksp_rinkm, papildyti
catch %err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
end;

try
    load(konfig_rinkm,'-mat');
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    esami={saranka.vardas}; %#ok
    if isempty(esami{1}); error(lokaliz('(empty)')); end;
catch err; Pranesk_apie_klaida(err, mfilename, konfig_rinkm, 0);
    try error(lokaliz('Nera ko eksportuoti.')); 
    catch err; Pranesk_apie_klaida(err, mfilename, konfig_rinkm);
    end;
    return;
end;
pasirinkti=[];
try pasirinkti=find(ismember(esami,{g.rinkiniai})); catch; end;
if isempty(pasirinkti);
    pasirinkti=listdlg('ListString', lokalizuok_rinkinius(esami),...
        'SelectionMode','multiple',...
        'PromptString', lokaliz('Eksportuoti'),...
        'InitialValue',length(esami),...
        'OKString',lokaliz('Eksportuoti'),...
        'CancelString',lokaliz('Cancel'));
end;
if isempty(pasirinkti); return; end;
vardas=esami(pasirinkti);
saranka=saranka(pasirinkti);

eksp_rinkm='';
try eksp_rinkm=g.eksp_rinkm; catch; end;
if isempty(eksp_rinkm);
    [eksp_rinkm,eksp_kel]=uiputfile({'*.drbk';'*.mat'},lokaliz('Eksportuoti'),...
        [ 'Darbeliai (' darbas ')'  sprintf(' -- %s', vardas{:}) '.drbk' ]);
    if isempty(eksp_rinkm); return; end;
    if isequal(eksp_rinkm,0); return; end;
    eksp_rinkm=fullfile(eksp_kel,eksp_rinkm);
end;

Darbeliai=struct; %#ok

if exist(eksp_rinkm, 'file') == 2;
    klsm=sprintf('%s\n%s', lokaliz('Rinkmena jau yra!'), lokaliz('Pabandyti papildyti rinkmena?'));
    mgtk={lokaliz('Yes'), lokaliz('No'), lokaliz('Cancel'),lokaliz('Yes')};
    papildyti=[];
    try papildyti=g.papildyti; catch; end;
    if isempty(papildyti);
        ats=questdlg(klsm, lokaliz('Rinkmena jau yra!'), mgtk{:});
        switch ats
            case lokaliz('Yes')
                papildyti=1;
            case lokaliz('No')
                papildyti=0;
            otherwise
                return;
        end;
    end;
else papildyti=0;
end;

if papildyti;
    try
        load(eksp_rinkm,'-mat');
        try    eval([ 'saranka2=Darbeliai.dialogai.' darbas '.saranka;' ]);
        catch; saranka2=struct('vardas',''); saranka2=saranka2([]);
        end;
        esami2={saranka2.vardas};
        persidengia_i2v=find(ismember(esami2,vardas));
        for persidengia_i2=persidengia_i2v;
            persidengia_i1_=ismember({saranka.vardas},esami2(persidengia_i2));
            persidengia_i1=find(persidengia_i1_); persidengia_i1=persidengia_i1(1);
            
            [vardas2, komentaras2, pavyko]=parinkciu_rinkinio_uzvadinimas(...
                saranka(persidengia_i1).vardas, saranka(persidengia_i1).komentaras, darbas, saranka, saranka2, 1);
            
            if (pavyko == 2) && ~strcmp(saranka(persidengia_i1).vardas, vardas2) ; % perrašyta ir pervadinta
                persidengia_i2v=unique([persidengia_i2v find(ismember(esami2,{vardas2}))]);
                pavyko=1;
            end;
            if pavyko < 2; % neleista perrašyti: atšaukta arba pervadinta;
                persidengia_i2v=setdiff(persidengia_i2v, persidengia_i2);
                if pavyko; % pervadinta
                    saranka(persidengia_i1).vardas=vardas2;
                    saranka(persidengia_i1).komentaras=komentaras2;
                else % atšaukta
                    saranka=saranka(~persidengia_i1_);
                end;
            end;
        end;
        
        if length(persidengia_i2v) == length(saranka2);
            eval([ 'Darbeliai.dialogai.' darbas '.saranka=saranka;' ]);
        else
            saranka2=saranka2(setdiff(1:length(saranka2),persidengia_i2v)); % ištrint persidengiančius
            saranka2_N=length(saranka2);
            % pridėti papildomus
            laukai=fieldnames(saranka);
            for i=1:length(saranka);
                for l=1:length(laukai); laukas=laukai{l};
                    saranka2(saranka2_N+i).(laukas)=saranka(i).(laukas);
                end;
            end;
            eval([ 'Darbeliai.dialogai.' darbas '.saranka=saranka2;' ]);
        end;
    catch err; Pranesk_apie_klaida(err, mfilename, eksp_rinkm, 0);
        klsm=sprintf('%s.\n%s', lokaliz('Nepavyko papildyti'), lokaliz('Perrasyti rinkmena?'));
        mgtk={lokaliz('Yes'), lokaliz('No'), lokaliz('No')};
        ats=questdlg(klsm, lokaliz('Nepavyko papildyti'), mgtk{:});
        if strcmp(ats,lokaliz('Yes'));
            eval([ 'Darbeliai.dialogai.' darbas '.saranka=saranka;' ]);
        else
            return;
        end;
    end;
else
    eval([ 'Darbeliai.dialogai.' darbas '.saranka=saranka;' ]);
end;
            
% Įrašyti
try   save(eksp_rinkm,'Darbeliai');
catch err; Pranesk_apie_klaida(err, darbas, eksp_rinkm, 0);
end;

switch darbas
    case {'pop_meta_drb'}
        sar=meta_drb_priklausomybes(saranka);
        if ~isempty(sar);
            disp(' '); disp(lokaliz('Eksportuoti priklausomybes?')); disp(sar); disp(' '); 
            mgtk={lokaliz('Yes'), lokaliz('No'), lokaliz('Yes')};
            ats=questdlg(lokaliz('Eksportuoti priklausomybes?'), lokaliz('Eksportuoti priklausomybes?'), mgtk{:});
            if strcmp(ats,lokaliz('Yes'));
                drbs=unique(sar(:,1));
                for d=1:length(drbs); drb=drbs{d};
                    prks=unique(sar(ismember(sar(:,1),{drb}),2));
                    drb_parinktis_eksportuoti(hObject, eventdata, handles, konfig_rinkm, drb, ...
                        'rinkiniai', prks, 'eksp_rinkm', eksp_rinkm, 'papildyti', 1);
                end;
            end;
        end;
end;


function [rinkiniai_lokaliz]=lokalizuok_rinkinius(rinkiniai_orig)
rinkiniai_lokaliz=rinkiniai_orig;
i=find(ismember(rinkiniai_orig, 'numatytas' ));
if ~isempty(i); rinkiniai_lokaliz(i)={lokaliz('Numatytas')}; end;
i=find(ismember(rinkiniai_orig, 'paskutinis' ));
if ~isempty(i); rinkiniai_lokaliz(i)={lokaliz('Paskiausias')}; end;


function sar=meta_drb_priklausomybes(saranka)
sar={};
for i=1:length(saranka);
    for dbr_i=1:10; dbr_id=num2str(dbr_i);
        try ci=ismember({saranka(i).parinktys.id}, {['checkbox_drb' dbr_id]});
            if saranka(i).parinktys(ci).Value;
                d=find(ismember({saranka(i).parinktys.id}, {['popupmenu_drb' dbr_id]}));
                p=find(ismember({saranka(i).parinktys.id}, {['popupmenu_drb' dbr_id '_']}));
                if length(d) >= 1 && length(p) >= 1; % buvo klaida pop_meta_drb, kai 2x septintus darbus įrašė ir neįrašė aštuntų
                    d=d(1); p=p(1);
                    drb=saranka(i).parinktys(d).TooltipString;
                    prk=saranka(i).parinktys(p).TooltipString;
                    if ~isempty(drb) && ~isempty(prk);
                        sar=[sar; {drb prk}]; %#ok
                    end;
                end;
            end;
        catch err; Pranesk_apie_klaida(err, num2str(i), dbr_id, 0);
        end;
    end;
end;


function drb_parinktis_importuoti(hObject, eventdata, handles, konfig_rinkm, darbas, varargin)
%% Importuoti
try
g=struct(varargin{:}); % imp_rinkm, rinkiniai
catch %err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
end;

imp_rinkm='';
try imp_rinkm=g.imp_rinkm; catch; end;
if isempty(imp_rinkm);
    [imp_rinkm,imp_kel]=uigetfile({'*.drbk';'*.mat'},lokaliz('Importuoti'),...
        [ 'Darbeliai (' darbas ').drbk' ]);
    if isempty(imp_rinkm); return; end;
    if isequal(imp_rinkm,0); return; end;
    imp_rinkm=fullfile(imp_kel,imp_rinkm);
    if exist(imp_rinkm,'file') ~= 2; return; end;
end;

try load(imp_rinkm,'-mat');
    try    eval([ 'saranka2=Darbeliai.dialogai.' darbas '.saranka;' ]);
    catch; error(lokaliz('Nera ko importuoti.'));
    end;
    esami2={saranka2.vardas}; %#ok
    pasirinkti=[];
    try pasirinkti=find(ismember(esami2,{g.rinkiniai})); catch; end;
    if isempty(pasirinkti);
        pasirinkti=listdlg('ListString', lokalizuok_rinkinius(esami2),...
            'SelectionMode','multiple',...
            'PromptString', lokaliz('Importuoti'),...
            'InitialValue',length(esami2),...
            'OKString',lokaliz('Importuoti'),...
            'CancelString',lokaliz('Cancel'));
    end;
    if isempty(pasirinkti); return; end;
    esami2=esami2(pasirinkti);
    saranka2=saranka2(pasirinkti);
catch err; Pranesk_apie_klaida(err, mfilename, imp_rinkm);
    return;
end;

try
    load(konfig_rinkm);
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    esami={saranka.vardas}; %#ok
    
    persidengia_i2v=find(ismember(esami2,esami));
    for persidengia_i2=persidengia_i2v;
        [vardas2, komentaras2, pavyko]=parinkciu_rinkinio_uzvadinimas(...
            saranka2(persidengia_i2).vardas, saranka2(persidengia_i2).komentaras, darbas, saranka2, saranka, 1);
        if pavyko == 2; % perrašyta ir pervadinta
            saranka=saranka(~ismember({saranka.vardas},vardas2));
            pavyko=1;
        end;
        if pavyko == 1; % pervadinta
            persidengia_i2v=setdiff(persidengia_i2v, persidengia_i2);
            saranka2(persidengia_i2).vardas=vardas2;
            saranka2(persidengia_i2).komentaras=komentaras2;
        end;
    end;
    
    
    if length(persidengia_i2v) == length(saranka2);
        return;
    else
        saranka2=saranka2(setdiff(1:length(saranka2),persidengia_i2v)); % ištrint persidengiančius
        saranka_N=length(saranka);
        % pridėti papildomus
        laukai=fieldnames(saranka2);
        for i=1:length(saranka2);
            for l=1:length(laukai); laukas=laukai{l};
                saranka(saranka_N+i).(laukas)=saranka2(i).(laukas); %#ok
            end;
        end;
    end;
catch %err; Pranesk_apie_klaida(err, mfilename, konfig_rinkm, 0);
    saranka=saranka2; %#ok
end;

eval(['Darbeliai.dialogai.' darbas '.saranka=saranka; ']);

% Įrašymas
try   movefile([konfig_rinkm '~'], [konfig_rinkm '~~' ], 'f'); catch; end;
try   movefile(konfig_rinkm, [konfig_rinkm '~' ], 'f'); catch; end;
try   save(konfig_rinkm,'Darbeliai');
catch err; Pranesk_apie_klaida(err, darbas, konfig_rinkm, 0);
end;


switch darbas
    case {'pop_meta_drb'}
        sar=meta_drb_priklausomybes(saranka2);
        if ~isempty(sar);
            disp(' '); disp(lokaliz('Importuoti priklausomybes?')); disp(sar); disp(' '); 
            mgtk={lokaliz('Yes'), lokaliz('No'), lokaliz('Yes')};
            ats=questdlg(lokaliz('Importuoti priklausomybes?'), lokaliz('Importuoti priklausomybes?'), mgtk{:});
            if strcmp(ats,lokaliz('Yes'));
                drbs=unique(sar(:,1));
                for d=1:length(drbs); drb=drbs{d};
                    prks=unique(sar(ismember(sar(:,1),{drb}),2));
                    drb_parinktis_importuoti([], eventdata, handles, konfig_rinkm, drb, ...
                        'rinkiniai', prks, 'imp_rinkm', imp_rinkm);
                end;
            end;
        end;
end;

% meniu
drb_meniu(hObject, eventdata, handles, 'visas', darbas);
