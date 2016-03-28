%
% Išmanus pop_pervadinimas su galimybe atnaujinti EEGLAB duomenų inormaciją
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

function varargout = pop_pervadinimas(varargin)
% POP_PERVADINIMAS MATLAB code for pop_pervadinimas.fig
%      POP_PERVADINIMAS, by itself, creates a new POP_PERVADINIMAS or raises the existing
%      singleton*.
%
%      H = POP_PERVADINIMAS returns the handle to a new POP_PERVADINIMAS or the handle to
%      the existing singleton*.
%
%      POP_PERVADINIMAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_PERVADINIMAS.M with the given input arguments.
%
%      POP_PERVADINIMAS('Property','Value',...) creates a new POP_PERVADINIMAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_pervadinimas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_pervadinimas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_pervadinimas

% Last Modified by GUIDE v2.5 07-Aug-2015 21:38:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_pervadinimas_OpeningFcn, ...
    'gui_OutputFcn',  @pop_pervadinimas_OutputFcn, ...
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


% --- Executes just before pop_pervadinimas is made visible.
function pop_pervadinimas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_pervadinimas (see VARARGIN)

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
set(handles.figure1,'Position',[pad(1) pad(2) max(pad(3),900) max(pad(4),500)]);
set(handles.pushbutton7, 'BackgroundColor', 'remove');

lokalizuoti(hObject, eventdata, handles);
drb_meniu(hObject, eventdata, handles, 'visas', mfilename);

if isempty(get(handles.text_koduote,'String'))
    set(handles.text_koduote,'String',feature('DefaultCharacterSet'));
end;
%feature('DefaultCharacterSet','UTF-8');
tic;

set(handles.figure1,'Color',get(handles.uipanel3,'BackgroundColor'));

Kelias_dabar=pwd;

% Pabandyk nustatyti kelią pagal parametrus
try set(handles.edit_tikri,'String',g(1).path);   catch err; end;
try set(handles.edit_tikri,'String',g(1).pathin); catch err; end;
% Pabandyk parinkti rinkmenas pagal parametrus
try
    if ~isempty({g.files});
        set(handles.edit_filtras,'Style','pushbutton');
        set(handles.text_tikri,'String',{g.files});
    end;
catch err;
end;

set(handles.pushbutton_v1,'UserData',{});
set(handles.pushbutton_v2,'UserData',{});
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);

% Patikrink kelią duomenų išsaugojimui
set(handles.edit_siulomi,'String','');
try
    k=Darbeliai.keliai.saugojimui{1};
    if exist(k,'dir') == 7 ; set(handles.edit_siulomi,'String',k); end;
catch err; 
end;
try set(handles.edit_siulomi,'String',g(1).path);    catch err; end;
try set(handles.edit_siulomi,'String',g(1).pathout); catch err; end;
edit_siulomi_Callback(hObject, eventdata, handles);
cd(Kelias_dabar);

atnaujink_rodomus_failus(hObject, eventdata, handles);
% Jei nenurodytas filtras - įšaldyk jau pasirinktus failus
try 
    set(handles.edit_filtras,'String',g(1).flt_slct); 
catch err; 
    edit_filtras_ButtonDownFcn(hObject, eventdata, handles);
end;

%[ALLEEG EEG CURRENTSET ALLCOM] = eeglab ;
STUDY = []; CURRENTSTUDY = 0; %ALLEEG = []; EEG=[]; CURRENTSET=[];
[ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);

Pabandyk_atspeti_failu_sablona(hObject, eventdata, handles);

uipanel2_SelectionChangeFcn(hObject, eventdata, handles);

set(handles.edit11,'String','_ .-');
%edit_filtras_ButtonDownFcn(hObject, eventdata, handles);
pushbutton5_Callback(hObject, eventdata, handles);

if isempty(get(handles.listbox_tikri,'String'))
   edit_filtras_Callback(hObject, eventdata, handles);
end;

parinktis_irasyti(hObject, eventdata, handles, 'numatytas','');
try 
    drb_parinktys(hObject, eventdata, handles, 'ikelti', mfilename, g(1).preset); 
catch err; 
    susildyk(hObject, eventdata, handles);
end;

tic;

% Choose default command line output for pop_pervadinimas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_pervadinimas wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Jei nurodyta veiksena
try
  if ~isempty(g(1).mode);
    agv=strcmp(get(handles.pushbutton1,'Enable'),'on');
    if ismember(g(1).mode,{'f' 'force' 'forceexec' 'force_exec' 'e' 'exec' 't' 'try' 'tryexec' 'tryforce' 'confirm'});
        set(handles.pushbutton7,'UserData',1);
    else
        set(handles.pushbutton7,'UserData',0);
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


% --- Outputs from this function are returned to the command line.
function varargout = pop_pervadinimas_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
try
    varargout{1} = handles.output;
    varargout{2} = get(handles.edit_siulomi,'String'); % kelias
    varargout{3} = get(handles.listbox_siulomi,'String'); % visos rinkmenos
    varargout{3} = varargout{3}(get(handles.listbox_siulomi,'Value')); % pažymėtos rinkmenos
catch err;
    varargout{1} = [];
    varargout{2} = '';
    varargout{3} = {};
end;

try
    if get(handles.pushbutton7,'UserData');
        pushbutton7_Callback(hObject, eventdata, handles);
    end;
catch err;
end;

% Atnaujink rodoma kelia
function atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles)
Kelias_dabar=pwd;
try 
    cd(get(handles.edit_tikri,'String'));
catch err;
    try
        cd(Tikras_Kelias(get(handles.edit_tikri,'TooltipString')));
    catch err;
    end;
end;
set(handles.edit_tikri,'String',pwd);
set(handles.edit_tikri,'TooltipString',pwd);
set(handles.pushbutton_v1,'UserData',...
    unique([get(handles.pushbutton_v1,'UserData') Kelias_dabar {pwd}]));
cd(Kelias_dabar);
set(handles.edit_tikri,'BackgroundColor',[1 1 1]);

% Atnaujink rodomus failus
function atnaujink_rodomus_failus(hObject, eventdata, handles)
FAILAI={};
%FAILAI(1).name='(tuščia)';
%FAILAI=[dir('*.cnt') ; dir('*.set')];
Kelias_dabar=pwd;
%try
  cd (get(handles.edit_tikri,'String'));
%catch err;
%  set(handles.edit_tikri,'String',pwd);
%end;
FAILAI=filter_filenames('*.set;*.SET;*.cnt;*.edf');
if isempty(FAILAI);
    %FAILAI(1).name='';
    set(handles.listbox_tikri,'Max',0);
    set(handles.listbox_tikri,'Value',[]);
    set(handles.listbox_tikri,'SelectionHighlight','off');
    %set(handles.uipanel5,'Title','Apdorotini failai: nėra');
