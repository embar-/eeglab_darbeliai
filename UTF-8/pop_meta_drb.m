%
%
% Darbų vykdymas pagal iš anksto aprašytus jų parinkčių rinkinius
%
% GUI versija
%
%
% (C) 2014-2016 Mindaugas Baranauskas
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

% Last Modified by GUIDE v2.5 04-Jul-2015 13:40:18

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

f=findobj('name', mfilename, 'Type','figure','Tag','Darbeliai');
if ismember(handles.figure1,f);
    wrn=warning('off','backtrace');
    warning([mfilename ': ' lokaliz('Dialogas jau atvertas!')]);
    warning(wrn.state, 'backtrace');
    figure(f);
    if strcmp(get(handles.pushbutton4),'off') || isempty(g); return; end;
    try klausti_naujo_atverimo=~ismember(g(1).mode,{'f' 'force' 'forceexec' 'force_exec'});
    catch; klausti_naujo_atverimo=1;
    end;
    if klausti_naujo_atverimo
        button = questdlg(...
            [ lokaliz('Dialogas jau atvertas!')  ' '  lokaliz('Reload parameters?') ], ...
            lokaliz('Dialogas jau atvertas!') , ...
            lokaliz('Atsisakyti'), lokaliz('Reload'), lokaliz('Reload'));
        switch button
            case lokaliz('Reload');
                wrn=warning('off','backtrace');
                warning([mfilename ': ' lokaliz('Changing options in dialog!')]);
                warning(wrn.state, 'backtrace');
            otherwise
                return;
        end;
    end;
end;
set(handles.figure1,'Name',mfilename);
set(handles.figure1,'Tag','Darbeliai');
set(handles.figure1,'Units','pixels');
set(handles.figure1,'Resize','on');
pad=get(handles.figure1,'Position');
set(handles.figure1,'Position',[pad(1) pad(2) max(pad(3),750) max(pad(4),600)]);

%Įsimink prieš funkcijų vykdymą buvusį kelią; netrukus bandysime laikinai pakeisti kelią
Kelias_dabar=pwd;

if isempty(get(handles.text_koduote,'String'))
    set(handles.text_koduote,'String',feature('DefaultCharacterSet'));
end;

tic;

lokalizuoti(hObject, eventdata, handles);
atstatyk_darbu_id(hObject, eventdata, handles, 1:10);
drb_meniu(hObject, eventdata, handles, 'visas', mfilename);
set(handles.checkbox_pabaigus_atverti,'Value',0);

%Pabandyk įkelti senąjį kelią
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));
    setappdata(handles.figure1, 'Darbeliai_config', Darbeliai);
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
set(handles.edit2,'String','');
try
    k=Darbeliai.keliai.saugojimui{1};
    if exist(k,'dir') == 7 ; set(handles.edit2,'String',k); end;
catch err;
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
    drb_parinktys(hObject, eventdata, handles, 'ikelti', mfilename, g(1).preset); 
catch err; 
    susildyk(hObject, eventdata, handles);
end;

try set(handles.text_atlikta_darbu,'String',num2str(g(1).counter)); catch err; end;
set(handles.checkbox_uzverti_pabaigus,'UserData',0);
set(handles.radiobutton6,'Visible','off');
set(handles.radiobutton7,'Visible','off');
set(handles.text7,'Visible','off');

tic;

