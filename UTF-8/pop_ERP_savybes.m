%
% 
% 
% 
% 
% ERP savybių tyrinėjimui
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

function varargout = pop_ERP_savybes(varargin)
% POP_ERP_SAVYBES MATLAB code for pop_ERP_savybes.fig
%      POP_ERP_SAVYBES, by itself, creates a new POP_ERP_SAVYBES or raises the existing
%      singleton*.
%
%      H = POP_ERP_SAVYBES returns the handle to a new POP_ERP_SAVYBES or the handle to
%      the existing singleton*.
%
%      POP_ERP_SAVYBES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_ERP_SAVYBES.M with the given input arguments.
%
%      POP_ERP_SAVYBES('Property','Value',...) creates a new POP_ERP_SAVYBES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_ERP_savybes_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_ERP_savybes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_ERP_savybes

% Last Modified by GUIDE v2.5 11-Feb-2015 11:31:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_ERP_savybes_OpeningFcn, ...
    'gui_OutputFcn',  @pop_ERP_savybes_OutputFcn, ...
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



% --- Executes just before pop_ERP_savybes is made visible.
function pop_ERP_savybes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_ERP_savybes (see VARARGIN)

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

set(handles.edit_failu_filtras1,'String','*.set');
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



% reikšmės numatytosios
set(handles.checkbox57,'Value',0);%Peržiūra
set(handles.checkbox58,'Enable','on'); % Failų vidurkis
set(handles.checkbox58,'Visible','on');
set(handles.checkbox59,'Value',1);%Kanalų vidurkis

set(handles.checkbox61,'Value',1);% vid ampl
set(handles.checkbox65,'Value',1);% plotas
set(handles.checkbox64,'Value',1);% laikas pusei ploto
set(handles.checkbox67,'Value',1);% ampl pusei ploto
set(handles.checkbox63,'Value',1);% min
set(handles.checkbox66,'Value',1);% max

if ~ispc;
    set(handles.popupmenu9,'Value',2);
end;
set(handles.edit60,'String',[lokaliz('ERP_savybes_') '%t']);
set(handles.edit60,'TooltipString',lokaliz('%t - date and time now'));

set(handles.slider3,'Min',-1000);
set(handles.slider3,'Max',1000);
set(handles.slider3,'Value',0);
set(handles.slider3,'SliderStep',[0.01 5]);

set(handles.pushbutton11,'UserData',{});
set(handles.pushbutton14,'UserData',{});
set(handles.pushbutton15,'UserData',{});

parinktis_irasyti(hObject, eventdata, handles, 'numatytas','');
try 
    drb_parinktys(hObject, eventdata, handles, 'ikelti', mfilename, g(1).preset); 
catch err; 
    susildyk(hObject, eventdata, handles);
end;

set(handles.checkbox_uzverti_pabaigus,'UserData',0);

tic;

% Choose default command line output for pop_ERP_savybes
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_ERP_savybes wait for user response (see UIRESUME)
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
function varargout = pop_ERP_savybes_OutputFcn(hObject, eventdata, handles)
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
set(handles.pushbutton11,'Enable','off');
set(handles.pushbutton14,'Enable','off');
set(handles.pushbutton15,'Enable','off');
set(handles.pushbutton_v1,'Enable','off');
set(handles.pushbutton_v2,'Enable','off');
set(handles.radiobutton6,'Enable','off');
set(handles.radiobutton7,'Enable','off');

 set(handles.edit51,'Enable','off');
 set(handles.edit59,'Enable','off');
% set(handles.edit54,'Enable','off');
% set(handles.edit55,'Enable','off');
% set(handles.edit56,'Enable','off');
% set(handles.edit57,'Enable','off');
% set(handles.edit58,'Enable','off');
 set(handles.edit60,'Enable','off');
% set(handles.edit62,'Enable','off');

%set(handles.checkbox55,'Enable','off');
set(handles.checkbox57,'Enable','off');

%checkbox55_Callback(hObject, eventdata, handles);
checkbox57_Callback(hObject, eventdata, handles);

set(handles.checkbox_baigti_anksciau,'Value',0);
set(handles.checkbox_baigti_anksciau,'Visible','on');
%set(handles.checkbox_pabaigus_atverti,'Value',0);
set(handles.checkbox_pabaigus_atverti,'Visible','on');

set(handles.text_darbas,'String',' ');

set(handles.checkbox59,'Enable','off'); %Kanalų vid
set(handles.checkbox58,'Enable','off'); %Failų vid
set(handles.checkbox57,'Enable','off'); %Peržiūra
set(handles.checkbox60,'Enable','off'); %Legenda
set(handles.checkbox72,'Enable','off'); %Y ašis
set(handles.checkbox69,'Enable','off'); %Exp
%set(handles.checkbox71,'Enable','off'); %Ragu
checkbox69_Callback(hObject, eventdata, handles);

set(handles.checkbox61,'Enable','off');% vid ampl
set(handles.checkbox65,'Enable','off');% plotas
set(handles.checkbox64,'Enable','off');% laikas pusei ploto
set(handles.checkbox67,'Enable','off');% ampl pusei ploto
set(handles.checkbox63,'Enable','off');% min
set(handles.checkbox66,'Enable','off');% max
set(handles.edit64, 'Visible', 'off'); % vid ampl
set(handles.edit65, 'Visible', 'off'); % plotas
set(handles.edit66, 'Visible', 'off'); % laikas pusei ploto
set(handles.edit69, 'Visible', 'off'); % ampl pusei ploto
set(handles.edit67, 'Visible', 'off'); % min
set(handles.edit68, 'Visible', 'off'); % max
set(handles.slider3,'Visible','off');
set(handles.edit70,'Enable','off'); % Exp atkarpa
set(handles.popupmenu9,'Enable','off'); % Dokumento tipas
popupmenu11_Callback(hObject, eventdata, handles)

% Vel leisk ka nors daryti
function susildyk(hObject, eventdata, handles)

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
set(handles.pushbutton11,'Enable','on');
set(handles.pushbutton14,'Enable','on');
set(handles.pushbutton15,'Enable','on');
set(handles.pushbutton_v1,'Enable','on');
set(handles.pushbutton_v2,'Enable','on');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','on');

set(handles.checkbox59,'Enable','on'); %Kanalų vid
set(handles.checkbox58,'Enable','on'); %Failų vid
popupmenu11_Callback(hObject, eventdata, handles)
if get(handles.checkbox57, 'Value');
    set(handles.checkbox60,'Enable','on'); %Legenda
    set(handles.checkbox72,'Enable','on'); %Y ašis
else    
    set(handles.checkbox60,'Enable','off'); %Legenda
    set(handles.checkbox72,'Enable','off'); %Y ašis
end;
set(handles.checkbox69,'Enable','on'); %Exp
%set(handles.checkbox71,'Enable','on'); %Ragu
checkbox69_Callback(hObject, eventdata, handles);

set(handles.checkbox61,'Enable','on');% vid ampl
set(handles.checkbox65,'Enable','on');% plotas
set(handles.checkbox64,'Enable','on');% laikas pusei ploto
set(handles.checkbox67,'Enable','on');% ampl pusei ploto
set(handles.checkbox63,'Enable','on');% min
set(handles.checkbox66,'Enable','on');% max


 set(handles.edit51,'Enable','on');
 set(handles.edit59,'Enable','on');
% set(handles.edit54,'Enable','on');
% set(handles.edit55,'Enable','on');
% set(handles.edit56,'Enable','on');
% set(handles.edit57,'Enable','on');
% set(handles.edit58,'Enable','on');
 set(handles.edit60,'Enable','on');
% set(handles.edit62,'Enable','on');

set(handles.popupmenu9,'Enable','on'); % Dokumento tipas

set(handles.edit70,'Enable','on'); % Exp atkarpa

%set(handles.checkbox55,'Enable','on');
set(handles.checkbox57,'Enable','on');

%checkbox55_Callback(hObject, eventdata, handles);
checkbox57_Callback(hObject, eventdata, handles);

uipanel15_SelectionChangeFcn(hObject, eventdata, handles);

%Vykdymo mygtukas
Ar_galima_vykdyti(hObject, eventdata, handles);

set(handles.checkbox_baigti_anksciau,'Visible','off');
set(handles.checkbox_pabaigus_atverti,'Visible','on');
set(handles.checkbox57,'Enable','on'); %Peržiūra

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
% if isempty(get(handles.edit59,'UserData'));
%     set(handles.edit59,'BackgroundColor', [1 1 0]);
%     return;
% end;
% if isempty(get(handles.edit51,'UserData'));
%     set(handles.edit51,'BackgroundColor', [1 1 0]);
%     return;
% end;
% if isempty(get(handles.edit54,'UserData'));
%     set(handles.edit54,'BackgroundColor', [1 1 0]);
%     return;
% end;

if and(get(handles.checkbox58,'Value'),...
    get(handles.checkbox69,'Value'));
    use_mean=lokaliz('Use mean of files');
    use_eksp=lokaliz('Export ERP');
    button = questdlg(lokaliz('This version does not support ERP export, then mean of files is selected.') , ...
        lokaliz('Question'), ...
        use_mean, use_eksp, use_eksp);
    if strcmp(button,use_mean);
        set(handles.checkbox69,'Value',0);
        checkbox69_Callback(hObject, eventdata, handles);
    else%if strcmp(button,use_eksp);
        set(handles.checkbox58,'Value',0);
        checkbox58_Callback(hObject, eventdata, handles);
    end;
end;

if and(get(handles.checkbox59,'Value'), and(...
    get(handles.checkbox69,'Value'),...
    (get(handles.popupmenu10,'Value')==1)));
    use_mean=lokaliz('Use mean of channels');
    use_ragu=lokaliz('Export to Ragu');
    button = questdlg(lokaliz('You can not export mean of channels to RAGU.') , ...
        lokaliz('Question'), ...
        use_mean, use_ragu, use_ragu);
    if strcmp(button,use_mean);
        set(handles.popupmenu10,'Value',2);
        set(handles.checkbox69,'Value',0);
        checkbox69_Callback(hObject, eventdata, handles);
    else%if strcmp(button,use_ragu);
        set(handles.checkbox59,'Value',0);
        checkbox59_Callback(hObject, eventdata, handles);
    end;
end;


set(handles.pushbutton1,'Enable','on');
drawnow;
%set(handles.checkbox_epoch_b,'TooltipString', ' ' ) ;


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
    %if Ar_galima_vykdyti2(hObject, eventdata, handles);
        vykdymas(hObject, eventdata, handles);
    %end;
end;


% --- Pats darbo vykdymas
function vykdymas(hObject, eventdata, handles)
if strcmp(get(handles.pushbutton1,'Enable'),'off'); return; end;
disp(' ');
disp('===================================');
disp('     S Į S P     S A V Y B Ė S     ');
disp(' ');
disp( datestr(now, 'yyyy-mm-dd HH:MM:SS' ));
disp('===================================');
disp(' ');
susaldyk(hObject, eventdata, handles);
set(handles.pushbutton1,'Enable','off');
% if get(handles.checkbox58, 'Value');
%     warndlg(lokaliz('This version does not support yet exporting mean values of files.'),lokaliz('Warning'));
% end;
drawnow;
%guidata(hObject, handles);

global STUDY CURRENTSTUDY ALLEEG EEG CURRENTSET;
Pasirinkti_failu_indeksai=(get(handles.listbox1,'Value'));
Rodomu_failu_pavadinimai=(get(handles.listbox1,'String'));
Pasirinkti_failu_pavadinimai=Rodomu_failu_pavadinimai(Pasirinkti_failu_indeksai);
Pasirinktu_failu_N=length(Pasirinkti_failu_pavadinimai);
set(handles.listbox2,'String',Pasirinkti_failu_pavadinimai);
%set(handles.listbox2,'String',{''});
dokumentas_savybiu_eksportui=get(handles.edit60,'String');
t=datestr(now, 'yyyy-mm-dd_HHMMSS');
if isempty(dokumentas_savybiu_eksportui);
    dokumentas_savybiu_eksportui=[lokaliz('ERP_savybes_') t];
else
    dokumentas_savybiu_eksportui=strrep(dokumentas_savybiu_eksportui,'%t',t);
end;
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

%STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
%[ALLEEG EEG CURRENTSET ALLCOM] = eeglab ;
%eeglab redraw ;
%[ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);

