% pop_RRI_perziura - EKG ir R-R intervalų peržiūra, RRI koregavimas
% 
% R_laikai_ms=pop_RRI_perziura
% R_laikai_ms=pop_RRI_perziura(R_laikai_ms)
% R_laikai_ms=pop_RRI_perziura([], veiksena, EKG, EKG_Hz)
% R_laikai_ms=pop_RRI_perziura(R_laikai_ms, veiksena, EKG, EKG_Hz)
% R_laikai_ms=pop_RRI_perziura(R_laikai_ms, veiksena, EKG, EKG_Hz, zymekliu_laikai, zymekliu_pavadinimai)
% R_laikai_ms=pop_RRI_perziura(R_laikai_ms, veiksena, EKG, EKG_Hz, zymekliu_laikai, zymekliu_pavadinimai)
% R_laikai_ms=pop_RRI_perziura([], veiksena, EKG, EKG_laikai)
% R_laikai_ms=pop_RRI_perziura(R_laikai_ms, veiksena, EKG, EKG_laikai)
% R_laikai_ms=pop_RRI_perziura(R_laikai_ms, veiksena, EKG, EKG_laikai, zymekliu_laikai, zymekliu_pavadinimai)
%
% (C) 2014-2015 Mindaugas Baranauskas

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

function varargout = pop_RRI_perziura(varargin)
% POP_RRI_PERZIURA MATLAB code for pop_RRI_perziura.fig
%      POP_RRI_PERZIURA, by itself, creates a new POP_RRI_PERZIURA or raises the existing
%      singleton*.
%
%      H = POP_RRI_PERZIURA returns the handle to a new POP_RRI_PERZIURA or the handle to
%      the existing singleton*.
%
%      POP_RRI_PERZIURA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_RRI_PERZIURA.M with the given input arguments.
%
%      POP_RRI_PERZIURA('Property','Value',...) creates a new POP_RRI_PERZIURA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_RRI_perziura_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_RRI_perziura_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_RRI_perziura

% Last Modified by GUIDE v2.5 17-Jul-2015 10:33:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pop_RRI_perziura_OpeningFcn, ...
    'gui_OutputFcn',  @pop_RRI_perziura_OutputFcn, ...
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

% --- Executes just before pop_RRI_perziura is made visible.
function pop_RRI_perziura_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_RRI_perziura (see VARARGIN)

%(findobj('type','figure','name',mfilename));

disp(' ');
disp('===================================');
disp('      R R I   P E R Ž I Ū R A      ');
disp(' ');

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
warning('on', 'MATLAB:uitools:uimode:callbackerror');
warning('off','MATLAB:handle_graphics:exceptions:SceneNode');
warning('off','MATLAB:class:setgetPropertyNotFound');
warning('off','MATLAB:modes:mode:InvalidPropertySet'); % pvz., 'brush' tempiant ant slinkiklių

%% Kintamieji

Pradiniai_laikai=[];
if nargin > 3 ; Pradiniai_laikai=varargin{1};
end;
if nargin > 4 ; set(handles.figure1,'userdata',varargin{2});
else            set(handles.figure1,'userdata',0);
end;
if nargin < 6 ;
    handles.EKG=[];
    handles.EKG_laikai=[];
else
    handles.EKG=varargin{3};
    if isempty(handles.EKG);
        handles.EKG_laikai=[];
    else
        if nargin < 7 ;
            handles.EKG_laikai=EKG_Hz_klausti;
        else
            handles.EKG_laikai=varargin{4};
        end;
        if isequal(size(handles.EKG_laikai),[1 1]);
            handles.EKG_Hz=handles.EKG_laikai;
            handles.EKG_laikai=(1:length(handles.EKG)) / handles.EKG_laikai;
        else
            handles.EKG_Hz= round(1/min(diff(handles.EKG_laikai))); %(length(handles.EKG_laikai)-1) / (handles.EKG_laikai(end)-handles.EKG_laikai(1));
        end;
        if ekg_apversta(handles.EKG,handles.EKG_Hz,0); handles.EKG=-handles.EKG; end;
        if size(handles.EKG_laikai,2) > 1; handles.EKG_laikai=handles.EKG_laikai' ; end;
        if median(diff(handles.EKG_laikai(:))) >= 100;
            handles.EKG_laikai=handles.EKG_laikai*0.001;
        end;
        if isempty(Pradiniai_laikai);
            try axes(handles.axes_rri); cla;
                set(handles.axes_rri,'Visible','off');
                Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles);
                set(handles.axes_rri,'Visible','on');
                Pradiniai_laikai=get(handles.axes_rri,'UserData');
            catch err;
                Pranesk_apie_klaida(err,mfilename);
            end
        end;
    end;
end;
if nargin > 7 ; handles.zmkl_lks=varargin{5};
else            handles.zmkl_lks=[];
end;
if nargin > 8 ; handles.zmkl_pvd=varargin{6}; 
else           %handles.zmkl_pvd={}; 
    handles.zmkl_pvd(1:length(handles.zmkl_lks))={' '};    
end;

if size(handles.zmkl_lks,2) > 1; handles.zmkl_lks=handles.zmkl_lks'; end;
if size(handles.zmkl_pvd,2) > 1; handles.zmkl_pvd=handles.zmkl_pvd'; end;
if ~isnumeric(Pradiniai_laikai); Pradiniai_laikai=[]; end;
if size(Pradiniai_laikai,2) > 1; Pradiniai_laikai=Pradiniai_laikai' ; end;
if mean(diff(Pradiniai_laikai(:))) < 100;
    Pradiniai_laikai=Pradiniai_laikai*1000;
end;

%% Meniu

