%
%
%
%
%
% EEG + EKG tyrinėjimui
%
% GUI versija
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

function varargout = pop_QRS_i_EEG(varargin)
% POP_QRS_I_EEG MATLAB code for pop_QRS_i_EEG.fig
%      POP_QRS_I_EEG, by itself, creates a new POP_QRS_I_EEG or raises the existing
%      singleton*.
%
%      H = POP_QRS_I_EEG returns the handle to a new POP_QRS_I_EEG or the handle to
%      the existing singleton*.
%
%      POP_QRS_I_EEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_QRS_I_EEG.M with the given input arguments.
%
%      POP_QRS_I_EEG('Property','Value',...) creates a new POP_QRS_I_EEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_QRS_i_EEG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_QRS_i_EEG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_QRS_i_EEG

% Last Modified by GUIDE v2.5 20-Nov-2014 20:38:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_QRS_i_EEG_OpeningFcn, ...
    'gui_OutputFcn',  @pop_QRS_i_EEG_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before pop_QRS_i_EEG is made visible.
function pop_QRS_i_EEG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_QRS_i_EEG (see VARARGIN)

set(handles.figure1,'Name',mfilename);

%Įsimink prieš funkcijų vykdymą buvusį kelią; netrukus bandysime laikinai pakeisti kelią
Kelias_dabar=pwd;

if isempty(get(handles.text_koduote,'String'))
    set(handles.text_koduote,'String',feature('DefaultCharacterSet'));
end;

tic;

lokalizuoti(hObject, eventdata, handles);

% global STUDY CURRENTSTUDY ALLEEG EEG CURRENTSET PLUGINLIST Rinkmena NaujaRinkmena KELIAS KELIAS_SAUGOJIMUI SaugomoNr;


disp(' ');
disp('===================================');
disp('        E E G   +   E K G      ');
disp(' ');

try
    tmp_mat=fullfile(tempdir,'tmp.mat');
    load(tmp_mat);
    %disp(g);
    cd(g.path{1});
    if ~isempty(g.files);
        set(handles.listbox2,'String',g.files);
        %set(handles.edit_failu_filtras2,'Style','pushbutton');
        edit_failu_filtras2_ButtonDownFcn(hObject, eventdata, handles);
    end;
    delete(tmp_mat);
catch err;
end;


set(handles.pushbutton_v1,'UserData',{});
set(handles.pushbutton_v2,'UserData',{});
set(handles.pushbutton_v3,'UserData',{});

atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);

KELIAS=pwd;

% Sugrįžk į kelią prieš šios funkcijos atvėrimą
cd(Kelias_dabar);

% Patikrink kelią duomenų išsaugojimui
set(handles.edit2,'String','');
edit2_Callback(hObject, eventdata, handles);

%STUDY = []; CURRENTSTUDY = 0; %ALLEEG = []; EEG=[]; CURRENTSET=[];
%if isempty(findobj('-regexp','name','EEGLAB.*'));
%    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab ;
%end;
%[ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);

%eeglab('redraw');
set(handles.edit_failu_filtras1,'String','*.set;*.cnt;*.edf');

atnaujink_rodomus_failus(hObject, eventdata, handles);

%susaldyk(hObject, eventdata, handles);

susildyk(hObject, eventdata, handles);

tic;

% Choose default command line output for pop_QRS_i_EEG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_QRS_i_EEG wait for user response (see UIRESUME)
% uiwait(handles.figure1);






% --- Outputs from this function are returned to the command line.
function varargout = pop_QRS_i_EEG_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function lokalizuoti(hObject, eventdata, handles)
set(handles.pushbutton1,'String',lokaliz('Execute'));
set(handles.pushbutton2,'String',lokaliz('Close'));
set(handles.pushbutton4,'String',lokaliz('Update'));
set(handles.pushbutton_ivykiai,'String',lokaliz('QRS event...'));
set(handles.pushbutton_kanal,'String',lokaliz('EKG channel...'));
set(handles.uipanel3,'Title',lokaliz('Options'));
set(handles.uipanel4,'Title',lokaliz('File filter'));
set(handles.uipanel5,'Title',lokaliz('Files for work'));
set(handles.uipanel23,'Title',lokaliz('Suffix and subdirectory'));
set(handles.text19,'String', lokaliz('# of done jobs for subdir names'));
set(handles.uipanel15,'Title',lokaliz('File loading options'));
set(handles.uipanel16,'Title',lokaliz('File saving options'));
set(handles.uipanel17,'Title',' ');
set(handles.uipanel18,'Title',' ');
set(handles.radiobutton6,'String',lokaliz('through data'));
set(handles.radiobutton7,'String',lokaliz('through functions'));
set(handles.text7,'String', lokaliz('After interim saved job go'));
set(handles.text24,'String', [lokaliz('Time interval') ' '  lokaliz('(miliseconds_short)') ]);
set(handles.text_failu_filtras1,'String',lokaliz('Show_filenames_filter:'));
set(handles.text_failu_filtras2,'String',lokaliz('Select_filenames_filter:'));
set(handles.checkbox_uzverti_pabaigus,'String',lokaliz('Close when complete'));
set(handles.checkbox_baigti_anksciau,'String',lokaliz('Break work'));
set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'String',lokaliz('Go to saved files directory when completed'));
set(handles.checkbox_pabaigus_atverti,'String',lokaliz('Load saved files in EEGLAB when completed'));
set(handles.checkbox_QRS_aptikimas,'String',lokaliz('Insert ECG QRS events to EEG. Source:'));
set(handles.checkbox_QRS_korekcija,'String',lokaliz('EKG/RRI review and QRS correction'));
set(handles.checkbox_trint_EKG,'String',lokaliz('Remove EKG channel'));
set(handles.checkbox_eksp_Rlaikus,'String',lokaliz('Export R times (1 column in file, times in ms)'));
set(handles.checkbox_eksp_RRI,'String',lokaliz('Export RRI (suitable for KubiosHRV)'));

set(handles.popupmenu_QRS_saltinis,'String',...
    {lokaliz('EKG tarp EEG kan'),...
     lokaliz('TXT su R'),...
     lokaliz('LabChart MAT')});

set(handles.popupmenu_QRS_algoritmas,'String',...
    {lokaliz('Pan-Tompkin (1985), pg. Sedghamiz (2014)'), ...
     lokaliz('Ramakrishnan et al. (2014)'), ...
     lokaliz('Suppappola-Sun (1994), ECGlab2.0'), ...
     lokaliz('adaptyvus Sedghamiz (2014) algoritmas'), ...
     lokaliz('adaptyvus algoritmas, fMRIb2.00')});


 
 

function Palauk()

f = warndlg(sprintf('Ar tikrai galime eiti prie kito darbo?'), 'Dėmesio!');
disp('Ar tikrai peržiūrėjote duomenis? Eisime prie kitų darbų.');
drawnow     % Necessary to print the message
waitfor(f);
disp('Einama toliau...');






% Atnaujink rodoma kelia
function atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles)
kelias_orig=pwd;
try
    cd(get(handles.edit1,'String'));
catch err;
    try
        cd(Tikras_Kelias(get(handles.edit1,'TooltipString')));
    catch err;
    end;
end;
set(handles.edit1,'String',pwd);
set(handles.edit1,'TooltipString',pwd);
set(handles.pushbutton_v1,'UserData',...
    unique([get(handles.pushbutton_v1,'UserData') kelias_orig {pwd}]));
cd(kelias_orig);
set(handles.edit1,'BackgroundColor',[1 1 1]);


% Atnaujink rodomus failus
function atnaujink_rodomus_failus(hObject, eventdata, handles)
set(handles.listbox1,'UserData',{});
Kelias_dabar=pwd;
cd(get(handles.edit1,'String'));
%cd(Tikras_Kelias(get(handles.edit1,'String')));
%set(handles.edit1,'String',pwd);
FAILAI={};
FAILAI=filter_filenames(get(handles.edit_failu_filtras1,'String'));

if isempty(FAILAI);
    %FAILAI(1).name='';
    set(handles.listbox1,'Max',0);
    set(handles.listbox1,'Value',[]);
    set(handles.listbox1,'SelectionHighlight','off');
    %set(handles.uipanel5,'Title','Apdorotini failai: nėra');
else
    if strcmp(get(handles.edit_failu_filtras2,'Style'),'edit') ;
        %FAILAI_filtruoti=dir(get(handles.edit_failu_filtras2,'String'));
        %FAILAI_filtruoti_={FAILAI_filtruoti.name};
        FAILAI_filtruoti_=atrinkti_teksta(FAILAI,get(handles.edit_failu_filtras2,'String'));
    else
        FAILAI_filtruoti_=FAILAI;
        try
            FAILAI_filtruoti_=get(handles.listbox2,'String');
        catch err;
            Pranesk_apie_klaida(err, 'Apdorotų duomenų pasirinkimas', '')
        end;
    end;
    set(handles.listbox1,'Max',length(FAILAI));
    Pasirinkti_failu_indeksai=find(ismember(FAILAI,intersect(FAILAI_filtruoti_,FAILAI)));
    if and(isempty(Pasirinkti_failu_indeksai),length(FAILAI)==1);
        set(handles.listbox1,'Value',1);
    else
        set(handles.listbox1,'Value',Pasirinkti_failu_indeksai);
    end;
    set(handles.listbox1,'SelectionHighlight','on');
    %set(handles.uipanel5,'Title', ['Apdorotini failai: ' num2str(length(Pasirinkti_failu_indeksai)) '/' num2str(length(FAILAI) )]);
end;
cd(Kelias_dabar);

set(handles.listbox1,'String',FAILAI);

%disp(get(handles.listbox1,'String'));
QRS_saltino_galunes(hObject, eventdata, handles);

Ar_galima_vykdyti(hObject, eventdata, handles);


function susaldyk(hObject, eventdata, handles)
% Neleisk nieko daryti
set(handles.pushbutton1,'Value',0);
set(handles.listbox1,'Enable','inactive');
set(handles.edit1,'Enable','off');
set(handles.edit2,'Enable','off');
set(handles.text_atlikta_darbu,'Enable','off');
set(handles.pushbutton1,'Enable','off');
%set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton3,'Enable','off');
set(handles.pushbutton4,'Enable','off');
set(handles.edit_failu_filtras1,'Enable','off');
set(handles.edit_failu_filtras2,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.radiobutton6,'Enable','off');
set(handles.radiobutton7,'Enable','off');

set(handles.edit_laiko_intervalas,'Enable','off');
set(handles.edit_ivykiai,'Enable','off');
set(handles.pushbutton_ivykiai,'Enable','off');
set(handles.pushbutton_kanal,'Enable','off');
set(handles.pushbutton_v1,'Enable','off');
set(handles.pushbutton_v2,'Enable','off');
set(handles.pushbutton_v3,'Enable','off');

set(handles.edit_QRS_ivykis,'Enable','off');
set(handles.checkbox_QRS_aptikimas,'Enable','off');
set(handles.checkbox_QRS_korekcija,'Enable','off');
set(handles.checkbox_eksp_Rlaikus,'Enable','off');
set(handles.checkbox_eksp_RRI,'Enable','off');
set(handles.checkbox_trint_EKG,'Enable','off');

checkbox_QRS_aptikimas_Callback(hObject, eventdata, handles);
checkbox_QRS_korekcija_Callback(hObject, eventdata, handles);
checkbox_eksp_Rlaikus_Callback(hObject, eventdata, handles);
checkbox_eksp_RRI_Callback(hObject, eventdata, handles);
checkbox_trint_EKG_Callback(hObject, eventdata, handles);

