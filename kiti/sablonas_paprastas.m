% sablonas_paprastas(KELIAS, FAILAI)

function sablonas_paprastas(varargin)

if nargin > 0;     
    PathName=varargin{1};
else
    PathName = ''; 
end;
if nargin > 1;     
    FileNames=varargin{2};
else
    FileNames='*.set;*.cnt';
end;


t=datestr(now, 'yyyy-mm-dd_HHMMSS'); disp(t);
NewDir=['Nauji_'  '_' t] ;
orig_path=pwd;
if or(isempty(FileNames),isempty(PathName));    
    % Duomenu ikelimui:
    [FileNames,PathName,FilterIndex] = uigetfile({'*.set','EEGLAB duomenys';'*.cnt','ASA LAB EEG duomenys';'*.*','Visi failai'},'Pasirinkite duomenis','','MultiSelect','on');
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
NewPath=fullfile(PathName, NewDir);
mkdir(NewPath);

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

NumberOfFiles=length(FileNames);
for i=1:NumberOfFiles ;
    
    % Isimink laika  - veliau bus galimybe paziureti, kiek laiko uztruko
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    %tic ;
    
    File=FileNames{i} ;
    disp(File);
    
    [KELIAS_,Rinkmena_,galune]=fileparts(fullfile(PathName,File));
    disp(fullfile(PathName,File));
    Rinkmena_=[Rinkmena_ galune];
    KELIAS_=Tikras_Kelias(KELIAS_);
    
    if FilterIndex == 1 ;
        %EEG = pop_loadset('filename',File);        
        EEG = pop_loadset('filename',Rinkmena_,'filepath',KELIAS_);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( [], EEG, 0 );
    elseif FilterIndex == 2 ;
        % Importuoti
        EEG=pop_fileio(fullfile(KELIAS_,Rinkmena_));
    else
        try
            EEG = pop_loadset('filename',Rinkmena_,'filepath',KELIAS_);
            [ALLEEG, EEG, CURRENTSET] = eeg_store( [], EEG, 0 );
        catch err ;
            try
                % Importuoti
                EEG=pop_fileio(fullfile(KELIAS_,Rinkmena_));
            catch err ;
            end;
        end;
    end;
    
    EEG = eeg_checkset( EEG );
    
	% Issaugoti
	[ALLEEG, EEG, CURRENTSET] = pop_newset([], EEG, 0,'savenew', fullfile(NewPath,Rinkmena_),'gui','off');
	
    % Isvalyti atminti
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
    %eeglab redraw;
    
    str=(sprintf('Apdorotas %d/%d(%3.2f%%): %s\r\n', i, NumberOfFiles, i/NumberOfFiles*100, File )) ;
    disp(str);
    % Parodyk, kiek laiko uztruko
    %t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    %toc ;
    
    
end ;



%% Baigta

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