% Duomenys
handles.m_Duomenys = uimenu( 'Parent',handles.figure1,  'Accelerator','M','Callback',' ','Label','Duomenys','Tag','Duomenys');
% naujas_langas
h38 = uimenu( 'Parent',handles.m_Duomenys, 'Accelerator','N', 'Callback','pop_RRI_perziura', 'Label','Naujas langas', 'Tag','naujas_langas');
% Atstatyti
h25 = uimenu( 'Parent',handles.m_Duomenys, 'Accelerator','P', 'Callback',@(hObject,eventdata)pop_RRI_perziura('pushbutton_atstatyti_Callback',hObject,eventdata,guidata(hObject)), 'Label','Nuo pradžių', 'Tag','Atstatyti');
% Importuoti
h14 = uimenu( 'Parent',handles.m_Duomenys, 'Accelerator','I', 'Callback',' ', 'Separator','on', 'Label','Importuoti', 'Tag','Importuoti');
% Importuoti_laikus
h15 = uimenu( 'Parent',h14, 'Accelerator','L', 'Callback',@(hObject,eventdata)pop_RRI_perziura('Importuoti_laikus_Callback',hObject,eventdata,guidata(hObject)), 'Label','QRS laikus', 'Tag','Importuoti_laikus');
% Importuoti_RRI
h16 = uimenu( 'Parent',h14, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Importuoti_RRI_Callback',hObject,eventdata,guidata(hObject)), 'Label','RRI', 'Tag','Importuoti_RRI');
% EKG_is_TXT
h17 = uimenu( 'Parent',h14, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Importuoti_EKG_is_txt_Callback',hObject,eventdata,guidata(hObject)), 'Label','EKG *.TXT', 'Separator','on', 'Tag','EKG_is_TXT');
% Importuoti_LabChartMAT
h18 = uimenu( 'Parent',h14, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Importuoti_LabChartMAT_Callback',hObject,eventdata,guidata(hObject)), 'Label','LabChart *.MAT', 'Tag','Importuoti_LabChartMAT');
% Importuoti_BiopacACQ
h19 = uimenu( 'Parent',h14, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Importuoti_BiopacACQ_Callback',hObject,eventdata,guidata(hObject)), 'Label','Biopac *.ACQ', 'Tag','Importuoti_BiopacACQ');
% EEGLab
h20 = uimenu( 'Parent',h14, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Importuoti_EEGLab_Callback',hObject,eventdata,guidata(hObject)), 'Label','EEG *.set, *.edf, *.cnt...', 'Tag','EEGLab');
% Eksportuoti
handles.m_Eksportuoti = uimenu( 'Parent',handles.m_Duomenys, 'Accelerator','E', 'Callback',' ', 'Label','Eksportuoti', 'Tag','Eksportuoti');
% Eksportuoti_laikus
h22 = uimenu( 'Parent',handles.m_Eksportuoti, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Eksportuoti_laikus_Callback',hObject,eventdata,guidata(hObject)), 'Label','QRS laikus', 'Tag','Eksportuoti_laikus');
% Eksportuoti_RRI
h23 = uimenu( 'Parent',handles.m_Eksportuoti, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Eksportuoti_RRI_Callback',hObject,eventdata,guidata(hObject)), 'Label','RRI', 'Tag','Eksportuoti_RRI');
% Užverti neperduodant laikų
h27 = uimenu( 'Parent',handles.m_Duomenys, 'Accelerator','X', 'Callback',@(hObject,eventdata)pop_RRI_perziura('figure1_CloseRequestFcn',hObject,eventdata,guidata(hObject)), 'Separator','on', 'Label','Užverti', 'Tag','Uzverti');
% Perduoti laikus ir užverti, jei atidaryta iš kitos programos
h26 = uimenu( 'Parent',handles.m_Duomenys, 'Accelerator','Q', 'Callback',@(hObject,eventdata)pop_RRI_perziura('pushbutton_OK_Callback',hObject,eventdata,guidata(hObject)), 'Separator','off', 'Visible','off', 'Label','Pateikti QRS laikus', 'Tag','Perduoti');


% Taisa
handles.m_Taisa = uimenu( 'Parent',handles.figure1,  'Callback',' ','Label','Taisa','Tag','Taisa');
% istorija_atgal
h42 = uimenu( 'Parent',handles.m_Taisa, 'Accelerator','Z', 'Callback',@(hObject,eventdata)pop_RRI_perziura('istorija_atgal_ClickedCallback',hObject,eventdata,guidata(hObject)), 'Label','Atšaukti veiksmą', 'Tag','istorija_atgal');
% istorija_tolyn
h43 = uimenu( 'Parent',handles.m_Taisa, 'Accelerator','Y', 'Callback',@(hObject,eventdata)pop_RRI_perziura('istorija_tolyn_ClickedCallback',hObject,eventdata,guidata(hObject)), 'Label','Grąžinti atšauktąjį', 'Tag','istorija_tolyn');
% Naujas_dantelis
h32 = uimenu( 'Parent',handles.m_Taisa, 'Accelerator','R', 'Callback',@(hObject,eventdata)pop_RRI_perziura('naujas_dantelis',hObject,eventdata,guidata(hObject)), 'separator', 'on', 'Label','Pridėti tašką ranka', 'Tag','Naujas_dantelis');
% Salinti
h33 = uimenu( 'Parent',handles.m_Taisa, 'Accelerator','D', 'Callback',@(hObject,eventdata)pop_RRI_perziura('salinti_pazymetuosius1',hObject,eventdata,guidata(hObject)), 'Label','Pašalinti pažymėtus taškus', 'Tag','Salinti');
handles.m_Aptikti_EKG_QRS = uimenu( 'Parent',handles.m_Taisa, 'Accelerator','K', 'Callback',@(hObject,eventdata)pop_RRI_perziura('Aptikti_EKG_QRS_Callback',hObject,eventdata,guidata(hObject)), 'Label','Aptikti EKG QRS', 'Separator','on', 'Tag','Aptikti_EKG_QRS');


% Rodymas
handles.m_Rodymas = uimenu( 'Parent',handles.figure1,  'Callback',' ','Label','Rodymas','Tag','Rodymas');
% Atnaujinti
h31 = uimenu( 'Parent',handles.m_Rodymas, 'Accelerator','A', 'Callback',@(hObject,eventdata)pop_RRI_perziura('pushbutton_atnaujinti_Callback',hObject,eventdata,guidata(hObject)), 'Label','Atnaujinti', 'Tag','Atnaujinti');
% EKG rodymas
handles.m_ekg_rodyti = uimenu( 'Parent',handles.m_Rodymas, 'Callback',@(hObject,eventdata)pop_RRI_perziura('checkbox_ekg_Callback',hObject,eventdata,guidata(hObject)), 'separator', 'on', 'checked','on', 'Label','Rodyti EKG', 'Tag','ekg_rodyti');
% Nejungti
handles.m_Nejungti = uimenu( 'Parent',handles.m_Rodymas, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Nejungti_ClickedCallback',hObject,eventdata,guidata(hObject)), 'checked','on', 'Label','Nejungti ypač nutolusių taškų', 'Tag','Nejungti');
% Uzribis
handles.m_Uzribis = uimenu( 'Parent',handles.m_Rodymas, 'Callback',@(hObject,eventdata)pop_RRI_perziura('edit_ribos_Callback',hObject,eventdata,guidata(hObject)), 'separator', 'on', 'Label','Pažymėti įtartinus taškus', 'Tag','Uzribis');
% toggle_brush
%h49 = uimenu( 'Parent',handles.m_Rodymas, 'Callback',' ', 'OnCallback',@(hObject,eventdata)pop_RRI_perziura('axes_rri_ButtonDownFcn',hObject,eventdata,guidata(hObject)), 'OffCallback',@(hObject,eventdata)pop_RRI_perziura('toggle_brush_OffCallback',hObject,eventdata,guidata(hObject)), 'Label','Žymėjimo apvedant stačiakampiu veiksena', 'Tag','toggle_brush');
% aktyvusis
%h50 = uimenu( 'Parent',handles.m_Rodymas, 'Callback',' ', 'OnCallback',@(hObject,eventdata)pop_RRI_perziura('aktyvusis_OnCallback',hObject,eventdata,guidata(hObject)), 'OffCallback',@(hObject,eventdata)pop_RRI_perziura('aktyvusis_OffCallback',hObject,eventdata,guidata(hObject)), 'Label','Paryškinti pelei artimiausius taškus', 'Tag','aktyvusis');
% anotacijos
%h51 = uimenu( 'Parent',handles.m_Rodymas, 'Callback',' ', 'OnCallback',@(hObject,eventdata)pop_RRI_perziura('anotacijos_OnCallback',hObject,eventdata,guidata(hObject)), 'OffCallback',@(hObject,eventdata)pop_RRI_perziura('anotacijos_OffCallback',hObject,eventdata,guidata(hObject)), 'Label','Rodyti informaciją apie artimiausius taškus ties pele', 'Tag','anotacijos');
% Artinti2
h54 = uimenu( 'Parent',handles.m_Rodymas, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Artinti2_ClickedCallback',hObject,eventdata,guidata(hObject)), 'Separator','on', 'Tag','Artinti2');
% Artinti
h55 = uimenu( 'Parent',handles.m_Rodymas, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Artinti_ClickedCallback',hObject,eventdata,guidata(hObject)), 'Label','Artinti', 'Tag','Artinti');
% Tolinti
h56 = uimenu( 'Parent',handles.m_Rodymas, 'Callback',@(hObject,eventdata)pop_RRI_perziura('Tolinti_ClickedCallback',hObject,eventdata,guidata(hObject)), 'Label','Tolinti', 'Tag','Tolinti');
% optimalus
h57 = uimenu( 'Parent',handles.m_Rodymas, 'Visible','off', 'Tag','optimalus');
% optimalusy
h58 = uimenu( 'Parent',handles.m_Rodymas, 'Callback',@(hObject,eventdata)pop_RRI_perziura('optimalus_rodymasy',hObject,eventdata,guidata(hObject)), 'Label','Optimalus aukštis', 'Tag','optimalusy');
% optimalusx
h59 = uimenu( 'Parent',handles.m_Rodymas, 'Callback',@(hObject,eventdata)pop_RRI_perziura('optimalus_rodymasx',hObject,eventdata,guidata(hObject)), 'Label','Optimalus plotis', 'Tag','optimalusx');

% Eiti
handles.m_Eiti = uimenu( 'Parent',handles.figure1,  'Callback',' ','Label','Eiti','Tag','Eiti');
% į ankste
h60 = uimenu( 'Parent',handles.m_Eiti, 'Callback',@(hObject,eventdata)pop_RRI_perziura('eiti_i_ClickedCallback',hObject,eventdata,guidata(hObject)), 'Label','Šokti į laiką...', 'Tag','eiti_i');
% prie ankstesnio pažymėto
h61 = uimenu( 'Parent',handles.m_Eiti, 'Callback',@(hObject,eventdata)pop_RRI_perziura('eiti_pazym_atgal_ClickedCallback',hObject,eventdata,guidata(hObject)), 'Separator','on', 'Label','Prie ankstesnio pažymėto', 'Tag','eiti_pazym_atgal');
% prie tolesnio pažymėto
h62 = uimenu( 'Parent',handles.m_Eiti, 'Callback',@(hObject,eventdata)pop_RRI_perziura('eiti_pazym_tolyn_ClickedCallback',hObject,eventdata,guidata(hObject)), 'Label','Prie tolesnio pažymėto', 'Tag','eiti_pazym_tolyn');

function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
vers='Darbeliai';
try
    fid_vers=fopen(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai.versija'));
    vers=regexprep(regexprep(fgets(fid_vers),'[ ]*\n',''),'[ ]*\r','');
    fclose(fid_vers); 
catch err;
end;
handles.meniu_apie = uimenu(handles.figure1,'Label',lokaliz('Pagalba'));

uimenu( handles.meniu_apie, 'Label', lokaliz('Apie'), 'callback', 'pop_RRI_perziura(''apie'')');
if strcmp(char(java.util.Locale.getDefault()),'lt_LT');
    vers=strrep(vers,'Darbeliai','Darbelius');
%     uimenu( handles.meniu_apie, 'Label', lokaliz('Apie dialogo langa'), ...
%         'Accelerator','H', 'callback', ...
%         'web(''https://github.com/embar-/eeglab_darbeliai/wiki/3.1.%20Bendryb%C4%97s'',''-browser'') ;'  );
    uimenu( handles.meniu_apie, 'Label', [lokaliz('Apie') ' ' vers], 'callback', ...
        'web(''https://github.com/embar-/eeglab_darbeliai/wiki/0.%20LT'',''-browser'') ;'  );
else
%     uimenu( handles.meniu_apie, 'Label', lokaliz('Apie dialogo langa'), ...
%         'Accelerator','H', 'callback', ...
%         'web(''https://github.com/embar-/eeglab_darbeliai/wiki/3.%20Usage'',''-browser'') ;'  );
    uimenu( handles.meniu_apie, 'Label', [lokaliz('Apie') ' ' vers], 'callback', ...
        'web(''https://github.com/embar-/eeglab_darbeliai/wiki/0.%20EN'',''-browser'') ;'  );
end;
if exist('atnaujinimas.m','file') == 2;
    uimenu( handles.meniu_apie, 'Label', lokaliz('Check for updates'), 'separator','on', 'Callback', 'pop_atnaujinimas ;'  );    
end;
susaldyk(hObject, eventdata, handles);


%% GUI niuansai
set(handles.edit_ribos,'String','500 1300')
set(handles.axes_rri,'UserData',Pradiniai_laikai);
set(handles.axes_rri,'Units','pixels');
set(handles.figure1,'units','normalized','outerposition',[0 0 1 1]);
set(handles.figure1,'Units','pixels');
set(handles.text1,'Backgroundcolor','remove');
set(handles.text3,'Backgroundcolor','remove');
set(handles.text4,'Backgroundcolor','remove');
set(handles.text5,'Backgroundcolor','remove');
set(handles.text6,'Backgroundcolor','remove');
set(handles.text7,'Backgroundcolor','remove');
set(handles.checkbox_rri,'Backgroundcolor','remove');
set(handles.checkbox_ekg,'Backgroundcolor','remove');
set(handles.pushbutton_atstatyti,'Backgroundcolor','remove');
set(handles.pushbutton_atnaujinti,'Backgroundcolor','remove');
set(handles.checkbox_rri,'Value',1); 
set(handles.Nejungti,'State','on');
set(handles.anotacijos, 'State','on');
handles.hlink_OK = linkprop([findobj(handles.figure1,'Tag','Perduoti')' handles.pushbutton_OK handles.OK],{'Visible' 'Enable'});
handles.hlink_EKG = linkprop([handles.checkbox_ekg findobj(handles.figure1,'Tag','ekg_rodyti')' findobj(handles.figure1,'Tag','Aptikti_EKG_QRS')' ],{'Enable'});
handles.fig_brush=brush(handles.figure1);
handles.axes_rri_padetis=get(handles.axes_rri,'Position');
set(handles.axes_rri,'ButtonDownFcn',@(hObject,eventdata)pop_RRI_perziura('axes_rri_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
setappdata(handles.axes_rri,'originalButtonDownFcn',get(handles.axes_rri,'ButtonDownFcn'));
setappdata(handles.figure1,'ButtonDownFcnX','pop_RRI_perziura(''optimalus_rodymasx'',gcbf,[],guidata(gcbf),cx,diff(barXs))');
setappdata(handles.figure1,'ButtonDownFcnY','pop_RRI_perziura(''optimalus_rodymasy'',gcbf,[],guidata(gcbf),cx,diff(barXs))');
handles.pradines_fig=findobj(handles.figure1);
setappdata(handles.figure1,'istorija',struct('RRI','','Laikai','','Nejungti',''));
setappdata(handles.figure1,'istorijosNr',0);
set([handles.figure1 handles.axes_rri], 'Interruptible','off');

%% Grafikai
handles=pirmieji_grafikai(hObject, eventdata, handles);
susaldyk(hObject, eventdata, handles);

% Įtartinų taškų žymėjimas
edit_ribos_Callback(hObject, eventdata, handles);

%Kita
set(handles.edit_ribos,'UserData',1);
set(handles.pushbutton_atnaujinti,'UserData',1);
%set(handles.figure1,'toolbar','figure');
set(handles.pushbutton_OK,'Visible', fastif(get(handles.figure1,'userdata'),'on','off'));
drawnow;

%% Anotacijų paruošimas
handles.anot=RRI_perziuros_anotacija('prideti',handles.figure1,handles.axes_rri); % sukurti
if strcmp(get(handles.aktyvusis, 'State'),'off');
    aktyvusis_OffCallback(hObject, eventdata, handles); % paslepti
end;
setappdata(handles.axes_rri,'MouseOutMainAxesFnc',{'eval', [ ...
    'anotObj=findall(hFig,''Tag'',''Anot''); ' ...
    'if ~isequal(hittest,anotObj); ' ...
    '   set(anotObj,''Visible'',''off''); ' ...
    'end; ']});
setappdata(handles.axes_rri,'MouseOutMainAxesFnc_BrushMode',{'eval', [ ...
    'if ~ismember(get(findall(overObcj,''-property'',''Tag''),''Tag''),{''Brushing'' ''Anot''}); ' ... % overObcj=hittest
    '   set(findobj(hFig,''Tag'',''toggle_brush''),''state'',''off''); ' ...
    'brush(hFig,''off''); ' ...
    '   set(findobj(hFig,''Tag'',''aktyvusis''), ''Enable'',''on''); ' ...
    '   set(findobj(hFig,''Tag'',''anotacijos''),''Enable'', get(findobj(hFig,''Tag'',''aktyvusis''),''state'')) ; '...
    'end; ' ]});
setappdata(handles.axes_rri,'MouseInMainAxesFnc_BrushModeCont',{'eval', [ ...
    'set(findobj(hFig,''Tag'',''aktyvusis''), ''Enable'',''off''); ' ...
    'set(findobj(hFig,''Tag'',''anotacijos''),''Enable'',''off''); ' ...
    'set(findobj(hFig,''Tag'',''toggle_brush''),''state'',''on''); ' ...
    'brush(hFig,''on''); ' ]});

% Update handles structure
guidata(handles.figure1, handles);

% UIWAIT makes pop_RRI_perziura wait for user response (see UIRESUME)
if get(handles.figure1,'userdata');
    uiwait(handles.figure1);
end;

%%
function handles=pirmieji_grafikai(hObject, eventdata, handles)
%Paruošimas
set(handles.figure1,'pointer','watch');
Pradiniai_laikai=get(handles.axes_rri,'UserData');

if length(Pradiniai_laikai)>1;
    handles.Laikai=0.001*[Pradiniai_laikai(1) ; ( Pradiniai_laikai(1)*2 + Pradiniai_laikai(2))/3 ; Pradiniai_laikai(2:end)];
    handles.RRI=[0 ; NaN ; diff(Pradiniai_laikai)] ;
    set(handles.aktyvusis, 'State','on');
else isempty(Pradiniai_laikai);
    handles.Laikai=[0 ; 1; 30];
    handles.RRI=[0 ; NaN ; 1000];
    set(handles.aktyvusis, 'State','off');
end;

%Grafikai
axes(handles.axes_rri); cla;
hold on;

%Žymekliai
zymekliai(hObject, eventdata, handles);

% EKG grafikas
if and(~isempty(handles.EKG),...
        length(handles.EKG_laikai)== length(handles.EKG) );
    set(handles.checkbox_ekg,'Value',1);
    set(handles.checkbox_ekg,'Visible','on');
    set(handles.checkbox_ekg,'Enable','on');
    %hold off;
    % EKGposlinkis Y ašyje
    EKGposlinkis=min(handles.RRI(handles.RRI(:)>0));
    if isempty(EKGposlinkis); EKGposlinkis=0; end;
    %handles.EKG_=mat2gray_octave(handles.EKG)*100-125+EKGposlinkis;
    EKG_=mat2gray_octave(handles.EKG); EKG_=EKG_ .* 10 ./ std(EKG_);
    handles.EKG_=EKG_- max(EKG_) + median(EKG_) + EKGposlinkis - 50;
    handles.EKG_lin=line(handles.EKG_laikai,handles.EKG_,'color','r');
    set(handles.EKG_lin,'Tag','EKG_lin','hittest','off');
    % % Galėjome piešti su plot – bettada linijas braukia Brush veiksena, jas gali ištrinti
    %handles.EKG_lin=plot(handles.EKG_laikai,handles.EKG_,'color','r');
    %set(handles.EKG_lin,'Tag','EKG_lin','XDataSource','','YDataSource','','hittest','off');
    %handles.EKG_lin=get(handles.axes_rri,'Children');
    %try
    handles.EKG_R=0*handles.RRI-20+EKGposlinkis;
    handles.EKG_tsk=plot(handles.Laikai,handles.EKG_R,'o','color','g');
    set(handles.EKG_tsk,'Tag','EKG_tsk','XDataSource','','YDataSource','','hittest','off');%,'MarkerFaceColor','w');
    %linijos=get(handles.axes_rri,'Children');
    %handles.EKG_tsk=linijos(find(~ismember(linijos,handles.EKG_lin)));
    %catch err;
    %warning(err.message);
    %end
    %[hAx,~,hLine2] =plotyy(handles.Laikai,handles.RRI,handles.EKG_laikai,handles.EKG);
    %set(hLine2,'color','r');
    %set(hAx(2),'ycolor','r');
    %ylabel(hAx(2),'EKG');
    %paveikslas = getframe(gca);
    %image(paveikslas.cdata);
    %colormap(paveikslas.colormap);
else
    set(handles.checkbox_ekg,'Value',0);
    set(handles.checkbox_ekg,'Enable','off');
    set(handles.checkbox_ekg,'Visible','off');
    handles.EKG_lin=[];
    handles.EKG_tsk=[];
end;
handles.EKG_tsk_=[];

% RRI grafikas
handles.RRI_lin=plot(handles.Laikai,handles.RRI,'color','b');
set(handles.RRI_lin,'Tag','RRI_lin','XDataSource','','YDataSource','','hittest','off');
% linijos=get(handles.axes_rri,'Children');
% handles.RRI_lin=linijos(find(~ismember(linijos,[handles.EKG_lin handles.EKG_tsk])));
handles.RRI_tsk=plot(handles.Laikai,handles.RRI,'o','color','k');
set(handles.RRI_tsk,'Tag','RRI_tsk','XDataSource','','YDataSource','','hittest','off');%,'MarkerFaceColor','w');
% linijos=get(handles.axes_rri,'Children');
% handles.RRI_tsk=linijos(find(~ismember(linijos,[handles.EKG_lin handles.RRI_lin handles.EKG_tsk])));
% handles.grafikas=plot(handles.axes_rri,1,1,'color','b');
% handles.grafikas=plot(handles.axes_rri,1,1,'o','color','k');
% get(handles.axes_rri,'Children')
% set(get(handles.axes_rri,'Children'),'XDataSource','handles.Laikai');
% set(get(handles.axes_rri,'Children'),'YDataSource','handles.RRI');
% %linkdata(handles.figure1,'on');
%
% handles.Laikai=0.001*Pradiniai_laikai;
% handles.RRI=[NaN ; diff(Pradiniai_laikai)] ;

%
%dpm=datamanager.linkplotmanager;
%dpm.Figures.Panel.close;


%title('RRI');
%xlabel('laikas, s');
ylabel('RRI, ms');

refreshdata(handles.figure1,'caller');
% Slinktis
try
    nereikia_slinkties=0;
    try nereikia_slinkties=sum(ishandle(handles.scrollHandles)); catch, end;
    if nereikia_slinkties; 
        set(handles.scrollHandles,'XLim',[max(0,handles.Laikai(1)-5) 5*ceil(handles.Laikai(end)/5)]);
        set(handles.scrollHandles(2),'YLim',[0 1500]);
        error('Sliktis jau yra'); 
    end;
    if get(handles.checkbox_ekg,'Value'); xlangas=30 ; else xlangas=300 ; end;
    WindowSizeX=min(xlangas,max(handles.Laikai));
    WindowSizeY=max(300,...
            min(1500,50+max(handles.RRI)) - ...
            max(0,min(handles.RRI(handles.RRI > 0))-80) );
    MaxY=min(1500,30+max(handles.RRI));
    MinX=max(0,handles.Laikai(1)-5);
    XLim=[MinX 5*ceil(handles.Laikai(end)/5)];
    handles.scrollHandles = scrollplot2('Axis','XY',...
        'WindowSizeX', WindowSizeX, 'WindowSizeY', WindowSizeY,...
        'MinX', MinX, 'MaxY', MaxY) ;
    set(handles.scrollHandles,'XLim',XLim);
    set(handles.scrollHandles(2),'YLim',[0 1500]);
    handles.ScrollHandlesCldrK=findobj(handles.scrollHandles,'-not','Tag','scrollDataLine');
    handles.ScrollHandlesCldrL=findobj(handles.scrollHandles,'Tag','scrollDataLine');
    for i=1:length(handles.ScrollHandlesCldrL); l=handles.ScrollHandlesCldrL(i);
        dx=get(l,'XData'); %dy=get(l,'YData'); 
        if size(dx) == [1 2]; %#ok
            if strcmp(get(get(l,'parent'),'userdata'),'y');
                delete(l);
            else
                if length(unique(dx)) == 1; set(l,'Tag','Zymeklis_slinkiklyje'); end;
            end;
        elseif isequal(length(dx),length(handles.Laikai));
            set(l,'Tag','RRI_slinkiklyje','color',[0.5 0.5 0.5]);
        else
            delete(l);
        end;
    end;
    set(findobj(handles.figure1,'Tag','Zymeklis_slinkiklyje'),'Color',[0.94 0.98 1]);
    handles.ScrollHandlesCldrL=findobj(handles.scrollHandles,'Tag','scrollDataLine');
    handles.ScrollHandlesCldrR=findobj(handles.scrollHandles,'Tag','RRI_slinkiklyje');
    handles.ScrollHandlesCldrZ=findobj(handles.scrollHandles,'Tag','Zymeklis_slinkiklyje');
    %handles.ScrollPatchHandle=get(handles.scrollHandles,'ScrollPatchHandle');
    %handles.scrollParentAxesHandle=get(handles.scrollHandles,'ParentAxesHandle');
catch %err;
    %Pranesk_apie_klaida(err,mfilename,'',0);
    %warning(err.message);
    %old_unit=get(handles.pushbutton_atstatyti, 'Units');
    %set(hFig, 'Units','pixels');
%     set(handles.pushbutton_atstatyti,'Units','pixels');
%     set(handles.axes_rri,'Units','pixels');  
%     p1=get(handles.pushbutton_atstatyti,'Position');
%     p2=get(handles.axes_rri,'Position');
%     set(handles.axes_rri,'Position',[p2(1) p1(2)+p1(4)+2 p2(3) p2(2)+p2(4)-(p1(2)+p1(4)+2)]);
end;

% Kosmetika
set(handles.axes_rri,'YGrid','on','Xgrid','on','TickDir','out'); 
figure1_ResizeFcn(hObject, eventdata, handles);

% Taisymų žurnalavimas
istorijos_tikrinimas(hObject, eventdata, handles, handles.RRI, handles.Laikai);
 
% Užbaigimas
handles.t=0; % Pakutinio atnaujinimo laikas
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
if get(handles.checkbox_ekg,'Value');
    set(handles.ekg_rodyti,'State','on');
end;
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);


function zymekliai(hObject, eventdata, handles)
try delete(findobj(handles.figure1,'Tag','Zymeklis')); catch; end;
try delete(findobj(handles.figure1,'Tag','Zymeklis_slinkiklyje')); catch; end;
if isempty(handles.zmkl_lks); return; end;
clear('handles.zmkl');
try 
    %sklinkAsisX=findobj(handles.figure1,'Tag','scrollAx','UserData','x');
    try    ribos=get(handles.scrollHandles(2),'YLim'); % Jei atnaujinama
    catch; ribos=[0 1500]; % Jei pirmą kartą
    end;
    try    RRI=get(handles.RRI_tsk,'YData'); % Jei atnaujinama
    catch; RRI=handles.RRI; % Jei pirmą kartą
    end;
    vidur=min(RRI(find(RRI(:)>0))) -30;
    if isempty(vidur); vidur=1000; end; 
    if get(handles.checkbox_ekg,'Value'); vidur=vidur-130; ribos(1)=ribos(1)+100; end;
    param_liniju={'color','c','hittest','off','Tag','Zymeklis','LineWidth',0.5};
    handles.zmkl=struct;
    for h=[handles.axes_rri];% sklinkAsisX]; 
        axes(h);
        zmkl_N=length(handles.zmkl_lks);
        zmkl_Y=zeros(1, 3*zmkl_N);
        zmkl_Y((1:zmkl_N)*3)=NaN;
        zmkl_Y((1:zmkl_N)*3-1)=ribos(1);
        zmkl_Y((1:zmkl_N)*3-2)=ribos(2);
        zmkl_X=zeros(1, 3*zmkl_N);
        for i=1:zmkl_N; j=((i-1)*3+1):i*3;
           zmkl_X(j)=handles.zmkl_lks(i);
        end;
        handles.zmkl(end+1).obj=line('XData',zmkl_X,'YData',zmkl_Y,param_liniju{:});
    end;
    axes(handles.axes_rri);
    if vidur < 300; % or(vidur - ribos(1) > 500, vidur < 300);
    handles.zmkl(end+1).obj=text(handles.zmkl_lks,zeros(zmkl_N,1)+ribos(1),handles.zmkl_pvd,...
        'color','b','hittest','off','Tag','Zymeklis','FontUnits','points','FontSize',10,'FontName','Arial','Rotation',90,'HorizontalAlignment','left');
    end;
    handles.zmkl(end+1).obj=text(handles.zmkl_lks,zeros(zmkl_N,1)+ribos(2),handles.zmkl_pvd,...
        'color','b','hittest','off','Tag','Zymeklis','FontUnits','points','FontSize',10,'FontName','Arial','Rotation',90,'HorizontalAlignment','right');
    if vidur >= 300;
    handles.zmkl(end+1).obj=text(handles.zmkl_lks,zeros(zmkl_N,1)+vidur,  handles.zmkl_pvd,...
        'color','b','hittest','off','Tag','Zymeklis','FontUnits','points','FontSize',10,'FontName','Arial','Rotation',90,'HorizontalAlignment','right');
    end;
catch %err; Pranesk_apie_klaida(err,mfilename,'',0);
end;
%drawnow;
% %pause(5);
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);

%%

% --- Outputs from this function are returned to the command line.
function varargout = pop_RRI_perziura_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%uiwait;
%guidata(handles.figure1, handles);
% Get default command line output from handles structure
try
    varargout{1} = handles.output;
catch
    varargout{1} = [] ;
end;

% The figure can be deleted now
try
    if get(handles.figure1,'userdata'); delete(handles.figure1); end; %close(mfilename);
catch
end;


% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%guidata(handles.figure1, handles);
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
%Laikai=get(get(handles.axes_rri,'Children'),'XData'); %handles.Laikai;  %get(handles.axes_rri,'UserData');
Laikai_=get([handles.RRI_lin handles.RRI_tsk],'XData');
if iscell(Laikai_);  Laikai=Laikai_{1};
else Laikai=Laikai_;
end;
RRI_=get([handles.RRI_lin handles.RRI_tsk],'YData');
if iscell(RRI_); RRI=RRI_{1};
else RRI=RRI_;
end;

idx=find(~isnan(RRI));
%idx=[1 idx];
Laikai=Laikai(idx);
handles.output=1000*Laikai';
guidata(handles.figure1, handles);
uiresume;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~get(handles.figure1,'Userdata')
    delete(handles.figure1); return;
end;
disp(lokaliz('User closes window...'));
button = questdlg(lokaliz('Return QRS times?'),lokaliz('Closing'),lokaliz('Yes'),lokaliz('No'),lokaliz('Cancel'),lokaliz('Yes'));
switch button
    case lokaliz('No')
        delete(handles.figure1);
    case lokaliz('Yes')
        pushbutton_OK_Callback(hObject, eventdata, handles);
    otherwise
        disp(lokaliz('Canceled'));
end;

%%

function edit_ribos_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ribos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ribos as text
%        str2double(get(hObject,'String')) returns contents of edit_ribos as a double
set(handles.edit_ribos,'UserData',0);
if get(handles.pushbutton_atnaujinti,'UserData');
    pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
end;
set(handles.edit_ribos,'UserData',1);
set(handles.figure1,'pointer','watch');

RRI_=get([handles.RRI_lin handles.RRI_tsk],'YData');
if iscell(RRI_); RRI=RRI_{1};
else RRI=RRI_;
end;
% Taškų žymėjimas
%b0=brush(handles.figure1);
%brush(handles.figure1,'on');
%guidata(handles.figure1, handles);
%set(b0, 'ActionPreCallback', @(hObject,eventdata)pushbutton_atnaujinti_Callback(hObject,eventdata,handles), 'enable', 'on' );
%set(b0, 'ActionPreCallback', @(hObject,eventdata)atnaujinimas(hObject,eventdata,handles), 'enable', 'on' );
%set(b0, 'ActionPreCallback', 'set(handles.pushbutton_atnaujinti,''BackgroundColor'',[1 1 0])');
%set(b0, 'ActionPostCallback', @(handles)set(handles.pushbutton_atnaujinti,'BackgroundColor','remove'));
%set(b0, 'enable', 'on' );
%set(b0, 'ActionPreCallback', @(gcf,eventdata)pop_RRI_perziura('pushbutton_atnaujinti_Callback',gcf,eventdata,guidata(gcf)), 'enable', 'on' );
%set(b0, 'ActionPostCallback', @(hObject,eventdata)pop_RRI_perziura('pushbutton_atnaujinti_Callback',hObject,eventdata,guidata(hObject)), 'enable', 'on' );
%set(b0, 'ActionPostCallback', , 'enable', 'on' );
guidata(handles.figure1, handles);
ribos=str2num(get(handles.edit_ribos,'String'));
%hB = findobj(handles.figure1,'-property','BrushData');
hB = [handles.RRI_lin handles.RRI_tsk handles.EKG_tsk [handles.ScrollHandlesCldrR]'];
for h = hB;
    try   senas=get(h,'BrushData') ;   senas = (senas > 0) ;
    catch;
        try datamanager.enableBrushing(h); catch; end;
        senas=zeros(1,length(RRI)) ; senas = (senas > 0) ;
    end;
    try
        if get(handles.pushbutton_atnaujinti,'UserData');
            senas=zeros(1,length(RRI)) ; senas = (senas > 0) ;
        end;
        if length(ribos) == 1;
            naujas = [RRI<ribos(1)] - [RRI==0] ;
        elseif length(ribos) == 2;
            naujas = [RRI<ribos(1)] - [RRI==0] + [RRI>ribos(2)] ;
        end;
        suminis = round([senas + naujas] / 2) ;
        set(h,'BrushData', suminis );
    catch err;
        Pranesk_apie_klaida(err,mfilename,'',0);
    end;
end;
try set(handles.ScrollHandlesCldrL,'hittest','off'); catch; end;
try set(handles.ScrollHandlesCldrR,'hittest','off'); catch; end;
try set(handles.ScrollHandlesCldrZ,'hittest','off'); catch; end;
try set(handles.ScrollHandlesCldrK,'hittest','on'); catch; end;
%set(handles.figure1,'ButtonDownFcn', 'brush off');
%brush(handles.figure1,get(b0,'Enable'));
axes(handles.axes_rri);
% guidata(handles.figure1, handles);
% refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);
%assignin('base','handles_edit',handles);
set(handles.figure1,'pointer','arrow');
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_ribos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ribos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end;

% --- Executes on button press in pushbutton_atstatyti.
function pushbutton_atstatyti_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_atstatyti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1,'pointer','watch');
susaldyk(hObject, eventdata, handles);
Pradiniai_laikai=get(handles.axes_rri,'UserData');
if length(Pradiniai_laikai)>1;
    handles.Laikai=0.001*[Pradiniai_laikai(1) ; ( Pradiniai_laikai(1)*2 + Pradiniai_laikai(2))/3 ; Pradiniai_laikai(2:end)];
    handles.RRI=[0 ; NaN ; diff(Pradiniai_laikai)] ;
    set(handles.aktyvusis, 'State','on');
else isempty(Pradiniai_laikai);
    handles.Laikai=[0 ; 1; 30];
    handles.RRI=[0 ; NaN ; 1500];
    set(handles.aktyvusis, 'State','off');
end;
set([handles.RRI_lin handles.RRI_tsk],'Visible','off');
set([handles.RRI_lin handles.RRI_tsk handles.EKG_tsk],'XData',handles.Laikai);
set([handles.RRI_lin handles.RRI_tsk handles.EKG_tsk],'YData',handles.RRI);
setappdata(handles.figure1,'istorijosNr',0);
istorijos_busena(hObject, eventdata, handles);
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
optimalus_rodymasx(hObject, eventdata, handles);
optimalus_rodymasy(hObject, eventdata, handles);
set([handles.RRI_lin handles.RRI_tsk],'Visible','on');
edit_ribos_Callback(hObject, eventdata, handles);


function optimalus_rodymasy(hObject, eventdata, handles, varargin)
% Y ašyje
dbr=[];
if nargin > 3;   dbr=varargin{1}; end;
if isempty(dbr); dbr=950; end;
if nargin > 4; 
    plt=varargin{2};
    if plt <= 0; plt=diff(get(handles.axes_rri,'YLim')); end;
    dbr=min(dbr, 1540-plt/2);
    nymin=max(-40, dbr - plt/2);
    nymax=nymin+plt;
    set(handles.axes_rri,'YLim',[nymin nymax]);
    return;
end;
RRI=get(handles.RRI_tsk,'YData');
RRI_galiojantys=RRI(RRI(:)>0);
if get(handles.checkbox_ekg,'Value'); xlangas=130 ; else xlangas=30 ; end;
if ~isempty(RRI_galiojantys);
        ylim=get(handles.scrollHandles(2),'YLim');
        ymin=min(RRI_galiojantys)-xlangas;
        ymax=max(RRI_galiojantys)+30;
        lim_nj=[max(ylim(1),ymin) min(ylim(2),ymax)];
        if lim_nj(1) < lim_nj(2);
            set(handles.axes_rri,'YLim',lim_nj);
        else
            set(handles.axes_rri,'YLim',[800 1100]);
        end;
else
    set(handles.axes_rri,'YLim',[800 1100]);
end;

function optimalus_rodymasx(hObject, eventdata, handles, varargin)
%X ašyje
dbr=[];
if nargin > 3;   dbr=varargin{1}; end;
if isempty(dbr); dbr=mean(get(handles.axes_rri,'XLim')); end;
if nargin > 4; plt=varargin{2};
else           plt=30; % Optimalus plotis
end;
if plt <= 0; plt=diff(get(handles.axes_rri,'XLim')); end;
if isempty(handles.EKG_laikai); 
     Laikai=handles.Laikai; 
else Laikai=handles.EKG_laikai; 
end;
xmin=max(0,min(Laikai)-1);
xmax=max(xmin+plt,max(Laikai));
dbr=min(dbr,xmax-plt/2);
dbr=max(dbr,xmin+plt/2);
nxmin=dbr-plt/2;
nxmax=nxmin+plt;
set(handles.axes_rri,'XLim',[nxmin nxmax]);

% --- Executes on button press in atnaujinti.
function pushbutton_atnaujinti_Callback(hObject, eventdata, handles)
% hObject    handle to atnaujinti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Kai žmogus ranka ištrina taškus, gali būti,
% kad linijinis ir taškinis grafikas truputį skirsis

%linijos=get(handles.axes_rri,'Children');
%rri_lin=linijos(find(ismember(linijos,[handles.RRI_lin handles.RRI_tsk])));
try if toc(handles.t)<1; return; end; catch; end;
%Peliukas=get(handles.figure1,'pointer');
set(handles.figure1,'pointer','watch');
%susaldyk(hObject, eventdata, handles);
set(handles.pushbutton_atnaujinti,'Enable','off');
set(handles.atnaujinti,'Enable','off');
guidata(hObject,handles);
drawnow;
rri_lin=[handles.RRI_lin handles.RRI_tsk ];
if get(handles.checkbox_ekg,'Value');
    Laikai_=get([rri_lin handles.EKG_tsk],'XData');
    RRI_=get([rri_lin handles.EKG_tsk],'YData');
else
    Laikai_=get([rri_lin ],'XData');
    RRI_=get([rri_lin ],'YData');
end;
if iscell(Laikai_);
    Laikai__=[unique([Laikai_{:}])]';
else
    Laikai__=[unique([Laikai_])]';
end;
if iscell(RRI_);
    if length(RRI_) < 2 ; RRI_(2)=RRI_(1); Laikai_(2)=Laikai_(1); end;
    if length(RRI_) < 3 ; RRI_(3)=RRI_(1); Laikai_(3)=Laikai_(1); end;
    if length(RRI_{3})==1;
        if isnan(RRI_{3}); RRI_(3)=RRI_(1); Laikai_(3)=Laikai_(1); end;
    end;
    RRI1=RRI_{1}; RRI2=RRI_{2}; RRI3=RRI_{3};
    RRI__=nan(length(Laikai__),1);
    for i=1:length(Laikai__);
            ri1=find(Laikai_{1}==Laikai__(i)); 
            ri2=find(Laikai_{2}==Laikai__(i)); 
            ri3=find(Laikai_{3}==Laikai__(i)); 
            if ri1>length(RRI1); warning('kažas negerai'); disp('ri1='); disp(ri1); ri1=ri1(ri1<=length(RRI1)); end;
            if ri2>length(RRI2); warning('kažas negerai'); disp('ri2='); disp(ri2); ri2=ri2(ri2<=length(RRI2)); end;
            if ri3>length(RRI3); warning('kažas negerai'); disp('ri3='); disp(ri3); ri3=ri3(ri3<=length(RRI3)); end;
            if isempty(ri1); r1=NaN; else r1=RRI1(ri1); end;
            if isempty(ri2); r2=NaN; else r2=RRI2(ri2); end;
            if isempty(ri3); r3=NaN; else r3=RRI3(ri3); end;
            if length(r1)>1; warning('kažas negerai'); disp('r1='); disp(r1); r1=unique(r1); if length(r1)>1; r1=r1(r1>0); end; end;
            if length(r2)>1; warning('kažas negerai'); disp('r2='); disp(r2); r2=unique(r2); if length(r2)>1; r2=r2(r2>0); end; end;
            if length(r3)>1; warning('kažas negerai'); disp('r3='); disp(r3); r3=unique(r3); if length(r3)>1; r3=r3(r3>0); end; end;
        try % Dėl visa pikto gaudykim klaidą kertinėje atnaujinimo vietoje
            r=(r1+r2+r3)/3; % NaN + 1 = NaN
            RRI__(i,1)=r; 
        catch err;
            Pranesk_apie_klaida(err);
            assignin('base','RRI__',RRI__);
            assignin('base','r1',r1);
            assignin('base','r2',r2);
            assignin('base','r3',r3);
            pause(5);
            uiresume;
            assignin('base','r', r);
            rethrow(err);
        end;
    end;

else
    RRI__=RRI_;
end;

if length(RRI__)>1;

    Laikai3=Laikai__(~isnan(RRI__));
    RRI___=[0 ; 1000 * diff(Laikai3)];

    if ~get(handles.checkbox_rri,'Value');

        Laikai=Laikai3;
        RRI=RRI___;
    else

        if length(RRI___)>1;

            Laikai=[Laikai3(1) ; ( Laikai3(1)*2 + Laikai3(2))/3  ];
            RRI=[RRI___(1) ; NaN ];
            for i=2:length(RRI___);
                nejungti=str2num(get(handles.edit_nejungti,'String'));
                if RRI___(i) > nejungti(1);
                    Laikai(end+1)=(Laikai3(i-1)+2*Laikai3(i))/3;
                    RRI(end+1)=NaN;

                    Laikai(end+1)=Laikai3(i);
                    RRI(end+1)=0;

                    if ~(i==length(RRI___));
                        Laikai(end+1)=(Laikai3(i)*2+Laikai3(i+1))/3;
                        RRI(end+1)=NaN;
                    end;

                else
                    Laikai(end+1)=Laikai3(i);
                    RRI(end+1)=RRI___(i);
                end;
            end;

        else
            %warning('QRS?');
            Laikai=Laikai__;
            RRI=RRI__;
        end;


    end;

else
    warning('QRS?');
    Laikai=Laikai__;
    RRI=RRI__;
end;

% Pakeitimų žurnalas
istorijos_tikrinimas(hObject, eventdata, handles, RRI, Laikai);

% Grafikai
handles.RRI=RRI; handles.Laikai=Laikai; % šiedu nėra tikri „handles“, t.y. tai ne objektai
set(rri_lin,'XData',Laikai','YData',RRI'); % ritmograma pagrindiniame paveiksle
set(findobj(handles.figure1,'Tag','RRI_slinkiklyje'),'XData',Laikai','YData',RRI'); % ritmograma slinkikliuose
if and(~isempty(handles.EKG),get(handles.checkbox_ekg,'Value'));
    EKGposlinkis=min(RRI(RRI(:)>0));
    if isempty(EKGposlinkis); EKGposlinkis=1000; end;
    %handles.EKG_=mat2gray_octave(handles.EKG)*100-125+EKGposlinkis;
    EKG_=mat2gray_octave(handles.EKG); EKG_=EKG_ .* 10 ./ std(EKG_);
    handles.EKG_=EKG_- max(EKG_) + median(EKG_) + EKGposlinkis - 50;
    set(handles.EKG_lin,'XData',handles.EKG_laikai,'YData',handles.EKG_);
    handles.EKG_R=0*RRI'-20+EKGposlinkis;
    set(handles.EKG_tsk,'XData',Laikai','YData',handles.EKG_R);
else
    set([handles.EKG_lin handles.EKG_tsk],'XData',0,'YData',NaN);
end;
NY1=0; if get(handles.checkbox_ekg,'Value'); NY1=NY1-100; end; 
NY2=1500; %if ~isempty(RRI(find([RRI(:)] >0))); NY2=min(max(RRI)+30,1500); end;
NX1=5*floor(min([Laikai ; handles.EKG_laikai])/5);
NX2=5*ceil( max([Laikai ; handles.EKG_laikai])/5);
set(findobj(handles.scrollHandles(1),'Tag','scrollPatch'),'YData',[NY1 NY2 NY2 NY1 ]);
set(findobj(handles.scrollHandles(1),'Tag','scrollBar'),  'YData',[NY1 NY2]);
set(findobj(handles.scrollHandles(2),'Tag','scrollPatch'),'XData',[NX1 NX1 NX2 NX2]);
set(findobj(handles.scrollHandles(2),'Tag','scrollBar'),  'XData',[NX1 NX2]);
if isobject(handles.scrollHandles);
    set(handles.scrollHandles,'XLim',[NX1 NX2]);
    set(handles.scrollHandles,'YLim',[NY1 NY2]);
end;
for h=[handles.RRI_lin handles.RRI_tsk handles.EKG_tsk [handles.ScrollHandlesCldrL]'];
    try
        if length(get(h,'BrushData')) ~= length(get(h,'XData'));
            set(h,'BrushData',zeros(1,length(get(h,'XData'))));
        end;
    catch
    end;
end;
%handles.b0=brush(handles.figure1);
%set(handles.b0, 'ActionPreCallback', 'disp(0)', 'enable', 'on' );
%set(handles.b0, 'ActionPostCallback', @(hObject,eventdata)pushbutton_atnaujinti_Callback(hObject,eventdata,handles), 'enable', 'on' );
%figure(handles.figure1); linkdata('on');
%handles.susietas=linkdata(handles.figure1)
set(handles.pushbutton_atnaujinti,'UserData',0);
if get(handles.edit_ribos,'UserData');
    %edit_ribos_Callback(hObject, eventdata, handles);
end;
set(handles.pushbutton_atnaujinti,'UserData',1);
try delete(findobj(handles.figure1,'Tag','naujasR')); catch; end;
susildyk(hObject, eventdata, handles);
istorijos_busena(hObject, eventdata, handles);
figure1_ResizeFcn(hObject, eventdata, handles);
handles.t=tic;
guidata(handles.figure1, handles);
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);
%assignin('base','handles',handles);
figure(handles.figure1);
anotacijos_atnaujinimas(hObject, eventdata, handles);
%set(handles.figure1,'pointer',Peliukas);
set(handles.figure1,'pointer','arrow');


function naujas_dantelis(hObject, eventdata, handles)
RRI_perziuros_anotacija('salinti');
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
susaldyk(hObject, eventdata, handles);
set(handles.figure1,'Pointer','cross'); drawnow;
b='escape';
try [x,~,b]=ginput(1); catch err; Pranesk_apie_klaida(err,mfilename); end;
set(handles.figure1,'Pointer','arrow');
if and(ismember(num2str(b),{'1' '2' '3' 'space'}),isequal(gca,handles.axes_rri));
    naujas_dantelis_apytiksliai(hObject, eventdata, handles, x);
end;
susildyk(hObject, eventdata, handles);
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);
        

function naujas_dantelis_apytiksliai(hObject, eventdata, handles,x_sek)
if isempty(handles.EKG_laikai); 
    naujas_dantelis_tiksliai(hObject, eventdata, handles,x_sek);
    return; 
end;
[~,i]=min(abs(handles.EKG_laikai-x_sek));
ribos=get(handles.axes_rri,'XLim');
plotis_sek=(ribos(2)-ribos(1))/200;
plotis=round(plotis_sek*handles.EKG_Hz);
ii=[ max(1,i-plotis) : min(length(handles.EKG_laikai),i+plotis) ];
if ~isempty(which('smooth'));
    [~,y]=max(smooth( handles.EKG(ii)));
elseif ~isempty(which('smooth2'));
    [~,y]=max(smooth2(handles.EKG(ii)));
else
    [~,y]=max(handles.EKG(ii));
end;
nx_sek=handles.EKG_laikai(ii(y));
disp(sprintf('x=%.4f; nx=%.4f; nx-x=%.4f; leidžiama paklaida=%.1f ms', x_sek,nx_sek,nx_sek-x_sek,plotis_sek*1000));
%handles.EKG_tsk_=plot(nx_sek,handles.EKG_(ii(y)),'o','color','b','hittest','off','Tag','naujasR'); %laikinas
naujas_dantelis_tiksliai(hObject, eventdata, handles,nx_sek);
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);


function naujas_dantelis_tiksliai(hObject, eventdata, handles,x_sek)
perspeta=0;
if get(handles.checkbox_ekg,'Value');
    elementai=[handles.RRI_lin handles.RRI_tsk handles.EKG_tsk]; %
else
    elementai=[handles.RRI_lin handles.RRI_tsk]; %
end;
set(elementai,'Visible','off');
for h=elementai; % saugiau eiti per kiekvieną liniją atskirai dėl galimų netikėtų naudotojo pakeitimų po atnaujinimo
    dx=get(h,'XData');
    dy=get(h,'YData');
    i=max(find(dx < x_sek));
    if isempty(i); i = 0 ; end;
%     if isequal(h,handles.RRI_tsk);
%         disp('-');
%         disp([i-2 dx(i-2) dy(i-2)]);
%         disp([i-1 dx(i-1) dy(i-1)]);
%         disp([i dx(i) dy(i) 0]);
%         disp([i+1 dx(i+1) dy(i+1) 0]);
%         disp([i+2 dx(i+2) dy(i+2)]);
%         disp([i+3 dx(i+3) dy(i+3)]);
%     end;
    if min(abs(dx-x_sek))>0.005 % Paklaidos ribos
        if i>0;
            dxi=dx(i);
            if isnan(dy(i)); % virtualus prieš įterpiamąjį
                dyi=NaN ;
                dyj=0;
            elseif isequal(h,handles.EKG_tsk);
                dyi=dy(1);
                dyj=dy(1);
            elseif i == length(dx); % bus paskutinis
                dyi=dy(i); % ankstenio paskutinio nekeičiam
                dyj= (x_sek-dx(i)) *1000;
            else % per vidury – reikia įsiterpti tarp dviejų gretimų
                dyi= (x_sek-dx(i)) *1000;
                dyj=(dx(i+1)-x_sek)*1000;
            end;
        else %pats pirmas
            dxi=[]; dyi=[]; dyj=0;
        end;
        %     if isequal(h,handles.RRI_tsk);
        %         disp('-');
        %         disp([i-2 dx(i-2) dy(i-2)]);
        %         disp([i-1 dx(i-1) dy(i-1)]);
        %         disp([i dxi dyi]);
        %         disp([0 x_sek dyj])
        %         disp([i+1 dx(i+1) dy(i+1) ]);
        %         disp([i+2 dx(i+2) dy(i+2)]);
        %         disp([i+3 dx(i+3) dy(i+3)]);
        %     end;
        set(h,'XData',[dx(1:i-1) dxi x_sek dx((i+1):end)]);
        set(h,'YData',[dy(1:i-1) dyi  dyj  dy((i+1):end)]);
    elseif ~perspeta;
        msg=sprintf(['\n ' ...
            'Bandote kurti šalia kito pernelyg artimo taško! \n' ...
            'Tam, kad galėtumėte kurti tašką pasirinktoje vietoje, \n' ...
            'arba priartinkite norimą vietą (leisima kurti taškus su mažesne paklaida), \n' ...
            'arba ištrinkite seną tašką (jei ir taip pakankamai išdidinote norimą sritį).\n']);
        try error(msg); catch err; Pranesk_apie_klaida(err,mfilename,'',1); end;
        perspeta=1;
    end;
end;
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
optimalus_rodymasy(hObject, eventdata, handles);
set(elementai,'Visible','on');
drawnow;
%guidata(handles.figure1, handles);
%refreshdata(handles.figure1,'caller');
%guidata(handles.figure1, handles);


function anotacijos_atnaujinimas(hObject, eventdata, handles)
overObcj=hittest;
if ~or(isequal(overObcj,handles.axes_rri),is_family(overObcj,handles.axes_rri));
    return;
end;
figure(handles.figure1); axes(handles.axes_rri);
try   
    %RRI_perziuros_anotacija('prideti',handles.figure1,handles.axes_rri));
    feval(getappdata(handles.axes_rri,'MouseInMainAxesFnc'));
catch
end;

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

ck=get(hObject,'CurrentKey');
modifiers = get(gcf,'currentModifier');
try
switch ck
    case 'escape'
        uiresume(handles.figure1); % = išeiti iš programos
        % pushbutton_atstatyti_Callback(hObject, eventdata, handles); = nuo pradžių
    case 'enter'
        pushbutton_OK_Callback(hObject, eventdata, handles);
    case 'space'
        pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
    case 'delete'
        salinti_pazymetuosius1(hObject, eventdata, handles);
    case 'backspace'
        %salinti_pazymetuosius2(hObject, eventdata, handles);
        salinti_pazymetuosius1(hObject, eventdata, handles);
    case 'uparrow'
        %disp('^');
        lim_dbr=get(handles.axes_rri,'YLim');
        lim_max=get(handles.scrollHandles(2),'YLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=min(lim_dbr(2) + lim_plt * 0.2, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,'YLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'downarrow'
        %disp('v');
        lim_dbr=get(handles.axes_rri,'YLim');
        lim_max=get(handles.scrollHandles(2),'YLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=max(lim_dbr(1) - lim_plt * 0.2, lim_max(1) - lim_plt * 0.2);
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'YLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'leftarrow'
        %disp('<');
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=max(lim_dbr(1) - lim_plt * 0.2, lim_max(1) - lim_plt * 0.2);
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'rightarrow'
        %disp('>');
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=min(lim_dbr(2) + lim_plt * 0.2, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'pageup'
        %disp('<');
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=max(lim_dbr(1) - lim_plt * 1.0, lim_max(1) - lim_plt * 0.2);
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'pagedown'
        %disp('>');
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=min(lim_dbr(2) + lim_plt * 1.0, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'home'
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=lim_max(1) - lim_plt * 0.2;
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'end'
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=lim_max(2) + lim_plt * 0.2;
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case {'subtract','hyphen'}
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=max(lim_dbr(1) - lim_plt * 0.125, lim_max(1) - lim_plt * 0.2);
        lim_nj2=min(lim_dbr(2) + lim_plt * 0.125, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,'XLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'add'
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=lim_dbr(1) + lim_plt * 0.1;
        lim_nj2=lim_dbr(2) - lim_plt * 0.1;
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,'XLim',lim_nj);
        anotacijos_atnaujinimas(hObject, eventdata, handles);
    case 'n'
        if ismember('shift',modifiers);
            oldu=get(handles.axes_rri,'Units');
            set(handles.axes_rri,'Units','pixels');
            cp=get(handles.axes_rri,'CurrentPoint');
            set(handles.axes_rri,'Units',oldu);
            pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
            naujas_dantelis_apytiksliai(hObject, eventdata, handles,cp(1));
        elseif ismember('control',modifiers);
            pop_RRI_perziura;
        else
            naujas_dantelis(hObject, eventdata, handles);
%         if isequal(hittest,handles.axes_rri);            
%             set(handles.figure1,'Pointer','cross');
%             set(handles.EKG_lin,'hittest','on');
%             datacursormode(handles.figure1,'on');
%             hdatacursor=datacursormode(handles.figure1);
%             set(hdatacursor,'DisplayStyle','datatip','SnapToDataVertex','on');
%             drawnow;
%             k=waitforbuttonpress; if isnumeric(k); k=num2str(k); end;
%             k
%             while ~ismember(k,{'escape' 'enter'}); disp('-')
%                 k=waitforbuttonpress; if isnumeric(k); k=num2str(k); end;
%             end; disp('+');
%             datacursormode(handles.figure1,'off');
%             set(handles.EKG_lin,'hittest','off');
%             set(handles.figure1,'Pointer','arrow');
%             drawnow;
%         end;
        end;
    case {'o' 'i'}
        Importuoti_Callback(hObject, eventdata, handles);
    case {'s' 'e'}
        Eksportuoti_Callback(hObject, eventdata, handles);
    case 'v'
        if ismember('alt',modifiers);
            handles.EKG = 0 - handles.EKG;
            pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
        end;
    case 'z'
        if ismember('control',modifiers);
            istorija_atgal_ClickedCallback(hObject, eventdata, handles);
        else
            Artinti2_ClickedCallback(hObject, eventdata, handles);
        end
    case 'y'
        if ismember('control',modifiers);
            istorija_tolyn_ClickedCallback(hObject, eventdata, handles);
        end
    otherwise
        %disp(ck);
end;
catch err;
        Pranesk_apie_klaida(err,mfilename,'',0);
end;
guidata(handles.figure1, handles);

function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
modifiers = get(gcf,'currentModifier');
act=hittest;
if ~isempty(findall(act,'-property','Tag'));
    if ismember(get(hittest,'Tag'),{'scrollAx' 'scrollPatch' 'scrollBar'});
        if strcmp(get(hittest,'UserData'),'y')
             asisR='y'; asisN=2;
        else asisR='x'; asisN=1;
        end;
    else     asisR='x'; asisN=1;
    end;
else         asisR='x'; asisN=1;
end;
try
if ismember('control',modifiers);
    if eventdata.VerticalScrollCount > 0;
        lim_dbr=get(handles.axes_rri, [asisR 'lim']);
        lim_max=get(handles.scrollHandles(asisN),[asisR 'lim']);
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=lim_dbr(1) + lim_plt * 0.1;
        lim_nj2=lim_dbr(2) - lim_plt * 0.1;
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,[asisR 'lim'],lim_nj);
    else
        lim_dbr=get(handles.axes_rri,[asisR 'lim']);
        lim_max=get(handles.scrollHandles(asisN),[asisR 'lim']);
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=max(lim_dbr(1) - lim_plt * 0.125, lim_max(1) - lim_plt * 0.2);
        lim_nj2=min(lim_dbr(2) + lim_plt * 0.125, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,[asisR 'lim'],lim_nj);
    end;
else
    if eventdata.VerticalScrollCount * (1.5-asisN) > 0 % inversija Y ašiai
        lim_dbr=get(handles.axes_rri,[asisR 'lim']);
        lim_max=get(handles.scrollHandles(asisN),[asisR 'lim']);
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=min(lim_dbr(2) + lim_plt * 0.2, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,[asisR 'lim'],lim_nj);
    else
        lim_dbr=get(handles.axes_rri,[asisR 'lim']);
        lim_max=get(handles.scrollHandles(asisN),[asisR 'lim']);
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=max(lim_dbr(1) - lim_plt * 0.2, lim_max(1) - lim_plt * 0.2);
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,[asisR 'lim'],lim_nj);
    end;
end;
catch err;
        Pranesk_apie_klaida(err,mfilename,'',0);
end;
anotacijos_atnaujinimas(hObject, eventdata, handles);
guidata(handles.figure1, handles);

function salinti_pazymetuosius1(hObject, eventdata, handles)

        pushbutton_atnaujinti_Callback(hObject, eventdata, handles);

        %hB = findobj(handles.figure1,'-property','BrushData');
        %disp(intersect(hB,[handles.RRI_lin handles.RRI_tsk handles.EKG_tsk]));
        objektai=[handles.RRI_lin handles.RRI_tsk handles.EKG_tsk];
        for y=1:length(objektai);
            RRI_=get(objektai(y),'YData');
            try
                duom=get(objektai(y),'BrushData');
                %if iscell(RRI_); RRI=RRI_{y};
                %else
                RRI=RRI_;
                %end;
                for i=find(duom>0);
                    RRI(1,i)=NaN;
                end;
                set(objektai(y),'YData',RRI');
            catch err;                
                Pranesk_apie_klaida(err,'','',0);
            end;
        end;

        pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
        optimalus_rodymasy(hObject, eventdata, handles);


function salinti_pazymetuosius2(hObject, eventdata, handles)

        pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
        hB = findobj(handles.figure1,'-property','BrushData');
        duom=get(hB(1),'BrushData');
        Laikai_=get([handles.RRI_lin handles.RRI_tsk],'XData');
        if iscell(Laikai_); Laikai=Laikai_{1}(find(duom==0));
        else Laikai=Laikai_(find(duom==0));
        end;
        RRI_=get([handles.RRI_lin handles.RRI_tsk],'YData');
        if iscell(RRI_); RRI=RRI_{1}(find(duom==0));
        else RRI=RRI_(find(duom==0));
        end;
        set([handles.RRI_lin handles.RRI_tsk ],'XData',Laikai');
        set([handles.RRI_lin handles.RRI_tsk ],'YData',RRI');
        pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
        optimalus_rodymasy(hObject, eventdata, handles);

% --- Executes on button press in checkbox_ekg.
function checkbox_ekg_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ekg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ekg
if get(handles.checkbox_ekg,'Value');
    set(handles.ekg_rodyti,'State','on');
    set(handles.m_ekg_rodyti,'checked','on');
else
    set(handles.ekg_rodyti,'State','off');
    set(handles.m_ekg_rodyti,'checked','off');
end;
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
optimalus_rodymasy(hObject, eventdata, handles);
guidata(handles.figure1, handles);

% --- Executes on button press in checkbox_rri.
function checkbox_rri_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox_rri
if get(handles.checkbox_rri,'Value');
    set(handles.Nejungti,'State','on');
    set(handles.m_Nejungti,'Checked','on');
else
    set(handles.Nejungti,'State','off');
    set(handles.m_Nejungti,'Checked','off');
end;
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function Importuoti_laikus_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to Importuoti_laikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
if nargin < 4;
    [f,p]=uigetfile({'*.txt'; '*.*' ;});
    if or(isempty(f),f==0) ;
        susildyk(hObject, eventdata, handles);
        return ;
    end;
    rinkmena=fullfile(p,f);
else
    rinkmena=varargin{1};
end;
SeniLaikai=get(handles.axes_rri,'UserData');
%Senas_EKG=handles.EKG; % Tyčia leisti palikti seną EKG, jei yra tikslūs R laikai
%Senas_EKG_=handles.EKG_laikai;
try
    Laikai=dlmread(rinkmena);
    if median(diff(Laikai(:))) < 100;
        Laikai=Laikai*1000;
    end;
    set(handles.axes_rri,'UserData',Laikai);
    handles.zmkl_lks=[]; handles.zmkl_pvd={};
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
catch err;
    Pranesk_apie_klaida(err,mfilename,rinkmena,1,1);
    %warning(err.message);
    %w=warndlg(err.message);
    %uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
end;
susildyk(hObject, eventdata, handles);
drawnow;


% --------------------------------------------------------------------
function Importuoti_RRI_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to Importuoti_laikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
if nargin < 4;
    [f,p]=uigetfile({'*.dat'; '*.txt'; '*.*' ;});
    if or(isempty(f),f==0) ;
        susildyk(hObject, eventdata, handles);
        return ;
    end;
    rinkmena=fullfile(p,f);
else
    rinkmena=varargin{1};
end;
SeniLaikai=get(handles.axes_rri,'UserData');
Senas_EKG=handles.EKG;
Senas_EKG_=handles.EKG_laikai;
try
    Laikai=dlmread(rinkmena);
    if median(Laikai(:)) < 0.100;
        Laikai=Laikai*1000;
    end;
    Laikai=cumsum(Laikai);
    if size(Laikai,2) > 1;
        Laikai=[0; Laikai'];
    else
        Laikai=[0; Laikai];
    end;
    set(handles.axes_rri,'UserData',Laikai);
    handles.EKG=[];
    handles.EKG_laikai=[];
    handles.zmkl_lks=[]; handles.zmkl_pvd={};
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
catch err;
    Pranesk_apie_klaida(err,mfilename,rinkmena,1,1);
    %w=warndlg(err.message);
    %uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    handles.EKG=Senas_EKG;
    handles.EKG_laikai=Senas_EKG_;
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
end;
susildyk(hObject, eventdata, handles);
drawnow;


% --------------------------------------------------------------------
function Eksportuoti_laikus_Callback(hObject, eventdata, handles)
% hObject    handle to Eksportuoti_laikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Eksportuoti_Callback(hObject, eventdata, handles, 'QRS_laikai');


% --------------------------------------------------------------------
function Eksportuoti_RRI_Callback(hObject, eventdata, handles)
% hObject    handle to Eksportuoti_laikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Eksportuoti_Callback(hObject, eventdata, handles, 'RRI');


function susaldyk(hObject, eventdata, handles)
v=findall(handles.figure1);
for i=1:length(v);
    try
        set(v(i),'Enable','off');
    catch
    end;
end;
guidata(handles.figure1, handles);
drawnow;


function susildyk(hObject, eventdata, handles)
v=findall(handles.figure1);
for i=1:length(v);
    try
        set(v(i),'Enable','on');
    catch
    end;
end;

if ~get(handles.checkbox_rri,'Value');
    set(handles.edit_nejungti,'Enable','off');
end;
if strcmp(get(handles.checkbox_ekg,'Visible'),'off');
    set(findobj(handles.figure1,'Tag','Aptikti_EKG_QRS'),'Enable','off');
    set(handles.ekg_rodyti,'Enable','off');
    %set(handles.Eksportuoti_laikus,'Enable','off');
end;

neeksportuoti=1;
try if length(find(~isnan(get(handles.RRI_tsk,'YData')))) > 2;
        neeksportuoti=0;
    end;
catch
end;
if neeksportuoti;
    set(findobj(handles.figure1,'Tag','Eksportuoti'),'Enable','off');
end;

if strcmp(get(handles.toggle_brush,'state'),'on');
    set(handles.aktyvusis,'Enable','off');
end;
if strcmp(get(handles.aktyvusis,'state'),'off') || strcmp(get(handles.aktyvusis,'Enable'),'off');
    set(handles.anotacijos,'Enable','off');
end;
istorijos_busena(hObject, eventdata, handles);

figure(handles.figure1);
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);
drawnow;


function edit_nejungti_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nejungti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nejungti as text
%        str2double(get(hObject,'String')) returns contents of edit_nejungti as a double
x=str2num(get(handles.edit_nejungti,'String'));
if length(x) == 1 ;
    set(handles.edit_nejungti,'UserData',regexprep(num2str(x), '[ ]*', ' '));
end;
set(handles.edit_nejungti,'String',num2str(get(handles.edit_nejungti,'UserData')));

pushbutton_atnaujinti_Callback(hObject, eventdata, handles);

guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function edit_nejungti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nejungti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function Importuoti_EKG_is_txt_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to Importuoti_laikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
if nargin < 4;
    [f,p]=uigetfile({'*.txt'; '*.*' ;});
    if or(isempty(f),f==0) ;
        susildyk(hObject, eventdata, handles);
        return ;
    end;
    rinkmena=fullfile(p,f);
else
    rinkmena=varargin{1};
end;
set(handles.figure1,'pointer','watch');
SeniLaikai=get(handles.axes_rri,'UserData');
Senas_EKG=handles.EKG;
Senas_EKG_=handles.EKG_laikai;
try
    EKG=dlmread(rinkmena);
    if size(EKG,1) > 1; EKG=EKG' ; end;
    EKG_Hz=EKG_Hz_klausti;
    if ekg_apversta(EKG,EKG_Hz,0); EKG=-EKG; end;
    EKG_laikai=[1:length(EKG)] / EKG_Hz;
    if size(EKG_laikai,2) > 1; EKG_laikai=EKG_laikai' ; end;
    if median(diff(handles.EKG_laikai(:))) >= 100;
        handles.EKG_laikai=handles.EKG_laikai*0.001;
    end;
    handles.EKG=EKG;
    handles.EKG_laikai=EKG_laikai;
    handles.EKG_Hz=EKG_Hz;
    handles.zmkl_lks=[]; handles.zmkl_pvd={};
    try   Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles);
    catch err; Pranesk_apie_klaida(err, 'EKG QRS aptikimas', rinkmena, 0);
    end;
    
    dabartines_fig=findobj(handles.figure1);
    delete(dabartines_fig(~ismember(dabartines_fig,handles.pradines_fig)));
    set(handles.axes_rri,'Position',handles.axes_rri_padetis);

    handles=pirmieji_grafikai(hObject, eventdata, handles);
    
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
catch err;
    Pranesk_apie_klaida(err,mfilename,rinkmena,1,1);
    %w=warndlg(err.message);
    %uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    handles.EKG=Senas_EKG;
    handles.EKG_laikai=Senas_EKG_;
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
end;
susildyk(hObject, eventdata, handles);
set(handles.figure1,'pointer','arrow');
figure(handles.figure1);
drawnow;


% --------------------------------------------------------------------
function Importuoti_EEGLab_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to Importuoti_laikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
if nargin < 4;
    [f,p]=uigetfile({'*.set; *.edf; *.cnt'; '*.set'; '*.edf'; '*.cnt'; '*.*' ;});
    if or(isempty(f),f==0) ;
        susildyk(hObject, eventdata, handles);
        return ;
    end;
else
    [p,f,g]=fileparts(varargin{1}); f=[ f g ];
end;
set(handles.figure1,'pointer','watch');
SeniLaikai=get(handles.axes_rri,'UserData');
Senas_EKG=handles.EKG;
Senas_EKG_=handles.EKG_laikai;
try
    EEG = eeg_ikelk(p,f);
    %assignin('base','EEG',EEG);
    EKG_Hz=EEG.srate;
    
    if size(EEG.data,3)>1;
        error(lokaliz('Here you can not use epoched data!'));
    end;
    
    [iv_latenc,iv_tipai,~,~,EKG_laikai]=eeg_ivykiu_latenc(EEG);
    bndrs=find(ismember(iv_tipai,{'boundary'}));
    di=1:EEG.pnts;
    if ~isempty(bndrs);
        bndrs_=bndrs(isnan([EEG.event(bndrs).duration]));
        if ~isempty(bndrs_);
            warning(lokaliz('Record is not contiguous!'));
            lat=([EEG.event(bndrs_).latency]' - 1) / EEG.srate;
            lat=[EEG.xmin ; lat ; EEG.xmax];
            bloku_sar=arrayfun(@(i) sprintf('%d. %.3f - %.3f', ...
                i, lat(i),lat(i+1)), [1:length(lat)-1], 'UniformOutput', false)
            %[~,blokas]=max(diff(lat));
            %blokas=listdlg(...
            %    'ListString',bloku_sar,...
            %    'SelectionMode','single',...
            %    'InitialValue',blokas,...
            %    'PromptString',lokaliz('Please select block'),...
            %    'OKString',lokaliz('OK'),...
            %    'CancelString',lokaliz('Cancel'));
            %di=find((EEG.times/1000)    <lat(blokas+1));
            %di=find((EEG.times(di)/1000)>lat(blokas));
        end;
    end;
    
    Kanalu_N=EEG.nbchan;    
    if Kanalu_N > 1;
        try Kanalai={EEG.chanlocs.labels}; 
        catch err;
            Kanalai=arrayfun(@(i) sprintf('%d', i), [1:Kanalu_N], 'UniformOutput', false);
        end;
        KanaloNr=find(ismember(Kanalai,{'EKG' 'ECG'}));
        if isempty(KanaloNr); KanaloNr=1; end;
           KanaloNr=listdlg(...
            'ListString',Kanalai,...
            'SelectionMode','single',...
            'InitialValue',KanaloNr(1),...
            'PromptString',lokaliz('Please select channel'),...
            'OKString',lokaliz('OK'),...
            'CancelString',lokaliz('Cancel'));
    elseif Kanalu_N == 1;
        KanaloNr=1;
    else
        error('EEG.nbchan=0');
    end;
    
    Ivykiai_=unique(iv_tipai(~ismember(iv_tipai,'boundary')));
    if ~isempty(Ivykiai_);
        ivyk_QRSi=find(ismember(Ivykiai_,{'R' 'r' 'QRS'}));
        if ~isempty(ivyk_QRSi); ivyk_QRSi=ivyk_QRSi(1); else ivyk_QRSi=1; end;
        ivyk_QRSi=listdlg(...
            'ListString',Ivykiai_,...
            'SelectionMode','single',...
            'InitialValue',ivyk_QRSi,...
            'PromptString',lokaliz('Select QRS event:'),...
            'OKString',lokaliz('OK'),...
            'CancelString',lokaliz('Cancel'));
        ivyk_QRS=Ivykiai_{ivyk_QRSi};
        ivyk_kit=setdiff(Ivykiai_,ivyk_QRS);
        if ~isempty(ivyk_kit);
            ivyk_kiti=listdlg(...
            'ListString',ivyk_kit,...
            'SelectionMode','multiple',...
            'InitialValue',1:length(ivyk_kit),...
            'PromptString',lokaliz('Select other events:'),...
            'OKString',lokaliz('OK'),...
            'CancelString',lokaliz('Cancel'));
        ivyk_kit=ivyk_kit(ivyk_kiti);
        end;
    else
        ivyk_QRS='';
        ivyk_kit={};
    end;
    
    EKG=[double(EEG.data(KanaloNr,di))]';
    if ekg_apversta(EKG,EKG_Hz,0); EKG=-EKG; end;
    handles.EKG=EKG;
    handles.EKG_laikai=[EKG_laikai / 1000]'; % sekundėmis
    handles.EKG_Hz=EKG_Hz;
    zmkls=ismember(iv_tipai,ivyk_kit);
    handles.zmkl_lks=iv_latenc(zmkls) / 1000; % sekundėmis
    handles.zmkl_pvd=iv_tipai(zmkls);
    if isempty(ivyk_QRS);
        try   Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles);
        catch err; Pranesk_apie_klaida(err, 'EKG QRS aptikimas', f, 0);
        end;
    else
        Laikai=eeg_ivykiu_latenc(EEG, 'type', ivyk_QRS);
        %if size(Laikai,2) > 1; Laikai=[Laikai]'; end;
        set(handles.axes_rri,'UserData',Laikai);
    end;
    dabartines_fig=findobj(handles.figure1);
    delete(dabartines_fig(find(ismember(dabartines_fig,handles.pradines_fig)==0)));
    set(handles.axes_rri,'Position',handles.axes_rri_padetis);

    handles=pirmieji_grafikai(hObject, eventdata, handles);
    
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
catch err;
    Pranesk_apie_klaida(err,mfilename,f,1,1);
    %w=warndlg(err.message);
    %uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    handles.EKG=Senas_EKG;
    handles.EKG_laikai=Senas_EKG_;
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
end;
susildyk(hObject, eventdata, handles);
set(handles.figure1,'pointer','arrow');
figure(handles.figure1);
drawnow;


% --------------------------------------------------------------------
function Importuoti_LabChartMAT_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to Importuoti_BiopacACQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
if nargin < 4;
    [f,p]=uigetfile({'*.mat'; '*.*' ;});
    if or(isempty(f),f==0) ;
        susildyk(hObject, eventdata, handles);
        return ;
    end;
    rinkmena=fullfile(p,f);
else
    rinkmena=varargin{1};
end;
set(handles.figure1,'pointer','watch');
SeniLaikai=get(handles.axes_rri,'UserData');
try
    Labchart_data=load(rinkmena,'-mat');
    %assignin('base','Labchart_data',Labchart_data);
    figure(handles.figure1);
    try
        Kanalu_N=size(Labchart_data.datastart,1); % size(Labchart_data.titles,1);
        if Kanalu_N > 1;
            Kanalai=cellfun(@(i) Labchart_data.titles(i,:), ...
                num2cell(1:size(Labchart_data.titles,1)),...
                'UniformOutput',false);
            KanaloNr=listdlg(...
                'ListString',Kanalai,...
                'SelectionMode','single',...
                'InitialValue',1,...
                'PromptString',lokaliz('Please select channel'),...
                'OKString',lokaliz('OK'),...
                'CancelString',lokaliz('Cancel'));
        else
            KanaloNr=1;
        end;
    catch err;
        Pranesk_apie_klaida(err,mfilename,rinkmena,0);
        KanaloNr=0;
    end;

    if isempty(Labchart_data.com);
        blokas=1;
    else
        blokas=mode(Labchart_data.com(find(Labchart_data.com(:,4)==1),2));
        if isnan(blokas) ;
            blokas=1;
        end;
    end;

    Bloku_N=size(Labchart_data.samplerate,2);
    if Bloku_N > 1;
        bloku_sar=cellfun(@(i) [num2str(i) ' - ' ...
            num2str(Labchart_data.datastart(KanaloNr,i)) ':' ...
            num2str(Labchart_data.dataend(  KanaloNr,i)) ], ...
            num2cell(1:Bloku_N),...
            'UniformOutput',false);
        blokas=listdlg(...
            'ListString',bloku_sar,...
            'SelectionMode','single',...
            'InitialValue',blokas,...
            'PromptString',lokaliz('Please select block'),...
            'OKString',lokaliz('OK'),...
            'CancelString',lokaliz('Cancel'));
    end;

    if KanaloNr
        handles.EKG=[Labchart_data.data(Labchart_data.datastart(KanaloNr,blokas):Labchart_data.dataend(KanaloNr,blokas))]';
        if ekg_apversta(handles.EKG,Labchart_data.samplerate(KanaloNr,blokas),0); handles.EKG=-handles.EKG; end;
        handles.EKG_laikai=[...
            ([Labchart_data.datastart(KanaloNr,blokas):Labchart_data.dataend(KanaloNr,blokas)] ...
            - Labchart_data.datastart(KanaloNr,blokas) ) / Labchart_data.samplerate(KanaloNr,blokas)]';
        set(handles.checkbox_ekg,'Value',1);
        %assignin('base','EKG_laikai',handles.EKG_laikai);
    else
        handles.EKG=[];
        handles.EKG_laikai=[];
    end;

%     if strcmp(get(handles.checkbox_ekg,'Visible'),'off');
%         set(handles.checkbox_ekg,'Visible','on');
%         handles.EKG_lin=plot(1,NaN,'color','r'); %handles.EKG_lin=plot(handles.EKG_laikai,handles.EKG_,'color','r');
%         handles.EKG_tsk=plot(1,NaN,'o','color','g'); %handles.EKG_tsk=plot(handles.Laikai,handles.EKG_R,'o','color','g');
%         brush(handles.figure1,'on');
%     end;

    if isempty(Labchart_data.com);
        LabChart_key='';
    else
        LabChart_TXT_events=(Labchart_data.comtext(Labchart_data.com(  find(Labchart_data.com(:,4) == 2), 5) ,1:3));
        LabChart_TXT_events_=unique(cellfun(@(i) LabChart_TXT_events(i,:), num2cell(1:length(LabChart_TXT_events)),'UniformOutput', false ));
        komb=ismember({'ECG' 'HRV'}, LabChart_TXT_events_);
        switch komb(1)*10 + komb(2)
            case 10
                LabChart_key='ECG';
            case 1
                LabChart_key='HRV';
            case 11
                button = questdlg(...
                    lokaliz('Select events:'),...
                    lokaliz('Selection of events'),...
                    'ECG','HRV',...
                    'ECG');
                switch button
                    case 'ECG'
                        LabChart_key='ECG';
                    case 'HRV'
                        LabChart_key='HRV';
                    otherwise
                        LabChart_key='';
                end;
            otherwise
                LabChart_key='';
        end;
    end;

    Laikai=[];

    if isempty(LabChart_key);
        try
            Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles);
        catch err;
            Pranesk_apie_klaida(err, 'EKG QRS aptikimas', rinkmena, 0);
            Laikai=[[1 NaN 100]*1000]';
            set(handles.axes_rri,'UserData',Laikai);
        end;
    else

        for icomMain = [intersect(...
                find(Labchart_data.com(:,2)==blokas),...
                find(Labchart_data.com(:,4)==2))]' ;
            comtextMark = Labchart_data.com(icomMain, 5);
            comtextMark = Labchart_data.comtext(comtextMark,:);
            comtextMark = deblank(comtextMark);
            is_LabChart_key=0;
            if and(length(comtextMark) > 2, ~isempty(LabChart_key))
                if strcmp(comtextMark(1:3),LabChart_key);
                    is_LabChart_key=1;
                end;
            end;
            if is_LabChart_key
                Laikelis=Labchart_data.com(icomMain,3) * ...
                    ( 1000 / Labchart_data.tickrate(blokas) )  ; % * g.Labchart_laiko_daugiklis ;
                Laikai=[Laikai; Laikelis];

            end ;
        end ;

        if isempty(Laikai);
            Laikai=[[1 NaN 100]*1000]';
        end;
        set(handles.axes_rri,'UserData',Laikai);
    end;
    
    handles.zmkl_lks=[]; handles.zmkl_pvd={};

    dabartines_fig=findobj(handles.figure1);
    delete(dabartines_fig(find(ismember(dabartines_fig,handles.pradines_fig)==0)));
    set(handles.axes_rri,'Position',handles.axes_rri_padetis);

    handles=pirmieji_grafikai(hObject, eventdata, handles);

    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
catch err;
    Pranesk_apie_klaida(err, 'Importuoti_LabChartMAT', rinkmena, 0);
    %warning(err.message);
    %w=warndlg(err.message);
    %uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
end;
susildyk(hObject, eventdata, handles);
set(handles.figure1,'pointer','arrow');
figure(handles.figure1);
drawnow;


% --------------------------------------------------------------------
function Importuoti_BiopacACQ_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to Importuoti_BiopacACQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
if nargin < 4;
    [f,p]=uigetfile({'*.acq'; '*.*' ;});
    if or(isempty(f),f==0) ;
        susildyk(hObject, eventdata, handles);
        return ;
    end;
    rinkmena=fullfile(p,f);
else
    rinkmena=varargin{1};
end;
set(handles.figure1,'pointer','watch');
SeniLaikai=get(handles.axes_rri,'UserData');
try
    acq_data=load_acq(rinkmena);
    %assignin('base','acq_data',acq_data);
    figure(handles.figure1);
    if isempty(acq_data.data); error(lokaliz('Empty dataset')); end;
    try
        Kanalu_N=acq_data.hdr.graph.num_channels;
        if Kanalu_N > 1;
            Kanalai={acq_data.hdr.per_chan_data.comment_text};
            KanaloNr=listdlg(...
                'ListString',Kanalai,...
                'SelectionMode','single',...
                'InitialValue',1,...
                'PromptString',lokaliz('Please select channel'),...
                'OKString',lokaliz('OK'),...
                'CancelString',lokaliz('Cancel'));
        else
            KanaloNr=1;
        end;
    catch err;
        Pranesk_apie_klaida(err,mfilename,'',0);
        KanaloNr=0;
    end;

    bloku=regexp(acq_data.markers.szText,'^Segment .*');
    bloku=find(arrayfun(@(i) ~isempty(bloku{i}), 1:length(bloku)));
    Bloku_N=length(bloku);
    if Bloku_N > 1;
        bloku_sar=acq_data.markers.szText(bloku);
        blokas=find(ismember(bloku,find(acq_data.markers.fSelected,1)));
        if isempty(blokas); blokas=1; end;
        blokas=listdlg(...
            'ListString',bloku_sar,...
            'SelectionMode','single',...
            'InitialValue',blokas,...
            'PromptString',lokaliz('Please select block'),...
            'OKString',lokaliz('OK'),...
            'CancelString',lokaliz('Cancel'));
    else
        blokas=1;
    end;

    if KanaloNr
        nuo=acq_data.markers.lSample(bloku(blokas))+1;
        if bloku(blokas) < bloku(end);
            iki=acq_data.markers.lSample(bloku(blokas+1));
        else
            iki=size(acq_data.data,1);
        end;
        handles.EKG=double(acq_data.data(nuo:iki,KanaloNr));
        if ekg_apversta(handles.EKG,double(acq_data.hdr.graph.sample_time),0); handles.EKG=-handles.EKG; end;
        handles.EKG_laikai=[double([nuo:iki] - nuo ) / 1000 * ...
            double(acq_data.hdr.graph.sample_time) ]';
        set(handles.checkbox_ekg,'Value',1);
        %assignin('base','EKG_laikai',handles.EKG_laikai);
    %else
    %    handles.EKG=[];
    %    handles.EKG_laikai=[];
    end;

    try
        Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles);
    catch err;
        Pranesk_apie_klaida(err, 'EKG QRS aptikimas', rinkmena, 0);
    end;
    
    handles.zmkl_lks=[]; handles.zmkl_pvd={};
    
    dabartines_fig=findobj(handles.figure1);
    delete(dabartines_fig(~ismember(dabartines_fig,handles.pradines_fig)));
    set(handles.axes_rri,'Position',handles.axes_rri_padetis);
    guidata(handles.figure1, handles);

    handles=pirmieji_grafikai(hObject, eventdata, handles);

    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
catch err;
    Pranesk_apie_klaida(err, 'Importuoti_LabChartMAT', rinkmena, 0);
    %warning(err.message);
    %w=warndlg(err.message);
    %uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(handles.figure1, handles);
end;
susildyk(hObject, eventdata, handles);
set(handles.figure1,'pointer','arrow');
figure(handles.figure1);
drawnow;

% --------------------------------------------------------------------
function Aptikti_EKG_QRS_Callback(hObject, eventdata, handles)
% hObject    handle to Aptikti_EKG_QRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles);
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
catch err;
    Pranesk_apie_klaida(err, 'EKG QRS aptikimas', '?', 0);
end;
susildyk(hObject, eventdata, handles);
guidata(handles.figure1, handles);
figure(handles.figure1);
drawnow;


function Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles)
susaldyk(hObject, eventdata, handles);
%handles.EKG_Hz = (length(handles.EKG_laikai)-1) / (handles.EKG_laikai(end)-handles.EKG_laikai(1)) ;
QRS_algoritmai={...
    'Pan-Tompkin (1985), pg. Sedghamiz (2014)' ...
    'Ramakrishnan et al. (2014)' ...
    'Suppappola-Sun (1994), iš ECGlab2.0' ...
    'adaptyvus Sedghamiz (2014) algoritmas'};
mode=listdlg('ListString',QRS_algoritmai,...
    'SelectionMode','single',...
    'InitialValue',1,...
    'PromptString',lokaliz('QRS detection algoritm:'),...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
if isempty(mode);
    susildyk(hObject, eventdata, handles);
    set(handles.figure1,'pointer','arrow');
    return;
end;

set(handles.figure1,'pointer','watch');

% % statusbar
% tici=tic;
f=statusbar(lokaliz('Palaukite!'));
statusbar('on',f);
%     tok=toc(tici);
%     p=i/length(RINKMENOS);
%     if and(tok>1,p<0.5);
%         statusbar('on',f);
%     end;
%     if isempty(statusbar(p,f));
%         break;
%     end;
p=0;
statusbar(p,f);

try
    leisti_apversti=~isempty(get(gcf,'currentModifier'));
    [RR_idx]=QRS_detekt(handles.EKG, handles.EKG_Hz, mode, leisti_apversti);
catch err;
    if ishandle(f); delete(f); end; 
    Pranesk_apie_klaida(err,QRS_algoritmai{mode},mfilename,1,1);
    Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles);
    return;
    
    susildyk(hObject, eventdata, handles);
    rethrow(err);
end;
if ishandle(f); delete(f); end;
Laikai=handles.EKG_laikai(RR_idx)*1000; %Laikai=(RR_idx-1)/sampling_rate*1000;
set(handles.axes_rri,'UserData',Laikai);
susildyk(hObject, eventdata, handles);
set(handles.figure1,'pointer','arrow');
guidata(handles.figure1, handles);


function EKG_Hz=EKG_Hz_klausti
a=inputdlg(lokaliz('Sampling rate (Hz):'),mfilename,1);
if ~isempty(a);
    if ~isempty(a{1});
        EKG_Hz=str2num(a{1});
    else
        EKG_Hz=EKG_Hz_klausti;
    end;
else
    EKG_Hz=EKG_Hz_klausti;
end;


function in_family=is_family(objChild,objParent)
try
    par=get(objChild,'parent');
    if isequal(par,objParent);
        in_family=true;
    elseif isequal(par,groot) || isempty(par);
        in_family=false;
    else
        in_family=is_family(par,objParent);
    end;
catch
    in_family=0;
end;


% --- Executes on mouse press over axes background.
function axes_rri_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_rri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.axes_rri,'originalButtonDownFcn',get(handles.axes_rri,'ButtonDownFcn'));
setappdata(handles.axes_rri,'update_fnc',get(handles.pushbutton_atnaujinti,'Callback'));
%try delete(findall(handles.figure1,'Type','textbox','Tag','Anot')); catch; end;
brush(handles.figure1,'on');
set(handles.toggle_brush,'state','on');
set(findobj(handles.figure1,'Tag','aktyvusis'),'Enable','off');
set(findobj(handles.figure1,'Tag','anotacijos'),'Enable','off');
set(handles.figure1,'Pointer','crosshair');


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.figure1,'Units','pixels');
    set(handles.axes_rri,'Units','pixels');  
    set(handles.text4,'Units','pixels');
    set(handles.text6,'Units','pixels');
    set(handles.text7,'Units','pixels');
    set(handles.checkbox_ekg,'Units','pixels');
    set(handles.pushbutton_atstatyti,'Units','pixels');
    set(handles.pushbutton_atnaujinti,'Units','pixels');
    set(handles.pushbutton_OK,'Units','pixels');
    
    p0=get(handles.figure1,'Position');    
    set(handles.figure1,'Position',[p0(1:2) max(850,p0(3)) max(480,p0(4)) ]) ;
    guidata(handles.figure1, handles);
    drawnow;
    p0=get(handles.figure1,'Position');
    p1=get(handles.text4,  'Position');
    
    plt=max(0.8*(p0(3)-80),1);
    auk=max(0.8*(p0(4)-90),1);
    xgl=p0(3)-0.11*plt-60;
    set(handles.axes_rri,'Position',[80 65+p0(4)/5 plt auk]);
    set(handles.text4,   'Position',[p1(1:2) max(xgl-p1(1)-20,1) p1(4)]);
    set(handles.text6,   'Position',[0 0 p0(3) 52]);
    set(handles.text7,   'Position',[p0(3)-150 0 170 150]);
    set(handles.checkbox_ekg,         'Position',[xgl 132 100 20]);
    set(handles.pushbutton_atstatyti, 'Position',[xgl 92  100 30]);
    set(handles.pushbutton_atnaujinti,'Position',[xgl 52  100 30]);
    set(handles.pushbutton_OK,        'Position',[xgl 12  100 30]);
    
    % RRI_perziuros_anotacija atnaujins koeficientus
    setappdata(handles.axes_rri,'koefY',[]); 
    setappdata(handles.axes_rri,'koefX',[]);


% --------------------------------------------------------------------
function Importuoti_Callback(hObject, eventdata, handles)
% hObject    handle to Importuoti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%susaldyk(hObject, eventdata, handles);
[f,p,i]=uigetfile({...
    '*.txt;*.TXT' '*.TXT - QRS laikai'; ...
    '*.dat;*.DAT' '*.DAT - R-R intervalai'; ...
    '*.txt;*.TXT' '*.TXT - R-R intervalai'; ...
    '*.txt;*.TXT' '*.TXT - EKG'; ...
    '*.mat;*.MAT' '*.MAT - LabChart'; ...
    '*.acq;*.ACQ' '*.ACQ - Biopac'; ...
    '*.set;*.SET' '*.SET - EEGLAB'; ...
    '*.edf;*.EDF' '*.EDF'; ...
    '*.cnt;*.CNT' '*.CNT - ASA Lab'; ...
    '*'           '*';...
    }, 'Pasirinkite importuotiną rinkmeną');
if or(isempty(f),f==0) ; 
    %susildyk(hObject, eventdata, handles);
    return ; 
end;
rinkmena=fullfile(p,f);
switch i
    case 1
        Importuoti_laikus_Callback(hObject, eventdata, handles, rinkmena)
    case {2 3}
        Importuoti_RRI_Callback(hObject, eventdata, handles, rinkmena)
    case 4
        Importuoti_EKG_is_txt_Callback(hObject, eventdata, handles, rinkmena)
    case 5
        Importuoti_LabChartMAT_Callback(hObject, eventdata, handles, rinkmena)
    case 6
        Importuoti_BiopacACQ_Callback(hObject, eventdata, handles, rinkmena);
    otherwise
        Importuoti_EEGLab_Callback(hObject, eventdata, handles, rinkmena)
end;
    

% --------------------------------------------------------------------
function Eksportuoti_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to Eksportuoti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
susaldyk(hObject, eventdata, handles);
Laikai_=get([handles.RRI_lin handles.RRI_tsk],'XData');
if iscell(Laikai_);  Laikai=Laikai_{1};
else Laikai=Laikai_;
end;
RRI_=get([handles.RRI_lin handles.RRI_tsk],'YData');
if iscell(RRI_); RRI=RRI_{1};
else RRI=RRI_;
end;

Laikai=Laikai(~isnan(RRI));
handles.output=1000*Laikai';
if iscell(Laikai_);  Laikai=Laikai_{1};
else Laikai=Laikai_;
end;
RRI_=get([handles.RRI_lin handles.RRI_tsk],'YData');
if iscell(RRI_); RRI=RRI_{1};
else RRI=RRI_;
end;
Laikai=Laikai(~isnan(RRI));
R_laikai=1000*Laikai';
%R_laikai=Laikai';
RRI=diff(R_laikai);
guidata(handles.figure1, handles);
if isempty(R_laikai);
    w=warndlg('Nebus ko eksportuoti!'); uiwait(w);
    susildyk(hObject, eventdata, handles);
else
    if nargin > 3; exp_tipas=varargin{1}; else exp_tipas=''; end;
    if isempty(exp_tipas);
        exp_tipai={'R-R intervalai' 'QRS laikai' ' '};
        exp_tipas=listdlg(...
            'ListString',exp_tipai,...
            'SelectionMode','single',...
            'InitialValue',2,...
            'PromptString','Eksportavimas',...
            'OKString',lokaliz('OK'),...
            'CancelString',lokaliz('Cancel'));
    end;
    if isempty(exp_tipas); 
        susildyk(hObject, eventdata, handles); return; 
    end;
    switch exp_tipas
        case {1 'RRI'}
            g='*.dat'; d=RRI;      t='%.0f'; 
        case {2 'RRI_laikai' 'RRI laikai' 'QRS_laikai' 'QRS laikai' 'laikai'}
            g='*.txt'; d=R_laikai; t='%.3f'; 
        case {3 'EEGLAB'}
            if ~get(handles.checkbox_ekg,'Value'); 
                susildyk(hObject, eventdata, handles); return; 
            end;
            g='*.set'; 
        otherwise
            warning('Netinkama veiksena');
            susildyk(hObject, eventdata, handles); return;
    end;
    [f,p]=uiputfile({g; '*.*' ;});
    susildyk(hObject, eventdata, handles);
    if or(isempty(f),f==0) ; return ; end;
    try
        switch exp_tipas
            case {1 'RRI' ...
                  2 'RRI_laikai' 'RRI laikai' 'QRS_laikai' 'QRS laikai' 'laikai'}
                dlmwrite(fullfile(p,f), num2cell(d), 'precision',t, 'newline', 'pc') ;
            case {3 'EEGLAB'}
                [~, EEG] = pop_newset([],[],[]);
                EEG.chanlocs.labels='EKG';
                EEG.data=handles.EKG';
                EEG.times=1000*handles.EKG_laikai';
                EEG.xmin=min(handles.EKG_laikai);
                EEG.xmax=max(handles.EKG_laikai);
                EEG.nbchan=1;
                EEG.srate=handles.EKG_Hz;
                ivykiai(1:length(R_laikai))={'R'};
                EEG.event=struct('type',ivykiai,...
                    'latency',num2cell(0.001*handles.EKG_Hz*R_laikai'),...
                    'urevent',num2cell(1:length(R_laikai)));
                EEG = eeg_checkset(EEG);
                eeg_issaugoti(EEG, p, f);
        end;
    catch err;
        Pranesk_apie_klaida(err,mfilename,f,1,1);
    end;
end;


% --------------------------------------------------------------------
function Artinti_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Artinti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
asysR={'x' 'y'};
try
for asisN=1:2;
    asisR=asysR{asisN};
        lim_dbr=get(handles.axes_rri, [asisR 'lim']);
        lim_max=get(handles.scrollHandles(asisN),[asisR 'lim']);
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=lim_dbr(1) + lim_plt * 0.1;
        lim_nj2=lim_dbr(2) - lim_plt * 0.1;
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,[asisR 'lim'],lim_nj);
end;
catch err;
        Pranesk_apie_klaida(err,mfilename,'',0);
end;
anotacijos_atnaujinimas(hObject, eventdata, handles);
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function Tolinti_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Tolinti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
asysR={'x' 'y'};
try
for asisN=1:2;
    asisR=asysR{asisN};
        lim_dbr=get(handles.axes_rri,[asisR 'lim']);
        lim_max=get(handles.scrollHandles(asisN),[asisR 'lim']);
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=max(lim_dbr(1) - lim_plt * 0.125, lim_max(1) - lim_plt * 0.2);
        lim_nj2=min(lim_dbr(2) + lim_plt * 0.125, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,[asisR 'lim'],lim_nj);
end;
catch err;
        Pranesk_apie_klaida(err,mfilename,'',0);
end;
anotacijos_atnaujinimas(hObject, eventdata, handles);
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function anotacijos_OffCallback(hObject, eventdata, handles)
% hObject    handle to anotacijos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.axes_rri,'MouseInMainAxesFnc', {'eval' ...
    'set(hFig,''Pointer'',''arrow''); RRI_perziuros_anotacija; '});
setappdata(handles.figure1,'anotRod',0);
RRI_perziuros_anotacija('slepti');
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function anotacijos_OnCallback(hObject, eventdata, handles)
% hObject    handle to anotacijos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.axes_rri,'MouseInMainAxesFnc', {'eval' ...
    'set(hFig,''Pointer'',''arrow''); RRI_perziuros_anotacija; '});
setappdata(handles.figure1,'anotRod',1);
anotacijos_atnaujinimas(hObject, eventdata, handles);
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function Nejungti_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Nejungti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.checkbox_rri,'Value',~get(handles.checkbox_rri,'Value'));
checkbox_rri_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function aktyvusis_OffCallback(hObject, eventdata, handles)
% hObject    handle to aktyvusis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.anotacijos,'Enable','off');
RRI_perziuros_anotacija('slepti');
setappdata(handles.axes_rri,'MouseInMainAxesFnc',{'eval',...
    'set(findobj(hFig,''Tag'',''toggle_brush''),''state'',''off''); '});
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function aktyvusis_OnCallback(hObject, eventdata, handles)
% hObject    handle to aktyvusis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.anotacijos,'Enable','on');
setappdata(handles.axes_rri,'MouseInMainAxesFnc', {'eval' ...
    'set(hFig,''Pointer'',''arrow''); RRI_perziuros_anotacija; '});
