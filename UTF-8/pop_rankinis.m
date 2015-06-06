%
%
%
%
% Savita komanda
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

function varargout = pop_rankinis(varargin)
% POP_RANKINIS MATLAB code for pop_rankinis.fig
%      POP_RANKINIS, by itself, creates a new POP_RANKINIS or raises the existing
%      singleton*.
%
%      H = POP_RANKINIS returns the handle to a new POP_RANKINIS or the handle to
%      the existing singleton*.
%
%      POP_RANKINIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_RANKINIS.M with the given input arguments.
%
%      POP_RANKINIS('Property','Value',...) creates a new POP_RANKINIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_rankinis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_rankinis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_rankinis

% Last Modified by GUIDE v2.5 20-Nov-2014 17:07:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_rankinis_OpeningFcn, ...
    'gui_OutputFcn',  @pop_rankinis_OutputFcn, ...
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



% --- Executes just before pop_rankinis is made visible.
function pop_rankinis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_rankinis (see VARARGIN)

set(handles.figure1,'Name',mfilename);

%Įsimink prieš funkcijų vykdymą buvusį kelią; netrukus bandysime laikinai pakeisti kelią
Kelias_dabar=pwd;

if isempty(get(handles.text_koduote,'String'))
    set(handles.text_koduote,'String',feature('DefaultCharacterSet'));
end;

tic;

lokalizuoti(hObject, eventdata, handles);
meniu(hObject, eventdata, handles);

% global STUDY CURRENTSTUDY ALLEEG EEG CURRENTSET PLUGINLIST Rinkmena NaujaRinkmena KELIAS KELIAS_SAUGOJIMUI SaugomoNr;


disp(' ');
disp('===================================');
disp('    RANKINIS KOMANDOS NURODYMAS    ');
disp(' ');

%Pabandyk įkelti senąjį kelią
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));   
    cd(Darbeliai.keliai.atverimui{1});
catch err; 
end;
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
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);

KELIAS=pwd;

% Sugrįžk į kelią prieš šios funkcijos atvėrimą
cd(Kelias_dabar);

% Patikrink kelią duomenų išsaugojimui
try
    set(handles.edit2,'String',Darbeliai.keliai.saugojimui{1});
catch err;
    set(handles.edit2,'String','');
end;
edit2_Callback(hObject, eventdata, handles);

set(handles.pushbutton_epoch_iv,'UserData',{});
set(handles.pushbutton14,'UserData',{});

%STUDY = []; CURRENTSTUDY = 0; %ALLEEG = []; EEG=[]; CURRENTSET=[];
%if isempty(findobj('-regexp','name','EEGLAB.*'));
%    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab ;
%end;
%[ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);

%eeglab('redraw');
set(handles.edit_failu_filtras1,'String','*.set;*.cnt;*.edf');

atnaujink_rodomus_failus(hObject, eventdata, handles);

set(handles.text_atlikta_darbu,'Visible','off');
set(handles.text19,'Visible','off'); % atliktų darbų paaiškinimas

parinktis_irasyti(hObject, eventdata, handles, 'numatytas','');

%susaldyk(hObject, eventdata, handles);
susildyk(hObject, eventdata, handles);

tic;

% Choose default command line output for pop_rankinis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_rankinis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function Palauk()

f = warndlg(sprintf('Ar tikrai galime eiti prie kito darbo?'), 'Dėmesio!');
disp('Ar tikrai peržiūrėjote duomenis? Eisime prie kitų darbų.');
drawnow     % Necessary to print the message
waitfor(f);
disp('Einama toliau...');





% --- Outputs from this function are returned to the command line.
function varargout = pop_rankinis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
Ar_galima_vykdyti(hObject, eventdata, handles);


% Neleisk nieko daryti
function susaldyk(hObject, eventdata, handles)
%Neleisti spausti Nuostatų meniu!
a=findall(handles.figure1,'type','uimenu'); 
a=a(find(ismember(get(a,'tag'),'Nuostatos'))) ; 
set(a,'Enable','off'); drawnow;

set(handles.pushbutton1,'Value',0);
set(handles.listbox1,'Enable','inactive');
set(handles.edit1,'Enable','off');
set(handles.edit2,'Enable','off');
set(handles.pushbutton1,'Enable','off');
%set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton3,'Enable','off');
set(handles.pushbutton4,'Enable','off');
set(handles.edit_failu_filtras1,'Enable','off');
set(handles.edit_failu_filtras2,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.pushbutton_epoch_iv,'Enable','off');
set(handles.pushbutton14,'Enable','off');
set(handles.pushbutton_v1,'Enable','off');
set(handles.pushbutton_v2,'Enable','off');
set(handles.radiobutton6,'Enable','off');
set(handles.radiobutton7,'Enable','off');