% Choose default command line output for pop_meta_drb
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_meta_drb wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Jei nurodyta veiksena
try
  if ~isempty(g(1).mode);
    agv=strcmp(get(handles.pushbutton1,'Enable'),'on');
    if or(ismember(g(1).mode,{'f' 'force' 'forceexec' 'force_exec'}),...
      and(ismember(g(1).mode,{'tryforce'}),agv));
        set(handles.checkbox_uzverti_pabaigus,'Enable','off');
    end;
    if ismember(g(1).mode,{'f' 'force' 'forceexec' 'force_exec' 'e' 'exec' 't' 'try' 'tryexec' 'tryforce' 'c' 'confirm'});
        set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'Enable','off');
        set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'Value',1);
        set(handles.checkbox_uzverti_pabaigus,'UserData',1);
        set(handles.checkbox_uzverti_pabaigus,'Value',1);
        %set(handles.checkbox_pabaigus_atverti,'Value',0);
    end;
    if or(ismember(g(1).mode,{'c' 'confirm'}),...
      and(ismember(g(1).mode,{'t' 'try' 'tryexec' 'tryforce'}),~agv)    );
        uiwait(handles.figure1); % UIRESUME bus įvykdžius užduotis
    end;
    if or(ismember(g(1).mode,{'f' 'force' 'forceexec' 'force_exec' 'e' 'exec'}),...
      and(ismember(g(1).mode,{'t' 'try' 'tryexec' 'tryforce'}),agv));
        pushbutton1_Callback(hObject, eventdata, handles);
    end;
  end;
catch err;
end;


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
for m_id={'m_Nuostatos' 'm_Darbeliai' 'm_Veiksmai'};
    set(findall(handles.figure1,'Type','uimenu','Tag',m_id{1}),'Enable','off');
end;
drawnow;

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
set(handles.radiobutton7,'Enable','on');

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
% set(handles.text_atlikta_darbu, 'String', num2str(max_pakatalogio_nr(...
%   get(handles.edit2, 'String'))));

set(handles.text_darbas,'Visible','off');
set(handles.text_darbas,'String',' ');
set(handles.pushbutton2,'Value',0);

% Leisti spausti Nuostatų meniu!
for m_id={'m_Nuostatos' 'm_Darbeliai' 'm_Veiksmai'};
    set(findall(handles.figure1,'Type','uimenu','Tag',m_id{1}),'Enable','on');