set(handles.checkbox_baigti_anksciau,'Value',0);
set(handles.checkbox_baigti_anksciau,'Visible','on');
%set(handles.checkbox_pabaigus_atverti,'Value',0);
set(handles.checkbox_pabaigus_atverti,'Visible','on');

set(handles.text_darbas,'String',' ');



function susildyk(hObject, eventdata, handles)
% Vel leisk ka nors daryti

set(handles.pushbutton1,'Value',1);
set(handles.listbox1,'Enable','on');
set(handles.edit1,'Enable','on');
set(handles.edit2,'Enable','on');
set(handles.text_atlikta_darbu,'Enable','on');

set(handles.pushbutton2,'Enable','on');
set(handles.pushbutton3,'Enable','on');
set(handles.pushbutton4,'Enable','on');
set(handles.edit_failu_filtras1,'Enable','on');
set(handles.edit_failu_filtras2,'Enable','on');
set(handles.pushbutton6,'Enable','on');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','on');


set(handles.edit_laiko_intervalas,'Enable','on');
set(handles.edit_ivykiai,'Enable','on');
set(handles.pushbutton_ivykiai,'Enable','on');
set(handles.pushbutton_kanal,'Enable','on');
set(handles.pushbutton_v1,'Enable','on');
set(handles.pushbutton_v2,'Enable','on');
set(handles.pushbutton_v3,'Enable','on');

set(handles.edit_QRS_ivykis,'Enable','on');
set(handles.checkbox_QRS_aptikimas,'Enable','on');
set(handles.checkbox_QRS_korekcija,'Enable','on');
set(handles.checkbox_eksp_Rlaikus,'Enable','on');
set(handles.checkbox_eksp_RRI,'Enable','on');
set(handles.checkbox_trint_EKG,'Enable','on');

checkbox_QRS_aptikimas_Callback(hObject, eventdata, handles);
checkbox_QRS_korekcija_Callback(hObject, eventdata, handles);
checkbox_eksp_Rlaikus_Callback(hObject, eventdata, handles);
checkbox_eksp_RRI_Callback(hObject, eventdata, handles);
checkbox_trint_EKG_Callback(hObject, eventdata, handles);

uipanel15_SelectionChangeFcn(hObject, eventdata, handles);

%Vykdymo mygtukas
Ar_galima_vykdyti(hObject, eventdata, handles);

%
set(handles.checkbox_baigti_anksciau,'Visible','off');
set(handles.checkbox_pabaigus_atverti,'Visible','on');

%Vidinis atliktų darbų skaitliukas
set(handles.text_atlikta_darbu,'String',num2str(0));

set(handles.text_darbas,'Visible','off');
set(handles.text_darbas,'String',' ');

set(handles.pushbutton2,'Value',0);



function Ar_galima_vykdyti(hObject, eventdata, handles)

set(handles.pushbutton1,'Enable','off');
if isempty(get(handles.listbox1,'String'));
    drawnow; return;
end;
if get(handles.listbox1,'Value') == 0;
    drawnow; return;
end;
Pasirinkti_failu_indeksai=(get(handles.listbox1,'Value'));
if isempty(Pasirinkti_failu_indeksai);
    drawnow; return;
end;
if get(handles.edit1,'BackgroundColor') == [1 1 0];
    drawnow; return;
end;
if get(handles.edit2,'BackgroundColor') == [1 1 0];
    drawnow; return;
end;
if get(handles.edit_failu_filtras1,'BackgroundColor') == [1 1 0];
    drawnow; return;
end;
if get(handles.edit_failu_filtras2,'BackgroundColor') == [1 1 0];
    drawnow; return;
end;
% if isempty(get(handles.edit_ivykiai,'UserData'));
%     set(handles.edit_ivykiai,'BackgroundColor', [1 1 0]);
%     return;
% end;
% if isempty(get(handles.edit_laiko_intervalas,'UserData'));
%     set(handles.edit_laiko_intervalas,'BackgroundColor', [1 1 0]);
%     return;
% end;

set(handles.pushbutton1,'Enable','on');
drawnow;


function Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N)