set(handles.edit51,'Enable','off');
set(handles.edit_epoch_iv,'Enable','off');

set(handles.edit_command,'Enable','off');

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
set(handles.pushbutton_epoch_iv,'Enable','on');
set(handles.pushbutton14,'Enable','on');
set(handles.pushbutton_v1,'Enable','on');
set(handles.pushbutton_v2,'Enable','on');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','off');


set(handles.edit51,'Enable','on');
set(handles.edit_epoch_iv,'Enable','on');

set(handles.edit_command,'Enable','on');

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

% Leisti spausti Nuostatų meniu!
a=findall(handles.figure1,'type','uimenu'); a=a(find(ismember(get(a,'tag'),'Nuostatos'))) ; set(a,'Enable','on'); 


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
% if isempty(get(handles.edit_epoch_iv,'UserData'));
%     set(handles.edit_epoch_iv,'BackgroundColor', [1 1 0]);
%     return;
% end;
% if isempty(get(handles.edit51,'UserData'));
%     set(handles.edit51,'BackgroundColor', [1 1 0]);
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

% Pasirinktų aplankų įsiminimas
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));  
    try
        lst=[{} KELIAS unique(Darbeliai.keliai.atverimui)];
        [~,idx,~]=unique(lst);
        Darbeliai.keliai.atverimui=lst(sort(idx));
    catch err1;
        Darbeliai.keliai.atverimui=[{} KELIAS];
    end;    
    try
        lst=[{} KELIAS_SAUGOJIMUI unique(Darbeliai.keliai.saugojimui)];
        [~,idx,~]=unique(lst);
        Darbeliai.keliai.saugojimui=lst(sort(idx));
    catch err2;
        Darbeliai.keliai.saugojimui=[{} KELIAS_SAUGOJIMUI];
    end;
    save(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'),'Darbeliai');
catch err;
    %warning(err.message);
end;

% Užduočių parinkčių įsiminimas
parinktis_irasyti(hObject, eventdata, handles, 'paskutinis','');
%Neleisti spausti Nuostatų meniu!
a=findall(gcf,'type','uimenu'); a=a(find(ismember(get(a,'tag'),'Nuostatos'))) ; set(a,'Enable','off'); drawnow;

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

Epochuoti_pagal_stimulus_=get(handles.pushbutton_epoch_iv,'UserData') ;
Pasirinkti_kanalai=get(handles.pushbutton14,'UserData');
if ~isempty(Pasirinkti_kanalai);
    Reikalingi_kanalai=Pasirinkti_kanalai;
    Reikalingi_kanalai_sukaupti=Reikalingi_kanalai;
else
    Reikalingi_kanalai={}; %Nebus keičiamas darbų eigoje
    Reikalingi_kanalai_sukaupti={}; % bus keičiamas darbų eigoje
end;
ribos=str2num(get(handles.edit51,'String'));%*1000;

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

%%

for i=1:Pasirinktu_failu_N;
    Rinkmena=Pasirinkti_failu_pavadinimai{i};
    [KELIAS_,Rinkmena_,galune]=fileparts(fullfile(KELIAS,Rinkmena));
    Rinkmena_=[Rinkmena_ galune];
    KELIAS_=Tikras_Kelias(KELIAS_);
    NaujaRinkmena=Rinkmena_;
    disp(sprintf([lokaliz('Opened file') ' %d/%d (%.2f%%) %s'], i, Pasirinktu_failu_N, i/Pasirinktu_failu_N*100, Rinkmena));
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    SaugomoNr=1+str2num(get(handles.text_atlikta_darbu,'String'));
    DarboNr=0;
    DarboPorcijaAtlikta=0;
    PaskutinioIssaugotoDarboNr=0;
    PaskRinkmIssaugKelias=KELIAS;
    
    %guidata(hObject, handles);
    Darbo_eigos_busena(handles, lokaliz('Loading data...'), DarboNr, i, Pasirinktu_failu_N);
    
    % Ikelti
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
        %eeglab redraw;
        
        
        % Darbas
        Darbo_apibudinimas=[ lokaliz('Darbas') '...'];
        %if get(handles.checkbox_kanalu_padetis,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));
                
                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);
                
                try
                    com=get(handles.edit_command,'String');
                    if iscell(com);
                        com=sprintf('%s \n',com{:});
                    end;
                    
                    skaiciai=str2num(get(handles.edit51,'String'));
                    
                    try
                    Pasirinkti_kanalai_yra_Nr=find(ismember({EEG.chanlocs.labels},Pasirinkti_kanalai));
                    Pasirinkti_kanalai_yra=Pasirinkti_kanalai(find(ismember(Pasirinkti_kanalai,{EEG.chanlocs.labels})));
                    catch err;
                        Pasirinkti_kanalai_yra_Nr=[];
                        Pasirinkti_kanalai_yra={};
                    end;
                    
                    Epochuoti_pagal_stimulus_=get(handles.pushbutton_epoch_iv,'UserData') ;
                    Epochuoti_pagal_stimulus={};
                    for i_epoch=1:length(Epochuoti_pagal_stimulus_) ;
                        try
                            orig_epoch=Epochuoti_pagal_stimulus_{i_epoch}; % teksto eilutėms
                        catch
                            orig_epoch=Epochuoti_pagal_stimulus_(i_epoch); % skaičiams
                        end;
                        %disp(orig_epoch);disp(isstr(orig_epoch));
                        if isnumeric(orig_epoch);
                                Epochuoti_pagal_stimulus=[Epochuoti_pagal_stimulus num2str(orig_epoch)];
                        elseif isstr(orig_epoch);
                            if isstr(EEG.event(1).type);
                                Epochuoti_pagal_stimulus=[Epochuoti_pagal_stimulus orig_epoch];
                            else
                                Epochuoti_pagal_stimulus=[Epochuoti_pagal_stimulus num2str(str2num(orig_epoch))];
                            end;                            
                        else
                            warning([lokaliz('Internal error') '. ']);
                            disp(orig_epoch);
                        end;
                    end;
                    
                    
                    EEG=eval2(com,...
                        EEG,...
                        KELIAS_,NaujaRinkmena,...
                        skaiciai,...
                        Pasirinkti_kanalai,Pasirinkti_kanalai_yra,Pasirinkti_kanalai_yra_Nr,...
                        Epochuoti_pagal_stimulus,...
                        handles);
                    
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Darbas'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;
                
                
                % Išsaugoti
                %Priesaga=(get(handles.edit_kanalu_padetis,'String')) ;
                %Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_kanalu_padetis_,'String')) ] ;
                %[~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                %if get(handles.checkbox_kanalu_padetis_,'Value') == 1 ;
                %    Issaugoti(ALLEEG,EEG,KELIAS_SAUGOJIMUI,Poaplankis,NaujaRinkmena);
                %    PaskutinioIssaugotoDarboNr=DarboNr;
                %    DarboPorcijaAtlikta = 1;
                %    SaugomoNr = SaugomoNr +1;
                %    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                %else
                    PaskRinkmIssaugKelias='';
                %end;
                
                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_kanalu_padetis,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;
                
            end;
        %end;
        
        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;
               
        
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
        %disp(str);
        
        if and(~isempty(EEG),DarboPorcijaAtlikta);
            if EEG.nbchan > 0 ;
                NaujosRinkmenos=get(handles.listbox2,'String');
                NaujosRinkmenos{i}=NaujaRinkmena;
                set(handles.listbox2,'String',NaujosRinkmenos);
                disp(['+']);
            end;
        end;
        
    else
        msgbox(sprintf([lokaliz('Time:') ' %s\n' lokaliz('Path:') ' %s\n' lokaliz('File:') ' %s'], ...
               t, pwd, Rinkmena),lokaliz('Empty dataset'),'error');
    end;
    
    % Isvalyti atminti
    %STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
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
        set(handles.edit_failu_filtras2,'BackgroundColor','remove');
        set(handles.edit_failu_filtras2,'Style','pushbutton');
        set(handles.edit_failu_filtras2,'String',lokaliz('Filter'));
        %if ~strcmp(char(mfilename),'pop_rankinis');
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
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0, ...
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
    uipanel15_SelectionChangeFcn(hObject, eventdata, handles);
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
    set(handles.edit_failu_filtras1,'String','*.set;*.cnt;*.edf');
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
                        %        pop_rankinis;
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


function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double
elementas=handles.edit51;
x=str2num(get(elementas,'String'));
if isempty(x);
    set(elementas,'UserData','');
else
    set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));