% Isimink laika  - veliau bus galimybe paziureti, kiek laiko uztruko
tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Galima naudoti nukreipiant į seniau aprašytas funkcijas, tačiau tuomet nebus atsižvelgiama į pasirinktus kanalus ir įvykius
% 
% Ivykiai=str2num(get(handles.edit59,'String'));
% Pasirinkti_kanalai_str=get(handles.text47,'TooltipString');
% if or(~isempty(Ivykiai),~isempty(Pasirinkti_kanalai_str));
%     Pasirinkti_kanalai=textscan(Pasirinkti_kanalai_str,'%s','delimiter',' ');
%     Reikalingi_kanalai=Pasirinkti_kanalai{1};  
%     warndlg('Programėlė neišbaigta (beta versija). Ji dar neatrenka pasirinktų kanalų ir įvykių eksportuodama, bet tai daro peržiūrint duomenis.');
% else       
%     Reikalingi_kanalai={};
% end;
% 
% Eksp=get(handles.checkbox69,'Value');
% laiko_intervalas=str2num(get(handles.edit51,'String'));
% time_interval_erp=str2num(get(handles.edit70,'String'));
%             
% cd(KELIAS);
%     EEG = pop_loadset('filename',Pasirinkti_failu_pavadinimai);
%     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%     eeglab redraw;
% 
% [lentele]=pop_erp_area(ALLEEG, EEG, CURRENTSET,1,KELIAS_SAUGOJIMUI,Reikalingi_kanalai,laiko_intervalas,Eksp,time_interval_erp);
% if ~ispc;    
%     save(fullfile(KELIAS_SAUGOJIMUI,[ 'ERP_plotas_' datestr(now, 'yyyy-mm-dd_HHMMSS') '.mat' ]),'lentele');
% end;
% 
% if get(handles.checkbox71,'Value');
%     STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
%     cd(KELIAS);
%     EEG = pop_loadset('filename',Pasirinkti_failu_pavadinimai,'loadmode','info');
%     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%     eeglab redraw;
%     eksportuoti_ragu_programai(ALLEEG, EEG, CURRENTSET,1,KELIAS_SAUGOJIMUI,Reikalingi_kanalai);
% end;
% 
% susildyk(hObject, eventdata, handles);
%         
%     % Parodyk, kiek laiko uztruko
%     disp(' ');
%     t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
%     toc ;
%     disp(['Atlikta']);
% 
% return;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DarboNr=0;
PaskutinioIssaugotoDarboNr=0;
Apdoroti_visi_tiriamieji=0;
sukauptos_klaidos={};

axes(handles.axes1);
datacursormode off;

Ar_eksportuoti_savybes = ...
get(handles.checkbox61,'Value') + get(handles.checkbox65,'Value') + ...
get(handles.checkbox64,'Value') + get(handles.checkbox67,'Value') + ...
get(handles.checkbox63,'Value') + get(handles.checkbox66,'Value') ;


Naudoti_kanalu_vidurki=get(handles.checkbox59, 'Value');
Epochuoti_pagal_stimulus_=get(handles.pushbutton11,'UserData') ;
Pasirinkti_kanalai=get(handles.pushbutton14,'UserData');
if ~isempty(Pasirinkti_kanalai);
    Reikalingi_kanalai=Pasirinkti_kanalai;
    Reikalingi_kanalai_sukaupti=Reikalingi_kanalai;
else
    Reikalingi_kanalai={}; %Nebus keičiamas darbų eigoje
    Reikalingi_kanalai_sukaupti={}; % bus keičiamas darbų eigoje
end;
Eksp=get(handles.checkbox69,'Value');
ribos=str2num(get(handles.edit51,'String'));%*1000;
time_interval_erp=str2num(get(handles.edit70,'String'));

[~,ALLEEG_,~]=pop_newset([],[],[]);
ALLEEG_=setfield(ALLEEG_,'datfile',[]);
ALLEEG_=setfield(ALLEEG_,'chanlocs2',[]);
%mūsų papildymas:
ALLEEG_=setfield(ALLEEG_,'file','');
ALLEEG_=setfield(ALLEEG_,'erp_data',[]);
ALLEEG_=setfield(ALLEEG_,'chans',{});

% ALLEEGTMP nevisai atitiks ALLEEG, nes ALLEEGTMP kuriamas jau atrinkus įvykius, turi 'erp_data'
ALLEEGTMP=get(handles.listbox1,'UserData');
if isempty(ALLEEGTMP);
    %ALLEEGTMP=struct('file',{},'erp_data',{},'times',{},'chanlocs',{});
    ALLEEGTMP=ALLEEG_;
end;

ERP_savyb=struct('plotas',{},'vid_ampl',{},'pusplocio_x',{},'pusplocio_y',{},'min_x',{},'min_y',{},'max_x',{},'max_y',{});
legendoje={};

%% 

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
    
    try
        
        % Įkelti
        Darbo_eigos_busena(handles, 'Įkeliama...', DarboNr, i, Pasirinktu_failu_N);
       
        EEGTMP = {};
        dFs={ALLEEGTMP.file};
        di=find(strcmp(dFs,Rinkmena)==1);
        if ~isempty(di);
            EEGTMP=ALLEEGTMP(di);
			if isempty(EEGTMP.epoch);
			   error([lokaliz('Not epoched data!') ' ' lokaliz('File') ': ' Rinkmena]);
			end;
        else
            EEGTMP = pop_loadset('filename',Rinkmena_,'filepath',KELIAS_,'loadmode','info');
            EEGTMP.file=Rinkmena;
            if isempty(EEGTMP.epoch);
			    [ALLEEGTMP, EEGTMP, ~] = eeg_store(ALLEEGTMP, EEGTMP,i);
				set(handles.listbox1,'UserData',ALLEEGTMP); 
                error(lokaliz('Not epoched data!'));
            end;
            [ALLEEGTMP, EEGTMP, ~] = eeg_store(ALLEEGTMP, EEGTMP,i);
            [~, EEGTMP, ~] = pop_newset(EEGTMP, EEGTMP, 1,'retrieve',1,'study',0);
            if ~isempty(Epochuoti_pagal_stimulus_);
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
                            if isstr(EEGTMP.event(1).type);
                                Epochuoti_pagal_stimulus=[Epochuoti_pagal_stimulus orig_epoch];
                            else
                                Epochuoti_pagal_stimulus=[Epochuoti_pagal_stimulus num2str(str2num(orig_epoch))];
                            end;                            
                        else
                            warning([lokaliz('Internal error') '. ']);
                            disp(orig_epoch);
                        end;
                    end;
                EEGTMP = pop_selectevent( EEGTMP, ...
                    'type', Epochuoti_pagal_stimulus ,...
                    'deleteevents','off',...
                    'deleteepochs','on',...
                    'invertepochs','off');
            end;
            EEGTMP=setfield(EEGTMP,'erp_data',[]);
            EEGTMP=setfield(EEGTMP,'chans',{});
            %ALLEEGTMP(i)=EEGTMP;
            EEGTMP.erp_data=mean(EEGTMP.data,3);
            EEGTMP.data=[];
            ALLEEGTMP(i).erp_data=EEGTMP.erp_data;            
            %set(handles.listbox1,'UserData',ALLEEGTMP);           
        end;
        
        if ~isempty(Reikalingi_kanalai);
            Reikalingi_kanalai_idx=find(ismember({EEGTMP.chanlocs.labels},Reikalingi_kanalai));
            %disp(Reikalingi_kanalai_idx);
            EEGTMP.erp_data=EEGTMP.erp_data(Reikalingi_kanalai_idx,:);
            %disp(length(EEGTMP.chanlocs));
            EEGTMP.chanlocs=EEGTMP.chanlocs(Reikalingi_kanalai_idx);
            %disp({EEGTMP.chanlocs.labels});
            EEGTMP.nbchan=length(Reikalingi_kanalai_idx);
        else
            [Reikalingi_kanalai_sukaupti,rksi]=unique([ Reikalingi_kanalai_sukaupti {EEGTMP.chanlocs.labels} ]);
            [~,y]=sort(rksi);
            Reikalingi_kanalai_sukaupti=Reikalingi_kanalai_sukaupti(y);
        end;
                
        
        if strcmp(ALLEEG_(1).file,'');
            %ALLEEG_(1)=EEGTMP;
            [ALLEEG_, EEGTMP, ~] = eeg_store(ALLEEG_, EEGTMP,1);
        else
            %ALLEEG_(end+1)=EEGTMP;
            [ALLEEG_, EEGTMP, ~] = eeg_store(ALLEEG_, EEGTMP,1+length(ALLEEG_));
        end;
        
        pask_eeg_i=length(ALLEEG_);
        
        if get(handles.checkbox59, 'Value')
            % Jei rodyti kanalų vidurkį
            ALLEEG_(pask_eeg_i).erp_data=mean(EEGTMP.erp_data,1);
            ALLEEG_(pask_eeg_i).chans={''};
            ALLEEG_(pask_eeg_i).chanlocs(1).labels=lokaliz('mean');
            Reikalingi_kanalai_sukaupti={};
%             li=1+size(legendoje,1);
%             legendoje{li,1}=Rinkmena;
%             legendoje{li,2}='';            
        else
            % Jei nerodyti kanalų vidurkio
            ALLEEG_(pask_eeg_i).erp_data=EEGTMP.erp_data;
            ALLEEG_(pask_eeg_i).chans={EEGTMP.chanlocs.labels};
