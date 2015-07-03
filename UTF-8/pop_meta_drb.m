%
%
% Darbų vykdymas pagal iš anksto aprašytus jų parinkčių rinkinius
%
% GUI versija
%
%
% (C) 2014-2015 Mindaugas Baranauskas
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

function varargout = pop_meta_drb(varargin)
% POP_META_DRB MATLAB code for pop_meta_drb.fig
%      POP_META_DRB, by itself, creates a new POP_META_DRB or raises the existing
%      singleton*.
%
%      H = POP_META_DRB returns the handle to a new POP_META_DRB or the handle to
%      the existing singleton*.
%
%      POP_META_DRB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_META_DRB.M with the given input arguments.
%
%      POP_META_DRB('Property','Value',...) creates a new POP_META_DRB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_meta_drb_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_meta_drb_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_meta_drb

% Last Modified by GUIDE v2.5 03-Jul-2015 09:52:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_meta_drb_OpeningFcn, ...
    'gui_OutputFcn',  @pop_meta_drb_OutputFcn, ...
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



% --- Executes just before pop_meta_drb is made visible.
function pop_meta_drb_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_meta_drb (see VARARGIN)

if and(nargin > 3, mod(nargin, 2)) ;
    if iscellstr(varargin((1:(nargin-3)/2)*2-1)); 
        g = struct(varargin{:});
    else  warning(lokaliz('Netinkami parametrai'));
        g=[];     end;
else    g=[];
end;

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

%clc;
disp(' ');
disp('===================================');
disp('      M E T A     D A R B A I      ');
disp(' ');

%Pabandyk įkelti senąjį kelią
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));   
    cd(Darbeliai.keliai.atverimui{1});
catch err; 
end;

% Pabandyk nustatyti kelią pagal parametrus
try set(handles.edit1,'String',g(1).path);   catch err; end;
try set(handles.edit1,'String',g(1).pathin); catch err; end;
% Pabandyk parinkti rinkmenas pagal parametrus
try
    if ~isempty({g.files});
        set(handles.listbox2,'String',{g.files});
        set(handles.edit_failu_filtras2,'Style','edit'); % 'pushbutton'
        edit_failu_filtras2_ButtonDownFcn(hObject, eventdata, handles);
    end;
catch err;
end;

set(handles.pushbutton_v1,'UserData',{});
set(handles.pushbutton_v2,'UserData',{});
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);

% Sugrįžk į kelią prieš šios funkcijos atvėrimą
cd(Kelias_dabar);

% Patikrink kelią duomenų išsaugojimui
try
    set(handles.edit2,'String',Darbeliai.keliai.saugojimui{1});
catch err;
    set(handles.edit2,'String','');
end;
try set(handles.edit2,'String',g(1).path);    catch err; end;
try set(handles.edit2,'String',g(1).pathout); catch err; end;
edit2_Callback(hObject, eventdata, handles);

set(handles.edit_failu_filtras1,'String','*.set;*.cnt;*.edf');
try set(handles.edit_failu_filtras1,'String',g(1).flt_show); catch err; end;
try 
    if ~isempty(g(1).flt_slct);    
        set(handles.edit_failu_filtras2,'Style','pushbutton'); % 'edit'
        edit_failu_filtras2_ButtonDownFcn(hObject, eventdata, handles);
        set(handles.edit_failu_filtras2,'String',g(1).flt_slct);
    end
catch err; 
end;

atnaujink_rodomus_failus(hObject, eventdata, handles);

parinktis_irasyti(hObject, eventdata, handles, 'numatytas','');
try 
    parinktis_ikelti(hObject, eventdata, handles, g(1).preset); 
catch err; 
    susildyk(hObject, eventdata, handles);
end;

try set(handles.text_atlikta_darbu,'String',num2str(g(1).counter)); catch err; end;
set(handles.checkbox_uzverti_pabaigus,'UserData',0);

tic;

% Choose default command line output for pop_meta_drb
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Jei prašoma, vykdyti automatiškai
try 
    if strcmp(g(1).mode,'exec');
        Ar_galima_vykdyti(hObject, eventdata, handles);
        if strcmp(get(handles.pushbutton1,'Enable'),'on');
            set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'Enable','off');
            set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'Value',1);
            set(handles.checkbox_uzverti_pabaigus,'UserData',1);
            set(handles.checkbox_uzverti_pabaigus,'Value',1);
            %set(handles.checkbox_pabaigus_atverti,'Value',0);
            pushbutton1_Callback(hObject, eventdata, handles);
        end;
    end;
catch err;
end;

% UIWAIT makes pop_meta_drb wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function Palauk()

f = warndlg(sprintf('Ar tikrai galime eiti prie kito darbo?'), 'Dėmesio!');
disp('Ar tikrai peržiūrėjote duomenis? Eisime prie kitų darbų.');
drawnow     % Necessary to print the message
waitfor(f);
disp('Einama toliau...');





% --- Outputs from this function are returned to the command line.
function varargout = pop_meta_drb_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
try
    varargout{1} = handles.output;
    varargout{2} = get(handles.edit1,'String'); % kelias
    varargout{3} = get(handles.listbox2,'String'); % rinkmenos    
    varargout{4} = varargout{3}(find(cellfun(@exist,fullfile(varargout{2},varargout{3}))==2)); % esamos rinkmenos
    varargout{5} = str2num(get(handles.text_atlikta_darbu,'String')); % skaitliukas
