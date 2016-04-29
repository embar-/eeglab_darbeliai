%
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

function varargout = pop_nuoseklus_apdorojimas(varargin)
% POP_NUOSEKLUS_APDOROJIMAS MATLAB code for pop_nuoseklus_apdorojimas.fig
%      POP_NUOSEKLUS_APDOROJIMAS, by itself, creates a new POP_NUOSEKLUS_APDOROJIMAS or raises the existing
%      singleton*.
%
%      H = POP_NUOSEKLUS_APDOROJIMAS returns the handle to a new POP_NUOSEKLUS_APDOROJIMAS or the handle to
%      the existing singleton*.
%
%      POP_NUOSEKLUS_APDOROJIMAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_NUOSEKLUS_APDOROJIMAS.M with the given input arguments.
%
%      POP_NUOSEKLUS_APDOROJIMAS('Property','Value',...) creates a new POP_NUOSEKLUS_APDOROJIMAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_nuoseklus_apdorojimas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_nuoseklus_apdorojimas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_nuoseklus_apdorojimas

% Last Modified by GUIDE v2.5 21-Nov-2015 19:24:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_nuoseklus_apdorojimas_OpeningFcn, ...
    'gui_OutputFcn',  @pop_nuoseklus_apdorojimas_OutputFcn, ...
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


% --- Executes just before pop_nuoseklus_apdorojimas is made visible.
function pop_nuoseklus_apdorojimas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_nuoseklus_apdorojimas (see VARARGIN)

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
set(handles.figure1,'Position',[pad(1) pad(2) max(pad(3),800) max(pad(4),600)]);

tic;

lokalizuoti(hObject, eventdata, handles);
drb_meniu(hObject, eventdata, handles, 'visas', mfilename);

Kelias_dabar=pwd;

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

set(    handles.edit_failu_filtras1,'String','*.set;*.cnt;*.edf');
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

edit3_Callback(hObject, eventdata, handles);
edit19_Callback(hObject, eventdata, handles);
edit21_Callback(hObject, eventdata, handles);
popupmenu3_Callback(hObject, eventdata, handles);

% Kurias parinktis įjungti vos paleidus
set(handles.checkbox_rf,'Value',0);
set(handles.checkbox_filtr1,'Value',0);
set(handles.checkbox_filtr2,'Value',0);
set(handles.checkbox_filtr_tinklo,'Value',0);
set(handles.checkbox_kanalu_padetis,'Value',0);
set(handles.checkbox_atrink_kanalus1,'Value',0);
set(handles.checkbox_atmesk_atkarpas_amp,'Value',0);
set(handles.checkbox_atmesk_atkarpas_dzn,'Value',0);
set(handles.checkbox_atmesk_kan_auto,'Value',0);
set(handles.checkbox_perziureti,'Value',0);
set(handles.checkbox_atmesk_iki2s,'Value',0);
set(handles.checkbox_vienoda_trukme,'Value',0);
set(handles.checkbox_ICA,'Value',0);
set(handles.checkbox_MARA,'Value',0);
set(handles.checkbox_atrink_kanalus2,'Value',0);
set(handles.checkbox_atrink_kanalus2A,'Value',1);
set(handles.checkbox_ASR,'Value',0);
set(handles.checkbox_perziureti_ICA,'Value',0);
set(handles.checkbox_epoch,'Value',0);

% Kitos numatytosios reikšmės
set(handles.edit_epoch_iv,'String','');
set(handles.popupmenu8,'Value',3);

set(handles.text_apdorotini_kanalai,'String',lokaliz('all'));
set(handles.text_apdorotini_kanalai,'TooltipString','');
set(handles.pushbutton_apdorotini_kanalai,'UserData',{});

VISI_KANALAI_66={'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'M1' 'T7' 'C3' 'Cz' 'C4' 'T8' 'M2' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'EOG' 'EOGh';};
kan_i=[1:3 5:7 9:12 15:17 20:23 25:27 29:58 65 66];
Parinkti_kanalai=VISI_KANALAI_66(kan_i);
Parinkti_kanalai_str=[Parinkti_kanalai{1}];
for i=2:length(Parinkti_kanalai);
    Parinkti_kanalai_str=[Parinkti_kanalai_str ' ' Parinkti_kanalai{i}];
end;
set(handles.text8,'TooltipString',Parinkti_kanalai_str);
set(handles.pushbutton9,'UserData',Parinkti_kanalai);


%disp(get(handles.pushbutton7,'UserData'));
kan_i=[5 7 25 27 41 43 48 50];
Parinkti_kanalai=VISI_KANALAI_66(kan_i);
Parinkti_kanalai_str=[Parinkti_kanalai{1}];
for i=2:length(Parinkti_kanalai);
    Parinkti_kanalai_str=[Parinkti_kanalai_str ' ' Parinkti_kanalai{i}];
end;
set(handles.text9,'TooltipString',Parinkti_kanalai_str);
set(handles.pushbutton7,'UserData',Parinkti_kanalai);

kanalu_padeciu_failai={};
siulomi_kanalu_padeciu_failai={ ...
   'Standard-10-5-Cap385_witheog.elp' ...
   'standard-10-5-cap385.elp'};
for i=1:length(siulomi_kanalu_padeciu_failai);
   if ~isempty(which(siulomi_kanalu_padeciu_failai{i}));
      kanalu_padeciu_failai= ...
        {kanalu_padeciu_failai{:} siulomi_kanalu_padeciu_failai{i}};
   end;
end;
set(handles.popupmenu12,'String',siulomi_kanalu_padeciu_failai);

parinktis_irasyti(hObject, eventdata, handles, 'numatytas','');
try 
    drb_parinktys(hObject, eventdata, handles, 'ikelti', mfilename, g(1).preset); 
catch err; 
    popupmenu12_Callback(hObject, eventdata, handles);
    susildyk(hObject, eventdata, handles);
end;

try set(handles.text_atlikta_darbu,'String',num2str(g(1).counter)); catch err; end;
set(handles.checkbox_uzverti_pabaigus,'UserData',0);

tic;

% Choose default command line output for pop_nuoseklus_apdorojimas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_nuoseklus_apdorojimas wait for user response (see UIRESUME)
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
f = warndlg(sprintf(lokaliz('Can we go to next job?')), lokaliz('Attention!'));
disp(lokaliz('Do you realy reviewed data? We will go to next job.'));
drawnow     % Necessary to print the message
waitfor(f);
disp(lokaliz('Einama toliau...'));




% --- Outputs from this function are returned to the command line.
function varargout = pop_nuoseklus_apdorojimas_OutputFcn(hObject, eventdata, handles)
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
FAILAI={};
%FAILAI(1).name='(tuščia)';
% if get(handles.radiobutton_cnt,'Value')==1;
%     FAILAI=dir('*.cnt');
% elseif get(handles.radiobutton_set,'Value')==1;
%     FAILAI=dir('*.set');
% elseif get(handles.radiobutton_cnt_set,'Value')==1;
%     FAILAI=[dir('*.cnt') ; dir('*.set')];
% end;
Kelias_dabar=pwd;
cd(get(handles.edit1,'String'));
%cd(Tikras_Kelias(get(handles.edit1,'String')));
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
            Pranesk_apie_klaida(err, lokaliz('Selection of files to process'), '')
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
set(handles.listbox1,'String',FAILAI);
cd(Kelias_dabar);
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
set(handles.edit3,'Enable','off');
set(handles.text_atlikta_darbu,'Enable','off');
set(handles.pushbutton1,'Enable','off');
%set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton3,'Enable','off');
set(handles.pushbutton4,'Enable','off');
set(handles.pushbutton_apdorotini_kanalai,'Enable','off');
set(handles.edit_failu_filtras1,'Enable','off');
set(handles.edit_failu_filtras2,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.pushbutton_v1,'Enable','off');
set(handles.pushbutton_v2,'Enable','off');
% set(handles.radiobutton_cnt,'Enable','off');
% set(handles.radiobutton_set,'Enable','off');
% set(handles.radiobutton_cnt_set,'Enable','off');
set(handles.radiobutton6,'Enable','off');
set(handles.radiobutton7,'Enable','off');
%if get(handles.radiobutton6,'Value') == 1;
set(handles.checkbox_rf,'Enable','off');
set(handles.checkbox_filtr1,'Enable','off');
set(handles.checkbox_filtr2,'Enable','off');
set(handles.checkbox_filtr_tinklo,'Enable','off');
set(handles.checkbox_kanalu_padetis,'Enable','off');
set(handles.checkbox_atrink_kanalus1,'Enable','off');
set(handles.checkbox_atmesk_atkarpas_amp,'Enable','off');
set(handles.checkbox_atmesk_atkarpas_dzn,'Enable','off');
set(handles.checkbox_atmesk_kan_auto,'Enable','off');
set(handles.checkbox_perziureti,'Enable','off');
set(handles.checkbox_atmesk_iki2s,'Enable','off');
set(handles.checkbox_vienoda_trukme,'Enable','off');
set(handles.checkbox_ICA,'Enable','off');
set(handles.checkbox_MARA,'Enable','off');
set(handles.checkbox_atrink_kanalus2,'Enable','off');
set(handles.checkbox_ASR,'Enable','off');
set(handles.checkbox_perziureti_ICA,'Enable','off');
set(handles.checkbox_epoch,'Enable','off');
%set(handles.checkbox_pabaigus_i_apdorotu_aplanka, 'Enable','off');

%end;

checkbox_rf_Callback(hObject, eventdata, handles);
checkbox_filtr1_Callback(hObject, eventdata, handles);
checkbox_filtr2_Callback(hObject, eventdata, handles);
checkbox_filtr_tinklo_Callback(hObject, eventdata, handles);
checkbox_kanalu_padetis_Callback(hObject, eventdata, handles);
checkbox_atrink_kanalus1_Callback(hObject, eventdata, handles);
checkbox_atmesk_atkarpas_amp_Callback(hObject, eventdata, handles);
checkbox_atmesk_atkarpas_dzn_Callback(hObject, eventdata, handles);
checkbox_atmesk_kan_auto_Callback(hObject, eventdata, handles);
checkbox_perziureti_Callback(hObject, eventdata, handles);
checkbox_MARA_Callback(hObject, eventdata, handles);
checkbox_ICA_Callback(hObject, eventdata, handles);
checkbox_atmesk_iki2s_Callback(hObject, eventdata, handles);
checkbox_vienoda_trukme_Callback(hObject, eventdata, handles);
checkbox_atrink_kanalus2_Callback(hObject, eventdata, handles);
checkbox_ASR_Callback(hObject, eventdata, handles);
checkbox_perziureti_ICA_Callback(hObject, eventdata, handles);
checkbox_epoch_Callback(hObject, eventdata, handles);

set(handles.checkbox_baigti_anksciau,'Value',0);
set(handles.checkbox_baigti_anksciau,'Visible','on');

set(handles.text_darbas,'String',' ');

% Vel leisk ka nors daryti
function susildyk(hObject, eventdata, handles)

set(handles.pushbutton1,'Value',1);
set(handles.listbox1,'Enable','on');
set(handles.edit1,'Enable','on');
set(handles.edit2,'Enable','on');
set(handles.edit3,'Enable','on');
set(handles.text_atlikta_darbu,'Enable','on');

set(handles.pushbutton2,'Enable','on');
set(handles.pushbutton3,'Enable','on');
set(handles.pushbutton4,'Enable','on');
set(handles.edit_failu_filtras1,'Enable','on');
set(handles.edit_failu_filtras2,'Enable','on');
set(handles.pushbutton6,'Enable','on');
set(handles.pushbutton_apdorotini_kanalai,'Enable','on');
set(handles.pushbutton_v1,'Enable','on');
set(handles.pushbutton_v2,'Enable','on');
% set(handles.radiobutton_cnt,'Enable','on');
% set(handles.radiobutton_set,'Enable','on');
% set(handles.radiobutton_cnt_set,'Enable','on');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','on');
set(handles.checkbox_rf,'Enable','on');
set(handles.checkbox_filtr1,'Enable','on');
set(handles.checkbox_filtr2,'Enable','on');
%'Cleanline'
set(handles.checkbox_filtr_tinklo,'Enable','on');
if exist('pop_cleanline.m','file') == 2;
    set(handles.checkbox_filtr_tinklo,'TooltipString', '');
else
    set(handles.checkbox_filtr_tinklo,'TooltipString', [ lokaliz('Please install plugin') ' CleanLine' ] );
    %set(handles.checkbox_filtr_tinklo,'TooltipString', 'Reikia įdiegti Cleanline paketą iš http://www.nitrc.org/projects/cleanline/ . Kažkodėl bent šiuo metu (2014 m. liepa) neveiks šis priedas įdiegtas per pačio eeglab meniu' ) ;
end;
set(handles.checkbox_kanalu_padetis,'Enable','on');
%set(handles.checkbox_atrink_kanalus1__,'TooltipString','Palikti failus, kuriuose yra visi nurodyti kanalai');
set(handles.checkbox_atrink_kanalus1,'Enable','on');
set(handles.checkbox_atmesk_atkarpas_dzn,'Enable','on');
set(handles.checkbox_atmesk_atkarpas_amp,'Enable','on');
set(handles.checkbox_atmesk_kan_auto,'Enable','on');
set(handles.checkbox_perziureti,'Enable','on');
set(handles.checkbox_atmesk_iki2s,'Enable','on');
set(handles.checkbox_vienoda_trukme,'Enable','on');
set(handles.checkbox_ICA,'Enable','on');
set(handles.checkbox_MARA,'Enable','on');
if exist('MARA.m','file') == 2;
    set(handles.checkbox_MARA,'TooltipString', '' ) ;
else
    set(handles.checkbox_MARA,'TooltipString', [ lokaliz('Please install plugin') ' MARA' ] ) ;
end;
set(handles.checkbox_atrink_kanalus2,'Enable','on');
set(handles.checkbox_ASR,'Enable','on');
% if exist('clean_rawdata.m','file') == 2
%     set(handles.checkbox_ASR,'TooltipString','' ) ;
% else
    set(handles.checkbox_ASR,'TooltipString', [ lokaliz('Please install plugin') ' ASR (clean_rawdata) >= 0.3' ] ) ;
%end ;
set(handles.checkbox_perziureti_ICA,'Enable','on');
set(handles.checkbox_epoch,'Enable','on');

checkbox_rf_Callback(hObject, eventdata, handles);
checkbox_filtr1_Callback(hObject, eventdata, handles);
checkbox_filtr2_Callback(hObject, eventdata, handles);
checkbox_filtr_tinklo_Callback(hObject, eventdata, handles);
checkbox_kanalu_padetis_Callback(hObject, eventdata, handles);
checkbox_atrink_kanalus1_Callback(hObject, eventdata, handles);
checkbox_atmesk_atkarpas_amp_Callback(hObject, eventdata, handles);
checkbox_atmesk_atkarpas_dzn_Callback(hObject, eventdata, handles);
checkbox_atmesk_kan_auto_Callback(hObject, eventdata, handles);
checkbox_perziureti_Callback(hObject, eventdata, handles);
checkbox_MARA_Callback(hObject, eventdata, handles);
checkbox_ICA_Callback(hObject, eventdata, handles);
checkbox_atmesk_iki2s_Callback(hObject, eventdata, handles);
checkbox_vienoda_trukme_Callback(hObject, eventdata, handles);
checkbox_atrink_kanalus2_Callback(hObject, eventdata, handles);
checkbox_ASR_Callback(hObject, eventdata, handles);
checkbox_perziureti_ICA_Callback(hObject, eventdata, handles);
checkbox_epoch_Callback(hObject, eventdata, handles);
checkbox_pabaigus_i_apdorotu_aplanka_Callback(hObject, eventdata, handles);
uipanel15_SelectionChangeFcn(hObject, eventdata, handles);

edit3_Callback(hObject, eventdata, handles);
edit19_Callback(hObject, eventdata, handles);
edit21_Callback(hObject, eventdata, handles);
edit50_Callback(hObject, eventdata, handles);

%Vykdymo mygtukas
Ar_galima_vykdyti(hObject, eventdata, handles);

set(handles.checkbox_baigti_anksciau,'Visible','off');

%Vidinis atliktų darbų skaitliukas
% set(handles.text_atlikta_darbu, 'String', num2str(max_pakatalogio_nr(...
%    get(handles.edit2,'String'))));

%set(handles.uipanel6,'Title', ['Duomenų apdorojimo funkcijos']);
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
    %disp('');
    drawnow; return;
end;
if get(handles.listbox1,'Value') == 0;
    %disp('');
    drawnow; return;
end;
Pasirinkti_failu_indeksai=(get(handles.listbox1,'Value'));
if isempty(Pasirinkti_failu_indeksai);
    %disp('');
    drawnow; return;
end;
if and(get(handles.checkbox_atrink_kanalus1,'Value') == 1 , ...
        isempty(get(handles.text8,'TooltipString')));
    %disp('');
    drawnow; return;
end;
if and(get(handles.checkbox_atrink_kanalus2,'Value') == 1 , ...
        isempty(get(handles.pushbutton7,'UserData')));
    %disp('');
    drawnow; return;
end;
if get(handles.edit1,'BackgroundColor') == [1 1 0];
    %disp('');
    drawnow; return;
end;
if get(handles.edit2,'BackgroundColor') == [1 1 0];
    %disp('');
    drawnow; return;
end;
if and(get(handles.checkbox_filtr1,'Value') == 1, ...
   get(handles.edit3,'BackgroundColor') == [1 1 0]);
    %disp('');
    drawnow; return;
end;
if and(get(handles.checkbox_filtr2,'Value') == 1, ...
   get(handles.edit21,'BackgroundColor') == [1 1 0]);
    %disp('');
    drawnow; return;
end;
if and(get(handles.checkbox_epoch,'Value') == 1, ...
   get(handles.edit_epoch_iv,'BackgroundColor') == [1 1 0]);
    %disp('');
    drawnow; return;
end;
if get(handles.edit_failu_filtras1,'BackgroundColor') == [1 1 0];
    %disp('');
    drawnow; return;
end;
if get(handles.edit_failu_filtras2,'BackgroundColor') == [1 1 0];
    %disp('');
    drawnow; return;
end;
% Ar pasirinkti darbai
chb_pav={'rf' 'filtr1' 'filtr2' 'filtr_tinklo' 'kanalu_padetis' 'atrink_kanalus1' ...
    'atmesk_atkarpas_amp' 'atmesk_atkarpas_dzn' 'atmesk_kan_auto' 'perziureti' ...
    'MARA' 'ICA' 'atmesk_iki2s' 'vienoda_trukme' 'atrink_kanalus2' 'ASR' 'perziureti_ICA' 'epoch'};
chb_c=0;
for i=1:length(chb_pav);
    chb_c=chb_c + get(eval(['handles.checkbox_' chb_pav{i}]),'Value');
end;
if chb_c == 0;
    %disp('Pasirinkite darbą!');
    drawnow; return;
end;

% Vykdyti galima
set(handles.pushbutton1,'Enable','on');
drawnow;


function Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N)
disp(' ');
NaujaAntraste=[lokaliz('Data processing:') ' ' num2str(DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' ' lokaliz('job_short') ', ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' ' lokaliz('data_file_very_short')];
disp(NaujaAntraste);
disp(Darbo_apibudinimas);
set(handles.text_darbas,'String',Darbo_apibudinimas);
set(handles.uipanel6,'Title', NaujaAntraste);
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
disp(' ');
disp('===================================');
disp('      NUOSEKLUS      DARBAS        ');
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

% Nuostatų įsiminimas, jei yra Darbeliai_config.mat
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));

    % Pasirinktų aplankų įsiminimas
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
    % Įrašymas
    save(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'),'Darbeliai');
catch err;
    Pranesk_apie_klaida(err, 'pop_nuoseklus_apdorojimas.m', '-', 0);
end;

% Užduočių parinkčių įsiminimas
parinktis_irasyti(hObject, eventdata, handles, 'paskutinis','');
%Neleisti spausti Nuostatų meniu!
for m_id={'m_Nuostatos' 'm_Darbeliai' 'm_Veiksmai'};
    set(findall(handles.figure1,'Type','uimenu','Tag',m_id{1}),'Enable','off');
end;
drawnow;

STUDY = []; CURRENTSTUDY = 0; %ALLEEG = []; EEG=[]; CURRENTSET=[];
%[ALLEEG EEG CURRENTSET ALLCOM] = eeglab ;
%eeglab redraw ;
%[ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);
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

% Jei pasirinkta atlikti MARA - tai rezultatų apibendrinimą rašyti į failiuką
if get(handles.checkbox_MARA,'Value') == 1 ;
    fid = fopen(['MARA_' datestr(now, 'yyyy-mm-dd_HHMMSS') '.txt'], 'w');
    fprintf(fid, [lokaliz('File') '	' lokaliz('MARA would reject ICA') '\r\n\r\n']);
end;

DarboNr=0;
PaskutinioIssaugotoDarboNr=0;
Apdoroti_visi_tiriamieji=0;
TIK_PERZIURA=getappdata(handles.figure1,'TIK_PERZIURA');
PERZIURA=~isempty(TIK_PERZIURA);
if ~PERZIURA; TIK_PERZIURA=0; end;

for i=1:Pasirinktu_failu_N;
    Rinkmena=Pasirinkti_failu_pavadinimai{i};
    [KELIAS_,Rinkmena_]=rinkmenos_tikslinimas(KELIAS,Rinkmena);
    NaujaRinkmena=Rinkmena_;
    fprintf('\n === %s %d/%d (%.2f%%) ===\n%s\n', lokaliz('Opened file'), i, Pasirinktu_failu_N, i/Pasirinktu_failu_N*100, fullfile(KELIAS_, Rinkmena_));
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    SaugomoNr=1+str2num(get(handles.text_atlikta_darbu,'String'));
    DarboNr=0;
    DarboPorcijaAtlikta=0;
    PaskutinioIssaugotoDarboNr=0;
    PaskRinkmIssaugKelias=KELIAS;

    %guidata(hObject, handles);
        Darbo_eigos_busena(handles, lokaliz('Loading data...'), DarboNr, i, Pasirinktu_failu_N);

    % Ikelti
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);
    EEG = eeg_ikelk(KELIAS_,Rinkmena_);

    if ~isempty(EEG);

        EEG = eeg_checkset( EEG );
        if PERZIURA; EEG0=EEG; end;

        % Kanalų padėtis
        Darbo_apibudinimas=lokaliz('Setting channel positions...');
        if get(handles.checkbox_kanalu_padetis,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try
                    kanalu_failai=get(handles.popupmenu12,'String');
                    kanalu_failas=kanalu_failai{get(handles.popupmenu12,'Value')};

                    % Pašalinti taškus iš kanalų pavadinimų
                    %esami_kanalai={EEG.chanlocs.labels};
                    %for knl=1:length(esami_kanalai);
                    %   EEG.chanlocs(knl).labels=strrep(esami_kanalai{knl},'.','');
                    %end;

                    EEG = pop_chanedit(EEG, 'lookup', kanalu_failas);
                    EEG = eegh( [ 'EEG = pop_chanedit(EEG, ''lookup'', ''' kanalu_failas ''');' ] , EEG);
                    EEG = eeg_checkset( EEG );
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Set channel positions_noun'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_kanalu_padetis,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_kanalu_padetis_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_kanalu_padetis_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_kanalu_padetis,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Reference
        Darbo_apibudinimas=lokaliz('Re-referencing...');
        if get(handles.checkbox_rf,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try
                    if get(handles.popupmenu3,'Value') == 1 ;
                        [EEG, LASTCOM] = pop_reref( EEG, []);
                    elseif get(handles.popupmenu3,'Value') == 2
                        reref_chans=[find(ismember({EEG.chanlocs.labels},'M1')) find(ismember({EEG.chanlocs.labels},'M2'))];
                        if isempty(reref_chans);
                           error(lokaliz('Reference channels not found.'));
                        end;
                        [EEG, LASTCOM] = pop_reref( EEG, reref_chans);
                    elseif get(handles.popupmenu3,'Value') == 3
                        reref_chans=[find(ismember({EEG.chanlocs.labels},'Cz')) ];
                        if isempty(reref_chans);
                           error(lokaliz('Reference channels not found.'));
                        end;
                        [EEG, LASTCOM] = pop_reref( EEG, reref_chans);
                    else
                        reref_chans=[find(ismember({EEG.chanlocs.labels},get(handles.pushbutton18,'UserData'))) ];
                        if isempty(reref_chans);
                           error(lokaliz('Reference channels not found.'));
                        end;
                        [EEG, LASTCOM] = pop_reref( EEG, reref_chans);
                    end;
                    EEG = eegh(LASTCOM, EEG);
                    EEG = eeg_checkset( EEG );
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Re-referencing'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_rf,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_rf_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_rf_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_rf,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Kanalų atrinkimas 1
        Darbo_apibudinimas=lokaliz('Selecting channels...');
        if get(handles.checkbox_atrink_kanalus1,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                EEG = eeg_checkset( EEG );
                %VISI_KANALAI_66={'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'M1' 'T7' 'C3' 'Cz' 'C4' 'T8' 'M2' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'EOG' 'EOGh';};
                %Pasirinkti_kanalai=textscan(get(handles.text8,'TooltipString'),'%s','delimiter',' ');
                %Reikalingi_kanalai=Pasirinkti_kanalai{1};
                Reikalingi_kanalai=get(handles.pushbutton9,'UserData');

                try
                    Reikalingi_kanalai_yra=Reikalingi_kanalai(find(ismember(Reikalingi_kanalai,{EEG.chanlocs.labels})));
                    if get(handles.checkbox_atrink_kanalus1__,'Value') == 0 ;
                        [EEG, LASTCOM] = pop_select( EEG,'channel',Reikalingi_kanalai_yra);
                    elseif length(Reikalingi_kanalai_yra) == length(Reikalingi_kanalai);
                        [EEG, LASTCOM] = pop_select( EEG,'channel',Reikalingi_kanalai_yra);
                    else
                        DarboPorcijaAtlikta=1;
                        PaskRinkmIssaugKelias='';
                        EEG.nbchan=0;
                    end ;
                    EEG = eegh(LASTCOM, EEG);
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Channel selection'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                disp(NaujaRinkmena);
                Priesaga=(get(handles.edit_atrink_kanalus1,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_atrink_kanalus1_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                disp(NaujaRinkmena);
                if get(handles.checkbox_atrink_kanalus1_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_atrink_kanalus1,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Filtruoti dažnius
        Darbo_apibudinimas=lokaliz('First filtering...');
        if get(handles.checkbox_filtr1,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                Kanalai=get(handles.pushbutton_apdorotini_kanalai,'UserData');
                if isempty(Kanalai);
                    KanaluNr=[1:EEG.nbchan];
                else
                    %Kanalai=intersect(Kanalai,{EEG.chanlocs.labels});
                    KanaluNr=find(ismember({EEG.chanlocs.labels},Kanalai));
                end;

                try
                    EEG = eeg_checkset( EEG );
                    NeitrauktiKanNr=setdiff([1:EEG.nbchan],KanaluNr);
                    if ~isempty(NeitrauktiKanNr);
                        EEG2 = eegh('EEG2 = EEG;', EEG);
                        [EEG, LASTCOM] = pop_select( EEG,'channel',KanaluNr);
                        EEG2 = eegh(LASTCOM, EEG2);
                    end;
                    daznis_filtravimui=str2num(get(handles.edit3,'String'));
                    disp([ 'Filtruokim <' num2str(daznis_filtravimui) '>' ] );
                    if     get(handles.popupmenu9,'Value') == 1 ;
                        [EEG, LASTCOM] = pop_eegfiltnew(EEG, [], daznis_filtravimui, [], 1, [], 0);
                    elseif get(handles.popupmenu9,'Value') == 2 ;
                        [EEG, LASTCOM] = pop_eegfiltnew(EEG, [], daznis_filtravimui, [], 0, [], 0);
                    elseif get(handles.popupmenu9,'Value') == 3;
                        [EEG, LASTCOM] = pop_eegfiltnew(EEG, daznis_filtravimui(1), daznis_filtravimui(2), [], 0, [], 0);
                    elseif get(handles.popupmenu9,'Value') == 4;
                        [EEG, LASTCOM] = pop_eegfiltnew(EEG, daznis_filtravimui(1), daznis_filtravimui(2), [], 1, [], 0);
                    end;
                    if ~isempty(NeitrauktiKanNr);
                        EEG2 = eegh(LASTCOM, EEG2);
                        if length(size(EEG2.data)) == 2;
                            EEG2.data(KanaluNr,:)=EEG.data;
                            EEG2 = eegh(['EEG2.data([' num2str(KanaluNr) '],:)=EEG.data;' ], EEG2);
                        else
                            EEG2.data(KanaluNr,:,:)=EEG.data;
                            EEG2 = eegh(['EEG2.data([' num2str(KanaluNr) '],:,:)=EEG.data;' ], EEG2);
                        end;
                        EEG = EEG2 ;
                        EEG = eegh('EEG = EEG2;', EEG);
                    else
                        EEG = eegh(LASTCOM, EEG);
                    end;
                    EEG = eeg_checkset( EEG );
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('First filtering'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_filtr1,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_filtr1_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_filtr1_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_filtr1,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Filtruoti tinklo triukšmą
        Darbo_apibudinimas=lokaliz('Filtering power-line noise...');
        if get(handles.checkbox_filtr_tinklo,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);


                Kanalai=get(handles.pushbutton_apdorotini_kanalai,'UserData');
                if isempty(Kanalai);
                    KanaluNr=[1:EEG.nbchan];
                else
                    %Kanalai=intersect(Kanalai,{EEG.chanlocs.labels});
                    KanaluNr=find(ismember({EEG.chanlocs.labels},Kanalai));
                end;

                try
                    line_freq=str2num(get(handles.edit50,'String'));
                    line_freq_rem=[line_freq (2:round(EEG.srate/line_freq/2))*line_freq ];
                    [EEG, LASTCOM] = pop_cleanline(EEG, 'Bandwidth',2,'ChanCompIndices',KanaluNr,'SignalType','Channels','ComputeSpectralPower',false,'LineFrequencies',line_freq_rem ,'NormalizeSpectrum',false,'LineAlpha',0.01,'PaddingFactor',2,'PlotFigures',false,'ScanForLines',true,'SmoothingFactor',100,'VerboseOutput',1);
                    EEG = eegh(LASTCOM, EEG);
                    EEG = eeg_checkset( EEG );
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Filtering power-line noise'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_filtr_tinklo,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_filtr_tinklo_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_filtr_tinklo_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_filtr_tinklo,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;


        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;


        % Atmesti triukšmingas atkarpėles (pagal amplitudę)
        Darbo_apibudinimas=lokaliz('Rejecting noisy intervals...');
        if get(handles.checkbox_atmesk_atkarpas_amp,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try

                    Kanalai=get(handles.pushbutton_apdorotini_kanalai,'UserData');
                    if isempty(Kanalai);
                        KanaluNr=[1:EEG.nbchan];
                    else
                        %Kanalai=intersect(Kanalai,{EEG.chanlocs.labels});
                        KanaluNr=find(ismember({EEG.chanlocs.labels},Kanalai));
                    end;
                    ampl=str2num(get(handles.edit58,'String'));
                    langas=str2num(get(handles.edit57,'String'));
                    EEG = atmest_pg_amplit(EEG,ampl,langas,KanaluNr);
                    EEG = eegh(['EEG = atmest_pg_amplit(EEG, [' num2str(ampl) '], [' num2str(langas) '], [' num2str(KanaluNr) ']);' ] , EEG);
                    EEG = eeg_checkset( EEG );
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Reject noisy time intervals'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_atmesk_atkarpas_amp,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_atmesk_atkarpas_amp_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_atmesk_atkarpas_amp_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_atmesk_atkarpas_amp,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        % Atmesti triukšmingas atkarpėles (pagal dažnių spektrą)
        Darbo_apibudinimas=lokaliz('Rejecting noisy intervals...');
        if get(handles.checkbox_atmesk_atkarpas_dzn,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try

                    Kanalai=get(handles.pushbutton_apdorotini_kanalai,'UserData');
                    if isempty(Kanalai);
                        KanaluNr=[1:EEG.nbchan];
                    else
                        %Kanalai=intersect(Kanalai,{EEG.chanlocs.labels});
                        KanaluNr=find(ismember({EEG.chanlocs.labels},Kanalai));
                    end;

                    [EEG, ~, ~, LASTCOM] = pop_rejcont(EEG, 'elecrange',KanaluNr,...
                        'freqlimit',str2num(get(handles.edit44,'String')) ,...
                        'threshold',str2num(get(handles.edit43,'String')),...
                        'epochlength',0.5,'contiguous',4,'addlength',1,'taper','hamming');
                    EEG = eegh(LASTCOM, EEG);
                    EEG = eeg_checkset( EEG );
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Reject noisy time intervals'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_atmesk_atkarpas_dzn,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_atmesk_atkarpas_dzn_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_atmesk_atkarpas_dzn_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_atmesk_atkarpas_dzn,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;


        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Atmesti triukšmingus kanalus (auto)
        Darbo_apibudinimas=lokaliz('Rejecting noisy channels (auto)...');
        if get(handles.checkbox_atmesk_kan_auto,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try
                    if get(handles.checkbox41,'Value');
                        atmesk_kan_auto_normalizav='on';
                    else
                        atmesk_kan_auto_normalizav='off';
                    end;


                    Kanalai=get(handles.pushbutton_apdorotini_kanalai,'UserData');
                    if isempty(Kanalai);
                        KanaluNr=[1:EEG.nbchan];
                        %find(~ismember({EEG.chanlocs.labels},{'EOG' 'EOGh'})) ;
                    else
                        %Kanalai=intersect(Kanalai,{EEG.chanlocs.labels});
                        KanaluNr=find(ismember({EEG.chanlocs.labels},Kanalai));
                    end;


                    %
                    % EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan] ,'threshold',3.5,'norm','on','measure','spec');
                    [EEG, ~, ~, LASTCOM] = pop_rejchan(EEG, ...
                        'elec',KanaluNr, ...
                        'threshold',str2num(get(handles.edit_atmesk_kan_auto_slenkstis,'String')), ...
                        'norm',     atmesk_kan_auto_normalizav, ...
                        'measure','spec', ...
                        'freqrange', str2num(get(handles.edit40,'String')));
                    EEG = eegh(LASTCOM, EEG);
                    EEG = eeg_checkset( EEG );
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Reject noisy channels (auto)'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_atmesk_kan_auto,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_atmesk_kan_auto_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_atmesk_kan_auto_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_atmesk_kan_auto,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % ASR
        Darbo_apibudinimas=lokaliz('Rejecting artefacts with ASR..');
        if get(handles.checkbox_ASR,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try

                    %if PLUGINLIST(find(ismember({PLUGINLIST.plugin},'clean_rawdata'))).version >= 0.3 ;
                    % tikrinta su clean_rawdata0.3 versija:
                    EEG = clean_rawdata(EEG, 5, [0.25 0.75], 0.8, 4, 5, 0.5);
                    EEG = eegh('EEG = clean_rawdata(EEG, 5, [0.25 0.75], 0.8, 4, 5, 0.5);', EEG);
                    %else
                    % clean_rawdata0.2 versijai:
                    %    EEG = clean_rawdata(EEG, 5, [0.25 0.75], 0.45, 5, 0.5);
                    %end ;

                    EEG = eeg_checkset( EEG );

                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Reject artefacts with ASR'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_ASR,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_ASR_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_ASR_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_ASR,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;


        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Peržiūrėti įrašą
        Darbo_apibudinimas=lokaliz('You are reviewind data...');
        if get(handles.checkbox_perziureti,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try
                    EEG = eeg_checkset( EEG );                    
                    try eeglab redraw;
                    catch err; Pranesk_apie_klaida(err,'','',0);
                    end;
                    pop_eegplot( EEG, 1, 1, 1);
                    EEG = eegh('pop_eegplot( EEG, 1, 1, 1);', EEG);

                    %eegplot( EEG.data, 'srate', EEG.srate, 'title', 'Scroll channel activities -- eegplot()', ...
                    %  'limits', [EEG.xmin EEG.xmax]*1000 , 'command', command, eegplotoptions{:});

                    %f = warndlg(sprintf('Jums atvėrėme langą, kuriame siūlome peržiūrėti artefaktus. Nepamirškite patvirtinimui nuspausti Reject mygtuko. Klausiant kur saugoi failą, tiesiog spauskite OK. '), 'Dėmesio!');
                    %disp('Dėmesio! Kai nuspausite mygtuką, užsivers langas, kuriame siūlome peržiūrėti artefaktus.');
                    %drawnow     % Necessary to print the message
                    %waitfor(f);

                    %eeglab redraw;


                    if get(handles.checkbox_perziureti_demesio,'Value') == 0 ;

                        while ~isempty([...
                                findobj('-regexp','name','Reject components by map.*')  ; ...
                                findobj('-regexp','name','pop_prop().*') ; ...
                                findobj('-regexp','name','Scroll channel activities.*') ; ...
                                findobj('-regexp','name','Scroll component activities.*') ; ...
                                findobj('-regexp','name','Confirmation.*') ; ...
                                findobj('-regexp','name','Black = channel before rejection.*') ; ] ) ;

                            if 1 == 0

                                waitfor([...
                                    findobj('-regexp','name','Reject components by map.*')  ; ...
                                    findobj('-regexp','name','pop_prop().*') ; ...
                                    findobj('-regexp','name','Scroll channel activities.*') ; ...
                                    findobj('-regexp','name','Scroll component activities.*') ; ...
                                    findobj('-regexp','name','Confirmation.*') ; ...
                                    findobj('-regexp','name','Black = channel before rejection.*') ; ] ) ;

                                pause(1) ;

                            end ;

                            uiwait(gcf,3);


                        end ;

                    else

                        Palauk();

                        try
                            close([...
                                findobj('-regexp','name','Reject components by map.*')  ; ...
                                findobj('-regexp','name','pop_prop().*') ; ...
                                findobj('-regexp','name','Scroll channel activities.*') ; ...
                                findobj('-regexp','name','Scroll component activities.*') ; ...
                                findobj('-regexp','name','Confirmation.*') ; ...
                                findobj('-regexp','name','Black = channel before rejection.*') ; ] );
                        catch err;
                        end;


                    end;

                    %[ALLEEG EEG CURRENTSET] = eeg_store([], EEG);
                    
                    try eeglab redraw;
                    catch err; Pranesk_apie_klaida(err,'','',0);
                    end;

                    %Palauk();

                    EEG = eeg_checkset( EEG );

                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Data review'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_perziureti,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_perziureti_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_perziureti_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_perziureti,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % ICA
        Darbo_apibudinimas=lokaliz('ICA...');
        if get(handles.checkbox_ICA,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try

                    Kanalai=get(handles.pushbutton_apdorotini_kanalai,'UserData');
                    if isempty(Kanalai);
                        KanaluNr=[1:EEG.nbchan];
                    else
                        %Kanalai=intersect(Kanalai,{EEG.chanlocs.labels});
                        KanaluNr=find(ismember({EEG.chanlocs.labels},Kanalai));
                    end;

                    % komponenčių kiekis
                    switch get(handles.popupmenu4,'Value')
                        case 1
                            ICA_N=length(KanaluNr) ; % (EEG.nbchan);
                        case 2
                            ICA_N=length(KanaluNr) - 1 ;
                        case 3
                            ICA_N=str2num(get(handles.edit59,'String')) ;
                        otherwise
                            error(lokaliz('Internal error'));
                    end;

                    [EEG, LASTCOM] = pop_runica(EEG, 'chanind', KanaluNr, 'extended',1, 'pca', ICA_N,  'interupt','on');
                    EEG = eegh(LASTCOM, EEG);
                    EEG = eeg_checkset( EEG );

                catch err;
                    Pranesk_apie_klaida(err, lokaliz('ICA'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_ICA,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_ICA_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_ICA_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_ICA,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;


        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % MARA
        Darbo_apibudinimas=lokaliz('MARA...');
        if get(handles.checkbox_MARA,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                EEG = eeg_checkset( EEG );
                try

                    switch get(handles.popupmenu5,'Value')
                        case 1
                            [ALLEEG,EEG,CURRENTSET]= processMARA( ALLEEG ,EEG ,CURRENTSET,[0,0,0,0,0] );
                            artcomps=find(EEG.reject.gcompreject);
                            EEG = eegh('[ALLEEG,EEG,CURRENTSET]= processMARA( ALLEEG ,EEG ,CURRENTSET,[0,0,0,0,0] );', EEG);
                        case 3
                            [ALLEEG,EEG,CURRENTSET]= processMARA( ALLEEG ,EEG ,CURRENTSET,[0,0,0,0,0] );
                            artcomps=find(EEG.reject.gcompreject);
                            EEG = eegh('[ALLEEG,EEG,CURRENTSET]= processMARA( ALLEEG ,EEG ,CURRENTSET,[0,0,0,0,0] );', EEG);
                            pop_selectcomps(EEG, [1:length(EEG.reject.gcompreject)]);
                            Palauk();
                        case 4
                            [ALLEEG,EEG,CURRENTSET]= processMARA( ALLEEG ,EEG ,CURRENTSET,[0,0,1,0,0] );
                            artcomps=find(EEG.reject.gcompreject);
                            EEG = eegh('[ALLEEG,EEG,CURRENTSET]= processMARA( ALLEEG ,EEG ,CURRENTSET,[0,0,1,0,0] );', EEG);
                            Palauk();
                        case 5
                            [ALLEEG,EEG,CURRENTSET]= processMARA( ALLEEG ,EEG ,CURRENTSET,[0,0,1,1,0] );
                            artcomps=find(EEG.reject.gcompreject);
                            EEG = eegh('[ALLEEG,EEG,CURRENTSET]= processMARA( ALLEEG ,EEG ,CURRENTSET,[0,0,1,1,0] );', EEG);
                            Palauk();
                        otherwise
                            [artcomps, info] = MARA(EEG);
                            EEG = eegh('[artcomps, info] = MARA (EEG);', EEG);
                            EEG = eeg_checkset( EEG );
                            EEG = pop_subcomp( EEG, artcomps, 0);
                            EEG = eegh('EEG = pop_subcomp( EEG, artcomps, 0);', EEG);
                    end;

                    EEG = eeg_checkset( EEG );

                    %Aprašyk
                    fprintf(fid, [strrep(strrep(NaujaRinkmena,'.cnt',''),'.set','') '	' num2str(artcomps) '\r\n']);
                    disp(strrep(strrep(NaujaRinkmena,'.cnt',''),'.set','')); disp(artcomps);

                catch err;
                    Pranesk_apie_klaida(err, lokaliz('MARA'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_MARA,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_MARA_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_MARA_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_MARA,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;


        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Peržiūrėti ICA
        Darbo_apibudinimas=lokaliz('You review ICA...');
        if get(handles.checkbox_perziureti_ICA,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);
                
                try

                    EEG = vykdymas_perziureti_ICA(EEG, EEG, ...
                        get(handles.popupmenu7,'Value'), ...
                        get(handles.popupmenu8,'Value'), ...
                        get(handles.checkbox_perziureti_ICA_demesio,'Value'), ...
                        NaujaRinkmena);

                catch err;
                    Pranesk_apie_klaida(err, lokaliz('ICA review'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_perziureti_ICA,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_perziureti_ICA_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_perziureti_ICA_,'Value') == 1 && ~TIK_PERZIURA && ~isempty(EEG) ;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_perziureti_ICA,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;


        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Atmesti atkarpėles iki 2 s
        Darbo_apibudinimas=lokaliz('Rejecting very short intervals between boundaries...');
        if get(handles.checkbox_atmesk_iki2s,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try

                    g={};
                    g.Atkarpu_padetis_N=find(strcmp({EEG.event(:).type},'boundary' )) ;
                    % visas iraso ilgis, sekundemis
                    g.Iraso_trukme= EEG.times(end)/1000 ;
                    if isempty(g.Atkarpu_padetis_N) ;
                        % visas ilgis, sekundemis
                        g.Atkarpu_padetis_s=[0 g.Iraso_trukme] ;
                        g.Atkarpu_trukmes=   g.Iraso_trukme ;
                        g.Atkarpu_trukme_max=g.Iraso_trukme ;
                    else
                        % ribos, sekundėmis
                        g.Atkarpu_padetis_s=[0 EEG.times(round([EEG.event(1,g.Atkarpu_padetis_N).latency])) ./ 1000 EEG.times(end)/1000]  ;
                        % atkarpu ilgiai, sekundemis
                        g.Atkarpu_trukmes=diff(g.Atkarpu_padetis_s);
                        % didziausias ilgis, sekundemis
                        g.Atkarpu_trukme_max=max(g.Atkarpu_trukmes);
                    end ;

                    g.Atkarpu_padetis_pt=[1 round([EEG.event(g.Atkarpu_padetis_N).latency]) EEG.pnts] ;

                    % Rasti atkarpas, kurios trumpesnes nei, pvz, 2 s
                    g.Atkarpu_padetis_N_Trumpu=find(g.Atkarpu_trukmes<str2num(get(handles.edit20,'String')));

                    disp( [ 'Buvo bendra trukmė: ' num2str(EEG.times(end)/1000 ) ]);

                    % atmesti trumpas atkarpas
                    for a=sort(g.Atkarpu_padetis_N_Trumpu,'descend');
                        disp([ num2str(g.Atkarpu_padetis_s(a+1)) ' - ' num2str(g.Atkarpu_padetis_s(a)) ' = ' num2str(g.Atkarpu_padetis_s(a+1) - g.Atkarpu_padetis_s(a) ) ]);
                        [EEG, LASTCOM] = pop_select( EEG,'nopoint',[g.Atkarpu_padetis_pt(a) min(length(EEG.times),g.Atkarpu_padetis_pt(a+1))] );
                        EEG = eegh(LASTCOM, EEG);
                        %EEG = eeg_checkset( EEG ) ;
                        %[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'overwrite','on','gui','off');
                        EEG = eeg_checkset( EEG ) ;
                    end;
                    disp( [ 'Nauja trukmė: ' num2str(EEG.times(end)/1000 )]);

                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Reject very short intervals between boundaries'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_atmesk_iki2s,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_atmesk_iki2s_,'String')) ];
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_atmesk_iki2s_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_atmesk_iki2s,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Suvienodinti trukmę
        Darbo_apibudinimas=lokaliz('Unifying duration...');
        if get(handles.checkbox_vienoda_trukme,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                NORIMA_EEG_TRUKME=str2num(get(handles.edit19,'String'));
                variantas=2;
                g={};
                g.Atkarpu_padetis_N=find(strcmp({EEG.event(:).type},'boundary' )) ;
                % visas iraso ilgis, sekundemis
                g.Iraso_trukme= EEG.times(end)/1000 ;
                if isempty(g.Atkarpu_padetis_N) ;
                    % visas ilgis, sekundemis
                    g.Atkarpu_padetis_s=[0 g.Iraso_trukme] ;
                    g.Atkarpu_trukmes=   g.Iraso_trukme ;
                    g.Atkarpu_trukme_max=g.Iraso_trukme ;
                else
                    % ribos, sekundėmis
                    g.Atkarpu_padetis_s=[0 EEG.times(round([EEG.event(1,g.Atkarpu_padetis_N).latency])) ./ 1000 EEG.times(end)/1000]  ;
                    % atkarpu ilgiai, sekundemis
                    g.Atkarpu_trukmes=diff(g.Atkarpu_padetis_s);
                    % didziausias ilgis, sekundemis
                    g.Atkarpu_trukme_max=max(g.Atkarpu_trukmes);
                end ;


                %g.Atkarpu_padetis_pt=[1 round([EEG.event(g.Atkarpu_padetis_N).latency]) EEG.pnts] ;

                Atmestina_trukme = g.Iraso_trukme - NORIMA_EEG_TRUKME ;

                if Atmestina_trukme >= 0;

                    if variantas == 1 ;
                        % stengtis palikti irasu pradzias
                        g.Karpymui(1,1)=0 ;
                        g.Karpymui(1,2)=NORIMA_EEG_TRUKME ;
                        for y=1;
                            x=1;
                            if ~isempty(g.Atkarpu_trukmes);
                                while and(x < length(g.Atkarpu_trukmes), sum(g.Atkarpu_trukmes(1:x)) < Atmestina_trukme(y) ) ;
                                    g.Karpymui(1,1:2)=g.Karpymui(1,1:2)+g.Atkarpu_trukmes(x) ;
                                    x=x+1;
                                end;
                            end;
                        end;
                    elseif variantas == 2 ;
                        % stengtis palikti irasu pabaigas
                        g.Karpymui(1,1)=Atmestina_trukme ;
                        g.Karpymui(1,2)=g.Iraso_trukme ;
                        for y=1;
                            x=1;
                            n=length(g.Atkarpu_trukmes);
                            if n > 0 ;
                                while and(x < n, sum(g.Atkarpu_trukmes(n-x+1:n)) < Atmestina_trukme(y) ) ;
                                    g.Karpymui(1,1:2)=g.Karpymui(1,1:2)-g.Atkarpu_trukmes(n-x+1) ;
                                    x=x+1;
                                end;
                            end;
                        end;
                    end;

                    disp([NaujaRinkmena ' ' num2str(g.Iraso_trukme) '-' num2str(NORIMA_EEG_TRUKME) '=' num2str(Atmestina_trukme) ]);
                    disp(['Kirpimo vieta prad ' num2str(g.Karpymui(1,1)) ]);
                    disp(['Kirpimo vieta gale ' num2str(g.Karpymui(1,2)) ]);

                    % atmesti
                    [EEG, LASTCOM] = pop_select( EEG,'time',[g.Karpymui(1,1) g.Karpymui(1,2)] );
                    EEG = eegh(LASTCOM, EEG);
                    EEG = eeg_checkset( EEG ) ;
                    %[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'overwrite','on','gui','off');

                    %Tikrinimui
                    disp( [ 'Nauja trukme: ' num2str(EEG.times(end)/1000) ]);
                    disp([g.Atkarpu_trukmes]);
                    g={};
                    g.Atkarpu_padetis_N=find(strcmp({EEG.event(:).type},'boundary' )) ;
                    % visas iraso ilgis, sekundemis
                    g.Iraso_trukme= EEG.times(end)/1000 ;
                    if isempty(g.Atkarpu_padetis_N) ;
                        % visas ilgis, sekundemis
                        g.Atkarpu_padetis_s=[0 g.Iraso_trukme] ;
                        g.Atkarpu_trukmes=   g.Iraso_trukme ;
                        g.Atkarpu_trukme_max=g.Iraso_trukme ;
                    else
                        % ribos, sekundėmis
                        g.Atkarpu_padetis_s=[0 EEG.times(round([EEG.event(1,g.Atkarpu_padetis_N).latency])) ./ 1000 EEG.times(end)/1000]  ;
                        % atkarpu ilgiai, sekundemis
                        g.Atkarpu_trukmes=diff(g.Atkarpu_padetis_s);
                        % didziausias ilgis, sekundemis
                        g.Atkarpu_trukme_max=max(g.Atkarpu_trukmes);
                    end ;
                    disp([g.Atkarpu_trukmes]);
                end;

                if round(EEG.times(end)/1000*EEG.srate) ~= NORIMA_EEG_TRUKME * EEG.srate ;
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                else



                    % Išsaugoti
                    Priesaga=(get(handles.edit_vienoda_trukme,'String')) ;
                    Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_vienoda_trukme_,'String')) ] ;
                    [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                    if get(handles.checkbox_vienoda_trukme_,'Value') == 1 && ~TIK_PERZIURA;
                        eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                        PaskutinioIssaugotoDarboNr=DarboNr;
                        DarboPorcijaAtlikta = 1;
                        SaugomoNr = SaugomoNr +1;
                        PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                    else
                        PaskRinkmIssaugKelias='';
                    end;

                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_vienoda_trukme,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Atrinkti kanalus, interpoliuojant trūkstamus
        Darbo_apibudinimas=lokaliz('Selecting channels, interpolating missing...');
        if get(handles.checkbox_atrink_kanalus2,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                EEG = eeg_checkset( EEG );

                VISI_KANALAI_66={'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'M1' 'T7' 'C3' 'Cz' 'C4' 'T8' 'M2' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'EOG' 'EOGh';};
                disp(get(handles.pushbutton7,'Value'));
                %Reikalingi_kanalai=VISI_KANALAI_66(get(handles.pushbutton7,'UserData'));
                Reikalingi_kanalai=get(handles.pushbutton7,'UserData');

                KANALU_DUOMENYS={
                    'Fp1','',-17.9260000000000,0.514988888888889,80.7840137690914,26.1330144040702,-4.00108454195971,17.9260000000000,-2.69799999999999,85,1,'';
                    'Fpz','',0,0.506688888888889,84.9812336134463,0,-1.78603850374883,0,-1.20399999999999,85,2,'';
                    'Fp2','',17.9260000000000,0.514988888888889,80.7840137690914,-26.1330144040702,-4.00108454195971,-17.9260000000000,-2.69799999999999,85,3,'';
                    'F7' ,'',-53.9130000000000,0.528083333333333,49.8713779489202,68.4233350269540,-7.48951836002624,53.9130000000000,-5.05500000000000,85,4,'';
                    'F3' ,'',-39.9470000000000,0.344594444444444,57.5510633930990,48.2004273175388,39.8697116710185,39.9470000000000,27.9730000000000,85,5,'';
                    'Fz' ,'',0,0.253377777777778,60.7384809484625,0,59.4629038314919,0,44.3920000000000,85,6,'';
                    'F4' ,'',39.8970000000000,0.344500000000000,57.5840261068105,-48.1425964684523,39.8919834378528,-39.8970000000000,27.9900000000000,85,7,'';
                    'F8' ,'',53.8670000000000,0.528066666666667,49.9265268118817,-68.3835902976096,-7.48508507040089,-53.8670000000000,-5.05200000000000,85,8,'';
                    'FC5','',-69.3320000000000,0.408233333333333,28.7628234353576,76.2473645099531,24.1669069868857,69.3320000000000,16.5180000000000,85,9,'';
                    'FC1','',-44.9250000000000,0.181183333333333,32.4361838987395,32.3513771312283,71.5980612293391,44.9250000000000,57.3870000000000,85,10,'';
                    'FC2','',44.9250000000000,0.181183333333333,32.4361838987395,-32.3513771312283,71.5980612293391,-44.9250000000000,57.3870000000000,85,11,'';
                    'FC6','',69.3320000000000,0.408233333333333,28.7628234353576,-76.2473645099531,24.1669069868857,-69.3320000000000,16.5180000000000,85,12,'';
                    'M1' ,'',-100.419000000000,0.747333333333333,-10.9602176732027,59.6061977901225,-59.5984464022411,100.419000000000,-44.5200000000000,85,13,'';
                    'T7' ,'',-90,0.533183333333333,5.17649253748256e-15,84.5385386396573,-8.84508251353112,90,-5.97300000000000,85,14,'';
                    'C3' ,'',-90,0.266688888888889,3.86812533613566e-15,63.1712807125907,56.8716914917349,90,41.9960000000000,85,15,'';
                    'Cz' ,'',0,0,5.20474889637625e-15,0,85,0,90,85,16,'';
                    'C4' ,'',90,0.266666666666667,3.86788221025119e-15,-63.1673101655785,56.8761015405030,-90,42,85,17,'';
                    'T8' ,'',90,0.533183333333333,5.17649253748256e-15,-84.5385386396573,-8.84508251353112,-90,-5.97300000000000,85,18,'';
                    'M2' ,'',100.419000000000,0.747333333333333,-10.9602176732027,-59.6061977901225,-59.5984464022411,-100.419000000000,-44.5200000000000,85,19,'';
                    'CP5','',-110.668000000000,0.408233333333333,-28.7628234353576,76.2473645099531,24.1669069868857,110.668000000000,16.5180000000000,85,20,'';
                    'CP1','',-135.075000000000,0.181183333333333,-32.4361838987395,32.3513771312283,71.5980612293391,135.075000000000,57.3870000000000,85,21,'';
                    'CP2','',135.075000000000,0.181183333333333,-32.4361838987395,-32.3513771312283,71.5980612293391,-135.075000000000,57.3870000000000,85,22,'';
                    'CP6','',110.668000000000,0.408233333333333,-28.7628234353576,-76.2473645099531,24.1669069868857,-110.668000000000,16.5180000000000,85,23,'';
                    'P7' ,'',-126.087000000000,0.528083333333333,-49.8713779489202,68.4233350269539,-7.48951836002624,126.087000000000,-5.05500000000000,85,24,'';
                    'P3' ,'',-140.053000000000,0.344594444444444,-57.5510633930990,48.2004273175389,39.8697116710185,140.053000000000,27.9730000000000,85,25,'';
                    'Pz' ,'',180,0.253377777777778,-60.7384809484625,-7.43831862786072e-15,59.4629038314919,-180,44.3920000000000,85,26,'';
                    'P4' ,'',140.103000000000,0.344500000000000,-57.5840261068105,-48.1425964684523,39.8919834378528,-140.103000000000,27.9900000000000,85,27,'';
                    'P8' ,'',126.133000000000,0.528066666666667,-49.9265268118817,-68.3835902976096,-7.48508507040089,-126.133000000000,-5.05200000000000,85,28,'';
                    'POz','',180,0.379944444444445,-79.0255388591416,-9.67783732147425e-15,31.3043800133831,-180,21.6100000000000,85,29,'';
                    'O1' ,'',-162.074000000000,0.514988888888889,-80.7840137690914,26.1330144040702,-4.00108454195971,162.074000000000,-2.69799999999999,85,30,'';
                    'Oz' ,'',180,0.506688888888889,-84.9812336134463,-1.04071995732300e-14,-1.78603850374883,-180,-1.20399999999999,85,31,'';
                    'O2' ,'',162.074000000000,0.514988888888889,-80.7840137690914,-26.1330144040702,-4.00108454195971,-162.074000000000,-2.69799999999999,85,32,'';
                    'AF7','',-35.8920000000000,0.522333333333333,68.6910763510323,49.7094313148880,-5.95889822761610,35.8920000000000,-4.02000000000000,85,33,'';
                    'AF3','',-22.4610000000000,0.421127777777778,76.1527667684846,31.4827967984807,20.8468131677331,22.4610000000000,14.1970000000000,85,34,'';
                    'AF4','',22.4610000000000,0.421127777777778,76.1527667684846,-31.4827967984807,20.8468131677331,-22.4610000000000,14.1970000000000,85,35,'';
                    'AF8','',35.8580000000000,0.522311111111111,68.7208994216315,-49.6689040281160,-5.95297869371352,-35.8580000000000,-4.01600000000001,85,36,'';
                    'F5' ,'',-49.4050000000000,0.431594444444444,54.0378881132512,63.0582218645482,18.1264255588676,49.4050000000000,12.3130000000000,85,37,'';
                    'F1' ,'',-23.4930000000000,0.279027777777778,59.9127302448179,26.0420933899754,54.3808249889562,23.4930000000000,39.7750000000000,85,38,'';
                    'F2' ,'',23.4930000000000,0.278783333333333,59.8744127660118,-26.0254380421476,54.4309771236893,-23.4930000000000,39.8190000000000,85,39,'';
                    'F6' ,'',49.4050000000000,0.431283333333333,54.0263340465386,-63.0447391225751,18.2075835425317,-49.4050000000000,12.3690000000000,85,40,'';
                    'FC3','',-62.4250000000000,0.288222222222222,30.9552849531915,59.2749781760892,52.4713950232968,62.4250000000000,38.1200000000000,85,41,'';
                    'FCz','',0,0.126622222222222,32.9278836352560,0,78.3629662487520,0,67.2080000000000,85,42,'';
                    'FC4','',62.4250000000000,0.288222222222222,30.9552849531915,-59.2749781760892,52.4713950232968,-62.4250000000000,38.1200000000000,85,43,'';
                    'C5' ,'',-90,0.399900000000000,4.94950482941819e-15,80.8315480490248,26.2918397986560,90,18.0180000000000,85,44,'';
                    'C1' ,'',-90,0.133188888888889,2.11480422795274e-15,34.5373740318457,77.6670444589234,90,66.0260000000000,85,45,'';
                    'C2' ,'',90,0.133483333333333,2.11920249382479e-15,-34.6092031645412,77.6350633175211,-90,65.9730000000000,85,46,'';
                    'C6' ,'',90,0.399900000000000,4.94950482941819e-15,-80.8315480490248,26.2918397986560,-90,18.0180000000000,85,47,'';
                    'CP3','',-117.575000000000,0.288222222222222,-30.9552849531915,59.2749781760892,52.4713950232968,117.575000000000,38.1200000000000,85,48,'';
                    'CPz','',180,0.126622222222222,-32.9278836352560,-4.03250272966127e-15,78.3629662487520,-180,67.2080000000000,85,49,'';
                    'CP4','',117.575000000000,0.288222222222222,-30.9552849531915,-59.2749781760892,52.4713950232968,-117.575000000000,38.1200000000000,85,50,'';
                    'P5' ,'',-130.595000000000,0.431594444444444,-54.0378881132511,63.0582218645482,18.1264255588676,130.595000000000,12.3130000000000,85,51,'';
                    'P1' ,'',-156.507000000000,0.279027777777778,-59.9127302448179,26.0420933899754,54.3808249889562,156.507000000000,39.7750000000000,85,52,'';
                    'P2' ,'',156.507000000000,0.278783333333333,-59.8744127660117,-26.0254380421476,54.4309771236893,-156.507000000000,39.8190000000000,85,53,'';
                    'P6' ,'',130.595000000000,0.431283333333333,-54.0263340465386,-63.0447391225751,18.2075835425317,-130.595000000000,12.3690000000000,85,54,'';
                    'PO5','',-149.461000000000,0.466494444444444,-72.8038985751152,42.9515511178202,8.93065556594885,149.461000000000,6.03100000000000,85,55,'';
                    'PO3','',-157.539000000000,0.421127777777778,-76.1527667684845,31.4827967984807,20.8468131677331,157.539000000000,14.1970000000000,85,56,'';
                    'PO4','',157.539000000000,0.421127777777778,-76.1527667684845,-31.4827967984807,20.8468131677331,-157.539000000000,14.1970000000000,85,57,'';
                    'PO6','',149.461000000000,0.466494444444444,-72.8038985751152,-42.9515511178202,8.93065556594885,-149.461000000000,6.03100000000000,85,58,'';
                    'FT7','',-71.9480000000000,0.531916666666667,26.2075035325936,80.4100143118706,-8.50860487705560,71.9480000000000,-5.74500000000001,85,59,'';
                    'FT8','',71.9480000000000,0.531916666666667,26.2075035325936,-80.4100143118706,-8.50860487705560,-71.9480000000000,-5.74500000000001,85,60,'';
                    'TP7','',-108.052000000000,0.531916666666667,-26.2075035325936,80.4100143118706,-8.50860487705560,108.052000000000,-5.74500000000001,85,61,'';
                    'TP8','',108.107000000000,0.531905555555556,-26.2847718099742,-80.3851021196760,-8.50565271492099,-108.107000000000,-5.74299999999999,85,62,'';
                    'PO7','',-144.108000000000,0.522333333333333,-68.6910763510323,49.7094313148880,-5.95889822761610,144.108000000000,-4.02000000000000,85,63,'';
                    'PO8','',144.142000000000,0.522311111111111,-68.7208994216315,-49.6689040281160,-5.95297869371352,-144.142000000000,-4.01600000000001,85,64,'';
                    'EOG','','','','','','','','','','','';
                    'EOGh','','','','','','','','','','','';
                    } ;


                NORIMU_KANALU_DUOMENYS=KANALU_DUOMENYS(find(ismember(KANALU_DUOMENYS(:,1),Reikalingi_kanalai)),:) ;

                disp(length(NORIMU_KANALU_DUOMENYS));
                disp(length(Reikalingi_kanalai));

                for k=1:length(Reikalingi_kanalai) ;
                    EEG.chanlocs2(k).labels=    NORIMU_KANALU_DUOMENYS{k,1}         ;
                    EEG.chanlocs2(k).type=      NORIMU_KANALU_DUOMENYS{k,2}         ;
                    EEG.chanlocs2(k).theta=     NORIMU_KANALU_DUOMENYS{k,3}         ;
                    EEG.chanlocs2(k).radius=    NORIMU_KANALU_DUOMENYS{k,4}         ;
                    EEG.chanlocs2(k).X=         NORIMU_KANALU_DUOMENYS{k,5}         ;
                    EEG.chanlocs2(k).Y=         NORIMU_KANALU_DUOMENYS{k,6}         ;
                    EEG.chanlocs2(k).Z=         NORIMU_KANALU_DUOMENYS{k,7}         ;
                    EEG.chanlocs2(k).sph_theta= NORIMU_KANALU_DUOMENYS{k,8}         ;
                    EEG.chanlocs2(k).sph_phi=   NORIMU_KANALU_DUOMENYS{k,9}         ;
                    EEG.chanlocs2(k).sph_radius=NORIMU_KANALU_DUOMENYS{k,10}        ;
                    EEG.chanlocs2(k).urchan=    NORIMU_KANALU_DUOMENYS{k,11}        ;
                    EEG.chanlocs2(k).ref=       NORIMU_KANALU_DUOMENYS{k,12}        ;
                end ;


                % Interpoliuok pagal EEG.chanlocs2 struktura
                try
                    [EEG, LASTCOM] = pop_interp(EEG, [EEG.chanlocs2], 'spherical');

                    EEG = eegh(LASTCOM, EEG);

                    % Pasalink visus kanalus, isskyrus tuos N ;
                    % Kadangi po interpoliavimo pagal nurodyta struktura
                    % tie norimieji kanalai perkeliami i pabaiga,
                    % tai istrinkime visus kanalus, isskyrus N paskutiniuju
                    if get(handles.checkbox_atrink_kanalus2A,'Value') == 1 ;
                        [EEG, LASTCOM] = pop_select( EEG,'channel', Reikalingi_kanalai);
                        EEG = eegh(LASTCOM, EEG);
                    end;

                    % Išmesti ICA struktūras
                    %EEG.specicaact=[]; EEG.icaact=[]; EEG.icawinv=[]; EEG.icasphere=[]; EEG.icaweights=[]; EEG.icachansind=[];
                    
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Channel selection and interpolation'), NaujaRinkmena) ;
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;




                % Išsaugoti
                disp(NaujaRinkmena);
                Priesaga=(get(handles.edit_atrink_kanalus2,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_atrink_kanalus2_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                disp(NaujaRinkmena);
                if get(handles.checkbox_atrink_kanalus2_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_atrink_kanalus2,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Filtruoti dažnius
        Darbo_apibudinimas=lokaliz('Second filtering...');
        if get(handles.checkbox_filtr2,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                try

                    daznis_filtravimui=str2num(get(handles.edit21,'String'));
                    %disp(['Filtruokim ' str2num(daznis_filtravimui)]);
                    if     get(handles.popupmenu10,'Value') == 1 ;
                        [EEG, LASTCOM] = pop_eegfiltnew(EEG, [], daznis_filtravimui, [], 1, [], 0);
                    elseif get(handles.popupmenu10,'Value') == 2 ;
                        [EEG, LASTCOM] = pop_eegfiltnew(EEG, [], daznis_filtravimui, [], 0, [], 0);
                    elseif get(handles.popupmenu10,'Value') == 3;
                        [EEG, LASTCOM] = pop_eegfiltnew(EEG, daznis_filtravimui(1), daznis_filtravimui(2), [], 0, [], 0);
                    elseif get(handles.popupmenu10,'Value') == 4;
                        [EEG, LASTCOM] = pop_eegfiltnew(EEG, daznis_filtravimui(1), daznis_filtravimui(2), [], 1, [], 0);
                    end;
                    EEG = eegh(LASTCOM, EEG);
                    EEG = eeg_checkset( EEG );

                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Second filtering'), NaujaRinkmena) ;
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;


                % Išsaugoti
                Priesaga=(get(handles.edit_filtr2,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_filtr2_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_filtr2_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;

                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_filtr2,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;

        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err; end;

        % Epochuoti
        Darbo_apibudinimas=lokaliz('Epoching...');
        if get(handles.checkbox_epoch,'Value') == 1 ;
            DarboNr = DarboNr + 1 ;
            if and(~and(get(handles.radiobutton7,'Value') == 1, DarboPorcijaAtlikta > 0), and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)));

                Darbo_eigos_busena(handles, Darbo_apibudinimas, DarboNr, i, Pasirinktu_failu_N);

                EEG = eeg_checkset( EEG );

                %Epochuoti_pagal_stimulus_=(str2num(get(handles.edit_epoch_iv,'String') ));
                try
                    Epochuoti_pagal_stimulus_=get(handles.pushbutton13,'UserData') ;
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

                    EEG = eeg_checkset( EEG );

                    disp(['pagal įvykius (' num2str(length(Epochuoti_pagal_stimulus)) '): ' ]);	
                    disp(sprintf('''%s'' ',Epochuoti_pagal_stimulus{:}));

                    %disp(get(handles.edit_epoch_t,'UserData'));
                    %disp({get(handles.edit_epoch_t,'UserData')});

                    %disp(get(handles.edit_epoch_t,'String'));
                    %disp({get(handles.edit_epoch_t,'String')});

                    %disp(str2num(get(handles.edit_epoch_t,'String')));
                    %disp({str2num(get(handles.edit_epoch_t,'String'))});

                    %EEG = pop_epoch( EEG, ...
                    %    Epochuoti_pagal_stimulus, ...
                    %    get(handles.edit_epoch_t,'UserData'), ...
                    %    'epochinfo', 'yes');

                    Epochos_laiko_intervalas=str2num(get(handles.edit_epoch_t,'String'));
                    %if length(Epochos_laiko_intervalas)==2;
                    if ~isempty(EEG.epoch);
                        Epochos_laiko_intervalas_alt= [ ...
                           max(Epochos_laiko_intervalas(1), EEG.xmin) ...
                           min(Epochos_laiko_intervalas(2), EEG.xmax) ];
                       if isempty(find(Epochos_laiko_intervalas == Epochos_laiko_intervalas_alt));
                           wrn=warning('off','backtrace');
                           warning(sprintf( [ '\n' ...
                               lokaliz('You use already epoched data.') '\n' ...
                               lokaliz('Your selected epoch interval may be too big.') '\n' ...
                               lokaliz('Consider to use') '\n'  ...
                               ' [' num2str(Epochos_laiko_intervalas_alt)  '] \n' ]));
                           warning(wrn.state, 'backtrace');
                            %EEG_pries=EEG;
                        end;

                    end;
                    %end;

                    [EEG, ~, LASTCOM] = pop_epoch( EEG, ...
                        Epochuoti_pagal_stimulus, ...
                        Epochos_laiko_intervalas, ...
                        'epochinfo', 'yes');

                    EEG = eeg_checkset( EEG );
                    
                    if and(isempty(EEG.data), exist('EEG_pries','var'));
                        wrn=warning('off','backtrace');
                        warning(sprintf(['\n' lokaliz('Empty dataset') '.\n ' lokaliz('Trying again with') ...
                            ' [' num2str(Epochos_laiko_intervalas_alt)  '] \n' ]));
                        warning(wrn.state, 'backtrace');
                        [EEG, ~, LASTCOM] = pop_epoch( EEG_pries, ...
                        Epochuoti_pagal_stimulus, ...
                        Epochos_laiko_intervalas_alt, ...
                        'epochinfo', 'yes');
                       EEG = eeg_checkset( EEG );
                    end;

                    EEG = eegh(LASTCOM, EEG);

                    if isempty(EEG.data);
                        error(lokaliz('Empty dataset'));
                    end;

                    if get(handles.checkbox_epoch_b,'Value') == 1 ;
                        %EEG = pop_rmbase( EEG, 1000 * get(handles.edit_epoch_b,'UserData'));
						EEG = pop_rmbase( EEG, 1000 * str2num(get(handles.edit_epoch_b,'String')));
                        EEG = eeg_checkset( EEG );
                    end;
                catch err;
                    Pranesk_apie_klaida(err, lokaliz('Epoching'), NaujaRinkmena);
                    DarboPorcijaAtlikta=1;
                    PaskRinkmIssaugKelias='';
                    EEG.nbchan=0;
                end;

                % Išsaugoti
                Priesaga=(get(handles.edit_epoch,'String')) ;
                Poaplankis=[ './' num2str(SaugomoNr) ' - ' (get(handles.edit_epoch_,'String')) ] ;
                [~, NaujaRinkmena, ~ ]=fileparts(NaujaRinkmena); NaujaRinkmena=[  NaujaRinkmena Priesaga '.set'];
                if get(handles.checkbox_epoch_,'Value') == 1 && ~TIK_PERZIURA;
                    eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
                    PaskutinioIssaugotoDarboNr=DarboNr;
                    DarboPorcijaAtlikta = 1;
                    SaugomoNr = SaugomoNr +1;
                    PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
                else
                    PaskRinkmIssaugKelias='';
                end;


                if and(get(handles.radiobutton7,'Value') == 1, i == Pasirinktu_failu_N );
                    set(handles.checkbox_epoch,'Value',0);
                    set(handles.text_atlikta_darbu,'String',num2str(1+str2num(get(handles.text_atlikta_darbu,'String'))));
                end;

            end;
        end;


        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
        try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err;  end;

        %try
        %    komanda
        %catch err;
        %Pranesk_apie_klaida(err, Darbelis, Rinkmena);
        %end;

        %pause;


        %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(0 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);



        % Išsaugoti
        if isempty(PaskRinkmIssaugKelias) && ~TIK_PERZIURA && ~isempty(EEG);
            Poaplankis='.';
            Priesaga='';
            eeg_issaugoti(EEG, fullfile(KELIAS_SAUGOJIMUI,Poaplankis), NaujaRinkmena);
            PaskRinkmIssaugKelias=Tikras_Kelias(fullfile(KELIAS_SAUGOJIMUI,Poaplankis));
            DarboPorcijaAtlikta = 1;
        %else   disp('Duomenys jau įrašyti');
        end;

        str=(sprintf('%s apdorotas (%d/%d = %3.2f%%)\r\n', NaujaRinkmena, i, Pasirinktu_failu_N, i/Pasirinktu_failu_N*100 )) ;
        disp(str);

        if and(~isempty(EEG),DarboPorcijaAtlikta) && ~TIK_PERZIURA;
            if and(EEG.nbchan > 0, and(~isempty(EEG.data), EEG.pnts>1)) ;
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

    if PERZIURA; pop_eeg_perziura(EEG0, EEG, 'title', [Rinkmena_ ' + ' NaujaRinkmena], 'zymeti', 0); end;

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
   
   set(handles.uipanel6,'Title', lokaliz('Data processing functions'));
   set(handles.text_atlikta_darbu,'String',num2str(SaugomoNr-1));
   atnaujinti_eeglab=true;

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

    % Uždaryk failą, jei MARA apibendrinimai buvo rašomi
    if get(handles.checkbox_MARA,'Value') == 1 ;
        fclose(fid);
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
    %try
        %cd(get(handles.edit2,'String'));
        %cd(PaskRinkmIssaugKelias);
    %end;

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


function langai=gauk_EEG_perziuru_langus(varargin)
langai=[...
        findobj('-regexp','name','Reject components by map.*')  ; ...
        findobj('-regexp','name','pop_prop().*') ; ...
        findobj('-regexp','name','Scroll channel activities.*') ; ...
        findobj('-regexp','name','Scroll component activities.*') ; ...
        findobj('-regexp','name','Confirmation.*') ; ...
        findobj('-regexp','name','Black = channel before rejection.*') ; ...
        findobj('-regexp','name','MARA .*') ; ];
if nargin > 0 ;
    atranka=varargin{1};
    if ischar(atranka);
        atranka={atranka};
    end;
    if iscellstr(atranka);
        for i=1:length(atranka);
            langai=[ langai ; findobj('-regexp', 'name', atranka{i}) ] ; %#ok
        end;
    end;
end;

function uzverti_EEG_perziuru_langus(varargin)
langai=gauk_EEG_perziuru_langus(varargin);
for i=1:length(langai);
    try close(langai(i)) ; catch; end;
end;


function EEG_perduot = vykdymas_perziureti_ICA(EEG_senas, EEG_darbinis, ICA_zr_veiksena, ICA_pt_veiksena, ICA_demesio, NaujaRinkmena)
% ICA_zr_veiksena = get(handles.popupmenu7,'Value')
% ICA_pt_veiksena = get(handles.popupmenu8,'Value')
% ICA_demesio = get(handles.checkbox_perziureti_ICA_demesio,'Value')
% NaujaRinkmena = 'bet koks pavadinimas'

EEG_perduot=[]; 
global STUDY CURRENTSTUDY ALLEEG EEG CURRENTSET;
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; CURRENTSET=[];
EEG = eeg_checkset( EEG_darbinis );
EEG_darbinis=[]; % nebereikalingas
ICA_kiekis=length(EEG.reject.gcompreject);
if ICA_kiekis == 0;
    error(lokaliz('NKA nerasta'));
end;
[~,NaujaRinkmena_be_galunes,~]=fileparts(NaujaRinkmena);
NaujaRinkmena_be_galunes_re=strrep(NaujaRinkmena_be_galunes,'+','\+');
uzverti_EEG_perziuru_langus; %([ '.*' NaujaRinkmena_be_galunes '.*' ]);

if ICA_zr_veiksena < 8;
    try eeglab redraw;
    catch err; Pranesk_apie_klaida(err,'','',0);
    end;
    drawnow ;
end;

switch ICA_zr_veiksena
    case 2
        pop_eeg_perziura(EEG, 'zymeti', 0, 'title', NaujaRinkmena_be_galunes);
        %pop_eegplot( EEG, 1, 1, 1);
    case {3 4 6}
        pop_eeg_perziura(EEG, 'zymeti', 0, 'title', NaujaRinkmena_be_galunes, 'ICA', 1);
        %pop_eegplot( EEG, 0, 1, 1);
    case 7
        if isfield(EEG.reject, 'MARAinfo');
            pop_visualizeMARAfeatures(EEG.reject.gcompreject, EEG.reject.MARAinfo);
        else
            wrn=warning('off','backtrace');
            warning([ lokaliz('kintamasis neegzistuoja') ': EEG.reject.MARAinfo' ] );
            warning(wrn.state, 'backtrace');
        end;
end;

switch ICA_zr_veiksena
    case {1 2 3}
        EEG = pop_selectcomps(EEG, [1:ICA_kiekis]);
        EEG = eegh(['EEG = pop_selectcomps(EEG, [1:' num2str(ICA_kiekis) ']);'], EEG);
    case {5 6 7}
        EEG = pop_selectcomps_MARA(EEG);
        EEG = eegh('EEG = pop_selectcomps_MARA(EEG);', EEG);
end;

%if get(handles.popupmenu8,'Value') ~= 4 ;

if ICA_zr_veiksena < 8;
    try eeglab redraw;
    catch err; Pranesk_apie_klaida(err,'','',0);
    end;
    drawnow ;
    pause(1) ;
end;

if ICA_demesio == 0 && ICA_zr_veiksena < 8;
    
    while ~isempty(gauk_EEG_perziuru_langus([ '.*' NaujaRinkmena_be_galunes '.*' ]));
        if 1 == 0
            waitfor(gauk_EEG_perziuru_langus([ '.*' NaujaRinkmena_be_galunes '.*' ]));
            pause(1) ;
        end ;
        uiwait(gcf,3);
        if ICA_zr_veiksena < 8;
            try eeglab redraw;
            catch err; Pranesk_apie_klaida(err,'','',0);
            end;
        end;
    end ;
    
else
    if ICA_zr_veiksena < 8;
        Palauk();
    end;
    uzverti_EEG_perziuru_langus([ '.*' NaujaRinkmena_be_galunes_re '.*' ]);
end;

EEG = eeg_checkset( EEG );

gcompreject=find(EEG.reject.gcompreject);
disp(gcompreject);

if isempty(gcompreject) && (ICA_pt_veiksena < 5);
    button = questdlg(...
        [ lokaliz('No selected ICA components for rejection.') ' ' lokaliz('Grazinti pradinius duomenis?') ], lokaliz('No selected ICA components for rejection.') , ...
        lokaliz('Abort'), lokaliz('Keisti'), lokaliz('Yes'), lokaliz('Yes'));
    switch button
        case lokaliz('Yes');
            EEG=EEG_senas;
        case lokaliz('Abort');
            return; %error(lokaliz('Nutraukta'));
        otherwise
            EEG_perduot = vykdymas_perziureti_ICA(EEG_senas, EEG, ICA_zr_veiksena, ICA_pt_veiksena, ICA_demesio, NaujaRinkmena);
            return;
    end;
else
    switch ICA_pt_veiksena
        case 1
            EEG = pop_subcomp( EEG, gcompreject, 0 );
            EEG = eegh(['EEG = pop_subcomp( EEG, [' num2str(gcompreject) '] , 0 );'], EEG);
        case 2
            EEG = pop_subcomp( EEG, gcompreject, 1 );
        case 3
            EEG_naujas = pop_subcomp( EEG, gcompreject, 0 );
            pop_eeg_perziura(EEG_naujas, EEG_senas, 'zymeti', 0, 'title', NaujaRinkmena_be_galunes);
            drawnow;
            %                                 ats=questdlg({lokaliz('Please review data after rejecting ICA components:') num2str(gcompreject) ...
            %                                     lokaliz('Priimti pakeitimus?')}, lokaliz('You review ICA...'), ...
            %                                     lokaliz('Cancel'), lokaliz('Atmesti'), lokaliz('Priimti'), lokaliz('Priimti') );
            d = dialog('Position',[300 300 250 200],'Name',lokaliz('You review ICA...'),'WindowStyle','normal');
            
            uicontrol('Parent',d,...
                'Style','text',...
                'Position',[20 80 210 100],...
                'HorizontalAlignment','left',...
                'String',{lokaliz('Please review data after rejecting ICA components:') ...
                num2str(gcompreject) lokaliz('Priimti pakeitimus?')});
            
            uicontrol('Parent',d,...
                'Position',[10 20 70 25],...
                'String', lokaliz('Baigti'),...
                'Callback','delete(gcf); setappdata(0, ''mygtuko_pasirinkimas'', 0); ');
            
            uicontrol('Parent',d,...
                'Position',[85 20 70 25],...
                'String', lokaliz('Tobulinti'),...
                'Callback','delete(gcf)');
            
            uicontrol('Parent',d,...
                'Position',[160 20 70 25],...
                'String', lokaliz('Priimti'),...
                'Callback','delete(gcf); setappdata(0, ''mygtuko_pasirinkimas'', 1); ');
            
            setappdata(0, 'mygtuko_pasirinkimas', NaN);
            uiwait(d);
            
            ats=getappdata(0, 'mygtuko_pasirinkimas');
            switch ats
                case { 1 lokaliz('Priimti') lokaliz('Yes') }
                    EEG = EEG_naujas;
                case { 0 lokaliz('Atmesti') lokaliz('No') }
                    uzverti_EEG_perziuru_langus([ '.*' NaujaRinkmena_be_galunes_re '.*' ]);
                    button = questdlg(...
                        [ lokaliz('Grazinti pradinius duomenis?') ], lokaliz('Grazinti pradinius duomenis?') , ...
                        lokaliz('Abort'), lokaliz('Yes'), lokaliz('Yes'));
                    switch button
                        case lokaliz('Yes');
                            EEG = EEG_senas;
                        otherwise
                            return; % error(lokaliz('Nutraukta'));
                    end;
                otherwise
                    uzverti_EEG_perziuru_langus([ '.*' NaujaRinkmena_be_galunes_re '.*' ]);
                    button = questdlg(...
                        [ lokaliz('Ikelti pradinius duomenis?') ], lokaliz('Ikelti pradinius duomenis?') , ...
                        lokaliz('No'), lokaliz('Reload'), lokaliz('Reload'));
                    switch button
                        case lokaliz('Reload');
                            EEG_perduot = vykdymas_perziureti_ICA(EEG_senas, EEG_senas, ICA_zr_veiksena, ICA_pt_veiksena, ICA_demesio, NaujaRinkmena);
                        otherwise
                            EEG_perduot = vykdymas_perziureti_ICA(EEG_senas, EEG, ICA_zr_veiksena, ICA_pt_veiksena, ICA_demesio, NaujaRinkmena);
                    end;
                    return;
            end;
            EEG_senas=[]; EEG_naujas=[]; %#ok
        case 5
            return;
    end;
    
    switch ICA_pt_veiksena
        case {2 3}
            if ~isfield(EEG.reject,'gcompreject');
                EEG = eegh(['EEG = pop_subcomp( EEG, [' num2str(gcompreject) '] , 1 );'], EEG);
            elseif ~isequal(gcompreject,find(EEG.reject.gcompreject));
                EEG = eegh(['EEG = pop_subcomp( EEG, [' num2str(gcompreject) '] , 1 );'], EEG);
            end;
    end;
end;

if ICA_zr_veiksena < 8;
    try eeglab redraw;
    catch err; Pranesk_apie_klaida(err,'','',0);
    end;
    drawnow ;
    pause(1) ;
end;

uzverti_EEG_perziuru_langus([ '.*' NaujaRinkmena_be_galunes '.*' ]);
EEG_perduot = eeg_checkset( EEG );



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
%try
%    cd(get(handles.edit1,'String'));
%catch err;
%end;
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);


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
if ~strcmp(get(handles.edit_failu_filtras2,'Style'),'pushbutton') ;
    set(handles.edit_failu_filtras2,'Style','pushbutton');
    set(handles.edit_failu_filtras2,'String',lokaliz('Filter'));
    set(handles.edit_failu_filtras2,'BackgroundColor','remove');
end;
Ar_galima_vykdyti(hObject, eventdata, handles)

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
    set(handles.edit2,'String',Tikras_Kelias(get(handles.edit2,'String')));
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
        'Neradome aplanko', ...
        'Atšaukti', 'Sukurti aplanką', 'Sukurti aplanką');
    if strcmp(button3,'Sukurti aplanką')
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


% --- Executes on button press in checkbox_rf.
function checkbox_rf_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rf
if and(get(handles.checkbox_rf, 'Value') == 1, ...
        strcmp(get(handles.checkbox_rf, 'Enable'),'on'));
    set(handles.popupmenu3,'Enable','on');
    set(handles.checkbox_rf_,'Enable','on');
    set(handles.edit_rf,'Enable','on');
    set(handles.pushbutton18,'Enable','on');
else
    set(handles.popupmenu3,'Enable','off');
    set(handles.checkbox_rf_,'Enable','off');
    set(handles.edit_rf,'Enable','off');
    set(handles.pushbutton18,'Enable','off');
end;
checkbox_rf__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes on button press in checkbox_filtr1.
function checkbox_filtr1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_filtr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_filtr1
if and(get(handles.checkbox_filtr1, 'Value') == 1, ...
        strcmp(get(handles.checkbox_filtr1, 'Enable'),'on'));
    set(handles.edit3,'Enable','on');
    set(handles.checkbox_filtr1_,'Enable','on');
    set(handles.edit_filtr1,'Enable','on');
    set(handles.popupmenu9,'Enable','on');
    edit3_Callback(hObject, eventdata, handles);
else
    set(handles.edit3,'Enable','off');
    set(handles.checkbox_filtr1_,'Enable','off');
    set(handles.edit_filtr1,'Enable','off');
    set(handles.popupmenu9,'Enable','off');
    Ar_galima_vykdyti(hObject, eventdata, handles);
end;
checkbox_filtr1__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_filtr_tinklo.
function checkbox_filtr_tinklo_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_filtr_tinklo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_filtr_tinklo

if get(handles.checkbox_filtr_tinklo, 'Value') == 1;
    if isempty(which('pop_cleanline.m'));
        disp(' ');
        disp([lokaliz('nerasta') ': pop_cleanline.m' ]);
        disp([ lokaliz('Please install plugin') ' CleanLine:']);
        disp('http://sccn.ucsd.edu/wiki/Plugin_list_process');
        disp('http://www.nitrc.org/projects/cleanline/');
        warndlg([ lokaliz('Please install plugin') ' CleanLine' ], lokaliz('Please install plugin'));
        set(handles.checkbox_filtr_tinklo, 'Value', 0);
    end;
end;

if and(get(handles.checkbox_filtr_tinklo, 'Value') == 1, ...
        strcmp(get(handles.checkbox_filtr_tinklo, 'Enable'),'on'));
    set(handles.checkbox_filtr_tinklo_,'Enable','on');
    set(handles.edit_filtr_tinklo,'Enable','on');
    set(handles.edit50,'Enable','on');
else
    set(handles.checkbox_filtr_tinklo_,'Enable','off');
    set(handles.edit_filtr_tinklo,'Enable','off');
    set(handles.edit50,'Enable','off');
end;
checkbox_filtr_tinklo__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_kanalu_padetis.
function checkbox_kanalu_padetis_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_kanalu_padetis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_kanalu_padetis
if and(get(handles.checkbox_kanalu_padetis, 'Value') == 1, ...
        strcmp(get(handles.checkbox_kanalu_padetis, 'Enable'),'on'));
    set(handles.checkbox_kanalu_padetis_,'Enable','on');
    set(handles.edit_kanalu_padetis,'Enable','on');
    set(handles.popupmenu12,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
else
    set(handles.checkbox_kanalu_padetis_,'Enable','off');
    set(handles.edit_kanalu_padetis,'Enable','off');
    set(handles.popupmenu12,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
end;
checkbox_kanalu_padetis__Callback(hObject, eventdata, handles);
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

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on slider movement.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
txts=get(handles.popupmenu3,'String');
set(handles.popupmenu3,'TooltipString',txts{get(handles.popupmenu3,'Value')});

priesaga='_rf';
if get(handles.popupmenu3,'Value') == 1 ;
    priesaga='_rfA';
elseif get(handles.popupmenu3,'Value') == 2
    priesaga='_rfM';
elseif get(handles.popupmenu3,'Value') == 3
    priesaga='_rfCz';
end;
set(handles.edit_rf,'String', priesaga  ) ;
set(handles.edit_rf_,'String', [ 'Reference' ]  ) ;

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
id=handles.edit3;
x=real(str2num(get(id,'String')));
senas=get(id,'UserData');
%disp(x);
tinka=0;
if and(length(x) == 1, get(handles.popupmenu9,'Value') < 3 ) ;
  if x > 0 ;
    tinka=1;
    set(id,'UserData',regexprep(num2str(x), '[ ]*', ' '));
  end;
elseif and(length(x) == 2, get(handles.popupmenu9,'Value') > 2 ) ;
  if and(0 < x(1), x(1) < x(2));
    tinka=1;
    set(id,'UserData',regexprep(num2str(x), '[ ]*', ' '));
  end;
end;
if tinka;
    set(id,'String',get(id,'UserData'));
end;
set(id,'BackgroundColor',[1 1 tinka]);
%x=str2num(get(id,'String'));
if ~strcmp(senas,get(id,'String'));
    set(handles.edit_filtr1,'String', [ lokaliz('_Nuosekl_apdor_default_file_suffix_filter') regexprep(  num2str(get(id,'UserData')) , '[ ]*', '-')   ]  ) ;
    set(handles.edit_filtr1_,'String', [ lokaliz('_Nuosekl_apdor_default_dir_filter') ' ' regexprep(  num2str(get(id,'UserData')) , '[ ]*', '-') ' ' lokaliz('Hz') ]) ;
end;
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes on button press in checkbox_atrink_kanalus1.
function checkbox_atrink_kanalus1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atrink_kanalus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atrink_kanalus1
if and(get(handles.checkbox_atrink_kanalus1, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atrink_kanalus1, 'Enable'),'on'));
    set(handles.checkbox_atrink_kanalus1__,'Enable','on');
    set(handles.checkbox_atrink_kanalus1_,'Enable','on');
    set(handles.edit_atrink_kanalus1,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    %set(handles.text8,'Visible','on');
    if ~strcmp('1',get(handles.checkbox_atrink_kanalus1,'UserData'));
        pushbutton9_Callback(hObject, eventdata, handles);
    end;
    %disp(get(handles.pushbutton9,'Value'));
    %disp(get(handles.pushbutton9,'UserData'));
    %set(handles.pushbutton9,'UserData',get(handles.pushbutton9,'Value'));
    %if ~isempty(get(handles.text8,'TooltipString')) ;
    if ~isempty(get(handles.pushbutton9,'UserData')) ;
        %Pasirinkti_kanalai=textscan(get(handles.text8,'TooltipString'),'%s','delimiter',' ');
        %Pasirinkti_kanalai=Pasirinkti_kanalai{1};
        Pasirinkti_kanalai=get(handles.pushbutton9,'UserData');
        senas_kan_kiekis=get(handles.text8,'String');
        set(handles.text8,'String',length(Pasirinkti_kanalai));
        Kanal_sar=regexprep(sprintf('%s ', Pasirinkti_kanalai{:}),' $','');
        set(handles.text8,'TooltipString',Kanal_sar);
        set(handles.pushbutton9,'BackgroundColor','remove');
    else
        set(handles.pushbutton9,'BackgroundColor',[1 1 0]);
        set(handles.text8,'TooltipString','');
        set(handles.text8,'String','?');
    end;

else
    set(handles.checkbox_atrink_kanalus1__,'Enable','off');
    set(handles.checkbox_atrink_kanalus1_,'Enable','off');
    set(handles.edit_atrink_kanalus1,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton9,'BackgroundColor', 'remove');
    %set(handles.text8,'Visible','on');
end;
checkbox_atrink_kanalus1__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_atrink_kanalus2A.
function checkbox_atrink_kanalus2A_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atrink_kanalus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atrink_kanalus2A


% --- Executes on button press in checkbox_atmesk_atkarpas_amp.
function checkbox_atmesk_atkarpas_amp_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atmesk_atkarpas_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atmesk_atkarpas_amp
if and(get(handles.checkbox_atmesk_atkarpas_amp, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atmesk_atkarpas_amp, 'Enable'),'on'));
    set(handles.checkbox_atmesk_atkarpas_amp_,'Enable','on');
    set(handles.edit_atmesk_atkarpas_amp,'Enable','on');
    set(handles.edit57,'Enable','on');
    set(handles.edit58,'Enable','on');
else
    set(handles.checkbox_atmesk_atkarpas_amp_,'Enable','off');
    set(handles.edit_atmesk_atkarpas_amp,'Enable','off');
    set(handles.edit57,'Enable','off');
    set(handles.edit58,'Enable','off');
end;
checkbox_atmesk_atkarpas_amp__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_atmesk_atkarpas_dzn.
function checkbox_atmesk_atkarpas_dzn_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atmesk_atkarpas_dzn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atmesk_atkarpas_dzn
if and(get(handles.checkbox_atmesk_atkarpas_dzn, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atmesk_atkarpas_dzn, 'Enable'),'on'));
    set(handles.checkbox_atmesk_atkarpas_dzn_,'Enable','on');
    set(handles.edit_atmesk_atkarpas_dzn,'Enable','on');
    set(handles.edit43,'Enable','on');
    set(handles.edit44,'Enable','on');
else
    set(handles.checkbox_atmesk_atkarpas_dzn_,'Enable','off');
    set(handles.edit_atmesk_atkarpas_dzn,'Enable','off');
    set(handles.edit43,'Enable','off');
    set(handles.edit44,'Enable','off');
end;
checkbox_atmesk_atkarpas_dzn__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_atmesk_kan_auto.
function checkbox_atmesk_kan_auto_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atmesk_kan_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atmesk_kan_auto
if and(get(handles.checkbox_atmesk_kan_auto, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atmesk_kan_auto, 'Enable'),'on'));
    set(handles.checkbox_atmesk_kan_auto_,'Enable','on');
    set(handles.edit_atmesk_kan_auto,'Enable','on');
    set(handles.popupmenu6,'Enable','on');
    set(handles.edit40,'Enable','on');
    set(handles.edit_atmesk_kan_auto_slenkstis,'Enable','on');
    set(handles.checkbox41,'Enable','on');
