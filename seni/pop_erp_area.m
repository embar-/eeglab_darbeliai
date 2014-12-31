%
% Randa pasirinktame ERP laiko intervale plotą, 
% laiko reikšme ties puse ploto,
% minimumus, maksimumus,
% taip pat eksportuoja ERP į Excel.
% 
%
% (C) 2014 Mindaugas Baranauskas
%
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

function [lentele]=pop_erp_area(varargin)
lentele={};

if ~ispc;
    %warning('Abejoju, ar kitoje nei Windows sistemoje MATLAB ras Excel. Nutraukiama');
    warning('Abejoju, ar kitoje nei Windows sistemoje MATLAB ras Excel. Duomenys nebus eksportuojami, bet naudokite funkciją taip: [lentele]=pop_erp_area()');
    %return;
end;

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
if nargin > 5;     
    Reikalingi_kanalai=varargin{6};
else
    Reikalingi_kanalai={};
end;
if nargin > 6;     
    laiko_intervalas=varargin{7};
else
    laiko_intervalas=[];
end;
if nargin > 7;     
    Eksp_erp=varargin{8};
else
    Eksp_erp=1;
end;
if nargin > 8;     
    time_interval_erp=varargin{9};
else
    time_interval_erp=[];
end;

excel_dokumentas_plotui=fullfile(folder_name,[ 'ERP_plotas_' datestr(now, 'yyyy-mm-dd_HHMMSS') '.xlsx' ]);
excel_dokumentas_erp=fullfile(folder_name,[ 'ERP_' datestr(now, 'yyyy-mm-dd_HHMMSS') '.xlsx' ]);
if ~ispc;
    csv_dokumentas_plotui=regexprep(excel_dokumentas_plotui,'.xls(|x)$','');
    csv_dokumentas_erp=regexprep(excel_dokumentas_erp,'.xls(|x)$','');
end;
EEG_filenames={};


% EEG eksportavimas į tekstinį failą
disp(' ');
disp(' === ERP ploto radimas ===');

% turi būti paleista EEGLAB programa
eeglab redraw;

koduote=feature('DefaultCharacterSet');
%%feature('DefaultCharacterSet','Windows-1257');

if ~Neklausti_failu;
answer = inputdlg( ...
    {'Laiko intervalas plotui, ms' , 'Laiko intervalas eksportui, ms'}, ...
    'ERP ploto radimas',1, ...
    {num2str(laiko_intervalas) num2str(time_interval_erp)},'on');

laiko_intervalas=str2num(answer{1});
time_interval_erp=str2num(answer{2});
end;

% Duomenų įkėlimas
button='Atverti naujus';
if ~isempty(EEG);
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
    %feature('DefaultCharacterSet',koduote);
    return ;
end;
if strcmp(button,'Atverti naujus');
    %feature('DefaultCharacterSet',koduote);
    [FileNames,PathName,FilterIndex] = uigetfile({'*.set','EEGLAB EEG duomenys';'*.*','Visi failai'},'Pasirinkite duomenis','','MultiSelect','on');
    try 	cd(PathName); catch err ; return ; end ;
    if class(FileNames) == 'char' ;
        NumberOfFiles=1 ;
        temp{1}=FileNames ;
        FileNames=temp;
    end ;
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    EEG = pop_loadset('filename',FileNames,'loadmode','info');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    eeglab redraw;
    EEG_filenames=FileNames;
    %feature('DefaultCharacterSet','Windows-1257');
end;

% Jei pažymėtas tik vienas rinkinys, pamėginti įkelti visus rinkinius
if length(EEG) == 1 ;
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',[1:length(ALLEEG)] ,'study',0);
eeglab redraw;
end;

% Tikrinti
if min([EEG.trials]) == 1 ;
    msg=['Naudokite tik epochuotus duomenis ERP analizei!' ] ;
    disp(char(msg));
    warndlg(msg, 'Tik epochuoti duomenys!' );
    %feature('DefaultCharacterSet',koduote);
    return ;
end;

% Tikrinti pasirinktų įrašų suderinamumą, jei jų yra keli
disp(' ');
disp('Tikrinami duomenys...');
if length(ALLEEG) > 1 ;
    if ~isequal(EEG.nbchan) ;
        msg='EEG įrašuose skirtingas kanalų kiekis! Kanalų atrinkimui galite pasinaudoti tam skirta funkcija per meniu Darbeliai > Nuoseklus apdorojimas';
        disp(msg);
        warndlg(msg, 'Duomenys nesuderinami!' );
        %feature('DefaultCharacterSet',koduote);
        return ;
    end;
    ChanLocs={};
    for i=1:length(ALLEEG);   
	    ChanLocs(i,1:length({EEG(1).chanlocs.labels}))={EEG(i).chanlocs.labels};
    end;
    for i=1:size(ChanLocs,2);	
        if ~isequal(ChanLocs{:,i});
            msg='EEG įrašuose nesutampa kanalai arba jų eiliškumas! Kanalų suvienodinimui galite pasinaudoti kanalų atrinkimo funkcija per meniu Darbeliai > Nuoseklus apdorojimas';
            disp(msg);
            warndlg(msg, 'Duomenys nesuderinami!' );
            %feature('DefaultCharacterSet',koduote);
            return ;
        end;
    end;
