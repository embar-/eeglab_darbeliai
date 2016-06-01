%% [DUOMENYS]=eeg_spektr_galia(Kelias, Failai, KANALAI, leisti_interpoliuoti, ...
% Dazniu_sritys Dazniu_sriciu_pavadinimai Papildomi_dazniu_santykiai, ...
% AR_GRAFIKAS,lango_ilgis_sekundemis,fft_tasku_herce, ...
% Ar_reikia_galios_absoliucios, Ar_reikia_galios_santykines)
%
%% Gauna pasirinktų failų spektrinį galios tankį
%
% (c) 2014-2016 Mindaugas Baranauskas


%%
% Pasiruošti

function [DUOMENYS]=eeg_spektr_galia(...
    PathName, FileNames, ...
    IsvedimoAplankas, Doc_pvd, Doc_tp, ...
    NORIMI_KANALAI, leisti_interpoliuoti, ...
    Dazniu_sritys, Dazniu_sriciu_pavadinimai,...
    Papildomi_dazniu_santykiai,...
    AR_GRAFIKAS,...
    lango_ilgis_sekundemis,fft_tasku_herce, ...
    Ar_reikia_galios_absoliucios, Ar_reikia_galios_santykines, ...
    Ar_reikia_spekro_absol, Ar_reikia_spekro_db)

[ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);
DUOMENYS.VISU.NORIMI_KANALAI=NORIMI_KANALAI;
DUOMENYS.VISU.leisti_interpoliuoti=leisti_interpoliuoti;
DUOMENYS.VISU.Dazniu_sritys=Dazniu_sritys;
DUOMENYS.VISU.Dazniu_sriciu_pavadinimai=Dazniu_sriciu_pavadinimai;
DUOMENYS.VISU.Papildomi_dazniu_santykiai=Papildomi_dazniu_santykiai;
DUOMENYS.VISU.lango_ilgis_sekundemis=lango_ilgis_sekundemis;
DUOMENYS.VISU.fft_tasku_herce=fft_tasku_herce;
%% Aprašykime kintamuosius
analizuoti_pavadinima=0;
%AR_GRAFIKAS='off';
if analizuoti_pavadinima;
    % Svarbu nurodyti failo pavadinimo schemą!
    %DUOMENYS.VISU.Pavadinimo_schema='s%d%c_%s';
    DUOMENYS.VISU.Pavadinimo_schema='%s';
end;
% Pirmojo intervalo atžvilgiu bus skaičiuojama santykinė galia
%DUOMENYS.VISU.Dazniu_sritys = { [1 45] [8 12] [8 13] ; };
% Turi atitikti dažnių sričių kiekį
%DUOMENYS.VISU.Dazniu_sriciu_pavadinimai = { 'visas' 'alfa8_12' 'alfa8_13' ;} ;
% Dėmesio! Rašomi ne dažniai, o aukščiau išvardintų dažnių indeksai, t.y.
% [4 3] reiškia, kad bus dalinama ketvirto dažnio absoliuti reikšmė iš trečio dažnio absoliučios reikšmės
%DUOMENYS.VISU.Papildomi_dazniu_santykiai={ [4 3] [5 3] [4 9] [5 10] [3 9] [3 10] [15 9] [16 10] [15 14] [16 14] } ;
%DUOMENYS.VISU.Papildomi_dazniu_santykiai={ } ;

% Skyriklis nurodant santykinę galią
skyriklis='/';
if isempty(Doc_tp); Doc_tp={'mat' 'txt'}; end;
if ischar(Doc_tp) ; Doc_tp={Doc_tp}; end;
t=datestr(now, 'yyyy-mm-dd_HHMMSS'); disp(t);
if isempty(Doc_pvd); Doc_pvd='EEGLab_PSD_%t' ; end;
Doc_pvd=strrep(Doc_pvd,'%t',t);
Rezultatu_MAT_failas=[Doc_pvd '.mat'] ;
Rezultatu_TXT_failas=[Doc_pvd '.txt'] ; % galia
Rezultatu_TXT_failas_sp = [ Doc_pvd '.sp.txt' ] ;
Rezultatu_Stjudento=[Doc_pvd '_Stjud.tsv'];
Rezultatu_Stjudento_galvos=[Doc_pvd '_StjudGalvos.txt'];
Rezultatu_Vilkoksono=[Doc_pvd '_Vilk.tsv'];
Rezultatu_Vilkoksono_galvos=[Doc_pvd '_VilkGalvos.txt'];
NewDir=[Doc_pvd '_' num2str(Dazniu_sritys{1}(1)) '-' num2str(Dazniu_sritys{1}(2)) ] ;

DUOMENYS.VISU.Tiriamieji={};

if or(strcmp(AR_GRAFIKAS,'on'),AR_GRAFIKAS==1);
    AR_GRAFIKAS='on';
    figure_id=figure;
    set(0,'CurrentFigure',figure_id);
    clf;
else
    AR_GRAFIKAS='off';
end;

%%
% Stačiakampėje (Excel) lentelėje { 'Pavad' x y ; ... }.
% Čia tik 48 kanalai:
DUOMENYS.VISU.Kanalu_koordinates_galvose={ ...
    ...
                          'Fp1' 3 1; 'Fpz' 4 1; 'Fp2' 5 1; ...
                          'AF3' 3 2;            'AF4' 5 2; ...
    'F5'  1 3; 'F3'  2 3; 'F1'  3 3; 'Fz'  4 3; 'F2'  5 3; 'F4'  6 3; 'F6'  7 3; ...
    'FC5' 1 4; 'FC3' 2 4; 'FC1' 3 4; 'FCz' 4 4; 'FC2' 5 4; 'FC4' 6 4; 'FC6' 7 4; ...
    'C5'  1 5; 'C3'  2 5; 'C1'  3 5; 'Cz'  4 5; 'C2'  5 5; 'C4'  6 5; 'C6'  7 5; ...
    'CP5' 1 6; 'CP3' 2 6; 'CP1' 3 6; 'CPz' 4 6; 'CP2' 5 6; 'CP4' 6 6; 'CP6' 7 6; ...
    'P5'  1 7; 'P3'  2 7; 'P1'  3 7; 'Pz'  4 7; 'P2'  5 7; 'P4'  6 7; 'P6'  7 7; ...
    'PO5' 1 8; 'PO3' 2 8;            'POz' 4 8;            'PO4' 6 8; 'PO6' 7 8; ...
                          'O1'  3 9; 'Oz'  4 9; 'O2'  5 9};