else
    set(handles.checkbox_atmesk_kan_auto_,'Enable','off');
    set(handles.edit_atmesk_kan_auto,'Enable','off');
    set(handles.popupmenu6,'Enable','off');
    set(handles.edit40,'Enable','off');
    set(handles.edit_atmesk_kan_auto_slenkstis,'Enable','off');
    set(handles.checkbox41,'Enable','off');
end;
checkbox_atmesk_kan_auto__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_perziureti.
function checkbox_perziureti_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_perziureti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_perziureti
if and(get(handles.checkbox_perziureti, 'Value') == 1, ...
        strcmp(get(handles.checkbox_perziureti, 'Enable'),'on'));
    set(handles.checkbox_perziureti_,'Enable','on');
    set(handles.checkbox_perziureti_demesio,'Enable','off');
    %set(handles.checkbox_perziureti_demesio,'Enable','inactive');
    set(handles.edit_perziureti,'Enable','on');
else
    set(handles.checkbox_perziureti_,'Enable','off');
    set(handles.checkbox_perziureti_demesio,'Enable','off');
    set(handles.edit_perziureti,'Enable','off');
end;
checkbox_perziureti__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_ICA.
function checkbox_ICA_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ICA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ICA
if and(get(handles.checkbox_ICA, 'Value') == 1, ...
        strcmp(get(handles.checkbox_ICA, 'Enable'),'on'));
    set(handles.checkbox_ICA_,'Enable','on');
    set(handles.edit_ICA,'Enable','on');
    set(handles.popupmenu4,'Enable','on');
    set(handles.edit59,'Enable','on');