anotacijos_atnaujinimas(hObject, eventdata, handles);
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function ekg_rodyti_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to ekg_rodyti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.checkbox_ekg,'Value',~get(handles.checkbox_ekg,'Value'));
checkbox_ekg_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function istorija_atgal_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to istorija_atgal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
istorijosNr=getappdata(handles.figure1,'istorijosNr');
if isempty(istorijosNr); istorijosNr=0; end;
if istorijosNr < 2; return; end;
istorijosNr=max(istorijosNr-1,1);
setappdata(handles.figure1,'istorijosNr',istorijosNr);
istorija_vykdoma(hObject, eventdata, handles);
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function istorija_tolyn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to istorija_tolyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
istorijos_busena(hObject, eventdata, handles);
istorijosNr=getappdata(handles.figure1,'istorijosNr');
if isempty(istorijosNr); istorijosNr=0; end;
if istorijosNr >= length(getappdata(handles.figure1,'istorija')); return; end;
istorijosNr=min(istorijosNr+1,length(getappdata(handles.figure1,'istorija')));
setappdata(handles.figure1,'istorijosNr',istorijosNr);
istorija_vykdoma(hObject, eventdata, handles);
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);


function istorijos_busena(hObject, eventdata, handles)
istorijosNr=[];
try istorijosNr=getappdata(handles.figure1,'istorijosNr'); catch; end;
if isempty(istorijosNr); istorijosNr=0; end;
set(findobj(handles.figure1,'Tag','istorija_atgal'),'Enable',...
    fastif(istorijosNr > 1,'on','off'));