disp(' ');
NaujaAntraste=[ num2str(DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.'];
disp(NaujaAntraste);
disp(Darbo_apibudinimas);
set(handles.text_darbas,'Visible','on');
set(handles.text_darbas,'String',[ NaujaAntraste ' ' Darbo_apibudinimas ] );
%set(handles.uipanel6,'Title', NaujaAntraste);
drawnow;
%uiwait(gcf,1);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



Ar_galima_vykdyti(hObject, eventdata, handles);

if strcmp(get(handles.pushbutton1,'Enable'),'off');
    return;
end;

%

disp(' ');
disp('===================================');
t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
disp('===================================');
disp(' ');


global STUDY CURRENTSTUDY ALLEEG EEG CURRENTSET Rinkmena NaujaRinkmena KELIAS KELIAS_SAUGOJIMUI SaugomoNr;

susaldyk(hObject, eventdata, handles);
set(handles.pushbutton1,'Enable','off');
drawnow;
%guidata(hObject, handles);


%if get(handles.checkbox55,'Value');
%    NewDir=get(handles.edit60,'String');
%else
NewDir='';
%end;


Pasirinkti_failu_indeksai=(get(handles.listbox1,'Value'));
Rodomu_failu_pavadinimai=(get(handles.listbox1,'String'));
Pasirinkti_failu_pavadinimai=Rodomu_failu_pavadinimai(Pasirinkti_failu_indeksai);
Pasirinktu_failu_N=length(Pasirinkti_failu_pavadinimai);
set(handles.listbox2,'String',Pasirinkti_failu_pavadinimai);
t=datestr(now, 'yyyy-mm-dd_HHMMSS');
%set(handles.listbox2,'String',{''});
disp(' ');
disp(['Dirbsima su:']);
for i=1:Pasirinktu_failu_N;
    disp(Pasirinkti_failu_pavadinimai{i});
end;
disp(' ');

KELIAS=Tikras_Kelias(get(handles.edit1,'String'));
KELIAS_SAUGOJIMUI=Tikras_Kelias(get(handles.edit2,'String'));

disp('Apdoroti duomenys rašysimi į ');
disp(fullfile(KELIAS_SAUGOJIMUI,NewDir));
disp(' ');

%STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
%[ALLEEG EEG CURRENTSET ALLCOM] = eeglab ;
%eeglab redraw ;
%[ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);

% Isimink laika  - veliau bus galimybe paziureti, kiek laiko uztruko
tic

DarboNr=0;
PaskutinioIssaugotoDarboNr=0;
Apdoroti_visi_tiriamieji=0;
sukauptos_klaidos={};

%axes(handles.axes1);
%datacursormode off;

%Ivykiai=str2num(get(handles.edit_ivykiai,'String'));
%ribos=str2num(get(handles.edit_laiko_intervalas,'String'));%*1000;

[~,ALLEEG_,~]=pop_newset([],[],[]);
ALLEEG_=setfield(ALLEEG_,'datfile',[]);
ALLEEG_=setfield(ALLEEG_,'chanlocs2',[]);
%mūsų papildymas:
ALLEEG_=setfield(ALLEEG_,'file','');
%ALLEEG_=setfield(ALLEEG_,'erp_data',[]);
ALLEEG_=setfield(ALLEEG_,'chans',{});

% ALLEEGTMP nevisai atitiks ALLEEG, nes ALLEEGTMP kuriamas jau atrinkus įvykius, turi 'erp_data'
ALLEEGTMP=get(handles.listbox1,'UserData');
if isempty(ALLEEGTMP);
    %ALLEEGTMP=struct('file',{},'erp_data',{},'times',{},'chanlocs',{});
    ALLEEGTMP=ALLEEG_;
end;

legendoje={};

%% Pagrindiniai darbai

for i=1:Pasirinktu_failu_N;
    Rinkmena=Pasirinkti_failu_pavadinimai{i};
    [KELIAS_,Rinkmena_,galune]=fileparts(fullfile(KELIAS,Rinkmena));
    Rinkmena_=[Rinkmena_ galune];
    KELIAS_=Tikras_Kelias(KELIAS_);
    NaujaRinkmena=Rinkmena_;
    disp(' ');
    disp(' ');
    disp(sprintf(' === %d/%d (%.2f%%) %s ===', i, Pasirinktu_failu_N, i/Pasirinktu_failu_N*100, Rinkmena));
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    SaugomoNr=1+str2num(get(handles.text_atlikta_darbu,'String'));
    DarboNr=0;
    DarboPorcijaAtlikta=0;
    PaskutinioIssaugotoDarboNr=0;
    PaskRinkmIssaugKelias=KELIAS;
    
    % Įkelti
    Darbo_eigos_busena(handles, 'Įkeliama...', DarboNr, i, Pasirinktu_failu_N);
    
    try
        EEG = pop_loadset('filename',Rinkmena_,'filepath',KELIAS_);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    catch err;
        try
            % Importuoti
            EEG=pop_biosig(fullfile(KELIAS_, Rinkmena_));
        catch err;
            try
                % Importuoti
                EEG=pop_fileio(fullfile(KELIAS_, Rinkmena_));
            catch err;
                try
                    % Importuoti
                    load(fullfile(KELIAS_, Rinkmena_),'-mat');
                catch err;
                end;
            end;
        end;
    end;
    
    %uiwait(gcf,1);
    
    
    if ~isempty(EEG);
        
        EEG = eeg_checkset( EEG );
        
        newEEGlabEvents_poslinkis=[];
        newEEGlabEvents_paklaidos=[];
        
        % QRS aptikimas
        Darbo_apibudinimas=lokaliz('Detecting QRS...');
        if get(handles.checkbox_QRS_aptikimas,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, ~isempty(EEG.data)));
                
                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);
                
                try
                   
                    QRS_ivykis=get(handles.edit_QRS_ivykis,'String');
                    
                    switch get(handles.popupmenu_QRS_saltinis,'Value')                        
                        case 1 
                            % EKG yra viename iš EEG kanalų. Naudojamas QRS aptikimo algoritmas
                            QRS_algoritmas=get(handles.popupmenu_QRS_algoritmas,'Value');
                            Reikalingas_kanalas=get(handles.text_kanal,'TooltipString');
                            if isempty(Reikalingas_kanalas);
                                error('Kanalas?');
                            end;
                            EKG_kanalas=find(ismember({EEG.chanlocs.labels},Reikalingas_kanalas)==1);
                            EEG=QRS_is_EEG(EEG,EKG_kanalas,QRS_ivykis,QRS_algoritmas,0);
                            
                        case 2
                            % R laikus importuoti iš tekstinio failo
                            QRS_kelias=get(handles.edit_QRS_saltinis,'String');
                            QRS_rinkmenos_galas=get(handles.popupmenu_QRS_saltinio_galune,'TooltipString');
                            
                            [~,QRS_rinkmena1,~]=fileparts(NaujaRinkmena); % fileparts(Rinkmena_);
                            QRS_rinkmena2=fullfile(QRS_kelias, QRS_rinkmena1  )  ;  
                            
                            QRS_rinkmena=[QRS_rinkmena2 QRS_rinkmenos_galas];
                            
                            if ~exist(QRS_rinkmena,'file');                                   
                                disp(' ');
                                warning([QRS_rinkmena ' ?']);
                                QRS_rinkmena=filter_filenames([QRS_rinkmena2 '*' ]);                                
                                QRS_rinkmenos_galai=regexprep(QRS_rinkmena,QRS_rinkmena2,'');
                                %
                                netinkami_regexp={[ '^.*' galune '$' ] '^.*\.set$' '^.*\.fdt$' '^.*\.ica$' '^.*\.cnt$' };
                                netinkami={};
                                for y=1:length(netinkami_regexp);
                                    netinkami_tmp=regexp(QRS_rinkmenos_galai,netinkami_regexp{y},'match');
                                    netinkami_tmp=[netinkami_tmp{:}];
                                    netinkami={netinkami{:} netinkami_tmp{:}};
                                end;
                                QRS_rinkmenos_galai=QRS_rinkmenos_galai(find(...
                                    ismember(QRS_rinkmenos_galai, netinkami)==0));
                                %
                                if isempty(QRS_rinkmenos_galai);
                                    error('EKG QRS info?');
                                elseif length(QRS_rinkmenos_galai) == 1;
                                    QRS_rinkmena=[QRS_rinkmena2 QRS_rinkmenos_galai{1}];
                                    warning([QRS_rinkmena ' !']);
                                    disp(' ');
                                else
                                    warning(sprintf('\n%s ? ',QRS_rinkmenos_galai{:}));
                                    disp(' ');
                                    error('EKG QRS info?');
                                end;
                            end;
                            
                            laikai=num2cell(dlmread(QRS_rinkmena));
                            ivykiai(1:length(laikai),1)={QRS_ivykis};
                            
                            EEG = pop_importevent( EEG, 'append','yes',...
                                'event', [ivykiai laikai],...
                                'fields',{'type' 'latency'}, ...
                                'timeunit',0.001);
                            
                        case 3
                            % Naudoti per Labchart gautus laikus R laikus 
                            QRS_kelias=get(handles.edit_QRS_saltinis,'String');
                            QRS_rinkmenos_galas=get(handles.popupmenu_QRS_saltinio_galune,'TooltipString');                            
                            
                            [~,QRS_rinkmena1,~]=fileparts(NaujaRinkmena); % fileparts(Rinkmena_);
                            QRS_rinkmena2=fullfile(QRS_kelias, QRS_rinkmena1  )  ;  
                            
                            QRS_rinkmena=[QRS_rinkmena2 QRS_rinkmenos_galas];
                            
                            if ~exist(QRS_rinkmena,'file');                                   
                                disp(' ');
                                warning([QRS_rinkmena ' ?']);
                                QRS_rinkmena=filter_filenames([QRS_rinkmena2 '*' ]);                                
                                QRS_rinkmenos_galai=regexprep(QRS_rinkmena,QRS_rinkmena2,'');                                
                                QRS_rinkmenos_galai=regexp(QRS_rinkmenos_galai,'^.*\.mat$','match');
                                QRS_rinkmenos_galai=[QRS_rinkmenos_galai{:}];                                    
                                if isempty(QRS_rinkmenos_galai);
                                    error('EKG QRS info?');
                                elseif length(QRS_rinkmenos_galai) == 1;
                                    QRS_rinkmena=[QRS_rinkmena2 QRS_rinkmenos_galai{1}];
                                    warning([QRS_rinkmena ' !']);
                                    disp(' ');
                                else
                                    warning(sprintf('\n%s ? ',QRS_rinkmenos_galai{:}));
                                    disp(' ');
                                    error('EKG QRS info?');
                                end;
                            end;
                            
                            % Įkelti iš LabChart į MATLAB eksportuotus duomenis
                            Labchart_data=load(QRS_rinkmena) ;
                            
                            % Sukurti naujų įvykių struktūrą
                            [newEEGlabEvents, newEEGlabEvents_poslinkis, newEEGlabEvents_paklaidos] = ...
                               labchartEKGevent2eeglab(...
                                'EEGlabTimes', EEG.times, ...
                                'EEGlabEvent', EEG.event, ...
                                'LabchartCom', Labchart_data.com, ...
                                'LabchartComtext', Labchart_data.comtext, ...
                                'LabchartTickrate', Labchart_data.tickrate, ...
                                'New_R_event_type',QRS_ivykis);
                            EEG.event = newEEGlabEvents;        
                            
                            assignin('base','newEEGlabEvents_poslinkis',newEEGlabEvents_poslinkis);
                            assignin('base','newEEGlabEvents_paklaidos',newEEGlabEvents_paklaidos);
                            
                        otherwise
                            error('EKG?');
                    end;
                    
                    EEG = eeg_checkset( EEG , 'eventconsistency');
                    EEG = eeg_checkset( EEG );                    
                    
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('QRS detection'), NaujaRinkmena) ;
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;
                
                
                % Išsaugoti
                Priesaga=(get(handles.edit_QRS_aptikimas,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_QRS_aptikimas_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_QRS_aptikimas_,'Value') == 1 ;
                    Issaugoti(ALLEEG,EEG,KELIAS_SAUGOJIMUI,Poaplankis,NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;
                
                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_QRS_aptikimas,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;
                
            end;
        end;
        
        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err;  end;
        
        
        
        
        
        
        
        
        
        
        
        
        
        % QRS korekcija
        Darbo_apibudinimas=lokaliz('QRS korekcija...');
        if get(handles.checkbox_QRS_korekcija,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, ~isempty(EEG.data)));
                
                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);
                
                try
                    
                    if ~isempty(EEG.trials);
                        if EEG.trials > 1;
                            error('Epoch!!!');
                        end;
                    end;
                    
                    Reikalingas_kanalas=get(handles.text_kanal,'TooltipString');
                    EKG_kanalas=find(ismember({EEG.chanlocs.labels},Reikalingas_kanalas)==1);
                    
                    QRS_ivykis=get(handles.edit_QRS_ivykis,'String');
                    tipas_ir_latencija=[{EEG.event.type}',{EEG.event.latency}'];
                    rodykles=find(ismember(tipas_ir_latencija(:,1),QRS_ivykis)==1) ;
                    tik_R_idx=cell2mat(tipas_ir_latencija(rodykles,2)) ;
                    %size(tik_R_idx)
                    R_laikai=[EEG.times(tik_R_idx)]';
                    
                    if isempty(R_laikai);
                        error('QRS?');
                    end;
                    
                    % Atverti dialogą RRI redagavimui
                    if isempty(EKG_kanalas);
                        laikai=num2cell(pop_RRI_perziura(R_laikai,1));
                    else
                        laikai=num2cell(pop_RRI_perziura(R_laikai,1,[EEG.data(EKG_kanalas,:)]',EEG.times' * 0.001));
                    end;
                    
                    if isempty(laikai);
                        error('QRS?');
                    end;
                    
                    ivykiai(1:length(laikai),1)={QRS_ivykis};
                    
                    % Pašalinti senus QRS_ivykis tipo įvykius
                    EEG = pop_selectevent( EEG, 'omittype',{QRS_ivykis},'deleteevents','on');
                    
                    % Įvesti naujus QRS_ivykis tipo įvykius
                    EEG = pop_importevent( EEG, 'append','yes',...
                        'event', [ivykiai laikai],...
                        'fields',{'type' 'latency'}, ...
                        'timeunit',0.001);
                    
                    EEG = eeg_checkset( EEG );
                    
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('QRS korekcija'), NaujaRinkmena) ;
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;
                
                
                % Išsaugoti
                Priesaga=(get(handles.edit_QRS_korekcija,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_QRS_korekcija_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_QRS_korekcija_,'Value') == 1 ;
                    Issaugoti(ALLEEG,EEG,KELIAS_SAUGOJIMUI,Poaplankis,NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;
                
                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_QRS_korekcija,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;
                
            end;
        end;
        
        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err;  end;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        % Eksportuoti QRS laikus
        Darbo_apibudinimas=lokaliz('Exporting R times...');
        if get(handles.checkbox_eksp_Rlaikus,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, ~isempty(EEG.data)));
                
                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);
                
                try
                    
                    % Apskaičiuoti
                    QRS_ivykis=get(handles.edit_QRS_ivykis,'String');
                    tipas_ir_latencija=[{EEG.event.type}',{EEG.event.latency}'];
                    rodykles=find(ismember(tipas_ir_latencija(:,1),QRS_ivykis)==1) ;
                    tik_R_idx=cell2mat(tipas_ir_latencija(rodykles,2)) ;
                    R_laikai=[EEG.times(tik_R_idx)]';
                    
                    if isempty(R_laikai);
                        error('QRS?');
                    end;
                    
                    % Eksportuoti
                    Priesaga=(get(handles.edit_eksp_Rlaikus,'String')) ;
                    Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_eksp_Rlaikus_,'String')) ] ;
                    %RinkmenaRlaik=[  strrep(strrep(Rinkmena_,'.cnt',''),'.set','') Priesaga ];
                    RinkmenaRlaik=[  strrep(strrep(NaujaRinkmena,'.cnt',''),'.set','') Priesaga ];
                    
                    
                    if get(handles.checkbox_eksp_Rlaikus_,'Value') == 1 ;
                        KeliasRlaik=fullfile(KELIAS_SAUGOJIMUI,Poaplankis);
                    else
                        KeliasRlaik=KELIAS_SAUGOJIMUI;
                    end;                                        
                    if ~exist(KeliasRlaik,'dir');
                        mkdir(KeliasRlaik);
                    end;    
                    
                    dlmwrite(fullfile(KeliasRlaik,RinkmenaRlaik), ...
                        num2cell(R_laikai),...
                        'precision','%.3f',...
                        'newline', 'pc') ;
                    
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Export R times'), NaujaRinkmena) ;
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;
                
                                
                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_eksp_Rlaikus,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;
                
            end;
        end;
        
        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err;  end;
        
        
        
        
        
        
        
        
        % Eksportuoti RRI
        Darbo_apibudinimas=lokaliz('Exporting RRI...');
        if get(handles.checkbox_eksp_RRI,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, ~isempty(EEG.data)));
                
                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);
                
                try
                    
                    % Apskaičiuoti
                    QRS_ivykis=get(handles.edit_QRS_ivykis,'String');
                    tipas_ir_latencija=[{EEG.event.type}',{EEG.event.latency}'];
                    rodykles=find(ismember(tipas_ir_latencija(:,1),QRS_ivykis)==1) ;
                    tik_R_idx=cell2mat(tipas_ir_latencija(rodykles,2)) ;
                    R_laikai=[EEG.times(tik_R_idx)]';
                    RRI=num2cell(diff(R_laikai));
                    
                    if isempty(RRI);
                        error('QRS?');
                    end;
                    
                    % Eksportuoti
                    Priesaga=(get(handles.edit_eksp_RRI,'String')) ;
                    Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_eksp_RRI_,'String')) ] ;
                    %RinkmenaRRI=[  strrep(strrep(Rinkmena_,'.cnt',''),'.set','') Priesaga ];
                    RinkmenaRRI=[  strrep(strrep(NaujaRinkmena,'.cnt',''),'.set','') Priesaga ];
                                        
                    if get(handles.checkbox_eksp_RRI_,'Value') == 1 ;
                        KeliasRRI=fullfile(KELIAS_SAUGOJIMUI,Poaplankis);
                    else
                        KeliasRRI=KELIAS_SAUGOJIMUI;
                    end;                    
                    if ~exist(KeliasRRI,'dir');
                        mkdir(KeliasRRI);
                    end;                        
                    
                    dlmwrite(fullfile(KeliasRRI,RinkmenaRRI), ...
                        RRI,...
                        'precision','%.0f',...
                        'newline', 'pc') ;
                    
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Export RRI'), NaujaRinkmena) ;
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;
                
                                
                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_eksp_RRI,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;
                
            end;
        end;
        
        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err;  end;
        
        
        
        
        
        
        
        % Šalinti EKG kanalą
        Darbo_apibudinimas=lokaliz('Removing EKG channel...');
        if get(handles.checkbox_trint_EKG,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, ~isempty(EEG.data)));
                
                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);
                
                try
                    
                    Reikalingas_kanalas=get(handles.text_kanal,'TooltipString');
                    EKG_kanalas=find(ismember({EEG.chanlocs.labels},Reikalingas_kanalas)==1);
                    EEG = pop_select(EEG, 'nochannel', EKG_kanalas);
                    
                    EEG = eeg_checkset( EEG );
                    
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Remove EKG channel'), NaujaRinkmena) ;
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;
                
                
                % Išsaugoti
                Priesaga=(get(handles.edit_trint_EKG,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_trint_EKG_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_trint_EKG_,'Value') == 1 ;
                    Issaugoti(ALLEEG,EEG,KELIAS_SAUGOJIMUI,Poaplankis,NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;
                
                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_trint_EKG,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;
                
            end;
        end;
        
        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err;  end;
        
        
        
        
        
        
        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(0 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        
        
        
        % Išsaugoti
        if isempty(PaskRinkmIssaugKelias);
            Poaplankis='.';
            Priesaga='';
            Issaugoti(ALLEEG,EEG,KELIAS_SAUGOJIMUI,Poaplankis,NaujaRinkmena);
            PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
            DarboPorcijaAtlikta = 1;
            %else   disp('Duomenys jau įrašyti');
        end;
        
        str=(sprintf('%s apdorotas (%d/%d = %3.2f%%)\r\n', NaujaRinkmena, i, Pasirinktu_failu_N, i/Pasirinktu_failu_N*100 )) ;
        disp(str);
        
        if and(~isempty(EEG),DarboPorcijaAtlikta);
            if and(EEG.nbchan > 0, ~isempty(EEG.data)) ;
                NaujosRinkmenos=get(handles.listbox2,'String');
                NaujosRinkmenos{i}=NaujaRinkmena;
                set(handles.listbox2,'String',NaujosRinkmenos);
                disp(['+']);
            end;
        end;
        
        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(0 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        
        
    else
        msgbox(sprintf([lokaliz('Time:') ' %s\n' lokaliz('Path:') ' %s\n' lokaliz('File:') ' %s'], ...
            t, pwd, Rinkmena),err.identifier,'error');
    end;
    
    
    % Isvalyti atminti
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    %eeglab redraw;
    
    if get(handles.radiobutton6,'Value') == 1;
        tmp_idx=get(handles.listbox1,'Value');
        if length(tmp_idx) > 1 ;
            set(handles.listbox1,'Value',tmp_idx(2:end));
        end;
        
        if i == Pasirinktu_failu_N ;
            Apdoroti_visi_tiriamieji=1;
        end;
        
        %Galbūt naudotojas nori nutraukti anksčiau
        if get(handles.checkbox_baigti_anksciau,'Value') == 1 ;
            break;
        end;
    end;
    
    %set(handles.listbox2,'Visible','on');
    %set(handles.listbox1,'Visible','off');
    
end;

%% Po darbų

set(handles.text_darbas,'String',' ' );
drawnow;

if and(Apdoroti_visi_tiriamieji == 1, ...
        or(...
        get(handles.radiobutton6,'Value') == 0 ,...
        get(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Value') == 1 ...
        ) ...
        );
    
    if ~isempty(PaskRinkmIssaugKelias);
        set(handles.edit1,'String',PaskRinkmIssaugKelias);
    end;
end;

% Jei nėra taip, kad pirmenybė eiti per darbus, o surasta daug darbų
% t.y. arba pirmenybė eiti vienu įrašu per visus darbus
%      arba pirmenybė eiti per darbus, bet dar liko atliktinų darbų
%
% ARBA
%     pirmenybė eiti per darbus, o naudotojas prašo baigti anksčiau
%
if or(~and(get(handles.radiobutton7,'Value') == 1, PaskutinioIssaugotoDarboNr <  DarboNr ),...
        and(get(handles.radiobutton7,'Value') == 1, get(handles.checkbox_baigti_anksciau,'Value') == 1));
    
    if Apdoroti_visi_tiriamieji == 1;
        
        if get(handles.checkbox_pabaigus_atverti,'Value') == 1;
            Pasirinkti_failu_pavadinimai=get(handles.listbox2,'String');
            Pasirinkti_failu_pavadinimai=Pasirinkti_failu_pavadinimai(find(~(cellfun(@isempty,Pasirinkti_failu_pavadinimai))));
            %visi_failai=dir(fullfile(PaskRinkmIssaugKelias, '*.set'));
            %Pasirinkti_failu_pavadinimai=intersect({visi_failai.name},Pasirinkti_failu_pavadinimai);
            Pasirinkti_failu_pavadinimai2={};
            for f=1:length(Pasirinkti_failu_pavadinimai);
                [KELIAS__,Rinkmena__,Prievardis__]=fileparts(fullfile(PaskRinkmIssaugKelias,Pasirinkti_failu_pavadinimai{f}));
                Rinkmena__=[Rinkmena__ Prievardis__];
                if exist(fullfile(KELIAS__,Rinkmena__ ),'file') == 2;
                    Pasirinkti_failu_pavadinimai2{end+1,1}=Pasirinkti_failu_pavadinimai{f};
                    Pasirinkti_failu_pavadinimai2{end,2}=KELIAS__;
                    Pasirinkti_failu_pavadinimai2{end,3}=Rinkmena__;
                end;
            end;
            Pasirinktu_failu_N=size(Pasirinkti_failu_pavadinimai2,1);
            if Pasirinktu_failu_N > 0 ;
                try
                    disp(' ');
                    disp('Įkelsime į EEGLAB:');
                    disp([ '[' PaskRinkmIssaugKelias ']' ] );
                    for f=1:Pasirinktu_failu_N;
                        disp(Pasirinkti_failu_pavadinimai2{f,1});
                    end;
                    disp(' ');
                    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
                    for f=1:Pasirinktu_failu_N;
                        EEG = pop_loadset('filename',Pasirinkti_failu_pavadinimai2{f,3},'filepath',Pasirinkti_failu_pavadinimai2{f,2});
                        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'study',0);
                    end;
                    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, Pasirinktu_failu_N,'retrieve',[1:Pasirinktu_failu_N] ,'study',0);
                catch err;
                end;
            end;
            eeglab redraw;
        end;
        
    end;
    
    
    if get(handles.checkbox_uzverti_pabaigus,'Value') == 1;
        delete(handles.figure1);
    else
        if and(Apdoroti_visi_tiriamieji == 1, ...
                or(...
                get(handles.radiobutton6,'Value') == 0 ,...
                get(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Value') == 1 ...
                ) ...
                );
            if ~isempty(PaskRinkmIssaugKelias);
                set(handles.edit1,'String',PaskRinkmIssaugKelias);
            end;
        end;
        set(handles.edit_failu_filtras2,'BackgroundColor',[0.7 0.7 0.7]);
        set(handles.edit_failu_filtras2,'Style','pushbutton');
        set(handles.edit_failu_filtras2,'String',lokaliz('Filter'));
        %if ~strcmp(char(mfilename),'pop_QRS_i_EEG');
        atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
        atnaujink_rodomus_failus(hObject, eventdata, handles);
        %end;
        susildyk(hObject, eventdata, handles);
    end;
    
    
    % Parodyk, kiek laiko uztruko
    disp(' ');
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    toc ;
    disp(['Atlikta']);
    
else
    
    if ~isempty(PaskRinkmIssaugKelias);
        set(handles.edit1,'String',PaskRinkmIssaugKelias);
    end;
    set(handles.edit_failu_filtras2,'BackgroundColor',[0.7 0.7 0.7]);
    set(handles.edit_failu_filtras2,'Style','pushbutton');
    set(handles.edit_failu_filtras2,'String',lokaliz('Filter'));
    atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
    atnaujink_rodomus_failus(hObject, eventdata, handles);
    
    disp([ 'Buvo ' num2str(DarboNr) ' darbai(-as,-ų), o atliktas tik vienas – suksimas kitas darbas.']);
    
    pushbutton1_Callback(hObject, eventdata, handles);
end;


function naujas_duomuo = konvertavimas_is_narvelio(duomuo)
if isempty(duomuo);
    duomuo='';
else
    duomuo=duomuo(1,:);
end;
while iscell(duomuo);
    duomuo=cell2mat(duomuo);
end;
while isnumeric(duomuo);
    duomuo=sprintf('%.12f',duomuo);
end;
naujas_duomuo = duomuo;



function [RinkmenaSaugojimuiSuKeliu]=Issaugoti(ALLEEG,EEG,KELIAS_SAUGOJIMUI,POAPLANKIS,RinkmenaSaugojimui)
if isempty(EEG) ;
    return ;
end;
try
    if or(EEG.nbchan==0,isempty(EEG.data));
        return ;
    end;
    if EEG.pnts<=1;
        return ;
    end;
    NaujasKelias=fullfile(KELIAS_SAUGOJIMUI,POAPLANKIS);
    if ~isdir(NaujasKelias)
        mkdir(NaujasKelias);
    end;
    NaujasKelias=Tikras_Kelias(NaujasKelias);
    RinkmenaSaugojimuiSuKeliu=fullfile(NaujasKelias, RinkmenaSaugojimui);
    disp(RinkmenaSaugojimuiSuKeliu);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, ...
        'setname', regexprep(regexprep(RinkmenaSaugojimui,'.cnt$',''),'.set$',''), ...
        'savenew',RinkmenaSaugojimuiSuKeliu);
catch err;
    Pranesk_apie_klaida(err,lokaliz('Save file'),RinkmenaSaugojimui);
end;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1,'Value',1);
if strcmp(get(handles.checkbox_baigti_anksciau,'Visible'),'on');
    set(handles.checkbox_baigti_anksciau,'Value',1);
    checkbox_baigti_anksciau_Callback(hObject, eventdata, handles);
    %set(handles.pushbutton2,'Enable','off');
else
    close(mfilename);
    
    % Parodyk, kiek laiko uztruko
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    %toc ;
    disp(['Atsisakyta']);
end;

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);
if strcmp(get(handles.edit1,'Enable'),'on');
    %
end;

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbr_kelias=pwd;
try
    cd(get(handles.edit1,'String'));
catch err;
end;
KELIAS=uigetdir;
set(handles.edit1,'String',Tikras_Kelias(KELIAS));
cd(dbr_kelias);
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
%set(handles.axes1, 'Visible', 'off');
if ~strcmp(get(handles.edit_failu_filtras2,'Style'),'pushbutton') ;
    set(handles.edit_failu_filtras2,'Style','pushbutton');
    set(handles.edit_failu_filtras2,'String',lokaliz('Filter'));
    set(handles.edit_failu_filtras2,'BackgroundColor',[0.7 0.7 0.7]);
end;
QRS_saltino_galunes(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
edit_failu_filtras2_Callback(hObject, eventdata, handles);
%atnaujink_rodomus_failus(hObject, eventdata, handles);


% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
atnaujink_rodomus_failus(hObject, eventdata, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
KELIAS=pwd;
try
    cd(get(handles.edit2,'String'));
catch err;
end;
KELIAS_ISSAUGOJIMUI=uigetdir;
try
    cd(KELIAS_ISSAUGOJIMUI);
catch err;
    cd(Tikras_Kelias(get(handles.edit2,'TooltipString')));
end;
set(handles.edit2,'String',pwd);
set(handles.edit2,'TooltipString',pwd);
set(handles.pushbutton_v2,'UserData',...
    unique([get(handles.pushbutton_v2,'UserData') KELIAS {pwd}]));
cd(KELIAS);
set(handles.edit2,'BackgroundColor',[1 1 1]);

% --- Executes on key press with focus on edit1 and none of its controls.
function edit1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'BackgroundColor',[1 1 0]);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on key press with focus on edit2 and none of its controls.
function edit2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2,'BackgroundColor',[1 1 0]);
Ar_galima_vykdyti(hObject, eventdata, handles);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

KELIAS=pwd;
KELIAS_siulomas=get(handles.edit2,'String');

try
    if ~isempty(KELIAS_siulomas);
        cd(KELIAS_siulomas);
    end;
catch err;
    
    button3 = questdlg([' ' KELIAS_siulomas ' ' ] , ...
        'Neradome aplanko', ...
        'Atšaukti', 'Sukurti aplanką', 'Sukurti aplanką');
    if and(~isempty(KELIAS_siulomas),strcmp(button3,'Sukurti aplanką'));
        try
            mkdir(KELIAS_siulomas);
            cd(KELIAS_siulomas);
        catch err ;
            warning(err.message);
            cd(Tikras_Kelias(get(handles.edit2,'TooltipString')));
        end;
    else
        cd(Tikras_Kelias(get(handles.edit2,'TooltipString')));
    end;
end;
set(handles.edit2,'String',pwd);
set(handles.edit2,'TooltipString',pwd);
set(handles.pushbutton_v2,'UserData',...
    unique([get(handles.pushbutton_v2,'UserData') KELIAS {pwd}]));
cd(KELIAS);
set(handles.edit2,'BackgroundColor',[1 1 1]);
Ar_galima_vykdyti(hObject, eventdata, handles);



% --- Executes on button press in checkbox_uzverti_pabaigus.
function checkbox_uzverti_pabaigus_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_uzverti_pabaigus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_uzverti_pabaigus
if get(handles.checkbox_uzverti_pabaigus,'Value') == 1;
    set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'Enable','off');