end;
drawnow;


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
disp('-----------------------------------');
kelintas_failas=num2str(i);
if isempty(kelintas_failas); kelintas_failas='?'; end;
NaujaAntraste=[ num2str(DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' meta darb., ' kelintas_failas '/' num2str(Pasirinktu_failu_N) ' įr.'];
disp(NaujaAntraste);
disp(Darbo_apibudinimas);
set(handles.text_darbas,'Visible','on');
set(handles.text_darbas,'String',[ NaujaAntraste ' ' Darbo_apibudinimas ] );
%set(handles.uipanel6,'Title', NaujaAntraste);
drawnow;
%uiwait(gcf,1);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
Ar_galima_vykdyti(hObject, eventdata, handles);
if strcmp(get(handles.pushbutton1,'Enable'),'on');
    %if Ar_galima_vykdyti2(hObject, eventdata, handles);
        vykdymas(hObject, eventdata, handles);
    %end;
end;


% --- Pats darbo vykdymas
function vykdymas(hObject, eventdata, handles)
if strcmp(get(handles.pushbutton1,'Enable'),'off'); return; end;
clc
disp(' ');
disp('===================================');
disp('      M E T A     D A R B A I      ');
disp(' ');
disp(' ');
disp('===================================');
disp( datestr(now, 'yyyy-mm-dd HH:MM:SS' ));
disp('===================================');
disp(' ');
susaldyk(hObject, eventdata, handles);
set(handles.pushbutton1,'Enable','off');
drawnow;
%guidata(hObject, handles);

global STUDY CURRENTSTUDY ALLEEG EEG CURRENTSET;
Pasirinkti_failu_indeksai=(get(handles.listbox1,'Value'));
Rodomu_failu_pavadinimai=(get(handles.listbox1,'String'));
Pasirinkti_failu_pavadinimai=Rodomu_failu_pavadinimai(Pasirinkti_failu_indeksai);
Pasirinktu_failu_N=length(Pasirinkti_failu_pavadinimai);
set(handles.listbox2,'String',Pasirinkti_failu_pavadinimai);
%set(handles.listbox2,'String',{''});
t=datestr(now, 'yyyy-mm-dd_HHMMSS');
disp(' ');
disp(lokaliz('File for work:'));
for i=1:Pasirinktu_failu_N;
    disp(Pasirinkti_failu_pavadinimai{i});
end;
disp(' ');

KELIAS=Tikras_Kelias(get(handles.edit1,'String'));
KELIAS_SAUGOJIMUI=Tikras_Kelias(get(handles.edit2,'String'));
disp(lokaliz('Processed files will go to '));
disp(KELIAS_SAUGOJIMUI);
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
for m_id={'m_Nuostatos' 'm_Darbeliai' 'm_Veiksmai'};
    set(findall(handles.figure1,'Type','uimenu','Tag',m_id{1}),'Enable','off');
end;
drawnow;

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
            Darbo_tipo_nr=get(eval(['handles.popupmenu_drb' dbr_id]),'Value');
            Darbo_tipo_id=get(eval(['handles.popupmenu_drb' dbr_id]),'TooltipString');
            Darbo_apibudinimas=get(eval(['handles.popupmenu_drb' dbr_id]),'String');
            Darbo_apibudinimas=Darbo_apibudinimas{Darbo_tipo_nr};
            preset=get(eval(['handles.popupmenu_drb' dbr_id '_']),'TooltipString');
            Darbo_eigos_busena(handles, [lokaliz('Job') ': ' Darbo_apibudinimas], dbr_i, [], Pasirinktu_failu_N);
            disp([lokaliz('Job preset') ': ' preset ]); disp(' ');
            switch Darbo_tipo_id
                case {'pop_pervadinimas'}
                    Kelias_sg=fullfile(KELIAS_SAUGOJIMUI,[num2str(DarboNr+1) ' - ' ]); % lokaliz('Rename')
                    if exist(Kelias_sg) ~= 7; try mkdir(Kelias_sg); catch err ; Kelias_sg=KELIAS_SAUGOJIMUI; end; end;
                otherwise
                    Kelias_sg=KELIAS_SAUGOJIMUI;
            end;
            veiksenos={'confirm' 'tryexec' 'forceexec'};
            veiksena=veiksenos{get(handles.popupmenu_patvirt,'Value')};
            dbr_param={'files',Sukamos_rinkmn, 'pathin',Sukamas_kelias, 'pathout',Kelias_sg, ...
                       'preset', preset, 'counter',DarboNr, 'mode',veiksena};
            %assignin('base', ['dbr_param' dbr_id], dbr_param);
            switch Darbo_tipo_id
                case {'pop_pervadinimas'}
                    [lng,Sukamas_kelias,Sukamos_rinkmn]=...
                        pop_pervadinimas(dbr_param{:});
                    try delete(lng); catch err; end;
                    DarboNr=DarboNr+1;
                case {'pop_nuoseklus_apdorojimas'}
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn,DarboNr]=...
                        pop_nuoseklus_apdorojimas(dbr_param{:});
                case {'pop_QRS_i_EEG'}
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn,DarboNr]=...
                        pop_QRS_i_EEG(dbr_param{:});
                case {'pop_Epochavimas_ir_atrinkimas'}
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn]=...
                        pop_Epochavimas_ir_atrinkimas(dbr_param{:});
                    if isempty(Sukamos_rinkmn); Sukamos_rinkmn={' '}; end;
                case {'pop_ERP_savybes'}
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn]=...
                        pop_ERP_savybes(dbr_param{:});
                case {'pop_eeg_spektrine_galia'}
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn]=...
                        pop_eeg_spektrine_galia(dbr_param{:});
                case {'pop_rankinis'}
                    [lng,Sukamas_kelias,~,Sukamos_rinkmn,DarboNr]=...
                        pop_rankinis(dbr_param{:});
                otherwise
                    warning(lokaliz('Netinkami parametrai'));
            end;
            %drawnow; pause(5);
        catch err;
            Pranesk_apie_klaida(err, 'Meta Darbeliai', ' ');
            DarboPorcijaAtlikta=1;
        end;
        
        if get(handles.checkbox_baigti_anksciau,'Value') == 1 ;
            break;
        end;
    end;