set(findobj(handles.figure1,'Tag','istorija_tolyn'),'Enable',...
    fastif(istorijosNr ~= 0 && ...
    istorijosNr < length(getappdata(handles.figure1,'istorija')), ...
    'on','off'));
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);
drawnow;


function istorija_vykdoma(hObject, eventdata, handles)
istorijos_busena(hObject, eventdata, handles);
istorija   =getappdata(handles.figure1,'istorija');
istorijosNr=getappdata(handles.figure1,'istorijosNr');
if get(handles.checkbox_ekg,'Value');
    h=[handles.RRI_lin handles.RRI_tsk handles.EKG_tsk];
else
    h=[handles.RRI_lin handles.RRI_tsk ];
end;
set(h,'XData',istorija(istorijosNr).Laikai);
set(h,'YData',istorija(istorijosNr).RRI);
set(handles.checkbox_rri,'Value',istorija(istorijosNr).Nejungti);
handles.t=0;
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
istorijos_busena(hObject, eventdata, handles);
refreshdata(handles.figure1,'caller');
guidata(handles.figure1, handles);


function paseno=istorijos_tikrinimas2(istorija, istorijosNr, RRI, Laikai, Nejungti)
if istorijosNr > length(istorija);
    paseno=1; return;
end;
RRI(find(isnan(RRI)))=Inf;
if istorijosNr;
    RRI0   = istorija(istorijosNr).RRI;
    Laikai0= istorija(istorijosNr).Laikai;