catch err;
    varargout{1} = [];
    varargout{2} = '';
    varargout{3} = {};
    varargout{4} = {};
    varargout{5} = [];
end;

% Užverti langą, jei nurodyta parinktyse
try    
    if and( get(handles.checkbox_uzverti_pabaigus,'UserData'),...
            get(handles.checkbox_uzverti_pabaigus,'Value'));
        delete(handles.figure1);
    end;
catch err;
end;


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
set(handles.pushbutton_v1,'Enable','off');
set(handles.pushbutton_v2,'Enable','off');
set(handles.radiobutton6,'Enable','off');
set(handles.radiobutton7,'Enable','off');

set(handles.checkbox_drb1,'Enable','off');
set(handles.checkbox_drb2,'Enable','off');
set(handles.checkbox_drb3,'Enable','off');
set(handles.checkbox_drb4,'Enable','off');
set(handles.checkbox_drb5,'Enable','off');
set(handles.checkbox_drb6,'Enable','off');
set(handles.checkbox_drb7,'Enable','off');
set(handles.checkbox_drb8,'Enable','off');
set(handles.checkbox_drb9,'Enable','off');
set(handles.checkbox_drb10,'Enable','off');
checkbox_drb1_Callback(hObject, eventdata, handles);
checkbox_drb2_Callback(hObject, eventdata, handles);
checkbox_drb3_Callback(hObject, eventdata, handles);
checkbox_drb4_Callback(hObject, eventdata, handles);
checkbox_drb5_Callback(hObject, eventdata, handles);
checkbox_drb6_Callback(hObject, eventdata, handles);
checkbox_drb7_Callback(hObject, eventdata, handles);
checkbox_drb8_Callback(hObject, eventdata, handles);
checkbox_drb9_Callback(hObject, eventdata, handles);
checkbox_drb10_Callback(hObject, eventdata, handles);

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
set(handles.pushbutton_v1,'Enable','on');
set(handles.pushbutton_v2,'Enable','on');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','off');

set(handles.checkbox_drb1,'Enable','on');
set(handles.checkbox_drb2,'Enable','on');
set(handles.checkbox_drb3,'Enable','on');
set(handles.checkbox_drb4,'Enable','on');
set(handles.checkbox_drb5,'Enable','on');
set(handles.checkbox_drb6,'Enable','on');
set(handles.checkbox_drb7,'Enable','on');
set(handles.checkbox_drb8,'Enable','on');
set(handles.checkbox_drb9,'Enable','on');
set(handles.checkbox_drb10,'Enable','on');
checkbox_drb1_Callback(hObject, eventdata, handles);
checkbox_drb2_Callback(hObject, eventdata, handles);
checkbox_drb3_Callback(hObject, eventdata, handles);
checkbox_drb4_Callback(hObject, eventdata, handles);
checkbox_drb5_Callback(hObject, eventdata, handles);
checkbox_drb6_Callback(hObject, eventdata, handles);
checkbox_drb7_Callback(hObject, eventdata, handles);
checkbox_drb8_Callback(hObject, eventdata, handles);
checkbox_drb9_Callback(hObject, eventdata, handles);
checkbox_drb10_Callback(hObject, eventdata, handles);

uipanel15_SelectionChangeFcn(hObject, eventdata, handles);

%Vykdymo mygtukas
Ar_galima_vykdyti(hObject, eventdata, handles);

%
set(handles.checkbox_baigti_anksciau,'Visible','off');
set(handles.checkbox_pabaigus_atverti,'Visible','on');

%Vidinis atliktų darbų skaitliukas
set(handles.text_atlikta_darbu, 'String', num2str(max_pakatalogio_nr(...
   get(handles.edit2, 'String'))));

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
clc
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

try 
    EEGLAB_senieji_kintamieji.EEG         =EEG;
    EEGLAB_senieji_kintamieji.ALLEEG      =ALLEEG;
    EEGLAB_senieji_kintamieji.CURRENTSET  =CURRENTSET;    
    EEGLAB_senieji_kintamieji.ALLCOM      =ALLCOM;
    EEGLAB_senieji_kintamieji.STUDY       =STUDY;
    EEGLAB_senieji_kintamieji.CURRENTSTUDY=CURRENTSTUDY;    
catch err,
end;
STUDY = []; CURRENTSTUDY = 0;

% Isimink laika  - veliau bus galimybe paziureti, kiek laiko uztruko
tic

DarboNr=str2num(get(handles.text_atlikta_darbu,'String'));
PaskutinioIssaugotoDarboNr=0;
Apdoroti_visi_tiriamieji=1;
sukauptos_klaidos={};
Sukamas_kelias=KELIAS;
Sukamos_rinkmn=Pasirinkti_failu_pavadinimai;

%%