else
    set(handles.checkbox_ICA_,'Enable','off');
    set(handles.edit_ICA,'Enable','off');
    set(handles.popupmenu4,'Enable','off');
    set(handles.edit59,'Enable','off');
    %set(handles.checkbox_MARA, 'Value',0);
    %checkbox_MARA_Callback(hObject, eventdata, handles);
end;
popupmenu4_Callback(hObject, eventdata, handles);
checkbox_ICA__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_atmesk_iki2s.
function checkbox_atmesk_iki2s_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atmesk_iki2s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atmesk_iki2s
if and(get(handles.checkbox_atmesk_iki2s, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atmesk_iki2s, 'Enable'),'on'));
    set(handles.checkbox_atmesk_iki2s_,'Enable','on');
    set(handles.edit_atmesk_iki2s,'Enable','on');
    set(handles.edit20,'Enable','on');
else
    set(handles.checkbox_atmesk_iki2s_,'Enable','off');
    set(handles.edit_atmesk_iki2s,'Enable','off');
    set(handles.edit20,'Enable','off');
end;
checkbox_atmesk_iki2s__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_vienoda_trukme.
function checkbox_vienoda_trukme_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_vienoda_trukme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_vienoda_trukme
if and(get(handles.checkbox_vienoda_trukme, 'Value') == 1, ...
        strcmp(get(handles.checkbox_vienoda_trukme, 'Enable'),'on'));
    set(handles.checkbox_vienoda_trukme_,'Enable','on');
    set(handles.edit_vienoda_trukme,'Enable','on');
    set(handles.edit19,'Enable','on');