elseif (isequal(RRI, [0; Inf; Inf; 0]) && isequal(Laikai,[0; 10; 20; 30])) || ...
       (isequal(RRI, [0; Inf;   1000]) && isequal(Laikai,[0; 1;      30])) || ...
       (isequal(RRI, [0;       30000]) && isequal(Laikai,[0;         30]));
    paseno=0; return;
elseif Nejungti;
    RRI0=[0; NaN; 1000]; Laikai0=[0; 1; 30];
else
    RRI0=[0; 30000]; Laikai0=[0; 30];
end;
if ~isequal(Laikai0,Laikai) || ...
        ~isequal(find( isnan(RRI0)),find( isnan(RRI))) || ...
        ~isequal(find(~isnan(RRI0)),find(~isnan(RRI))) || ...
        ~isequal(RRI0(~isnan(RRI0)), RRI(~isnan(RRI)));
    paseno=1;
else
    paseno=0;
end;


function istorijos_tikrinimas(hObject, eventdata, handles, RRI, Laikai)
istorija   =getappdata(handles.figure1,'istorija');
istorijosNr=getappdata(handles.figure1,'istorijosNr');
Nejungti=get(handles.checkbox_rri,'Value');
if istorijos_tikrinimas2(istorija, istorijosNr, RRI, Laikai, Nejungti);
    istorijosNr=istorijosNr+1;    
    if istorijos_tikrinimas2(istorija, istorijosNr, RRI, Laikai, Nejungti);
        istorija(istorijosNr).RRI=RRI; 
        istorija(istorijosNr).Laikai=Laikai; 
        istorija(istorijosNr).Nejungti=get(handles.checkbox_rri,'Value');
        istorija=istorija(1:istorijosNr);
    end;