for dbr_i=1:10;
    dbr_id=num2str(dbr_i);
    if and(and(~isempty(Sukamas_kelias),~isempty(Sukamos_rinkmn)),...
            get(eval(['handles.checkbox_drb' dbr_id]),'Value')) ;
        try
            preset=get(eval(['handles.popupmenu_drb' dbr_id '_']),'UserData');
            disp(' ');  disp([lokaliz('Job preset') ': ']); disp(' ');
            Darbo_eigos_busena(handles, lokaliz('Job'), dbr_i, 0, Pasirinktu_failu_N);
            dbr_param={'files',Sukamos_rinkmn,...
                'pathin',Sukamas_kelias,...
                'pathout',KELIAS_SAUGOJIMUI,...
                'preset', preset,...
                'counter',DarboNr,...
                'mode','exec'};
            %assignin('base', ['dbr_param' dbr_id], dbr_param);
            clear functions;
            switch get(eval(['handles.popupmenu_drb' dbr_id]),'Value')
                case 1
                    [lng,Sukamas_kelias,Sukamos_rinkmn]=...
                        pop_pervadinimas(dbr_param{:});
                    try delete(lng); catch err; end; 
                case 2
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn,DarboNr]=...
                        pop_nuoseklus_apdorojimas(dbr_param{:});
                case 3
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn,DarboNr]=...
                        pop_QRS_i_EEG(dbr_param{:});
                case 4
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn]=...
                        pop_Epochavimas_ir_atrinkimas(dbr_param{:});
                case 5
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn]=...
                        pop_ERP_savybes(dbr_param{:});
                case 6
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn]=...
                        pop_eeg_spektrine_galia(dbr_param{:});
                case 7
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn,DarboNr]=...
                        pop_rankinis(dbr_param{:});
                otherwise
                    warning(lokaliz('Netinkami parametrai'));
            end;
            clear functions;
            %drawnow; pause(5);
        catch err;
            Pranesk_apie_klaida(err, 'Meta Darbeliai', dbr_id);
            DarboPorcijaAtlikta=1;
        end;
    end;
end;

%% Po darbų

set(handles.text_darbas,'String',' ' );
if ~isempty(Sukamos_rinkmn);
    set(handles.listbox2,'String',Sukamos_rinkmn);
end;
drawnow;