orig_path=pwd;
if or(isempty(FileNames),isempty(PathName));
    % Duomenu ikelimui:
    [FileNames,PathName,FilterIndex] = ...
        uigetfile({'*.set','EEGLAB duomenys';'*.cnt','ASA LAB EEG duomenys';'*.*','Visi failai'},...
        'Pasirinkite duomenis','','MultiSelect','on');
    NewFileNames={};
    try
        cd(PathName);
    catch err ;
        warning(err.message) ;
        return ;
    end;
else
    try
        cd(PathName);
    catch err;
        warning(err.message);
    end;
    FileNames=filter_filenames(FileNames);
    FilterIndex = 3;
end;

tic;

cd(orig_path);

if class(FileNames) == 'char' ;
    NumberOfFiles=1 ;
    temp{1}=FileNames ;
    FileNames=temp;
end ;



% Sukurti nauja aplanka, kuriame patalpinsime naujai sukursimus failus
if or(isempty(IsvedimoAplankas),~ischar(IsvedimoAplankas));
    NewPath=fullfile(PathName, NewDir);
else
    NewPath=IsvedimoAplankas;
end;
if ~(exist(NewPath,'dir') == 7);
    mkdir(NewPath);
end;

% tikrinimas dėl kanalų tvarkos priskyrimo
simuliacinis_tikrinimas([3 1 2], 1:2)=[10 10; 20 20; 30 30];
if ~isequal(simuliacinis_tikrinimas, [20 20; 30 30; 10 10]);
    error(lokaliz('Internal error'));
end;

