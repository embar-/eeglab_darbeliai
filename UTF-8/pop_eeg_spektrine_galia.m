%
%
%
%
%
% EEG spektrinė galia
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

function varargout = pop_eeg_spektrine_galia(varargin)
% POP_EEG_SPEKTRINE_GALIA MATLAB code for pop_eeg_spektrine_galia.fig
%      POP_EEG_SPEKTRINE_GALIA, by itself, creates a new POP_EEG_SPEKTRINE_GALIA or raises the existing
%      singleton*.
%
%      H = POP_EEG_SPEKTRINE_GALIA returns the handle to a new POP_EEG_SPEKTRINE_GALIA or the handle to
%      the existing singleton*.
%
%      POP_EEG_SPEKTRINE_GALIA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_EEG_SPEKTRINE_GALIA.M with the given input arguments.
%
%      POP_EEG_SPEKTRINE_GALIA('Property','Value',...) creates a new POP_EEG_SPEKTRINE_GALIA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_eeg_spektrine_galia_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_eeg_spektrine_galia_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_eeg_spektrine_galia

% Last Modified by GUIDE v2.5 15-Apr-2015 12:45:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_eeg_spektrine_galia_OpeningFcn, ...
    'gui_OutputFcn',  @pop_eeg_spektrine_galia_OutputFcn, ...
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



% --- Executes just before pop_eeg_spektrine_galia is made visible.
function pop_eeg_spektrine_galia_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_eeg_spektrine_galia (see VARARGIN)

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
set(handles.figure1,'Position',[pad(1) pad(2) max(pad(3),725) max(pad(4),600)]);
set(handles.checkbox_interpol,'Value',0);

%Įsimink prieš funkcijų vykdymą buvusį kelią; netrukus bandysime laikinai pakeisti kelią
Kelias_dabar=pwd;

if isempty(get(handles.text_koduote,'String'))
    set(handles.text_koduote,'String',feature('DefaultCharacterSet'));
end;

tic;

lokalizuoti(hObject, eventdata, handles);
drb_meniu(hObject, eventdata, handles, 'visas', mfilename);

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
set(handles.checkbox_perziura,'Value',0);
set(handles.radiobutton_spektras,'Visible','on');

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

set(handles.pushbutton14,'UserData',{});

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

% Papildomos parinktys
set(handles.checkbox76,'Value',1);

parinktis_irasyti(hObject, eventdata, handles, 'numatytas','');
try 
    drb_parinktys(hObject, eventdata, handles, 'ikelti', mfilename, g(1).preset); 
catch err; 
    susildyk(hObject, eventdata, handles);
end;

set(handles.checkbox_uzverti_pabaigus,'UserData',0);

tic;

% Choose default command line output for pop_eeg_spektrine_galia
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_eeg_spektrine_galia wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Jei nurodyta veiksena
try
  if ~isempty(g(1).mode);
    agv=strcmp(get(handles.pushbutton1,'Enable'),'on');
    if agv; agv=Ar_galima_vykdyti2(hObject, eventdata, handles); end;
    %if agv; agv=Ar_galima_vykdyti3(hObject, eventdata, handles, 1); end;
    if or(ismember(g(1).mode,{'f' 'force' 'forceexec' 'force_exec'}),...
      and(ismember(g(1).mode,{'tryforce'}),agv));
        set(handles.checkbox_uzverti_pabaigus,'Enable','off');
    end;
    if ismember(g(1).mode,{'f' 'force' 'forceexec' 'force_exec' 'e' 'exec' 't' 'try' 'tryexec' 'tryforce' 'c' 'confirm'});
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
function varargout = pop_eeg_spektrine_galia_OutputFcn(hObject, eventdata, handles)
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
    %varargout{5} = str2num(get(handles.text_atlikta_darbu,'String')); % skaitliukas
catch err;
    varargout{1} = [];
    varargout{2} = '';
    varargout{3} = {};
    varargout{4} = {};
    %varargout{5} = [];
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

checkbox_perziura_Callback(hObject, eventdata, handles);

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
set(handles.pushbutton14,'Enable','off');
set(handles.pushbutton18,'Enable','off');
set(handles.pushbutton19,'Enable','off');
set(handles.pushbutton_v1,'Enable','off');
set(handles.pushbutton_v2,'Enable','off');
set(handles.radiobutton6,'Enable','off');
set(handles.radiobutton7,'Enable','off');

set(handles.uitable1,'Enable','off');
set(handles.checkbox79,'Enable','off');
checkbox79_Callback(hObject, eventdata, handles);
set(handles.edit_tikslumas,'Enable','off');
set(handles.edit_fft_langas,'Enable','off');
set(handles.edit_doc,'Enable','off');
set(handles.popupmenu_doc,'Enable','off');
set(handles.checkbox_perziura,'Enable','off');
set(handles.checkbox_interpol,'Enable','off');
checkbox_perziura_Callback(hObject, eventdata, handles);
popupmenu_doc_Callback(hObject, eventdata, handles);
set(handles.radiobutton_spektras,'Enable','off');
set(handles.radiobutton_galia_absol,'Enable','off');
set(handles.radiobutton_galia_santyk,'Enable','off');

set(handles.checkbox_baigti_anksciau,'Value',0);
set(handles.checkbox_baigti_anksciau,'Visible','off');
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
set(handles.pushbutton14,'Enable','on');
set(handles.pushbutton18,'Enable','on');
set(handles.pushbutton19,'Enable','on');
set(handles.pushbutton_v1,'Enable','on');
set(handles.pushbutton_v2,'Enable','on');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','on');