end;

% Paklausti, kur saugoti duomenis
% try
%     folder_name = uigetdir(pwd, 'Pasirinkite aplanką, į kurį eksportuoti EEG duomenis tekstiniu pavidalu') ;
%     try 
%         mkdir(fullfile (folder_name, 'info'));
%     catch err;
%     end
%     cd(folder_name) ;
%     disp(' ');
%     disp('Duomenys bus rašomi į:');
%     disp(pwd);
% catch err;
%     disp('Atšaukta!');
%     %feature('DefaultCharacterSet',koduote);
%     return ;
% end;

plotas=[];
vidutine_amplitude=[];
ploto_pusei_x=[];
ploto_pusei_y=[];
minimumai_x=[];
minimumai_y=[];
maksimumai_x=[];
maksimumai_y=[];

ERP={};

% Analizuoti
disp(' ');
disp('Analizuojama...');
for i=1:length(ALLEEG) ;
     try
        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',i,'study',0);
        %[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',[1:length(ALLEEG)],'study',0);
        if length(EEG_filenames)<i;
            if ~isempty(EEG.filename);               
                EEG_filenames{i}=EEG.filename;        
            elseif ~isempty(EEG.setname);
                EEG_filenames{i}=EEG.setname;
            else
                EEG_filenames{i}=num2str(i);
            end;
        end;
        Rinkmena= EEG_filenames{i} ;
        disp([num2str(i) '/' num2str(length(ALLEEG)) ' (' num2str(round(i/length(ALLEEG) * 100)) '%): ' Rinkmena]);
        %if ~isempty(Svetimi_kanalai) ;
        %   EEG = pop_select( EEG,'channel',intersect(VISI_KANALAI_62,ChanLocs(1,:)));
        %end;
        %     if min_trials > 0 ;
        %        EEG = pop_selectevent( EEG, 'epoch',[1:min_trials] ,'deleteevents','off', 'deleteepochs','on', 'invertepochs','off');
        %     end;
        if isempty(laiko_intervalas);
            laiko_intervalas=[EEG.times(1) EEG.times(end)];
        end;
        [plotas(i,1:EEG.nbchan), ...
         ploto_pusei_x(i,1:EEG.nbchan),...
         ploto_pusei_y(i,1:EEG.nbchan)] = ...
         erp_area(EEG,laiko_intervalas);
        
        [~, idx1] = min(abs(EEG.times - laiko_intervalas(1) )) ;
        [~, idx2] = min(abs(EEG.times - laiko_intervalas(2) )) ;
        lango_trukme=EEG.times(idx2) - EEG.times(idx1) ;
        vidutine_amplitude(i,1:EEG.nbchan)=plotas(i,1:EEG.nbchan) ./ lango_trukme ;

        lango_erp=mean([EEG.data(:,idx1:idx2,:)],3);
        minimumai_y(i,1:EEG.nbchan)=[min(lango_erp,[],2)]';
        minimumai_x(i,1:EEG.nbchan)=EEG.times(idx1 - 1 + cell2mat([ ...
          cellfun(@(x) find(ismember(lango_erp(x,:),minimumai_y(i,x)),1), ...
          num2cell(1:EEG.nbchan), ...
          'UniformOutput',false)]));
        maksimumai_y(i,1:EEG.nbchan)=[max(lango_erp,[],2)]';
        maksimumai_x(i,1:EEG.nbchan)=EEG.times(idx1 - 1 + cell2mat([ ...
          cellfun(@(x) find(ismember(lango_erp(x,:),maksimumai_y(i,x)),1), ...
          num2cell(1:EEG.nbchan), ...
          'UniformOutput',false)]));
        
      if Eksp_erp;
        if isempty(time_interval_erp);
            time_interval_erp=[EEG.times(1) EEG.times(end)];
        end;
        [~, idx_1] = min(abs(EEG.times - time_interval_erp(1) )) ;
        [~, idx_2] = min(abs(EEG.times - time_interval_erp(2) )) ;
        ERP{i}=[mean([EEG.data(:,idx_1:idx_2,:)],3)]';
        ERP_lentele={};
        ERP_lentele(1,1)={[regexprep(Rinkmena,'.set$','')] };
        ERP_lentele(1,2:EEG.nbchan + 1)={EEG(1).chanlocs.labels};
        ERP_lentele(2:length(EEG.times(idx_1:idx_2))+1,1) = num2cell([EEG.times(idx_1:idx_2)]');
        ERP_lentele(2:length(EEG.times(idx_1:idx_2))+1,2:EEG.nbchan + 1)=num2cell(ERP{i});
        
            if ~isempty(ERP_lentele{1,1})
                laksto_pav=ERP_lentele{1,1}(1:min(length(ERP_lentele{1,1}),31));
            else
                laksto_pav=num2str(i);
            end;       
            if ispc
                xlswrite(excel_dokumentas_erp, ERP_lentele, laksto_pav );
            elseif 1 == 0;
                %disp('Abejoju, ar kitoje nei Windows sistemoje MATLAB ras Excel');
                csvwrite([csv_dokumentas_erp '_' laksto_pav '.csv'], ERP_lentele );                
            end ;
            disp(' ');
            disp(excel_dokumentas_erp);
     end;
      catch err;
          disp(err.message);
          warndlg(err.message,err.identifier);
      end;
end;

Rinkmenos={EEG_filenames{:}}';

% Karkasas

lentele{1,1}(1,1)={' '};
lentele{1,1}(1,2:EEG.nbchan + 1)={EEG(1).chanlocs.labels};
lentele{1,1}(2:length(ALLEEG)+1,1) = Rinkmenos;
lentele{1,2}=lentele{1,1};
lentele{1,3}=lentele{1,1};
lentele{2,2}=lentele{1,1};
lentele{2,3}=lentele{1,1};
lentele{3,2}=lentele{1,1};
lentele{3,3}=lentele{1,1};
lentele{4,2}=lentele{1,1};
lentele{4,3}=lentele{1,1};

% Užpildyti
lentele{1,2}(2:length(ALLEEG)+1,2:EEG.nbchan + 1) = num2cell(plotas);
lentele{1,3}(2:length(ALLEEG)+1,2:EEG.nbchan + 1) = num2cell(vidutine_amplitude);
lentele{2,2}(2:length(ALLEEG)+1,2:EEG.nbchan + 1) = num2cell(ploto_pusei_x);
lentele{2,3}(2:length(ALLEEG)+1,2:EEG.nbchan + 1) = num2cell(ploto_pusei_y);
lentele{3,2}(2:length(ALLEEG)+1,2:EEG.nbchan + 1) = num2cell(minimumai_x);
lentele{3,3}(2:length(ALLEEG)+1,2:EEG.nbchan + 1) = num2cell(minimumai_y);
lentele{4,2}(2:length(ALLEEG)+1,2:EEG.nbchan + 1) = num2cell(maksimumai_x);
lentele{4,3}(2:length(ALLEEG)+1,2:EEG.nbchan + 1) = num2cell(maksimumai_y);


lentele{1,1}=merge_cells(lentele{1,2},lentele{1,3},'plotas','vid.ampl., microV');
lentele{2,1}=merge_cells(lentele{2,2},lentele{2,3},'t, ms','ampl., microV');
lentele{3,1}=merge_cells(lentele{3,2},lentele{3,3},'t, ms','ampl., microV');
lentele{4,1}=merge_cells(lentele{4,2},lentele{4,3},'t, ms','ampl., microV');

lango_intervalas_zodziu=regexprep(num2str(round(laiko_intervalas) ), '[ ]*' , ' ' );
lango_intervalas_zodziu=strrep(lango_intervalas_zodziu,' ',' - ');

if ispc
    lakstas=['Plotas ' lango_intervalas_zodziu ] ;
    xlswrite(excel_dokumentas_plotui, lentele{1,1}, lakstas);
    lakstas=['Ties puse ploto' ] ;
    xlswrite(excel_dokumentas_plotui, lentele{2,1}, lakstas);
    lakstas=['Min' ] ;
    xlswrite(excel_dokumentas_plotui, lentele{3,1}, lakstas);
    lakstas=['Max' ] ;
    xlswrite(excel_dokumentas_plotui, lentele{4,1}, lakstas);
    disp(' ');
    disp(['Excel dokumentas sukurtas!' ]) ;
    disp(pwd);
    disp(excel_dokumentas_plotui);
elseif  1 == 0;   
    lakstas=['Plotas ' lango_intervalas_zodziu ] ;
    csvwrite([csv_dokumentas_plotui '_' lakstas '.csv'], lentele{1,1});
    lakstas=['Ties puse ploto' ] ;
    csvwrite([csv_dokumentas_plotui '_' lakstas '.csv'], lentele{2,1});
    lakstas=['Min' ] ;
    csvwrite([csv_dokumentas_plotui '_' lakstas '.csv'], lentele{3,1});
    lakstas=['Max' ] ;
    csvwrite([csv_dokumentas_plotui '_' lakstas '.csv'], lentele{4,1});
    disp(' ');
    disp(['CSV dokumentas sukurtas!' ]) ;
    disp(pwd);
    disp(excel_dokumentas_plotui);
end ;

disp(' ');
disp('Atlikta !');

%feature('DefaultCharacterSet',koduote);