%
% Atnaujinti
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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% (C) 2014 Mindaugas Baranauskas
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

function varargout = pop_atnaujinimas(varargin)
% POP_ATNAUJINIMAS MATLAB code for pop_atnaujinimas.fig
%      POP_ATNAUJINIMAS, by itself, creates a new POP_ATNAUJINIMAS or raises the existing
%      singleton*.
%
%      H = POP_ATNAUJINIMAS returns the handle to a new POP_ATNAUJINIMAS or the handle to
%      the existing singleton*.
%
%      POP_ATNAUJINIMAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_ATNAUJINIMAS.M with the given input arguments.
%
%      POP_ATNAUJINIMAS('Property','Value',...) creates a new POP_ATNAUJINIMAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_atnaujinimas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_atnaujinimas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_atnaujinimas

% Last Modified by GUIDE v2.5 28-Aug-2014 14:51:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_atnaujinimas_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_atnaujinimas_OutputFcn, ...
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


% --- Executes just before pop_atnaujinimas is made visible.
function pop_atnaujinimas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_atnaujinimas (see VARARGIN)

set(handles.pushbutton1,'String',lokaliz('Update'));
set(handles.pushbutton2,'String',lokaliz('Close'));

Tekstas=[{' '}];
sena_versija='';
nauja_versija='';
apie_vers='';
curdir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
if strcmp(curdir(end),filesep);
   curdir=curdir(1:end-1);
end ;
curdir_sep=find(ismember(curdir,filesep));
curdir_parrent=curdir(1:curdir_sep(end));
curdir=[curdir filesep];
config_file='Darbeliai_config.mat';
Darbeliai_nuostatos.url_atnaujinimui='https://github.com/embar-/eeglab_darbeliai/archive/stable.zip';
Darbeliai_nuostatos.url_versijai='https://raw.githubusercontent.com/embar-/eeglab_darbeliai/stable/Darbeliai.versija';
Darbeliai_nuostatos.stabili_versija=0;

% Unix - UTF-8
V= version('-release') ;
% For MATLAB R2010b or later:
if or(strcmp(V,'2010b'), str2num(V(1:end-1)) > 2010 ) ;
    ret = feature('locale');
    encoding = ret.encoding;
    % For MATLAB R2008a through R2010a:
elseif str2num(V(1:end-1)) >= 2008 ;
    ret = feature('locale');
    [~,r] = strtok(ret.ctype,'.');
    encoding = r(2:end);
else
    encoding = '';
end;


try
   load(fullfile(curdir_parrent,config_file));
   Darbeliai_nuostatos.url_atnaujinimui=Darbeliai.nuostatos.url_atnaujinimui;
   Darbeliai_nuostatos.url_versijai    =Darbeliai.nuostatos.url_versijai;
   Darbeliai_nuostatos.stabili_versija =Darbeliai.nuostatos.stabili_versija;
catch %err; disp(err.message);
end;
setappdata(handles.figure1,'url_atnaujinimui',Darbeliai_nuostatos.url_atnaujinimui);

if length(varargin) > 1 ;
    sena_versija=varargin{2};
   if length(varargin) > 3;
       apie_vers=varargin{4};
   end;
else
    try
        fid_vers=fopen(fullfile(Tikras_Kelias(fullfile(curdir,'..')),'Darbeliai.versija'));
        sena_versija=regexprep(regexprep(fgets(fid_vers),'[ ]*\n',''),'[ ]*\r','');
        fclose(fid_vers);
    catch err;
        disp(err.message);
    end;
end ;
if ~isempty(sena_versija)
    Tekstas=[ Tekstas ; lokaliz('Naudojate') ; sena_versija ; {' '} ];
end;

if length(varargin) > 2 ;
   nauja_versija=varargin{3};
else
   %url='https://www.dropbox.com/s/q57pntndm704isv/Darbeliai.versija?dl=1';
   %url='https://raw.githubusercontent.com/embar-/eeglab_darbeliai/master/Darbeliai.versija';
   %url='https://raw.githubusercontent.com/embar-/eeglab_darbeliai/stable/Darbeliai.versija';
   status=0;
   disp(lokaliz('Checking for updates...'));
   try
   [filestr,status] = urlwrite(Darbeliai_nuostatos.url_versijai,fullfile(tempdir,'Darbeliai_versija1.txt'));
   catch
   end;
   if status
       convert_file_encoding(filestr, [filestr '~'], 'UTF-8', encoding );
       fid_nvers=fopen([filestr '~']);
	   nauja_versija=regexprep(regexprep(fgets(fid_nvers),'[ ]*\n',''),'[ ]*\r','');
       %disp(size(nauja_versija));
       apie_vers_='';
       while ischar(apie_vers_);
           apie_vers=[apie_vers apie_vers_];
           apie_vers_ = fgets(fid_nvers);
       end;
       fclose(fid_nvers);
       try delete(filestr); catch; end;
       try delete([filestr '~']); catch; end;
   end;