end;

%% Po darbų

set(handles.text_darbas,'String',' ' );
set(handles.text_atlikta_darbu,'String',num2str(DarboNr));
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
                    disp([ '[' Sukamas_kelias ']' ] );
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
            try eeglab redraw;
            catch err; Pranesk_apie_klaida(err,'','',0);
            end;
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
        if ~isempty(findobj('tag', 'EEGLAB')); 
            try eeglab redraw;
            catch err; Pranesk_apie_klaida(err,'','',0);
            end;
        end;
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
        atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
        atnaujink_rodomus_failus(hObject, eventdata, handles);
        susildyk(hObject, eventdata, handles);
        uiresume(handles.figure1);
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
    set(handles.edit_failu_filtras2,'BackgroundColor','remove');
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
    set(handles.edit_failu_filtras2,'BackgroundColor','remove');
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
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
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
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
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
        lokaliz('No such directory'), ...
        lokaliz('Cancel'), lokaliz('Create directory'), lokaliz('Create directory'));
    if and(~isempty(KELIAS_siulomas),strcmp(button3,lokaliz('Create directory')));
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
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
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
    set(handles.edit_failu_filtras2,'BackgroundColor','remove');
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
    %set(handles.edit_failu_filtras2,'BackgroundColor','remove');
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
try
if ~isempty(findobj('-regexp','name',mfilename)) ;
    if and(strcmp(get(handles.checkbox_baigti_anksciau,'Visible'),'on'), ...
             and(~get(handles.checkbox_baigti_anksciau,'Value'), ...
                 ~get(handles.pushbutton1,'Value')));
        disp(' '); disp('Naudotojas priverstinai uždaro langą!');
        set(handles.checkbox_baigti_anksciau,'Value',1);
        %set(handles.checkbox_baigti_anksciau,'Visible','on');
        checkbox_baigti_anksciau_Callback(hObject, eventdata, handles);
    elseif strcmp(get(handles.pushbutton4,'Enable'),'on') ;        
        delete(handles.figure1);
    else
        %error('Darbą nutraukė naudotojas');
        
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
catch err;
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


function atstatyk_darbu_id(hObject, eventdata, handles, id)
popdrb={'pop_pervadinimas' ...
        'pop_nuoseklus_apdorojimas'};
if strcmp(char(java.util.Locale.getDefault()),'lt_LT');
    popdrb=[ popdrb {'pop_QRS_i_EEG'} ];
end;
popdrb=[ popdrb {...
        'pop_Epochavimas_ir_atrinkimas' ...
        'pop_ERP_savybes' ...
        'pop_eeg_spektrine_galia' ...
        'pop_rankinis'}]; %#ok
for i=id;
    eval(['set(handles.popupmenu_drb' num2str(i) ', ''UserData'',popdrb); ']);
end;


function lokalizuoti(hObject, eventdata, handles)
set(handles.popupmenu_patvirt, 'String',{...
    lokaliz('visada')...
    lokaliz('kai negalima vykdyti')...
    lokaliz('niekada');});
fjos={ ...
    lokaliz('Pervadinimas su info suvedimu') ...
    lokaliz('Nuoseklus apdorojimas') };
if strcmp(char(java.util.Locale.getDefault()),'lt_LT'); 
    fjos=[ fjos {lokaliz('EEG + EKG')}] ;
end;
fjos=[ fjos { ...
    lokaliz('Epochavimas pg. stimulus ir atsakus') ...
    lokaliz('ERP properties, export...') ...
    lokaliz('EEG spektras ir galia') ...
    lokaliz('Custom command') }];
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
set(handles.text53,'String', lokaliz('Patvirtinti paskiro darbelio parinktis:'));
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
set(handles.uipanel17,'Title',lokaliz('Vykdymo parinktys'));
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
i=get(handles.edit1,'String'); % įkėlimo
s=get(handles.edit2,'String'); % saugojimo
n=get(handles.pushbutton_v1,'UserData'); % naudotieji
a=drb_uzklausa('katalogas','atverimui',i, [s n]);
if isempty(a); return; end;
set(handles.edit1,'String',a);
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);