NumberOfFiles=length(FileNames);
for i=1:NumberOfFiles ;

    % Isimink laika  - veliau bus galimybe paziureti, kiek laiko uztruko
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    %tic ;

    File=FileNames{i} ;
    disp(File);

    if ~isempty(which('rinkmenos_tikslinimas.m'));
        [KELIAS_,Rinkmena_]=rinkmenos_tikslinimas(PathName,File);
    else
        [KELIAS_,Rinkmena_,galune]=fileparts(fullfile(PathName,File));
        Rinkmena_=[Rinkmena_ galune];
        KELIAS_=Tikras_Kelias(KELIAS_);
    end;

    if FilterIndex == 1 ;
        %EEG = pop_loadset('filename',File);
        EEG = pop_loadset('filename',Rinkmena_,'filepath',KELIAS_);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    elseif FilterIndex == 2 ;
        % Importuoti
        EEG=pop_fileio(fullfile(KELIAS_,Rinkmena_));
    else
        EEG = eeg_ikelk(KELIAS_,Rinkmena_);
    end;
    
    try
        
        EEG = eeg_checkset( EEG );
        
        if (EEG.xmax - EEG.xmin) < DUOMENYS.VISU.lango_ilgis_sekundemis ;
            error([lokaliz('Epocha trumpesne uz FFT lango ilgi!') ...
                ' EEG.xmax-EEG.xmin=' num2str(EEG.xmax - EEG.xmin) 's, bet FFT langas' ...
                num2str(DUOMENYS.VISU.lango_ilgis_sekundemis) ' s.']);
        end;
        
        %if EEG.nbchan > 0;
        
        if leisti_interpoliuoti;
            % Jei reikia – interpoliuok
            EEG = eeg_interpoliuok64(EEG, NORIMI_KANALAI);
            EEG = eeg_checkset( EEG );
        end;
        
        % Tikrinti, ar visi kanalai yra        
        nesutampantys_kanalai=setdiff(DUOMENYS.VISU.NORIMI_KANALAI,{EEG.chanlocs(:).labels});
        if ~isempty(nesutampantys_kanalai);
            isp_prnsm=sprintf(' \n\n%s\n%s:\n %s\n%s\n%s\n%s %s\n', ...
                lokaliz('Some selected channels may not appear in every dataset.'), ...
                lokaliz('Rinkmena'), File, ...
                lokaliz('Missing channels:'), sprintf(' %s', nesutampantys_kanalai{:}), ...
                lokaliz('Galimas sprendimas:'), ...
                lokaliz('Allow interpolate channels'));
            wrn=warning('off','backtrace');
            warning(isp_prnsm);
            warning(wrn.state, 'backtrace');
        end;
        
        % Atrinkti kanalus
        try
            %EEG = pop_select( EEG,'channel',DUOMENYS.VISU.NORIMI_KANALAI);
            % Jei nebuvo interpoliacijos, tada reikia naudoti sekančią eilutę, kad
            % nenulūžtų programa beieškodama nesamo kanalo
            EEG = pop_select( EEG,'channel',intersect({EEG.chanlocs(:).labels},DUOMENYS.VISU.NORIMI_KANALAI));
        catch err; Pranesk_apie_klaida(err, 'EEG spektras', File, 0);
        end;
        
        % Atmesti kanalus, kurie yra tiesi linija
        ne_tiesiosios_linijos=[];
        for knl=1:size(EEG.data,1);
            if length(unique(EEG.data(knl,:))) ~= 1;
                ne_tiesiosios_linijos=[ne_tiesiosios_linijos knl];
            else
                disp([ EEG.chanlocs(knl).labels ' yra tiesi linija!' ]);
                nesutampantys_kanalai=[nesutampantys_kanalai {EEG.chanlocs(knl).labels}];
            end;
        end;
        if length(ne_tiesiosios_linijos) ~= size(EEG.data,1);
            EEG = pop_select( EEG,'channel', {EEG.chanlocs(ne_tiesiosios_linijos).labels});
        end;
        
        EEG = eeg_checkset( EEG );
        
        if and(EEG.nbchan > 0, ~isempty(EEG.data));
            
            if strcmp(AR_GRAFIKAS,'on');
                set(0,'CurrentFigure',figure_id);
                clf;
            end;
            
            %try
            
            %spectopo_daznis=[1 2 4 8 16 32 64 128 256 512 1024];
            %spectopo_daznis=spectopo_daznis(max(find(spectopo_daznis <= (EEG.srate/2) == 1)));
            
            DUOMENYS.FAILO(i).KANALAI=DUOMENYS.VISU.NORIMI_KANALAI; %{EEG.chanlocs.labels}
            [~,Kanalu_sukeisti_id]=ismember({EEG.chanlocs.labels},DUOMENYS.VISU.NORIMI_KANALAI);
            
            [DUOMENYS.FAILO(i).SPEKTRAS.dB(Kanalu_sukeisti_id,:),DUOMENYS.FAILO(i).DAZNIAI]= ...
                pop_spectopo(EEG, 1, [EEG.times(1) EEG.times(end)], 'EEG',...
                'percent',100,...
                'freqrange',[0 EEG.srate/2],...
                'electrodes','off',...
                'winsize',EEG.srate*DUOMENYS.VISU.lango_ilgis_sekundemis,...
                'nfft',EEG.srate*DUOMENYS.VISU.fft_tasku_herce,...
                'plot',AR_GRAFIKAS );
            
            [~,Kanalu_nesanciu_id]=ismember(nesutampantys_kanalai,DUOMENYS.VISU.NORIMI_KANALAI);
            DUOMENYS.FAILO(i).SPEKTRAS.dB(Kanalu_nesanciu_id,:)=nan(length(Kanalu_nesanciu_id),length(DUOMENYS.FAILO(i).DAZNIAI));
            
            % 0.1*[0:(10*floor(EEG.srate/2))]
            %             'freqfac',10,...
            %         catch err;
            %             disp('Perkuriamas EEG.chanlocs');
            %             for kan_i=1:EEG.nbchan;
            %                 EEG.chanlocs(kan_i).labels=    DUOMENYS.VISU.NORIMI_KANALAI{kan_i} ;
            %                 EEG.chanlocs(kan_i).type=      '' ;
            %                 EEG.chanlocs(kan_i).theta=     0 ;
            %                 EEG.chanlocs(kan_i).radius=    0 ;
            %                 EEG.chanlocs(kan_i).X=         5.20474889637625e-15 ;
            %                 EEG.chanlocs(kan_i).Y=         0  ;
            %                 EEG.chanlocs(kan_i).Z=         85 ;
            %                 EEG.chanlocs(kan_i).sph_theta= 0  ;
            %                 EEG.chanlocs(kan_i).sph_phi=   90 ;
            %                 EEG.chanlocs(kan_i).sph_radius=85 ;
            %                 EEG.chanlocs(kan_i).urchan=    16 ;
            %                 EEG.chanlocs(kan_i).ref=       '' ;
            %             end;
            %         end;
            %         [DUOMENYS.FAILO(i).SPEKTRAS.dB,DUOMENYS.FAILO(i).DAZNIAI]= ...
            %         pop_spectopo(EEG, 1, [EEG.times(1) EEG.times(end)], 'EEG' , 'freq', [10], 'freqrange',[0 min(50,EEG.srate/2)],'electrodes','off','plot','off');
            
            
            DUOMENYS.FAILO(i).SPEKTRAS.absol=10.^(DUOMENYS.FAILO(i).SPEKTRAS.dB/10);
            DUOMENYS.FAILO(i).pavad=File;
            if analizuoti_pavadinima
                % Pakeitus DUOMENYS.VISU.Pavadinimo_schema ar duomenų aplanką, teks
                % iš naujo aprašyti informacijos atpažinimą pagal failą.
                DUOMENYS.FAILO(i).Informacija= textscan(File, DUOMENYS.VISU.Pavadinimo_schema); %,'delimiter','');
                DUOMENYS.FAILO(i).Tiriamasis=[num2str(DUOMENYS.FAILO(i).Informacija{1}) DUOMENYS.FAILO(i).Informacija{2}];
                DUOMENYS.FAILO(i).Salyga=DUOMENYS.FAILO(i).Informacija{2}; % (['Ramybe' num2str(DUOMENYS.FAILO(i).Informacija{2})]);
                DUOMENYS.FAILO(i).Grupe=1;
                DUOMENYS.FAILO(i).Sesija=1;
            else
                %if isempty(EEG.subject);
                %[~,DUOMENYS.FAILO(i).Tiriamasis,~]=fileparts(File);
                DUOMENYS.FAILO(i).Tiriamasis=File;
                DUOMENYS.FAILO(i).Salyga=1;
                DUOMENYS.FAILO(i).Grupe=1;
                DUOMENYS.FAILO(i).Sesija=1;
                %         else % Kol kas nesutvarkyta tam atvejui, jei vienam tiriamajam bus kelios salygos neskaitines, jei bus skirtingu grupiu ir sesiju.
                DUOMENYS.FAILO(i).Tiriamasis_=EEG.subject;
                DUOMENYS.FAILO(i).Salyga_=EEG.condition;
                DUOMENYS.FAILO(i).Grupe=EEG.group;
                DUOMENYS.FAILO(i).Sesija=EEG.session;
                %         end;
            end;
            DUOMENYS.FAILO(i).Apibudinimas='_' ; % DUOMENYS.FAILO(i).Informacija{3};
            DUOMENYS.FAILO(i).Tiriamojo_idx=find(ismember(DUOMENYS.VISU.Tiriamieji,DUOMENYS.FAILO(i).Tiriamasis));
            if isempty(DUOMENYS.FAILO(i).Tiriamojo_idx);
                DUOMENYS.FAILO(i).Tiriamojo_idx = length(DUOMENYS.VISU.Tiriamieji)+1;
                DUOMENYS.VISU.Tiriamieji{DUOMENYS.FAILO(i).Tiriamojo_idx,1}=DUOMENYS.FAILO(i).Tiriamasis;
            end;
            
            % Tiek tikrinti nereikia, bet gali praversti, jei interpoliuosime ir kanalai nesutaps
            if ~isfield(DUOMENYS.VISU, 'DAZNIAI');
                DUOMENYS.VISU.DAZNIAI=DUOMENYS.FAILO(i).DAZNIAI;
            end;
            if ~isfield(DUOMENYS.VISU, 'KANALAI');
                DUOMENYS.VISU.KANALAI=DUOMENYS.FAILO(i).KANALAI;
            end;
            if ~isequal(DUOMENYS.VISU.DAZNIAI, DUOMENYS.FAILO(i).DAZNIAI);
                warning(['Nesutampa EEG.srate su kitų failų. ' File]);
                if length(DUOMENYS.FAILO(i).DAZNIAI) < length(DUOMENYS.VISU.DAZNIAI);
                    DUOMENYS.VISU.DAZNIAI=DUOMENYS.FAILO(i).KANALAI;
                end;
            end;
            if isequal(DUOMENYS.VISU.KANALAI, DUOMENYS.FAILO(i).KANALAI);
                DUOMENYS.VISU.tmp.SPEKTRAS_LENTELESE_absol{DUOMENYS.FAILO(i).Tiriamojo_idx,DUOMENYS.FAILO(i).Salyga}=DUOMENYS.FAILO(i).SPEKTRAS.absol;
                DUOMENYS.VISU.tmp.SPEKTRAS_LENTELESE_dB{DUOMENYS.FAILO(i).Tiriamojo_idx,DUOMENYS.FAILO(i).Salyga}=DUOMENYS.FAILO(i).SPEKTRAS.dB;
                DUOMENYS.VISU.tmp.failai{DUOMENYS.FAILO(i).Tiriamojo_idx,DUOMENYS.FAILO(i).Salyga}=File;
            else
                warning(['Nesutampa kanalai su kitų failų. ' File]);
            end;
            
            % Isvalyti atminti
            STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
            
            %eeglab redraw;
            
            str=(sprintf('Apdorotas %d/%d(%3.2f%%): %s\r\n', i, NumberOfFiles, i/NumberOfFiles*100, File )) ;
            disp(str);
            % Parodyk, kiek laiko uztruko
            %t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
            %toc ;
            
        end;
        
    catch err;
        Pranesk_apie_klaida(err, 'EEG spektras', File, 0);
    end;
    
