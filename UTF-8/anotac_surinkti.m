% [EDF_FAILAI,ann,comments]=anotac_surinkti
% tipas - tuscias - visos anotacijos

function [EDF_FAILAI,laikas_sekundemis,busenu_sarasas,sukurti_eeg_failai]=anotac_surinkti
KELIAS='D:\OSIMAS_EEG_polisomnogr\EDF+';
cd(KELIAS); laikas=datestr(now, 'yyyy-mm-dd_HHMMSS');
KELIAS_SAUG=['D:\OSIMAS_EEG_polisomnogr\EEGLAB\' laikas ];
mkdir(KELIAS_SAUG);
% Paimkim pirmus 20 zmoniu. Ju amzius 25-34 m.
DUOMENYS=[dir('SC40*-PSG.edf') ; dir('SC41*-PSG.edf')];
%busenos={'Sleep_stage_R' 'Sleep_stage_4'};
busenos={'Sleep_stage_W'};
busenu_sarasas={};
laikas_milisekundemis={}; laikas_100sekundemis={}; laikas_sekundemis={};
sukurti_eeg_failai={};

EDF_FAILAI={DUOMENYS.name};

EDF_header=struct('ver',{},'patientID',{},'recordID',{},...
    'startdate',{},'starttime',{},'length',{},'reserved',{},...
	'records',{},'duration',{},'channels',{},...
	'labels',{},'transducer',{},'units',{},...
	'physmin',{},'physmax',{},'digmin',{},...
	'digmax',{},'prefilt',{},'samplerate',{});

for i=1:length(EDF_FAILAI);
    EDF_FAILAS=EDF_FAILAI{i};
    [laikas_100sekundemis{i},~,~,~,~,busenu_sarasas{i}]=rdann(EDF_FAILAS,'hyp');
    laikas_milisekundemis{i}=10*(laikas_100sekundemis{i} - 1 );
    laikas_sekundemis{i}=0.001*laikas_milisekundemis{i};
    
    
    for b=1:length(busenos)
        busena=busenos{b};
        
        disp(' ');
        disp([ '==' EDF_FAILAS ' ' busena '==' ]);
        
        interv_idx=find(ismember([busenu_sarasas{i}{:}],busena)==1);
       
        fid=fopen(EDF_FAILAS,'r','ieee-le');
        hdr=char(fread(fid,256,'uchar')');
        EDF_header(i).ver=str2num(hdr(1:8));            % 8 ascii : version of this data format (0)
        EDF_header(i).patientID  = char(hdr(9:88));     % 80 ascii : local patient identification
        EDF_header(i).recordID  = char(hdr(89:168));    % 80 ascii : local recording identification
        EDF_header(i).startdate=char(hdr(169:176));     % 8 ascii : startdate of recording (dd.mm.yy)
        EDF_header(i).starttime  = char(hdr(177:184));  % 8 ascii : starttime of recording (hh.mm.ss)
        EDF_header(i).length = str2num(hdr(185:192));  % 8 ascii : number of bytes in EDF_header(i) record
        EDF_header(i).reserved = hdr(193:236); % [EDF+C       ] % 44 ascii : reserved
        EDF_header(i).records = str2num(hdr(237:244)); % 8 ascii : number of data records (-1 if unknown)
        EDF_header(i).duration = str2num(hdr(245:252)); % 8 ascii : duration of a data record, in seconds
        EDF_header(i).channels = str2num(hdr(253:256));% 4 ascii : number of signals (ns) in data record
        
        EDF_header(i).labels=cellstr(char(fread(fid,[16,EDF_header(i).channels],'char')')); % ns * 16 ascii : ns * label (e.g. EEG FpzCz or Body temp)
        EDF_header(i).transducer =cellstr(char(fread(fid,[80,EDF_header(i).channels],'char')')); % ns * 80 ascii : ns * transducer type (e.g. AgAgCl electrode)
        EDF_header(i).units = cellstr(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * physical dimension (e.g. uV or degreeC)
        EDF_header(i).physmin = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * physical minimum (e.g. -500 or 34)
        EDF_header(i).physmax = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * physical maximum (e.g. 500 or 40)
        EDF_header(i).digmin = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * digital minimum (e.g. -2048)
        EDF_header(i).digmax = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * digital maximum (e.g. 2047)
        EDF_header(i).prefilt =cellstr(char(fread(fid,[80,EDF_header(i).channels],'char')')); % ns * 80 ascii : ns * prefiltering (e.g. HP:0.1Hz LP:75Hz)
        EDF_header(i).samplerate = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * nr of samples in each data record

        fclose(fid);
        
        norimu_kanalu_idx=find( ismember(EDF_header(i).labels,{'EEG Fpz-Cz' 'EEG Pz-Oz' 'EOG horizontal' 'EMG submental'}) == 1);
        
        [ALLEEG_,EEG_,~]= pop_newset([],[],[]);
        
        for x=1:length(interv_idx);
            laikas_nuo=laikas_sekundemis{i}(interv_idx(x));
            if interv_idx(x) < length(busenu_sarasas{i});
                laikas_iki=laikas_sekundemis{i}(interv_idx(x) + 1);
            else
                laikas_iki=EDF_header(i).duration * EDF_header(i).records;            
            end;
            
            trukme=laikas_iki - laikas_nuo;
            
            disp(' ');
            disp(['nuo ' num2str(laikas_nuo) ' iki ' num2str(laikas_iki) ' (' num2str(trukme) ' s)']);
            
            if trukme > 119;
                
                EEG_failas=[ regexprep(EDF_FAILAS,'.edf$','') '_' busena '_' num2str(x) '.set' ];
                                
                EEG_ = pop_biosig(fullfile(KELIAS,EDF_FAILAS), 'channels',[1:3 5] ,'blockrange',[laikas_nuo laikas_iki] );
                [ALLEEG_ EEG_ CURRENTSET_] = pop_newset(ALLEEG_, EEG_, 0,'savenew', fullfile(KELIAS_SAUG,EEG_failas),'gui','off');
                
                e_i=1+size(sukurti_eeg_failai,1);
                sukurti_eeg_failai{e_i,1}=EEG_failas;
                sukurti_eeg_failai{e_i,2}=EDF_FAILAS;
                sukurti_eeg_failai{e_i,3}=laikas_nuo;
                sukurti_eeg_failai{e_i,4}=laikas_iki;
                sukurti_eeg_failai{e_i,5}=trukme;
                
                
                ALLEEG_=[];
                EEG_ =[];            
            end;
            
        end;
        
%         EEG = pop_mergeset( ALLEEG, [1:length(interv_idx)], 0);
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'savenew', fullfile(KELIAS,[ EDF_FAILAS '_' busena '.set' ]),'gui','off');
        
        
    end;
    save(fullfile('D:\OSIMAS_EEG_polisomnogr\EEGLAB',['info_' laikas '.mat~']),...
    'EDF_FAILAI','laikas_sekundemis','busenu_sarasas','busenos','sukurti_eeg_failai','EDF_header');
end;

save(fullfile('D:\OSIMAS_EEG_polisomnogr\EEGLAB',['info_' laikas '.mat']),...
    'EDF_FAILAI','laikas_sekundemis','busenu_sarasas','busenos','sukurti_eeg_failai','EDF_header');

return 
%%

% laikas_nuo ir laikas_iki - laiko intervalas importavimui sekundemis
EEG = pop_biosig(fullfile(KELIAS,EDF_FAILAS), 'channels',[1:3 5] ,'blockrange',[laikas_nuo laikas_iki] );