else
    if strcmp(get(handles.edit_filtras,'Style'),'edit');
        %FAILAI_filtruoti=dir(get(handles.edit_filtras,'String'));
        %FAILAI_filtruoti_={FAILAI_filtruoti.name};
        FAILAI_filtruoti_=atrinkti_teksta(FAILAI,get(handles.edit_filtras,'String'));
    else
        FAILAI_filtruoti_=FAILAI;
        try
            FAILAI_filtruoti_=get(handles.text_tikri,'String');
            edit_filtras_ButtonDownFcn(hObject, eventdata, handles);
            if or( strcmp([FAILAI_filtruoti_],{' '}), ...
                  isempty(FAILAI_filtruoti_)) ;
               %FAILAI_filtruoti=dir(get(handles.edit_filtras,'String'));
               %FAILAI_filtruoti_={FAILAI_filtruoti.name};
               FAILAI_filtruoti_=atrinkti_teksta(FAILAI,get(handles.edit_filtras,'String'));
            end;
        catch err;
            Pranesk_apie_klaida(err, 'Apdorotų duomenų pasirinkimas', '')
        end;
    end;
    set(handles.listbox_tikri,'Max',length(FAILAI));
    Pasirinkti_failu_indeksai=find(ismember(FAILAI,intersect(FAILAI_filtruoti_,FAILAI)));
    if and(isempty(Pasirinkti_failu_indeksai),length(FAILAI)==1);
       set(handles.listbox_tikri,'Value',1);
    else
       set(handles.listbox_tikri,'Value',Pasirinkti_failu_indeksai);
    end;    
    %disp(Pasirinkti_failu_indeksai);
    set(handles.listbox_tikri,'SelectionHighlight','on');
    %set(handles.uipanel5,'Title', ['Apdorotini failai: ' num2str(length(Pasirinkti_failu_indeksai)) '/' num2str(length(FAILAI) )]);
end;
cd(Kelias_dabar);
set(handles.listbox_tikri,'String',FAILAI);
%disp(get(handles.listbox_tikri,'String'));
Ar_galima_vykdyti(hObject, eventdata, handles);



function Ar_galima_vykdyti(hObject, eventdata, handles)
%assignin('base','handles',handles);
set(handles.pushbutton1,'Enable','off');
%set(handles.text_kartojasi,'Visible','on');
%set(handles.text_kartojasi,'BackgroundColor','remove');