end ;
if isempty(nauja_versija);
    Tekstas=[ Tekstas ; lokaliz('Can not check for updates.') ; lokaliz('Check internet connection.') ];
    set(handles.pushbutton1,'Visible','off');
    set(handles.pushbutton2,'BackgroundColor',[0.7 0.7 1]);
    set(handles.pushbutton2,'FontWeight','bold');
else
    
    % Jei sutampa rasta versija su paskiausia per GIT išleista versija, naudoti pastarąją
    try git_latest=github_darbeliu_versijos(1);
        [filestr,status] = urlwrite(git_latest.url_versijai,fullfile(tempdir,'Darbeliai_versija2.txt'));
        if status;
            convert_file_encoding(filestr, [filestr '~'], 'UTF-8', encoding );
            fid_nvers=fopen([filestr '~']);
            nauja_versija2=regexprep(regexprep(fgets(fid_nvers),'[ ]*\n',''),'[ ]*\r','');
            fclose(fid_nvers);
            try delete(filestr); catch; end;
            try delete([filestr '~']); catch; end;
            if strcmp(nauja_versija,nauja_versija2) ...
                    && isequal(Darbeliai_nuostatos.stabili_versija,git_latest.stabili_versija);
                setappdata(handles.figure1,'url_atnaujinimui',git_latest.url_atnaujinimui);
                %apie_vers=git_latest.komentaras;
            end;
        end;
    catch
    end;
    
    if strcmp(sena_versija,nauja_versija)
        Tekstas=[ Tekstas ; [lokaliz('You use latest version.') ' ' lokaliz('Update anyway?') ]];
        set(handles.pushbutton1,'BackgroundColor','remove');
        set(handles.pushbutton1,'FontWeight','normal');
        set(handles.pushbutton1,'Visible','on');
        set(handles.pushbutton2,'BackgroundColor',[0.7 0.7 1]);
        set(handles.pushbutton2,'FontWeight','bold');
    else
        Tekstas=[ Tekstas ; lokaliz('Rasta nauja versija') ': ' ; nauja_versija ; {' '} ; apie_vers ];
        Tekstas=[ Tekstas ; ' ' ; lokaliz('Ar norite pabandyti atnaujinti?') ];
        set(handles.pushbutton2,'BackgroundColor','remove');
        set(handles.pushbutton2,'FontWeight','normal');
        set(handles.pushbutton1,'Visible','on');
        set(handles.pushbutton1,'BackgroundColor',[0.7 0.7 1]);
        set(handles.pushbutton1,'FontWeight','bold');
    end;
    
end;

set(handles.text1,'String',Tekstas);
Tekstas2=sprintf('%s\n',Tekstas{:});
Tekstas2=textscan(Tekstas2,'%s','delimiter','\n');
aukstis=1.5*size(Tekstas2{1},1);
plotis=1.3*max(arrayfun(@(ti) size(Tekstas2{1}{ti},2), 1:length(Tekstas2{1})));
wind_position=get(handles.figure1,'Position');
set(handles.figure1,'Position',[ ...
    wind_position(1) ...
    wind_position(2)-aukstis ...
    max(wind_position(3),plotis) ...
    3+aukstis]);

% Choose default command line output for pop_atnaujinimas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_atnaujinimas wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pop_atnaujinimas_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tekstas=[get(handles.text1,'String')];
Tekstas=[ Tekstas(1:end-1) ; [lokaliz('Palaukite!') ' ' lokaliz('Atnaujinima...')] ];
set(handles.text1,'String',[Tekstas]);
set(handles.pushbutton1,'Enable','off');
set(handles.pushbutton2,'Enable','off');
drawnow;
%koduote=feature('DefaultCharacterSet');
%feature('DefaultCharacterSet','UTF-8');

try
    atnaujinimas(getappdata(handles.figure1,'url_atnaujinimui'));
    %pause(5);
catch err;
   disp(err.message);
end;
%feature('DefaultCharacterSet',koduote);
close(mfilename);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(mfilename);

function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'return'));
        pushbutton1_Callback(hObject, eventdata, handles);
    end;