% --- Executes on button press in pushbutton_v2.
function pushbutton_v2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i=get(handles.edit1,'String'); % įkėlimo
s=get(handles.edit2,'String'); % saugojimo
n=get(handles.pushbutton_v2,'UserData'); % naudotieji
a=drb_uzklausa('katalogas','atverimui',s, [i n]);
if isempty(a); return; end;
set(handles.edit2,'String',a);
set(handles.edit2,'TooltipString',a);
set(handles.pushbutton_v2,'UserData',...
    unique([get(handles.pushbutton_v2,'UserData') {s} {a}]));
set(handles.text_atlikta_darbu, 'String', num2str(max_pakatalogio_nr(a)));
set(handles.edit2,'BackgroundColor',[1 1 1]);


function parinktis_irasyti(hObject, eventdata, handles, varargin)
if nargin > 3; vardas=varargin{1};
else           vardas='';
end;
if nargin > 4; komentaras=varargin{2};
else           komentaras='';
end;
isimintini=struct('nariai','','raktai','');

isimintini(1).raktai={'Value' 'UserData'};
isimintini(1).nariai={'checkbox_uzverti_pabaigus' 'checkbox_pabaigus_atverti' 'checkbox_pabaigus_i_apdorotu_aplanka' ...
    'checkbox_drb1' 'checkbox_drb2' 'checkbox_drb3' 'checkbox_drb4' 'checkbox_drb5' ...
    'checkbox_drb6' 'checkbox_drb7' 'checkbox_drb8' 'checkbox_drb9' 'checkbox_drb10' ...
    'popupmenu_patvirt' 'radiobutton6' 'radiobutton7' };
isimintini(2).raktai={'Value' 'UserData' 'TooltipString'};
isimintini(2).nariai={...
    'popupmenu_drb1' 'popupmenu_drb2' 'popupmenu_drb3' 'popupmenu_drb4' 'popupmenu_drb5' ...
    'popupmenu_drb6' 'popupmenu_drb7' 'popupmenu_drb8' 'popupmenu_drb9' 'popupmenu_drb10' ...
    'popupmenu_drb1_' 'popupmenu_drb2_' 'popupmenu_drb3_' 'popupmenu_drb4_' 'popupmenu_drb5_' ...
    'popupmenu_drb6_' 'popupmenu_drb7_' 'popupmenu_drb8_' 'popupmenu_drb9_' 'popupmenu_drb10_'};
drb_parinktys(hObject, eventdata, handles, 'irasyti', mfilename, vardas, komentaras, isimintini);


%%

% --- Executes on button press in checkbox_drb1.
function checkbox_drb1_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 1);

% --- Executes on selection change in popupmenu_drb1.
function popupmenu_drb1_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 1);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb1_.
function popupmenu_drb1__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 1);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb1__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb2.
function checkbox_drb2_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 2);

% --- Executes on selection change in popupmenu_drb2.
function popupmenu_drb2_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 2);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb2_.
function popupmenu_drb2__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 2);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb2__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb3.
function checkbox_drb3_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 3);

% --- Executes on selection change in popupmenu_drb3.
function popupmenu_drb3_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 3);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb3_.
function popupmenu_drb3__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 3);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb3__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb4.
function checkbox_drb4_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 4);

% --- Executes on selection change in popupmenu_drb4.
function popupmenu_drb4_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 4);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb4_.
function popupmenu_drb4__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 4);


% --- Executes during object creation, after setting all properties.
function popupmenu_drb4__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb5.
function checkbox_drb5_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 5);

% --- Executes on selection change in popupmenu_drb5.
function popupmenu_drb5_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 5);