if isempty(get(handles.listbox_siulomi,'String'));    
    set(handles.text_kartojasi,'Visible','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.edit4, 'BackgroundColor',[1 1 1]);
    set(handles.edit10,'BackgroundColor',[1 1 1]);
    drawnow; return;
else
    set(handles.pushbutton8,'Enable','on');
end;
i=ismember(regexprep(get(handles.listbox_siulomi,'String'),'[ ]+',''),{'' '.set'});
if sum(i);
    set(handles.text_kartojasi,'Visible','off');
    set(handles.listbox_siulomi,'Value',find(i));
    set(handles.edit10,'BackgroundColor',[1 1 0]);
    drawnow; return;
end;
if length(unique(get(handles.listbox_siulomi,'String'))) ~= ...
        length(get(handles.listbox_siulomi,'String'));
    set(handles.text_kartojasi,'String',lokaliz('Dublicate filenames'));
    set(handles.text_kartojasi,'Visible','on');
    set(handles.edit10,'BackgroundColor',[1 1 0]);
    drawnow; return;
else    
    set(handles.text_kartojasi,'Visible','off');
end;
if isempty(get(handles.listbox_tikri,'String'));
    drawnow; return;
end;
if get(handles.listbox_tikri,'Value') == 0;
    drawnow; return;
end;
Pasirinkti_failu_indeksai=(get(handles.listbox_tikri,'Value'));
if isempty(Pasirinkti_failu_indeksai);
    drawnow; return;
end;
if get(handles.edit_siulomi,'BackgroundColor') == [1 1 0];
    drawnow; return;
end;
if get(handles.edit_tikri,'BackgroundColor') == [1 1 0];
    drawnow; return;
end;
if get(handles.edit_filtras,'BackgroundColor') == [1 1 0];
    drawnow; return;
end;

    FAILAI_ORIG=get(handles.listbox_tikri,'String');
    siulomas_sutampa_su_senu_kitame=tikrinti_rinkmenu_perrasyma(...
        get(handles.edit_tikri,'String'),   FAILAI_ORIG(get(handles.listbox_tikri,'Value')),...
        get(handles.edit_siulomi,'String'), get(handles.listbox_siulomi,'String'));
    
    if isempty(siulomas_sutampa_su_senu_kitame);
        drawnow; return;
    end;
    
    siulomas_sutampa_su_senu_kitame_i=find(siulomas_sutampa_su_senu_kitame(:,1)==1);
    
    if ~isempty(siulomas_sutampa_su_senu_kitame_i);
        if ~get(handles.checkbox3,'Value');
            set(handles.pushbutton1,'Enable','off');
            set(handles.text_kartojasi,'String',lokaliz('Some files already exist!'));
            set(handles.text_kartojasi,'Visible','on');
            set(handles.listbox_siulomi,'Value',siulomas_sutampa_su_senu_kitame_i);
            drawnow; return;
        end;        
        perras=intersect(siulomas_sutampa_su_senu_kitame_i, find(siulomas_sutampa_su_senu_kitame(:,3)==1));
        origin=intersect(siulomas_sutampa_su_senu_kitame_i, find(siulomas_sutampa_su_senu_kitame(:,2)==1));
        neorig=intersect(siulomas_sutampa_su_senu_kitame_i, find(siulomas_sutampa_su_senu_kitame(:,2)==0));
        if ~isempty(perras);
            set(handles.pushbutton1,'Enable','off');
            set(handles.text_kartojasi,'String',lokaliz('Do not overwrite orinals!'));
            set(handles.text_kartojasi,'Visible','on');
            set(handles.listbox_siulomi,'Value',perras);
            drawnow; return;
        end;
        if ~isempty(neorig);
            %set(handles.pushbutton1,'Enable','off');
            set(handles.text_kartojasi,'String',lokaliz('Some files already exist!'));
            set(handles.text_kartojasi,'Visible','on');
            set(handles.listbox_siulomi,'Value',neorig);
            %return;
        end;
        if ~isempty(origin);
            %set(handles.pushbutton1,'Enable','off');
            set(handles.text_kartojasi,'String',lokaliz('Some originals = new names'));
            set(handles.text_kartojasi,'Visible','on');
            set(handles.listbox_siulomi,'Value',origin);
        end;
        %disp(' ');
        %disp(B(siulomas_sutampa_su_senu_kitame_i));
        %return;
    end;


set(handles.pushbutton1,'Enable','on');
drawnow; 


function lentele=tikrinti_rinkmenu_perrasyma(KELIAS_ORIG, RINKMENOS_ORIG, KELIAS_NAUJ, RINKMENOS_NAUJ)
% grąžina lentelę, kurioje yra loginės reikšmės.
% eilutės atitinka siūlomų rinkmenų pavadinimų eiliškumą
% 1-as  stulpelis – ar toks failas jau yra
% 2-as  stulpelis – ar siūlomas failo pavadinimas sutampa su originaliu
% 3-ias stulpelis - ar siūlomas failas perrašytų tokį originalų failų, kurį ketinate pervadinti
lentele=[];
RINKMENOS_ORIG_N=length(RINKMENOS_ORIG);
RINKMENOS_NAUJ_N=length(RINKMENOS_NAUJ);
if or(RINKMENOS_ORIG_N == 0, ...
    RINKMENOS_ORIG_N ~= RINKMENOS_NAUJ_N);
    return;
end;

tmp=cellfun(@(i) ...
   [(exist(fullfile(KELIAS_NAUJ, RINKMENOS_NAUJ{i}),'file') == 2) ...
    and(strcmp(KELIAS_ORIG, KELIAS_NAUJ),   strcmp(RINKMENOS_NAUJ(i), RINKMENOS_ORIG(i))) ...
    and(strcmp(KELIAS_ORIG, KELIAS_NAUJ), ismember(RINKMENOS_NAUJ(i), RINKMENOS_ORIG([1:(i-1) (i+1):end]))) ], ...
    num2cell([1:RINKMENOS_NAUJ_N]),'UniformOutput',false);

lentele=(cell2mat(tmp'));

function Pabandyk_atspeti_failu_sablona(hObject, eventdata, handles)
% Šablonai:
%          senas_pavad      naujas_pavad     tiriam grup salyga sesija
sablonai={{[get(handles.edit4,'String')] [get(handles.edit10,'String')] ... 
           [get(handles.edit5,'String')] [get(handles.edit6 ,'String') ] ...
           [get(handles.edit7,'String')] [get(handles.edit8 ,'String')] } , ...
          {'%d%s%s%s%s%s%s' '%T%G.set'         '%1'  '%2'  '%3'  '%4' } , ...
          {'%d%s%s%s%s%s%s' '%T%G_%C%S.set'    '%1'  '%2'  '%3'  '%4' } , ...
          {'%d%c%s%s%s%s%s' '%T%G.set'         '%1'  '%2'  '%3'  '%4' } , ...
          {'%d%c%s%s%s%s%s' '%T%G_%C%S.set'    '%1'  '%2'  '%3'  '%4' } , ...
          {'%c%d%c%s%s%s%s' '%1%T%G.set'       '%2'  '%3'  '%4'  '%5' } , ...
          {'%c%d%c%s%s%s%s' '%1%T%G_%C%S.set'  '%2'  '%3'  '%4'  '%5' } , ...
          {'%c%d%s%s%s%s%s' '%1%T%G.set'       '%2'  '%3'  '%4'  '%5' } , ...
          {'%c%d%s%s%s%s%s' '%1%T%G_%C%S.set'  '%2'  '%3'  '%4'  '%5' } , ...
          {'%s%d%s%s%s%s%s' '%1%T%G.set'       '%2'  '%3'  '%4'  '%5' } , ...
          {'%s%d%s%s%s%s%s' '%1%T%G_%C%S.set'  '%2'  '%3'  '%4'  '%5' } , ...
          {'%s%d%c%s%s%s%s' '%1%T%G.set'       '%2'  '%3'  '%4'  '%5' } , ...
          {'%s%d%c%s%s%s%s' '%1%T%G_%C%S.set'  '%2'  '%3'  '%4'  '%5' } , ...
          {'%s%d%c%s%s%s%s' '%1%T%G.set'      '%2%3' '%4'  '%5'  '%6' } , ...
          {'%s%d%c%s%s%s%s' '%1%T%G_%C%S.set' '%2%3' '%4'  '%5'  '%6' } , ...
          {'%s%s%s%s%s%s%s' '%T_%G.set'         '%1'  '%2'  '%3'  '%4' } , ...
          {'%s%s%s%s%s%s%s' '%T_%G_%C.set'      '%1'  '%2'  '%3'  '%4' } , ...
          {'%s%s%s%s%s%s%s' '%T_%G_%C%S.set'    '%1'  '%2'  '%3'  '%4' } , ...
          {'%s%s%s%s%s%s%s' '%O.set'            '%1'  '%2'  '%3'  '%4' } , ...
          {'%s%s%s%s%s%s%s' '%O_%i.set'         '%1'  '%2'  '%3'  '%4' }, ...
          {'%s%s%s%s%s%s%s' '%i.set'            '%1'  '%2'  '%3'  '%4' }} ;

tici=tic;
f=statusbar(lokaliz('Searching template...'));
statusbar('off',f);

for sablono_i=1:length(sablonai);
    sablonas=sablonai{sablono_i};
    set(handles.edit4, 'String',sablonas{1}); % tikras (senas) pavadinimas
    set(handles.edit10,'String',sablonas{2}); % siūlomas (naujas) pavadinimas
    set(handles.edit5, 'String',sablonas{3}); % tiriamasis
    set(handles.edit6, 'String',sablonas{4}); % grupė
    set(handles.edit7, 'String',sablonas{5}); % sąlyga
    set(handles.edit8, 'String',sablonas{6}); % sesija
    edit4_Callback(hObject, eventdata, handles);
    lentele =get(handles.uitable1, 'Data');
    Duomenys=get(handles.uitable2, 'Data');
            
    if strcmp(get(handles.pushbutton1,'Enable'),'on') ;
        if and(~isempty(Duomenys),~isempty(lentele));
            Tiriamasis=Duomenys(:,1);
            if ~ismember('',Tiriamasis);                
                break;
            end;
        end;
    end;
    
    % statusbar
    tok=toc(tici);
    p=sablono_i/length(sablonai);
    if and(tok>1,p<0.5);
        statusbar('on',f);
    end;
    if isempty(statusbar(p,f));
        break;
    end;
    
end;

if ishandle(f)
    delete(f);
end;

checkbox1_Callback(hObject, eventdata, handles);

% --- Executes on selection change in listbox_tikri.
function listbox_tikri_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_tikri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_tikri contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_tikri
edit4_Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function listbox_tikri_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_tikri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_siulomi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_siulomi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tikri_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tikri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tikri as text
%        str2double(get(hObject,'String')) returns contents of edit_tikri as a double

%feature('DefaultCharacterSet',get(handles.text_koduote,'String'));
Kelias_dabar=pwd;
try
    cd(get(handles.edit_tikri,'String'));
    set(handles.edit_tikri,'String',pwd);
catch err;
end;
%feature('DefaultCharacterSet','UTF-8');
cd(Kelias_dabar);
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);
edit4_Callback(hObject, eventdata, handles);
Pabandyk_atspeti_failu_sablona(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_tikri_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tikri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_filtras_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtras (see GCBO)
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
Kelias_dabar=pwd;
try
    cd(get(handles.edit_tikri,'String'));
catch err;
end;
KELIAS=uigetdir;
try
    cd(KELIAS);
catch err;
end;
set(handles.edit_tikri,'String',pwd);
cd(Kelias_dabar);
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);
edit4_Callback(hObject, eventdata, handles);
Pabandyk_atspeti_failu_sablona(hObject, eventdata, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
KELIAS=pwd;
try
    cd(get(handles.edit_siulomi,'String'));
catch err;
end;
KELIAS_ISSAUGOJIMUI=uigetdir;
try
    cd(KELIAS_ISSAUGOJIMUI);
catch err;
end;
set(handles.edit_siulomi,'String',pwd);
set(handles.edit_siulomi,'TooltipString',pwd);
set(handles.pushbutton_v2,'UserData',...
    unique([get(handles.pushbutton_v2,'UserData') KELIAS {pwd}]));
cd(KELIAS);
set(handles.edit_siulomi,'BackgroundColor',[1 1 1]);
edit_siulomi_Callback(hObject, eventdata, handles);


% --- Executes on key press with focus on edit_tikri and none of its controls.
function edit_tikri_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
set(handles.edit_tikri,'BackgroundColor',[1 1 0]);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on key press with focus on edit_siulomi and none of its controls.
function edit_siulomi_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
set(handles.edit_siulomi,'BackgroundColor',[1 1 0]);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on selection change in listbox_siulomi.
function listbox_siulomi_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_siulomi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_siulomi contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_siulomi
set(handles.listbox_siulomi,'Value',1:length(get(handles.listbox_siulomi,'String')));

% --- Executes during object creation, after setting all properties.
function listbox_siulomi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_siulomi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_siulomi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_siulomi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_siulomi as text
%        str2double(get(hObject,'String')) returns contents of edit_siulomi as a double

KELIAS=pwd;
%feature('DefaultCharacterSet',get(handles.text_koduote,'String'));
KELIAS_siulomas=get(handles.edit_siulomi,'String');
%feature('DefaultCharacterSet','UTF-8');
try
    if ~isempty(KELIAS_siulomas);
       cd(KELIAS_siulomas);
    end;
catch err;
    a1=lokaliz('Cancel');
    a2=lokaliz('Create directory');
    button3 = questdlg(KELIAS_siulomas , ...
        lokaliz('No such directory'), ...
        a1, a2, a2);
    if strcmp(button3,a2)
        try
            mkdir(KELIAS_siulomas);
            cd(KELIAS_siulomas);
        catch err ;
            warning(err.message);
            cd(Tikras_Kelias(get(handles.edit_siulomi,'TooltipString')));
        end;
    else
        cd(Tikras_Kelias(get(handles.edit_siulomi,'TooltipString')));
    end;
end;
set(handles.edit_siulomi,'String',pwd);
set(handles.edit_siulomi,'TooltipString',pwd);
set(handles.pushbutton_v2,'UserData',...
    unique([get(handles.pushbutton_v2,'UserData') KELIAS {pwd}]));
cd(KELIAS);
set(handles.edit_siulomi,'BackgroundColor',[1 1 1]);
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on key press with focus on edit_filtras and none of its controls.
function edit_filtras_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtras (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.edit_filtras,'Style'),'pushbutton') ;
    set(handles.edit_filtras,'Style','edit');
    set(handles.edit_filtras,'String','*');
    set(handles.edit_filtras,'BackgroundColor',[1 1 1]);
else
    set(handles.edit_filtras,'BackgroundColor',[1 1 0]);
    Ar_galima_vykdyti(hObject, eventdata, handles);
    %set(handles.edit_filtras,'Style','pushbutton');
    %set(handles.edit_filtras,'String','Filtruoti');
    %set(handles.edit_filtras,'BackgroundColor','remove');
end;


% --- Executes on button press in edit_filtras.
function edit_filtras_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filtras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.edit_filtras,'String'));
    set(handles.edit_filtras,'String','*');