set(handles.uitable1,'Enable','on');
set(handles.checkbox79,'Enable','on');
checkbox79_Callback(hObject, eventdata, handles);
set(handles.edit_tikslumas,'Enable','on');
set(handles.edit_fft_langas,'Enable','on');
set(handles.edit_doc,'Enable','on');
set(handles.popupmenu_doc,'Enable','on');
set(handles.checkbox_perziura,'Enable','off');
checkbox_perziura_Callback(hObject, eventdata, handles);
set(handles.checkbox_perziura,'Enable','on');
set(handles.checkbox_interpol,'Enable','on');
%set(handles.radiobutton_galia_absol,'Enable','on');
%set(handles.radiobutton_galia_santyk,'Enable','on');

popupmenu_doc_Callback(hObject, eventdata, handles);
uipanel15_SelectionChangeFcn(hObject, eventdata, handles);

%Vykdymo mygtukas
Ar_galima_vykdyti(hObject, eventdata, handles);

set(handles.checkbox_baigti_anksciau,'Visible','off');
set(handles.checkbox_pabaigus_atverti,'Visible','on');

%Vidinis atliktų darbų skaitliukas
% set(handles.text_atlikta_darbu,'String',num2str(0));

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
if ~Ar_galima_vykdyti1(hObject, eventdata, handles, 1);
    drawnow; return;
end;
if ~Ar_galima_vykdyti3(hObject, eventdata, handles, 1);
    drawnow; return;
end;
set(handles.pushbutton1,'Enable','on');
drawnow;

function Galima=Ar_galima_vykdyti1(hObject, eventdata, handles, blykcioti)
Galima=false;
if isempty(get(handles.listbox1,'String'));
    drawnow; return;
end;
if get(handles.listbox1,'Value') == 0;
    drawnow; return;
end;
Pasirinkti_failu_indeksai=(get(handles.listbox1,'Value'));
if isempty(Pasirinkti_failu_indeksai);
    if blykcioti;
        set(handles.listbox1,'BackgroundColor', [1 1 0]); pause(1);
        set(handles.listbox1,'BackgroundColor', [1 1 1]);
    end;
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
if isempty(get(handles.edit_tikslumas,'String'));
    set(handles.edit_tikslumas,'BackgroundColor', [1 1 0]);
    return;
end;
if isempty(get(handles.edit_fft_langas,'String'));
    set(handles.edit_fft_langas,'BackgroundColor', [1 1 0]);
    return;
end;

naudotojo_lentele=[[{lokaliz('visa')} ...
    num2cell(str2num(get(handles.edit51,'String')))];...
    get(handles.uitable1,'Data')];
Dazniu_sriciu_pavadinimai=[naudotojo_lentele(:,1)]';
Dazniu_sritys=cellfun(@(x) [naudotojo_lentele{x,2:3}], ...
    num2cell(1:length(Dazniu_sriciu_pavadinimai)),'UniformOutput',false);
lentele_bloga=false;
for i=1:length(Dazniu_sriciu_pavadinimai);
    if or(...
       or(isempty(Dazniu_sriciu_pavadinimai{i}),...
           strcmp(Dazniu_sriciu_pavadinimai{i},'?')),...
       or(~isempty(find(isnan(Dazniu_sritys{i}))),...
           Dazniu_sritys{i}(1)>=Dazniu_sritys{i}(2)));
        lentele_bloga=true;
        break;
    end;
end;
if lentele_bloga
    set(handles.uitable1,'BackgroundColor', [1 1 0]);
    %drawnow; pause(1)
    %set(handles.uitable1,'BackgroundColor', [1 1 1]);
    drawnow; return;
else
    set(handles.uitable1,'BackgroundColor', [1 1 1]);
end;

% Vykdyti galima
Galima=true;

function Galima=Ar_galima_vykdyti2(hObject, eventdata, handles)
Galima=false;
fft_lango_ilgis_sekundemis=str2num(get(handles.edit_fft_langas,'String'));
Pasirinkti_kanalai=get(handles.pushbutton14,'UserData');
RINKMENOS=get(handles.listbox1,'String');
if isempty(RINKMENOS); return; end;
RINKMENOS=RINKMENOS(get(handles.listbox1,'Value'));
if isempty(RINKMENOS); return; 
elseif isempty(atrinkti_teksta(lower(RINKMENOS),'*.set'));
    Galima=true; return;
end;
[~,~,min_trukme,patikrintos_visos]=...
    eeg_trukmiu_sarasas(get(handles.edit1,'String'), RINKMENOS);
if min_trukme < fft_lango_ilgis_sekundemis;
    wrn=warning('off','backtrace');
    warning([lokaliz('FFT window length') ' (' num2str(fft_lango_ilgis_sekundemis) ...
        ') > EEG.xmax - EEG.xmin (' num2str(min_trukme) ')' ]);
    warning(wrn.state, 'backtrace');
    set(handles.edit_fft_langas,'Backgroundcolor',[1 1 0]); drawnow; pause(1);
    set(handles.edit_fft_langas,'Backgroundcolor',[1 1 1]); drawnow;
    return;
end;
if isempty(Pasirinkti_kanalai); Galima=true; return; end;
[~,visi_galimi_kanalai,~,patikrintos_visos]=...
    eeg_kanalu_sarasas(get(handles.edit1,'String'), RINKMENOS);