end ;

 if strcmp(AR_GRAFIKAS,'on');
          close(figure_id) ;
 end;

% close all ;

%% Spektrinės galios tankio duomenų apdorojimas - Galios skaičiavimas
DUOMENYS.VISU.Dazniu_sriciu_N=length(DUOMENYS.VISU.Dazniu_sritys);
try DUOMENYS.VISU.Salygu_N=size(DUOMENYS.VISU.tmp.failai,2);
catch; error([lokaliz('Error') '! '  lokaliz('Skaitykite info konsoleje.')]);
end
%DUOMENYS.VISU.Tiriamieji=[];
%for i=1:DUOMENYS.VISU.Salygu_N;
%    DUOMENYS.VISU.Tiriamieji=[DUOMENYS.VISU.Tiriamieji ; find(~cellfun(@isempty,DUOMENYS.VISU.tmp.failai(:,i))) ] ;
%end;
%DUOMENYS.VISU.Tiriamieji=unique(DUOMENYS.VISU.Tiriamieji) ;
DUOMENYS.VISU.SPEKTRAS_LENTELESE_microV2_Hz=DUOMENYS.VISU.tmp.SPEKTRAS_LENTELESE_absol ;
DUOMENYS.VISU.SPEKTRAS_LENTELESE_dB=DUOMENYS.VISU.tmp.SPEKTRAS_LENTELESE_dB ;
DUOMENYS.VISU.failai=DUOMENYS.VISU.tmp.failai ;
DUOMENYS.VISU=rmfield(DUOMENYS.VISU,'tmp');
DUOMENYS.VISU.KANALU_N=length(DUOMENYS.VISU.KANALAI);
DUOMENYS.VISU.Tiriamuju_N=length(DUOMENYS.VISU.Tiriamieji);

try cd(NewPath);
catch;
    try cd(NewDir); 
    catch; 
    end;
end;

save([ Rezultatu_MAT_failas '~'], 'DUOMENYS') ;

cd(orig_path);

%% Absoliuti galia
disp('Absoliuti galia...');
DUOMENYS.VISU.GALIA_Absol_dazniu_srityje={};
for i=1:DUOMENYS.VISU.Dazniu_sriciu_N;
    [~,tasku_sritis_nuo]=min(abs(DUOMENYS.VISU.DAZNIAI - DUOMENYS.VISU.Dazniu_sritys{i}(1)));
    [~,tasku_sritis_iki]=min(abs(DUOMENYS.VISU.DAZNIAI - DUOMENYS.VISU.Dazniu_sritys{i}(2)));
    tasku_sritis= [tasku_sritis_nuo:tasku_sritis_iki];
    if length(tasku_sritis) < 2
        warning([num2str(DUOMENYS.VISU.Dazniu_sritys{i}(2)) 'Hz > ' num2str(DUOMENYS.VISU.DAZNIAI(end)) 'Hz (~EEG.srate/2)!' ]);
    end;
    for tir=1:DUOMENYS.VISU.Tiriamuju_N ;
        for sal=1:DUOMENYS.VISU.Salygu_N ;
            % DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,sal}(tir,1:DUOMENYS.VISU.KANALU_N)= ( DUOMENYS.VISU.Dazniu_sritys{i}(2) - DUOMENYS.VISU.Dazniu_sritys{i}(1) ) * mean(DUOMENYS.VISU.SPEKTRAS_LENTELESE_microV2_Hz{tir,sal}(:,tasku_sritis),2)';
            for kan=1:DUOMENYS.VISU.KANALU_N;
                try
                    if length(tasku_sritis) > 1
                        DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,sal}(tir,kan)= ...
                            trapz(DUOMENYS.VISU.DAZNIAI(tasku_sritis), ...
                            DUOMENYS.VISU.SPEKTRAS_LENTELESE_microV2_Hz{tir,sal}(kan,tasku_sritis));
                    else
                        DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,sal}(tir,kan)=0;
                    end;
                catch %err; Pranesk_apie_klaida(err,'','',0);
                    %warning([DUOMENYS.VISU.Tiriamieji{tir} ' : ' DUOMENYS.VISU.KANALAI{kan} ' : ' num2str(DUOMENYS.VISU.Dazniu_sritys{i}(1)) '-' num2str(DUOMENYS.VISU.Dazniu_sritys{i}(2)) 'Hz '  ] );
                    error([DUOMENYS.VISU.Tiriamieji{tir} ' : Data computed for ' ...
                        num2str(size(DUOMENYS.VISU.SPEKTRAS_LENTELESE_microV2_Hz{1,1},1)) ...
                        ' channels, but expected ' num2str(DUOMENYS.VISU.KANALU_N) '! ' ...
                        'Please check this file!' ]);
                end;
            end;
        end;
    end;