%             li=1+size(legendoje,1) ;
%             li=li:(li+size(EEGTMP.erp_data,1) - 1);
%             legendoje(li,1)={Rinkmena};
%             legendoje(li,2)=ALLEEG_(end).chans;           
        end;
        
        %if Ar_eksportuoti_savybes;
        if and(Ar_eksportuoti_savybes,~get(handles.checkbox58, 'Value'));
            
            DarboNr=1;
            Darbo_eigos_busena(handles, 'ERP savybės...', DarboNr, i, Pasirinktu_failu_N);
            
            [~,nauja_kanalu_tvarka]=ismember(Reikalingi_kanalai_sukaupti,ALLEEG_(pask_eeg_i).chans);
            
            
            [ERP_savyb(pask_eeg_i).plotas,        ERP_savyb(pask_eeg_i).vid_ampl,...
                ERP_savyb(pask_eeg_i).pusplocio_x,ERP_savyb(pask_eeg_i).pusplocio_y,...
                ERP_savyb(pask_eeg_i).min_x,      ERP_savyb(pask_eeg_i).min_y,...
                ERP_savyb(pask_eeg_i).max_x,      ERP_savyb(pask_eeg_i).max_y...
                ]=ERP_savybes(ALLEEG_(pask_eeg_i),ribos,nauja_kanalu_tvarka);
                
            
                
        end;
        
        %PaskRinkmIssaugKelias=fullfile(KELIAS_SAUGOJIMUI,NewDir);
        
    catch err;
         
         Pranesk_apie_klaida(err, lokaliz('ERP properties'), NaujaRinkmena,0) ;
         %warning(err.message);
         %sukauptos_klaidos{end+1}=err;
         DarboPorcijaAtlikta=1;
         PaskRinkmIssaugKelias='';
         EEGTMP.nbchan=0;
     end;
    
    
    %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(1 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
    %try  ALLEEG = pop_delset( ALLEEG, find ([1:length(ALLEEG)] ~= CURRENTSET) ); catch err;  end;
    
    
    str=(sprintf('%s apdorotas (%d/%d = %3.2f%%)\r\n', NaujaRinkmena, i, Pasirinktu_failu_N, i/Pasirinktu_failu_N*100 )) ;
    %disp(str);
    
    if and(~isempty(EEGTMP),DarboPorcijaAtlikta);
        if EEGTMP.nbchan > 0 ;
            NaujosRinkmenos=get(handles.listbox2,'String');
            NaujosRinkmenos{i}=NaujaRinkmena;
            set(handles.listbox2,'String',NaujosRinkmenos);
            disp(['+']);
        end;
    end;
    
    %set(handles.uipanel6,'Title', ['Duomenų apdorojimas: ' num2str(0 + DarboNr + str2num(get(handles.text_atlikta_darbu,'String'))) ' darb., ' num2str(i) '/' num2str(Pasirinktu_failu_N) ' įr.']);
    
    
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

%% ERP savybių surinkimas, kai prašoma vidurkinti

%if 1==0;
if get(handles.checkbox58, 'Value');
  if and(Ar_eksportuoti_savybes,get(handles.checkbox58, 'Value'));
            
            DarboNr=1;
            Darbo_eigos_busena(handles, 'ERP savybės...', DarboNr, 1, 1);
            
    if length(ALLEEG_)>1;
        if get(handles.checkbox58, 'Value');
            
            if isequal(ALLEEG_.times);
                if get(handles.checkbox59, 'Value');
                    %Jei vidurkis kanalų
                    uniq_kan={''} ; % {lokaliz('Mean on channels')};
                else                    
                    uniq_kan=Reikalingi_kanalai_sukaupti;
                end;
                [~,ALLEEG__,~]=pop_newset([],[],[]);
                uniq_kan_N=length(uniq_kan);
                %legendoje={};
                
                switch get(handles.popupmenu11,'Value')
                    case 1
                        grpsar={lokaliz('mean')} ;
                        grpN=length(grpsar);
                        grpnar{1}=1:length(ALLEEG_);
                    case 2
                        grpsar=unique({ALLEEG_.subject});
                        grpN=length(grpsar);
                        for grpid=1:grpN;
                            grpnar{grpid}=find(ismember({ALLEEG_.subject},grpsar{grpid}));
                        end;
                    case 3
                        grpsar=unique({ALLEEG_.group});
                        grpN=length(grpsar);
                        for grpid=1:grpN;
                            grpnar{grpid}=find(ismember({ALLEEG_.group},grpsar{grpid}));
                        end;
                    case 4
                        grpsar=unique({ALLEEG_.condition});
                        grpN=length(grpsar);
                        for grpid=1:grpN;
                            grpnar{grpid}=find(ismember({ALLEEG_.condition},grpsar{grpid}));
                        end;
                    case 5
                        grpsar=unique({ALLEEG_.session});
                        grpN=length(grpsar);
                        for grpid=1:grpN;
                            grpnar{grpid}=find(ismember({ALLEEG_.session},grpsar{grpid}));
                        end;
                    case 6                        
                        if strcmp(get(handles.edit_failu_filtras2,'Style'),'edit') ;
                            grpsar=regexp(get(handles.edit_failu_filtras2,'String'),';', 'split');
                            grpN=length(grpsar);
                            for grpid=1:grpN;
                                FAILAI_filtruoti_=atrinkti_teksta(Fs(Fsi2),grpsar{grpid});
                                grpnar_=find(ismember(Fs(Fsi2),FAILAI_filtruoti_));
                                grpnar{grpid}=grpnar_';
                            end;                            
                        else
                            grpsar=unique({lokaliz('mean')});
                            grpN=length(grpsar);
                            grpnar{1}=1:length(ALLEEG_);
                        end;
                    otherwise 
                        warning(lokaliz('Internal error'));
                        grpsar={lokaliz('mean')} ;
                        grpN=length(grpsar);
                        grpnar=1:length(ALLEEG_);
                end;
                                
                for grpid=1:grpN;
                    
                    ALLEEG__(grpid).times=ALLEEG_(grpid).times;
                    ALLEEG__(grpid).srate=ALLEEG_(grpid).srate;
                    ALLEEG__(grpid).file=grpsar{grpid};
                    for k=1:uniq_kan_N;
                        tmp=[];
                        di=1;
                        for d=grpnar{grpid};
                            %if get(handles.checkbox59, 'Value');
                            %else
                            idx=find(ismember(ALLEEG_(d).chans,uniq_kan{k}));
                            tmp(di,1:length(ALLEEG__(grpid).times))=ALLEEG_(d).erp_data(idx,:);
                            di=di+1;
                            %end;
                        end;
                        ALLEEG__(grpid).erp_data(k,1:length(ALLEEG__(grpid).times))=mean(tmp,1);
                    end;
                    %legendoje((1+((grpid-1)*uniq_kan_N)):(uniq_kan_N*grpid),1)={grpsar{grpid}};
                    %legendoje((1+((grpid-1)*uniq_kan_N)):(uniq_kan_N*grpid),2)=uniq_kan';
                    
                    [ERP_savyb(grpid).plotas,        ERP_savyb(grpid).vid_ampl,...
                        ERP_savyb(grpid).pusplocio_x,ERP_savyb(grpid).pusplocio_y,...
                        ERP_savyb(grpid).min_x,      ERP_savyb(grpid).min_y,...
                        ERP_savyb(grpid).max_x,      ERP_savyb(grpid).max_y...
                        ]=ERP_savybes(ALLEEG__(grpid),ribos);
                    
                end;
                
                ALLEEG_=ALLEEG__;
            
            else
                for d=1:length(ALLEEG_);
                   [ERP_savyb(d).plotas,        ERP_savyb(d).vid_ampl,...
                    ERP_savyb(d).pusplocio_x,ERP_savyb(d).pusplocio_y,...
                    ERP_savyb(d).min_x,      ERP_savyb(d).min_y,...
                    ERP_savyb(d).max_x,      ERP_savyb(d).max_y...
                    ]=ERP_savybes(ALLEEG_(d),ribos);
                end;
            end;
        end;
    elseif ~isempty(ALLEEG_(1).file);
        [ERP_savyb(1).plotas,        ERP_savyb(1).vid_ampl,...
                    ERP_savyb(1).pusplocio_x,ERP_savyb(1).pusplocio_y,...
                    ERP_savyb(1).min_x,      ERP_savyb(1).min_y,...
                    ERP_savyb(1).max_x,      ERP_savyb(1).max_y...
                    ]=ERP_savybes(ALLEEG_(1),ribos);
    end;
  end;        
end;

%% ERP savybių eksportavimas

if and(Ar_eksportuoti_savybes,~isempty(ALLEEG_(1).file));
    
    DarboNr=DarboNr+1;
    Darbo_eigos_busena(handles, 'ERP savybių eksportavimas...', DarboNr, i, Pasirinktu_failu_N);
    
    if get(handles.checkbox59, 'Value')
        %Jei vidurkis kanalų
        Reikalingi_kanalai_sukaupti={lokaliz('Mean on channels')};
    end;
    
    lenteles_dydis_x=length(Reikalingi_kanalai_sukaupti)+2;
    lenteles_dydis_y=length(ALLEEG_)+1;
    
    %if 1==0;
    if get(handles.checkbox58, 'Value');
        switch get(handles.popupmenu11,'Value')
            case 1
                lentele{1,1}(1,1)={lokaliz('mean of files')};
            case 2
                lentele{1,1}(1,1)={lokaliz('Experiment_participant')};
            case 3
                lentele{1,1}(1,1)={lokaliz('Group')};
            case 4
                lentele{1,1}(1,1)={lokaliz('Condition')};
            case 5
                lentele{1,1}(1,1)={lokaliz('Session')};
            case 6
                lentele{1,1}(1,1)={lokaliz('Filter')};
            otherwise
                lentele{1,1}(1,1)={lokaliz('mean of files')};
        end;
    else
        lentele{1,1}(1,1)={lokaliz('File')};
    end;
    lentele{1,1}(1,2)={lokaliz('Parameter')};
    lentele{1,1}(1,3:lenteles_dydis_x)=Reikalingi_kanalai_sukaupti;
    lentele{1,1}(2:lenteles_dydis_y,1) = {ALLEEG_.file};
    lentele{1,1}(2:lenteles_dydis_y,3:lenteles_dydis_x)={NaN};
    lentele{1,2}=lentele{1,1}; lentele{1,2}(2:lenteles_dydis_y,2)={[lokaliz('area') ', ms*microV']}; %plotas
    lentele{1,3}=lentele{1,1}; lentele{1,3}(2:lenteles_dydis_y,2)={[lokaliz('mean_amplitude_short') ', microV']};%vidutinė amplitudė
    lentele{2,2}=lentele{1,1}; lentele{2,2}(2:lenteles_dydis_y,2)={[lokaliz('half_area_time') ', ms']};%laikas ties puspločiu
    lentele{2,3}=lentele{1,1}; lentele{2,3}(2:lenteles_dydis_y,2)={[lokaliz('half_area_amplitude') ' ampl., microV']};%amplitudė ties puspločiu
    lentele{3,2}=lentele{1,1}; lentele{3,2}(2:lenteles_dydis_y,2)={[lokaliz('time at min ampl.') ', ms']};
    lentele{3,3}=lentele{1,1}; lentele{3,3}(2:lenteles_dydis_y,2)={'min ampl., microV'};
    lentele{4,2}=lentele{1,1}; lentele{4,2}(2:lenteles_dydis_y,2)={[lokaliz('time at max ampl.') ', ms']};
    lentele{4,3}=lentele{1,1}; lentele{4,3}(2:lenteles_dydis_y,2)={'max ampl., microV'};
        
    %save(fullfile(KELIAS_SAUGOJIMUI,[ 'ERP_savybes_' datestr(now, 'yyyy-mm-dd_HHMMSS') '.mat' ]),'lentele','ERP_savyb');
    
    for li=1:length(ERP_savyb);
        eilutes_ilgis=length(ERP_savyb(li).plotas)+2;
        %if isempty
        lentele{1,2}(li+1,3:eilutes_ilgis) = num2cell(ERP_savyb(li).plotas);
        lentele{1,3}(li+1,3:eilutes_ilgis) = num2cell(ERP_savyb(li).vid_ampl);
        lentele{2,2}(li+1,3:eilutes_ilgis) = num2cell(ERP_savyb(li).pusplocio_x);
        lentele{2,3}(li+1,3:eilutes_ilgis) = num2cell(ERP_savyb(li).pusplocio_y);
        lentele{3,2}(li+1,3:eilutes_ilgis) = num2cell(ERP_savyb(li).min_x);
        lentele{3,3}(li+1,3:eilutes_ilgis) = num2cell(ERP_savyb(li).min_y);
        lentele{4,2}(li+1,3:eilutes_ilgis) = num2cell(ERP_savyb(li).max_x);
        lentele{4,3}(li+1,3:eilutes_ilgis) = num2cell(ERP_savyb(li).max_y);
    end;
    
    lentele{3,1}=merge_cells(lentele{3,2},lentele{3,3},'',''); % min
    lentele{4,1}=merge_cells(lentele{4,2},lentele{4,3},'',''); % max

    Excel_lentele={};
    if get(handles.checkbox63,'Value'); % min
        Excel_lentele=merge_cells(Excel_lentele,lentele{3,1},'','');
    end;
    if get(handles.checkbox66,'Value'); % max
        Excel_lentele=merge_cells(Excel_lentele,lentele{4,1},'','');
    end;
    if get(handles.checkbox65,'Value'); % plotas
        Excel_lentele=merge_cells(Excel_lentele,lentele{1,2},'','');
    end;
    if get(handles.checkbox61,'Value'); % vid ampl
        Excel_lentele=merge_cells(Excel_lentele,lentele{1,3},'','');
    end;
    if get(handles.checkbox64,'Value'); % laikas pusei ploto
        Excel_lentele=merge_cells(Excel_lentele,lentele{2,2},'','');
    end;
    if get(handles.checkbox67,'Value'); % ampl pusei ploto
        Excel_lentele=merge_cells(Excel_lentele,lentele{2,3},'','');
    end;
   
    % Eksportuoti
    lango_intervalas_zodziu=regexprep(num2str(round(ribos) ), '[ ]*' , ' ' );
    lango_intervalas_zodziu=strrep(lango_intervalas_zodziu,' ',' - ');
    dok=fullfile(KELIAS_SAUGOJIMUI,dokumentas_savybiu_eksportui);
    try
        switch get(handles.popupmenu9,'Value')
            case 1
                lakstas=lango_intervalas_zodziu;
                xlswrite(fullfile(KELIAS_SAUGOJIMUI,dokumentas_savybiu_eksportui), Excel_lentele, lakstas);
            case 2
                %%
                dok=[regexprep(dok,'.txt$','') '.txt']; % visada .txt galūnė
                dok_id=fopen(dok,'w');
                %size(Excel_lentele)
                for eilut=1:size(Excel_lentele,1);
                    str=cellfun(@(x) konvertavimas_is_narvelio(Excel_lentele(eilut,x)), num2cell(1:size(Excel_lentele,2)), 'UniformOutput', false);
                    fprintf(dok_id,'%s\t', str{:,:});
                    %fprintf(dok_id,'%s\t', Excel_lentele{eilut,:});
                    fprintf(dok_id,'\r\n');
                end;
                fclose(dok_id);
                % Atvverti po įrašymo
                open(dok);
            case 3
                ERP_info=Excel_lentele;
                save(fullfile(KELIAS_SAUGOJIMUI,dokumentas_savybiu_eksportui),'ERP_info','ERP_savyb','lentele');
        end;
    catch err;
        warning(err.message);
    end;
end; 

%% Eksportuoti pačius ERP duomenis, o ne savybes

if and(~isempty(ALLEEG_(1).file),get(handles.checkbox69,'Value'));
    
    %% Eksportuoti RAGU programai
    
    if get(handles.popupmenu10,'Value')==1;
        
        DarboNr=DarboNr+1;
        Darbo_eigos_busena(handles, 'Eksportuoti į RAGU...', DarboNr, length(ALLEEG_), length(ALLEEG_));
        eksportuoti_ragu_programai(ALLEEG_, ALLEEG_, 1, 1,KELIAS_SAUGOJIMUI,Reikalingi_kanalai);
        
    end;
    
    
    %% Eksportuoti į TXT
    
    if get(handles.popupmenu10,'Value')==2;
        
        DarboNr=DarboNr+1;
        
        %Darbo_eigos_busena(handles, 'Eksportuoti į TXT...', DarboNr, 0, length(ALLEEG_));
        
        for eeg_i=1:length(ALLEEG_);
            try
                Darbo_eigos_busena(handles, 'Eksportuoti į TXT...', DarboNr, eeg_i, length(ALLEEG_));
                EEGTMP=ALLEEG_(eeg_i);
                [~,Rinkmena_txt_exp,~]=fileparts(EEGTMP.file);
                Rinkmena_txt_exp=fullfile(KELIAS_SAUGOJIMUI,[Rinkmena_txt_exp '.txt']);
                EEGTMP.data=EEGTMP.erp_data; % EEG.erp_data is not standard EEGLAB param
                disp(lokaliz('We use pre-processed data to speed up exporting data. Please ignore these eeg_checkset warnings:'));
                %lango_erp=[EEGTMP.erp_data(:,idx1:idx2,:)];
                pop_export(EEGTMP, Rinkmena_txt_exp, 'transpose','on','elec','on','time','on','erp','on','precision',7);
                disp(Rinkmena_txt_exp);
            catch err;
                Pranesk_apie_klaida(err,'','',0);
            end;
        end;
    end;
    
    %% Eksportuoti į Excel
    % Nebaigta
    
    
    if get(handles.popupmenu10,'Value')==3;
        
        DarboNr=DarboNr+1;
    
        %Darbo_eigos_busena(handles, 'Eksportuoti į TXT...', DarboNr, 0, length(ALLEEG_));
        
        excel_dokumentas_erp=dokumentas_savybiu_eksportui;
                
        for eeg_i=1:length(ALLEEG_);
            try
                Darbo_eigos_busena(handles, 'Eksportuoti į Excel...', DarboNr, eeg_i, length(ALLEEG_));
                EEGTMP=ALLEEG_(eeg_i);
                [~,Rinkmenos_pav,~]=fileparts(EEGTMP.file);
                if isempty(time_interval_erp);
                    idx_1=1;
                    idx_2=length(EEGTMP.times);
                else
                    [~, idx_1] = min(abs(EEGTMP.times - time_interval_erp(1) )) ;
                    [~, idx_2] = min(abs(EEGTMP.times - time_interval_erp(2) )) ;
                end;
                ERP{i}=[EEGTMP.erp_data(:,idx_1:idx_2)]'; %[mean([EEGTMP.data(:,idx_1:idx_2,:)],3)]';
                EEGTMP.nbchan=size(EEGTMP.erp_data,1);
                ERP_lentele={};                
                ERP_lentele(1,1)={Rinkmenos_pav};
                ERP_lentele(1,2:EEGTMP.nbchan + 1)={EEGTMP(1).chanlocs.labels};
                ERP_lentele(2:length(EEGTMP.times(idx_1:idx_2))+1,1) = num2cell([EEGTMP.times(idx_1:idx_2)]');
                ERP_lentele(2:length(EEGTMP.times(idx_1:idx_2))+1,2:EEGTMP.nbchan + 1)=num2cell(ERP{i});
                
                if ~isempty(ERP_lentele{1,1})
                    laksto_pav=ERP_lentele{1,1}(1:min(length(ERP_lentele{1,1}),31));
                else
                    laksto_pav=num2str(i);
                end;
                %if ispc
                    xlswrite(excel_dokumentas_erp, ERP_lentele, laksto_pav );
                    disp(excel_dokumentas_erp);
                %elseif 1 == 0;
                    %disp('Abejoju, ar kitoje nei Windows sistemoje MATLAB ras Excel');
                %    csvwrite([csv_dokumentas_erp '_' laksto_pav '.csv'], ERP_lentele );
                %end ;
                %disp(' ');
            catch err;
                Pranesk_apie_klaida(err,'','',0);
            end;
        end;
    end;
    
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
        set(handles.checkbox57,'Value',0);
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
ERP_perziura(hObject, eventdata, handles);
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
ERP_perziura(hObject, eventdata, handles);

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
ERP_perziura(hObject, eventdata, handles);

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

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
if get(handles.popupmenu3,'Value') == 1 ;
    priesaga='_rfA';
elseif get(handles.popupmenu3,'Value') == 2
    priesaga='_rfM';
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
    set(handles.edit_failu_filtras1,'String','*.set');
end;
set(handles.edit_failu_filtras1,'BackgroundColor',[1 1 1]);
atnaujink_rodomus_failus(hObject, eventdata, handles);
ERP_perziura(hObject, eventdata, handles);


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
ERP_perziura(hObject, eventdata, handles);


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
                        %        pop_ERP_savybes;
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



% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


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
        set(elementas,'BackgroundColor',[1 1 1]);
        %set(handles.slider3,'Min',xmin);
        %set(handles.slider3,'Max',xmax-1000*(x(2)-x(1)));
        slider_val=max(min(x(1),get(handles.slider3,'Max')),get(handles.slider3,'Min'));
    end;
end;
if isempty(x);
    set(elementas,'UserData','');        
    set(elementas,'BackgroundColor',[1 1 1]);
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
%edit57_Callback(hObject, eventdata, handles);
ERP_perziura(hObject, eventdata, handles);

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




function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double
elementas=handles.edit59;
senas=get(elementas,'UserData');
set(elementas,'BackgroundColor',[1 1 1]);
str=get(elementas,'String');
x=unique(str2num(str));
if length(x) > 0 ;
    x_txt=num2str2(x);
    set(elementas,'UserData',regexprep(x_txt, '[ ]*', ' '));
    set(handles.pushbutton11,'UserData',...
        cellfun(@(i) num2str(x(i)), ...
        num2cell(1:length(x)),...
        'UniformOutput', false));
elseif isempty(str);
    set(elementas,'UserData','');
    set(handles.pushbutton11,'UserData',{});
else
    iv=get(handles.pushbutton11,'UserData');
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
if ~strcmp(senas,get(elementas,'UserData'));
    set(handles.listbox1,'UserData',{});
    ERP_perziura(hObject, eventdata, handles);
end;

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


function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit54 as text
%        str2double(get(hObject,'String')) returns contents of edit54 as a double
elementas=handles.edit54;
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
if ~isempty(get(elementas,'String'));
    set(elementas,'BackgroundColor',[1 1 1]);
else
    set(elementas,'BackgroundColor',[1 1 0]);
end;
tmp_str=[ strrep(get(handles.edit59,'String'),':','-') ' ' lokaliz('with') ' ' strrep(get(handles.edit54,'String'),':','-') ];
regexprep(tmp_str, '[ ]*', ' ');
set(handles.edit60,'String',tmp_str);
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit55_Callback(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit55 as text
%        str2double(get(hObject,'String')) returns contents of edit55 as a double
elementas=handles.edit55;
x=str2num(get(elementas,'String'));
if length(x) == 2 ;
    if x(1) < x(2);
        set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));        
        set(elementas,'BackgroundColor',[1 1 1]);
        set(handles.edit56,'Enable','on');
    end;
elseif isempty(get(elementas,'String'));
    set(elementas,'UserData','');
    set(handles.edit56,'Enable','off');
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
%priderinti baseline, jei reikia
edit56_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit56_Callback(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit56 as text
%        str2double(get(hObject,'String')) returns contents of edit56 as a double
elementas=handles.edit56;
x=str2num(get(elementas,'String'));
epoch_interval=str2num(get(handles.edit55,'String'));
if length(x) == 2 ;
    x(1)=max(x(1),epoch_interval(1));
    x(2)=min(x(2),epoch_interval(2));
    if x(1) < x(2);
        set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));
        set(elementas,'BackgroundColor',[1 1 1]);
    else
        set(elementas,'UserData','');
    end;
