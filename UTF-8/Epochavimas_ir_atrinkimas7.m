%
% Atrinkti dideles epochas, kuriose yra dviejų rūšių stimulai: stimulai ir atsakai
% T.y. epochuojama pagal stimulų įvykius, po to tikrinama, ar naujose epochose yra atsakų įvykiai
% 
% Taip pat yra galimybė šias dideles epchas dar smulkiau epochuoti pagal stimulus ir Epochuoti_pagal_atsakus,
% galima pašalinti jų baseline
%
%
% (c) 2014 Mindaugas Baranauskas
%
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



function epochavimas_ir_atrinkimas7(varargin)


if nargin > 11 ;
    
    
    Epochavimo_intervalas_pirminis       = (varargin{1});
    Epochuoti_pagal_stimulus_            = (varargin{2});
    Epochavimo_intervalas_stimulams      = (varargin{3});
    Epochavimo_intervalas_stimulams_base = (varargin{4});
    Epochuoti_pagal_atsakus              = (varargin{5});
    Epochavimo_intervalas_atsakams       = (varargin{6});
    Epochavimo_intervalas_atsakams_base  = (varargin{7});
    PathName  = varargin{8};
    FileNames = varargin{9};
    NewDir    = varargin{10};
    Pirminio_epochavimo_priesaga = varargin{11};
    Pirminio_epochavimo_netrinti = varargin{12};
    
    FilterIndex=0;
    
%     disp('vv')
%     disp(Epochavimo_intervalas_pirminis);
%     disp(Epochuoti_pagal_stimulus_);
%     disp(Epochuoti_pagal_atsakus);
%     disp(Epochavimo_intervalas_atsakams);
%     disp(Epochavimo_intervalas_atsakams_base);
%     disp(Epochavimo_intervalas_stimulams);
%     disp(Epochavimo_intervalas_stimulams_base);
%     disp('^^')
    