end;

%% Santykinė galia
disp('Santykinė galia...');
% Pirmosios dazniu srities atzvilgiu

DUOMENYS.VISU.GALIA_Sant_dazniu_srityje={};
for i=1:DUOMENYS.VISU.Dazniu_sriciu_N;
    for sal=1:DUOMENYS.VISU.Salygu_N ;

        DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,sal}= ...
            DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,sal} ./ ...
            DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{1,sal} ;
    end;
end;

% DUOMENYS.VISU.Papildomi_dazniu_santykiai

for i=1:length(DUOMENYS.VISU.Papildomi_dazniu_santykiai);
    for sal=1:DUOMENYS.VISU.Salygu_N ;

        DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{DUOMENYS.VISU.Dazniu_sriciu_N + i,sal}= ...
            DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{DUOMENYS.VISU.Papildomi_dazniu_santykiai{i}(1),sal} ./ ...
            DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{DUOMENYS.VISU.Papildomi_dazniu_santykiai{i}(2),sal} ;
    end;
end;

% save([ Rezultatu_MAT_failas '~'], 'DUOMENYS') ;

if and(0,(DUOMENYS.VISU.Salygu_N == 2)) ;

%% Statistika – Stjudento ir Vilkoksono
% Tarp (pirmu) dvieju salygu
DUOMENYS.VISU.Statistika_Stjudento_absol_galiai={};
DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.h_galvai=[];
DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai={};
DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.h_galvai=[];
for i=1:DUOMENYS.VISU.Dazniu_sriciu_N;

    DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.h_galvai{i}(1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,3}]),1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,2}]))=' ';
    DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.h_galvai{i}(1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,3}]),1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,2}]))=' ';

    for kan=1:DUOMENYS.VISU.KANALU_N;
        kan_pav=DUOMENYS.VISU.KANALAI{kan};
        galvoje=find(ismember(DUOMENYS.VISU.Kanalu_koordinates_galvose(:,1),kan_pav));
        galvoje_x=DUOMENYS.VISU.Kanalu_koordinates_galvose{galvoje,2};
        galvoje_y=DUOMENYS.VISU.Kanalu_koordinates_galvose{galvoje,3};
        [DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.PasInt{i,kan}, ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.stats{i,kan}] ...
         = ttest(DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,2}(:,kan), ...
            0.05, 'both') ;
        [DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_l.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_l.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_l.PasInt{i,kan}, ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_l.stats{i,kan}] ...
         = ttest(DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,2}(:,kan), ...
            0.05, 'left') ;
        [DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_r.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_r.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_r.PasInt{i,kan}, ...
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_r.stats{i,kan}] ...
         = ttest(DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,2}(:,kan), ...
            0.05, 'right') ;
        [DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.stats{i,kan}] ...
          = signrank(DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,1}(:,kan), DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,2}(:,kan), 'tail', 'both') ;
        [DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai_l.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai_l.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai_l.stats{i,kan}] ...
          = signrank(DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,1}(:,kan), DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,2}(:,kan), 'tail', 'left') ;
        [DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai_r.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai_r.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai_r.stats{i,kan}] ...
          = signrank(DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,1}(:,kan), DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,2}(:,kan), 'tail', 'right') ;

       % Stjudento
       if DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.h(i,kan) == 1 ;
            if mean(DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,1}(:,kan)) < ...
                    mean(DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,2}(:,kan));  ...
                    galvoje_reiksme='+';
            else galvoje_reiksme='-';
            end;

            if     DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_r.h(i,kan) == 1 ;
                      galvoje_reiksme2='-' ;
            elseif DUOMENYS.VISU.Statistika_Stjudento_absol_galiai_l.h(i,kan) == 1 ;
                      galvoje_reiksme2='+' ;
            else
                disp(['Vidinė klaida: i=' num2str(i) ', kan=' num2str(kan) ', turi būti ' galvoje_reiksme ', bet yra ' galvoje_reiksme2 ]);
            end ;

            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.h_galvai{i}(galvoje_y,galvoje_x)=galvoje_reiksme2;
        else
            DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.h_galvai{i}(galvoje_y,galvoje_x)='.';
        end;

        % Vilkoksono
        if DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.h(i,kan) == 1 ;

            if     DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai_r.h(i,kan) == 1 ;
                      galvoje_reiksme3='-' ;
            elseif DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai_l.h(i,kan) == 1 ;
                      galvoje_reiksme3='+' ;
            else
                disp(['Vidinė klaida: i=' num2str(i) ', kan=' num2str(kan)  ]);
            end ;

            DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.h_galvai{i}(galvoje_y,galvoje_x)=galvoje_reiksme3;
        else
            DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.h_galvai{i}(galvoje_y,galvoje_x)='.';
        end;


    end;


    % Stjud
    fid=fopen(Rezultatu_Stjudento_galvos, 'a');
    fprintf(fid, sprintf('\n%s\n', DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i}) );
    for e=1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,3}]) ;
        fwrite(fid, DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.h_galvai{i}(e,:));
        fprintf(fid, sprintf('\n'));
    end;
    fprintf(fid, sprintf('\n'));
    fclose(fid);

    %Vilkoksono
    fid=fopen(Rezultatu_Vilkoksono_galvos, 'a');
    fprintf(fid, sprintf('\n%s\n', DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i}) );
    for e=1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,3}]) ;
        fwrite(fid, DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.h_galvai{i}(e,:));
        fprintf(fid, sprintf('\n'));
    end;
    fprintf(fid, sprintf('\n'));
    fclose(fid);