else
    set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'Enable','on');
end;

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_pabaigus_atverti.
function checkbox_pabaigus_atverti_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_pabaigus_atverti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pabaigus_atverti


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7

% --- Executes on key press with focus on edit_failu_filtras1 and none of its controls.
function edit_failu_filtras1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_failu_filtras1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_failu_filtras1,'BackgroundColor',[1 1 0]);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in edit_failu_filtras1.
function edit_failu_filtras1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_failu_filtras1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.edit_failu_filtras1,'String'));
    set(handles.edit_failu_filtras1,'String','*.set;*.cnt');
end;
set(handles.edit_failu_filtras1,'BackgroundColor',[1 1 1]);
atnaujink_rodomus_failus(hObject, eventdata, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit_failu_filtras2.
function edit_failu_filtras2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit_failu_filtras2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.edit_failu_filtras2,'Style'),'pushbutton') ;
    set(handles.edit_failu_filtras2,'Style','edit');
    set(handles.edit_failu_filtras2,'String','*');
    set(handles.edit_failu_filtras2,'BackgroundColor',[1 1 1]);
else
    set(handles.edit_failu_filtras2,'Style','pushbutton');
    set(handles.edit_failu_filtras2,'String',lokaliz('Filter'));
    set(handles.edit_failu_filtras2,'BackgroundColor',[0.7 0.7 0.7]);