end;
if strcmp(get(handles.edit_filtras,'Style'),'pushbutton') ;
    set(handles.edit_filtras,'Style','edit');
    set(handles.edit_filtras,'String','*');
end;
set(handles.edit_filtras,'BackgroundColor',[1 1 1]);
atnaujink_rodomus_failus(hObject, eventdata, handles);
edit4_Callback(hObject, eventdata, handles);


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
try
    PASIRINKTI_FAILAI=get(handles.listbox_tikri,'String');
    if isempty(PASIRINKTI_FAILAI);
        error('nepasirinkta rinkmenų');
    end;
    if isempty(get(handles.edit4,'String'));
        error('tuščias edit4');
    end;
    PASIRINKTI_FAILAI=PASIRINKTI_FAILAI(get(handles.listbox_tikri,'Value'));
    lentele={};
    sabln=strrep(get(handles.edit4,'String'),'%d','%[0123456789]');
    sabln=strrep(sabln,'%f','%%f'); sabln=strrep(sabln,'%u','%%u'); sabln=strrep(sabln,'%n','%%n');
    sabln=strrep(sabln,'%q','%%q'); sabln=strrep(sabln,'%C','%%C'); sabln=strrep(sabln,'%D','%%D');
    for i=1:length(PASIRINKTI_FAILAI);
        tmp= (textscan(PASIRINKTI_FAILAI{i}, sabln, 'delimiter', get(handles.edit11,'String'))) ;
        %disp([PASIRINKTI_FAILAI{i} '.']);
        lentele(i,1:length(tmp))=cellfun(@(x) konvertavimas_is_narvelio(x), tmp, 'UniformOutput', false);
    end;
    %disp(lentele);
    %lentele=[lentele];
    if and(iscellstr(lentele),length(tmp)>0);
        set(handles.uitable1,'Data', lentele);
        set(handles.edit4,'BackgroundColor',[1 1 1]);
    else    
        set(handles.uitable1,'Data', {});
        set(handles.edit4,'BackgroundColor',[1 1 0]);
    end;
catch err;
    set(handles.edit4,'BackgroundColor',[1 1 0]);
    set(handles.uitable1,'Data', {});
    %Pranesk_apie_klaida(err,'Pervadinimas','',0);
end;
set(handles.uitable2,'Data',  {'' '' '' ''} );
edit5_Callback(hObject, eventdata, handles);
edit6_Callback(hObject, eventdata, handles);
edit7_Callback(hObject, eventdata, handles);
edit8_Callback(hObject, eventdata, handles);
edit10_Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);

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
    duomuo=num2str(duomuo);