end;

DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai={};
DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.h_galvai=[];
DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai={};
DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.h_galvai=[];
for i=2:(DUOMENYS.VISU.Dazniu_sriciu_N + length(DUOMENYS.VISU.Papildomi_dazniu_santykiai));

    DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.h_galvai{i}(1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,3}]),1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,2}]))=' ';
    DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.h_galvai{i}(1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,3}]),1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,2}]))=' ';

    for kan=1:DUOMENYS.VISU.KANALU_N;
        kan_pav=DUOMENYS.VISU.KANALAI{kan};
        galvoje=find(ismember(DUOMENYS.VISU.Kanalu_koordinates_galvose(:,1),kan_pav));
        galvoje_x=DUOMENYS.VISU.Kanalu_koordinates_galvose{galvoje,2};
        galvoje_y=DUOMENYS.VISU.Kanalu_koordinates_galvose{galvoje,3};
        [DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.PasInt{i,kan}, ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.stats{i,kan}] ...
            = ttest(DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,2}(:,kan), 0.05, 'both' ) ;
        [DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_l.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_l.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_l.PasInt{i,kan}, ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_l.stats{i,kan}] ...
            = ttest(DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,2}(:,kan), 0.05, 'left' ) ;
        [DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_r.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_r.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_r.PasInt{i,kan}, ...
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_r.stats{i,kan}] ...
            = ttest(DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,2}(:,kan), 0.05, 'right' ) ;
        if DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.h(i,kan) == 1 ;
            if mean(DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,1}(:,kan)) < ...
                    mean(DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,2}(:,kan));  ...
                    galvoje_reiksme='+';
            else galvoje_reiksme='-';
            end;


            if     DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_r.h(i,kan) == 1 ;
                      galvoje_reiksme2='-' ;
            elseif DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai_l.h(i,kan) == 1 ;
                      galvoje_reiksme2='+' ;
            else
                disp(['Vidinė klaida: i=' num2str(i) ', kan=' num2str(kan) ', turi būti ' galvoje_reiksme ', bet yra ' galvoje_reiksme2 ]);
            end ;



            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.h_galvai{i}(galvoje_y,galvoje_x)=galvoje_reiksme2;
        else
            DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.h_galvai{i}(galvoje_y,galvoje_x)='.';
        end;






        [DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.stats{i,kan}] ...
            = signrank(DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,2}(:,kan), 'tail', 'both' ) ;
        [DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai_l.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai_l.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai_l.stats{i,kan}] ...
            = signrank(DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,2}(:,kan), 'tail', 'left' ) ;
        [DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai_r.p(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai_r.h(i,kan), ...
            DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai_r.stats{i,kan}] ...
            = signrank(DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,1}(:,kan),...
            DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,2}(:,kan), 'tail', 'right' ) ;
        if DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.h(i,kan) == 1 ;

            if     DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai_r.h(i,kan) == 1 ;
                      galvoje_reiksme3='-' ;
            elseif DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai_l.h(i,kan) == 1 ;
                      galvoje_reiksme3='+' ;
            else
                disp(['Vidinė klaida: i=' num2str(i) ', kan=' num2str(kan) ]);
            end ;



            DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.h_galvai{i}(galvoje_y,galvoje_x)=galvoje_reiksme3;
        else
            DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.h_galvai{i}(galvoje_y,galvoje_x)='.';
        end;


    end;


    % Stjudento galvos
    fid=fopen(Rezultatu_Stjudento_galvos, 'a');
    if i <= DUOMENYS.VISU.Dazniu_sriciu_N ;
        fprintf(fid, sprintf('\n%s\n', [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i} skyriklis ...
              DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{1}]));
    else
        fprintf(fid, sprintf('\n%s\n', cell2mat([DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(1)) ' / ' ...
              DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(2)) ]))) ;
    end;
    for e=1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,3}]) ;
        fwrite(fid, DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.h_galvai{i}(e,:));
        fprintf(fid, sprintf('\n'));
    end;
    fprintf(fid, sprintf('\n'));
    fclose(fid);


    % Vilkoksono galvos
    fid=fopen(Rezultatu_Vilkoksono_galvos, 'a');
    if i <= DUOMENYS.VISU.Dazniu_sriciu_N ;
        fprintf(fid, sprintf('\n%s\n', [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i} skyriklis ...
              DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{1}]));
    else
        fprintf(fid, sprintf('\n%s\n', cell2mat([DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(1)) ' / ' ...
              DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(2)) ]))) ;
    end;
    for e=1:max([DUOMENYS.VISU.Kanalu_koordinates_galvose{:,3}]) ;
        fwrite(fid, DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.h_galvai{i}(e,:));
        fprintf(fid, sprintf('\n'));
    end;
    fprintf(fid, sprintf('\n'));
    fclose(fid);

end;


end;

%% DUOMENŲ IŠSAUGOJIMAS

try
    cd(NewPath);
catch err;
    try
        cd(NewDir);
    catch err;
    end;
end;

disp(' ');
disp('Saugomi duomenys...');
disp( [ '[' pwd ']' ] );