else
    
    disp(' ');
    disp(' === Epochavimas pagal stimulus ir atsakus ===');
    disp(' ');
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    
    
    PAGEIDAUJAMAS_KELIAS='D:\Rasa\eeg_analize\2m_S\31  32  33  34  35  36  51  52  53  54  55  56 su 10' ;
    Epochuoti_pagal_stimulus= '31:36 51:56' ;
    Epochavimo_intervalas_pirminis= '-0.200 2.000 ' ;
    Epochavimo_intervalas_stimulams= '0.350 0.700 ' ;
    Epochavimo_intervalas_stimulams_base= '-0.200 0.000 ' ;
    Epochavimo_intervalas_atsakams= '-0.600 -0.250' ;
    Epochavimo_intervalas_atsakams_base= '-0.600 0.000 ' ;
    Epochuoti_pagal_atsakus=' 10 ' ;
    
    Pirminio_epochavimo_priesaga='_EpochDidelis';
    Pirminio_epochavimo_netrinti=1;
    
    answer = inputdlg({ ...
        '1) Pirminis epochavimo intervalas, sekundemis *:' ...
        'Epochuoti pagal STIMULUS *:' ...
        '2) Stimulu epochavimo intervalas, sekundemis (jei reikia):' ...
        'Stimulu baseline (jei nereikia - tuscia palikti):' ...
        '3) Epochose taip pat turi buti ATSAKAS *:' ...
        'Atsaku epochavimo intervalas, sekundemis (jei reikia):'  ...
        'Atsaku baseline (jei nereikia - tuscia palikti):' ...
        }, ...
        'Epochavimas',1, ...
        { ...
        Epochavimo_intervalas_pirminis ...
        Epochuoti_pagal_stimulus  ...
        Epochavimo_intervalas_stimulams ...
        Epochavimo_intervalas_stimulams_base ...
        Epochuoti_pagal_atsakus ...
        Epochavimo_intervalas_atsakams ...
        Epochavimo_intervalas_atsakams_base ...
        }, ...
        'on') ;
    
    if isempty(answer);
        return;
    end;
    
    try
        
        Epochavimo_intervalas_pirminis=str2num(answer{1}) ;
        Epochuoti_pagal_stimulus_=str2num(answer{2});
        Epochuoti_pagal_atsakus=str2num(answer{5}) ;
        
    catch err;
        %disp(err.message);
        Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
        return ;
    end;
    
    try
        Epochavimo_intervalas_stimulams=str2num(answer{3}) ;
    catch
    end;
    
    
    try
        Epochavimo_intervalas_atsakams=str2num(answer{6}) ;
        %disp(['Pakartotines epochos trukme atsakams ' num2str( Epochavimo_intervalas_atsakams(2) - Epochavimo_intervalas_atsakams(1)) ' sekundes']);
        NewDir=([ num2str(Epochuoti_pagal_stimulus_) ' su ' num2str(Epochuoti_pagal_atsakus) ] ) ;
    catch
    end;
    
    
    try
        Epochavimo_intervalas_stimulams_base= str2num(answer{4}) ;
    catch
    end;
    
    try
        Epochavimo_intervalas_atsakams_base= str2num(answer{7}) ;
    catch
    end;
    
    
    
    % Duomenu ikelimui:
    
    try
        cd(PAGEIDAUJAMAS_KELIAS);
    catch err;
        %disp(err.message);
        disp([ 'Neradome pageidaujamo kelio ' PAGEIDAUJAMAS_KELIAS ' , tad pasirinkite ji!' ]);
        %    return ;
    end;
    
    [FileNames,PathName,FilterIndex] = uigetfile({'*.set','EEGLAB duomenys';'*.cnt','ASA LAB EEG duomenys';'*Pruned with ICA*.set','Pruned with ICA';'*.*','Visi failai'},'Pasirinkite duomenis','', 'MultiSelect','on');
    
    % [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    % global ALLEEG EEG CURRENTSET ALLCOM ;
    eeglab redraw;
    
end ;


try
    if iscellstr(Epochuoti_pagal_stimulus_);
        Epochuoti_pagal_stimulus=Epochuoti_pagal_stimulus_;
    else
        Epochuoti_pagal_stimulus={};
        for i=1:length(Epochuoti_pagal_stimulus_) ;
            Epochuoti_pagal_stimulus{1+length(Epochuoti_pagal_stimulus)}=num2str(Epochuoti_pagal_stimulus_(i));
        end;
    end;
    if ~iscellstr(Epochuoti_pagal_atsakus);
        Epochuoti_pagal_atsakus_=Epochuoti_pagal_atsakus;
        Epochuoti_pagal_atsakus={};
        for i=1:length(Epochuoti_pagal_atsakus_) ;
            Epochuoti_pagal_atsakus{1+length(Epochuoti_pagal_atsakus)}=num2str(Epochuoti_pagal_atsakus_(i));
        end;
    end;
    disp(['Pirmines epochos trukme ' num2str( Epochavimo_intervalas_pirminis(2) - Epochavimo_intervalas_pirminis(1)) ' sekundes']);
catch err;
    %disp(err.message);
    Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;    
    return;
end;
try
    %disp(['Pakartotines epochos trukme stimulams ' num2str( Epochavimo_intervalas_stimulams(2) - Epochavimo_intervalas_stimulams(1)) ' sekundes']);
    if Epochavimo_intervalas_stimulams(1) < Epochavimo_intervalas_pirminis(1) ;
        disp('Epocha stimulu epochavimui prasideda anksciau nei pirminiam!');
        return ;
    end ;
    if Epochavimo_intervalas_stimulams(2) > Epochavimo_intervalas_pirminis(2) ;
        disp('Epocha stimulu epochavimui baigesi veliau nei pirminiam!');
        return ;
    end ;
catch
end;
if isempty(PathName);
    disp(' ');
    disp('Nepasirinkote kelio');
    return ;
end;

current_path=pwd;
try
    cd(PathName);
catch err;
    %disp(err.message);
    disp(' ');
    disp('Netinkamas kelias');
    return ;
end;

if class(FileNames) == 'char' ;
    NumberOfFiles=1 ;
    temp{1}=FileNames ;
    FileNames=temp;
end ;

% Sukurti nauja aplanka, kuriame patalpinsime naujai sukursimus failus

try
    if ~(exist(fullfile(pwd,NewDir),'dir') == 7);
        mkdir(NewDir);
    end;
catch err;
    warning(err.message);
end;
try
    cd(NewDir);
catch err;
    warning(err.message);
    %Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
end;
NewDir=pwd;
cd(current_path);

NumberOfFiles=length(FileNames);
for i=1:NumberOfFiles ;
    
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
    disp(' ');
    disp(' ');
    
    File=FileNames{i} ;
    disp([ ' == ' File ' == ' ] );
    
    % Isimink laika  - veliau bus galimybe paziureti, kiek laiko uztruko
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    tic ;
    
    if FilterIndex == 1 ;
        EEG = pop_loadset('filename',File,'filepath',PathName);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    elseif FilterIndex == 2 ;
        % Importuoti
        EEG=pop_fileio([PathName File]);
    else
        EEG = eeg_ikelk(PathName,File);
    end;
    
    visi_galimi_ivykiai=unique({EEG.event.type});
    
    % Epochuoti pagal nurodytus ivykius nurodytame intervale
    disp(' ');
    disp(' = Pirminis epochavimas tik pagal stimulus = ');
    [EEG, ~, LASTCOM] = pop_epoch( EEG, Epochuoti_pagal_stimulus, Epochavimo_intervalas_pirminis, 'newname', [ strrep(strrep(File,'.cnt',''),'.set','') 'filtr epochs'], 'epochinfo', 'yes');
    EEG = eegh(LASTCOM, EEG);
    EEG = eeg_checkset( EEG );
    
    % Baseline korekcija
    % EEG = pop_rmbase( EEG, [-200 0]);
    EEG = eeg_checkset( EEG );
    %[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    
    % Atrinkti tik nurodyta ivyki turincias epochas (teisingus atsakymus)
    try
        disp(' = Epochu su pasirinktais atsakais atrinkimas = ');
        [EEG, ~, LASTCOM] = pop_selectevent( EEG, 'type', Epochuoti_pagal_atsakus ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        EEG = eegh(LASTCOM, EEG);
        EEG = eeg_checkset( EEG );
        
        % Sukurti laikina faila po pirminio epochavimo, kuriame yra tiek
        % stimulai, tiek ir atsakai
        %NewFileTmp=fullfile(pwd , [ File '_epoch_pg ' num2str(Epochuoti_pagal_stimulus_) ' su ' num2str(Epochuoti_pagal_atsakus) '.set']);
        NewFileTmp_=[ strrep(strrep(File,'.cnt',''),'.set','') Pirminio_epochavimo_priesaga '.set'];
        NewFileTmp=fullfile(NewDir,NewFileTmp_);
        if EEG.trials > 0 ;
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname', strrep(strrep(File,'.cnt',''),'.set',''),'savenew',NewFileTmp);
        else
            error('Liko tuscias irasas');
        end;% Isvalyti atminti
        STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
        
        
        %% Ikelti laikinaji faila darbui su ATSAKAIS
        disp(' ');
        disp(' = Darbas su atsakais = ');
        try
            %Epochavimo_intervalas_atsakams=str2num(answer{6}) ;
            disp(['Pakartotines epochos trukme atsakams ' num2str( Epochavimo_intervalas_atsakams(2) - Epochavimo_intervalas_atsakams(1)) ' sekundes']);
            
            EEG = pop_loadset('filename',NewFileTmp_,'filepath',NewDir);
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            
            
            % Epochuoti pagal nurodytus ivykius nurodytame intervale trumpesniame
            % ATSAKAMS
            [EEG, ~, LASTCOM] = pop_epoch( EEG, Epochuoti_pagal_atsakus, Epochavimo_intervalas_atsakams, 'newname', [ strrep(strrep(File,'.cnt',''),'.set','') 'filtr epoch atsakai'], 'epochinfo', 'yes');
            EEG = eegh(LASTCOM, EEG);
            try
                tmp_base_interval=[];
                tmp_base_trukme=(Epochavimo_intervalas_atsakams_base(2) - Epochavimo_intervalas_atsakams_base(1) );
                tmp_base_interval=1000 * [Epochavimo_intervalas_atsakams_base(1) Epochavimo_intervalas_atsakams_base(2)];
                [EEG, LASTCOM] = pop_rmbase( EEG, tmp_base_interval);
                EEG = eegh(LASTCOM, EEG);
                EEG = eeg_checkset( EEG );
            catch err
                disp([ 'Baseline ' num2str(tmp_base_interval) ' atsakams nekoreguota:' ]);
                %disp(err.message);
                Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
            end;
            
            EEG = eeg_checkset( EEG );
            NewFile=fullfile(NewDir, [  strrep(strrep(File,'.cnt',''),'.set','') ' tik_ats_su visais stim.set']);
            
            if EEG.trials > 0 ;
                [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname', strrep(strrep(File,'.cnt',''),'.set',''),'savenew',NewFile);
            else
                error('Liko tuscias irasas');
            end;
            
            % Isvalyti atminti
            STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
            
            % Viska pakartokim, kad smulkiau EEG sukarpytu pagal stimulus,
            % susietais su vienu atsaku
            for y=1:length(Epochuoti_pagal_stimulus) ;
                
                try
                    if ~(ismember(Epochuoti_pagal_stimulus(y),visi_galimi_ivykiai));
                        error(['Nera stimulo ' Epochuoti_pagal_stimulus(y) ]);
                    end;
                    
                    disp(' ');
                    
                    EEG = pop_loadset('filename',NewFileTmp_,'filepath',NewDir);
                    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
                    
                    % Atrinkti tik nurodyta ivyki turincias epochas (teisingus atsakymus)
                    [EEG, ~, LASTCOM] = pop_selectevent( EEG, 'type', [Epochuoti_pagal_stimulus_(y)] ,'deleteevents','off','deleteepochs','on','invertepochs','off');
                    EEG = eegh(LASTCOM, EEG);
                    EEG = eeg_checkset( EEG );
                    % Apkarpyti pagal pageidaujama atsako intervala
                    [EEG, ~, LASTCOM] = pop_epoch( EEG, Epochuoti_pagal_atsakus, Epochavimo_intervalas_atsakams, 'newname', [ strrep(strrep(File,'.cnt',''),'.set','') 'filtr epoch atsakai'], 'epochinfo', 'yes');
                    EEG = eegh(LASTCOM, EEG);
                    try
                        tmp_base_interval=[];
                        tmp_base_trukme=(Epochavimo_intervalas_atsakams_base(2) - Epochavimo_intervalas_atsakams_base(1) );
                        tmp_base_interval=1000 * [Epochavimo_intervalas_atsakams_base(1) Epochavimo_intervalas_atsakams_base(2)];
                        [EEG, LASTCOM] = pop_rmbase( EEG, tmp_base_interval );
                        EEG = eegh(LASTCOM, EEG);
                        EEG = eeg_checkset( EEG );
                    catch err
                        disp([ 'Baseline ' num2str(tmp_base_interval) ' atsakams(2) nekoreguota:' ]);
                        %disp(err.message);
                        Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
                    end;
                    EEG = eeg_checkset( EEG );
                    
                    NewFile2=fullfile(NewDir, [  strrep(strrep(File,'.cnt',''),'.set','') ' tik_ats_su '  Epochuoti_pagal_stimulus{y} ' stim.set']);
                    if EEG.trials > 0 ;
                        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname', strrep(strrep(File,'.cnt',''),'.set',''),'savenew',NewFile2);
                        disp(['Pavyko atrinkti atsakus, kai yra ivykis ' Epochuoti_pagal_stimulus{y}]);
                        str=(sprintf('Naujas failas patalpintas cia:\n%s\n\n', NewFile2)) ;
                        disp(str);
                    else
                        error('Liko tuscias irasas');
                    end;
                    
                catch err;
                    disp(['NEPAVYKO atrinkti atsaku, kai yra ivykis ' Epochuoti_pagal_stimulus{y}]);
                    %disp(err.message);
                    Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
                    disp(' ');
                end;
                
                % Isvalyti atminti
                STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
                
            end;
        catch err;
            str=sprintf(['Klaida epochuojant pagal atsakus.']);
            disp(str);
            %disp(err.message);
            Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
        end;
        
        disp(' ');
        
        %% Ikelti laikinaji faila darbui su STIMULAIS
        disp(' ');
        disp(' = Darbas su stimulais = ');
        
        try
            %Epochavimo_intervalas_stimulams=str2num(answer{3}) ;
            disp(['Pakartotines epochos trukme stimulams ' num2str( Epochavimo_intervalas_stimulams(2) - Epochavimo_intervalas_stimulams(1)) ' sekundes']);
            
            EEG = pop_loadset('filename',NewFileTmp_,'filepath',NewDir);
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            
            % Epochuoti pagal nurodytus ivykius nurodytame intervale trumpesniame
            % STIMULAMS
            
            [EEG, ~, LASTCOM] = pop_epoch( EEG, Epochuoti_pagal_stimulus, Epochavimo_intervalas_stimulams, 'newname', [ strrep(strrep(File,'.cnt',''),'.set','') 'filtr epoch stimulai'], 'epochinfo', 'yes');
            EEG = eegh(LASTCOM, EEG);
            try
                tmp_base_interval=[];
                tmp_base_trukme=(Epochavimo_intervalas_stimulams_base(2) - Epochavimo_intervalas_stimulams_base(1) );
                tmp_base_interval=1000 * [Epochavimo_intervalas_stimulams_base(1) Epochavimo_intervalas_stimulams_base(2)];
                [EEG, LASTCOM] = pop_rmbase( EEG, tmp_base_interval);
                EEG = eegh(LASTCOM, EEG);
                EEG = eeg_checkset( EEG );
            catch err
                disp([ 'Baseline ' num2str(tmp_base_interval) ' stimulams nekoreguota:' ]);
                %disp(err.message);
                Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', File,0) ;
            end;
            EEG = eeg_checkset( EEG );
            NewFile=fullfile(NewDir, [  strrep(strrep(File,'.cnt',''),'.set','') ' tik_stim visi.set']);
            if EEG.trials > 0 ;
                [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname', strrep(strrep(File,'.cnt',''),'.set',''),'savenew',NewFile);
            else
                error('Liko tuscias irasas');
            end;
            % Isvalyti atminti
            STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
            % Info
            str=(sprintf('\n\n%s apdorotas (%d is %d = %3.2f%%)\nNaujas failas patalpintas cia:\n%s\n\n', File, i, NumberOfFiles, i/NumberOfFiles*100, NewFile)) ;
            disp(str);
            % Parodyk, kiek laiko uztruko
            toc ;
            
            disp(' ');
            
            % Viska pakartokim, kad smulkiau EEG sukarpytu pagal stimulus
            for y=1:length(Epochuoti_pagal_stimulus) ;
                
                try
                    if ~(ismember(Epochuoti_pagal_stimulus(y),visi_galimi_ivykiai));
                        error(['Nera stimulo ' Epochuoti_pagal_stimulus(y) ]);
                    end;
                    
                    disp(' ');
                    
                    EEG = pop_loadset('filename',NewFileTmp_,'filepath',NewDir);
                    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
                    
                    % Atrinkti tik nurodyta ivyki turincias epochas (teisingus atsakymus)
                    [EEG, ~, LASTCOM] = pop_selectevent( EEG, 'type', [Epochuoti_pagal_stimulus_(y)] ,'deleteevents','off','deleteepochs','on','invertepochs','off');
                    EEG = eegh(LASTCOM, EEG);
                    [EEG, ~, LASTCOM] = pop_epoch( EEG, Epochuoti_pagal_stimulus, Epochavimo_intervalas_stimulams, 'newname', [ strrep(strrep(File,'.cnt',''),'.set','') 'filtr epoch stimulai'], 'epochinfo', 'yes');
                    EEG = eegh(LASTCOM, EEG);
                    try
                        tmp_base_interval=[];
                        tmp_base_trukme=(Epochavimo_intervalas_stimulams_base(2) - Epochavimo_intervalas_stimulams_base(1) );
                        tmp_base_interval=1000 * [Epochavimo_intervalas_stimulams_base(1) Epochavimo_intervalas_stimulams_base(2)];
                        [EEG, LASTCOM] = pop_rmbase( EEG, tmp_base_interval);
                        EEG = eegh(LASTCOM, EEG);
                        EEG = eeg_checkset( EEG );
                    catch err
                        disp([ 'Baseline ' num2str(tmp_base_interval) ' stimulams(2) nekoreguota:' ]);
                        %disp(err.message);
                        Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
                    end;
                    
                    
                    EEG = eeg_checkset( EEG );
                    
                    NewFile2=fullfile(NewDir, [  strrep(strrep(File,'.cnt',''),'.set','') ' tik_stim ' Epochuoti_pagal_stimulus{y} '.set']);
                    if EEG.trials > 0 ;
                        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname', strrep(strrep(File,'.cnt',''),'.set',''),'savenew',NewFile2);
                        disp(['Pavyko atrinkti stimulus, kai yra ivykis ' Epochuoti_pagal_stimulus{y}]);
                        str=(sprintf('Naujas failas patalpintas cia:\n%s\n\n', NewFile2)) ;
                        disp(str);
                    else
                        error('Liko tuscias irasas');
                    end;
                catch err;
                    disp(['NEPAVYKO atrinkti stimulu, kai yra ivykis ' Epochuoti_pagal_stimulus{y}]);
                    %disp(err.message);
                    Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
                    disp(' ');
                end;
                
                % Isvalyti atminti
                STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
                
            end;
        catch err;
            str=sprintf(['Klaida epochuojant pagal stimulus.']);
            disp(str);
            %disp(err.message);
            Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
        end;
        
        disp(' ');
        
    catch err;
        str=sprintf('Klaida.\n Gal epochose nera arba nebeliko ivykio, pagal kuri norite atrinkti epochas? \n O gal failo vardas tampa per ilgas? \n');
        str=[str sprintf('%s ',Epochuoti_pagal_atsakus{:})];
        disp(str);
        %disp(err.message);
        Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', '',0) ;
        %f = msgbox(str, 'Kazkas netvarkoj su failu') ;
        %drawnow ;
        disp(' ');
    end;
    
    disp(' ');
    
    if ~Pirminio_epochavimo_netrinti ;
        try 
            delete(NewFileTmp); 
            NewFileTmp_fdt=regexprep(NewFileTmp,'.set$','.fdt');
            if exist(NewFileTmp_fdt,'file') == 2;
                delete(NewFileTmp_fdt);
            end;
            NewFileTmp_ica=regexprep(NewFileTmp,'.set$','.ica');
            if exist(NewFileTmp_ica,'file') == 2;
                delete(NewFileTmp_ica);
            end;
        catch err; 
            %disp(err.message); 
            Pranesk_apie_klaida(err, 'Epochavimas_ir_atrinkimas7', NewFileTmp,0) ;
        end;
    end ;
    
end ;

% close all ;
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

%eeglab redraw;

if nargin < 12 ;
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    disp(['Viskas uzbaigta: ' t ]);
    f = msgbox(sprintf('Apdorota pradiniu failu: %d.\nNaujus smulkesnius duomenis rasite aplanke\n%s\n', NumberOfFiles, NewDir), 'Baigta!');
    drawnow;
end;