end;



% --- Executes on key press with focus on edit_failu_filtras2 and none of its controls.
function edit_failu_filtras2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_failu_filtras2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.edit_failu_filtras2,'Style'),'pushbutton') ;
    set(handles.edit_failu_filtras2,'Style','edit');
    set(handles.edit_failu_filtras2,'String','*');
    set(handles.edit_failu_filtras2,'BackgroundColor',[1 1 1]);
else
    set(handles.edit_failu_filtras2,'BackgroundColor',[1 1 0]);
    Ar_galima_vykdyti(hObject, eventdata, handles);
    %set(handles.edit_failu_filtras2,'Style','pushbutton');
    %set(handles.edit_failu_filtras2,'String',lokaliz('Filter'));
    %set(handles.edit_failu_filtras2,'BackgroundColor',[0.7 0.7 0.7]);
end;


% --- Executes on button press in edit_failu_filtras2.
function edit_failu_filtras2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_failu_filtras2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.edit_failu_filtras2,'Style'),'pushbutton') ;
    set(handles.edit_failu_filtras2,'Style','edit');
    set(handles.edit_failu_filtras2,'String','*');
elseif isempty(get(handles.edit_failu_filtras2,'String'));
    set(handles.edit_failu_filtras2,'String','*');
end;
set(handles.edit_failu_filtras2,'BackgroundColor',[1 1 1]);
atnaujink_rodomus_failus(hObject, eventdata, handles);


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function [varargout] = Tikras_Kelias(kelias_tikrinimui)
kelias_dabar=pwd;
try
    cd(kelias_tikrinimui);
catch err;
end;
varargout{1}=pwd;
cd(kelias_dabar);



% --- Executes on button press in checkbox_baigti_anksciau.
function checkbox_baigti_anksciau_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_baigti_anksciau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_baigti_anksciau
if get(handles.checkbox_baigti_anksciau,'Value') == 1;
    set(handles.pushbutton2,'Enable','off');
    set(handles.pushbutton2,'Value',0);
else
    set(handles.pushbutton2,'Enable','on');
    set(handles.pushbutton2,'Value',1);
end;

function figure1_InterruptFcn(hObject, eventdata, handles)