if ~(isempty(find(ismember(Doc_tp, {'txt','TXT'})))) && ( Ar_reikia_galios_absoliucios || Ar_reikia_galios_santykines );
    
    %% Rezultatų po Stjudento eksportavimas
    
    if and(0,DUOMENYS.VISU.Salygu_N == 2) ;
        disp(Rezultatu_Stjudento);
        fid=fopen(Rezultatu_Stjudento, 'w');
        % Antraštė
        fprintf(fid, sprintf('Dazniu_sritys\tDazniu_sriciu_pav'));
        fprintf(fid, '\t%s', DUOMENYS.VISU.NORIMI_KANALAI{:});
        fprintf(fid, sprintf('\n'));
        % Absoliučios galios
        for i=1:DUOMENYS.VISU.Dazniu_sriciu_N;
            fprintf(fid, sprintf('%s\t%s', ...
                [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i} ], ...
                [    num2str(DUOMENYS.VISU.Dazniu_sritys{i}(1)) '_' ...
                num2str(DUOMENYS.VISU.Dazniu_sritys{i}(2)) ]));
            fprintf(fid, '\t%1.4g', DUOMENYS.VISU.Statistika_Stjudento_absol_galiai.p(i,:));
            fprintf(fid, sprintf('\n'));
        end;
        % Santykinės galios
        for i=2:length(DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.p(:,1));
            if i <= DUOMENYS.VISU.Dazniu_sriciu_N ;
                fprintf(fid, sprintf('%s\t%s', ...
                    [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i} skyriklis...
                    DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{1}], ...
                    [    num2str(DUOMENYS.VISU.Dazniu_sritys{i}(1)) '_' ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{i}(2)) skyriklis ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{1}(1)) '_' ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{1}(2)) ]));
            else
                e=DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N};
                fprintf(fid, sprintf('%s\t%s', ...
                    cell2mat(...
                    [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai( ...
                    DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(1)) skyriklis ...
                    DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(...
                    DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(2)) ]), ...
                    [    num2str(DUOMENYS.VISU.Dazniu_sritys{e(1)}(1)) '_' ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{e(1)}(2)) skyriklis ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{e(2)}(1)) '_' ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{e(2)}(2)) ]   )) ;
            end;
            fprintf(fid, '\t%1.4g', DUOMENYS.VISU.Statistika_Stjudento_santyk_galiai.p(i,:));
            fprintf(fid, sprintf('\n'));
        end ;
        fprintf(fid, sprintf('\n'));
        fclose(fid);
        
        
        %% Rezultatų po Vilkoksono eksportavimas
        
        fid=fopen(Rezultatu_Vilkoksono, 'w');
        disp(Rezultatu_Vilkoksono);
        % Antraštė
        fprintf(fid, sprintf('Dazniu_sritys\tDazniu_sriciu_pav'));
        fprintf(fid, '\t%s', DUOMENYS.VISU.NORIMI_KANALAI{:});
        fprintf(fid, sprintf('\n'));
        % Absoliučios galios
        for i=1:DUOMENYS.VISU.Dazniu_sriciu_N;
            fprintf(fid, sprintf('%s\t%s', ...
                [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i} ], ...
                [    num2str(DUOMENYS.VISU.Dazniu_sritys{i}(1)) '_' ...
                num2str(DUOMENYS.VISU.Dazniu_sritys{i}(2)) ]));
            fprintf(fid, '\t%1.4g', DUOMENYS.VISU.Statistika_Vilkoksono_absol_galiai.p(i,:));
            fprintf(fid, sprintf('\n'));
        end;
        % Santykinės galios
        for i=2:length(DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.p(:,1));
            if i <= DUOMENYS.VISU.Dazniu_sriciu_N ;
                fprintf(fid, sprintf('%s\t%s', ...
                    [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i} skyriklis...
                    DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{1}], ...
                    [    num2str(DUOMENYS.VISU.Dazniu_sritys{i}(1)) '_' ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{i}(2)) skyriklis ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{1}(1)) '_' ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{1}(2)) ]));
            else
                e=DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N};
                fprintf(fid, sprintf('%s\t%s', ...
                    cell2mat(...
                    [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai( ...
                    DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(1)) skyriklis ...
                    DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(...
                    DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(2)) ]), ...
                    [    num2str(DUOMENYS.VISU.Dazniu_sritys{e(1)}(1)) '_' ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{e(1)}(2)) skyriklis ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{e(2)}(1)) '_' ...
                    num2str(DUOMENYS.VISU.Dazniu_sritys{e(2)}(2)) ]   )) ;
            end;
            fprintf(fid, '\t%1.4g', DUOMENYS.VISU.Statistika_Vilkoksono_santyk_galiai.p(i,:));
            fprintf(fid, sprintf('\n'));
        end ;
        fprintf(fid, sprintf('\n'));
        fclose(fid);
        
    end ;
    
    
    %% Spektrinės galios eksportavimas į tekstinį failą
    disp([ Rezultatu_TXT_failas ' (galite atverti su MS Excel ar LibreOffice Calc)' ] );
    fid=fopen(Rezultatu_TXT_failas, 'w');
    % Antraštė
    if exist('lokaliz.m','file') == 2;
        fprintf(fid, sprintf([ lokaliz('Rinkmena') '\t' lokaliz('Salyga') '\t' lokaliz('Freq_int_name') '\t' lokaliz('Freq_interval') ] ));
    else
        fprintf(fid, sprintf('Rinkmena\tSalyga\tDazniu_int_pav\tDazniu_interv'));
    end;
    fprintf(fid, '\t%s', DUOMENYS.VISU.NORIMI_KANALAI{:});
    fprintf(fid, sprintf('\n'));
    for tir=1:DUOMENYS.VISU.Tiriamuju_N ;
        for sal=1:DUOMENYS.VISU.Salygu_N ;
            % Absoliučios galios
            if Ar_reikia_galios_absoliucios;
                for i=1:DUOMENYS.VISU.Dazniu_sriciu_N;
                    fprintf(fid, '%s\t%d\t%s\t%s', ...
                        DUOMENYS.VISU.Tiriamieji{tir}, sal , ...
                        [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i} ], ...
                        [num2str(DUOMENYS.VISU.Dazniu_sritys{i}(1)) '_' ...
                        num2str(DUOMENYS.VISU.Dazniu_sritys{i}(2)) ] );
                    fprintf(fid, '\t%.16g', DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,sal}(tir,:));
                    fprintf(fid, sprintf('\n'));
                end;
            end;
            % Santykinės galios
            if Ar_reikia_galios_santykines;
                for i=2:(DUOMENYS.VISU.Dazniu_sriciu_N + length(DUOMENYS.VISU.Papildomi_dazniu_santykiai));
                    if i <= DUOMENYS.VISU.Dazniu_sriciu_N ;
                        fprintf(fid, '%s\t%d\t%s\t%s', ...
                            DUOMENYS.VISU.Tiriamieji{tir}, sal, ...
                            [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{i} skyriklis...
                            DUOMENYS.VISU.Dazniu_sriciu_pavadinimai{1}], ...
                            [num2str(DUOMENYS.VISU.Dazniu_sritys{i}(1)) '_' ...
                            num2str(DUOMENYS.VISU.Dazniu_sritys{i}(2)) skyriklis ...
                            num2str(DUOMENYS.VISU.Dazniu_sritys{1}(1)) '_' ...
                            num2str(DUOMENYS.VISU.Dazniu_sritys{1}(2)) ]);
                    else
                        e=DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N};
                        fprintf(fid, '%s\t%d\t%s\t%s', ...
                            DUOMENYS.VISU.Tiriamieji{tir}, sal, ...
                            cell2mat(...
                            [DUOMENYS.VISU.Dazniu_sriciu_pavadinimai( ...
                            DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(1)) skyriklis ...
                            DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(...
                            DUOMENYS.VISU.Papildomi_dazniu_santykiai{i-DUOMENYS.VISU.Dazniu_sriciu_N}(2)) ]), ...
                            [num2str(DUOMENYS.VISU.Dazniu_sritys{e(1)}(1)) '_' ...
                            num2str(DUOMENYS.VISU.Dazniu_sritys{e(1)}(2)) skyriklis ...
                            num2str(DUOMENYS.VISU.Dazniu_sritys{e(2)}(1)) '_' ...
                            num2str(DUOMENYS.VISU.Dazniu_sritys{e(2)}(2)) ]  ) ;
                    end;
                    fprintf(fid, '\t%.16g', DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,sal}(tir,:));
                    fprintf(fid, sprintf('\n'));
                end;
            end;
        end;
    end;
    fclose(fid);
    
    try
        if exist(Rezultatu_TXT_failas,'file') == 2;
            open(Rezultatu_TXT_failas);
        end
    catch err;
        warning(err.message);
    end;
    