end;
naujas_duomuo = duomuo;

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on edit4 and none of its controls.
function edit4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit4,'BackgroundColor',[1 1 0]);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
PASIRINKTI_FAILAI=get(handles.listbox_tikri,'String');
try
    PASIRINKTI_FAILAI=PASIRINKTI_FAILAI(get(handles.listbox_tikri,'Value'));
catch err;
	PASIRINKTI_FAILAI={};
end;

if ~isempty(PASIRINKTI_FAILAI) ;
    tmp2(1:length(PASIRINKTI_FAILAI),1)={konvertavimas_is_narvelio(get(handles.edit5,'String'))};
    lentele=get(handles.uitable1,'Data');
    if ~isempty(lentele) ;
        for i=1:length(lentele(1,:));
            tmp2=strrep(tmp2, [ '%' num2str(i) ],lentele(:,i));
        end;
    end;
    visa=get(handles.uitable2,'Data');
    visa(1:length(tmp2),1)=tmp2;
    %disp( tmp2);
    set(handles.uitable2,'Data', visa );
    set(handles.edit5,'BackgroundColor',[1 1 1]);
else
    set(handles.edit5,'BackgroundColor',[1 1 1]);
    set(handles.uitable2,'Data', {} );
end;
edit10_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
PASIRINKTI_FAILAI=get(handles.listbox_tikri,'String');
try
    PASIRINKTI_FAILAI=PASIRINKTI_FAILAI(get(handles.listbox_tikri,'Value'));
catch err;
	PASIRINKTI_FAILAI={};
end;
if ~isempty(PASIRINKTI_FAILAI) ;
    tmp2(1:length(PASIRINKTI_FAILAI),1)={konvertavimas_is_narvelio(get(handles.edit6,'String'))};
    lentele=get(handles.uitable1,'Data');
    if ~isempty(lentele) ;
        for i=1:length(lentele(1,:));
            tmp2=strrep(tmp2, [ '%' num2str(i) ],lentele(:,i));
        end;
    end;
    visa=get(handles.uitable2,'Data');
    visa(1:length(tmp2),2)=tmp2;
    %disp( tmp2);
    set(handles.uitable2,'Data', visa );
    set(handles.edit6,'BackgroundColor',[1 1 1]);
else
    set(handles.edit6,'BackgroundColor',[1 1 1]);
    set(handles.uitable2,'Data', {} );
end;
edit10_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
PASIRINKTI_FAILAI=get(handles.listbox_tikri,'String');
try
    PASIRINKTI_FAILAI=PASIRINKTI_FAILAI(get(handles.listbox_tikri,'Value'));
catch err;
	PASIRINKTI_FAILAI={};
end;
if ~isempty(PASIRINKTI_FAILAI) ;
    tmp2(1:length(PASIRINKTI_FAILAI),1)={konvertavimas_is_narvelio(get(handles.edit7,'String'))};
    lentele=get(handles.uitable1,'Data');
    if ~isempty(lentele) ;
        for i=1:length(lentele(1,:));
            tmp2=strrep(tmp2, [ '%' num2str(i) ],lentele(:,i));
        end;
    end;
    visa=get(handles.uitable2,'Data');
    visa(1:length(tmp2),3)=tmp2;
    %disp( tmp2);
    set(handles.uitable2,'Data', visa );
    set(handles.edit7,'BackgroundColor',[1 1 1]);
else
    set(handles.edit7,'BackgroundColor',[1 1 1]);
    set(handles.uitable2,'Data', {} );
end;
edit10_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
set(handles.edit8,'String',numstr_(get(handles.edit8,'String')));
PASIRINKTI_FAILAI=get(handles.listbox_tikri,'String');
try
    PASIRINKTI_FAILAI=PASIRINKTI_FAILAI(get(handles.listbox_tikri,'Value'));
catch err;
    PASIRINKTI_FAILAI={};
end;
if ~isempty(PASIRINKTI_FAILAI) ;
    tmp2(1:length(PASIRINKTI_FAILAI),1)={konvertavimas_is_narvelio(get(handles.edit8,'String'))};
    lentele=get(handles.uitable1,'Data');
    if ~isempty(lentele) ;
        for i=1:length(lentele(1,:));
            tmp2=strrep(tmp2, [ '%' num2str(i) ],lentele(:,i));
        end;
    end;
    tmp2=cellfun(@(x) numstr(x), tmp2, 'UniformOutput', false);
    visa=get(handles.uitable2,'Data');
    visa(1:length(tmp2),4)=tmp2;
    %disp( tmp2);
    set(handles.uitable2,'Data', visa );
    set(handles.edit8,'BackgroundColor',[1 1 1]);
else
    set(handles.edit8,'BackgroundColor',[1 1 1]);
    set(handles.uitable2,'Data', {} );
end;
edit10_Callback(hObject, eventdata, handles);

function str = numstr(string)
str='';
if ischar(string)
   for i=1:length(string)
      c=string(i);
      if ismember(c, {'1' '2' '3' '4' '5' '6' '7' '8' '9' '0'});
         str=[str c];
      end;
   end;
   return
end;
if isnumeric(string)   
   str=num2str(string);
end;

function str = numstr_(string)
str='';
if ischar(string)
   for i=1:length(string)
      c=string(i);
      if ismember(c, {'1' '2' '3' '4' '5' '6' '7' '8' '9' '0' '%'});
         str=[str c];
      end;
   end;
   return
end;
if isnumeric(string)   
   str=num2str(string);
end;


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
if isempty(regexprep(get(handles.edit10,'String'),'[ ]+','')); 
    set(handles.edit10,'BackgroundColor',[1 1 0]);
    set(handles.uitable1,'Data', {});
    set(handles.listbox_siulomi,'Value',[]);
    set(handles.listbox_siulomi,'String',{});
    Ar_galima_vykdyti(hObject, eventdata, handles);
    return;
end;
PASIRINKTI_FAILAI=get(handles.listbox_tikri,'String');
try
    PASIRINKTI_FAILAI=PASIRINKTI_FAILAI(get(handles.listbox_tikri,'Value'));
catch err;
	PASIRINKTI_FAILAI={};