elseif isempty(get(elementas,'String'));
    set(elementas,'UserData','');
end;
set(elementas,'String',num2str(get(elementas,'UserData')));


% --- Executes during object creation, after setting all properties.
function edit56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
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
elementas=handles.edit57;
x=str2num(get(elementas,'String'));
epoch_interval=str2num(get(handles.edit51,'String'));
if length(x) == 2 ;
    x(1)=max(x(1),epoch_interval(1));
    x(2)=min(x(2),epoch_interval(2));
    if x(1) < x(2);
        set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));
        set(elementas,'BackgroundColor',[1 1 1]);
        set(handles.edit58,'Enable','on');
    else
        set(elementas,'UserData','');
        set(handles.edit58,'Enable','off');
    end;
elseif isempty(get(elementas,'String'));
    set(elementas,'UserData','');
    set(handles.edit58,'Enable','off');
end;
set(elementas,'String',num2str(get(elementas,'UserData')));
%priderinti baseline, jei reikia
edit58_Callback(hObject, eventdata, handles);

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
elementas=handles.edit58;
x=str2num(get(elementas,'String'));
epoch_interval=str2num(get(handles.edit57,'String'));
if length(x) == 2 ;
    x(1)=max(x(1),epoch_interval(1));
    x(2)=min(x(2),epoch_interval(2));
    if x(1) < x(2);
        set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));        
        set(elementas,'BackgroundColor',[1 1 1]);
    else
        set(elementas,'UserData','');
    end;
elseif isempty(get(elementas,'String'));
    set(elementas,'UserData','');
end;
set(elementas,'String',num2str(get(elementas,'UserData')));


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


% --- Executes on button press in text35.
function text35_Callback(hObject, eventdata, handles)
% hObject    handle to text35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of text35