else
    set(handles.checkbox_vienoda_trukme_,'Enable','off');
    set(handles.edit_vienoda_trukme,'Enable','off');
    set(handles.edit19,'Enable','off');
end;
checkbox_vienoda_trukme__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_atrink_kanalus2.
function checkbox_atrink_kanalus2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atrink_kanalus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atrink_kanalus2
if and(get(handles.checkbox_atrink_kanalus2, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atrink_kanalus2, 'Enable'),'on'));
    set(handles.checkbox_atrink_kanalus2A,'Enable','on');
    set(handles.checkbox_atrink_kanalus2_,'Enable','on');
    set(handles.edit_atrink_kanalus2,'Enable','on');
    set(handles.pushbutton7,'Enable','on');


    if ~strcmp('1',get(handles.checkbox_atrink_kanalus2,'UserData'));
        pushbutton7_Callback(hObject, eventdata, handles);
    end;

    %disp(get(handles.pushbutton7,'UserData'));

    %set(handles.pushbutton7,'UserData',get(handles.pushbutton7,'Value'));
    %if or(get(handles.pushbutton7,'UserData') ~= 0, ~isempty(get(handles.pushbutton7,'UserData'))) ;
    if ~isempty(get(handles.pushbutton7,'UserData'));
        set(handles.text9,'String',length(get(handles.pushbutton7,'UserData')));
        set(handles.pushbutton7,'BackgroundColor','remove');
    else
        set(handles.pushbutton7,'BackgroundColor',[1 1 0]);
        set(handles.text9,'String','?');
    end;

else
    set(handles.checkbox_atrink_kanalus2A,'Enable','off');
    set(handles.checkbox_atrink_kanalus2_,'Enable','off');
    set(handles.edit_atrink_kanalus2,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton7,'BackgroundColor','remove');
end;
checkbox_atrink_kanalus2__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_ASR.
function checkbox_ASR_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ASR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ASR
if get(handles.checkbox_ASR, 'Value') == 1;
    if isempty(which('clean_rawdata.m'));
        disp(' ');
        disp([lokaliz('nerasta') ': clean_rawdata.m' ]);
        disp([ lokaliz('Please install plugin') ' ASR <http://sccn.ucsd.edu/wiki/Plugin_list_process>' ]);
        warndlg([ lokaliz('Please install plugin') ' ASR (clean_rawdata)' ], lokaliz('Please install plugin'));
        set(handles.checkbox_ASR, 'Value', 0);
    end;
end;

if and(get(handles.checkbox_ASR, 'Value') == 1, ...
        strcmp(get(handles.checkbox_ASR, 'Enable'),'on'));
    set(handles.checkbox_ASR_,'Enable','on');
    set(handles.edit_ASR,'Enable','on');
else
    set(handles.checkbox_ASR_,'Enable','off');
    set(handles.edit_ASR,'Enable','off');
end;
checkbox_ASR__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_MARA.
function checkbox_MARA_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_MARA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_MARA
if get(handles.checkbox_MARA, 'Value') == 1;
    if isempty(which('MARA.m')) || isempty(which('processMARA.m'));
        disp(' ');
        disp([lokaliz('nerasta') ': pop_selectcomps_MARA.m' ]);
        disp([ lokaliz('Please install plugin') ' MARA:']);
        disp('http://www.user.tu-berlin.de/irene.winkler/artifacts/');
        disp('http://sccn.ucsd.edu/wiki/Plugin_list_process');
        warndlg([ lokaliz('Please install plugin') ' MARA' ], lokaliz('Please install plugin'));
        set(handles.checkbox_MARA, 'Value', 0);
    end;
end;

if and(get(handles.checkbox_MARA, 'Value') == 1, ...
        strcmp(get(handles.checkbox_MARA, 'Enable'),'on'));
    set(handles.checkbox_MARA_,'Enable','on');
    set(handles.edit_MARA,'Enable','on');
    set(handles.popupmenu5,'Enable','on');
else
    set(handles.checkbox_MARA_,'Enable','off');
    set(handles.edit_MARA,'Enable','off');
    set(handles.popupmenu5,'Enable','off');
end;
popupmenu5_Callback(hObject, eventdata, handles);
checkbox_MARA__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_perziureti_ICA.
function checkbox_perziureti_ICA_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_perziureti_ICA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_perziureti_ICA
if and(get(handles.checkbox_perziureti_ICA, 'Value') == 1, ...
        strcmp(get(handles.checkbox_perziureti_ICA, 'Enable'),'on'));
    set(handles.checkbox_perziureti_ICA_,'Enable','on');
    set(handles.edit_perziureti_ICA,'Enable','on');
    set(handles.checkbox_perziureti_ICA_demesio,'Enable','off');
    %set(handles.checkbox_perziureti_ICA_demesio,'Enable','inactive');
    set(handles.popupmenu7,'Enable','on');
    popupmenu7_Callback(hObject, eventdata, handles);
    set(handles.popupmenu8,'Enable','on');
    popupmenu8_Callback(hObject, eventdata, handles);
else
    set(handles.checkbox_perziureti_ICA_,'Enable','off');
    set(handles.edit_perziureti_ICA,'Enable','off');
    set(handles.checkbox_perziureti_ICA_demesio,'Enable','off');
    set(handles.popupmenu7,'Enable','off');
    set(handles.popupmenu8,'Enable','off');
end;
checkbox_perziureti_ICA__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_filtr2.
function checkbox_filtr2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_filtr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_filtr2
if and(get(handles.checkbox_filtr2, 'Value') == 1, ...
        strcmp(get(handles.checkbox_filtr2, 'Enable'),'on'));
    set(handles.checkbox_filtr2_,'Enable','on');
    set(handles.edit_filtr2,'Enable','on');
    set(handles.edit21,'Enable','on');
    set(handles.popupmenu10,'Enable','on');
    edit21_Callback(hObject, eventdata, handles);
else
    set(handles.checkbox_filtr2_,'Enable','off');
    set(handles.edit_filtr2,'Enable','off');
    set(handles.edit21,'Enable','off');
    set(handles.popupmenu10,'Enable','off');
    Ar_galima_vykdyti(hObject, eventdata, handles);
end;
checkbox_filtr2__Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox_rf_.
function checkbox_rf__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rf_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rf_
if and(get(handles.checkbox_rf_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_rf_, 'Enable'),'on'));
    set(handles.edit_rf_,'Enable','on');
else
    set(handles.edit_rf_,'Enable','off');
end;


% --- Executes on button press in checkbox_filtr1_.
function checkbox_filtr1__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_filtr1_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_filtr1_
if and(get(handles.checkbox_filtr1_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_filtr1_, 'Enable'),'on'));
    set(handles.edit_filtr1_,'Enable','on');
else
    set(handles.edit_filtr1_,'Enable','off');
end;



% --- Executes on button press in checkbox_filtr_tinklo_.
function checkbox_filtr_tinklo__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_filtr_tinklo_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_filtr_tinklo_
if and(get(handles.checkbox_filtr_tinklo_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_filtr_tinklo_, 'Enable'),'on'));
    set(handles.edit_filtr_tinklo_,'Enable','on');
else
    set(handles.edit_filtr_tinklo_,'Enable','off');
end;