disp(' ');
disp('Darbą nutraukė pats naudotojas');
susildyk(hObject, eventdata, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
disp(' ');
disp('Naudotojas priverstinai uždaro langą!');
if ~isempty(findobj('-regexp','name',mfilename)) ;
    if and(strcmp(get(handles.checkbox_baigti_anksciau,'Visible'),'on'), ...
            and(get(handles.checkbox_baigti_anksciau,'Value') == 0, ...
            get(handles.pushbutton1,'Value') == 0));
        set(handles.checkbox_baigti_anksciau,'Value',1);
        %set(handles.checkbox_baigti_anksciau,'Visible','on');
        checkbox_baigti_anksciau_Callback(hObject, eventdata, handles);
    else
        %if get(handles.pushbutton1,'Value') == 1 ;
        
        % delete(hObject);
        % error('Darbą nutraukė naudotojas');
        
        %else
        button1 = questdlg(lokaliz('Quit function help') , ...
            lokaliz('Quit function'), ...
            lokaliz('Close window'), lokaliz('Allow change options'), lokaliz('Continue as is'), ...
            lokaliz('Continue as is'));
        
        
        
        switch button1
            case lokaliz('Close window')
                
                button2 = 'Tik užverti langą';
                
                
                % Neklausti
                if 1 < 0 ;
                    button2 = questdlg(['Jei per klaidą nuspaudėte užvėrimo mygtuką, ' ...
                        'spauskite „Tęsti kaip buvo“. ' ...
                        'Jei spausite „Tik užverti langą“, gali sutrikti šios ' ...
                        'programos darbai. Jei norite nutraukti šios programėlės ' ...
                        'darbą, spauskite „Visai nutraukti“' ] , ...
                        'Darbų stabdymas', ...
                        'Užveriant generuoti klaidą', 'Tik užverti langą', lokaliz('Continue as is'), ...
                        'Tik užverti langą');
                end;
                
                switch button2
                    case 'Užveriant generuoti klaidą'
                        delete(hObject);
                        error('Darbą nutraukė naudotojas');
                        %    case 'Grįžti į parinktis'
                        %        %error('Darbą nutraukė naudotojas');
                        %        pop_QRS_i_EEG;
                    case 'Tik užverti langą'
                        delete(hObject);
                        disp('Langą naudotojas užvėrė ');
                    case lokaliz('Allow change options')
                        disp('Naudotojas paprašė atitirpdyti parinktis');
                        susildyk(hObject, eventdata, handles);
                    case lokaliz('Continue as is')
                        disp('Tęsiama');
                end;
                
                
            case lokaliz('Allow change options')
                disp('Naudotojas paprašė atitirpdyti parinktis');
                susildyk(hObject, eventdata, handles);
            case lokaliz('Continue as is')
                disp('Tęsiama');
        end;
        %end;
    end;
end;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close(mfilename);
try fclose(fid); catch err ; end;

function text_atlikta_darbu_Callback(hObject, eventdata, handles)
% hObject    handle to text_atlikta_darbu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_atlikta_darbu as text
%        str2double(get(hObject,'String')) returns contents of text_atlikta_darbu as a double
x=str2num(get(handles.text_atlikta_darbu,'String'));
if length(x) == 1 ;
    set(handles.text_atlikta_darbu,'UserData',regexprep(num2str(x), '[ ]*', ' '));
end;
set(handles.text_atlikta_darbu,'String',num2str(get(handles.text_atlikta_darbu,'UserData')));
%set(handles.text_atlikta_darbu,'BackgroundColor',[1 1 1]);


% --- Executes on button press in checkbox_pabaigus_i_apdorotu_aplanka.
function checkbox_pabaigus_i_apdorotu_aplanka_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_pabaigus_i_apdorotu_aplanka (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pabaigus_i_apdorotu_aplanka
set(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'UserData', get(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Value'));

% --- Executes when selected object is changed in uipanel15.
function uipanel15_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel15
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton7,'Value') == 1 ;
    set(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Value',1);
    set(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Enable','off');
else
    set(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Enable','on');
    tmp=get(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'UserData');
    if ~isempty(tmp);
        switch tmp
            case 0
                set(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Value', 0);
            case 1
                set(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Value', 1);
        end;
    end;
end;


function edit_laiko_intervalas_Callback(hObject, eventdata, handles)
% hObject    handle to edit_laiko_intervalas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_laiko_intervalas as text
%        str2double(get(hObject,'String')) returns contents of edit_laiko_intervalas as a double
elementas=handles.edit_laiko_intervalas;
x=str2num(get(elementas,'String'));
if length(x) == 2 ;
    if x(1) < x(2);
        set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));
        set(elementas,'BackgroundColor',[1 1 1]);
        %set(handles.slider3,'Min',xmin);
        %set(handles.slider3,'Max',xmax-1000*(x(2)-x(1)));
        set(handles.slider3,'Value',x(1)*1000);
    end;
end;
if isempty(x);
    set(elementas,'UserData','');
    set(elementas,'BackgroundColor',[1 1 1]);
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
%edit57_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_laiko_intervalas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_laiko_intervalas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_ivykiai_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ivykiai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ivykiai as text
%        str2double(get(hObject,'String')) returns contents of edit_ivykiai as a double
elementas=handles.edit_ivykiai;
senas=get(elementas,'UserData');
x=unique(str2num(get(elementas,'String')));
if length(x) > 0 ;
    x_txt=num2str(x(1));
    x_diff=diff(x);
    x_not_seq=find(x_diff~=1);
    for i=1:length(x_diff);
        if ismember(i, x_not_seq);
            x_txt=[ x_txt ' ' num2str(x(1+i)) ];
        elseif or(ismember(1+i, x_not_seq),i==length(x_diff));
            x_txt=[ x_txt ':' num2str(x(1+i)) ];
        end;
    end;
    set(elementas,'UserData',regexprep(x_txt, '[ ]*', ' '));
elseif isempty(get(elementas,'String'));
    set(elementas,'UserData','');
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
%if ~isempty(get(elementas,'String'));
set(elementas,'BackgroundColor',[1 1 1]);
%else
%    set(elementas,'BackgroundColor',[1 1 0]);
%end;
%tmp_str=[ strrep(get(handles.edit_ivykiai,'String'),':','-') ' ' lokaliz('with') ' ' strrep(get(handles.edit54,'String'),':','-') ];
%if ischar(tmp_str);
%    tmp_str=regexprep(tmp_str, '[ ]*', ' ');
%    set(handles.edit60,'String',tmp_str);
%end;
Ar_galima_vykdyti(hObject, eventdata, handles);
if ~strcmp(senas,get(elementas,'UserData'));
    set(handles.listbox1,'UserData',{});
end;

% --- Executes during object creation, after setting all properties.
function edit_ivykiai_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ivykiai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_failu_filtras1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_failu_filtras1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_failu_filtras2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_failu_filtras2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_atlikta_darbu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_atlikta_darbu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'));
    pushbutton1_Callback(hObject, eventdata, handles);
end;


% --- Executes on button press in pushbutton_ivykiai.
function pushbutton_ivykiai_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ivykiai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RINKMENOS=get(handles.listbox1,'String');
if isempty(RINKMENOS);
    set(handles.edit1,'BackgroundColor',[1 1 0]);
    drawnow;
    return; 
end;
RINKMENOS=RINKMENOS(get(handles.listbox1,'Value'));
if isempty(RINKMENOS);
    set(handles.listbox1,'BackgroundColor',[1 1 0]);    pause(1);
    set(handles.listbox1,'BackgroundColor',[1 1 1]);    drawnow;
    return; 
end;
set(handles.pushbutton_ivykiai,'Enable','off'); drawnow;
[~,visi_galimi_ivykiai,bendri_ivykiai]=eeg_ivykiu_sarasas (get(handles.edit1,'String'), RINKMENOS);
set(handles.pushbutton_ivykiai,'Enable','on');
if ismember('boundary',visi_galimi_ivykiai);
    i=find(ismember(visi_galimi_ivykiai,'boundary')==0);
    visi_galimi_ivykiai=visi_galimi_ivykiai(i);
end;
if ismember('boundary',bendri_ivykiai);
    i=find(ismember(bendri_ivykiai,'boundary')==0);
    bendri_ivykiai=bendri_ivykiai(i);
end;
if isempty(visi_galimi_ivykiai);
    warndlg(lokaliz('No events found.'),lokaliz('Selection of events'));
    return;
end;
pateikiami_ivykiai={};
pradinis_pasirinkimas=[];
pateikiami_bendri_v=0;
if ~isempty(bendri_ivykiai);
    if length(RINKMENOS) == 1;
        pateikiami_ivykiai={bendri_ivykiai{:}};
        pateikiami_bendri_v=0;
        %pradinis_pasirinkimas=[1:length(bendri_ivykiai)];
    else
        pateikiami_ivykiai={lokaliz('(all common:)') bendri_ivykiai{:} };
        pateikiami_bendri_v=1;
        %pradinis_pasirinkimas=[2:length(bendri_ivykiai)+1];
    end;
end;
nebendri_idx=find(ismember(visi_galimi_ivykiai,bendri_ivykiai) == 0);
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
    pateikiami_ivykiai={pateikiami_ivykiai{:} lokaliz('(not common:)') visi_galimi_ivykiai{nebendri_idx} };
    pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_ivykiai);
    if ~pateikiami_bendri_v;
        %pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_kanalai) + pateikiami_bendri_v + 1 ) ];
    end;
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
senas=get(handles.edit_QRS_ivykis,'String');
if ~isempty(senas);
    senas=str2num(senas);
    if ~isempty(senas);
        senas=cellfun(@(i) {num2str(senas(i))}, num2cell([1:length(senas)]));
        pradinis_pasirinkimas=find(ismember(pateikiami_ivykiai,senas)==1);
    end;
end;
if ~iscellstr(pateikiami_ivykiai);
    warning(lokaliz('unexpected events types.'),lokaliz('Selection of events'));
    disp(pateikiami_ivykiai);
    return;
end;
if isempty(pradinis_pasirinkimas);
    [~,tmp]=ismember(pateikiami_ivykiai, ...
        {'R' 'r' 'QRS' 'qrs' '300'});
     tmpi=find(tmp>0);
     if ~isempty(tmpi);
%     tmpi=min(tmp(tmpi));
%     tmpi
%     tmp
        pradinis_pasirinkimas=find(tmp==min(tmp(tmpi)));
       %pradinis_pasirinkimas=find(tmp==min(tmp(find(tmp>0))));
     end;
end;
if isempty(pradinis_pasirinkimas);
    pradinis_pasirinkimas=1;
else
    pradinis_pasirinkimas=pradinis_pasirinkimas(1);
end;
pasirinkti_ivykiai_idx=listdlg('ListString', pateikiami_ivykiai,...
    'SelectionMode','single',...
    'PromptString', lokaliz('Select events:'),...
    'InitialValue',pradinis_pasirinkimas );
if isempty(pasirinkti_ivykiai_idx); return ; end;
pasirinkti_ivykiai={};
% if ismember(pateikiami_bendri_v,pasirinkti_ivykiai_idx);
%     pasirinkti_ivykiai={pasirinkti_ivykiai{:} bendri_ivykiai{:} };
% end;
% if ismember(pateikiami_nebendri_v,pasirinkti_ivykiai_idx);
%     pasirinkti_ivykiai={pasirinkti_ivykiai{:} visi_galimi_ivykiai{nebendri_idx} };
% end;
pasirinkti_ivykiai_idx_=pasirinkti_ivykiai_idx(find(ismember(pasirinkti_ivykiai_idx, [pateikiami_bendri_v pateikiami_nebendri_v])==0));
pasirinkti_ivykiai=unique({pasirinkti_ivykiai{:} pateikiami_ivykiai{pasirinkti_ivykiai_idx_}});
if isempty(pasirinkti_ivykiai);
    pasirinkti_ivykiai_str='';    
    set(handles.pushbutton_ivykiai,'BackgroundColor',[1 1 0]);
else
    pasirinkti_ivykiai_str=pasirinkti_ivykiai{1};
    set(handles.pushbutton_ivykiai,'BackgroundColor','remove');
end;
for i=2:length(pasirinkti_ivykiai);
    pasirinkti_ivykiai_str=[pasirinkti_ivykiai_str ' ' pasirinkti_ivykiai{i}];
end;
set(handles.edit_QRS_ivykis,'String',pasirinkti_ivykiai_str);
%edit59_Callback(hObject, eventdata, handles);


% --- Executes on button press in pushbutton_kanal.
function pushbutton_kanal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_kanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


RINKMENOS=get(handles.listbox1,'String');
if isempty(RINKMENOS);
    set(handles.edit1,'BackgroundColor',[1 1 0]);
    drawnow;
    return; 
end;
RINKMENOS=RINKMENOS(get(handles.listbox1,'Value'));
if isempty(RINKMENOS);
    set(handles.listbox1,'BackgroundColor',[1 1 0]);    pause(1);
    set(handles.listbox1,'BackgroundColor',[1 1 1]);    drawnow;
    return; 
end;
set(handles.pushbutton_kanal,'Enable','off'); drawnow;
[~,visi_galimi_kanalai,bendri_kanalai]=eeg_kanalu_sarasas (get(handles.edit1,'String'), RINKMENOS);
set(handles.pushbutton_kanal,'Enable','on');
if isempty(visi_galimi_kanalai);
    warndlg(lokaliz('No channels found.'),lokaliz('Selection of channels'));
    return;
end;
pateikiami_kanalai={};
pradinis_pasirinkimas=[];
pateikiami_bendri_v=0;
if ~isempty(bendri_kanalai);
    if length(RINKMENOS) == 1;
        pateikiami_kanalai={bendri_kanalai{:}};
        pateikiami_bendri_v=0;
        %pradinis_pasirinkimas=[1:length(bendri_kanalai)];
    else
        pateikiami_kanalai={lokaliz('(all common:)') bendri_kanalai{:} };
        pateikiami_bendri_v=1;
        %pradinis_pasirinkimas=[2:(length(bendri_kanalai)+1)];
    end;
end;
nebendri_idx=find(ismember(visi_galimi_kanalai,bendri_kanalai) == 0);
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
    pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(not common:)') visi_galimi_kanalai{nebendri_idx} };
    pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_kanalai);
    if ~pateikiami_bendri_v;
        %pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_kanalai) + pateikiami_bendri_v + 1 ) ];
    end;
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
Ankstesni_kanalai=get(handles.text_kanal,'TooltipString');
if ~isempty(Ankstesni_kanalai);
    Ankstesni_kanalai=textscan(Ankstesni_kanalai,'%s','delimiter',' ');
    senas=Ankstesni_kanalai{1};
    if ~isempty(senas);
        pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,senas)==1);
    end;
end;
if ~iscellstr(pateikiami_kanalai);
    warning(lokaliz('unexpected channels types.'),lokaliz('Selection of channels'));
    disp(pateikiami_kanalai);
    return;
end;
if isempty(pradinis_pasirinkimas);
    [~,tmp]=ismember(pateikiami_kanalai, ...
        {'EKG' 'ECG' 'ekg' 'ecg' 'EKG1' 'ECG1' 'EOG' 'EOGh' 'EOG1' 'EOG2' });
    tmpi=find(tmp>0);
    if ~isempty(tmpi);
        pradinis_pasirinkimas=find(tmp==min(tmp(tmpi)));
    end;
    %pradinis_pasirinkimas=find(tmp==min(tmp(find(tmp>0))));
end;
if isempty(pradinis_pasirinkimas);
    pradinis_pasirinkimas=1;
else
    pradinis_pasirinkimas=pradinis_pasirinkimas(1);
end;
pasirinkti_kanalai_idx=listdlg('ListString', pateikiami_kanalai,...
    'SelectionMode','single',...
    'PromptString', lokaliz('Select channels:'),...
    'InitialValue',pradinis_pasirinkimas );
if isempty(pasirinkti_kanalai_idx); return ; end;
pasirinkti_kanalai={};
% if ismember(pateikiami_bendri_v,pasirinkti_kanalai_idx);
%     pasirinkti_kanalai={pasirinkti_kanalai{:} bendri_kanalai{:} };
% end;
% if ismember(pateikiami_nebendri_v,pasirinkti_kanalai_idx);
%     pasirinkti_kanalai={pasirinkti_kanalai{:} visi_galimi_kanalai{nebendri_idx} };
% end;
pasirinkti_kanalai_idx_=pasirinkti_kanalai_idx(find(ismember(pasirinkti_kanalai_idx, ...
    [pateikiami_bendri_v pateikiami_nebendri_v])==0));
pasirinkti_kanalai=unique({pasirinkti_kanalai{:} pateikiami_kanalai{pasirinkti_kanalai_idx_}});
if isempty(pasirinkti_kanalai);
    pasirinkti_kanalai_str='';
else
    pasirinkti_kanalai_str=[pasirinkti_kanalai{1}];
end;
for i=2:length(pasirinkti_kanalai);
    pasirinkti_kanalai_str=[pasirinkti_kanalai_str ' ' pasirinkti_kanalai{i}];
