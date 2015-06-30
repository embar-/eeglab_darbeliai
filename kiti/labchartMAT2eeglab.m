function EEG_=labchartMAT2eeglab(LC_MAT)

[EEG_,~,~]=pop_newset([],[],[]);

if ischar(LC_MAT);
    LC_MAT=load(LC_MAT,'-mat');
end;

if ~isstruct(LC_MAT);
    error('LabChart MAT?');
end;
if length(unique(LC_MAT.samplerate))>1 ;
    error(['Sampling rate different: ' num2str(LC_MAT.samplerate)]);
end;

EEG_.setname='';
EEG_.icawinv=[];
EEG_.icaweights=[];
EEG_.icasphere=[];
EEG_.icaact = [];
EEG_.trials=1;
EEG_.xmin=0;

EEG_.srate=LC_MAT.samplerate(1);

Kanalu_N=size(LC_MAT.titles,1);
EEG_.nbchan=Kanalu_N;

%     if Kanalu_N > 1;
          Kanalai=cellfun(@(i) LC_MAT.titles(i,:), ...
              num2cell( 1:size(LC_MAT.titles,1)),...
              'UniformOutput',false);
%         KanaloNr=listdlg(...
%             'ListString',Kanalai,...
%             'SelectionMode','single',...
%             'PromptString',lokaliz('Please select channel'),...
%             'OKString',lokaliz('OK'),...
%             'CancelString',lokaliz('Cancel'));
%     else
%         KanaloNr=1;
%     end;


tsk=[];

for KanaloNr=1:Kanalu_N;
    prd=LC_MAT.datastart(KanaloNr);
    pab=LC_MAT.dataend(  KanaloNr);
    tsk=[tsk (pab-prd+1)];
    EEG_.data(KanaloNr,1:tsk(end))=LC_MAT.data(prd:pab);
    EEG_.chanlocs(KanaloNr).labels=Kanalai{KanaloNr};
end;
if length(unique(tsk))>1 ;
    error('internal error');
end;

EEG_.pnts=tsk(1);
EEG_.xmax=(EEG_.pnts - 1)/EEG_.srate + EEG_.xmin;

% Įvykiai
for i=1:size(LC_MAT.com,1);
    type=LC_MAT.comtext(LC_MAT.com(i,5),:);
    EEG_.event(i).type=regexprep(type,'[ ]*$','');
    EEG_.event(i).latency=LC_MAT.com(i,3) * ( 1000 / LC_MAT.tickrate );
end;

EEG_ = eeg_checkset( EEG_ );