% --- Executes on button press in checkbox_kanalu_padetis_.
function checkbox_kanalu_padetis__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_kanalu_padetis_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_kanalu_padetis_
if and(get(handles.checkbox_kanalu_padetis_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_kanalu_padetis_, 'Enable'),'on'));
    set(handles.edit_kanalu_padetis_,'Enable','on');
else
    set(handles.edit_kanalu_padetis_,'Enable','off');
end;


% --- Executes on button press in checkbox_atrink_kanalus1__.
function checkbox_atrink_kanalus1___Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atrink_kanalus1__ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atrink_kanalus1__


% --- Executes on button press in checkbox_atmesk_atkarpas_dzn_.
function checkbox_atmesk_atkarpas_dzn__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atmesk_atkarpas_dzn_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atmesk_atkarpas_dzn_
if and(get(handles.checkbox_atmesk_atkarpas_dzn_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atmesk_atkarpas_dzn_, 'Enable'),'on'));
    set(handles.edit_atmesk_atkarpas_dzn_,'Enable','on');
else
    set(handles.edit_atmesk_atkarpas_dzn_,'Enable','off');
end;


% --- Executes on button press in checkbox_atmesk_kan_auto_.
function checkbox_atmesk_kan_auto__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atmesk_kan_auto_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atmesk_kan_auto_
if and(get(handles.checkbox_atmesk_kan_auto_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atmesk_kan_auto_, 'Enable'),'on'));
    set(handles.edit_atmesk_kan_auto_,'Enable','on');
else
    set(handles.edit_atmesk_kan_auto_,'Enable','off');
end;



% --- Executes on button press in checkbox_perziureti_.
function checkbox_perziureti__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_perziureti_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_perziureti_
if and(get(handles.checkbox_perziureti_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_perziureti_, 'Enable'),'on'));
    set(handles.edit_perziureti_,'Enable','on');
else
    set(handles.edit_perziureti_,'Enable','off');
end;


% --- Executes on button press in checkbox_ICA_.
function checkbox_ICA__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ICA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ICA_
if and(get(handles.checkbox_ICA_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_ICA_, 'Enable'),'on'));
    set(handles.edit_ICA_,'Enable','on');
else
    set(handles.edit_ICA_,'Enable','off');
end;


% --- Executes on button press in checkbox_atmesk_iki2s_.
function checkbox_atmesk_iki2s__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atmesk_iki2s_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atmesk_iki2s_
if and(get(handles.checkbox_atmesk_iki2s_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atmesk_iki2s_, 'Enable'),'on'));
    set(handles.edit_atmesk_iki2s_,'Enable','on');
else
    set(handles.edit_atmesk_iki2s_,'Enable','off');
end;


% --- Executes on button press in checkbox_vienoda_trukme_.
function checkbox_vienoda_trukme__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_vienoda_trukme_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_vienoda_trukme_
if and(get(handles.checkbox_vienoda_trukme_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_vienoda_trukme_, 'Enable'),'on'));
    set(handles.edit_vienoda_trukme_,'Enable','on');
else
    set(handles.edit_vienoda_trukme_,'Enable','off');
end;


% --- Executes on button press in checkbox_atrink_kanalus2_.
function checkbox_atrink_kanalus2__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atrink_kanalus2_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atrink_kanalus2_
if and(get(handles.checkbox_atrink_kanalus2_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atrink_kanalus2_, 'Enable'),'on'));
    set(handles.edit_atrink_kanalus2_,'Enable','on');
else
    set(handles.edit_atrink_kanalus2_,'Enable','off');
end;


% --- Executes on button press in checkbox_ASR_.
function checkbox_ASR__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ASR_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ASR_
if and(get(handles.checkbox_ASR_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_ASR_, 'Enable'),'on'));
    set(handles.edit_ASR_,'Enable','on');
else
    set(handles.edit_ASR_,'Enable','off');
end;


% --- Executes on button press in checkbox_MARA_.
function checkbox_MARA__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_MARA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_MARA_
if and(get(handles.checkbox_MARA_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_MARA_, 'Enable'),'on'));
    set(handles.edit_MARA_,'Enable','on');
else
    set(handles.edit_MARA_,'Enable','off');
end;


% --- Executes on button press in checkbox_filtr2_.
function checkbox_filtr2__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_filtr2_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_filtr2_
if and(get(handles.checkbox_filtr2_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_filtr2_, 'Enable'),'on'));
    set(handles.edit_filtr2_,'Enable','on');
else
    set(handles.edit_filtr2_,'Enable','off');
end;


function edit_rf_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rf as text
%        str2double(get(hObject,'String')) returns contents of edit_rf as a double


% --- Executes during object creation, after setting all properties.
function edit_rf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atrink_kanalus1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_atrink_kanalus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atrink_kanalus1 as text
%        str2double(get(hObject,'String')) returns contents of edit_atrink_kanalus1 as a double


% --- Executes during object creation, after setting all properties.
function edit_atrink_kanalus1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atrink_kanalus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filtr1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filtr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filtr1 as text
%        str2double(get(hObject,'String')) returns contents of edit_filtr1 as a double


% --- Executes during object creation, after setting all properties.
function edit_filtr1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filtr_tinklo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filtr_tinklo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filtr_tinklo as text
%        str2double(get(hObject,'String')) returns contents of edit_filtr_tinklo as a double


% --- Executes during object creation, after setting all properties.
function edit_filtr_tinklo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtr_tinklo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atmesk_atkarpas_dzn_Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_atkarpas_dzn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_atkarpas_dzn as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_atkarpas_dzn as a double


% --- Executes during object creation, after setting all properties.
function edit_atmesk_atkarpas_dzn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_atkarpas_dzn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atmesk_kan_auto_Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_kan_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_kan_auto as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_kan_auto as a double


% --- Executes during object creation, after setting all properties.
function edit_atmesk_kan_auto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_kan_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_perziureti_Callback(hObject, eventdata, handles)
% hObject    handle to edit_perziureti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_perziureti as text
%        str2double(get(hObject,'String')) returns contents of edit_perziureti as a double


% --- Executes during object creation, after setting all properties.
function edit_perziureti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_perziureti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ICA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ICA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ICA as text
%        str2double(get(hObject,'String')) returns contents of edit_ICA as a double


% --- Executes during object creation, after setting all properties.
function edit_ICA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ICA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MARA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MARA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MARA as text
%        str2double(get(hObject,'String')) returns contents of edit_MARA as a double


% --- Executes during object creation, after setting all properties.
function edit_MARA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MARA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atmesk_iki2s_Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_iki2s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_iki2s as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_iki2s as a double


% --- Executes during object creation, after setting all properties.
function edit_atmesk_iki2s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_iki2s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_vienoda_trukme_Callback(hObject, eventdata, handles)
% hObject    handle to edit_vienoda_trukme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_vienoda_trukme as text
%        str2double(get(hObject,'String')) returns contents of edit_vienoda_trukme as a double


% --- Executes during object creation, after setting all properties.
function edit_vienoda_trukme_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_vienoda_trukme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atrink_kanalus2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_atrink_kanalus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atrink_kanalus2 as text
%        str2double(get(hObject,'String')) returns contents of edit_atrink_kanalus2 as a double


% --- Executes during object creation, after setting all properties.
function edit_atrink_kanalus2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atrink_kanalus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ASR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ASR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ASR as text
%        str2double(get(hObject,'String')) returns contents of edit_ASR as a double


% --- Executes during object creation, after setting all properties.
function edit_ASR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ASR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_kanalu_padetis_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit_kanalu_padetis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_filtr2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filtr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filtr2 as text
%        str2double(get(hObject,'String')) returns contents of edit_filtr2 as a double


% --- Executes during object creation, after setting all properties.
function edit_filtr2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtr2 (see GCBO)
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



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double
id=handles.edit19;
senas=get(id,'UserData');
virtual_edit_sk_Callback(hObject, eventdata, handles, id, 1, 'x > 0');
if ~strcmp(senas,get(id,'String'));
    set(handles.edit_vienoda_trukme,'String',[ '_' num2str(get(id,'UserData')) lokaliz('seconds_short') ] );
    set(handles.edit_vienoda_trukme_,'String',[ lokaliz('_Nuosekl_apdor_default_dir_unify_duration')  ' ' num2str(get(id,'UserData')) ' ' lokaliz('seconds_short') ] );
end;

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit20, 1, 'x > 0');


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double
id=handles.edit21;
senas=get(id,'UserData');
x=real(str2num(get(handles.edit21,'String')));
%disp(x);
tinka=0;
if and(length(x) == 1, get(handles.popupmenu10,'Value') < 3 ) ;
  if x > 0;
    tinka=1;
    set(id,'UserData',regexprep(num2str(x), '[ ]*', ' '));
  end;
elseif and(length(x) == 2, get(handles.popupmenu10,'Value') > 2 ) ;
  if and(0 < x(1), x(1) < x(2));
    tinka=1;
    set(id,'UserData',regexprep(num2str(x), '[ ]*', ' '));
  end;
end;
if tinka;
    set(id,'String',get(id,'UserData'));
end;
set(id,'BackgroundColor',[1 1 tinka]);
%x=str2num(get(id,'String'));
if ~strcmp(senas,get(id,'String'));
    set(handles.edit_filtr2,'String', [ lokaliz('_Nuosekl_apdor_default_file_suffix_filter') regexprep(  num2str(get(id,'UserData')) , '[ ]*', '-')   ]  ) ;
    set(handles.edit_filtr2_,'String', [ lokaliz('_Nuosekl_apdor_default_dir_filter') ' ' regexprep(  num2str(get(id,'UserData')) , '[ ]*', '-') ' ' lokaliz('Hz') ]) ;
end;
Ar_galima_vykdyti(hObject, eventdata, handles);


function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50 as text
%        str2double(get(hObject,'String')) returns contents of edit50 as a double
id=handles.edit50;
senas=get(id,'UserData');
virtual_edit_sk_Callback(hObject, eventdata, handles, id, 1, 'x > 0');
if ~strcmp(senas,get(id,'String'));
    set(handles.edit_filtr_tinklo_,'String',[lokaliz('_Nuosekl_apdor_default_dir_filter') ' ' num2str(get(id,'UserData')) ' ' lokaliz('Hz') ]) ;
    set(handles.edit_filtr_tinklo,'String',[lokaliz('_Nuosekl_apdor_default_file_suffix_filter') num2str(get(id,'UserData')) ]) ;
end;


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_kanalu_padetis__Callback(hObject, eventdata, handles)
% hObject    handle to edit_kanalu_padetis_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kanalu_padetis_ as text
%        str2double(get(hObject,'String')) returns contents of edit_kanalu_padetis_ as a double


% --- Executes during object creation, after setting all properties.
function edit_kanalu_padetis__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kanalu_padetis_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rf__Callback(hObject, eventdata, handles)
% hObject    handle to edit_rf_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rf_ as text
%        str2double(get(hObject,'String')) returns contents of edit_rf_ as a double


% --- Executes during object creation, after setting all properties.
function edit_rf__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rf_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atrink_kanalus1__Callback(hObject, eventdata, handles)
% hObject    handle to edit_atrink_kanalus1_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atrink_kanalus1_ as text
%        str2double(get(hObject,'String')) returns contents of edit_atrink_kanalus1_ as a double


% --- Executes during object creation, after setting all properties.
function edit_atrink_kanalus1__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atrink_kanalus1_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filtr1__Callback(hObject, eventdata, handles)
% hObject    handle to edit_filtr1_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filtr1_ as text
%        str2double(get(hObject,'String')) returns contents of edit_filtr1_ as a double


% --- Executes during object creation, after setting all properties.
function edit_filtr1__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtr1_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filtr_tinklo__Callback(hObject, eventdata, handles)
% hObject    handle to edit_filtr_tinklo_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filtr_tinklo_ as text
%        str2double(get(hObject,'String')) returns contents of edit_filtr_tinklo_ as a double


% --- Executes during object creation, after setting all properties.
function edit_filtr_tinklo__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtr_tinklo_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atmesk_atkarpas_dzn__Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_atkarpas_dzn_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_atkarpas_dzn_ as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_atkarpas_dzn_ as a double


% --- Executes during object creation, after setting all properties.
function edit_atmesk_atkarpas_dzn__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_atkarpas_dzn_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atmesk_kan_auto__Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_kan_auto_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_kan_auto_ as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_kan_auto_ as a double


% --- Executes during object creation, after setting all properties.
function edit_atmesk_kan_auto__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_kan_auto_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_perziureti__Callback(hObject, eventdata, handles)
% hObject    handle to edit_perziureti_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_perziureti_ as text
%        str2double(get(hObject,'String')) returns contents of edit_perziureti_ as a double


% --- Executes during object creation, after setting all properties.
function edit_perziureti__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_perziureti_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ICA__Callback(hObject, eventdata, handles)
% hObject    handle to edit_ICA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ICA_ as text
%        str2double(get(hObject,'String')) returns contents of edit_ICA_ as a double


% --- Executes during object creation, after setting all properties.
function edit_ICA__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ICA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MARA__Callback(hObject, eventdata, handles)
% hObject    handle to edit_MARA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MARA_ as text
%        str2double(get(hObject,'String')) returns contents of edit_MARA_ as a double


% --- Executes during object creation, after setting all properties.
function edit_MARA__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MARA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atmesk_iki2s__Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_iki2s_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_iki2s_ as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_iki2s_ as a double


% --- Executes during object creation, after setting all properties.
function edit_atmesk_iki2s__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_iki2s_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_vienoda_trukme__Callback(hObject, eventdata, handles)
% hObject    handle to edit_vienoda_trukme_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_vienoda_trukme_ as text
%        str2double(get(hObject,'String')) returns contents of edit_vienoda_trukme_ as a double


% --- Executes during object creation, after setting all properties.
function edit_vienoda_trukme__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_vienoda_trukme_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atrink_kanalus2__Callback(hObject, eventdata, handles)
% hObject    handle to edit_atrink_kanalus2_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atrink_kanalus2_ as text
%        str2double(get(hObject,'String')) returns contents of edit_atrink_kanalus2_ as a double


% --- Executes during object creation, after setting all properties.
function edit_atrink_kanalus2__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atrink_kanalus2_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ASR__Callback(hObject, eventdata, handles)
% hObject    handle to edit_ASR_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ASR_ as text
%        str2double(get(hObject,'String')) returns contents of edit_ASR_ as a double


% --- Executes during object creation, after setting all properties.
function edit_ASR__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ASR_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filtr2__Callback(hObject, eventdata, handles)
% hObject    handle to edit_filtr2_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filtr2_ as text
%        str2double(get(hObject,'String')) returns contents of edit_filtr2_ as a double


% --- Executes during object creation, after setting all properties.
function edit_filtr2__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtr2_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp(get(handles.pushbutton7,'UserData'));

% Įraše nesantys kanalai interpoliuojami.

% VISI_KANALAI_64={'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'M1' 'T7' 'C3' 'Cz' 'C4' 'T8' 'M2' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8';};
% Reikalingu_kanalu_idx=listdlg('ListString', VISI_KANALAI_64,'SelectionMode','multiple','PromptString','Pasirinkite paliekamus kanalus:','InitialValue',get(handles.pushbutton7,'UserData') );
% if isempty(Reikalingu_kanalu_idx); return; end;
% disp(Reikalingu_kanalu_idx);
% pasirinkti_kanalai=VISI_KANALAI_64(Reikalingu_kanalu_idx);
% disp(pasirinkti_kanalai);
% set(handles.pushbutton7,'UserData',Reikalingu_kanalu_idx);
% if Reikalingu_kanalu_idx ~= 0 ;
%     set(handles.text9,'String',length(Reikalingu_kanalu_idx));
%     pasirinkti_kanalai_str=[pasirinkti_kanalai{1}];
%     for i=2:length(pasirinkti_kanalai);
%         pasirinkti_kanalai_str=[pasirinkti_kanalai_str ' ' pasirinkti_kanalai{i}];
%     end;
%     set(handles.text9,'TooltipString',pasirinkti_kanalai_str);
%     set(handles.pushbutton7,'BackgroundColor','remove');
% else
%     set(handles.pushbutton7,'BackgroundColor',[1 1 0]);
%     set(handles.text9,'String','?');
%     set(handles.text9,'TooltipString','');
% end;

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
set(handles.pushbutton7,'Enable','off'); drawnow;
[~,visi_galimi_kanalai,bendri_kanalai]=eeg_kanalu_sarasas (get(handles.edit1,'String'), RINKMENOS);
set(handles.pushbutton7,'Enable','on');
if isempty(visi_galimi_kanalai);
    wf=warndlg(lokaliz('No names of channels found.'),lokaliz('Selection of channels'));
    uiwait(wf);
    %return;
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
if isempty(visi_galimi_kanalai);
    nebendri_idx=[];
    dar_kiti_kanalai=sort(VISI_KANALAI_64);
else
    nebendri_idx=find(ismember(visi_galimi_kanalai,bendri_kanalai) == 0);
    dar_kiti_kanalai=sort(VISI_KANALAI_64(find(ismember(VISI_KANALAI_64,visi_galimi_kanalai)==0)));
end;
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(not common:)') visi_galimi_kanalai{nebendri_idx} };
   pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_kanalai);
   if ~pateikiami_bendri_v;
       pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_kanalai) + pateikiami_bendri_v + 1 ) ];
       disp(pradinis_pasirinkimas);
   end;
end;
pateikiami_kiti_v=0;
if ~isempty(dar_kiti_kanalai);
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(other:)') dar_kiti_kanalai{:} };
   pateikiami_kiti_v=1+pateikiami_bendri_v + (pateikiami_nebendri_v ~= 0) + length(visi_galimi_kanalai);
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
% Ankstesni_kanalai=get(handles.text9,'TooltipString');
Ankstesni_kanalai=get(handles.pushbutton7,'UserData');
if ~isempty(Ankstesni_kanalai);
%   Ankstesni_kanalai=textscan(Ankstesni_kanalai,'%s','delimiter',' ');
%   senas=Ankstesni_kanalai{1};
%   if ~isempty(senas);
%     pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,senas)==1);
%   end;
    pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,Ankstesni_kanalai)==1);
end;
if ~iscellstr(pateikiami_kanalai);
    warning(lokaliz('unexpected channels types.'),lokaliz('Selection of channels'));
    disp(pateikiami_kanalai);
    return;
end;
pasirinkti_kanalai_idx=listdlg('ListString', pateikiami_kanalai,...
    'SelectionMode','multiple',...
    'PromptString', lokaliz('Select channels:'),...
    'InitialValue',pradinis_pasirinkimas ,...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
if isempty(pasirinkti_kanalai_idx); return ; end;
%disp(length(pasirinkti_kanalai_idx));
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
pasirinkti_kanalai_idx_=pasirinkti_kanalai_idx(...
   find(ismember(pasirinkti_kanalai_idx, ...
   [pateikiami_bendri_v pateikiami_nebendri_v pateikiami_kiti_v])==0));
pasirinkti_kanalai=unique({pasirinkti_kanalai{:} pateikiami_kanalai{pasirinkti_kanalai_idx_}});

pasirinktu_leidziamu_kanalu_idx=find(ismember(VISI_KANALAI_64,pasirinkti_kanalai)==1);
%set(handles.pushbutton7,'UserData',pasirinktu_leidziamu_kanalu_idx);
pasirinkti_leidziami_kanalai=VISI_KANALAI_64(pasirinktu_leidziamu_kanalu_idx);
if length(pasirinkti_leidziami_kanalai) ~= length(pasirinkti_kanalai);
   pasirinkti_neleidziami_kanalai=pasirinkti_kanalai(find(ismember(pasirinkti_kanalai,pasirinkti_leidziami_kanalai)==0));
   warning([sprintf('%s\n', [lokaliz('Internal schema does not have channels for interpolation:' )]) ...
            sprintf('''%s'' ', pasirinkti_neleidziami_kanalai{:}) ]);
   %disp(pasirinkti_neleidziami_kanalai);
   warndlg([lokaliz('Internal schema does not have channels for interpolation:') {} pasirinkti_neleidziami_kanalai],lokaliz('Selection of channels'));
end;

if ~isempty(pasirinktu_leidziamu_kanalu_idx) ;
    pasirinkti_kanalai_str=sprintf('%s ', pasirinkti_kanalai{:});
    pasirinkti_kanalai_str=regexprep(pasirinkti_kanalai_str, ' $', '');
    disp([ '''' regexprep(pasirinkti_kanalai_str, ' ', ''' ''') '''' ]);

    set(handles.text9,'String',length(pasirinktu_leidziamu_kanalu_idx));
    pasirinkti_leidziami_kanalai_str=[pasirinkti_leidziami_kanalai{1}];
    for i=2:length(pasirinkti_leidziami_kanalai);
        pasirinkti_leidziami_kanalai_str=[pasirinkti_leidziami_kanalai_str ' ' pasirinkti_leidziami_kanalai{i}];
    end;
    set(handles.text9,'TooltipString',pasirinkti_leidziami_kanalai_str);
    set(handles.pushbutton7,'BackgroundColor','remove');
    set(handles.pushbutton7,'UserData',pasirinkti_leidziami_kanalai);
else
    set(handles.text9,'String','?');
    set(handles.text9,'TooltipString','');
    set(handles.pushbutton7,'BackgroundColor',[1 1 0]);
    set(handles.pushbutton7,'UserData',{});
end;
set(handles.checkbox_atrink_kanalus2,'UserData','1');


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp(get(handles.pushbutton9,'UserData'));

VISI_KANALAI_66={'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'M1' 'T7' 'C3' 'Cz' 'C4' 'T8' 'M2' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'EOG' 'EOGh';};
% Reikalingu_kanalu_idx=listdlg('ListString', VISI_KANALAI_66,...
%     'SelectionMode','multiple',...
%     'PromptString','Pasirinkite paliekamus kanalus:',...
%     'InitialValue',get(handles.pushbutton9,'UserData') );
% if isempty(Reikalingu_kanalu_idx); return; end;
% disp(Reikalingu_kanalu_idx);
% disp(VISI_KANALAI_66(Reikalingu_kanalu_idx));
% set(handles.pushbutton9,'UserData',Reikalingu_kanalu_idx);
% if Reikalingu_kanalu_idx ~= 0 ;
%     set(handles.text8,'String',length(Reikalingu_kanalu_idx));
%     set(handles.pushbutton9,'Value',Reikalingu_kanalu_idx);
%     set(handles.pushbutton9,'BackgroundColor','remove');
% else
%     set(handles.pushbutton9,'Value',0);
%     set(handles.pushbutton9,'BackgroundColor',[1 1 0]);
%     set(handles.text8,'String','?');
% end;

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
set(handles.pushbutton9,'Enable','off'); drawnow;
[~,visi_galimi_kanalai,bendri_kanalai]=eeg_kanalu_sarasas (get(handles.edit1,'String'), RINKMENOS);
set(handles.pushbutton9,'Enable','on');
if isempty(visi_galimi_kanalai);
    wf=warndlg(lokaliz('No names of channels found.'),lokaliz('Selection of channels'));
    uiwait(wf);
    %return;
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
if isempty(visi_galimi_kanalai);
    nebendri_idx=[];
    dar_kiti_kanalai=sort(VISI_KANALAI_66);
else
    nebendri_idx=find(ismember(visi_galimi_kanalai,bendri_kanalai) == 0);
    dar_kiti_kanalai=[];
    %dar_kiti_kanalai=sort(VISI_KANALAI_66(find(ismember(VISI_KANALAI_66,visi_galimi_kanalai)==0)));
end;
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(not common:)') visi_galimi_kanalai{nebendri_idx} };
   pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_kanalai);
   if ~pateikiami_bendri_v;
       pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_kanalai) + pateikiami_bendri_v + 1 ) ];
   end;
end;
pateikiami_kiti_v=0;
if ~isempty(dar_kiti_kanalai);
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(other:)') dar_kiti_kanalai{:} };
   pateikiami_kiti_v=1+pateikiami_bendri_v + (pateikiami_nebendri_v ~= 0) + length(visi_galimi_kanalai);
   disp(pateikiami_kiti_v);
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
%Ankstesni_kanalai=get(handles.text8,'TooltipString');
Ankstesni_kanalai=get(handles.pushbutton9,'UserData');
if ~isempty(Ankstesni_kanalai);
  %Ankstesni_kanalai=textscan(Ankstesni_kanalai,'%s','delimiter',' ');
  %senas=Ankstesni_kanalai{1};
  %if ~isempty(senas);
  %  pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,senas)==1);
  %end;
  pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,Ankstesni_kanalai)==1);
