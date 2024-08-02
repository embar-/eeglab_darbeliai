% eksportuoti_erp_mat()
% eksportuoti_erp_mat(ALLEEG, EEG)
%
% ERP eksportavimas į MAT failą
%
%
% (C) 2014-2016 Mindaugas Baranauskas
%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Ši programa yra laisva. Jūs galite ją platinti ir/arba modifikuoti
% remdamiesi Free Software Foundation paskelbtomis GNU Bendrosios
% Viešosios licencijos sąlygomis: 3 licencijos versija, arba (savo
% nuožiūra) bet kuria vėlesne versija.
%
% Ši programa platinama su viltimi, kad ji bus naudinga, bet BE JOKIOS
% GARANTIJOS; taip pat nesuteikiama jokia numanoma garantija dėl TINKAMUMO
% PARDUOTI ar PANAUDOTI TAM TIKRAM TIKSLU. Daugiau informacijos galite 
% rasti pačioje GNU Bendrojoje Viešojoje licencijoje.
%
% Jūs kartu su šia programa turėjote gauti ir GNU Bendrosios Viešosios
% licencijos kopiją; jei ne - žr. <https://www.gnu.org/licenses/>.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%%
 
function [ChanLocs, ERP_laikai, Eksportuotos_rinkmenos, ERP_lentele]=eksportuoti_erp_mat(varargin)

ERP_laikai=[];
Eksportuotos_rinkmenos={};
ERP_lentele=[];
ChanLocs={};

if nargin > 0;    
    ALLEEG=varargin{1};
else
    ALLEEG = [];
end;
if nargin > 1;    
    EEG=varargin{2};
else
    EEG=[];
end;
if nargin > 2;    
    CURRENTSET=varargin{3};
else
    CURRENTSET=[];
end;
if nargin > 3;    
    Neklausti_failu=varargin{4};
else
    Neklausti_failu=0;
end;
if nargin > 4;    
    folder_name=varargin{5};
else
    folder_name='';
end; 

disp(' ');
disp(' === ERP eksportavimas į MAT rinkmeną ===');
 
% turi būti paleista EEGLAB programa
%eeglab redraw;

EEG_filenames={};

% Duomenų įkėlimas
button='Atverti naujus';
if ~isempty(EEG);
    try
        EEG(1).data=EEG(1).erp_data; % EEG.erp_data is not standard EEGLAB param
    catch err;
    end;
    if ~isempty(EEG(1).data);
        if ~Neklausti_failu;
            button = questdlg(['Kokius epochuotus duomenis naudoti?' ] , ...
                'Naudotini duomenys', ...
                'Atsisakyti', 'Jau įkeltuosius', 'Atverti naujus', 'Jau įkeltuosius');
        else
            button='Jau įkeltuosius';
        end;
    end;
end;
if strcmp(button,'Atsisakyti');
    return ;
end;
if strcmp(button,'Atverti naujus');
    [FileNames,PathName] = uigetfile({'*.set','EEGLAB EEG duomenys';'*.*','Visi failai'},'Pasirinkite duomenis','','MultiSelect','on');
    try     cd(PathName); catch; return ; end ;
    if class(FileNames) == 'char' ;
        NumberOfFiles=1 ;
        temp{1}=FileNames ;
        FileNames=temp;
    end ;
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    EEG = pop_loadset('filename',FileNames,'loadmode','info');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    %eeglab redraw;
    EEG_filenames=FileNames;
end;
 
% Jei pažymėtas tik vienas rinkinys, pamėginti įkelti visus rinkinius
if and(length(EEG) == 1, length(ALLEEG) > 1);
    try
        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',[1:length(ALLEEG)] ,'study',0);
    catch %err; Pranesk_apie_klaida(err,'','',0);
        %eeglab redraw;
    end;
end;

% Tikrinti pasirinktų įrašų suderinamumą, jei jų yra keli
disp(' ');
disp('Tikrinami duomenys...');
if length(ALLEEG) > 1 ;
    if ~isequal(ALLEEG.srate) ;
        msg='Skiriasi duomenų kvantavimo dažnis! Duomenų suvienodinimui galite pasinaudoti tam skirta funkcija per meniu Tools > Change sampling rate';
        warning(msg);
        warndlg(msg, 'Duomenys nesuderinami!' );
        return ;
    end;
    if ~isequal(ALLEEG.pnts) ;
        msg=['Skiriasi EEG įrašų trukmės! Trukmių suvienodinimui galite pasinaudoti tam skirta funkcija per meniu Darbeliai > Nuoseklus apdorojimas' ];
        warning(msg);
        warndlg(msg, 'Duomenys nesuderinami!' );
        return ;
    end;   
    if ~isequal(ALLEEG.nbchan) ;
        msg='EEG įrašuose skirtingas kanalų kiekis! Kanalų atrinkimui galite pasinaudoti tam skirta funkcija per meniu Darbeliai > Nuoseklus apdorojimas';
        warning(msg);
        warndlg(msg, 'Duomenys nesuderinami!' );
        return ;
    end;
    for i=1:length(ALLEEG);  
        ChanLocs(i,1:length({ALLEEG(1).chanlocs.labels}))={ALLEEG(i).chanlocs.labels};
    end;
    ChanLocsUniq=unique(ChanLocs)';
    for i=1:size(ChanLocs,1);  
        if ~isequal(ChanLocsUniq,unique(ChanLocs(i,:)));
            msg='EEG įrašuose nesutampa kanalai! Kanalų suvienodinimui galite pasinaudoti kanalų atrinkimo funkcija per meniu Darbeliai > Nuoseklus apdorojimas';
            warning(msg);
            warndlg(msg, 'Duomenys nesuderinami!' );
            return ;
        end;
    end;