end;
setappdata(handles.figure1,'istorija',istorija);
setappdata(handles.figure1,'istorijosNr',istorijosNr);


% --------------------------------------------------------------------
function Artinti2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Artinti2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Artinti2,'state','on');
set(handles.toggle_brush,'state','off');
set(handles.figure1,'Pointer','cross');
k=waitforbuttonpress; rect_pos = rbbox;
if  ~ismember(num2str(k),{'escape'}) && (rect_pos(3)*rect_pos(4))>0 ;
    axes_pos=get(handles.axes_rri,'position');
    axes_xlm=get(handles.axes_rri,'xlim'); axes_xpl=axes_xlm(2)-axes_xlm(1);
    axes_ylm=get(handles.axes_rri,'ylim'); axes_ypl=axes_ylm(2)-axes_ylm(1);
    skirtums=rect_pos - axes_pos;
    x1=axes_xlm(1) + axes_xpl*skirtums(1)/axes_pos(3); x2=x1+axes_xpl*rect_pos(3)/axes_pos(3);
    y1=axes_ylm(1) + axes_ypl*skirtums(2)/axes_pos(4); y2=y1+axes_ypl*rect_pos(4)/axes_pos(4);
    lim_njx=[min(x1,x2) max(x1,x2)];
    lim_njy=[min(y1,y2) max(y1,y2)];
    set(handles.axes_rri, 'XLim', lim_njx);
    set(handles.axes_rri, 'YLim', lim_njy);