end;
set(elementas,'BackgroundColor',[1 1 1]);
set(elementas,'String',num2str(get(elementas,'UserData')));
%edit57_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_epoch_iv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epoch_iv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epoch_iv as text
%        str2double(get(hObject,'String')) returns contents of edit_epoch_iv as a double
elementas=handles.edit_epoch_iv;
set(elementas,'BackgroundColor',[1 1 1]);
str=get(elementas,'String');
x=unique(str2num(str));
if length(x) > 0 ;
    x_txt=num2str2(x);
    set(elementas,'UserData',regexprep(x_txt, '[ ]*', ' '));
    set(handles.pushbutton_epoch_iv,'UserData',...
        cellfun(@(i) num2str(x(i)), ...
        num2cell(1:length(x)),...
        'UniformOutput', false));
elseif isempty(str);
    set(elementas,'UserData','');
    set(handles.pushbutton_epoch_iv,'UserData',{});
else
    iv=get(handles.pushbutton_epoch_iv,'UserData');
    try
        senas_str=regexprep(sprintf('%s ', iv{:}),' $','');
        senas_x=str2num(senas_str);
        if ~isempty(senas_x); senas_str=num2str2(senas_x); end;
        set(elementas,'UserData',senas_str);
    catch err;
        %set(elementas,'UserData',sprintf('%d ', iv));
    end;        
    warning(lokaliz('This version allow to select any real events from dataset, but manually you can enter only numbers.'));
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
str=get(elementas,'String');
set(elementas,'TooltipString',str);
% if ~isempty(str);
     set(elementas,'BackgroundColor',[1 1 1]);