% --- Executes during object creation, after setting all properties.
function popupmenu_drb5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb5_.
function popupmenu_drb5__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 5);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb5__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb6.
function checkbox_drb6_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 6);

% --- Executes on selection change in popupmenu_drb6.
function popupmenu_drb6_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 6);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb6_.
function popupmenu_drb6__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 6);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb6__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb7.
function checkbox_drb7_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 7);

% --- Executes on selection change in popupmenu_drb7.
function popupmenu_drb7_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 7);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb7_.
function popupmenu_drb7__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 7);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb7__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb8.
function checkbox_drb8_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 8);

% --- Executes on selection change in popupmenu_drb8.
function popupmenu_drb8_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 8);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb8_.
function popupmenu_drb8__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 8);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb8__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb9.
function checkbox_drb9_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 9);

% --- Executes on selection change in popupmenu_drb9.
function popupmenu_drb9_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 9);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb9_.
function popupmenu_drb9__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 9);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb9__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_drb10.
function checkbox_drb10_Callback(hObject, eventdata, handles)
virtual_checkbox_drb_Callback(hObject, eventdata, handles, 10);

% --- Executes on selection change in popupmenu_drb10.
function popupmenu_drb10_Callback(hObject, eventdata, handles)
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, 10);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_drb10_.
function popupmenu_drb10__Callback(hObject, eventdata, handles)
virtual_popupmenu_drb__Callback(hObject, eventdata, handles, 10);

% --- Executes during object creation, after setting all properties.
function popupmenu_drb10__CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%

% --- Executes on button press in checkbox_drb*.
function virtual_checkbox_drb_Callback(hObject, eventdata, handles, id)
eval(['cbh=handles.checkbox_drb' num2str(id) ' ; ']);
eval(['pm=handles.popupmenu_drb' num2str(id) ' ; ']);
eval(['pm_=handles.popupmenu_drb' num2str(id) '_ ; ']);
aktyvus=and(get(cbh, 'Value'), strcmp(get(cbh, 'Enable'),'on'));
set(pm,'Enable',fastif(aktyvus,'on','off'));

% suderinamumas su pirmuoju pop_meta_drb parinkčių valdymu
try if length(get(pm, 'UserData')) ~= length(get(pm, 'String'))...
    || ischar(get(pm_,'UserData'));
        atstatyk_darbu_id(hObject, eventdata, handles, id);
        tstr = get(pm_,'UserData');
        if ischar(tstr);
            set(pm_,'TooltipString',tstr);
            set(pm, 'TooltipString','');
            pmV =get(pm, 'Value');
            pmUD=get(pm, 'UserData');
            Darbeliai=getappdata(handles.figure1, 'Darbeliai_config');
            if pmV > 2 && isequal(Darbeliai.nuostatos.stabili_versija,1);
                pmV=pmV+1; set(pm, 'Value', pmV);
            end;
            if length(pmUD) < pmV ;
                d=pmV-length(pmUD);
                for i=1:10;
                    eval(['pm0=handles.popupmenu_drb' num2str(i) ' ; ']);
                    pm0V=get(pm0, 'Value');
                    if pm0V-d>2;
                        set(pm0, 'Value', pm0V-d);
                    end;
                end;
            end;
        end;
    end;
catch err; Pranesk_apie_klaida(err, 'virtual_popupmenu_drb_Callback', id, 0);
end;

pmTS=get(pm, 'TooltipString');
pmUD=get(pm, 'UserData');
if ~isempty(pmTS) && iscellstr(pmUD);
    n=find(ismember(pmUD, pmTS));
    if ~isempty(n); 
        set(pm, 'Value', n(1));
    else
        if get(cbh,'Value'); warning([lokaliz('Netinkami parametrai') ': ' num2str(id) ': ' pmTS]); end;
        set(cbh,'Value',0); set(pm,'Value', 1); set(pm,'Enable','off');
    end;
end;
virtual_popupmenu_drb_Callback(hObject, eventdata, handles, id);