function edit60_Callback(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit60 as text
%        str2double(get(hObject,'String')) returns contents of edit60 as a double


% --- Executes during object creation, after setting all properties.
function edit60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit62_Callback(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit62 as text
%        str2double(get(hObject,'String')) returns contents of edit62 as a double


% --- Executes during object creation, after setting all properties.
function edit62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox55.
function checkbox55_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox55
if and(get(handles.checkbox55,'Value'),...
        strcmp(get(handles.checkbox55,'Enable'),'on'));
    set(handles.edit60,'Enable','on');
else
    set(handles.edit60,'Enable','off');
end;


% --- Executes on button press in checkbox57.
function checkbox57_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox57

% Peržiūros įungimas/išjungimas
if and(strcmp(get(handles.checkbox57, 'Enable'),'on'), ...
        get(handles.checkbox57, 'Value'));
    set(handles.checkbox60, 'Enable', 'on');
    set(handles.checkbox72, 'Enable', 'on');
else
    set(handles.checkbox60, 'Enable', 'off');
    set(handles.checkbox72, 'Enable', 'off');
end;
if strcmp(get(handles.checkbox57, 'Enable'),'on');
    ERP_perziura(hObject, eventdata, handles);
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
set(handles.pushbutton1,'String',lokaliz('Execute'));
set(handles.pushbutton2,'String',lokaliz('Close'));
set(handles.pushbutton4,'String',lokaliz('Update'));
set(handles.pushbutton11,'String',lokaliz('Events...'));
set(handles.pushbutton14,'String',lokaliz('Channels...'));
set(handles.pushbutton15,'String',lokaliz('Update'));
set(handles.uipanel3,'Title',lokaliz('Options'));
set(handles.uipanel4,'Title',lokaliz('File filter'));
set(handles.uipanel5,'Title',lokaliz('Files for work'));
set(handles.uipanel15,'Title',lokaliz('File loading options'));
set(handles.uipanel16,'Title',lokaliz('File saving options'));
set(handles.uipanel17,'Title',lokaliz('ERP properties'));
%set(handles.uipanel21,'Title',lokaliz());
set(handles.uipanel18,'Title',lokaliz('Preview'));
%set(handles.uipanel19,'Title',lokaliz('Stimuli as reference'));
%set(handles.uipanel20,'Title',lokaliz('Responses as reference'));
set(handles.text24,'String', [lokaliz('Time interval') ' '  lokaliz('(miliseconds_short)') ]);
set(handles.text44,'String', [lokaliz('At half area') ]);
set(handles.text45,'String', lokaliz('Document for ERP properties:'));
%set(handles.text25,'String', [lokaliz('Time interval') ' '  lokaliz('(seconds_short)') ':' ]);
%set(handles.text28,'String', [lokaliz('Remove baseline') ' ' lokaliz('(seconds_short)') ':']);
%set(handles.text36,'String', [lokaliz('stimuli as reference') ]);
%set(handles.text33,'String',lokaliz('Mandatory events in epochs'));
%set(handles.text34,'String',lokaliz('Stimuli'));
%set(handles.text35,'String',lokaliz('Responses'));
%set(handles.text38,'String',lokaliz('and'));
set(handles.text_failu_filtras1,'String',lokaliz('Show_filenames_filter:'));
set(handles.text_failu_filtras2,'String',lokaliz('Select_filenames_filter:'));
%set(handles.radiobutton_cnt_set,'String',lokaliz('  *.cnt or *.set'));
set(handles.checkbox58,'String', lokaliz('mean of files') );
set(handles.checkbox59,'String', lokaliz('mean on channels') );
set(handles.checkbox73,'String', lokaliz('merge events') );
set(handles.checkbox61,'String', lokaliz('mean_amplitude') );
set(handles.checkbox67,'String', lokaliz('amplitude') );
set(handles.checkbox63,'String', lokaliz('minimum') );
set(handles.checkbox66,'String', lokaliz('maximum') );
set(handles.checkbox64,'String', lokaliz('time') );
set(handles.checkbox65,'String', lokaliz('area') );
set(handles.checkbox57,'String', lokaliz('Preview'));
set(handles.checkbox60,'String', lokaliz('Legend'));
set(handles.checkbox69,'String', lokaliz('Export ERP'));
%set(handles.checkbox71,'String', lokaliz('Export for RAGU'));
set(handles.checkbox_uzverti_pabaigus,'String',lokaliz('Close when complete'));
set(handles.checkbox_baigti_anksciau,'String',lokaliz('Break work'));
set(handles.checkbox_pabaigus_i_apdorotu_aplanka,'String',lokaliz('Go to saved files directory when completed'));
set(handles.checkbox_pabaigus_atverti,'String',lokaliz('Load saved files in EEGLAB when completed'));
set(handles.togglebutton1,'String', lokaliz('Cancel'));
set(handles.popupmenu11,'String', ...
    {lokaliz('of all files'), ...
     lokaliz('by subjects as in EEG.subject variable'), ...
     lokaliz('by groups as in EEG.group variable'), ...
     lokaliz('by conditions as in EEG.condition variable'), ...
     lokaliz('by sessions as in EEG.session variable'), ...
     lokaliz('by filters, separated by semicolons')});

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
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
set(handles.pushbutton11,'Enable','off'); drawnow;
[pasirinkti_ivykiai]=drb_uzklausa('ivykiai', ...
    get(handles.edit1,'String'), RINKMENOS, get(handles.pushbutton11,'UserData'));
set(handles.pushbutton11,'Enable','on');
if isempty(pasirinkti_ivykiai); return; end;
pasirinkti_ivykiai_str=pasirinkti_ivykiai{1};
for i=2:length(pasirinkti_ivykiai);
    pasirinkti_ivykiai_str=[pasirinkti_ivykiai_str ' ' pasirinkti_ivykiai{i}];
end;
set(handles.pushbutton11,'UserData',pasirinkti_ivykiai);
set(handles.edit59,'TooltipString',pasirinkti_ivykiai_str);
set(handles.edit59,'String',pasirinkti_ivykiai_str);
%set(handles.edit59,'UserData',pasirinkti_ivykiai_str);
if ~isempty(str2num(pasirinkti_ivykiai_str));
    edit59_Callback(hObject, eventdata, handles);
else
    set(handles.edit59,'BackgroundColor',[1 1 1]);
    try skiriasi=(~isempty(find(1- strcmp(senas,pasirinkti_ivykiai)))) ;
    catch err;
        skiriasi=true;
    end;
    if skiriasi;
        set(handles.listbox1,'UserData',{});
        ERP_perziura(hObject, eventdata, handles);
    end;
end;


% --- Executes on button press in checkbox58.
function checkbox58_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox58
popupmenu11_Callback(hObject, eventdata, handles);
%Ar_galima_vykdyti(hObject, eventdata, handles);
%ERP_perziura(hObject, eventdata, handles);

% --- Executes on button press in checkbox59.
function checkbox59_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox59

%if and(get(handles.checkbox59, 'Value'),...
%        strcmp(get(handles.checkbox59,'Enable'),'on'));
%    set(handles.checkbox58, 'Enable', 'on'); %
%else
%    set(handles.checkbox58, 'Enable', 'off'); % 
%end;
Ar_galima_vykdyti(hObject, eventdata, handles);
ERP_perziura(hObject, eventdata, handles);

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox61.
function checkbox61_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox61
if and(get(handles.checkbox61, 'Value'),get(handles.checkbox57,'Value'));
    set(handles.edit64, 'Visible', 'on'); % vid ampl
else
    set(handles.edit64, 'Visible', 'off'); % vid ampl
end;


% --- Executes on button press in checkbox63.
function checkbox63_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox63
if and(get(handles.checkbox63, 'Value'),get(handles.checkbox57,'Value'));
    set(handles.edit67, 'Visible', 'on'); % ampl pusei ploto
else
    set(handles.edit67, 'Visible', 'off');
end;


% --- Executes on button press in checkbox64.
function checkbox64_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox64

if and(get(handles.checkbox64, 'Value'),get(handles.checkbox57,'Value'));
    set(handles.edit66, 'Visible', 'on'); % laikas pusei ploto
else
    set(handles.edit66, 'Visible', 'off');
end;


% --- Executes on button press in checkbox65.
function checkbox65_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox65

if and(get(handles.checkbox65, 'Value'),get(handles.checkbox57,'Value'));
    set(handles.edit65, 'Visible', 'on'); % plotas
else
    set(handles.edit65, 'Visible', 'off');
end;

% --- Executes on button press in checkbox66.
function checkbox66_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox66
if and(get(handles.checkbox66, 'Value'),get(handles.checkbox57,'Value'));
    set(handles.edit68, 'Visible', 'on'); % ampl pusei ploto
else
    set(handles.edit68, 'Visible', 'off');
end;


% --- Executes on button press in checkbox67.
function checkbox67_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox67

if and(get(handles.checkbox67, 'Value'),get(handles.checkbox57,'Value'));
    set(handles.edit69, 'Visible', 'on'); % ampl pusei ploto
else
    set(handles.edit69, 'Visible', 'off');
end;



function edit64_Callback(hObject, eventdata, handles)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit64 as text
%        str2double(get(hObject,'String')) returns contents of edit64 as a double


% --- Executes during object creation, after setting all properties.
function edit64_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit65_Callback(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit65 as text
%        str2double(get(hObject,'String')) returns contents of edit65 as a double


% --- Executes during object creation, after setting all properties.
function edit65_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit66_Callback(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit66 as text
%        str2double(get(hObject,'String')) returns contents of edit66 as a double


% --- Executes during object creation, after setting all properties.
function edit66_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit67_Callback(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit67 as text
%        str2double(get(hObject,'String')) returns contents of edit67 as a double


% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit68_Callback(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit68 as text
%        str2double(get(hObject,'String')) returns contents of edit68 as a double


% --- Executes during object creation, after setting all properties.
function edit68_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit69_Callback(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit69 as text
%        str2double(get(hObject,'String')) returns contents of edit69 as a double


% --- Executes during object creation, after setting all properties.
function edit69_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox69.
function checkbox69_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox69
if and(get(handles.checkbox69,'Value'),...
    strcmp(get(handles.checkbox69,'Enable'),'on'));
    set(handles.edit70,'Enable','on');
    set(handles.popupmenu10,'Enable','on');    
else
    set(handles.edit70,'Enable','off');
    set(handles.popupmenu10,'Enable','off');
end;

if and(get(handles.checkbox58,'Value'),...
    get(handles.checkbox69,'Value'));
    Ar_galima_vykdyti(hObject, eventdata, handles);
end;
if and(get(handles.checkbox59,'Value'),...
    get(handles.checkbox69,'Value'));
    Ar_galima_vykdyti(hObject, eventdata, handles);
end;

% --- Executes on button press in checkbox70.
function checkbox70_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox70


% --- Executes on button press in checkbox71.
function checkbox71_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox71
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


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



function edit70_Callback(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit70 as text
%        str2double(get(hObject,'String')) returns contents of edit70 as a double
elementas=handles.edit70;
x=str2num(get(elementas,'String'));
if length(x) == 2 ;
    if x(1) < x(2);
        set(elementas,'UserData',regexprep(num2str(x), '[ ]*', ' '));        
        set(elementas,'BackgroundColor',[1 1 1]);
    end;
end;
if isempty(x);
    set(elementas,'UserData','');        
    set(elementas,'BackgroundColor',[1 1 1]);
end;
set(elementas,'String',num2str(get(elementas,'UserData')));

% --- Executes during object creation, after setting all properties.
function edit70_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ankstesni_kanalai=get(handles.text47,'TooltipString');
if ~isempty(Ankstesni_kanalai);
    Ankstesni_kanalai=textscan(Ankstesni_kanalai,'%s','delimiter',' ');
    seni=Ankstesni_kanalai{1};
else
    seni={};
end;
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
pasirinkti_kanalai=drb_uzklausa('kanalai', ...
    get(handles.edit1,'String'), RINKMENOS, seni);
set(handles.pushbutton14,'Enable','on');
if isempty(pasirinkti_kanalai); return; end;
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
ERP_perziura(hObject, eventdata, handles);


function ERP_perziura(hObject, eventdata, handles)
% Mastelis grafiko x ašiai.
% Jei mast=0.001 - tai sekundėmis, jei mast=1 - sekundėmis
mast=1;         

if strcmp(get(handles.checkbox57,'Enable'),'off');
    return;
end;
Fs=get(handles.listbox1,'String');
Fsi=get(handles.listbox1,'Value');
if isempty(Fs) || isempty(Fsi) ;
    set(handles.listbox1,'BackgroundColor',[1 1 0]);    pause(1);
    set(handles.listbox1,'BackgroundColor',[1 1 1]);    drawnow;
end;
if ~(get(handles.checkbox57, 'Value') && (~isempty(Fs)) && (~isempty(Fsi)) );
    set(handles.edit64, 'Visible', 'off'); % vid ampl
    set(handles.edit65, 'Visible', 'off'); % plotas
    set(handles.edit66, 'Visible', 'off'); % laikas pusei ploto
    set(handles.edit69, 'Visible', 'off'); % ampl puei ploto
    set(handles.edit67, 'Visible', 'off'); % min
    set(handles.edit68, 'Visible', 'off'); % max
    set(handles.slider3,'Visible','off');
    cla; grid off;
    legend('off');
    return;
end;

set(handles.checkbox57,'Enable','off');
set(handles.checkbox60,'UserData',get(handles.checkbox60, 'Enable'));
set(handles.checkbox60,'Enable','off');
set(handles.pushbutton1,'Enable','off');
set(handles.slider3,'Enable','inactive');
%warning('.');
drawnow;

%Ivykiai=str2num(get(handles.edit59,'String'));
Epochuoti_pagal_stimulus_=get(handles.pushbutton11,'UserData') ;
Pasirinkti_kanalai=get(handles.pushbutton14,'UserData');
if ~isempty(Pasirinkti_kanalai);
    Reikalingi_kanalai=Pasirinkti_kanalai;
else
    Reikalingi_kanalai={}; 
end;

axes(handles.axes1);
try
    %datacursormode off;
    %set(handles.text43, 'Visible', 'on');
    set(handles.togglebutton1, 'Style', 'togglebutton');
    set(handles.togglebutton1, 'String', lokaliz('Cancel'));
    set(handles.togglebutton1, 'Visible', 'on');
    set(handles.togglebutton1, 'Value', 0);
    %legend('off');
    drawnow;
    
    %disp(F);
    
    %hold on;
    ribos=str2num(get(handles.edit51,'String'));%*1000;
    %ALLEEG_=struct();
    %ALLEEG_=struct('file',{},'erp_data',{},'times',{},'chanlocs',{});
    %ALLEEG_=struct('setname',{},'filename',{},'filepath',{},'pnts',{},...
    % 'nbchan',{},'trials',{},'srate',{},'xmin',{},'xmax',{},'data',{},...
    % 'icawinv',{},'icasphere',{},'icaweights',{},'icaact',{},...
    % 'event',{},'epoch',{},'chanlocs',{},'comments',{},'averef',{}, ...
    % 'rt',{},'eventdescription',{},'epochdescription',{},'specdata',{}, ...
    % 'specicaact',{},'reject',{},'stats',{},'splinefile',{},'ref',{},...
    % 'history',{},'urevent',{},'times',{});
    ERP_savyb=struct('plotas',{},'vid_ampl',{},'pusplocio_x',{},'pusplocio_y',{},...
        'min_x',{},'min_y',{},'max_x',{},'max_y',{});
    legendoje={};
    %datacursormode on;
    
    [~,ALLEEG_,~]=pop_newset([],[],[]);
    ALLEEG_=setfield(ALLEEG_,'datfile',[]);
    ALLEEG_=setfield(ALLEEG_,'chanlocs2',[]);
    %mūsų papildymas:
    ALLEEG_=setfield(ALLEEG_,'file','');
    ALLEEG_=setfield(ALLEEG_,'erp_data',[]);
    ALLEEG_=setfield(ALLEEG_,'chans',{});
    
    Kelias=get(handles.edit1,'String');
    ALLEEGTMP=get(handles.listbox1,'UserData');    
    if isempty(ALLEEGTMP);
        %ALLEEGTMP=struct('file',{},'erp_data',{},'times',{},'chanlocs',{});
        ALLEEGTMP=ALLEEG_;
    end;
    
    for i=Fsi;
        try
        Rinkmena=Fs{i};        
        %EEGTMP = {};
        dFs={ALLEEGTMP.file};
        di=find(strcmp(dFs,Rinkmena)==1);
        if ~isempty(di);
            EEGTMP=ALLEEGTMP(di);
			if isempty(EEGTMP.epoch);
			    listbox1_val=setdiff(get(handles.listbox1,'Value'),i);
                if and(isempty(listbox1_val),length(Fs)==1); listbox1_val=1; end;
                set(handles.listbox1,'Value',listbox1_val);               
			   error([lokaliz('Not epoched data!') ' ' lokaliz('File') ': ' Rinkmena]);
			end;
        else
            [KELIAS_,Rinkmena_]=rinkmenos_tikslinimas(Kelias,Rinkmena);
            EEGTMP = pop_loadset('filename',Rinkmena_,'filepath',KELIAS_,'loadmode','info');
            EEGTMP.file=Rinkmena;
            if isempty(EEGTMP.epoch);
			    [ALLEEGTMP, EEGTMP, ~] = eeg_store(ALLEEGTMP, EEGTMP,i);
				set(handles.listbox1,'UserData',ALLEEGTMP); 
			    listbox1_val=setdiff(get(handles.listbox1,'Value'),i);
                if and(isempty(listbox1_val),length(Fs)==1); listbox1_val=1; end;
                set(handles.listbox1,'Value',listbox1_val);
                error([lokaliz('Not epoched data!') ' ' lokaliz('File') ': ' Rinkmena]);
            end;
            [ALLEEGTMP, EEGTMP, ~] = eeg_store(ALLEEGTMP, EEGTMP,i);
            [~, EEGTMP, ~] = pop_newset(EEGTMP, EEGTMP, 1,'retrieve',1,'study',0);
            if ~isempty(Epochuoti_pagal_stimulus_);
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
                            if isstr(EEGTMP.event(1).type);
                                Epochuoti_pagal_stimulus=[Epochuoti_pagal_stimulus orig_epoch];
                            else
                                Epochuoti_pagal_stimulus=[Epochuoti_pagal_stimulus num2str(str2num(orig_epoch))];
                            end;                            
                        else
                            warning([lokaliz('Internal error') '. ']);
                            disp(orig_epoch);
                        end;
                    end;
                EEGTMP = pop_selectevent( EEGTMP, ...
                    'type', Epochuoti_pagal_stimulus ,...
                    'deleteevents','off',...
                    'deleteepochs','on',...
                    'invertepochs','off');
            end;
            if isempty(EEGTMP.data);                
			    listbox1_val=setdiff(get(handles.listbox1,'Value'),i);
                if and(isempty(listbox1_val),length(Fs)==1); listbox1_val=1; end;
                set(handles.listbox1,'Value',listbox1_val);
                error([lokaliz('Empty dataset') '. ' lokaliz('File') ': ' Rinkmena]);
            end;
            EEGTMP=setfield(EEGTMP,'chanlocs2',[]);
            EEGTMP=setfield(EEGTMP,'erp_data',[]);
            EEGTMP=setfield(EEGTMP,'chans',{});
            %ALLEEGTMP(i)=EEGTMP;
            %[~, EEGTMP, ~] = eeg_store(ALLEEGTMP, EEGTMP);
            EEGTMP.erp_data=mean(EEGTMP.data,3);
            EEGTMP.data=[];
            ALLEEGTMP(i).erp_data=EEGTMP.erp_data;            
            set(handles.listbox1,'UserData',ALLEEGTMP);            
        end;
        
        if ~isempty(Reikalingi_kanalai);
            Reikalingi_kanalai_idx=find(ismember({EEGTMP.chanlocs.labels},Reikalingi_kanalai));
            %disp(Reikalingi_kanalai_idx);
            EEGTMP.erp_data=EEGTMP.erp_data(Reikalingi_kanalai_idx,:);
            %disp(length(EEGTMP.chanlocs));
            EEGTMP.chanlocs=EEGTMP.chanlocs(Reikalingi_kanalai_idx);            
            EEGTMP.nbchan=length(Reikalingi_kanalai_idx);
        end;
        
        %disp(plotas);
        %disp(size(get(handles.listbox1,'UserData')));
        
        if strcmp(ALLEEG_(1).file,'');
            %ALLEEG_(1)=EEGTMP;
            [ALLEEG_, EEGTMP, ~] = eeg_store(ALLEEG_, EEGTMP,1);
        else
            [ALLEEG_, EEGTMP, ~] = eeg_store(ALLEEG_, EEGTMP,1+length(ALLEEG_));
            %ALLEEG_(end+1)=EEGTMP;
        end;
        
        pask_eeg_i=length(ALLEEG_);
        
        if get(handles.checkbox59, 'Value');
            % Jei rodyti kanalų vidurkį
            ALLEEG_(pask_eeg_i).erp_data=mean(EEGTMP.erp_data,1);
            ALLEEG_(pask_eeg_i).chans={''};
            ALLEEG_(pask_eeg_i).chanlocs(1).labels=lokaliz('mean');
            lngdi=1+size(legendoje,1);
            legendoje{lngdi,1}=regexprep(Rinkmena,'.set$','');
            legendoje{lngdi,2}='';            
        else
            % Jei nerodyti kanalų vidurkio
            ALLEEG_(pask_eeg_i).erp_data=EEGTMP.erp_data;
            ALLEEG_(pask_eeg_i).chans={EEGTMP.chanlocs.labels};
            lngdi=1+size(legendoje,1) ;
            lngdi=lngdi:(lngdi+size(EEGTMP.erp_data,1) - 1);
            legendoje(lngdi,1)={regexprep(Rinkmena,'.set$','')};
            legendoje(lngdi,2)=ALLEEG_(pask_eeg_i).chans;           
        end;
        
        if ~get(handles.checkbox58, 'Value');        
           [ERP_savyb(pask_eeg_i).plotas,        ERP_savyb(pask_eeg_i).vid_ampl,...
                ERP_savyb(pask_eeg_i).pusplocio_x,ERP_savyb(pask_eeg_i).pusplocio_y,...
                ERP_savyb(pask_eeg_i).min_x,      ERP_savyb(pask_eeg_i).min_y,...
                ERP_savyb(pask_eeg_i).max_x,      ERP_savyb(pask_eeg_i).max_y...
                ]=ERP_savybes(ALLEEG_(pask_eeg_i),ribos);
        end;
        
        catch err;
            Pranesk_apie_klaida(err, lokaliz('Preview'), '', 0);
             %warning(err.message);
             %disp(err.message);
        end;
        
        EEGTMP = {};
        
        drawnow;
        if get(handles.togglebutton1, 'Value');
            break;
        end;        
        
    end;
    
    Fsi2=get(handles.listbox1,'Value');
    rodyti_ypatingas_grupes=(get(handles.checkbox58, 'Value') && (get(handles.popupmenu11,'Value') > 1));
    
    if length(ALLEEG_)>1;
        if get(handles.checkbox58, 'Value');
            if isequal(ALLEEG_.times);
                uniq_kan=unique({legendoje{:,2}});
                [~,ALLEEG__,~]=pop_newset([],[],[]);
                uniq_kan_N=length(uniq_kan);
                legendoje={};
                
                switch get(handles.popupmenu11,'Value')
                    case 1
                        grpsar={lokaliz('mean')} ;
                        grpN=length(grpsar);
                        grpnar{1}=1:length(ALLEEG_);
                        rodyti_ypatingas_grupes=0;  % išimtis visuotiniam vidurkinimui
                    case 2
                        grpsar=unique({ALLEEG_.subject});
                        grpN=length(grpsar);
                        for grpid=1:grpN;
                            grpnar{grpid}=find(ismember({ALLEEG_.subject},grpsar{grpid}));
                        end;
                    case 3
                        grpsar=unique({ALLEEG_.group});
                        grpN=length(grpsar);
                        for grpid=1:grpN;
                            grpnar{grpid}=find(ismember({ALLEEG_.group},grpsar{grpid}));
                        end;
                    case 4
                        grpsar=unique({ALLEEG_.condition});
                        grpN=length(grpsar);
                        for grpid=1:grpN;
                            grpnar{grpid}=find(ismember({ALLEEG_.condition},grpsar{grpid}));
                        end;
                    case 5
                        for sesid=1:length(ALLEEG_);
                            if ~ischar(ALLEEG_(sesid).session);
                                ALLEEG_(sesid).session=num2str(ALLEEG_(sesid).session);
                            end;
                        end;
                        grpsar=unique({ALLEEG_.session});
                        grpN=length(grpsar);
                        for grpid=1:grpN;
                            grpnar{grpid}=find(ismember({ALLEEG_.session},grpsar{grpid}));
                        end;
                    case 6                        
                        if strcmp(get(handles.edit_failu_filtras2,'Style'),'edit') ;
                            grpsar=regexp(get(handles.edit_failu_filtras2,'String'),';', 'split');
                            grpN=length(grpsar);
                            for grpid=1:grpN;
                                FAILAI_filtruoti_=atrinkti_teksta(Fs(Fsi2),grpsar{grpid});
                                grpnar_=find(ismember(Fs(Fsi2),FAILAI_filtruoti_));
                                grpnar{grpid}=grpnar_';
                            end;                            
                        else
                            grpsar={lokaliz('mean')};
                            grpN=length(grpsar);
                            grpnar{1}=1:length(ALLEEG_);
                        end;
                    otherwise 
                        warning(lokaliz('Internal error'));
                        grpsar={lokaliz('mean')} ;
                        grpN=length(grpsar);
                        grpnar=1:length(ALLEEG_);
                end;
                                
                for grpid=1:grpN;
                    
                    if isempty(grpsar{grpid});
                        grpsar{grpid}='?';
                    end;
                    ALLEEG__(grpid).file=grpsar{grpid};
                    ALLEEG__(grpid).times=ALLEEG_(grpid).times;
                    ALLEEG__(grpid).srate=ALLEEG_(grpid).srate;
                    for k=1:uniq_kan_N;
                        tmp=[];
                        di=1;
                        for d=grpnar{grpid};
                            idx=find(ismember(ALLEEG_(d).chans,uniq_kan{k}));
                            if ~isempty(idx);
                                tmp(di,1:length(ALLEEG__(grpid).times))=ALLEEG_(d).erp_data(idx,:);
                            end;
                            di=di+1;
                        end;
                        %assignin('base','tmp',tmp)
                        ALLEEG__(grpid).erp_data(k,1:length(ALLEEG__(grpid).times))=mean(tmp,1);
                    end;
                    legendoje((1+((grpid-1)*uniq_kan_N)):(uniq_kan_N*grpid),1)={grpsar{grpid}};
                    legendoje((1+((grpid-1)*uniq_kan_N)):(uniq_kan_N*grpid),2)=uniq_kan';
                    
                    [ERP_savyb(grpid).plotas,        ERP_savyb(grpid).vid_ampl,...
                        ERP_savyb(grpid).pusplocio_x,ERP_savyb(grpid).pusplocio_y,...
                        ERP_savyb(grpid).min_x,      ERP_savyb(grpid).min_y,...
                        ERP_savyb(grpid).max_x,      ERP_savyb(grpid).max_y...
                        ]=ERP_savybes(ALLEEG__(grpid),ribos);
                    
                end;
                
                ALLEEG_=ALLEEG__;
                
            else
                wrn=warning('off','backtrace');
                warning([mfilename ': ' lokaliz('ERP grupe nevidurkintina: ERP laikai nesuderinami!')]);
                warning(wrn.state, 'backtrace');
                rodyti_ypatingas_grupes=0;
                for d=1:length(ALLEEG_);
                   [ERP_savyb(d).plotas,     ERP_savyb(d).vid_ampl,...
                    ERP_savyb(d).pusplocio_x,ERP_savyb(d).pusplocio_y,...
                    ERP_savyb(d).min_x,      ERP_savyb(d).min_y,...
                    ERP_savyb(d).max_x,      ERP_savyb(d).max_y...
                    ]=ERP_savybes(ALLEEG_(d),ribos);
                end;
            end;
        end;
    elseif ~isempty(ALLEEG_(1).file);
        
                   [ERP_savyb(1).plotas,     ERP_savyb(1).vid_ampl,...
                    ERP_savyb(1).pusplocio_x,ERP_savyb(1).pusplocio_y,...
                    ERP_savyb(1).min_x,      ERP_savyb(1).min_y,...
                    ERP_savyb(1).max_x,      ERP_savyb(1).max_y...
                    ]=ERP_savybes(ALLEEG_(1),ribos);
                
                if get(handles.checkbox58, 'Value');
                    switch get(handles.popupmenu11,'Value');
                        case 2;
                            legendoje{1,1}=ALLEEG_(1).subject;
                        case 3;
                            legendoje{1,1}=ALLEEG_(1).group;
                        case 4;
                            legendoje{1,1}=ALLEEG_(1).condition;
                        case 5;
                            legendoje{1,1}=ALLEEG_(1).session;
                    end;
                    if isempty(legendoje{1,1});
                        legendoje{1,1}='?';
                    end;
                    if isnumeric(legendoje{1,1});
                        legendoje{1,1}=num2str(legendoje{1,1});
                    end;
                    for lgndi=2:size(legendoje,1);
                        legendoje{lgndi,1}=legendoje{1,1};
                    end;
                end;
    end;
        
    set(handles.edit64, 'String', mean(mean([ERP_savyb.vid_ampl]))); % vid ampl
    set(handles.edit65, 'String', mast*mean(mean([ERP_savyb.plotas]))); % plotas
    set(handles.edit66, 'String', mast*mean(mean([ERP_savyb.pusplocio_x]))); % laikas pusei ploto
    set(handles.edit69, 'String', mean(mean([ERP_savyb.pusplocio_y]))); % ampl puei ploto
    set(handles.edit67, 'String', mean(mean([ERP_savyb.min_y]))); % min
    set(handles.edit68, 'String', mean(mean([ERP_savyb.max_y]))); % max
    
    % Išvalyti seną paveikslą
    axes(handles.axes1);
    cla;
    
    % Naujas paveikslas
    linijos={'-' '--' '-.'};
    colormap('colorcube');   spalvos1=colormap;
    spalvos1=spalvos1([1:63],:);
    colormap('lines'); spalvos2=colormap; spalvos2=spalvos2(1:7,:);
    spalvos=[spalvos2; spalvos1];
    colormap(spalvos);
    %colormap('default');
    if isempty(ALLEEG_(1).file);
        reikia_valyti_grafika=1;
    else
        set(handles.axes1, 'UserData', size(legendoje,1));
        xmin=min(min([ALLEEG_.times]));
        xmax=max(max([ALLEEG_.times]));
        xmin_=xmin - 0.05*(xmax-xmin);
        xmax_=xmax + 0.05*(xmax-xmin);
        netusti=find(arrayfun(@(x) ...
            and(~isempty(ALLEEG_(x).erp_data),...
            ~any(isnan(ALLEEG_(x).erp_data(:)))), ...
            1:length(ALLEEG_)));
        if isempty(netusti);
            reikia_valyti_grafika=1;
            wrn=warning('off','backtrace');
            warning(lokaliz('No selected channels found in selected files.'));
            warning(wrn.state, 'backtrace');
            set(handles.pushbutton14,'BackgroundColor',[1 1 0]);    pause(1);
            set(handles.pushbutton14,'BackgroundColor','remove');    drawnow;
        else
            reikia_valyti_grafika=0;
            ymin=min(arrayfun(@(x) min(min(ALLEEG_(x).erp_data, [], 2)), netusti));
            ymax=max(arrayfun(@(x) max(max(ALLEEG_(x).erp_data, [], 2)), netusti));
            ymin_=ymin - 0.05*(ymax-ymin);
            ymax_=ymax + 0.05*(ymax-ymin);
            %d=get(handles.listbox1,'UserData');
            hold on;
            %if ~get(handles.checkbox58,'Value');
            %tmp=struct('times',[]);
            %for x=1:size(ALLEEG_,1);
            %    tmp(x).times=[mast*ALLEEG_(x).times]';
            %end;
            %%tmp_times=arrayfun(@(x) mast*ALLEEG_(x).times,1:size(ALLEEG_,1), 'UniformOutput', false);
            %viskas={tmp.times ; ALLEEG_.erp_data};
            %viskas={ALLEEG_.times ; ALLEEG_.erp_data};
            %plot(viskas{:});
            lni=1; spi=0;
            for i=1:length(ALLEEG_);
                for j=1:size(ALLEEG_(i).erp_data,1);
                    spi=1+mod(spi,length(spalvos));
                    splv=spalvos(spi,:);
                    plot(ALLEEG_(i).times, ALLEEG_(i).erp_data(j,:), 'LineStyle',linijos{lni},'color',splv);
                end;
                %lni=1+mod(lni,length(linijos));
            end;
            %end;
            
            if (size(legendoje,1)==1) && ~rodyti_ypatingas_grupes;
                %plot(mast*[ERP_savyb.pusplocio_x],[ERP_savyb.pusplocio_y],'*','Color','g');
                %plot(mast*[ERP_savyb.max_x],[ERP_savyb.max_y],'+','Color',[1 0 0.6]);
                %plot(mast*[ERP_savyb.min_x],[ERP_savyb.min_y],'+','Color',[1 0.5 0]);
                irasu_kiekis_legendoje=1;
                irasai_legendoje={lokaliz('ERP')};
                if get(handles.checkbox64, 'Value') || get(handles.checkbox67, 'Value');
                    plot([ERP_savyb.pusplocio_x],[ERP_savyb.pusplocio_y],'*','Color','g');
                    irasu_kiekis_legendoje=irasu_kiekis_legendoje+1;
                    irasai_legendoje=[irasai_legendoje {lokaliz('half_area')} ];
                end;
                if get(handles.checkbox63, 'Value')
                    plot([ERP_savyb.min_x],[ERP_savyb.min_y],'+','Color',[1 0.6 0]);
                    irasu_kiekis_legendoje=irasu_kiekis_legendoje+1;
                    irasai_legendoje=[irasai_legendoje {lokaliz('minimum_short')} ];
                end;
                if get(handles.checkbox66, 'Value')
                    plot([ERP_savyb.max_x],[ERP_savyb.max_y],'+','Color',[1 0 0.6]);
                    irasu_kiekis_legendoje=irasu_kiekis_legendoje+1;
                    irasai_legendoje=[irasai_legendoje {lokaliz('maximum_short')} ];
                end;
                legend(irasai_legendoje,'FontSize', 6, 'Location', 'eastoutside', 'Interpreter', 'none');
                set(handles.axes1, 'UserData', irasu_kiekis_legendoje);
            elseif and(get(handles.checkbox58,'Value'),strcmp(get(handles.checkbox58,'Enable'),'on'));
                    %if isequal(ALLEEG_.times);
                    %    plot(mast*ALLEEG_(1).times,mean(ALLEEG_.erp_data));
                    %    plot(ALLEEG_(1).times,mean(cell2mat({ALLEEG_.erp_data}')),'LineWidth',3,'color','k');
                    %else
                    %    warning('Nesutampa duomenų laikai');
                    %    %set(handles.checkbox58,'Value',0);
                    %    %drawnow;
                    %end;
            end;
            %disp([xmin_ xmax_ ymin_ ymax_]);
            if length(ribos) == 2 ;
                %ribos=1000*ribos;
                %plot(mast*[ribos(1) ribos(1)],[ymin_ ymax_],'--', mast*[ribos(2) ribos(2)], [ymin_ ymax_],'--','Color',[0.5 0.5 0.5]);
                plot([ribos(1) ribos(1)],[ymin_ ymax_],'--', [ribos(2) ribos(2)], [ymin_ ymax_],'--','Color',[0.5 0.5 0.5]);
                SliderMin=round(xmin-1);
                SliderMax=2+round(xmax-(ribos(2)-ribos(1)));
                slider_val=max(min(ribos(1),SliderMax),SliderMin);
                set(handles.slider3,'Value',slider_val);
                set(handles.slider3,'Min',SliderMin);
                set(handles.slider3,'Max',SliderMax);
                SliderStep2=0.01*round(100*(ribos(2)-ribos(1))/(xmax-xmin-(ribos(2)-ribos(1))));
                set(handles.slider3,'SliderStep',[0.01 max(0.01,SliderStep2)]);
                set(handles.slider3,'Visible','on');
                set(handles.slider3,'Enable','on');
                %ribos=0.001*ribos;
            else
                set(handles.slider3,'Visible','off');
            end;
            %plot(mast*[xmin_ xmax_],[0 0], [0 0], [ymin_ ymax_],'-','Color','k');
            plot([xmin_ xmax_],[0 0], [0 0], [ymin_ ymax_],'-','Color','k');
            %set(gca,'XLim',mast*[xmin_ xmax_],'YLim',[ymin_ ymax_]);
            set(gca,'XLim',[xmin_ xmax_],'YLim',[ymin_ ymax_]);
            %set(handles.listbox1,'UserData',d);
            if (size(legendoje,1)>1) || rodyti_ypatingas_grupes;
                %legendoje
                legendos_param={'FontSize', 6, 'Location', 'eastoutside', 'Interpreter', 'none'};
                skirtingu_failu=length(unique(legendoje(:,1)'));
                skirtingu_kanalu=length(unique(legendoje(:,2)'));
                if and(skirtingu_failu > 1, skirtingu_kanalu > 1);
                    legendos_irasai=cellfun(@(z) sprintf('%s: %s', legendoje{z,1},legendoje{z,2}), num2cell(1:size(legendoje,1)),'UniformOutput',false);
                elseif (skirtingu_kanalu==1);
                    legendos_irasai=legendoje(:,1);
                else%if (skirtingu_failu==1);
                    legendos_irasai=legendoje(:,2);
                end;
                legend(legendos_irasai,legendos_param{:});
                legend('show');
            end;
            if or(size(legendoje,1)==0,~get(handles.checkbox60, 'Value'));
                legend('off');
            end;
        end;
    end;
    if reikia_valyti_grafika;        
        set(handles.axes1, 'UserData', 0);
        set(handles.slider3,'Visible','off');
        legend('off');
    end;
    if mast==1;
        xlabel([lokaliz('Time') ', ' lokaliz('miliseconds_short') ], 'FontSize',10);
    elseif mast==0.001;
        xlabel([lokaliz('Time') ', ' lokaliz('seconds_short') ], 'FontSize',10);
    else
        xlabel([lokaliz('Time')], 'FontSize',10);
    end;
    ylabel([lokaliz('Amplitude') ', ' lokaliz('microV') ], 'FontSize',10);
    grid on;
    set(handles.axes1, 'Visible', 'on');

    % Koreliacijų rodymas
    try
        if length(ribos) == 2;
            kor_lent_v=['Koreliacijos: [' num2str(ribos(1)) ' ' num2str(ribos(2)) '] ms'];
        else
            kor_lent_v='Koreliacijos';
        end;
        kor_lent_h=getappdata(handles.figure1, 'kor_lent_h'); % evalin('base','h');
        kor_lent_i=getappdata(handles.figure1, 'kor_lent_i'); % evalin('base','id');
        kor_lent_d=getappdata(handles.figure1, 'kor_lent_d'); % evalin('base','d');
        if length(kor_lent_i) ~= size(kor_lent_d,1); error('netinka'); end;
        if length(kor_lent_h) ~= size(kor_lent_d,2); error('netinka'); end;
        kor_lent_idx=zeros(1,length(kor_lent_i));
        kor_lent_l={ALLEEG_.file};
        for i=1:length(kor_lent_i);
            g=regexp(kor_lent_l, ['^' kor_lent_i{i} '[^0-9]']); 
            n=find(arrayfun(@(x) ~isempty(g{x}), 1:length(g)));
            if length(n) == 1;
                kor_lent_idx(i)=n;
            end;
        end;
        kor_lent_netusti=find(kor_lent_idx);
        if length(kor_lent_netusti) < 5; error('netinka'); end;
        kor_lent_d=kor_lent_d(kor_lent_netusti,:);
        kor_lent_y=length(ERP_savyb(1).vid_ampl);
        kor_lent_a=nan(length(kor_lent_netusti),kor_lent_y);
        kor_lent_k={};
        for i=1:length(kor_lent_netusti);
            tmpid=kor_lent_idx(kor_lent_netusti(i));
            for ii=1:length(ERP_savyb(tmpid).vid_ampl);
                kl=ALLEEG_(tmpid).chanlocs(ii).labels;
                ki=find(ismember(kor_lent_k,kl));
                if isempty(ki);
                    kor_lent_k=[kor_lent_k kl];
                    ki=length(kor_lent_k);
                end;
                kor_lent_a(i,ki)=ERP_savyb(tmpid).vid_ampl(ii);
            end;
        end;
        [kor_r,kor_p]=corr(kor_lent_d,kor_lent_a,'rows','pairwise','type','Spearman'); % 'Pearson' arba 'Spearman'
        kor_r_=num2cell(kor_r);
        disp(' ');
        disp(kor_lent_v);
        %disp(' '); disp([ 'r' kor_lent_k ; kor_lent_h' kor_r_]);
        disp(' ');
        for i=1:length(kor_lent_h);
            for kor_p_i=find(kor_p(i,:)<0.05);
                fprintf('r = %1.3f, p = %1.4f - %s <-> %s\n', kor_r(i,kor_p_i), kor_p(i,kor_p_i), kor_lent_h{i}, kor_lent_k{kor_p_i});
                kor_r_{i,kor_p_i}=['<html><table bgcolor=yellow><tr><td>' num2str(kor_r(i,kor_p_i)) '</td></tr></table><html>' ];
            end;
        end;
        kor_lent_f=figure('Toolbar','none','Menubar','none','NumberTitle','off','Name',kor_lent_v);
        kor_lent_t=uitable(kor_lent_f,'data',kor_r_,'ColumnName', kor_lent_k, 'RowName', kor_lent_h, ...
            'Units', 'normalized', 'position', [0 0 1 1],'tag','koreliaciju_lentele');
        disp(' ');
    catch %err; Pranesk_apie_klaida(err,'','',0);
    end

if ~isempty(ALLEEG_);
if get(handles.checkbox61, 'Value');
    set(handles.edit64, 'Visible', 'on'); % vid ampl
end;
if get(handles.checkbox65, 'Value');
    set(handles.edit65, 'Visible', 'on'); % plotas
end;
if get(handles.checkbox64, 'Value');
    set(handles.edit66, 'Visible', 'on'); % laikas pusei ploto
end;
if get(handles.checkbox67, 'Value');
    set(handles.edit69, 'Visible', 'on'); % ampl pusei ploto
end;
if get(handles.checkbox63, 'Value');
    set(handles.edit67, 'Visible', 'on'); % min
end;
if get(handles.checkbox66, 'Value');
    set(handles.edit68, 'Visible', 'on'); % max
end
else
    set(handles.edit64, 'Visible', 'off'); % vid ampl
    set(handles.edit65, 'Visible', 'off'); % plotas
    set(handles.edit66, 'Visible', 'off'); % laikas pusei ploto
    set(handles.edit69, 'Visible', 'off'); % ampl puei ploto
    set(handles.edit67, 'Visible', 'off'); % min
    set(handles.edit68, 'Visible', 'off'); % max
end;
catch err;
    Pranesk_apie_klaida(err, lokaliz('Preview'), '', 0);
end;
set(handles.togglebutton1, 'Visible', 'off');
set(handles.checkbox57,'Enable','on');
set(handles.checkbox60,'Enable',get(handles.checkbox60, 'UserData'));
if get(handles.checkbox72, 'Value');
    set(handles.axes1,'YDir','normal');
else
    set(handles.axes1,'YDir','reverse');
end;
drawnow;
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes on button press in checkbox60.
function checkbox60_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox60

% Legendos įjungimas/išjungimas

axes(handles.axes1);
legenda(hObject, eventdata, handles);

function legenda(hObject, eventdata, handles)
if get(handles.checkbox60, 'Value');
    l=legend('show');
    lstr=get(l, 'String');
    %ribos=str2num(get(handles.edit51,'String'));
    %atmest_ir=length(ribos)+2;
    %legend('boxoff');
    lk=get(handles.axes1, 'UserData');    
    if lk > 0; 
        legend(lstr(1:min(lk,size(lstr,2))), 'FontSize', 6, 'Location', 'EastOutside', 'Interpreter', 'none');
    end;
    set(handles.axes1,'units','normalized','Position',[0.12 0.15 0.65 0.8]);
else
    %legend('hide');
    legend('off');
    set(handles.axes1,'units','normalized','Position',[0.12 0.15 0.85 0.8]);
end;
drawnow;


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10
if get(handles.popupmenu10,'Value') == 3;
    set(handles.edit70,'Visible','on');
    if ~ispc;
        warning([ lokaliz('Export ERP') ': Excel + Windows!']);
        warndlg('Excel + Windows!', lokaliz('Export ERP'));
    end;
else    
    set(handles.edit70,'Visible','off');
end;
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end;


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sena=str2num(get(handles.edit51,'String'));
if length(sena) ~= 2;    
   set(handles.slider3,'Visible','off');
   return;
end;
nauja=5*round(0.2*get(handles.slider3,'Value'));
nauja=[nauja nauja+(sena(2)-sena(1))];
nauja=regexprep(num2str(nauja), '[ ]*', ' ');
set(handles.edit51,'String',nauja);
ERP_perziura(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


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
ERP_perziura(hObject, eventdata, handles);


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


% --- Executes on button press in checkbox72.
function checkbox72_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox72

if get(handles.checkbox72, 'Value');
    set(handles.axes1,'YDir','normal');
else
    set(handles.axes1,'YDir','reverse');
end;
drawnow;


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
pele=get(handles.figure1,'SelectionType');
if ~get(handles.checkbox57, 'Value') && strcmpi(pele,'normal');
    return;
end;
if strcmpi(pele,'extend');
    if strcmp(get(handles.checkbox57,'Enable'),'off');
        return;
    end;
    try axes1_ButtonDownFcn2(hObject, eventdata, handles); catch; end;
else
    try axes1_ButtonDownFcn1(hObject, eventdata, handles); catch; end;
end;

function axes1_ButtonDownFcn1(hObject, eventdata, handles)
h2 = figure;
set(h2,'Visible','off');
try
    set(handles.togglebutton1, 'Style', 'pushbutton');
    set(handles.togglebutton1, 'String', lokaliz('Palaukite!'));
    set(handles.togglebutton1, 'Visible','on')
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
    V=version('-release');
    if str2num(V(1:end-1)) < 2014;
        set(a2,'units','normalized','Position',[0.1 0.1 0.65 0.8]);
    end;
    figure(h2);
    datacursormode on;
    try delete(fn); catch; end;
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
set(handles.togglebutton1,'Visible','off');
set(h2,'Visible','on');
drawnow;
spausdinti=getappdata(handles.axes1, 'spausdinti');
if ~isempty(spausdinti);
    pavad=fullfile(get(handles.edit2,'String'), getappdata(handles.axes1, 'pavadinimas'));
    for i=1:length(spausdinti);
        try print(h2,pavad,spausdinti{i}); catch err; Pranesk_apie_klaida(err,'','',0) ;end;
    end;
    %pause(1);
    delete(h2);
    setappdata(handles.axes1, 'spausdinti', []);
end;

function axes1_ButtonDownFcn2(hObject, eventdata, handles)
%a=inputdlg({'Rinkmenos priesaga prie atvejo:'},'Lentelės įkėlimas',1,{'.set'});
%Priesaga=a{1};
Priesaga='';
try
[h,i,d]=importuoti_lentele('',Priesaga);
catch err; Pranesk_apie_klaida(err,'','',0);
end;
if length(i) ~= size(d,1); return; end;
if length(h) ~= size(d,2); return; end;
setappdata(handles.figure1, 'kor_lent_h', h); assignin('base','kor_lent_h',h);
setappdata(handles.figure1, 'kor_lent_i', i); assignin('base','kor_lent_i',i);
setappdata(handles.figure1, 'kor_lent_d', d); assignin('base','kor_lent_d',d);
msgbox('Pavyko įkelti lentelę!','Pavyko!');
ERP_perziura(hObject, eventdata, handles);

function [h,id,d]=importuoti_lentele(varargin)
h={'-'};id={};d=[];
if nargin > 0;
    rinkmena=varargin{1};
else
    rinkmena='';
end;
if nargin > 1;
    id_priesaga=varargin{2};
else
    id_priesaga='';
end;
if isempty(rinkmena) || ~exist(rinkmena,'file');
    [f,p] = uigetfile({'*.txt','*.txt';'*.*','*.*'},'Pasirinkite duomenis','','MultiSelect','off');
    if f == 0; return; end;
    rinkmena=fullfile(p,f);
end;
fid=fopen(rinkmena, 'r');
h1=regexprep(regexprep(fgets(fid),'[ \t]*\n',''),'[ \t]*\r','');
h1=strrep(h1,' ','_');
h=textscan(h1,'%s',1+length(regexp(h1,'\t')));
h=h{1}'; h=h(2:end);
id={}; t='';
while ischar(t);
    if ~isempty(t);
        id1=textscan(t,'%s',1);
        id=[id ; { [ id1{1}{1} id_priesaga ] } ];
    end;
    t=fgets(fid);
end;
fclose(fid);
d=dlmread(rinkmena,'',1,1);

function spausdinimas_pagal_kanalus(hObject, eventdata, handles)
spausdinimas_pagal(hObject, eventdata, handles, 'kanalai')

function spausdinimas_pagal_tiriamuosius(hObject, eventdata, handles)
spausdinimas_pagal(hObject, eventdata, handles, 'tiriamieji')

function spausdinimas_pagal(hObject, eventdata, handles, raktas)
% raktas - 'kanalai' | 'tiriamieji'
Rinkmenu_id=get(handles.listbox1,'Value');
if isempty(Rinkmenu_id); return; end;
% pradinis_rodymas=get(handles.checkbox57, 'Value');
set(handles.checkbox57, 'Value', 0);
switch raktas;
    case {'kanalai'};
        pradiniai_kanalai1=get(handles.pushbutton14, 'UserData');
        pradiniai_kanalai2=get(handles.text47, 'TooltipString');
        pradiniai_kanalai3=get(handles.text47, 'String');
        pradiniai_kanalai4=get(handles.checkbox59, 'Value');
        set(handles.checkbox59, 'Value',0);
        pushbutton14_Callback(hObject, eventdata, handles);
        kanalai=get(handles.pushbutton14, 'UserData');
        rakto_nariai=kanalai;
    otherwise
        pradinis_vidurkinimas=get(handles.checkbox58, 'Value');
        % visuminį paveikslą spausdinsime dukart: mastelio parinkimui ir pg. parinktis
        set(handles.checkbox58, 'Value',0);
        % rakto_nariai apibrėžti toliau
end;
paveikslu_sar={'BMP' 'JPEG' 'PNG' 'TIFF' 'EPS' 'EPS mono' 'PDF' 'PS' 'PS mono' 'SVG' };
paveikslu_id=listdlg('OKString',lokaliz('OK'),'CancelString',lokaliz('Cancel'), ...
    'SelectionMode','multiple','ListString',paveikslu_sar,'InitialValue',3);
if ~isempty(paveikslu_id);
    paveikslu_spausd={'-dbmp' '-djpeg' '-dpng' '-dtiff' '-depsc' '-deps' '-dpdf' '-dpsc' '-dps' '-dsvg'};
    paveikslai=paveikslu_spausd(paveikslu_id);
    set(handles.checkbox57, 'Value', 1);
    if strcmpi(raktas,'kanalai');
        spausdinimo_zingsnelis(hObject, eventdata, handles, kanalai, paveikslai, lokaliz('all'), [], []);
        xlim=get(handles.axes1, 'XLim');
        ylim=get(handles.axes1, 'YLim');
    else
        ERP_perziura(hObject, eventdata, handles);
        xlim=get(handles.axes1, 'XLim');
        ylim=get(handles.axes1, 'YLim');
        set(handles.checkbox58, 'Value',pradinis_vidurkinimas);
        spausdinimo_zingsnelis(hObject, eventdata, handles, [], paveikslai, lokaliz('all'), xlim, ylim);
    end;
    switch raktas
        case {'tiriamieji'}
            ALLEEG_=get(handles.listbox1,'UserData');
            if isempty(ALLEEG_); return; end;
            tiriamieji_kart={ALLEEG_(Rinkmenu_id).subject};
            rakto_nariai=unique(tiriamieji_kart);
    end;
    for i=1:length(rakto_nariai);
        switch raktas
            case {'kanalai'};
                spausdinimo_zingsnelis(hObject, eventdata, handles, kanalai(i), paveikslai, kanalai{i}, xlim, ylim);
            case {'tiriamieji'}
                set(handles.listbox1,'Value',Rinkmenu_id(find(ismember(tiriamieji_kart,rakto_nariai{i}))));
                spausdinimo_zingsnelis(hObject, eventdata, handles, [], paveikslai, rakto_nariai{i}, xlim, ylim);
        end;
    end;
    set(handles.checkbox57, 'Value', 0); % pradinis_rodymas
end;
switch raktas;
    case {'kanalai'};
        set(handles.pushbutton14, 'UserData', pradiniai_kanalai1);
        set(handles.text47,  'TooltipString', pradiniai_kanalai2);
        set(handles.text47,       'String',   pradiniai_kanalai3);
        set(handles.checkbox59,   'Value',    pradiniai_kanalai4);
    case {'tiriamieji'}
        set(handles.listbox1,'Value',Rinkmenu_id);
end;
ERP_perziura(hObject, eventdata, handles);


function spausdinimo_zingsnelis(hObject, eventdata, handles, kanalai, paveikslai, pavadinimas, xlim, ylim)
    if ~isempty(kanalai);
       set(handles.pushbutton14, 'UserData', kanalai);
       set(handles.text47,'TooltipString', pavadinimas);
    end;    
    ERP_perziura(hObject, eventdata, handles);
    setappdata(handles.axes1, 'spausdinti', paveikslai);
    setappdata(handles.axes1, 'pavadinimas', pavadinimas);
    if ~isempty(xlim);
        set(handles.axes1, 'XLim', xlim);
    end;
    if ~isempty(ylim);
        set(handles.axes1, 'YLim', ylim);
    end;
    axes1_ButtonDownFcn(hObject, eventdata, handles);
    setappdata(handles.axes1, 'spausdinti', []);
    setappdata(handles.axes1, 'pavadinimas', '');


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11
if and(get(handles.checkbox58,'Value'),...
        strcmp('on',get(handles.checkbox58,'Enable')))
    set(handles.popupmenu11,'Enable','on');
else
    set(handles.popupmenu11,'Enable','off');
end;
strl=get(handles.popupmenu11,'String');
set(handles.popupmenu11,'Tooltip', [ lokaliz('mean of files') ': ' strl{get(handles.popupmenu11,'Value')}] );


Ar_galima_vykdyti(hObject, eventdata, handles);
ERP_perziura(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox73.
function checkbox73_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox73


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
    'checkbox61' 'checkbox65' 'checkbox64' 'checkbox63' 'checkbox66' 'checkbox67' ...
    'checkbox73' 'checkbox59' 'checkbox58' 'checkbox57' 'checkbox60' 'checkbox72' 'checkbox69' ...
    'pushbutton14' 'pushbutton11' 'pushbutton15' 'popupmenu9' 'popupmenu10' 'popupmenu11' ...
    'radiobutton6' 'radiobutton7' };
    
isimintini(2).raktai={'Value' 'UserData' 'String'};
isimintini(2).nariai={ 'edit51' 'edit60' 'edit70' };

isimintini(3).raktai={'Value' 'UserData' 'String' 'TooltipString'};
isimintini(3).nariai={ 'text47' 'edit59' };
drb_parinktys(hObject, eventdata, handles, 'irasyti', mfilename, vardas, komentaras, isimintini);