% else
%     set(elementas,'BackgroundColor',[1 1 0]);
% end;
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_epoch_iv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epoch_iv (see GCBO)
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


function lokalizuoti(hObject, eventdata, handles)
set(handles.pushbutton1,'String',lokaliz('Execute'));
set(handles.pushbutton2,'String',lokaliz('Close'));
set(handles.pushbutton4,'String',lokaliz('Update'));
set(handles.pushbutton_epoch_iv,'String',lokaliz('Events...'));
set(handles.pushbutton14,'String',lokaliz('Channels...'));
set(handles.uipanel3,'Title',lokaliz('Options'));
set(handles.uipanel4,'Title',lokaliz('File filter'));
set(handles.uipanel5,'Title',lokaliz('Files for work'));
set(handles.uipanel15,'Title',lokaliz('File loading options'));
set(handles.uipanel16,'Title',lokaliz('File saving options'));
set(handles.uipanel17,'Title',lokaliz('Task'));
set(handles.uipanel18,'Title',lokaliz('Code'));
set(handles.text24,'String', [lokaliz('Time interval') ]);
set(handles.text_failu_filtras1,'String',lokaliz('Show_filenames_filter:'));
set(handles.text_failu_filtras2,'String',lokaliz('Select_filenames_filter:'));
set(handles.checkbox_uzverti_pabaigus,'String',lokaliz('Close when complete'));
set(handles.checkbox_baigti_anksciau,'String',lokaliz('Break work'));
set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'String',lokaliz('Go to saved files directory when completed'));
set(handles.checkbox_pabaigus_atverti,'String',lokaliz('Load saved files in EEGLAB when completed'));
set(handles.radiobutton6,'String',lokaliz('through data'));
set(handles.radiobutton7,'String',lokaliz('through functions'));
set(handles.text7,'String', lokaliz('After interim saved job go'));
set(handles.text19,'String', lokaliz('# of done jobs for subdir names'));
set(handles.edit_command,'String',{ ...
   [ '% ' lokaliz('Predefined variables:') ] ...
   [ '% EEG                       - EEGLAB EEG ' lokaliz('variable') ] ...
   [ '% laiko_intervalas          - ' lokaliz('selected time interval') ] ...
   [ '% Pasirinkti_ivykiai        - ' lokaliz('selected events') ] ...
   [ '% Pasirinkti_kanalai        - ' lokaliz('names of selected channels') ] ...
   [ '% Pasirinkti_kanalai_yra_Nr - ' lokaliz('irase esamu pasirinktu kanalu nr - 1') ] ...
   [ '%                             ' lokaliz('irase esamu pasirinktu kanalu nr - 2') ] ...
   [ '% ' lokaliz('Your command:') ] ...
   [ ' ' ] ...
   [ 'EEG = eeg_checkset(EEG);' ] ...
   [ ' ' ] });

% --- Executes on button press in pushbutton_epoch_iv.
function pushbutton_epoch_iv_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_epoch_iv (see GCBO)
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
set(handles.pushbutton_epoch_iv,'Enable','off'); drawnow;
[~,visi_galimi_ivykiai,bendri_ivykiai]=eeg_ivykiu_sarasas (get(handles.edit1,'String'), RINKMENOS);
set(handles.pushbutton_epoch_iv,'Enable','on');
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
        pradinis_pasirinkimas=[1:length(bendri_ivykiai)];
    else
        pateikiami_ivykiai={lokaliz('(all common:)') bendri_ivykiai{:} };
        pateikiami_bendri_v=1;
        pradinis_pasirinkimas=[2:length(bendri_ivykiai)+1];
    end;