end;
if ~isempty(PASIRINKTI_FAILAI) ;
    lentele=get(handles.uitable1,'Data');
    Duomenys={};
    try 
        Duomenys=get(handles.uitable2, 'Data');
    catch err;
        disp(err.message);
    end;
    tmp2(1:length(PASIRINKTI_FAILAI),1)={konvertavimas_is_narvelio(get(handles.edit10,'String'))};
    if ~isempty(lentele) ;
        try
            for i=1:length(lentele(1,:));
                tmp2=strrep(tmp2, [ '%' num2str(i) ],lentele(:,i));
            end;
        catch err;
        end;
    end;
    if ~isempty(Duomenys);
        try
            tmp2=strrep(tmp2, [ '%T' ],Duomenys(:,1)); % Tiriamasis
            tmp2=strrep(tmp2, [ '%G' ],Duomenys(:,2)); % Grupe
            tmp2=strrep(tmp2, [ '%C' ],Duomenys(:,3)); % Salyga
            tmp2=strrep(tmp2, [ '%S' ],Duomenys(:,4)); % Sesija
        catch err;
        end;
    end;
    tmp2=strrep(tmp2, [ '%O' ],regexprep(PASIRINKTI_FAILAI,'.set$',''));
    tmp2=strrep(tmp2, [ '%i' ],cellstr(num2str([1:length(tmp2)]')));
    %disp( tmp2);
    set(handles.listbox_siulomi,'String',  tmp2 );
    set(handles.listbox_siulomi,'Value', 1:length(tmp2) );
    set(handles.listbox_siulomi,'Max', length(tmp2) );
    set(handles.edit10,'BackgroundColor',[1 1 1]);
else
    set(handles.edit10,'BackgroundColor',[1 1 1]);
    set(handles.listbox_siulomi,'String', '' );
end;
Ar_galima_vykdyti(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
if get(handles.checkbox1,'Value') == 0;
    set(handles.radiobutton1, 'Value', 1);
    set(handles.radiobutton2, 'Enable', 'off');
    set(handles.edit5, 'Enable', 'off');
    set(handles.edit6, 'Enable', 'off');
    set(handles.edit7, 'Enable', 'off');
    set(handles.edit8, 'Enable', 'off');
    nauj_pav_sabl=get(handles.edit10, 'String');
    nauj_pav_sabl=strrep(nauj_pav_sabl,'%T',get(handles.edit5, 'String'));
    nauj_pav_sabl=strrep(nauj_pav_sabl,'%G',get(handles.edit6, 'String'));
    nauj_pav_sabl=strrep(nauj_pav_sabl,'%C',get(handles.edit7, 'String'));
    nauj_pav_sabl=strrep(nauj_pav_sabl,'%S',get(handles.edit8, 'String'));
    set(handles.edit10, 'String', nauj_pav_sabl);
    uipanel2_SelectionChangeFcn(hObject, eventdata, handles);
else
    set(handles.radiobutton2, 'Value', 1);
    set(handles.radiobutton2, 'Enable', 'on');
    set(handles.edit5, 'Enable', 'on');
    set(handles.edit6, 'Enable', 'on');
    set(handles.edit7, 'Enable', 'on');
    set(handles.edit8, 'Enable', 'on');
    uipanel2_SelectionChangeFcn(hObject, eventdata, handles);
end;

% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton1,'Value') ;
    set(handles.uitable1,'Visible','on');
    set(handles.uitable2,'Visible','off');
else
    set(handles.uitable2,'Visible','on');
    set(handles.uitable1,'Visible','off');
end;


% --- Executes on key press with focus on edit10 and none of its controls.
function edit10_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
set(handles.edit10,'BackgroundColor',[1 1 0]);


% --- Executes on key press with focus on edit5 and none of its controls.
function edit5_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
set(handles.edit5,'BackgroundColor',[1 1 0]);

% --- Executes on key press with focus on edit6 and none of its controls.
function edit6_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
set(handles.edit6,'BackgroundColor',[1 1 0]);


% --- Executes on key press with focus on edit7 and none of its controls.
function edit7_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
set(handles.edit7,'BackgroundColor',[1 1 0]);


% --- Executes on key press with focus on edit8 and none of its controls.
function edit8_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.figure1, 'currentModifier')); return; end;
set(handles.edit8,'BackgroundColor',[1 1 0]);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
atnaujink_rodomus_failus(hObject, eventdata, handles);
edit4_Callback(hObject, eventdata, handles);


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
edit10_Callback(hObject, eventdata, handles);



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
disp('            PERVADINIMAS           ');
disp(' ');
disp( datestr(now, 'yyyy-mm-dd HH:MM:SS' ));
disp('===================================');
disp(' ');
susaldyk(hObject, eventdata, handles);
set(handles.pushbutton1,'Enable','off');
drawnow;
%guidata(hObject, handles);

global STUDY CURRENTSTUDY ALLEEG EEG CURRENTSET;
Pasirinkti_failu_indeksai=(get(handles.listbox_tikri,'Value'));
Rodomu_failu_pavadinimai=(get(handles.listbox_tikri,'String'));
Pasirinkti_failu_pavadinimai=Rodomu_failu_pavadinimai(Pasirinkti_failu_indeksai);
Pasirinktu_failu_N=length(Pasirinkti_failu_pavadinimai);
Pavadinimai_saugojimui=(get(handles.listbox_siulomi,'String'));
Duomenys=get(handles.uitable2, 'Data');
%set(handles.listbox2,'String',Pasirinkti_failu_pavadinimai);
%set(handles.listbox2,'String',{''});
disp(' ');
disp(lokaliz('File for work:'));
for i=1:Pasirinktu_failu_N;
    disp(Pasirinkti_failu_pavadinimai{i});
end;
disp(' ');
KELIAS=Tikras_Kelias(get(handles.edit_tikri,'String'));
KELIAS_SAUGOJIMUI=Tikras_Kelias(get(handles.edit_siulomi,'String'));
disp(lokaliz('Processed files will go to '));
disp(KELIAS_SAUGOJIMUI);
disp(' ');

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
tici=tic;
f=statusbar(get(handles.pushbutton1,'String'));
statusbar('off',f);

for i=1:Pasirinktu_failu_N;
    Rinkmena=Pasirinkti_failu_pavadinimai{i};
    [KELIAS_,Rinkmena_]=rinkmenos_tikslinimas(KELIAS,Rinkmena);
    RinkmenaAtverimuiSuKeliu=fullfile(KELIAS_, Rinkmena_);
    % statusbar
    tok=toc(tici);
    p=(i-1)/Pasirinktu_failu_N;
    if and(tok>1,p<0.5);
        statusbar('on',f);
    end;
    if isempty(statusbar(p,f));
        break;
    end;
    fprintf('\n === %s %d/%d (%.2f%%) ===\n%s\n', lokaliz('Opened file'), i, Pasirinktu_failu_N, i/Pasirinktu_failu_N*100, RinkmenaAtverimuiSuKeliu);
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    
    % Ikelti
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = pop_newset([],[],[]);
    EEG = eeg_ikelk(KELIAS_,Rinkmena_);
    
    if ~isempty(EEG);
        
        EEG = eeg_checkset( EEG );
        
        RinkmenaSaugojimui=Pavadinimai_saugojimui{i};
    
        
        %Atnaujinti info
        if get(handles.checkbox1,'Value');
            Tiriamasis=Duomenys{i,1};
            Grupe=Duomenys{i,2};
            Salyga=Duomenys{i,3};
            Sesija=konvertavimas_is_narvelio(Duomenys(i,4));
            [EEG, LASTCOM] = pop_editset(EEG, ...
                'setname', [regexprep(regexprep(RinkmenaSaugojimui,'.cnt$',''),'.set$','')], ...
                'subject', Tiriamasis, ...
                'condition', Salyga, ...
                'group', Grupe, ...
                'session', Sesija );
            EEG = eegh(LASTCOM, EEG);
        end;
        
    end;
    
    % Išsaugoti
    try
        RinkmenaSaugojimuiSuKeliu=fullfile(KELIAS_SAUGOJIMUI, RinkmenaSaugojimui);
        TikrasSaugojimoKelias=fileparts(RinkmenaSaugojimuiSuKeliu);
        if exist(TikrasSaugojimoKelias,'dir') ~= 7; try mkdir(TikrasSaugojimoKelias); catch; end; end;
        [~, ~, ~] = pop_newset(ALLEEG, EEG, 0, ...
            'setname', regexprep(regexprep(RinkmenaSaugojimui,'.cnt$',''),'.set$',''), ...
            'savenew', RinkmenaSaugojimuiSuKeliu);
        
        % ištrinti seną
        if and(~get(handles.checkbox2,'Value'),~strcmp(RinkmenaAtverimuiSuKeliu,RinkmenaSaugojimuiSuKeliu));
            try
                delete(RinkmenaAtverimuiSuKeliu);
                fdt=regexprep(RinkmenaAtverimuiSuKeliu,'.set$','.fdt');
                if exist(fdt,'file') == 2;
                    delete(fdt);
                end;
                ica=regexprep(RinkmenaAtverimuiSuKeliu,'.set$','.ica');
                if exist(ica,'file') == 2;
                    delete(ica);
                end;
            catch err;
                Pranesk_apie_klaida(err,lokaliz('Remove old files'),RinkmenaAtverimuiSuKeliu);
            end;
        end;
    catch err;
        Pranesk_apie_klaida(err,lokaliz('Save file'),RinkmenaSaugojimuiSuKeliu);
    end;
end;

 % Parodyk, kiek laiko uztruko
    disp(' ');
    t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
    toc(tici);
    disp(lokaliz('Done'));
    
if ishandle(f)
    delete(f);
end;

% Grąžinti senuosius EEGLAB kintamuosius ir atnaujinti langą
    %if atnaujinti_eeglab;
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
    %end;

susildyk(hObject, eventdata, handles);
uiresume(handles.figure1);
pushbutton5_Callback(hObject, eventdata, handles);


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
set(handles.edit11,'BackgroundColor',[1 1 1]);
edit4_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on edit11 and none of its controls.
function edit11_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit11,'BackgroundColor',[1 1 0]);