% --- Executes on selection change in popupmenu_drb*.
function virtual_popupmenu_drb_Callback(hObject, eventdata, handles, id)
eval(['cbh=handles.checkbox_drb' num2str(id) ' ; ']);
eval(['pm=handles.popupmenu_drb' num2str(id) ' ; ']);
eval(['pm_=handles.popupmenu_drb' num2str(id) '_ ; ']);
pm_Enable=get(pm, 'Enable');
darbai=get(pm, 'UserData');
darbas=darbai{get(pm, 'Value')};
pmTS=get(pm,'TooltipString');
set(pm,'TooltipString',darbas);
[rinkiniai_lok,rinkiniai_orig]=Darbeliu_nuostatu_rinkiniai(darbas);

if ~isempty(rinkiniai_lok);
    set(pm_,'String',rinkiniai_lok);
    set(pm_,'UserData',rinkiniai_orig);
    pm_TS=get(pm_,'TooltipString'); 
    i = [] ;
    if ~isempty(pm_TS) && ischar(pm_TS);
        i=find(ismember(rinkiniai_orig,pm_TS));
        if isempty(i) && strcmp(pmTS,darbas);
            if get(cbh,'Value'); warning([lokaliz('Netinkami parametrai') ': ' num2str(id) ': ' darbas ': ' pm_TS]); end;
            %set(cbh,'Value',0); set(pm,'Enable','off'); pm_Enable='off';
        end;
    end;
    if isempty(i); i=find(ismember(rinkiniai_orig,'paskutinis')); end; if isempty(i); i=1; end;
    set(pm_,'Value',i(1));
else
    set(pm_,'TooltipString',{'paskutinis'});
    set(pm_,'String',{' '});
    set(pm_,'Value',1);
    pm_Enable='off';
end;
set(pm_,'Enable',pm_Enable);
eval(['popupmenu_drb' num2str(id) '__Callback(hObject, eventdata, handles);' ]);


% --- Executes on selection change in popupmenu_drb*_.
function virtual_popupmenu_drb__Callback(hObject, eventdata, handles, id)
eval(['pm_=handles.popupmenu_drb' num2str(id) '_ ; ']);
str=get(pm_,'String');
val=get(pm_,'Value');
if length(str) < val; set(pm_,'Value',1); val= 1; end;
dbr=get(pm_,'UserData');
set(pm_,'TooltipString',dbr{val});


function [rinkiniai_lokaliz,rinkiniai_orig]=Darbeliu_nuostatu_rinkiniai(darbas)
rinkiniai_orig={'numatytas'}; % Net jei tokio ir dar nėra, jis sukuriamas paleidžiant dialogą
try    
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    k=Tikras_Kelias(fullfile(function_dir,'..'));
    load(fullfile(k,'Darbeliai_config.mat'));
    eval(['rinkiniai_orig={Darbeliai.dialogai.' darbas '.saranka.vardas};' ]);
catch %err; Pranesk_apie_klaida(err, 'Darbeliu_nuostatu_rinkiniai', darbelio_Nr, 0);
    %disp('darbas='); disp(darbas);
end;
if ismember(rinkiniai_orig, 'paskutinis' );
    rinkiniai_orig=[{'numatytas' 'paskutinis'} rinkiniai_orig];
else
    rinkiniai_orig=[{'numatytas'} rinkiniai_orig];
end;
[~, i]=unique(rinkiniai_orig);
rinkiniai_orig=rinkiniai_orig(sort(i));
rinkiniai_lokaliz=rinkiniai_orig;
n=find(ismember(rinkiniai_orig, 'numatytas' ));
if ~isempty(n); rinkiniai_lokaliz(n)={lokaliz('Numatytas')}; end;
p=find(ismember(rinkiniai_orig, 'paskutinis' ));
if ~isempty(p); rinkiniai_lokaliz(p)={lokaliz('Paskiausias')}; end;


% --- Executes on selection change in popupmenu_patvirt.
function popupmenu_patvirt_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_patvirt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