end;
set(handles.Artinti2,'state','off');
set(handles.toggle_brush,'state','off');
set(handles.figure1,'Pointer','arrow');
            

% --------------------------------------------------------------------
function toggle_brush_OffCallback(hObject, eventdata, handles)
% hObject    handle to toggle_brush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.aktyvusis,'Enable','on');
if strcmp(get(handles.aktyvusis,'state'),'off') || strcmp(get(handles.aktyvusis,'Enable'),'off');
    set(handles.anotacijos,'Enable','off');
else
    set(handles.anotacijos,'Enable','on');
end;
brush(handles.figure1,'off');


function apie
msg=sprintf([...
    'Elektrokardiogramos ir R-R intervalų peržiūros ir taisymo programėlė\n\n' ...
    'Skirta QRS aptikimui EKG įraše, pasiruošimui tolesnei širdies ritmo kintamumo (variabilumo) analizei (pvz., su KubiosHRV).\n' ...
    'Platinama kaip EEGLAB papildinio „Darbeliai“ dalis.\n\n(c) 2014-2015 Mindaugas Baranauskas']);
msgbox(msg);


% --------------------------------------------------------------------
function eiti_i_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to eiti_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xvid=mean(get(handles.axes_rri,'XLim'));
a=inputdlg('Šokti į laiką (sekundėmis):',mfilename,1,{num2str(xvid)});
if ~isempty(a);
    if ~isempty(a{1});
        t=str2num(a{1});
        optimalus_rodymasx(hObject, eventdata, handles, t, 0);
    end;