end;
disp([ '''' regexprep(pasirinkti_kanalai_str, ' ', ''' ''') '''' ]);
if ~isempty(pasirinkti_kanalai_str) ;
    %set(handles.text_kanal,'String',length(pasirinkti_kanalai));
    set(handles.text_kanal,'String',pasirinkti_kanalai_str);
    set(handles.text_kanal,'TooltipString',pasirinkti_kanalai_str);
    set(handles.pushbutton_kanal,'BackgroundColor','remove');
else
    set(handles.text_kanal,'String','?');
    set(handles.text_kanal,'TooltipString','');
    set(handles.pushbutton_kanal,'BackgroundColor',[1 1 0]);
end;




% --- Executes on selection change in popupmenu_QRS_algoritmas.
function popupmenu_QRS_algoritmas_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_QRS_algoritmas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_QRS_algoritmas contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_QRS_algoritmas


% --- Executes during object creation, after setting all properties.
function popupmenu_QRS_algoritmas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_QRS_algoritmas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_QRS_ivykis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_QRS_ivykis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_QRS_ivykis as text
%        str2double(get(hObject,'String')) returns contents of edit_QRS_ivykis as a double


% --- Executes during object creation, after setting all properties.
function edit_QRS_ivykis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_QRS_ivykis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_trint_EKG.
function checkbox_trint_EKG_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_trint_EKG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_trint_EKG
if and(get(handles.checkbox_trint_EKG, 'Value') == 1, ...
        strcmp(get(handles.checkbox_trint_EKG, 'Enable'),'on'));
    set(handles.checkbox_trint_EKG_,'Enable','on');
    set(handles.edit_trint_EKG,'Enable','on');
else
    set(handles.checkbox_trint_EKG_,'Enable','off');
    set(handles.edit_trint_EKG,'Enable','off');
end;
checkbox_trint_EKG__Callback(hObject, eventdata, handles);



function edit_QRS_aptikimas_Callback(hObject, eventdata, handles)
% hObject    handle to edit_QRS_aptikimas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_QRS_aptikimas as text
%        str2double(get(hObject,'String')) returns contents of edit_QRS_aptikimas as a double


% --- Executes during object creation, after setting all properties.
function edit_QRS_aptikimas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_QRS_aptikimas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_QRS_aptikimas__Callback(hObject, eventdata, handles)
% hObject    handle to edit_QRS_aptikimas_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_QRS_aptikimas_ as text
%        str2double(get(hObject,'String')) returns contents of edit_QRS_aptikimas_ as a double


% --- Executes during object creation, after setting all properties.
function edit_QRS_aptikimas__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_QRS_aptikimas_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_QRS_aptikimas_.
function checkbox_QRS_aptikimas__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_QRS_aptikimas_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_QRS_aptikimas_
if and(get(handles.checkbox_QRS_aptikimas_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_QRS_aptikimas_, 'Enable'),'on'));
    set(handles.edit_QRS_aptikimas_,'Enable','on');
else
    set(handles.edit_QRS_aptikimas_,'Enable','off');
end;


% --- Executes on button press in checkbox_QRS_aptikimas.
function checkbox_QRS_aptikimas_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_QRS_aptikimas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_QRS_aptikimas
if and(get(handles.checkbox_QRS_aptikimas, 'Value') == 1, ...
        strcmp(get(handles.checkbox_QRS_aptikimas, 'Enable'),'on'));
    set(handles.checkbox_QRS_aptikimas_,'Enable','on');
    set(handles.edit_QRS_aptikimas,'Enable','on');
    set(handles.popupmenu_QRS_algoritmas,'Enable','on');
    set(handles.popupmenu_QRS_saltinis,'Enable','on');
    set(handles.edit_QRS_saltinis,'Enable','on');
    set(handles.pushbutton_QRS_saltinis,'Enable','on');
    set(handles.popupmenu_QRS_saltinio_galune,'Enable','on');
else
    set(handles.checkbox_QRS_aptikimas_,'Enable','off');
    set(handles.edit_QRS_aptikimas,'Enable','off');
    set(handles.popupmenu_QRS_algoritmas,'Enable','off');
    set(handles.popupmenu_QRS_saltinis,'Enable','off');
    set(handles.edit_QRS_saltinis,'Enable','off');
    set(handles.pushbutton_QRS_saltinis,'Enable','off');
    set(handles.popupmenu_QRS_saltinio_galune,'Enable','off');
end;
checkbox_QRS_aptikimas__Callback(hObject, eventdata, handles);
popupmenu_QRS_saltinis_Callback(hObject, eventdata, handles);

% --- Executes on button press in checkbox_QRS_korekcija.
function checkbox_QRS_korekcija_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_QRS_korekcija (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_QRS_korekcija
if and(get(handles.checkbox_QRS_korekcija, 'Value') == 1, ...
        strcmp(get(handles.checkbox_QRS_korekcija, 'Enable'),'on'));
    set(handles.checkbox_QRS_korekcija_,'Enable','on');
    set(handles.edit_QRS_korekcija,'Enable','on');
else
    set(handles.checkbox_QRS_korekcija_,'Enable','off');
    set(handles.edit_QRS_korekcija,'Enable','off');
end;
checkbox_QRS_korekcija__Callback(hObject, eventdata, handles);


% --- Executes on button press in checkbox_eksp_RRI.
function checkbox_eksp_RRI_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_eksp_RRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_eksp_RRI
if and(get(handles.checkbox_eksp_RRI, 'Value') == 1, ...
        strcmp(get(handles.checkbox_eksp_RRI, 'Enable'),'on'));
    set(handles.checkbox_eksp_RRI_,'Enable','on');
    set(handles.edit_eksp_RRI,'Enable','on');
else
    set(handles.checkbox_eksp_RRI_,'Enable','off');
    set(handles.edit_eksp_RRI,'Enable','off');
end;
checkbox_eksp_RRI__Callback(hObject, eventdata, handles);


% --- Executes on button press in checkbox_QRS_korekcija_.
function checkbox_QRS_korekcija__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_QRS_korekcija_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_QRS_korekcija_
if and(get(handles.checkbox_QRS_korekcija_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_QRS_korekcija_, 'Enable'),'on'));
    set(handles.edit_QRS_korekcija_,'Enable','on');
else
    set(handles.edit_QRS_korekcija_,'Enable','off');
end;



function edit_QRS_korekcija_Callback(hObject, eventdata, handles)
% hObject    handle to edit_QRS_korekcija (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_QRS_korekcija as text
%        str2double(get(hObject,'String')) returns contents of edit_QRS_korekcija as a double


% --- Executes during object creation, after setting all properties.
function edit_QRS_korekcija_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_QRS_korekcija (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_QRS_korekcija__Callback(hObject, eventdata, handles)
% hObject    handle to edit_QRS_korekcija_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_QRS_korekcija_ as text
%        str2double(get(hObject,'String')) returns contents of edit_QRS_korekcija_ as a double


% --- Executes during object creation, after setting all properties.
function edit_QRS_korekcija__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_QRS_korekcija_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_eksp_RRI_.
function checkbox_eksp_RRI__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_eksp_RRI_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_eksp_RRI_
if and(get(handles.checkbox_eksp_RRI_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_eksp_RRI_, 'Enable'),'on'));
    set(handles.edit_eksp_RRI_,'Enable','on');
else
    set(handles.edit_eksp_RRI_,'Enable','off');
end;



function edit_eksp_RRI_Callback(hObject, eventdata, handles)
% hObject    handle to edit_eksp_RRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eksp_RRI as text
%        str2double(get(hObject,'String')) returns contents of edit_eksp_RRI as a double


% --- Executes during object creation, after setting all properties.
function edit_eksp_RRI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eksp_RRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_eksp_RRI__Callback(hObject, eventdata, handles)
% hObject    handle to edit_eksp_RRI_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eksp_RRI_ as text
%        str2double(get(hObject,'String')) returns contents of edit_eksp_RRI_ as a double


% --- Executes during object creation, after setting all properties.
function edit_eksp_RRI__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eksp_RRI_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_trint_EKG_.
function checkbox_trint_EKG__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_trint_EKG_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_trint_EKG_
if and(get(handles.checkbox_trint_EKG_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_trint_EKG_, 'Enable'),'on'));
    set(handles.edit_trint_EKG_,'Enable','on');
else
    set(handles.edit_trint_EKG_,'Enable','off');
end;



function edit_trint_EKG_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trint_EKG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trint_EKG as text
%        str2double(get(hObject,'String')) returns contents of edit_trint_EKG as a double


% --- Executes during object creation, after setting all properties.
function edit_trint_EKG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trint_EKG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_trint_EKG__Callback(hObject, eventdata, handles)
% hObject    handle to edit_trint_EKG_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trint_EKG_ as text
%        str2double(get(hObject,'String')) returns contents of edit_trint_EKG_ as a double


% --- Executes during object creation, after setting all properties.
function edit_trint_EKG__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trint_EKG_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_eksp_Rlaikus.
function checkbox_eksp_Rlaikus_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_eksp_Rlaikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_eksp_Rlaikus
if and(get(handles.checkbox_eksp_Rlaikus, 'Value') == 1, ...
        strcmp(get(handles.checkbox_eksp_Rlaikus, 'Enable'),'on'));
    set(handles.checkbox_eksp_Rlaikus_,'Enable','on');
    set(handles.edit_eksp_Rlaikus,'Enable','on');
else
    set(handles.checkbox_eksp_Rlaikus_,'Enable','off');
    set(handles.edit_eksp_Rlaikus,'Enable','off');
end;
checkbox_eksp_Rlaikus__Callback(hObject, eventdata, handles);


% --- Executes on button press in checkbox_eksp_Rlaikus_.
function checkbox_eksp_Rlaikus__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_eksp_Rlaikus_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_eksp_Rlaikus_
if and(get(handles.checkbox_eksp_Rlaikus_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_eksp_Rlaikus_, 'Enable'),'on'));
    set(handles.edit_eksp_Rlaikus_,'Enable','on');
else
    set(handles.edit_eksp_Rlaikus_,'Enable','off');
end;



function edit_eksp_Rlaikus_Callback(hObject, eventdata, handles)
% hObject    handle to edit_eksp_Rlaikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eksp_Rlaikus as text
%        str2double(get(hObject,'String')) returns contents of edit_eksp_Rlaikus as a double


% --- Executes during object creation, after setting all properties.
function edit_eksp_Rlaikus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eksp_Rlaikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_eksp_Rlaikus__Callback(hObject, eventdata, handles)
% hObject    handle to edit_eksp_Rlaikus_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eksp_Rlaikus_ as text
%        str2double(get(hObject,'String')) returns contents of edit_eksp_Rlaikus_ as a double


% --- Executes during object creation, after setting all properties.
function edit_eksp_Rlaikus__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eksp_Rlaikus_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_QRS_saltinis.
function popupmenu_QRS_saltinis_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_QRS_saltinis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_QRS_saltinis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_QRS_saltinis
if get(handles.popupmenu_QRS_saltinis,'Value') == 1;
    set(handles.popupmenu_QRS_algoritmas,'Visible','on');
    set(handles.edit_QRS_saltinis,'Visible','off');
    set(handles.pushbutton_QRS_saltinis,'Visible','off');
    set(handles.popupmenu_QRS_saltinio_galune,'Visible','off');
    set(handles.pushbutton_v3,'Visible','off');
    set(handles.text_QRS_aptikimas,'String',lokaliz('QRS detection algoritm:'));    
else
    set(handles.popupmenu_QRS_algoritmas,'Visible','off');
    set(handles.edit_QRS_saltinis,'Visible','on');
    set(handles.pushbutton_QRS_saltinis,'Visible','on');
    set(handles.popupmenu_QRS_saltinio_galune,'Visible','on');
    set(handles.pushbutton_v3,'Visible','on');
    if get(handles.popupmenu_QRS_saltinis,'Value')==2;
        set(handles.text_QRS_aptikimas,'String',lokaliz('Directory of files with QRS times (1 column, in ms):'));      
        set(handles.text_QRS_aptikimas,'TooltipString',lokaliz('Directory of files with QRS times (1 column, in ms):'));
    else
        set(handles.text_QRS_aptikimas,'String',lokaliz('Directory of *.mat files:'));  
        set(handles.text_QRS_aptikimas,'TooltipString',lokaliz('Directory of *.mat files:'));  
    end;
