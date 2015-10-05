% sablonas_paprastas(KELIAS, FAILAI)

%
% (C) 2014 Mindaugas Baranauskas
%
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