end;


if ~(isempty(find(ismember(Doc_tp, {'txt','TXT'})))) && ( Ar_reikia_spekro_absol || Ar_reikia_spekro_db );
    
    %% Spektro eksportavimas į tekstinį failą
    disp([ Rezultatu_TXT_failas_sp ' (galite atverti su MS Excel ar LibreOffice Calc)' ] );
    fid=fopen(Rezultatu_TXT_failas_sp, 'w');
    % Antraštė
    if exist('lokaliz.m','file') == 2;
        fprintf(fid, sprintf([ lokaliz('Rinkmena') '\t' lokaliz('Salyga') '\t' lokaliz('Vienetai') '\t' lokaliz('Channel') ] ));
        spektro_vienetai_uV2Hz=lokaliz('mikro voltai ^ 2 / Hz');
    else
        fprintf(fid, sprintf('Rinkmena\tSalyga\tVienetai\tKanalas'));
        spektro_vienetai_uV2Hz='mikroV^2/Hz';
    end;
    spektro_vienetai_db=[ '10*lg(' spektro_vienetai_uV2Hz ')' ];
    if mod(1/fft_tasku_herce, 1) == 0;
        hz_sar_trpmn = 0 ;
    elseif ismember(fft_tasku_herce, [2 5 10]);
        hz_sar_trpmn = 1 ;
    elseif fft_tasku_herce < 10 || ismember(fft_tasku_herce, [20 50 100]);
        hz_sar_trpmn = 2 ; 
    else
        hz_sar_trpmn = 1 + length(num2str(fft_tasku_herce)) ;
    end;
    hz_sar= [ '\t%.' num2str(hz_sar_trpmn) 'f' ];
    fprintf(fid, hz_sar, DUOMENYS.VISU.DAZNIAI');
    fprintf(fid, sprintf('\n'));
    spektro_tasku_N=length(DUOMENYS.VISU.DAZNIAI);
    for tir=1:DUOMENYS.VISU.Tiriamuju_N ;
        for sal=1:DUOMENYS.VISU.Salygu_N ;
            % Spektras, mikrovoltais
            if Ar_reikia_spekro_absol;
                for i=find(~isnan(DUOMENYS.VISU.SPEKTRAS_LENTELESE_microV2_Hz{tir,sal}(:,1)'));
                    fprintf(fid, '%s\t%d\t%s\t%s', ...
                        DUOMENYS.VISU.Tiriamieji{tir}, sal, spektro_vienetai_uV2Hz, DUOMENYS.VISU.NORIMI_KANALAI{i});
                    fprintf(fid, '\t%.16g', DUOMENYS.VISU.SPEKTRAS_LENTELESE_microV2_Hz{tir,sal}(i,1:spektro_tasku_N));
                    fprintf(fid, sprintf('\n'));
                end;
            end;
            if Ar_reikia_spekro_db;
                for i=find(~isnan(DUOMENYS.VISU.SPEKTRAS_LENTELESE_dB{tir,sal}(:,1)'));
                    fprintf(fid, '%s\t%d\t%s\t%s', ...
                        DUOMENYS.VISU.Tiriamieji{tir}, sal, spektro_vienetai_db, DUOMENYS.VISU.NORIMI_KANALAI{i});
                    fprintf(fid, '\t%.16g', DUOMENYS.VISU.SPEKTRAS_LENTELESE_dB{tir,sal}(i,1:spektro_tasku_N));
                    fprintf(fid, sprintf('\n'));
                end;
            end;
        end;
    end;
    fclose(fid);    
    
    try
        if exist(Rezultatu_TXT_failas_sp,'file') == 2;
            open(Rezultatu_TXT_failas_sp);
        end
    catch err;
        warning(err.message);
    end;
    
end;


%% Išsaugoti į MAT
if ~(isempty(find(ismember(Doc_tp, {'mat','MAT', 'matlab','MATLAB'}))));
disp(Rezultatu_MAT_failas);
save( Rezultatu_MAT_failas , 'DUOMENYS') ;
end;

try delete([Rezultatu_MAT_failas '~']) ; catch; end;
cd(orig_path);


%% Baigta

disp(' ');
toc ;
disp('Atlikta!');


function [varargout] = Tikras_Kelias(kelias_tikrinimui)
kelias_dabar=pwd;
try
    cd(kelias_tikrinimui);
catch err;
end;
varargout{1}=pwd;
cd(kelias_dabar);