function susaldyk(hObject, eventdata, handles)
%Neleisti spausti Nuostatų meniu!
for m_id={'m_Nuostatos' 'm_Darbeliai' 'm_Veiksmai'};
    set(findall(handles.figure1,'Type','uimenu','Tag',m_id{1}),'Enable','off');
end;
drawnow;
%Kita
set(handles.pushbutton1,'Enable','off');
set(handles.pushbutton5,'Enable','off');
set(handles.edit_tikri,'Enable','off');
set(handles.edit_siulomi,'Enable','off');
set(handles.edit_filtras,'Enable','off');
set(handles.edit4,'Enable','off');
set(handles.edit5,'Enable','off');
set(handles.edit6,'Enable','off');
set(handles.edit7,'Enable','off');
set(handles.edit8,'Enable','off');
set(handles.edit10,'Enable','off');
set(handles.edit11,'Enable','off');
set(handles.listbox_tikri,'Enable','inactive');
set(handles.listbox_siulomi,'Enable','inactive');
set(handles.uitable2,'ColumnEditable',false);
set(handles.checkbox1,'Enable','off');
set(handles.checkbox2,'Enable','off');
set(handles.checkbox3,'Enable','off');
set(handles.pushbutton7,'Enable','off');
set(handles.radiobutton1, 'Enable', 'off');
set(handles.radiobutton2, 'Enable', 'off');
set(handles.pushbutton8,'Enable','off');
set(handles.pushbutton_v1,'Enable','off');
set(handles.pushbutton_v2,'Enable','off');
drawnow;

function susildyk(hObject, eventdata, handles)
%set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton5,'Enable','on');
set(handles.edit_tikri,'Enable','on');
set(handles.edit_siulomi,'Enable','on');
set(handles.edit_filtras,'Enable','on');
set(handles.edit4,'Enable','on');
set(handles.edit5,'Enable','on');
set(handles.edit6,'Enable','on');
set(handles.edit7,'Enable','on');
set(handles.edit8,'Enable','on');
set(handles.edit10,'Enable','on');
set(handles.edit11,'Enable','on');
set(handles.listbox_tikri,'Enable','on');
set(handles.listbox_siulomi,'Enable','on');
set(handles.uitable2,'ColumnEditable',true);
set(handles.checkbox1,'Enable','on');
set(handles.checkbox2,'Enable','on');
set(handles.checkbox3,'Enable','on');
set(handles.pushbutton7,'Enable','on');
set(handles.radiobutton1, 'Enable', 'on');
set(handles.radiobutton2, 'Enable', 'on');
set(handles.pushbutton8,'Enable','on');
set(handles.pushbutton_v1,'Enable','on');
set(handles.pushbutton_v2,'Enable','on');
%pushbutton5_Callback(hObject, eventdata, handles);
%atnaujink_rodomus_failus(hObject, eventdata, handles);
checkbox1_Callback(hObject, eventdata, handles);
Ar_galima_vykdyti(hObject, eventdata, handles);
% Leisti spausti Nuostatų meniu!
for m_id={'m_Nuostatos' 'm_Darbeliai' 'm_Veiksmai'};
    set(findall(handles.figure1,'Type','uimenu','Tag',m_id{1}),'Enable','on');
end;
drawnow;


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function uitable1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when selected cell(s) is changed in uitable2.
function uitable2_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable2,'ColumnEditable',true);


% --------------------------------------------------------------------
function uitable2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable2,'ColumnEditable',false);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(mfilename);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit_filtras.
function edit_filtras_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.edit_filtras,'Style'),'pushbutton') ;
    set(handles.edit_filtras,'Style','edit');
    set(handles.edit_filtras,'String','*');
    set(handles.edit_filtras,'BackgroundColor',[1 1 1]);