end;
nebendri_idx=find(ismember(visi_galimi_ivykiai,bendri_ivykiai) == 0);
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
    pateikiami_ivykiai={pateikiami_ivykiai{:} lokaliz('(not common:)') visi_galimi_ivykiai{nebendri_idx} };
    pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_ivykiai);
    if ~pateikiami_bendri_v;
        pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_ivykiai) + pateikiami_bendri_v + 1 ) ];
    end;
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
senas=get(handles.pushbutton_epoch_iv,'UserData');
if ~isempty(senas);
    pradinis_pasirinkimas=find(ismember(pateikiami_ivykiai,senas)==1);
end;
if ~iscellstr(pateikiami_ivykiai);
    warning(lokaliz('unexpected events types.'),lokaliz('Selection of events'));
    disp(pateikiami_ivykiai);
    return;
end;
pasirinkti_ivykiai_idx=listdlg('ListString', pateikiami_ivykiai,...
    'SelectionMode','multiple',...
    'PromptString', lokaliz('Select events:'),...
    'InitialValue',pradinis_pasirinkimas );
if isempty(pasirinkti_ivykiai_idx); return ; end;
pasirinkti_ivykiai={};
if ismember(pateikiami_bendri_v,pasirinkti_ivykiai_idx);
    pasirinkti_ivykiai={pasirinkti_ivykiai{:} bendri_ivykiai{:} };
end;
if ismember(pateikiami_nebendri_v,pasirinkti_ivykiai_idx);
    pasirinkti_ivykiai={pasirinkti_ivykiai{:} visi_galimi_ivykiai{nebendri_idx} };
end;
pasirinkti_ivykiai_idx_=pasirinkti_ivykiai_idx(find(ismember(pasirinkti_ivykiai_idx, [pateikiami_bendri_v pateikiami_nebendri_v])==0));
pasirinkti_ivykiai=unique({pasirinkti_ivykiai{:} pateikiami_ivykiai{pasirinkti_ivykiai_idx_}});
pasirinkti_ivykiai_str=pasirinkti_ivykiai{1};
for i=2:length(pasirinkti_ivykiai);
    pasirinkti_ivykiai_str=[pasirinkti_ivykiai_str ' ' pasirinkti_ivykiai{i}];
end;
set(handles.pushbutton_epoch_iv,'UserData',pasirinkti_ivykiai);
set(handles.edit_epoch_iv,'TooltipString',pasirinkti_ivykiai_str);
set(handles.edit_epoch_iv,'String',pasirinkti_ivykiai_str);
%set(handles.edit_epoch_iv,'UserData',pasirinkti_ivykiai_str);
if ~isempty(str2num(pasirinkti_ivykiai_str));
    edit_epoch_iv_Callback(hObject, eventdata, handles);
else
    set(handles.edit_epoch_iv,'BackgroundColor',[1 1 1]);
end;

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
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
set(handles.pushbutton14,'Enable','off'); drawnow;
[~,visi_galimi_kanalai,bendri_kanalai]=eeg_kanalu_sarasas (get(handles.edit1,'String'), RINKMENOS);
set(handles.pushbutton14,'Enable','on');
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
        pradinis_pasirinkimas=[1:length(bendri_kanalai)];
    else
        pateikiami_kanalai={lokaliz('(all common:)') bendri_kanalai{:} };
        pateikiami_bendri_v=1;
        pradinis_pasirinkimas=[2:(length(bendri_kanalai)+1)];
    end;
end;
nebendri_idx=find(ismember(visi_galimi_kanalai,bendri_kanalai) == 0);
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
    pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(not common:)') visi_galimi_kanalai{nebendri_idx} };
    pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_kanalai);
    if ~pateikiami_bendri_v;
        pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_kanalai) + pateikiami_bendri_v + 1 ) ];
    end;
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
Ankstesni_kanalai=get(handles.text47,'TooltipString');
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
pasirinkti_kanalai_idx=listdlg('ListString', pateikiami_kanalai,...
    'SelectionMode','multiple',...
    'PromptString', lokaliz('Select channels:'),...
    'InitialValue',pradinis_pasirinkimas );
if isempty(pasirinkti_kanalai_idx); return ; end;
pasirinkti_kanalai={};
if ismember(pateikiami_bendri_v,pasirinkti_kanalai_idx);
    pasirinkti_kanalai={pasirinkti_kanalai{:} bendri_kanalai{:} };
end;
if ismember(pateikiami_nebendri_v,pasirinkti_kanalai_idx);
    pasirinkti_kanalai={pasirinkti_kanalai{:} visi_galimi_kanalai{nebendri_idx} };