end;


% --------------------------------------------------------------------
function eiti_pazym_atgal_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to eiti_pazym_atgal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
xvid=mean(get(handles.axes_rri,'XLim'));
Laikai=get(handles.RRI_tsk,'XData');
if get(handles.checkbox_ekg,'Value');
    h=[handles.RRI_lin handles.RRI_tsk handles.EKG_tsk];
else
    h=[handles.RRI_lin handles.RRI_tsk ];
end;
bd=get(h,'BrushData');
%assignin('base','bd',bd);
bd=sum(cell2mat(bd),1);
Laikai=Laikai(find(bd));
t=max(Laikai(find(Laikai < (xvid-0.001))));
optimalus_rodymasx(hObject, eventdata, handles, t, 0);


% --------------------------------------------------------------------
function eiti_pazym_tolyn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to eiti_pazym_tolyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
xvid=mean(get(handles.axes_rri,'XLim'));
Laikai=get(handles.RRI_tsk,'XData');
if get(handles.checkbox_ekg,'Value');
    h=[handles.RRI_lin handles.RRI_tsk handles.EKG_tsk];
else
    h=[handles.RRI_lin handles.RRI_tsk ];
end;
bd=get(h,'BrushData');
%assignin('base','bd',bd);
bd=sum(cell2mat(bd),1);
Laikai=Laikai(find(bd));
t=min(Laikai(find(Laikai > (xvid+0.001))));
optimalus_rodymasx(hObject, eventdata, handles, t, 0);