end;
if ~iscellstr(pateikiami_kanalai);
    warning(lokaliz('unexpected channels types.'),lokaliz('Selection of channels'));
    disp(pateikiami_kanalai);
    return;
end;
pasirinkti_kanalai_idx=listdlg('ListString', pateikiami_kanalai,...
    'SelectionMode','multiple',...
    'PromptString', lokaliz('Select channels:'),...
    'InitialValue',pradinis_pasirinkimas ,...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
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
pasirinkti_kanalai_idx_=pasirinkti_kanalai_idx(find(ismember(pasirinkti_kanalai_idx, [pateikiami_bendri_v pateikiami_nebendri_v pateikiami_kiti_v])==0));
pasirinkti_kanalai=unique({pasirinkti_kanalai{:} pateikiami_kanalai{pasirinkti_kanalai_idx_}});
pasirinkti_kanalai_str=[pasirinkti_kanalai{1}];
for i=2:length(pasirinkti_kanalai);
    pasirinkti_kanalai_str=[pasirinkti_kanalai_str ' ' pasirinkti_kanalai{i}];
end;
disp([ '''' regexprep(pasirinkti_kanalai_str, ' ', ''' ''') '''' ]);
if ~isempty(pasirinkti_kanalai_str) ;
    set(handles.text8,'String',length(pasirinkti_kanalai));
    set(handles.text8,'TooltipString',pasirinkti_kanalai_str);
    set(handles.pushbutton9,'BackgroundColor','remove');
    set(handles.pushbutton9,'UserData',pasirinkti_kanalai);
else
    set(handles.text8,'String','?');
    set(handles.text8,'TooltipString','');
    set(handles.pushbutton9,'BackgroundColor',[1 1 0]);
    set(handles.pushbutton9,'UserData',{});
end;
set(handles.checkbox_atrink_kanalus1,'UserData','1');



function [varargout] = Tikras_Kelias(kelias_tikrinimui)
kelias_dabar=pwd;
try
    cd(kelias_tikrinimui);
catch err;
end;
varargout{1}=pwd;
cd(kelias_dabar);


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8


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
if ~isempty(findobj('-regexp','name','nuoseklus_apdorojimas')) ;
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
                        %        pop_nuoseklus_apdorojimas;
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

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
if get(handles.popupmenu4,'Value') > 2;
    dabar=str2num(get(handles.edit59,'String'));
    maxim=str2num(get(handles.text_apdorotini_kanalai,'String'));
    if ~isempty(maxim);
        if dabar > maxim ;
            set(handles.edit59,'String',num2str(maxim));
        end;
    end;
    set(handles.edit59,'Visible','on');
else
    set(handles.edit59,'Visible','off');
end;

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
strl=get(handles.popupmenu5,'String');
set(handles.popupmenu5,'TooltipString',strl{get(handles.popupmenu5,'Value')});

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_atmesk_kan_auto_slenkstis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_kan_auto_slenkstis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_kan_auto_slenkstis as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_kan_auto_slenkstis as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit_atmesk_kan_auto_slenkstis, 1, 'true');


% --- Executes during object creation, after setting all properties.
function edit_atmesk_kan_auto_slenkstis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_kan_auto_slenkstis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit40, 2, 'and(0 < x(1), x(1) < x(2))');


% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox41.
function checkbox41_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox41


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
strl=get(handles.popupmenu7,'String');
set(handles.popupmenu7,'TooltipString',strl{get(handles.popupmenu7,'Value')});
pasirinkimas=get(handles.popupmenu7,'Value');
if (pasirinkimas > 4) && (pasirinkimas < 8);
    if isempty(which('pop_selectcomps_MARA.m'));
        disp(' ');
        disp([lokaliz('nerasta') ': pop_selectcomps_MARA.m' ]);
        disp([ lokaliz('Please install plugin') ' MARA <http://www.user.tu-berlin.de/irene.winkler/artifacts/>' ]);
        warndlg([ lokaliz('Please install plugin') ' MARA' ], lokaliz('Please install plugin'));
    end;
end;

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox43.
function checkbox43_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox43


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
strl=get(handles.popupmenu8,'String');
set(handles.popupmenu8,'TooltipString',strl{get(handles.popupmenu8,'Value')});


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_perziureti_ICA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_perziureti_ICA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_perziureti_ICA as text
%        str2double(get(hObject,'String')) returns contents of edit_perziureti_ICA as a double


% --- Executes during object creation, after setting all properties.
function edit_perziureti_ICA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_perziureti_ICA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_perziureti_ICA_.
function checkbox_perziureti_ICA__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_perziureti_ICA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_perziureti_ICA_
if and(get(handles.checkbox_perziureti_ICA_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_perziureti_ICA_, 'Enable'),'on'));
    set(handles.edit_perziureti_ICA_,'Enable','on');
else
    set(handles.edit_perziureti_ICA_,'Enable','off');
end;



function edit_perziureti_ICA__Callback(hObject, eventdata, handles)
% hObject    handle to edit_perziureti_ICA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_perziureti_ICA_ as text
%        str2double(get(hObject,'String')) returns contents of edit_perziureti_ICA_ as a double


% --- Executes during object creation, after setting all properties.
function edit_perziureti_ICA__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_perziureti_ICA_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit43 as text
%        str2double(get(hObject,'String')) returns contents of edit43 as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit43, 1, 'true');


% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit44, 2, 'and(0 < x(1), x(1) < x(2))');


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_epoch.
function checkbox_epoch_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_epoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_epoch
if and(get(handles.checkbox_epoch, 'Value') == 1, ...
        strcmp(get(handles.checkbox_epoch, 'Enable'),'on'));
    set(handles.checkbox_epoch_,'Enable','on');
    set(handles.checkbox_epoch_b,'Enable','on');
    set(handles.edit_epoch,'Enable','on');
    set(handles.edit_epoch_iv,'Enable','on');
    set(handles.edit_epoch_t,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    edit_epoch_iv_Callback(hObject, eventdata, handles);
else
    set(handles.checkbox_epoch_,'Enable','off');
    set(handles.checkbox_epoch_b,'Enable','off');
    set(handles.edit_epoch,'Enable','off');
    set(handles.edit_epoch_iv,'Enable','off');
    set(handles.edit_epoch_t,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
end;
checkbox_epoch__Callback(hObject, eventdata, handles);
checkbox_epoch_b_Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);



function edit_epoch_iv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epoch_iv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epoch_iv as text
%        str2double(get(hObject,'String')) returns contents of edit_epoch_iv as a double
elementas=handles.edit_epoch_iv;
set(elementas,'BackgroundColor',[1 1 1]);
str=get(elementas,'String');
x=unique(real(str2num(str)));
if length(x) > 0 ;
    x_txt=num2str2(x);
    set(elementas,'UserData',regexprep(x_txt, '[ ]*', ' '));
    set(handles.pushbutton13,'UserData',...
        cellfun(@(i) num2str(x(i)), ...
        num2cell(1:length(x)),...
        'UniformOutput', false));
elseif isempty(str);
    set(elementas,'UserData','');
    set(handles.pushbutton13,'UserData',{});
else
    iv=get(handles.pushbutton13,'UserData');
    try
        senas_str=regexprep(sprintf('%s ', iv{:}),' $','');
        senas_x=str2num(senas_str);
        if ~isempty(senas_x); senas_str=num2str2(senas_x); end;
        set(elementas,'UserData',senas_str);
    catch err;
        %set(elementas,'UserData',sprintf('%d ', iv));
    end;
    wrn=warning('off','backtrace');
    warning(lokaliz('This version allow to select any real events from dataset, but manually you can enter only numbers.'));
    warning(wrn.state, 'backtrace');
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
str=get(elementas,'String');
set(elementas,'TooltipString',str);
if ~isempty(str);
    set(elementas,'BackgroundColor',[1 1 1]);
else
    set(elementas,'BackgroundColor',[1 1 0]);
end;
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



function edit_epoch_t_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epoch_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epoch_t as text
%        str2double(get(hObject,'String')) returns contents of edit_epoch_t as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit_epoch_t, 2, 'x(1) < x(2)');


% --- Executes during object creation, after setting all properties.
function edit_epoch_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epoch_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_epoch_b_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epoch_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epoch_b as text
%        str2double(get(hObject,'String')) returns contents of edit_epoch_b as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit_epoch_b, 2, 'x(1) < x(2)');


% --- Executes during object creation, after setting all properties.
function edit_epoch_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epoch_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_epoch_b.
function checkbox_epoch_b_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_epoch_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_epoch_b
if and(get(handles.checkbox_epoch_b, 'Value') == 1, ...
        strcmp(get(handles.checkbox_epoch_b, 'Enable'),'on'));
    set(handles.edit_epoch_b,'Enable','on');
else
    set(handles.edit_epoch_b,'Enable','off');
end;



function edit_epoch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epoch as text
%        str2double(get(hObject,'String')) returns contents of edit_epoch as a double


% --- Executes during object creation, after setting all properties.
function edit_epoch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_epoch_.
function checkbox_epoch__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_epoch_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_epoch_
if and(get(handles.checkbox_epoch_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_epoch_, 'Enable'),'on'));
    set(handles.edit_epoch_,'Enable','on');
else
    set(handles.edit_epoch_,'Enable','off');
end;



function edit_epoch__Callback(hObject, eventdata, handles)
% hObject    handle to edit_epoch_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epoch_ as text
%        str2double(get(hObject,'String')) returns contents of edit_epoch_ as a double


% --- Executes during object creation, after setting all properties.
function edit_epoch__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epoch_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in checkbox_perziureti_demesio.
function checkbox_perziureti_demesio_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_perziureti_demesio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_perziureti_demesio

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


% --- Executes on button press in checkbox_atrink_kanalus1_.
function checkbox_atrink_kanalus1__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atrink_kanalus1_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atrink_kanalus1_
if and(get(handles.checkbox_atrink_kanalus1_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atrink_kanalus1_, 'Enable'),'on'));
    set(handles.edit_atrink_kanalus1_,'Enable','on');
else
    set(handles.edit_atrink_kanalus1_,'Enable','off');
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


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9
edit3_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10
edit21_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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
set(handles.pushbutton7,'TooltipString',lokaliz('Channels'));
set(handles.pushbutton9,'TooltipString',lokaliz('Channels'));
set(handles.pushbutton_apdorotini_kanalai,'String',lokaliz('Channels'));
set(handles.pushbutton_apdorotini_kanalai,'TooltipString',lokaliz('Nuoseklus apdorojimas: kanalai keliems darbams'));
set(handles.pushbutton13,'TooltipString',lokaliz('Events'));
set(handles.uipanel3,'Title',lokaliz('Options'));
set(handles.uipanel4,'Title',lokaliz('File filter'));
set(handles.uipanel5,'Title',lokaliz('Files for work'));
set(handles.uipanel15,'Title',lokaliz('File loading options'));
set(handles.uipanel16,'Title',lokaliz('File saving options'));
set(handles.uipanel6,'Title',lokaliz('Data processing functions'));
set(handles.uipanel11,'Title',lokaliz('Suffix and subdirectory'));
set(handles.checkbox_uzverti_pabaigus,'String',lokaliz('Close when complete'));
set(handles.checkbox_baigti_anksciau,'String',lokaliz('Break work'));
set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'String',lokaliz('Go to saved files directory when completed'));
set(handles.checkbox_pabaigus_atverti,'String',lokaliz('Load saved files in EEGLAB when completed'));
%set(handles.radiobutton_cnt_set,'String',lokaliz('  *.cnt or *.set'));
set(handles.radiobutton6,'String',lokaliz('through data'));
set(handles.radiobutton7,'String',lokaliz('through functions'));
set(handles.text7,'String', lokaliz('After interim saved job go'));
set(handles.text19,'String', lokaliz('# of done jobs for subdir names'));
set(handles.text15,'String', lokaliz('threshold_a_bit_shorter'));
set(handles.text11,'String', lokaliz('threshold_short'));
set(handles.text10,'String', lokaliz('Hz'));
set(handles.text14,'String', lokaliz('Hz'));
set(handles.text21,'String', lokaliz('Hz'));
set(handles.text26,'String', lokaliz('Hz'));
set(handles.text27,'String', lokaliz('Hz'));
set(handles.text17,'String', lokaliz('seconds_short'));
set(handles.text28,'String', lokaliz('seconds_short'));
set(handles.text29,'String', lokaliz('seconds_short'));
set(handles.text30,'String', lokaliz('microV'));
set(handles.text31,'String', lokaliz('miliseconds_window'));
set(handles.text_failu_filtras1,'String',lokaliz('Show_filenames_filter:'));
set(handles.text_failu_filtras2,'String',lokaliz('Select_filenames_filter:'));

set(handles.checkbox_kanalu_padetis,      'String', lokaliz('Set channel positions_verb') );
set(handles.checkbox_rf,                  'String', lokaliz('Re-reference'));
set(handles.checkbox_filtr1,              'String', lokaliz('Filter'));
set(handles.checkbox_filtr2,              'String', lokaliz('Filter'));
set(handles.checkbox_filtr_tinklo,        'String', lokaliz('Filter power-line noise'));
set(handles.checkbox_atrink_kanalus1,     'String', lokaliz('Select channels to leave'));
set(handles.checkbox_atrink_kanalus1__,   'String', lokaliz('mandatory_channels'));
set(handles.checkbox_atmesk_atkarpas_amp, 'String', lokaliz('Reject intervals (amplit)'));
set(handles.checkbox_atmesk_atkarpas_dzn, 'String', lokaliz('Reject intervals (freq)'));
set(handles.checkbox_atmesk_kan_auto,     'String', lokaliz('Reject chann. by spectr.'));
set(handles.checkbox_perziureti,          'String', lokaliz('Review data manually'));
set(handles.checkbox_perziureti_demesio,  'String', lokaliz('Confirm to continue'));
set(handles.checkbox_atmesk_iki2s,        'String',[lokaliz('Reject intervals between boundaries shorter than') ]);
set(handles.checkbox_vienoda_trukme,      'String',[lokaliz('Cut to have same duration')]);
set(handles.checkbox_ICA,                 'String', lokaliz('ICA'));
set(handles.checkbox_MARA,                'String', lokaliz('MARA'));
set(handles.checkbox_atrink_kanalus2,     'String', lokaliz('Interpoliuoti kanalus'));
set(handles.checkbox_atrink_kanalus2A,    'String', lokaliz('Atmesti nepasirinktus'));
set(handles.checkbox_ASR,                 'String', lokaliz('ASR tool for artefacts auto-removing'));
set(handles.checkbox_perziureti_ICA,      'String', lokaliz('Review ICA'));
set(handles.checkbox_epoch,               'String', lokaliz('Epoch. by'));
set(handles.checkbox_epoch_b,             'String', lokaliz('baseline_short'));

set(handles.popupmenu3,'String', { ...
   lokaliz('average_reference') ...
   lokaliz('M1_M2_reference') ...
   lokaliz('Cz_reference') });

set(handles.popupmenu5,'String', { ...
   lokaliz('clasify only'        ) ...
   lokaliz('reject automatically') ...
   lokaliz('view traditionally'  ) ...
   lokaliz('view via MARA'       ) ...
   lokaliz('view detailed'       ) });

set(handles.popupmenu7,'String', { ...
   lokaliz('traditionally'        ) ...
   lokaliz('trad + channels'      ) ...
   lokaliz('trad + ICA comps'     ) ...
   lokaliz('only ICA curves'      ) ...
   lokaliz('with spectrum'        ) ...
   lokaliz('sp. + channel curves' ) ...
   lokaliz('sp. + MARA info'      ) ...
   lokaliz('nothing'              ) });

set(handles.popupmenu8,'String', { ...
   lokaliz('reject immediately'   ) ...
  [lokaliz('wait for confirmation') ' (EEGLAB)'] ...
  [lokaliz('wait for confirmation') ' (Darbeliai)'] ...
   lokaliz('isiminti pasirinkima' ) ...
   lokaliz('nesaugoti'            ) });

set(handles.popupmenu9,'String', { ...
   lokaliz('(filter) high-pass') ...
   lokaliz('(filter) low-pass' ) ...
   lokaliz('(filter) band-pass') ...
   lokaliz('(filter) notch'    )  });

set(handles.popupmenu10,'String', { ...
   lokaliz('(filter) high-pass') ...
   lokaliz('(filter) low-pass' ) ...
   lokaliz('(filter) band-pass') ...
   lokaliz('(filter) notch'    ) });

set(handles.popupmenu4,'String', {'N' 'N-1' '...'});

set(handles.edit_kanalu_padetis,       'String', lokaliz('_Nuosekl_apdor_default_file_suffix_chan_position'         ));
set(handles.edit_rf,                   'String', lokaliz('_Nuosekl_apdor_default_file_suffix_rereference'           ));
set(handles.edit_atrink_kanalus1,      'String', lokaliz('_Nuosekl_apdor_default_file_suffix_select_chan1'          ));
set(handles.edit_filtr1,               'String', lokaliz('_Nuosekl_apdor_default_file_suffix_filter1'               ));
set(handles.edit_filtr_tinklo,         'String', lokaliz('_Nuosekl_apdor_default_file_suffix_filter_line'           ));
set(handles.edit_atmesk_atkarpas_amp,  'String', lokaliz('_Nuosekl_apdor_default_file_suffix_reject_artef_intervals_amp'));
set(handles.edit_atmesk_atkarpas_dzn,  'String', lokaliz('_Nuosekl_apdor_default_file_suffix_reject_artef_intervals_dzn'));
set(handles.edit_atmesk_kan_auto,      'String', lokaliz('_Nuosekl_apdor_default_file_suffix_reject_artef_chan'     ));
set(handles.edit_ASR,                  'String', lokaliz('_Nuosekl_apdor_default_file_suffix_ASR'                   ));
set(handles.edit_perziureti,           'String', lokaliz('_Nuosekl_apdor_default_file_suffix_review'                ));
set(handles.edit_ICA,                  'String', lokaliz('_Nuosekl_apdor_default_file_suffix_ICA'                   ));
set(handles.edit_MARA,                 'String', lokaliz('_Nuosekl_apdor_default_file_suffix_MARA'                  ));
set(handles.edit_perziureti_ICA,       'String', lokaliz('_Nuosekl_apdor_default_file_suffix_review_ICA'            ));
set(handles.edit_atmesk_iki2s,         'String', lokaliz('_Nuosekl_apdor_default_file_suffix_reject_short_interval' ));
set(handles.edit_vienoda_trukme,       'String', lokaliz('_Nuosekl_apdor_default_file_suffix_unify_duration'        ));
set(handles.edit_atrink_kanalus2,      'String', lokaliz('_Nuosekl_apdor_default_file_suffix_select_chan2'          ));
set(handles.edit_filtr2,               'String', lokaliz('_Nuosekl_apdor_default_file_suffix_filter2'               ));
set(handles.edit_epoch,                'String', lokaliz('_Nuosekl_apdor_default_file_suffix_epoch'                 ));