end;
pasirinkti_kanalai_idx_=pasirinkti_kanalai_idx(find(ismember(pasirinkti_kanalai_idx, [pateikiami_bendri_v pateikiami_nebendri_v])==0));
pasirinkti_kanalai=unique({pasirinkti_kanalai{:} pateikiami_kanalai{pasirinkti_kanalai_idx_}});
pasirinkti_kanalai_str=[pasirinkti_kanalai{1}];
for i=2:length(pasirinkti_kanalai);
    pasirinkti_kanalai_str=[pasirinkti_kanalai_str ' ' pasirinkti_kanalai{i}];
end;
disp([ '''' regexprep(pasirinkti_kanalai_str, ' ', ''' ''') '''' ]);
if ~isempty(pasirinkti_kanalai_str) ;
    set(handles.text47,'String',length(pasirinkti_kanalai));
    set(handles.text47,'TooltipString',pasirinkti_kanalai_str);
    set(handles.pushbutton14,'BackgroundColor','remove');
    set(handles.pushbutton14,'UserData',pasirinkti_kanalai);
else
    set(handles.text47,'String','?');
    set(handles.text47,'TooltipString','');
    set(handles.pushbutton14,'BackgroundColor',[1 1 0]);
    set(handles.pushbutton14,'UserData',{});
end;




function edit_command_Callback(hObject, eventdata, handles)
% hObject    handle to edit_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_command as text
%        str2double(get(hObject,'String')) returns contents of edit_command as a double


% --- Executes during object creation, after setting all properties.
function edit_command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




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

% ankstesnių seansų kelių įkėlimas
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));   
catch err;    
    %warning(err.message);
end;
try x=strcmp(Darbeliai.keliai.atverimui{1},'');
catch err; 
    %warning(err.message);
    Darbeliai.keliai.atverimui={};    
end;
s0=[{} [(fileparts(which('eeglab'))) filesep 'sample_data' ] ...
    Darbeliai.keliai.atverimui ...
    get(handles.pushbutton_v1,'UserData') ];
s1={} ; 
for x=1:length(s0) ; 
    if strcmp(s0{x}, Tikras_Kelias(s0{x}));
        s1=[s1 s0{x}] ;
    end;
end;

p=unique([p1 d1 l1 s1 {pwd} ...    
    get(handles.edit2,'String')]);
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

% anksčiau pasirinktų kelių įkėlimas
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));   
catch err;    
    %warning(err.message);
end;
try x=strcmp(Darbeliai.keliai.saugojimui{1},'');
catch err; 
    %warning(err.message);
    Darbeliai.keliai.saugojimui={};    
end;
s0=[{} Darbeliai.keliai.saugojimui ...
    get(handles.pushbutton_v2,'UserData') ];
s1={} ; 
for x=1:length(s0) ; 
    if strcmp(s0{x}, Tikras_Kelias(s0{x}));
        s1=[s1 s0{x}] ;
    end;
end;

p=unique([p1 d1 l1 s1 {pwd} ...
    regexprep({tempdir}, [filesep '$'], '' )  ...
    get(handles.edit1,'String') ]);
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

function EEG=eval2(com,EEG, KELIAS_,NaujaRinkmena,laiko_intervalas,...
                        Pasirinkti_kanalai,Pasirinkti_kanalai_yra,Pasirinkti_kanalai_yra_Nr,...
                        Pasirinkti_ivykiai,...
                        handles)
eval(com);


function parinktis_ikelti(hObject, eventdata, handles, rinkinys)
susaldyk(hObject, eventdata, handles);
% Įkelti ankstenius nustatymus
try    
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));   
    esami={Darbeliai.dialogai.pop_rankinis.saranka.vardas};
    i=find(ismember(esami,rinkinys));
    Parinktys=Darbeliai.dialogai.pop_rankinis.saranka(i).parinktys;
    for i=1:length(Parinktys);
        try
            set(eval(['handles.' Parinktys(i).id ]), ...
                'Value',         Parinktys(i).Value );
            set(eval(['handles.' Parinktys(i).id ]), ...
                'UserData',      Parinktys(i).UserData );
            if Parinktys(i).String_ ;
                set(eval(['handles.' Parinktys(i).id ]), ...
                    'String',        Parinktys(i).String );
            end;
            if Parinktys(i).TooltipString_ ;
                set(eval(['handles.' Parinktys(i).id ]), ...
                    'TooltipString', Parinktys(i).TooltipString );
            end;
        catch err;
            Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
        end;
    end;
catch err;
    %Pranesk_apie_klaida(err, '', '', 0);