if and(Apdoroti_visi_tiriamieji == 1, ...
        or(...
        get(handles.radiobutton6,'Value') == 0 ,...
        get(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Value') == 1 ...
        ) ...
        );
    
    if ~isempty(Sukamas_kelias);
        set(handles.edit1,'String',Sukamas_kelias);
    end;
end;

% Jei nėra taip, kad pirmenybė eiti per darbus, o surasta daug darbų
% t.y. arba pirmenybė eiti vienu įrašu per visus darbus
%      arba pirmenybė eiti per darbus, bet dar liko atliktinų darbų
%
% ARBA
%     pirmenybė eiti per darbus, o naudotojas prašo baigti anksčiau
%
if or(~and(get(handles.radiobutton7,'Value') == 1, isempty(Sukamos_rinkmn) ),...
       and(get(handles.radiobutton7,'Value') == 1, get(handles.checkbox_baigti_anksciau,'Value') == 1));
    atnaujinti_eeglab=true;
    
    if Apdoroti_visi_tiriamieji == 1;        
        if get(handles.checkbox_pabaigus_atverti,'Value') == 1;
            Pasirinkti_failu_pavadinimai=get(handles.listbox2,'String');
            Pasirinkti_failu_pavadinimai=Pasirinkti_failu_pavadinimai(find(~(cellfun(@isempty,Pasirinkti_failu_pavadinimai))));
            %visi_failai=dir(fullfile(PaskRinkmIssaugKelias, '*.set'));
            %Pasirinkti_failu_pavadinimai=intersect({visi_failai.name},Pasirinkti_failu_pavadinimai);
            Pasirinkti_failu_pavadinimai2={};
            for f=1:length(Pasirinkti_failu_pavadinimai);
                [KELIAS__,Rinkmena__,Prievardis__]=fileparts(fullfile(Sukamas_kelias,Pasirinkti_failu_pavadinimai{f}));
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
            atnaujinti_eeglab=false;
        end;        
    end;
    
    % Grąžinti senuosius EEGLAB kintamuosius ir atnaujinti langą
    if atnaujinti_eeglab;
        try
            EEG=         EEGLAB_senieji_kintamieji.EEG;
            ALLEEG=      EEGLAB_senieji_kintamieji.ALLEEG;
            CURRENTSET=  EEGLAB_senieji_kintamieji.CURRENTSET;
            ALLCOM=      EEGLAB_senieji_kintamieji.ALLCOM;
            STUDY=       EEGLAB_senieji_kintamieji.STUDY;
            CURRENTSTUDY=EEGLAB_senieji_kintamieji.CURRENTSTUDY;
        catch err,
        end;
        if ~isempty(findobj('tag', 'EEGLAB')); eeglab redraw; end;
    end;    
    
    if and(~get(handles.checkbox_uzverti_pabaigus,'UserData'),...
            get(handles.checkbox_uzverti_pabaigus,'Value'));
        delete(handles.figure1);
    else
        if and(Apdoroti_visi_tiriamieji == 1, ...
                or(...
                get(handles.radiobutton6,'Value') == 0 ,...
                get(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Value') == 1 ...
                ) ...
                );
            if ~isempty(Sukamas_kelias);
                set(handles.edit1,'String',Sukamas_kelias);
            end;
        end;
        set(handles.edit_failu_filtras2,'BackgroundColor','remove');
        set(handles.edit_failu_filtras2,'Style','pushbutton');
        set(handles.edit_failu_filtras2,'String',lokaliz('Filter'));
        %if ~strcmp(char(mfilename),'pop_meta_drb');
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
    
    if ~isempty(Sukamas_kelias);
        set(handles.edit1,'String',Sukamas_kelias);
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
set(handles.text_atlikta_darbu, 'String', num2str(max_pakatalogio_nr(pwd)));
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
set(handles.text_atlikta_darbu, 'String', num2str(max_pakatalogio_nr(pwd)));
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
                        %        pop_meta_drb;
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
set(handles.text_atlikta_darbu,'BackgroundColor',[1 1 1]);


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
fjos={ ...
    lokaliz('Pervadinimas su info suvedimu') ...
    lokaliz('Nuoseklus apdorojimas') ...
    lokaliz('EEG + EKG') ...
    lokaliz('Epochavimas pg. stimulus ir atsakus') ...
    lokaliz('ERP properties, export...') ...
    lokaliz('EEG spektras ir galia') ...
    lokaliz('Custom command') };
fjos=regexprep(fjos,'[.]+$','');
set(handles.popupmenu_drb1, 'String',fjos);
set(handles.popupmenu_drb2, 'String',fjos);
set(handles.popupmenu_drb3, 'String',fjos);
set(handles.popupmenu_drb4, 'String',fjos);
set(handles.popupmenu_drb5, 'String',fjos);
set(handles.popupmenu_drb6, 'String',fjos);
set(handles.popupmenu_drb7, 'String',fjos);
set(handles.popupmenu_drb8, 'String',fjos);
set(handles.popupmenu_drb9, 'String',fjos);
set(handles.popupmenu_drb10,'String',fjos);
set(handles.popupmenu_drb1_, 'String',{''});
set(handles.popupmenu_drb2_, 'String',{''});
set(handles.popupmenu_drb3_, 'String',{''});
set(handles.popupmenu_drb4_, 'String',{''});
set(handles.popupmenu_drb5_, 'String',{''});
set(handles.popupmenu_drb6_, 'String',{''});
set(handles.popupmenu_drb7_, 'String',{''});
set(handles.popupmenu_drb8_, 'String',{''});
set(handles.popupmenu_drb9_, 'String',{''});
set(handles.popupmenu_drb10_, 'String',{''});
set(handles.text51,'String', lokaliz('Job'));
set(handles.text52,'String', lokaliz('Job preset'));
set(handles.pushbutton1,'String',lokaliz('Execute'));
set(handles.pushbutton2,'String',lokaliz('Close'));
set(handles.pushbutton4,'String',lokaliz('Update'));
set(handles.radiobutton6,'String',lokaliz('through data'));
set(handles.radiobutton7,'String',lokaliz('through functions'));
set(handles.text7,'String', lokaliz('After interim saved job go'));
set(handles.text19,'String', lokaliz('# of done jobs for subdir names'));
set(handles.uipanel3,'Title',lokaliz('Options'));
set(handles.uipanel4,'Title',lokaliz('File filter'));
set(handles.uipanel5,'Title',lokaliz('Files for work'));
set(handles.uipanel15,'Title',lokaliz('File loading options'));
set(handles.uipanel16,'Title',lokaliz('File saving options'));
set(handles.uipanel17,'Title',lokaliz('Task'));
set(handles.text_failu_filtras1,'String',lokaliz('Show_filenames_filter:'));
set(handles.text_failu_filtras2,'String',lokaliz('Select_filenames_filter:'));
set(handles.checkbox_uzverti_pabaigus,'String',lokaliz('Close when complete'));
set(handles.checkbox_baigti_anksciau,'String',lokaliz('Break work'));
set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'String',lokaliz('Go to saved files directory when completed'));
set(handles.checkbox_pabaigus_atverti,'String',lokaliz('Load saved files in EEGLAB when completed'));


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
k=Tikras_Kelias(p{a});
set(handles.edit2,'String',k);
set(handles.edit2,'TooltipString',k);
set(handles.pushbutton_v2,'UserData',...
    unique([get(handles.pushbutton_v2,'UserData') c p{a} ]));
set(handles.text_atlikta_darbu, 'String', num2str(max_pakatalogio_nr(k)));
set(handles.edit2,'BackgroundColor',[1 1 1]);

function EEG=eval2(com,EEG, KELIAS_,NaujaRinkmena,laiko_intervalas,...
                        Pasirinkti_kanalai,Pasirinkti_kanalai_yra,Pasirinkti_kanalai_yra_Nr,...
                        Epochuoti_pagal_stimulus,...
                        handles)
eval(com);

function parinktis_ikelti(hObject, eventdata, handles, rinkinys)
susaldyk(hObject, eventdata, handles);
% Įkelti ankstenius nustatymus
try    
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));   
    esami={Darbeliai.dialogai.pop_meta_dbr.saranka.vardas};
    i=find(ismember(esami,rinkinys));
    Parinktys=Darbeliai.dialogai.pop_meta_dbr.saranka(i).parinktys;
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
            Pranesk_apie_klaida(err, 'pop_meta_dbr.m', '-', 0);
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
    esami={Darbeliai.dialogai.pop_meta_dbr.saranka.vardas};
    if and(ismember(vardas,esami),~ismember(vardas,{'numatytas','paskutinis'}));
        ats=questdlg(lokaliz('Perrašyti nuostatų rinkinį?'),lokaliz('Nuostatos jau yra!'),lokaliz('Rewrite'),lokaliz('Cancel'),lokaliz('Cancel'));
        if isempty(ats); return; end;
        if ~strcmp(ats,lokaliz('Rewrite')); return; end;
        reikia_perkurti_meniu=1;
    end;
catch err;
    %Pranesk_apie_klaida(err, 'pop_meta_drb.m', '-', 0);
end;