if ~patikrintos_visos; Galima=true; end;
if isempty(find(ismember(Pasirinkti_kanalai,visi_galimi_kanalai)));
    warning(lokaliz('No selected channels found in selected files.'));
    set(handles.pushbutton14,'Backgroundcolor',[1 1 0]) ; drawnow; pause(1);
    set(handles.pushbutton14,'Backgroundcolor','remove'); drawnow;
    return;
end;
Galima=true;

function Galima=Ar_galima_vykdyti3(hObject, eventdata, handles, blykcioti)
Galima=false;
if ~( get(handles.checkbox75,'Value') || get(handles.checkbox76,'Value') || get(handles.checkbox77,'Value') );
    if blykcioti;
        set([handles.checkbox75 handles.checkbox76 handles.checkbox77],'BackgroundColor', [1 1 0]); pause(1);
        set([handles.checkbox75 handles.checkbox76 handles.checkbox77],'BackgroundColor', 'remove');
    end;
    return;
end;
Galima=true;


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
Ar_galima_vykdyti(hObject, eventdata, handles);
if strcmp(get(handles.pushbutton1,'Enable'),'on');
    if Ar_galima_vykdyti2(hObject, eventdata, handles);
        vykdymas(hObject, eventdata, handles);
    end;
end;


% --- Pats darbo vykdymas
function vykdymas(hObject, eventdata, handles)
if strcmp(get(handles.pushbutton1,'Enable'),'off'); return; end;
disp(' ');
disp('===================================');
disp(' S P E K T R A S   I R   G A L I A ');
disp(' ');
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
%if get(handles.checkbox55,'Value'); NewDir=get(handles.edit60,'String'); else
NewDir='';
%end;
disp(lokaliz('Processed files will go to '));
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
    catch %err1;
        Darbeliai.keliai.atverimui=[{} KELIAS];
    end;    
    try
        lst=[{} KELIAS_SAUGOJIMUI unique(Darbeliai.keliai.saugojimui)];
        [~,idx,~]=unique(lst);
        Darbeliai.keliai.saugojimui=lst(sort(idx));
    catch %err2;
        Darbeliai.keliai.saugojimui=[{} KELIAS_SAUGOJIMUI];
    end;
    save(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'),'Darbeliai');
catch %err; warning(err.message);
end;

% Užduočių parinkčių įsiminimas
parinktis_irasyti(hObject, eventdata, handles, 'paskutinis','');
%Neleisti spausti Nuostatų meniu!
for m_id={'m_Nuostatos' 'm_Darbeliai' 'm_Veiksmai'};
    set(findall(handles.figure1,'Type','uimenu','Tag',m_id{1}),'Enable','off');
end;
drawnow;

%STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
%[ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);

% Isimink laika  - veliau bus galimybe paziureti, kiek laiko uztruko
tic

DarboNr=0;
PaskutinioIssaugotoDarboNr=0;
Apdoroti_visi_tiriamieji=0;
sukauptos_klaidos={};

%axes(handles.axes1);
%datacursormode off;

Pasirinkti_kanalai=get(handles.pushbutton14,'UserData');
if ~isempty(Pasirinkti_kanalai);
    Reikalingi_kanalai=Pasirinkti_kanalai;
    Reikalingi_kanalai_sukaupti=Reikalingi_kanalai;
else
    disp('Nepasirinkote kanalų! Bus įkelti visi kanalai!');
    [~,~,Pasirinkti_kanalai]=eeg_kanalu_sarasas(KELIAS, Pasirinkti_failu_pavadinimai);
    if isempty(Pasirinkti_kanalai);
        warndlg(lokaliz('No common names of channels found.'),lokaliz('Selection of channels'));
        susildyk(hObject, eventdata, handles);
        return;
    end
    disp('Parinkti kanalai:');
    disp(sprintf('''%s'' ',Pasirinkti_kanalai{:}));
    Reikalingi_kanalai={}; %Nebus keičiamas darbų eigoje
    Reikalingi_kanalai_sukaupti={}; % bus keičiamas darbų eigoje
end;
leisti_interpoliuoti=get(handles.checkbox_interpol,'Value');
ribos=str2num(get(handles.edit51,'String'));%*1000;
Ar_reikia_galios_absoliucios=get(handles.checkbox76,'Value');
Ar_reikia_galios_santykines=get(handles.checkbox77,'Value');
Ar_reikia_spekro_absol=0; % FIXME: leisti pasirinkti
Ar_reikia_spekro_db=get(handles.checkbox75,'Value');

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

    DarboNr=1;
    DarboPorcijaAtlikta=0;
    PaskutinioIssaugotoDarboNr=0;
    PaskRinkmIssaugKelias=KELIAS;
    
    %guidata(hObject, handles);
    %Darbo_eigos_busena(handles, lokaliz('Loading data...'), DarboNr, i, Pasirinktu_failu_N);
    
        
        % Darbas
        Darbo_apibudinimas=[ lokaliz('EEG spektras ir galia') '...'];
            %DarboNr = DarboNr + 1 ;                
                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);
                
                try
                    
                    Doc_pvd=get(handles.edit_doc,'String');
                    switch get(handles.popupmenu_doc,'Value')
                        case 1
                            Doc_tp='mat';
                        case 2
                            Doc_tp='txt';
                    end;
                    
                    naudotojo_lentele=[[{lokaliz('visa')} ...
                        num2cell(str2num(get(handles.edit51,'String')))];...
                        get(handles.uitable1,'Data')];
                    Dazniu_sriciu_pavadinimai=[naudotojo_lentele(:,1)]';
                    Dazniu_sritys=cellfun(@(x) [naudotojo_lentele{x,2:3}], ...
                        num2cell(1:length(Dazniu_sriciu_pavadinimai)),'UniformOutput',false);
                    Papildomi_dazniu_santykiai={};
                    
                    fft_lango_ilgis_sekundemis=str2num(get(handles.edit_fft_langas,'String'));
                    fft_tasku_herce=str2num(get(handles.edit_tikslumas,'String'));
                    
                    axes(handles.axes1);
                    
                    [DUOMENYS]=eeg_spektr_galia(...
                        KELIAS, Pasirinkti_failu_pavadinimai,...
                        get(handles.edit2,'String'), Doc_pvd, Doc_tp, ...
                        Pasirinkti_kanalai,leisti_interpoliuoti,...
                        Dazniu_sritys,...
                        Dazniu_sriciu_pavadinimai,...
                        Papildomi_dazniu_santykiai,...
                        0,...
                        fft_lango_ilgis_sekundemis(1),...
                        fft_tasku_herce, ...
                        Ar_reikia_galios_absoliucios, ...
                        Ar_reikia_galios_santykines, ...
                        Ar_reikia_spekro_absol, ...
                        Ar_reikia_spekro_db);
                    %assignin('base','DUOMENYS',DUOMENYS);
                    Apdoroti_visi_tiriamieji=1;
                    DarboPorcijaAtlikta = 1;
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('EEG spektras ir galia'), '?');
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    %EEG.nbchan=0;
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
            if ~isempty(PaskRinkmIssaugKelias);
                set(handles.edit1,'String',PaskRinkmIssaugKelias);
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
    
    if ~isempty(PaskRinkmIssaugKelias);
        set(handles.edit1,'String',PaskRinkmIssaugKelias);
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
checkbox_perziura_Callback(hObject, eventdata, handles);

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
cd(KELIAS);
set(handles.edit2,'BackgroundColor',[1 1 1]);
Ar_galima_vykdyti(hObject, eventdata, handles);



% --- Executes on button press in checkbox_uzverti_pabaigus.
function checkbox_uzverti_pabaigus_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_uzverti_pabaigus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_uzverti_pabaigus


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
                        %        pop_eeg_spektrine_galia;
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
if length(x) == 2 ;
    if x(1) < x(2);
        set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));
    end;
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
set(elementas,'BackgroundColor',[1 1 1]);
checkbox_perziura_Callback(hObject, eventdata, handles);

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
set(handles.pushbutton14,'String',lokaliz('Channels...'));
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
set(handles.uipanel23,'Title',lokaliz('Preview'));
set(handles.text24,'String', lokaliz('Frequency interval (Hz)'));
set(handles.text54,'String', lokaliz('Document:'));
set(handles.text_failu_filtras1,'String',lokaliz('Show_filenames_filter:'));
set(handles.text_failu_filtras2,'String',lokaliz('Select_filenames_filter:'));
set(handles.checkbox_uzverti_pabaigus,'String',lokaliz('Close when complete'));
set(handles.checkbox_baigti_anksciau,'String',lokaliz('Break work'));
set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'String',lokaliz('Go to saved files directory when completed'));
set(handles.checkbox_pabaigus_atverti,'String',lokaliz('Load saved files in EEGLAB when completed'));
set(handles.checkbox_interpol,'String',lokaliz('Allow interpolate channels'));
set(handles.radiobutton_spektras,'String',lokaliz('Spectrum'));
set(handles.checkbox75,'String',lokaliz('Spectrum'));
set(handles.radiobutton_galia_absol,'String',lokaliz('Absolute power'));
set(handles.checkbox76,'String',lokaliz('Absolute power'));
set(handles.radiobutton_galia_santyk,'String',lokaliz('Relative power'));
set(handles.checkbox77,'String',lokaliz('Relative power'));
set(handles.checkbox_legenda,'String',lokaliz('Legend'));
set(handles.palaukite,'String',lokaliz('Palaukite!'));
set(handles.text53,'String', [ lokaliz('FFT window length') ' '  lokaliz('(seconds_short)') ]);
set(handles.text52,'String', lokaliz('Spectrum steps in 1 Hz:'));
stlp1=lokaliz('Spectrum band');
stlp2=lokaliz('From (time)');
stlp3=lokaliz('To (time)');
set(handles.uitable1,'ColumnName', {stlp1 stlp2 stlp3});
set(handles.edit_doc,'String',[ lokaliz('Galia') '_%t' ]);

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VISI_KANALAI_64={'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'M1' 'T7' 'C3' 'Cz' 'C4' 'T8' 'M2' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8';};

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
pateikiami_kiti_v=0;
dar_kiti_kanalai=sort(VISI_KANALAI_64(find(ismember(VISI_KANALAI_64,visi_galimi_kanalai)==0)));
if and(~isempty(dar_kiti_kanalai),get(handles.checkbox_interpol,'Value'));
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(other:)') dar_kiti_kanalai{:} };
   pateikiami_kiti_v=1+pateikiami_bendri_v + (pateikiami_nebendri_v ~= 0) + length(visi_galimi_kanalai);
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
if ismember(pateikiami_kiti_v,pasirinkti_kanalai_idx);
    pasirinkti_kanalai={pasirinkti_kanalai{:} dar_kiti_kanalai{:} };
end;
pasirinkti_kanalai_idx_=pasirinkti_kanalai_idx( ...
    find(ismember(pasirinkti_kanalai_idx, ...
    [pateikiami_bendri_v pateikiami_nebendri_v pateikiami_kiti_v])==0));
pasirinkti_kanalai=unique({pasirinkti_kanalai{:} pateikiami_kanalai{pasirinkti_kanalai_idx_}});
pasirinkti_kanalai_str=[pasirinkti_kanalai{1}];
for i=2:length(pasirinkti_kanalai);
    pasirinkti_kanalai_str=[pasirinkti_kanalai_str ' ' pasirinkti_kanalai{i}];
end;
disp([ '''' regexprep(pasirinkti_kanalai_str, ' ', ''' ''') '''' ]);
if get(handles.checkbox_interpol,'Value') == 0 ;
    if ~isempty(find(ismember(pasirinkti_kanalai,bendri_kanalai)==0));
        button3 = questdlg([' ' ...
            lokaliz('Some selected channels may not appear in every dataset.') ' ' ...
            lokaliz('Allow interpolation?') ] , ...
            lokaliz('Select channels'), ...
            lokaliz('No'), lokaliz('Yes'), lokaliz('Yes'));
        if strcmp(button3,lokaliz('Yes'));
            set(handles.checkbox_interpol,'Value',1);
        end;
    end;
end;
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
checkbox_perziura_Callback(hObject, eventdata, handles);

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
set(handles.edit2,'BackgroundColor',[1 1 1]);


% --- Executes on button press in checkbox60.
function checkbox_legenda_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox60

% Legendos įjungimas/išjungimas

axes(handles.axes1);
legenda(hObject, eventdata, handles);

function legenda(hObject, eventdata, handles)
if get(handles.checkbox_legenda, 'Value');
    l=legend('show');
    lstr=get(l, 'String');
    %ribos=str2num(get(handles.edit51,'String'));
    %atmest_ir=length(ribos)+2;
    %legend('boxoff');
    lk=get(handles.axes1, 'UserData');
    if lk > 0;
        legend(lstr(1:(min(lk,size(lstr,2)))), 'FontSize', 6, 'Location', 'eastoutside', 'Interpreter', 'none');
    end;
    set(handles.axes1,'units','normalized','Position',[0.1 0.15 0.65 0.7]);
else
    %legend('hide');
    legend('off');
    set(handles.axes1,'units','normalized','Position',[0.1 0.15 0.85 0.7]);
end;
drawnow;

% --- Executes on button press in checkbox_perziura.
function checkbox_perziura_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_perziura (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_perziura
if get(handles.checkbox_perziura,'Value');
    set(handles.radiobutton_spektras,'Enable','on');
    set(handles.radiobutton_galia_absol,'Enable','on');
    set(handles.radiobutton_galia_santyk,'Enable','on');  
    set(handles.checkbox_legenda,'Enable','on');  
    set(handles.axes1,'Visible','on');  
else
    set(handles.radiobutton_spektras,'Enable','off');
    set(handles.radiobutton_galia_absol,'Enable','off');
    set(handles.radiobutton_galia_santyk,'Enable','off');    
    set(handles.checkbox_legenda,'Enable','off');   
    set(handles.axes1,'Visible','off');     
    axes(handles.axes1);
    legend('off');
    cla;
    return;
end;
if strcmp(get(handles.checkbox_perziura,'Enable'),'off');
    return;
end;

if ~Ar_galima_vykdyti1(hObject, eventdata, handles, 0);
    return;
end;
if ~Ar_galima_vykdyti2(hObject, eventdata, handles);
    return;
end;

set(handles.palaukite,'Visible','on');
susaldyk(hObject, eventdata, handles);
drawnow;

Pasirinkti_failu_indeksai=(get(handles.listbox1,'Value'));
Rodomu_failu_pavadinimai=(get(handles.listbox1,'String'));
Pasirinkti_failu_pavadinimai=Rodomu_failu_pavadinimai(Pasirinkti_failu_indeksai);
Pasirinktu_failu_N=length(Pasirinkti_failu_pavadinimai);
KELIAS=Tikras_Kelias(get(handles.edit1,'String'));

tic

leisti_interpoliuoti=get(handles.checkbox_interpol,'Value');
Pasirinkti_kanalai=get(handles.pushbutton14,'UserData');
if ~isempty(Pasirinkti_kanalai);
    Reikalingi_kanalai=Pasirinkti_kanalai;
    Reikalingi_kanalai_sukaupti=Reikalingi_kanalai;
else
    disp('Nepasirinkote kanalų! Bus įkelti visi kanalai!');
    if leisti_interpoliuoti == 0
       [~,~,Pasirinkti_kanalai]=eeg_kanalu_sarasas(KELIAS, Pasirinkti_failu_pavadinimai);
    else
       [~,Pasirinkti_kanalai,~]=eeg_kanalu_sarasas(KELIAS, Pasirinkti_failu_pavadinimai);
    end;
    if isempty(Pasirinkti_kanalai);
        warndlg(lokaliz('No common names of channels found.'),lokaliz('Selection of channels'));
        susildyk(hObject, eventdata, handles);
        set(handles.palaukite,'Visible','off');
        return;
    end
    disp('Parinkti kanalai:');
    disp(sprintf('''%s'' ',Pasirinkti_kanalai{:}));
    Reikalingi_kanalai={}; %Nebus keičiamas darbų eigoje
    Reikalingi_kanalai_sukaupti={}; % bus keičiamas darbų eigoje
end;

legendoje={};
simboliai='*o^v<>dspx';
colormap('colorcube');   spalvos1=colormap;
spalvos1=spalvos1([1:63],:);
colormap('lines'); spalvos2=colormap; spalvos2=spalvos2(1:7,:);
spalvos=[spalvos2; spalvos1];
colormap('default');
    
try    
    naudotojo_lentele=[[{lokaliz('visa')} ...
        num2cell(str2num(get(handles.edit51,'String')))];...
        get(handles.uitable1,'Data')];
    Dazniu_sriciu_pavadinimai=[naudotojo_lentele(:,1)]';
    Dazniu_sritys=cellfun(@(x) [naudotojo_lentele{x,2:3}], ...
        num2cell(1:length(Dazniu_sriciu_pavadinimai)),'UniformOutput',false);
    Papildomi_dazniu_santykiai={};
    
    fft_lango_ilgis_sekundemis=str2num(get(handles.edit_fft_langas,'String'));
    fft_tasku_herce=str2num(get(handles.edit_tikslumas,'String'));
        
    [DUOMENYS]=eeg_spektr_galia(...
        KELIAS, Pasirinkti_failu_pavadinimai,...
        get(handles.edit2,'String'), '', 'pseudo', ...
        Pasirinkti_kanalai,leisti_interpoliuoti,...
        Dazniu_sritys,...
        Dazniu_sriciu_pavadinimai,...
        Papildomi_dazniu_santykiai,...
        0,...
        fft_lango_ilgis_sekundemis(1),...
        fft_tasku_herce,...
        0, 0, 0, 0);
    %assignin('base','DUOMENYS',DUOMENYS);
    
    
    axes(handles.axes1);
    cla;
    
    if get(handles.radiobutton_spektras,'Value');
        ylabel('10 * lg(\muV^{2}/Hz)','FontSize',10);
        set(handles.axes1,'XLim',str2num(get(handles.edit51,'String')));
        set(handles.axes1,'XTickMode', 'auto');
        set(handles.axes1,'XTickLabelMode', 'auto');
        %set(handles.axes1,'XTick',[0 10 20 30 40 50 60]);
        %set(handles.axes1,'XTickLabel',{'0' '10' '20' '30' '40' '50' '    60, Hz'});
        tmp_lab=get(handles.axes1,'XTickLabel');
        try
            set(handles.axes1,'XTickLabel', [ (tmp_lab(1:end-1,:)) ; {[ ' ' tmp_lab(end,:) ' Hz' ]} ]); % MATLAB R2014a
        catch
            set(handles.axes1,'XTickLabel', [ (tmp_lab(1:end-1,:)) ; {[ ' ' tmp_lab{end,:} ' Hz' ]} ]); % MATLAB R2015a
        end;
        hold('on');
        dazniu_tasku_N=size(DUOMENYS.VISU.DAZNIAI,1);
        TMP_SPEKTR=nan(DUOMENYS.VISU.KANALU_N * DUOMENYS.VISU.Tiriamuju_N, dazniu_tasku_N);
        for k=1:DUOMENYS.VISU.KANALU_N;
            for i=1:DUOMENYS.VISU.Tiriamuju_N;
                l=size(legendoje,1);
                legendoje{l+1,1}=regexprep(DUOMENYS.VISU.failai{i},'.set$','');
                legendoje{l+1,2}=DUOMENYS.VISU.KANALAI{k};
                TMP_SPEKTR((k-1)*DUOMENYS.VISU.Tiriamuju_N + i,:)=DUOMENYS.VISU.SPEKTRAS_LENTELESE_dB{i,1}(k,1:dazniu_tasku_N);
            end;
        end;
        for i=1:size(TMP_SPEKTR,1);
            plot(DUOMENYS.VISU.DAZNIAI,TMP_SPEKTR(i,:),'color',spalvos(1+mod(i-1,length(spalvos)),:));
        end;
    end;
    
    if get(handles.radiobutton_galia_absol,'Value');
        ylabel('\muV^{2}','FontSize',10);
        hold('on');
        if (DUOMENYS.VISU.Dazniu_sriciu_N > 1 );
            set(handles.axes1,'XLim',[1.5 DUOMENYS.VISU.Dazniu_sriciu_N + 0.5]);
            set(handles.axes1,'XTick',[2:DUOMENYS.VISU.Dazniu_sriciu_N]');
            set(handles.axes1,'XTickLabel',DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(2:end));
            for i=2:DUOMENYS.VISU.Dazniu_sriciu_N;
                for j=1:DUOMENYS.VISU.Tiriamuju_N;
                    simb=simboliai(1+mod(j,length(simboliai)));
                    for k=1:DUOMENYS.VISU.KANALU_N;
                        splv=fastif(DUOMENYS.VISU.KANALU_N == 1, ...
                            spalvos(1+mod(j-1,length(spalvos)),:), ...
                            spalvos(1+mod(k-1,length(spalvos)),:));
                        plot(i,DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{i,1}(j,k),...
                            'LineStyle','none','Color',splv,'Marker',simb);
                    end;
                end;
            end;
            
        else
            set(handles.axes1,'XLim',[1.5 2.5]);
            set(handles.axes1,'XTick',[2]);
            set(handles.axes1,'XTickLabel',DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(1));
            plot(2,DUOMENYS.VISU.GALIA_Absol_dazniu_srityje{1,1}(:),'o');
        end;
        for i=1:DUOMENYS.VISU.Tiriamuju_N;
            for k=1:DUOMENYS.VISU.KANALU_N;
                l=size(legendoje,1);
                legendoje{l+1,1}=regexprep(DUOMENYS.VISU.failai{i},'.set$','');
                legendoje{l+1,2}=DUOMENYS.VISU.KANALAI{k};
            end;
        end;
    end;
    
    if get(handles.radiobutton_galia_santyk,'Value')
        hold('on');
        ylabel('');
        if (DUOMENYS.VISU.Dazniu_sriciu_N > 1 );
            set(handles.axes1,'XLim',[1.5 DUOMENYS.VISU.Dazniu_sriciu_N + 0.5]);
            set(handles.axes1,'XTick',[2:DUOMENYS.VISU.Dazniu_sriciu_N]');
            set(handles.axes1,'XTickLabel',DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(2:end));
            for i=2:DUOMENYS.VISU.Dazniu_sriciu_N;
                for j=1:DUOMENYS.VISU.Tiriamuju_N;
                    simb=simboliai(1+mod(j,length(simboliai)));
                    for k=1:DUOMENYS.VISU.KANALU_N;
                        splv=fastif(DUOMENYS.VISU.KANALU_N == 1, ...
                            spalvos(1+mod(j-1,length(spalvos)),:), ...
                            spalvos(1+mod(k-1,length(spalvos)),:));
                        plot(i,DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{i,1}(j,k),...
                            'LineStyle','none','Color',splv,'Marker',simb);
                    end;
                end;
            end;
        else            
            set(handles.axes1,'XLim',[1.5 2.5]);
            set(handles.axes1,'XTick',[2]);
            set(handles.axes1,'XTickLabel',DUOMENYS.VISU.Dazniu_sriciu_pavadinimai(1));
            plot(2,DUOMENYS.VISU.GALIA_Sant_dazniu_srityje{1,1}(:),'o');
        end;
        for i=1:DUOMENYS.VISU.Tiriamuju_N;
            for k=1:DUOMENYS.VISU.KANALU_N;
                l=size(legendoje,1);
                legendoje{l+1,1}=regexprep(DUOMENYS.VISU.failai{i},'.set$','');
                legendoje{l+1,2}=DUOMENYS.VISU.KANALAI{k};
            end;
        end;
    end;
    
    set(handles.axes1, 'UserData', size(legendoje,1)); 
    if size(legendoje,1) > 0;
        %disp(legendoje);
        skirtingu_failu=length(unique(legendoje(:,1)'));
        skirtingu_kanalu=length(unique(legendoje(:,2)'));
        if skirtingu_kanalu==1;
            %disp(2);
            legend(legendoje(:,1),'FontSize', 6, 'Location', 'eastoutside', 'Interpreter', 'none');
            legend('show');
        end;
        if skirtingu_failu==1;
            %disp(1);
            legend(legendoje(:,2),'FontSize', 6, 'Location', 'eastoutside', 'Interpreter', 'none');
            legend('show');
        end;
        if and(skirtingu_failu > 1, skirtingu_kanalu > 1);
            %disp(3);
            tmp=cellfun(@(z) sprintf('%s: %s', legendoje{z,1},legendoje{z,2}), num2cell(1:size(legendoje,1)),'UniformOutput',false);
            legend(tmp,'FontSize', 6, 'Location', 'eastoutside', 'Interpreter', 'none');
            legend('show');
        end;
    end;
    if or(size(legendoje,1)==0,~get(handles.checkbox_legenda, 'Value'));
        legend('off');
    end;
    
catch err;
    Pranesk_apie_klaida(err, lokaliz('EEG spektras ir galia'), '?');
end;
susildyk(hObject, eventdata, handles);
set(handles.palaukite,'Visible','off');
                

% --- Executes on button press in checkbox74.
function checkbox74_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox74


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
senas=get(handles.uitable1,'Data');
d=size(senas,1);
if d == 0 ;
    return;
elseif d == 1;        
    set(handles.uitable1,'Data',senas(1:end-1,:));
else
    a=listdlg(...
        'PromptString', lokaliz('Trinti:'),...
        'ListString',senas(:,1),...
        'SelectionMode','multiple',...
        'InitialValue',d,...
        'OKString',lokaliz('OK'),...
        'CancelString',lokaliz('Cancel'));
    if isempty(a); return; end;
    set(handles.uitable1,'Data',senas(setdiff(1:d,a),:));
end;
if get(handles.checkbox79,'Value');
        lentele=get(handles.uitable1,'Data');
        interv=[min([lentele{:,2}]) max([lentele{:,3}])];
        set(handles.edit51,'String',num2str(interv));
        edit51_Callback(hObject, eventdata, handles);
end;
Ar_galima_vykdyti(hObject, eventdata, handles);
checkbox_perziura_Callback(hObject, eventdata, handles);

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
senas=get(handles.uitable1,'Data');
set(handles.uitable1,'Data',[senas; {'?' [NaN] [NaN];} ]);

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
try
    lentele=get(handles.uitable1,'Data');
    set(handles.uitable1,'Data',sortrows(lentele,[2 3 1]));
    if get(handles.checkbox79,'Value');
        interv=[min([lentele{:,2}]) max([lentele{:,3}])];
        set(handles.edit51,'String',num2str(interv));
        edit51_Callback(hObject, eventdata, handles);
    end;
catch err;
    set(handles.uitable1,'BackgroundColor', [1 1 0]);
end;
  
Ar_galima_vykdyti(hObject, eventdata, handles);
checkbox_perziura_Callback(hObject, eventdata, handles);


function edit_tikslumas_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tikslumas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tikslumas as text
%        str2double(get(hObject,'String')) returns contents of edit_tikslumas as a double
elementas=handles.edit_tikslumas;
x=str2num(get(elementas,'String'));
if length(x) == 1 ;
    set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
set(elementas,'BackgroundColor',[1 1 1]);
checkbox_perziura_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_tikslumas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tikslumas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fft_langas_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fft_langas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fft_langas as text
%        str2double(get(hObject,'String')) returns contents of edit_fft_langas as a double
elementas=handles.edit_fft_langas;
x=str2num(get(elementas,'String'));
if length(x) == 1 ;
    set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
set(elementas,'BackgroundColor',[1 1 1]);
checkbox_perziura_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_fft_langas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fft_langas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_doc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_doc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_doc as text
%        str2double(get(hObject,'String')) returns contents of edit_doc as a double


% --- Executes during object creation, after setting all properties.
function edit_doc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_doc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_doc.
function popupmenu_doc_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_doc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_doc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_doc
busena=get(handles.popupmenu_doc,'Enable');
switch get(handles.popupmenu_doc,'Value')
    case 1
        set(handles.checkbox75, 'Visible', 'on', 'Enable', 'off', 'Value', 1);
        set(handles.checkbox76, 'Visible', 'on', 'Enable', 'off', 'Value', 1);
        set(handles.checkbox77, 'Visible', 'on', 'Enable', 'off', 'Value', 1);
    case 2
        set(handles.checkbox75, 'Visible', 'on', 'Enable', busena);
        set(handles.checkbox76, 'Visible', 'on', 'Enable', busena);
        set(handles.checkbox77, 'Visible', 'on', 'Enable', busena);
end;

% --- Executes during object creation, after setting all properties.
function popupmenu_doc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_doc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox75.
function checkbox75_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox75
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes on button press in checkbox76.
function checkbox76_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox76
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes on button press in checkbox77.
function checkbox77_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox77
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function uipanel23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes when selected object is changed in uipanel23.
function uipanel23_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel23 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
checkbox_perziura_Callback(hObject, eventdata, handles);


% --- Executes on button press in checkbox_interpol.
function checkbox_interpol_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_interpol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_interpol
checkbox_perziura_Callback(hObject, eventdata, handles);

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h2 = figure;
set(h2,'Visible','off');
try
    set(handles.palaukite,'Visible','on');
    fn=[tempname '.fig'];
    try
        hgsave(handles.axes1,fn);
    catch err;
        disp(err.message)
        savefig(handles.axes1,fn);
    end;
    a2=openfig(fn);
    set(a2,'Parent',h2);
    set(a2,'ButtonDownFcn','');
    set(a2,'units','normalized','Position',[0.1 0.1 0.65 0.8]);
    figure(h2);
    datacursormode on;
    try delete(fn); catch err; end;
catch err;
    delete(h2);
    h2 = figure;
    disp(err.message)
    fnc=get(handles.axes1,'ButtonDownFcn');
    poz=get(handles.axes1,'Position');
    uni=get(handles.axes1,'units');
    set(handles.axes1,'ButtonDownFcn','');
    set(handles.axes1,'units','normalized','Position',[0.1 0.1 0.65 0.8]);
    nauj=copyobj(handles.axes1, h2);
    datacursormode on;
    set(handles.axes1,'ButtonDownFcn',fnc);
    set(handles.axes1,'units',uni);
    set(handles.axes1,'Position',poz);
    axes(nauj);
    legenda(hObject, eventdata, handles);
end;
set(h2,'Visible','on');
set(handles.palaukite,'Visible','off');

% --- Executes on button press in checkbox79.
function checkbox79_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox79
if get(handles.checkbox79,'Value')
    if strcmp(get(handles.checkbox79,'Enable'),'on');
        try
            lentele=get(handles.uitable1,'Data');
            interv=[min([lentele{:,2}]) max([lentele{:,3}])];
            set(handles.edit51,'String',num2str(interv));
            edit51_Callback(hObject, eventdata, handles);
        catch err;
            set(handles.uitable1,'BackgroundColor', [1 1 0]);
        end;
    end;
    set(handles.edit51,'Enable','off');
else
    if strcmp(get(handles.checkbox79,'Enable'),'on');
        set(handles.edit51,'Enable','on');
    else
        set(handles.edit51,'Enable','off');
    end;
end;
   


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
    'checkbox79' 'checkbox74' 'checkbox_interpol' 'checkbox_perziura' 'checkbox_legenda' 'pushbutton14' ...
    'checkbox75' 'checkbox76' 'checkbox77' 'popupmenu_doc' ...
    'radiobutton_spektras' 'radiobutton_galia_absol' 'radiobutton_galia_santyk' 'radiobutton6' 'radiobutton7' };
    
isimintini(2).raktai={'Value' 'UserData' 'String'};
isimintini(2).nariai={ 'edit51' 'edit_fft_langas' 'edit_tikslumas' 'edit_doc' };

isimintini(3).raktai={'Value' 'UserData' 'String' 'TooltipString'};
isimintini(3).nariai={ 'text47' };

isimintini(4).raktai={'UserData' 'Data' 'ColumnName' 'TooltipString'};
isimintini(4).nariai={ 'uitable1' };
drb_parinktys(hObject, eventdata, handles, 'irasyti', mfilename, vardas, komentaras, isimintini);