end;
susildyk(hObject, eventdata, handles);

function parinktis_irasyti(hObject, eventdata, handles, vardas, komentaras)
reikia_perkurti_meniu=0;
if isempty(vardas); 
    a=inputdlg({lokaliz('Pavadinimas:'),lokaliz('Komentaras:')}); 
    if isempty(a); return; end;
    if iscell(a);
        if isempty(a{1});
            vardas='paskutinis';
            komentaras='';
        else
            vardas=a{1};
            komentaras=a{2};
        end;
    end;
end;
    
try
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));  
    esami={Darbeliai.dialogai.pop_rankinis.saranka.vardas};
    if and(ismember(vardas,esami),~ismember(vardas,{'numatytas','paskutinis'}));
        ats=questdlg(lokaliz('Perrašyti nuostatų rinkinį?'),lokaliz('Nuostatos jau yra!'),lokaliz('Rewrite'),lokaliz('Cancel'),lokaliz('Cancel'));
        if isempty(ats); return; end;
        if ~strcmp(ats,lokaliz('Rewrite')); return; end;
        reikia_perkurti_meniu=1;
    end;
catch err;
    %Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
end;

% Užduočių parinktys
Parinktys=struct('id','','Value','','UserData','','String_','','String','','TooltipString_','','TooltipString','');
isimintini_el={'checkbox_uzverti_pabaigus' 'checkbox_pabaigus_atverti' 'checkbox_pabaigus_i_apdorotu_aplanka' ...
    'pushbutton14' 'pushbutton_epoch_iv' 'radiobutton6' 'radiobutton7' };
for i=1:length(isimintini_el);
    try
        Parinktys(i).id = isimintini_el{i} ;
        Parinktys(i).Value    = get(eval(['handles.' isimintini_el{i}]), 'Value');
        Parinktys(i).UserData = get(eval(['handles.' isimintini_el{i}]), 'UserData');
        Parinktys(i).String_  = 0;
        Parinktys(i).TooltipString_ = 0;
    catch err;
        Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
    end;
end;
isimintini_el={ 'edit51' 'edit_command' };
for i=1:length(isimintini_el);
    try
        Parinktys(end+1).id = isimintini_el{i} ;
        Parinktys(end).Value    = get(eval(['handles.' isimintini_el{i}]), 'Value');
        Parinktys(end).UserData = get(eval(['handles.' isimintini_el{i}]), 'UserData');
        Parinktys(end).String_  = 1;
        Parinktys(end).String   = get(eval(['handles.' isimintini_el{i}]), 'String');
        Parinktys(end).TooltipString_ = 0 ;
    catch err;
        Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
    end;
end;
isimintini_el={ 'text47' 'edit_epoch_iv' };
for i=1:length(isimintini_el);
    try
        Parinktys(end+1).id = isimintini_el{i} ;
        Parinktys(end).Value    = get(eval(['handles.' isimintini_el{i}]), 'Value');
        Parinktys(end).UserData = get(eval(['handles.' isimintini_el{i}]), 'UserData');
        Parinktys(end).String_  = 1;
        Parinktys(end).String   = get(eval(['handles.' isimintini_el{i}]), 'String');
        Parinktys(end).TooltipString_ = 1;
        Parinktys(end).TooltipString   = get(eval(['handles.' isimintini_el{i}]), 'TooltipString');
    catch err;
        Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
    end;
end;

try
    i=find(ismember(esami,vardas));
    if isempty(i);
        i=length(esami)+1; 
        reikia_perkurti_meniu=1;
    end;
catch err;
    i=1;
end;
Darbeliai.dialogai.pop_rankinis.saranka(i).vardas    = vardas ;
Darbeliai.dialogai.pop_rankinis.saranka(i).data      = datestr(now,'yyyy-mm-dd HH:MM:SS') ;
Darbeliai.dialogai.pop_rankinis.saranka(i).komentaras= [ komentaras ' ' ] ;
Darbeliai.dialogai.pop_rankinis.saranka(i).parinktys = Parinktys ;

% Įrašymas
try
    save(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'),'Darbeliai');
catch err;
    %Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
end;
if reikia_perkurti_meniu; meniu(hObject, eventdata, handles); end;

function parinktis_trinti(hObject, eventdata, handles)
try
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));  
    esami={Darbeliai.dialogai.pop_rankinis.saranka.vardas};
    esami_N=length(esami);
    esami_nr=find(~ismember(esami,{'numatytas','paskutinis'}));
    esami=esami(esami_nr);
    if isempty(esami); return; end;
catch err;
    %Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
    return;