% Užduočių parinktys
Parinktys=struct('id','','Value','','UserData','','String_','','String','','TooltipString_','','TooltipString','');
isimintini_el={'checkbox_uzverti_pabaigus' 'checkbox_pabaigus_atverti' 'checkbox_pabaigus_i_apdorotu_aplanka' ...
    'checkbox_drb1' 'checkbox_drb2' 'checkbox_drb3' 'checkbox_drb4' 'checkbox_drb5' ...
    'checkbox_drb6' 'checkbox_drb7' 'checkbox_drb8' 'checkbox_drb9' 'checkbox_drb10' ...
    'popupmenu_drb1' 'popupmenu_drb2' 'popupmenu_drb3' 'popupmenu_drb4' 'popupmenu_drb5' ...
    'popupmenu_drb6' 'popupmenu_drb7' 'popupmenu_drb7' 'popupmenu_drb9' 'popupmenu_drb10' ...
    'popupmenu_drb1_' 'popupmenu_drb2_' 'popupmenu_drb3_' 'popupmenu_drb4_' 'popupmenu_drb5_' ...
    'popupmenu_drb6_' 'popupmenu_drb7_' 'popupmenu_drb7_' 'popupmenu_drb9_' 'popupmenu_drb10_'...
    'radiobutton6' 'radiobutton7' };
for i=1:length(isimintini_el);
    try
        Parinktys(i).id = isimintini_el{i} ;
        Parinktys(i).Value    = get(eval(['handles.' isimintini_el{i}]), 'Value');
        Parinktys(i).UserData = get(eval(['handles.' isimintini_el{i}]), 'UserData');
        Parinktys(i).String_  = 0;
        Parinktys(i).TooltipString_ = 0;
    catch err;
        Pranesk_apie_klaida(err, 'pop_meta_dbr.m', '-', 0);
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
Darbeliai.dialogai.pop_meta_dbr.saranka(i).vardas    = vardas ;
Darbeliai.dialogai.pop_meta_dbr.saranka(i).data      = datestr(now,'yyyy-mm-dd HH:MM:SS') ;
Darbeliai.dialogai.pop_meta_dbr.saranka(i).komentaras= [ komentaras ' ' ] ;
Darbeliai.dialogai.pop_meta_dbr.saranka(i).parinktys = Parinktys ;

% Įrašymas
try
    save(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'),'Darbeliai');
catch err;
    %Pranesk_apie_klaida(err, 'pop_meta_drb.m', '-', 0);
end;
if reikia_perkurti_meniu; meniu(hObject, eventdata, handles); end;

function parinktis_trinti(hObject, eventdata, handles)
try
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));  
    esami={Darbeliai.dialogai.pop_meta_dbr.saranka.vardas};
    esami_N=length(esami);
    esami_nr=find(~ismember(esami,{'numatytas','paskutinis'}));
    esami=esami(esami_nr);
    if isempty(esami); return; end;
catch err;
    %Pranesk_apie_klaida(err, 'pop_meta_drb.m', '-', 0);
    return;
end;
pasirinkti=listdlg('ListString', esami,...
    'SelectionMode','multiple',...
    'PromptString', lokaliz('Trinti:'),...
    'InitialValue',length(esami),...
    'OKString',lokaliz('Trinti'),...
    'CancelString',lokaliz('Cancel'));
if isempty(pasirinkti); return; end;
Darbeliai.dialogai.pop_meta_dbr.saranka= ...
    Darbeliai.dialogai.pop_meta_dbr.saranka(...
    setdiff([1:esami_N], esami_nr(pasirinkti)));