set(handles.edit_kanalu_padetis_,       'String', lokaliz('_Nuosekl_apdor_default_dir_chan_position'         ));
set(handles.edit_rf_,                   'String', lokaliz('_Nuosekl_apdor_default_dir_rereference'           ));
set(handles.edit_atrink_kanalus1_,      'String', lokaliz('_Nuosekl_apdor_default_dir_select_chan1'          ));
set(handles.edit_filtr1_,               'String', lokaliz('_Nuosekl_apdor_default_dir_filter1'               ));
set(handles.edit_filtr_tinklo_,         'String', lokaliz('_Nuosekl_apdor_default_dir_filter_line'           ));
set(handles.edit_atmesk_atkarpas_amp_,  'String', lokaliz('_Nuosekl_apdor_default_dir_reject_artef_intervals_amp'));
set(handles.edit_atmesk_atkarpas_dzn_,  'String', lokaliz('_Nuosekl_apdor_default_dir_reject_artef_intervals_dzn'));
set(handles.edit_atmesk_kan_auto_,      'String', lokaliz('_Nuosekl_apdor_default_dir_reject_artef_chan'     ));
set(handles.edit_ASR_,                  'String', lokaliz('_Nuosekl_apdor_default_dir_ASR'                   ));
set(handles.edit_perziureti_,           'String', lokaliz('_Nuosekl_apdor_default_dir_review'                ));
set(handles.edit_ICA_,                  'String', lokaliz('_Nuosekl_apdor_default_dir_ICA'                   ));
set(handles.edit_MARA_,                 'String', lokaliz('_Nuosekl_apdor_default_dir_MARA'                  ));
set(handles.edit_perziureti_ICA_,       'String', lokaliz('_Nuosekl_apdor_default_dir_review_ICA'            ));
set(handles.edit_atmesk_iki2s_,         'String', lokaliz('_Nuosekl_apdor_default_dir_reject_short_interval' ));
set(handles.edit_vienoda_trukme_,       'String', lokaliz('_Nuosekl_apdor_default_dir_unify_duration'        ));
set(handles.edit_atrink_kanalus2_,      'String', lokaliz('_Nuosekl_apdor_default_dir_select_chan2'          ));
set(handles.edit_filtr2_,               'String', lokaliz('_Nuosekl_apdor_default_dir_filter2'               ));
set(handles.edit_epoch_,                'String', lokaliz('_Nuosekl_apdor_default_dir_epoch'                 ));

set(handles.edit59,'TooltipString', lokaliz('Number of independent components'));


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
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
set(handles.pushbutton13,'Enable','off'); drawnow;
[pasirinkti_ivykiai]=drb_uzklausa('ivykiai', ...
    get(handles.edit1,'String'), RINKMENOS, get(handles.pushbutton13,'UserData'));
set(handles.pushbutton13,'Enable','on');
if isempty(pasirinkti_ivykiai); return; end;
pasirinkti_ivykiai_str=pasirinkti_ivykiai{1};
for i=2:length(pasirinkti_ivykiai);
    pasirinkti_ivykiai_str=[pasirinkti_ivykiai_str ' ' pasirinkti_ivykiai{i}];
end;
set(handles.pushbutton13,'UserData',pasirinkti_ivykiai);
set(handles.edit_epoch_iv,'TooltipString',pasirinkti_ivykiai_str);
set(handles.edit_epoch_iv,'String',pasirinkti_ivykiai_str);
%set(handles.edit_epoch_iv,'UserData',pasirinkti_ivykiai_str);
if ~isempty(str2num(pasirinkti_ivykiai_str));
    edit_epoch_iv_Callback(hObject, eventdata, handles);
else
    set(handles.edit_epoch_iv,'BackgroundColor',[1 1 1]);
end;
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12
kanalu_failai=get(handles.popupmenu12,'String');
kanalu_failas=kanalu_failai{get(handles.popupmenu12,'Value')};
set(handles.popupmenu12,'TooltipString',kanalu_failas);

% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f,p]=uigetfile('*.elp;*.elc;*.loc;*.locs;*.eloc;*.sph;*.xyz;*.asc;*.sfp;*.ced;*.dat');
if f;
   nauj=fullfile(p,f);
   seni=get(handles.popupmenu12,'String');
   if ~ismember(nauj,seni);
      set(handles.popupmenu12,'String',{seni{:} nauj});
      set(handles.popupmenu12,'Value',1+length(seni));
   end;
end;


function edit_atmesk_atkarpas_amp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_atkarpas_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_atkarpas_amp as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_atkarpas_amp as a double


% --- Executes during object creation, after setting all properties.
function edit_atmesk_atkarpas_amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_atkarpas_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_atmesk_atkarpas_amp_.
function checkbox_atmesk_atkarpas_amp__Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_atmesk_atkarpas_amp_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_atmesk_atkarpas_amp_
if and(get(handles.checkbox_atmesk_atkarpas_amp_, 'Value') == 1, ...
        strcmp(get(handles.checkbox_atmesk_atkarpas_amp_, 'Enable'),'on'));
    set(handles.edit_atmesk_atkarpas_amp_,'Enable','on');
else
    set(handles.edit_atmesk_atkarpas_amp_,'Enable','off');
end;


function edit_atmesk_atkarpas_amp__Callback(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_atkarpas_amp_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_atmesk_atkarpas_amp_ as text
%        str2double(get(hObject,'String')) returns contents of edit_atmesk_atkarpas_amp_ as a double


% --- Executes during object creation, after setting all properties.
function edit_atmesk_atkarpas_amp__CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_atmesk_atkarpas_amp_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit57_Callback(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit57 as text
%        str2double(get(hObject,'String')) returns contents of edit57 as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit57, 1, 'x > 0');


% --- Executes during object creation, after setting all properties.
function edit57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit58_Callback(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit58 as text
%        str2double(get(hObject,'String')) returns contents of edit58 as a double
id=handles.edit58;
x=real(str2num(get(id,'String')));
if length(x) == 2 ;
    if x(1) < x(2);
        set(id,'UserData',regexprep(num2str(x), '[ ]*', ' '));
    end;
end;
if length(x) == 1 ;
    set(id,'UserData',regexprep(num2str(x), '[ ]*', ' '));
end;
set(id,'String',num2str(get(id,'UserData')));
set(id,'BackgroundColor',[1 1 1]);


% --- Executes during object creation, after setting all properties.
function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_apdorotini_kanalai.
function pushbutton_apdorotini_kanalai_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_apdorotini_kanalai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

VISI_KANALAI_66={'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'M1' 'T7' 'C3' 'Cz' 'C4' 'T8' 'M2' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'EOG' 'EOGh';};

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
set(handles.pushbutton_apdorotini_kanalai,'Enable','off'); drawnow;
[~,visi_galimi_kanalai,bendri_kanalai]=eeg_kanalu_sarasas (get(handles.edit1,'String'), RINKMENOS);
set(handles.pushbutton_apdorotini_kanalai,'Enable','on');
if isempty(visi_galimi_kanalai);
    wf=warndlg(lokaliz('No names of channels found.'),lokaliz('Selection of channels'));
    uiwait(wf);
    %return;
end;
if get(handles.checkbox_atrink_kanalus1,'Value');
    visi_galimi_kanalai=intersect(visi_galimi_kanalai,get(handles.pushbutton9,'UserData'));
    bendri_kanalai=intersect(bendri_kanalai,get(handles.pushbutton9,'UserData'));
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
if isempty(visi_galimi_kanalai);
    nebendri_idx=[];
    dar_kiti_kanalai=sort(VISI_KANALAI_66);
else
    nebendri_idx=find(ismember(visi_galimi_kanalai,bendri_kanalai) == 0);
    dar_kiti_kanalai=[];
    %dar_kiti_kanalai=sort(VISI_KANALAI_66(find(ismember(VISI_KANALAI_66,visi_galimi_kanalai)==0)));
end;
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(not common:)') visi_galimi_kanalai{nebendri_idx} };
   pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_kanalai);
   if ~pateikiami_bendri_v;
       pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_kanalai) + pateikiami_bendri_v + 1 ) ];
   end;
end;
pateikiami_kiti_v=0;
if ~isempty(dar_kiti_kanalai);
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(other:)') dar_kiti_kanalai{:} };
   pateikiami_kiti_v=1+pateikiami_bendri_v + (pateikiami_nebendri_v ~= 0) + length(visi_galimi_kanalai);
   disp(pateikiami_kiti_v);
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
%Ankstesni_kanalai=get(handles.text8,'TooltipString');
Ankstesni_kanalai=get(handles.pushbutton_apdorotini_kanalai,'UserData');
if ~isempty(Ankstesni_kanalai);
  %Ankstesni_kanalai=textscan(Ankstesni_kanalai,'%s','delimiter',' ');
  %senas=Ankstesni_kanalai{1};
  %if ~isempty(senas);
  %  pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,senas)==1);
  %end;
  pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,Ankstesni_kanalai)==1);
end;
if ~iscellstr(pateikiami_kanalai);
    warning(lokaliz('unexpected channels types.'),lokaliz('Selection of channels'));
    disp(pateikiami_kanalai);
    return;
end;
pasirinkti_kanalai_idx=listdlg('ListString', pateikiami_kanalai,...
    'SelectionMode','multiple',...
    'PromptString', lokaliz('Select channels:'),...
    'InitialValue',pradinis_pasirinkimas ,...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
if isempty(pasirinkti_kanalai_idx);
    set(handles.text_apdorotini_kanalai,'String',lokaliz('all'));
    set(handles.text_apdorotini_kanalai,'TooltipString','');
    set(handles.pushbutton_apdorotini_kanalai,'BackgroundColor','remove');
    set(handles.pushbutton_apdorotini_kanalai,'UserData',{});
    return ;
end;
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
pasirinkti_kanalai_idx_=pasirinkti_kanalai_idx(find(ismember(pasirinkti_kanalai_idx, [pateikiami_bendri_v pateikiami_nebendri_v pateikiami_kiti_v])==0));
pasirinkti_kanalai=unique({pasirinkti_kanalai{:} pateikiami_kanalai{pasirinkti_kanalai_idx_}});
pasirinkti_kanalai_str=[pasirinkti_kanalai{1}];
for i=2:length(pasirinkti_kanalai);
    pasirinkti_kanalai_str=[pasirinkti_kanalai_str ' ' pasirinkti_kanalai{i}];
end;
disp([ '''' regexprep(pasirinkti_kanalai_str, ' ', ''' ''') '''' ]);
if ~isempty(pasirinkti_kanalai_str) ;
    set(handles.text_apdorotini_kanalai,'String',length(pasirinkti_kanalai));
    set(handles.text_apdorotini_kanalai,'TooltipString',pasirinkti_kanalai_str);
    set(handles.pushbutton_apdorotini_kanalai,'BackgroundColor','remove');
    set(handles.pushbutton_apdorotini_kanalai,'UserData',pasirinkti_kanalai);
else
    set(handles.text_apdorotini_kanalai,'String','?');
    set(handles.text_apdorotini_kanalai,'TooltipString','');
    set(handles.pushbutton_apdorotini_kanalai,'BackgroundColor',[1 1 0]);
    set(handles.pushbutton_apdorotini_kanalai,'UserData',{});
end;
popupmenu4_Callback(hObject, eventdata, handles);

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




% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


VISI_KANALAI_66={'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'M1' 'T7' 'C3' 'Cz' 'C4' 'T8' 'M2' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2' 'AF7' 'AF3' 'AF4' 'AF8' 'F5' 'F1' 'F2' 'F6' 'FC3' 'FCz' 'FC4' 'C5' 'C1' 'C2' 'C6' 'CP3' 'CPz' 'CP4' 'P5' 'P1' 'P2' 'P6' 'PO5' 'PO3' 'PO4' 'PO6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'EOG' 'EOGh';};

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
set(handles.pushbutton18,'Enable','off'); drawnow;
[~,visi_galimi_kanalai,bendri_kanalai]=eeg_kanalu_sarasas(get(handles.edit1,'String'), RINKMENOS);
set(handles.pushbutton18,'Enable','on');
if isempty(visi_galimi_kanalai);
    wf=warndlg(lokaliz('No names of channels found.'),lokaliz('Selection of channels'));
    uiwait(wf);
    %return;
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
if isempty(visi_galimi_kanalai);
    nebendri_idx=[];
    dar_kiti_kanalai=sort(VISI_KANALAI_66);
else
    nebendri_idx=find(ismember(visi_galimi_kanalai,bendri_kanalai) == 0);
    dar_kiti_kanalai=[];
    %dar_kiti_kanalai=sort(VISI_KANALAI_66(find(ismember(VISI_KANALAI_66,visi_galimi_kanalai)==0)));
end;
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(not common:)') visi_galimi_kanalai{nebendri_idx} };
   pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_kanalai);
   if ~pateikiami_bendri_v;
       pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_kanalai) + pateikiami_bendri_v + 1 ) ];
   end;
end;
pateikiami_kiti_v=0;
if ~isempty(dar_kiti_kanalai);
   pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(other:)') dar_kiti_kanalai{:} };
   pateikiami_kiti_v=1+pateikiami_bendri_v + (pateikiami_nebendri_v ~= 0) + length(visi_galimi_kanalai);
   disp(pateikiami_kiti_v);
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
%Ankstesni_kanalai=get(handles.text8,'TooltipString');
Ankstesni_kanalai=get(handles.pushbutton18,'UserData');
if ~isempty(Ankstesni_kanalai);
  %Ankstesni_kanalai=textscan(Ankstesni_kanalai,'%s','delimiter',' ');
  %senas=Ankstesni_kanalai{1};
  %if ~isempty(senas);
  %  pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,senas)==1);
  %end;
  pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,Ankstesni_kanalai)==1);
end;
if ~iscellstr(pateikiami_kanalai);
    warning(lokaliz('unexpected channels types.'),lokaliz('Selection of channels'));
    disp(pateikiami_kanalai);
    return;
end;
pasirinkti_kanalai_idx=listdlg('ListString', pateikiami_kanalai,...
    'SelectionMode','multiple',...
    'PromptString', lokaliz('Select channels:'),...
    'InitialValue',pradinis_pasirinkimas ,...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
if isempty(pasirinkti_kanalai_idx);
    set(handles.text_apdorotini_kanalai,'String',lokaliz('all'));
    set(handles.text_apdorotini_kanalai,'TooltipString','');
    set(handles.pushbutton18,'BackgroundColor','remove');
    set(handles.pushbutton18,'UserData',{});
    return ;
end;
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
pasirinkti_kanalai_idx_=pasirinkti_kanalai_idx(find(ismember(pasirinkti_kanalai_idx, [pateikiami_bendri_v pateikiami_nebendri_v pateikiami_kiti_v])==0));
pasirinkti_kanalai=unique({pasirinkti_kanalai{:} pateikiami_kanalai{pasirinkti_kanalai_idx_}});
pasirinkti_kanalai_str=[pasirinkti_kanalai{1}];
for i=2:length(pasirinkti_kanalai);
    pasirinkti_kanalai_str=[pasirinkti_kanalai_str ' ' pasirinkti_kanalai{i}];
end;
disp([ '''' regexprep(pasirinkti_kanalai_str, ' ', ''' ''') '''' ]);
if ~isempty(pasirinkti_kanalai_str) ;
    %set(handles.text_apdorotini_kanalai,'String',length(pasirinkti_kanalai));
    %set(handles.text_apdorotini_kanalai,'TooltipString',pasirinkti_kanalai_str);
    popupmenu3_senas=get(handles.popupmenu3,'String');
    set(handles.popupmenu3,'String',[popupmenu3_senas(1:3) ; pasirinkti_kanalai_str ]);
    set(handles.popupmenu3,'Value',length(get(handles.popupmenu3,'String')));

    set(handles.pushbutton18,'BackgroundColor','remove');
    set(handles.pushbutton18,'UserData',pasirinkti_kanalai);
else
    %set(handles.text_apdorotini_kanalai,'String','?');
    %set(handles.text_apdorotini_kanalai,'TooltipString','');
    set(handles.pushbutton18,'BackgroundColor',[1 1 0]);
    set(handles.pushbutton18,'UserData',{});
end;
popupmenu3_Callback(hObject, eventdata, handles);

function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double
virtual_edit_sk_Callback(hObject, eventdata, handles, handles.edit59, 1, 'and(x>1,x==floor(x))');


% --- Executes during object creation, after setting all properties.
function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function virtual_edit_sk_Callback(hObject, eventdata, handles, id, n, cond)
if isempty(cond); cond='true'; end;
x=real(str2num(get(id,'String')));
if length(x) == n ;
    if eval(cond);
        set(id,'UserData',regexprep(num2str(x), '[ ]*', ' '));
    end;
end;
d=get(id,'UserData');
if ~ischar(d); d=regexprep(num2str(d), '[ ]*', ' '); end;
set(id,'String',d);
set(id,'BackgroundColor',[1 1 1]);



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
    'checkbox_rf' 'checkbox_filtr1' 'checkbox_filtr2' 'checkbox_filtr_tinklo' 'checkbox_kanalu_padetis' 'checkbox_atrink_kanalus1' ...
    'checkbox_atmesk_atkarpas_amp' 'checkbox_atmesk_atkarpas_dzn' 'checkbox_atmesk_kan_auto' 'checkbox_perziureti' 'checkbox_atmesk_iki2s' ...
    'checkbox_vienoda_trukme' 'checkbox_ICA' 'checkbox_MARA' 'checkbox_atrink_kanalus2' 'checkbox_atrink_kanalus2A' 'checkbox_ASR' 'checkbox_perziureti_ICA' 'checkbox_epoch' ...
    'checkbox_rf_' 'checkbox_filtr1_' 'checkbox_filtr2_' 'checkbox_filtr_tinklo_' 'checkbox_kanalu_padetis_' 'checkbox_atrink_kanalus1_' ...
    'checkbox_atmesk_atkarpas_amp_' 'checkbox_atmesk_atkarpas_dzn_' 'checkbox_atmesk_kan_auto_' 'checkbox_perziureti_' 'checkbox_atmesk_iki2s_' ...
    'checkbox_vienoda_trukme_' 'checkbox_ICA_' 'checkbox_MARA_' 'checkbox_atrink_kanalus2_' 'checkbox_ASR_' 'checkbox_perziureti_ICA_' 'checkbox_epoch_' ...
    'checkbox_atrink_kanalus1__' 'checkbox41' 'checkbox_perziureti_demesio' 'checkbox_perziureti_ICA_demesio' 'checkbox_epoch_b' ...
    'popupmenu9' 'popupmenu4' 'popupmenu5' 'popupmenu7' 'popupmenu8' 'popupmenu10' ...
    'pushbutton14' 'pushbutton18' 'pushbutton9' 'pushbutton_apdorotini_kanalai' 'pushbutton7' 'pushbutton13' ...
    'radiobutton6' 'radiobutton7' };
    
isimintini(2).raktai={'Value' 'UserData' 'String'};
isimintini(2).nariai={ 'edit3' 'edit50' 'edit58' 'edit57' 'edit44' 'edit43' 'edit40' 'edit_atmesk_kan_auto_slenkstis' ...
    'edit59' 'edit20' 'edit19' 'edit21'  'edit_epoch_t' 'edit_epoch_b'};

isimintini(3).raktai={'Value' 'UserData' 'String' 'TooltipString'};
isimintini(3).nariai={ 'popupmenu12' 'popupmenu3' 'text8' 'text9' 'text_apdorotini_kanalai' ...
    'edit_rf' 'edit_filtr1' 'edit_filtr2' 'edit_filtr_tinklo' 'edit_kanalu_padetis' 'edit_atrink_kanalus1' ...
    'edit_atmesk_atkarpas_amp' 'edit_atmesk_atkarpas_dzn' 'edit_atmesk_kan_auto' 'edit_perziureti' 'edit_atmesk_iki2s' ...
    'edit_vienoda_trukme' 'edit_ICA' 'edit_MARA' 'edit_atrink_kanalus2' 'edit_ASR' 'edit_perziureti_ICA' 'edit_epoch' ...
    'edit_rf_' 'edit_filtr1_' 'edit_filtr2_' 'edit_filtr_tinklo_' 'edit_kanalu_padetis_' 'edit_atrink_kanalus1_' ...
    'edit_atmesk_atkarpas_amp_' 'edit_atmesk_atkarpas_dzn_' 'edit_atmesk_kan_auto_' 'edit_perziureti_' 'edit_atmesk_iki2s_' ...
    'edit_vienoda_trukme_' 'edit_ICA_' 'edit_MARA_' 'edit_atrink_kanalus2_' 'edit_ASR_' 'edit_perziureti_ICA_' 'edit_epoch_' ...
    'edit_epoch_iv' };
drb_parinktys(hObject, eventdata, handles, 'irasyti', mfilename, vardas, komentaras, isimintini);