end;
edit_QRS_saltinis_Callback(hObject, eventdata, handles);
drawnow;

% --- Executes during object creation, after setting all properties.
function popupmenu_QRS_saltinis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_QRS_saltinis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_QRS_saltinis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_QRS_saltinis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_QRS_saltinis as text
%        str2double(get(hObject,'String')) returns contents of edit_QRS_saltinis as a double

KELIAS=pwd;
KELIAS_siulomas=get(handles.edit_QRS_saltinis,'String');

try
    if ~isempty(KELIAS_siulomas);
        cd(KELIAS_siulomas);
    end;
catch err;    
    cd(Tikras_Kelias(get(handles.edit_QRS_saltinis,'TooltipString')));
end;
set(handles.edit_QRS_saltinis,'String',pwd);
set(handles.edit_QRS_saltinis,'TooltipString',pwd);
set(handles.pushbutton_v3,'UserData',...
    unique([get(handles.pushbutton_v3,'UserData') {KELIAS} {pwd} ]));
cd(KELIAS);
set(handles.edit_QRS_saltinis,'BackgroundColor',[1 1 1]);

QRS_saltino_galunes(hObject, eventdata, handles);

Ar_galima_vykdyti(hObject, eventdata, handles);





function QRS_saltino_galunes(hObject, eventdata, handles)
if strcmp(get(handles.popupmenu_QRS_saltinio_galune,'Enable'),'off');
    return;
end;
KELIAS_siulomas=get(handles.edit_QRS_saltinis,'String');
Pasirinkti_failu_indeksai=(get(handles.listbox1,'Value'));
Rodomu_failu_pavadinimai=(get(handles.listbox1,'String'));
Pasirinkti_failu_pavadinimai=Rodomu_failu_pavadinimai(Pasirinkti_failu_indeksai);
Pasirinktu_failu_N=length(Pasirinkti_failu_pavadinimai);

Galunes={};
for i=1:Pasirinktu_failu_N
    Rinkmena=Pasirinkti_failu_pavadinimai{i};
    [~,QRS_rinkmena1,galune]=fileparts(fullfile(Rinkmena));
    
    QRS_rinkmena2=fullfile(KELIAS_siulomas, QRS_rinkmena1  )  ;
    QRS_rinkmena=filter_filenames([QRS_rinkmena2 '*' ]);
    
    QRS_rinkmenos_gal=regexprep(QRS_rinkmena,QRS_rinkmena2,'');
    if isstr(QRS_rinkmenos_gal); QRS_rinkmenos_gal={QRS_rinkmenos_gal}; end;
    
    Galune_tmp=QRS_rinkmenos_gal;
    
    if get(handles.popupmenu_QRS_saltinis,'Value')==2;
        netinkami_regexp={[ '^.*' galune '$' ] '^.*\.set$' '^.*\.fdt$' '^.*\.ica$' '^.*\.cnt$' };
        netinkami={};
        for y=1:length(netinkami_regexp);
            netinkami_tmp=regexp(QRS_rinkmenos_gal,netinkami_regexp{y},'match');
            netinkami_tmp=[netinkami_tmp{:}];
            netinkami={netinkami{:} netinkami_tmp{:}};
        end;
        Galune_tmp=QRS_rinkmenos_gal(find(...
            ismember(QRS_rinkmenos_gal, netinkami)==0));
    else
        Galune_tmp=regexp(QRS_rinkmenos_gal,'^.*\.mat$','match');
        Galune_tmp=[Galune_tmp{:}];
    end;
    
    if isempty(Galunes);
        Galunes=Galune_tmp;
    else
        Galunes=intersect(Galunes,Galune_tmp);
    end;    
end; 
if isempty(Galunes);
    set(handles.popupmenu_QRS_saltinio_galune,'Visible','off');
else
    tmp=get(handles.popupmenu_QRS_saltinio_galune,'TooltipString');
    idx=find(ismember(Galunes,tmp));
    if isempty(idx); idx=1; end;
    set(handles.popupmenu_QRS_saltinio_galune,'String',Galunes);
    set(handles.popupmenu_QRS_saltinio_galune,'Value',idx);
    set(handles.popupmenu_QRS_saltinio_galune,'TooltipString',Galunes{idx});
    if and(length(Galunes)>1, ~strcmp(tmp,Galunes{idx}));
        set(handles.popupmenu_QRS_saltinio_galune,'BackgroundColor',[0 1 0]);
    else        
        set(handles.popupmenu_QRS_saltinio_galune,'BackgroundColor',[1 1 1]);
    end;
    set(handles.popupmenu_QRS_saltinio_galune,'Visible','on');
end;

% --- Executes during object creation, after setting all properties.
function edit_QRS_saltinis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_QRS_saltinis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_QRS_saltinis.
function pushbutton_QRS_saltinis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_QRS_saltinis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
KELIAS=pwd;
try
    cd(get(handles.edit_QRS_saltinis,'String'));
catch err;
end;
KELIAS_ISSAUGOJIMUI=uigetdir;
try
    cd(KELIAS_ISSAUGOJIMUI);
catch err;
    cd(Tikras_Kelias(get(handles.edit_QRS_saltinis,'TooltipString')));
end;
set(handles.edit_QRS_saltinis,'String',pwd);
set(handles.edit_QRS_saltinis,'TooltipString',pwd);
cd(KELIAS);
set(handles.edit_QRS_saltinis,'BackgroundColor',[1 1 1]);
QRS_saltino_galunes(hObject, eventdata, handles);


% --- Executes on key press with focus on edit_QRS_saltinis and none of its controls.
function edit_QRS_saltinis_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_QRS_saltinis (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_QRS_saltinis,'BackgroundColor',[1 1 0]);
Ar_galima_vykdyti(hObject, eventdata, handles);







% --- Executes on selection change in popupmenu_QRS_saltinio_galune.
function popupmenu_QRS_saltinio_galune_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_QRS_saltinio_galune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_QRS_saltinio_galune contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_QRS_saltinio_galune
tmp=get(handles.popupmenu_QRS_saltinio_galune,'String');
set(handles.popupmenu_QRS_saltinio_galune,'TooltipString',...
    tmp{get(handles.popupmenu_QRS_saltinio_galune,'Value')});
set(handles.popupmenu_QRS_saltinio_galune,'BackgroundColor',[1 1 1]);

% --- Executes during object creation, after setting all properties.
function popupmenu_QRS_saltinio_galune_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_QRS_saltinio_galune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popupmenu_QRS_saltinio_galune and none of its controls.
function popupmenu_QRS_saltinio_galune_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_QRS_saltinio_galune (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.popupmenu_QRS_saltinio_galune,'BackgroundColor',[1 1 1]);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu_QRS_saltinio_galune.
function popupmenu_QRS_saltinio_galune_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_QRS_saltinio_galune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popupmenu_QRS_saltinio_galune,'BackgroundColor',[1 1 1]);


% --- Executes on button press in pushbutton_v1.
function pushbutton_v1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_v1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=get(handles.edit1,'String');
p0=''; p={c}; while ~strcmp(p{1},p0); p=[fileparts(p{1}) p]; p0=p{2};  end;
p1=p(2:end);
d=dir(c);
d0={d(find([d.isdir])).name};
d1=arrayfun(@(x) [regexprep(c,[filesep '$'],'') filesep d0{x}], 3:length(d0),'UniformOutput', false);
l=dir(fileparts(c));
l0={l(find([l.isdir])).name};
l1=arrayfun(@(x) [regexprep(fileparts(c),[filesep '$'],'') filesep l0{x}], 3:length(l0),'UniformOutput', false);
p=unique([p1 d1 l1 {pwd} ...    
    [(fileparts(which('eeglab'))) filesep 'sample_data' ] ...
    get(handles.edit2,'String') ...    
    get(handles.edit_QRS_saltinis,'String') ...    
    get(handles.pushbutton_v1,'UserData')  ]);
a=listdlg(...
    'ListString',p,...
    'SelectionMode','single',...
    'InitialValue',find(ismember(p,c)),...
    'ListSize',[500 200],...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
if isempty(a); return; end;
set(handles.edit1,'String',Tikras_Kelias(p{a}));
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);


% --- Executes on button press in pushbutton_v2.
function pushbutton_v2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=get(handles.edit2,'String');
p0=''; p={c}; while ~strcmp(p{1},p0); p=[fileparts(p{1}) p]; p0=p{2};  end;
p1=p(2:end);
d=dir(c);
d0={d(find([d.isdir])).name};
d1=arrayfun(@(x) [regexprep(c,[filesep '$'],'') filesep d0{x}], 3:length(d0),'UniformOutput', false);
l=dir(fileparts(c));
l0={l(find([l.isdir])).name};
l1=arrayfun(@(x) [regexprep(fileparts(c),[filesep '$'],'') filesep l0{x}], 3:length(l0),'UniformOutput', false);
p=unique([p1 d1 l1 {pwd} ...
    regexprep({tempdir}, [filesep '$'], '' )  ...
    get(handles.edit1,'String') ...
    get(handles.edit_QRS_saltinis,'String') ...    
    get(handles.pushbutton_v2,'UserData')  ]);
a=listdlg(...
    'ListString',p,...
    'SelectionMode','single',...
    'InitialValue',find(ismember(p,c)),...
    'ListSize',[500 200],...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
if isempty(a); return; end;
set(handles.edit2,'String',Tikras_Kelias(p{a}));
set(handles.edit2,'TooltipString',Tikras_Kelias(p{a}));
set(handles.pushbutton_v2,'UserData',...
    unique([get(handles.pushbutton_v2,'UserData') c p{a} ]));
set(handles.edit2,'BackgroundColor',[1 1 1]);


% --- Executes on button press in pushbutton_v3.
function pushbutton_v3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_v3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=get(handles.edit_QRS_saltinis,'String');
p0=''; p={c}; while ~strcmp(p{1},p0); p=[fileparts(p{1}) p]; p0=p{2};  end;
p1=p(2:end);
d=dir(c);
d0={d(find([d.isdir])).name};
d1=arrayfun(@(x) [regexprep(c,[filesep '$'],'') filesep d0{x}], 3:length(d0),'UniformOutput', false);
l=dir(fileparts(c));
l0={l(find([l.isdir])).name};
l1=arrayfun(@(x) [regexprep(fileparts(c),[filesep '$'],'') filesep l0{x}], 3:length(l0),'UniformOutput', false);
p=unique([p1 d1 l1 {pwd} ...    
    [(fileparts(which('eeglab'))) filesep 'sample_data' ] ...
    get(handles.edit1,'String') ...    
    get(handles.edit2,'String') ...    
    get(handles.pushbutton_v3,'UserData')  ]);
a=listdlg(...
    'ListString',p,...
    'SelectionMode','single',...
    'InitialValue',find(ismember(p,c)),...
    'ListSize',[500 200],...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
if isempty(a); return; end;
set(handles.edit_QRS_saltinis,'String',Tikras_Kelias(p{a}));
set(handles.pushbutton_v3,'UserData',...
    unique([get(handles.pushbutton_v3,'UserData') c p{a} ]));
set(handles.edit_QRS_saltinis,'BackgroundColor',[1 1 1]);
edit_QRS_saltinis_Callback(hObject, eventdata, handles);