% Įrašymas
try
    save(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'),'Darbeliai');
catch err;
    Pranesk_apie_klaida(err, 'pop_meta_dbr.m', '-', 0);
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
    par_pav={ Darbeliai.dialogai.pop_meta_dbr.saranka.vardas };
    if ismember('paskutinis',par_pav);
        uimenu(handles.meniu_nuostatos_ikelti,'Label',lokaliz('Paskiausias'),'Separator','off',...
            'Accelerator','0','Callback',{@parinktis_ikelti,handles,'paskutinis'});
    end;
    ids=find(~ismember(par_pav,{'numatytas','paskutinis'}));
    par_pav=par_pav(ids);
    par_dat={ Darbeliai.dialogai.pop_meta_dbr.saranka.data };       par_dat=par_dat(ids);
    par_kom={ Darbeliai.dialogai.pop_meta_dbr.saranka.komentaras }; par_kom=par_kom(ids);
    if ~isempty(par_pav); yra_isimintu_rinkiniu=1 ; end; 
    for i=1:length(par_pav);
        try
        el=uimenu(handles.meniu_nuostatos_ikelti,...
            'Label', ['<html><font size="-2" color="#ADD8E6">' par_dat{i} '</font> ' ...
            par_pav{i} ' <br><font size="-2" color="#ADD8E6">' par_kom{i} '</font></html>'],...
            'Separator',fastif(i==1,'on','off'),...
            'Accelerator',fastif(i<10, num2str(i), ''),...
            'Callback',{@parinktis_ikelti,handles,par_pav{i}});
        catch err0;
            Pranesk_apie_klaida(err0, 'pop_meta_dbr.m', '-', 0);
        end;
    end;
catch err;
    %Pranesk_apie_klaida(err, 'pop_meta_drb.m', '-', 0);
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


% --- Executes on button press in checkbox_drb1.
function checkbox_drb1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb1
if and(get(handles.checkbox_drb1, 'Value'), ...
        strcmp(get(handles.checkbox_drb1, 'Enable'),'on'));
    set(handles.popupmenu_drb1,'Enable','on');
else
    set(handles.popupmenu_drb1,'Enable','off');
end;
popupmenu_drb1_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb1.
function popupmenu_drb1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb1
if strcmp(get(handles.popupmenu_drb1, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb1, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb1_,'String',rinkiniai);
        set(handles.popupmenu_drb1,'UserData',rinkiniai2);
        i = []; 
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb1_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb1_,'Value',i(1));
        set(handles.popupmenu_drb1_,'Enable','on');
    else
        set(handles.popupmenu_drb1,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb1_,'String',{' '});
        set(handles.popupmenu_drb1_,'Value',1);
        set(handles.popupmenu_drb1_,'Enable','off');        
    end;
    popupmenu_drb1__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb1_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb1_.
function popupmenu_drb1__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb1_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb1_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb1_
str=get(handles.popupmenu_drb1_,'String');
set(handles.popupmenu_drb1_,'TooltipString',str{...
    get(handles.popupmenu_drb1_,'Value')});
dbr=get(handles.popupmenu_drb1,'UserData');
set(handles.popupmenu_drb1_,'UserData',dbr{...
    get(handles.popupmenu_drb1_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb1__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb1_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb2.
function checkbox_drb2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb2
if and(get(handles.checkbox_drb2, 'Value'), ...
        strcmp(get(handles.checkbox_drb2, 'Enable'),'on'));
    set(handles.popupmenu_drb2,'Enable','on');
else
    set(handles.popupmenu_drb2,'Enable','off');
end;
popupmenu_drb2_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb2.
function popupmenu_drb2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb2
if strcmp(get(handles.popupmenu_drb2, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb2, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb2_,'String',rinkiniai);
        set(handles.popupmenu_drb2,'UserData',rinkiniai2);
        i = []; 
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb2_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb2_,'Value',i(1));
        set(handles.popupmenu_drb2_,'Enable','on');
    else
        set(handles.popupmenu_drb2,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb2_,'String',{' '});
        set(handles.popupmenu_drb2_,'Value',1);
        set(handles.popupmenu_drb2_,'Enable','off');        
    end;
    popupmenu_drb2__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb2_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb2_.
function popupmenu_drb2__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb2_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb2_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb2_
str=get(handles.popupmenu_drb2_,'String');
set(handles.popupmenu_drb2_,'TooltipString',str{...
    get(handles.popupmenu_drb2_,'Value')});
dbr=get(handles.popupmenu_drb2,'UserData');
set(handles.popupmenu_drb2_,'UserData',dbr{...
    get(handles.popupmenu_drb2_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb2__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb2_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb3.
function checkbox_drb3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb3
if and(get(handles.checkbox_drb3, 'Value'), ...
        strcmp(get(handles.checkbox_drb3, 'Enable'),'on'));
    set(handles.popupmenu_drb3,'Enable','on');
else
    set(handles.popupmenu_drb3,'Enable','off');
end;
popupmenu_drb3_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb3.
function popupmenu_drb3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb3
if strcmp(get(handles.popupmenu_drb3, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb3, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb3_,'String',rinkiniai);
        set(handles.popupmenu_drb3,'UserData',rinkiniai2);
        i = [];
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb3_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb3_,'Value',i(1));
        set(handles.popupmenu_drb3_,'Enable','on');
    else
        set(handles.popupmenu_drb3,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb3_,'String',{' '});
        set(handles.popupmenu_drb3_,'Value',1);
        set(handles.popupmenu_drb3_,'Enable','off');        
    end;
    popupmenu_drb3__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb3_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb3_.
function popupmenu_drb3__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb3_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb3_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb3_
str=get(handles.popupmenu_drb3_,'String');
set(handles.popupmenu_drb3_,'TooltipString',str{...
    get(handles.popupmenu_drb3_,'Value')});
dbr=get(handles.popupmenu_drb3,'UserData');
set(handles.popupmenu_drb3_,'UserData',dbr{...
    get(handles.popupmenu_drb3_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb3__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb3_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb4.
function checkbox_drb4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb4
if and(get(handles.checkbox_drb4, 'Value'), ...
        strcmp(get(handles.checkbox_drb4, 'Enable'),'on'));
    set(handles.popupmenu_drb4,'Enable','on');
else
    set(handles.popupmenu_drb4,'Enable','off');
end;
popupmenu_drb4_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb4.
function popupmenu_drb4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb4
if strcmp(get(handles.popupmenu_drb4, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb4, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb4_,'String',rinkiniai);
        set(handles.popupmenu_drb4,'UserData',rinkiniai2);
        i = [];
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb4_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb4_,'Value',i(1));
        set(handles.popupmenu_drb4_,'Enable','on');
    else
        set(handles.popupmenu_drb4,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb4_,'String',{' '});
        set(handles.popupmenu_drb4_,'Value',1);
        set(handles.popupmenu_drb4_,'Enable','off');        
    end;
    popupmenu_drb4__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb4_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb4_.
function popupmenu_drb4__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb4_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb4_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb4_
str=get(handles.popupmenu_drb4_,'String');
set(handles.popupmenu_drb4_,'TooltipString',str{...
    get(handles.popupmenu_drb4_,'Value')});
dbr=get(handles.popupmenu_drb4,'UserData');
set(handles.popupmenu_drb4_,'UserData',dbr{...
    get(handles.popupmenu_drb4_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb4__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb4_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb5.
function checkbox_drb5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb5
if and(get(handles.checkbox_drb5, 'Value'), ...
        strcmp(get(handles.checkbox_drb5, 'Enable'),'on'));
    set(handles.popupmenu_drb5,'Enable','on');
else
    set(handles.popupmenu_drb5,'Enable','off');
end;
popupmenu_drb5_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb5.
function popupmenu_drb5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb5
if strcmp(get(handles.popupmenu_drb5, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb5, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb5_,'String',rinkiniai);
        set(handles.popupmenu_drb5,'UserData',rinkiniai2);
        i = [];
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb5_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb5_,'Value',i(1));
        set(handles.popupmenu_drb5_,'Enable','on');
    else
        set(handles.popupmenu_drb5,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb5_,'String',{' '});
        set(handles.popupmenu_drb5_,'Value',1);
        set(handles.popupmenu_drb5_,'Enable','off');        
    end;
    popupmenu_drb5__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb5_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb5_.
function popupmenu_drb5__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb5_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb5_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb5_
str=get(handles.popupmenu_drb5_,'String');
set(handles.popupmenu_drb5_,'TooltipString',str{...
    get(handles.popupmenu_drb5_,'Value')});
dbr=get(handles.popupmenu_drb5,'UserData');
set(handles.popupmenu_drb5_,'UserData',dbr{...
    get(handles.popupmenu_drb5_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb5__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb5_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb6.
function checkbox_drb6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb6
if and(get(handles.checkbox_drb6, 'Value'), ...
        strcmp(get(handles.checkbox_drb6, 'Enable'),'on'));
    set(handles.popupmenu_drb6,'Enable','on');
else
    set(handles.popupmenu_drb6,'Enable','off');
end;
popupmenu_drb6_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb6.
function popupmenu_drb6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb6
if strcmp(get(handles.popupmenu_drb6, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb6, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb6_,'String',rinkiniai);
        set(handles.popupmenu_drb6,'UserData',rinkiniai2);
        i = [];
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb6_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb6_,'Value',i(1));
        set(handles.popupmenu_drb6_,'Enable','on');
    else
        set(handles.popupmenu_drb6,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb6_,'String',{' '});
        set(handles.popupmenu_drb6_,'Value',1);
        set(handles.popupmenu_drb6_,'Enable','off');        
    end;
    popupmenu_drb6__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb6_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb6_.
function popupmenu_drb6__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb6_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb6_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb6_
str=get(handles.popupmenu_drb6_,'String');
set(handles.popupmenu_drb6_,'TooltipString',str{...
    get(handles.popupmenu_drb6_,'Value')});
dbr=get(handles.popupmenu_drb6,'UserData');
set(handles.popupmenu_drb6_,'UserData',dbr{...
    get(handles.popupmenu_drb6_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb6__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb6_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb7.
function checkbox_drb7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb7
if and(get(handles.checkbox_drb7, 'Value'), ...
        strcmp(get(handles.checkbox_drb7, 'Enable'),'on'));
    set(handles.popupmenu_drb7,'Enable','on');
else
    set(handles.popupmenu_drb7,'Enable','off');
end;
popupmenu_drb7_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb7.
function popupmenu_drb7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb7
if strcmp(get(handles.popupmenu_drb7, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb7, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb7_,'String',rinkiniai);
        set(handles.popupmenu_drb7,'UserData',rinkiniai2);
        i = [];
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb7_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb7_,'Value',i(1));
        set(handles.popupmenu_drb7_,'Enable','on');
    else
        set(handles.popupmenu_drb7,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb7_,'String',{' '});
        set(handles.popupmenu_drb7_,'Value',1);
        set(handles.popupmenu_drb7_,'Enable','off');        
    end;
    popupmenu_drb7__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb7_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb7_.
function popupmenu_drb7__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb7_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb7_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb7_
str=get(handles.popupmenu_drb7_,'String');
set(handles.popupmenu_drb7_,'TooltipString',str{...
    get(handles.popupmenu_drb7_,'Value')});
dbr=get(handles.popupmenu_drb7,'UserData');
set(handles.popupmenu_drb7_,'UserData',dbr{...
    get(handles.popupmenu_drb7_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb7__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb7_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb8.
function checkbox_drb8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb8
if and(get(handles.checkbox_drb8, 'Value'), ...
        strcmp(get(handles.checkbox_drb8, 'Enable'),'on'));
    set(handles.popupmenu_drb8,'Enable','on');
else
    set(handles.popupmenu_drb8,'Enable','off');
end;
popupmenu_drb8_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb8.
function popupmenu_drb8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb8
if strcmp(get(handles.popupmenu_drb8, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb8, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb8_,'String',rinkiniai);
        set(handles.popupmenu_drb8,'UserData',rinkiniai2);
        i = [];
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb8_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb8_,'Value',i(1));
        set(handles.popupmenu_drb8_,'Enable','on');
    else
        set(handles.popupmenu_drb8,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb8_,'String',{' '});
        set(handles.popupmenu_drb8_,'Value',1);
        set(handles.popupmenu_drb8_,'Enable','off');        
    end;
    popupmenu_drb8__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb8_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb8_.
function popupmenu_drb8__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb8_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb8_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb8_
str=get(handles.popupmenu_drb8_,'String');
set(handles.popupmenu_drb8_,'TooltipString',str{...
    get(handles.popupmenu_drb8_,'Value')});
dbr=get(handles.popupmenu_drb8,'UserData');
set(handles.popupmenu_drb8_,'UserData',dbr{...
    get(handles.popupmenu_drb8_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb8__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb8_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb9.
function checkbox_drb9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb9
if and(get(handles.checkbox_drb9, 'Value'), ...
        strcmp(get(handles.checkbox_drb9, 'Enable'),'on'));
    set(handles.popupmenu_drb9,'Enable','on');
else
    set(handles.popupmenu_drb9,'Enable','off');
end;
popupmenu_drb9_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb9.
function popupmenu_drb9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb9
if strcmp(get(handles.popupmenu_drb9, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb9, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb9_,'String',rinkiniai);
        set(handles.popupmenu_drb9,'UserData',rinkiniai2);
        i = [];
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb9_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb9_,'Value',i(1));
        set(handles.popupmenu_drb9_,'Enable','on');
    else
        set(handles.popupmenu_drb9,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb9_,'String',{' '});
        set(handles.popupmenu_drb9_,'Value',1);
        set(handles.popupmenu_drb9_,'Enable','off');        
    end;
    popupmenu_drb9__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb9_,'Enable','off');
end;


% --- Executes during object creation, after setting all properties.
function popupmenu_drb9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb9_.
function popupmenu_drb9__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb9_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb9_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb9_
str=get(handles.popupmenu_drb9_,'String');
set(handles.popupmenu_drb9_,'TooltipString',str{...
    get(handles.popupmenu_drb9_,'Value')});
dbr=get(handles.popupmenu_drb9,'UserData');
set(handles.popupmenu_drb9_,'UserData',dbr{...
    get(handles.popupmenu_drb9_,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu_drb9__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb9_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_drb10.
function checkbox_drb10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_drb10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_drb10
if and(get(handles.checkbox_drb10, 'Value'), ...
        strcmp(get(handles.checkbox_drb10, 'Enable'),'on'));
    set(handles.popupmenu_drb10,'Enable','on');
else
    set(handles.popupmenu_drb10,'Enable','off');
end;
popupmenu_drb10_Callback(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_drb10.
function popupmenu_drb10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb10
if strcmp(get(handles.popupmenu_drb10, 'Enable'),'on');
    [rinkiniai,rinkiniai2]=Darbeliu_nuostatu_rinkiniai(get(handles.popupmenu_drb10, 'Value'));
    if ~isempty(rinkiniai);
        set(handles.popupmenu_drb10_,'String',rinkiniai);
        set(handles.popupmenu_drb10,'UserData',rinkiniai2);
        i = [];
        try i=find(ismember(rinkiniai2,get(handles.popupmenu_drb10_,'UserData'))); catch err; end;
        if isempty(i); i=find(ismember(rinkiniai2,'paskutinis')); end; if isempty(i); i=1; end;
        set(handles.popupmenu_drb10_,'Value',i(1));
        set(handles.popupmenu_drb10_,'Enable','on');
    else
        set(handles.popupmenu_drb10,'UserData',{'paskutinis'});
        set(handles.popupmenu_drb10_,'String',{' '});
        set(handles.popupmenu_drb10_,'Value',1);
        set(handles.popupmenu_drb10_,'Enable','off');        
    end;
    popupmenu_drb10__Callback(hObject, eventdata, handles);
else
    set(handles.popupmenu_drb10_,'Enable','off');
end;

% --- Executes during object creation, after setting all properties.
function popupmenu_drb10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_drb10_.
function popupmenu_drb10__Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb10_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_drb10_ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_drb10_
str=get(handles.popupmenu_drb10_,'String');
set(handles.popupmenu_drb10_,'TooltipString',str{...
    get(handles.popupmenu_drb10_,'Value')});
dbr=get(handles.popupmenu_drb10,'UserData');
set(handles.popupmenu_drb10_,'UserData',dbr{...
    get(handles.popupmenu_drb10_,'Value')});

% --- Executes during object creation, after setting all properties.
function popupmenu_drb10__CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_drb10_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [rinkiniai_lokaliz,rinkiniai_orig]=Darbeliu_nuostatu_rinkiniai(darbelio_Nr)
rinkiniai_lokaliz={};
rinkiniai_orig={};
try
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));
    switch darbelio_Nr
        case 1
            rinkiniai={Darbeliai.dialogai.pop_pervadinimas.saranka.vardas};
        case 2
            rinkiniai={Darbeliai.dialogai.pop_nuoseklus_apdorojimas.saranka.vardas};
        case 3
            rinkiniai={Darbeliai.dialogai.pop_QRS_i_EEG.saranka.vardas};
        case 4
            rinkiniai={Darbeliai.dialogai.pop_Epochavimas_ir_atrinkimas.saranka.vardas};
        case 5
            rinkiniai={Darbeliai.dialogai.pop_ERP_savybes.saranka.vardas};
        case 6
            rinkiniai={Darbeliai.dialogai.pop_eeg_spektrine_galia.saranka.vardas};
        case 7
            rinkiniai={Darbeliai.dialogai.pop_rankinis.saranka.vardas};
        otherwise
            disp('darbelio_Nr=');
            disp(darbelio_Nr);
            error([lokaliz('Netinkami parametrai')]);
    end;
    rinkiniai_orig=rinkiniai;
    rinkiniai(find(ismember(rinkiniai,'numatytas'))) ={lokaliz('Numatytas')};
    rinkiniai(find(ismember(rinkiniai,'paskutinis')))={lokaliz('Paskiausias')};
    rinkiniai_lokaliz=rinkiniai;
catch err;
    Pranesk_apie_klaida(err, 'Darbeliu_nuostatu_rinkiniai', darbelio_Nr, 0);
end;