elseif length(ALLEEG) == 1 ;
    ChanLocs(1,1:length({ALLEEG(1).chanlocs.labels}))={ALLEEG(1).chanlocs.labels};
    ChanLocsUniq=unique(ChanLocs)';
else
    error('internal error');
end;

% Kanalų kiekis
ChanLocs=ChanLocs(1,:);
ChN=size(ChanLocs,2);

ERP_laikai=ALLEEG(1).times;

% Paklausti, kur saugoti duomenis
try
    if isempty(folder_name);
    folder_name = uigetdir(pwd, 'Pasirinkite aplanką, į kurį eksportuoti SĮSP duomenis MAT rinkmenoje') ;
    end;
catch
    disp('Atšaukta!');
    return ;
end;
 
% Lentelės sukūrimas
disp(' ');
disp('Kuriama lentelė...');
for i=1:length(ALLEEG) ;
    try
        EEG=ALLEEG(i);
        if ~isnumeric(EEG.data);
            EEG=eeg_retrieve(ALLEEG, i);
            %[~, EEG, ~] = pop_newset(ALLEEG, EEG, i,'retrieve',i,'study',0);
            %[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',[1:length(ALLEEG)],'study',0);
        end;
        if length(EEG_filenames)<i;
            if ~isempty(EEG.filename);              
                EEG_filenames{i}=EEG.filename;       
            elseif ~isempty(EEG.setname);
                EEG_filenames{i}=EEG.setname;
            else
                EEG_filenames{i}=num2str(i);
            end;
        end;
       
        Rinkmena=[regexprep(EEG_filenames{i}, '.set$', '') '.txt'];
        Rinkmena_su_keliu=fullfile(folder_name, Rinkmena) ;
        disp([num2str(i) '/' num2str(length(ALLEEG)) ' (' num2str(round(i/length(ALLEEG) * 100)) '%): ' Rinkmena_su_keliu]);
       
        try
            EEG.data=EEG.erp_data; % EEG.erp_data is not standard EEGLAB param
            EEG.trials=1; EEG.epoch=[]; EEG.event=[];
            EEG.icaact=[]; EEG.icawinv=[]; EEG.icasphere=[]; EEG.icaweights=[]; EEG.icachansind=[]; 
            disp(lokaliz('We use pre-processed data to speed up exporting. Please ignore eeg_checkset warnings.'));
            %lango_erp=[EEGTMP.erp_data(:,idx1:idx2,:)];
        catch 
            %lango_erp=mean([EEGTMP.data(:,idx1:idx2,:)],3);
        end;
       
        if isempty(EEG.data);
            error(lokaliz('Empty dataset'));
        end;
        
        x = EEG.data;
        if ~isempty(EEG.epoch); % TMPEEG.trials > 0 ; % size(TMPEEG.data,3) >1 %
            x = mean(x, 3);
        else
            x = reshape(x, size(x,1), size(x,2)*size(x,3));
        end;
        lentele=nan(ChN,size(x,2));
        x_n = size(x,1);
        for index = 1:x_n;
            lbl=EEG.chanlocs(index).labels;
            nr=find(ismember(ChanLocs,lbl));
            % disp({index lbl '>' nr});
            if length(nr) == 1;
                lentele(nr,:)=x(index,:);
            else
                warning(lbl);
            end;
        end;
        
        Eksportuotos_rinkmenos{end+1}=Rinkmena;
        ERP_lentele(1:size(lentele,1),1:size(lentele,2),length(Eksportuotos_rinkmenos))=lentele;
        
    catch err; Pranesk_apie_klaida(err,'','',0);
    end;
end;

ERP_MAT.Kanalai   = ChanLocs;
ERP_MAT.Laikai    = ERP_laikai;
ERP_MAT.Rinkmenos = Eksportuotos_rinkmenos;
ERP_MAT.Amplitude_KxLxR = ERP_lentele; %#ok
mat_file=fullfile (folder_name, ['ERP_'  datestr(now, 'yyyy-mm-dd_HHMMSS') '.mat']);

disp(' ');
disp(lokaliz('Duomenis rasite rinkmenoje'));
disp(mat_file);
save(mat_file, 'ERP_MAT');

disp(' ');
disp('Atlikta!');
disp(' ');