else
    set(handles.edit_filtras,'Style','pushbutton');
    set(handles.edit_filtras,'String','???');
    set(handles.edit_filtras,'BackgroundColor',[1 1 1]);
end;


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PASIRINKTI_FAILAI=get(handles.listbox_tikri,'String');
Kelias= [get(handles.edit_tikri,'String')] ;
try
    PASIRINKTI_FAILAI=PASIRINKTI_FAILAI(get(handles.listbox_tikri,'Value'));
catch err;
	PASIRINKTI_FAILAI={};
end;
orig_savybes(1:length(PASIRINKTI_FAILAI),1:4)={''};
if ~isempty(PASIRINKTI_FAILAI) ;
    susaldyk(hObject, eventdata, handles);    
    for i=1:length(PASIRINKTI_FAILAI);
        try
        Rinkmena=PASIRINKTI_FAILAI{i};
        TMPEEG=[];
        TMPEEG = pop_loadset('filename',Rinkmena,'filepath',Kelias,'loadmode','info');
            if ~isempty(TMPEEG);
                orig_savybes{i,1}=[TMPEEG.subject];
                orig_savybes{i,2}=[TMPEEG.group];
                orig_savybes{i,3}=[TMPEEG.condition];
                orig_savybes{i,4}=[num2str(TMPEEG.session)];
            end;
        catch err;
            Pranesk_apie_klaida(err, 'Senos nuostatos', Rinkmena,0);
        end;
    end;
else
    return;
end;
set(handles.uitable2,'Data', orig_savybes );
susildyk(hObject, eventdata, handles);
set(handles.radiobutton2, 'Value', 1);
uipanel2_SelectionChangeFcn(hObject, eventdata, handles);
edit10_Callback(hObject, eventdata, handles);

function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'return'));
        pushbutton1_Callback(hObject, eventdata, handles);
    end;



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

if get(handles.checkbox2,'Value');
    set(handles.pushbutton1,'String',lokaliz('Copy'));
else
    set(handles.pushbutton1,'String',lokaliz('Rename'));
end;
Ar_galima_vykdyti(hObject, eventdata, handles);


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
Ar_galima_vykdyti(hObject, eventdata, handles);

function lokalizuoti(hObject, eventdata, handles)
set(handles.pushbutton7,'String',lokaliz('Close'));
set(handles.pushbutton5,'String',lokaliz('Update'));
set(handles.pushbutton8,'String',lokaliz('Load old'));
set(handles.uipanel2,'Title',lokaliz('Info'));
set(handles.uipanel3,'Title',lokaliz('Open'));
set(handles.uipanel4,'Title',lokaliz('Save as'));
set(handles.text_kartojasi,'String',lokaliz('Dublicate filenames'));
set(handles.text3,'String',lokaliz('Filename_schema:'));
set(handles.text4,'FontSize',10,'FontUnits','pixels','String',lokaliz('textscan_short_help'));
set(handles.text5,'String',lokaliz('New_filename:'));
set(handles.text6,'String',lokaliz('Experiment_participant'));
set(handles.text7,'String',lokaliz('Group'));
set(handles.text8,'String',lokaliz('Condition_'));
set(handles.text9,'String',lokaliz('Session_No'));
set(handles.text10,'FontSize',10,'FontUnits','pixels','String',lokaliz('pervadinimas_substitute_help'));
set(handles.text11,'String',lokaliz('Filter:'));
set(handles.text12,'String',lokaliz('Separators'));
set(handles.checkbox1,'String',lokaliz('enter EEGLAB info'));
set(handles.checkbox2,'String',lokaliz('Do not remove original files'));
set(handles.checkbox3,'String',lokaliz('Allow overwrite files'));
set(handles.radiobutton1,'String',lokaliz('File_name_decoding'));
set(handles.radiobutton2,'String',lokaliz('New_EEG_info'));

stlp1=lokaliz('Experiment_participant');
stlp2=lokaliz('Group');
stlp3=lokaliz('Condition');
stlp4=lokaliz('Session');
set(handles.uitable2,'ColumnName', {stlp1 stlp2 stlp3 stlp4});
stlp_ilgvnt=235 / size([ stlp1 stlp2 stlp3 stlp4],2);
set(handles.uitable2,'ColumnWidth', {...
    [round(size(stlp1,2)*stlp_ilgvnt)] ...
    [round(size(stlp2,2)*stlp_ilgvnt)] ...
    [round(size(stlp3,2)*stlp_ilgvnt)] ...
    [round(size(stlp4,2)*stlp_ilgvnt)] } );
checkbox2_Callback(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function checkbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function parinktis_irasyti(hObject, eventdata, handles, varargin)
if nargin > 3; vardas=varargin{1};
else           vardas='';
end;
if nargin > 4; komentaras=varargin{2};
else           komentaras='';
end;
isimintini=struct('nariai','','raktai','');

isimintini(1).raktai={'Value' 'UserData'};
isimintini(1).nariai={ 'checkbox1' 'checkbox2' 'checkbox3' };
    
isimintini(2).raktai={'Value' 'UserData' 'String'};
isimintini(2).nariai={ 'edit4' 'edit10' 'edit11' 'edit5' 'edit6' 'edit7' 'edit8' };

drb_parinktys(hObject, eventdata, handles, 'irasyti', mfilename, vardas, komentaras, isimintini);


% --- Executes on button press in pushbutton_v1.
function pushbutton_v1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_v1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i=get(handles.edit_tikri,'String'); % įkėlimo
s=get(handles.edit_siulomi,'String'); % saugojimo
n=get(handles.pushbutton_v1,'UserData'); % naudotieji
a=drb_uzklausa('katalogas','atverimui',i, [s n]);
if isempty(a); return; end;
set(handles.edit_tikri,'String',a);
atnaujink_rodoma_darbini_kelia(hObject, eventdata, handles);
atnaujink_rodomus_failus(hObject, eventdata, handles);
edit4_Callback(hObject, eventdata, handles);
Pabandyk_atspeti_failu_sablona(hObject, eventdata, handles);


% --- Executes on button press in pushbutton_v2.
function pushbutton_v2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i=get(handles.edit_tikri,'String'); % įkėlimo
s=get(handles.edit_siulomi,'String'); % saugojimo
n=get(handles.pushbutton_v2,'UserData'); % naudotieji
a=drb_uzklausa('katalogas','atverimui',s, [i n]);
if isempty(a); return; end;
set(handles.edit_siulomi,'String',a);
set(handles.edit_siulomi,'TooltipString',a);
set(handles.pushbutton_v2,'UserData',...
    unique([get(handles.pushbutton_v2,'UserData') {s} {a}]));
set(handles.edit_siulomi,'BackgroundColor',[1 1 1]);
edit_siulomi_Callback(hObject, eventdata, handles);