end;
pasirinkti=listdlg('ListString', esami,...
    'SelectionMode','multiple',...
    'PromptString', lokaliz('Trinti:'),...
    'InitialValue',length(esami),...
    'OKString',lokaliz('Trinti'),...
    'CancelString',lokaliz('Cancel'));
if isempty(pasirinkti); return; end;
Darbeliai.dialogai.pop_rankinis.saranka= ...
    Darbeliai.dialogai.pop_rankinis.saranka(...
    setdiff([1:esami_N], esami_nr(pasirinkti)));
% Įrašymas
try
    save(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'),'Darbeliai');
catch err;
    Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
end;
meniu(hObject, eventdata, handles);

function meniu(hObject, eventdata, handles)
delete(findall(handles.figure1,'type','uimenu'));
yra_isimintu_rinkiniu=0;
handles.meniu_nuostatos = uimenu(handles.figure1,'Label',lokaliz('Nuostatos'),'Tag','Nuostatos');
handles.meniu_nuostatos_ikelti = uimenu(handles.meniu_nuostatos,'Label',lokaliz('Ikelti'));
uimenu(handles.meniu_nuostatos_ikelti,'Label',lokaliz('Numatytas'),'Accelerator','R','Callback',{@parinktis_ikelti,handles,'numatytas'});
try
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));
    par_pav={ Darbeliai.dialogai.pop_rankinis.saranka.vardas };
    if ismember('paskutinis',par_pav);
        uimenu(handles.meniu_nuostatos_ikelti,'Label',lokaliz('Paskiausias'),'Separator','off',...
            'Accelerator','0','Callback',{@parinktis_ikelti,handles,'paskutinis'});
    end;
    ids=find(~ismember(par_pav,{'numatytas','paskutinis'}));
    par_pav=par_pav(ids);
    par_dat={ Darbeliai.dialogai.pop_rankinis.saranka.data };       par_dat=par_dat(ids);
    par_kom={ Darbeliai.dialogai.pop_rankinis.saranka.komentaras }; par_kom=par_kom(ids);
    if ~isempty(par_pav); yra_isimintu_rinkiniu=1 ; end; 
    for i=1:length(par_pav);
        el=uimenu(handles.meniu_nuostatos_ikelti,...
            'Label', ['<html><font size="-2" color="#ADD8E6">' par_dat{i} '</font> ' ...
            par_pav{i} ' <br><font size="-2" color="#ADD8E6">' par_kom{i} '</font></html>'],...
            'Separator',fastif(i==1,'on','off'),...
            'Accelerator',num2str(i),...
            'Callback',{@parinktis_ikelti,handles,par_pav{i}});
    end;
catch err;
    Pranesk_apie_klaida(err, 'pop_rankinis.m', '-', 0);
end;
%handles.meniu_nuostatos_irasyti = uimenu(handles.meniu_nuostatos,'Label','Įrašyti');
%uimenu(handles.meniu_nuostatos_irasyti,'Label','Kaip paskutines','Callback',{@parinktis_irasyti,handles,'paskutinis',''});
uimenu(handles.meniu_nuostatos,'Label',lokaliz('Saugoti...'),...
    'Accelerator','S','Callback',{@parinktis_irasyti,handles,'',''});
uimenu(handles.meniu_nuostatos,'Label',lokaliz('Trinti...'),...
    'Enable',fastif(yra_isimintu_rinkiniu==1,'on','off'),'Callback',{@parinktis_trinti,handles});

handles.meniu_apie = uimenu(handles.figure1,'Label',lokaliz('Pagalba'));
if strcmp(char(java.util.Locale.getDefault()),'lt_LT');
    uimenu( handles.meniu_apie, 'Label', 'Darbeliai...', 'callback', ...
        'web(''https://github.com/embar-/eeglab_darbeliai/wiki/0.%20LT'',''-browser'') ;'  );
    uimenu( handles.meniu_apie, 'Label', lokaliz('Custom command'), ...
        'Accelerator','H', 'callback', ...
        'web(''https://github.com/embar-/eeglab_darbeliai/wiki/3.7.%20Savos%20komandos%20vykdymas'',''-browser'') ;'  );
else
    uimenu( handles.meniu_apie, 'Label', 'Darbeliai...', 'callback', ...
        'web(''https://github.com/embar-/eeglab_darbeliai/wiki/0.%20EN'',''-browser'') ;'  );
    uimenu( handles.meniu_apie, 'Label', lokaliz('Custom command'), ...
        'Accelerator','H', 'callback', ...
        'web(''https://github.com/embar-/eeglab_darbeliai/wiki/3.7.%20Custom%20command'',''-browser'') ;'  );
end;
