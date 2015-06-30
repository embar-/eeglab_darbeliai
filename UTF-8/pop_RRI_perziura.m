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

% Last Modified by GUIDE v2.5 07-Dec-2014 16:31:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
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

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
warning('on','MATLAB:modes:mode:InvalidPropertySet');
warning('on','MATLAB:uitools:uimode:callbackerror');

Pradiniai_laikai=[];
if nargin > 3 ; Pradiniai_laikai=varargin{1};
end;
if nargin > 4 ; handles.veiksena=varargin{2};
else handles.veiksena=1;
end;
if nargin > 6 ;
    handles.EKG=varargin{3};
    handles.EKG_laikai=varargin{4};
    if mean(diff(handles.EKG_laikai(:))) >= 100;
        handles.EKG_laikai=handles.EKG_laikai*0.001;
    end;
else
    handles.EKG=[];
    handles.EKG_laikai=[];
end;

if ~isnumeric(Pradiniai_laikai);
    Pradiniai_laikai=[];
end;
if size(Pradiniai_laikai,2) > 1; Pradiniai_laikai=Pradiniai_laikai' ; end;
if mean(diff(Pradiniai_laikai(:))) < 100;
    Pradiniai_laikai=Pradiniai_laikai*1000;
end;

set(handles.axes_rri,'UserData',Pradiniai_laikai);
handles.axes_rri_padetis=get(handles.axes_rri,'Position');
handles.pradines_fig=findobj(handles.figure1);

disp(' ');
disp('===================================');
disp('      R R I   P E R Ž I Ū R A      ');
disp(' ');


% Grafikai
handles=pirmieji_grafikai(hObject, eventdata, handles);

% Įtartinų taškų žymėjimas
edit_ribos_Callback(hObject, eventdata, handles);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_RRI_perziura wait for user response (see UIRESUME)
uiwait(handles.figure1);


function handles=pirmieji_grafikai(hObject, eventdata, handles)
%Paruošimas
handles.Laikai=[];
handles.RRI=[];
Pradiniai_laikai=get(handles.axes_rri,'UserData');

if length(Pradiniai_laikai)>1;
    handles.Laikai=0.001*[Pradiniai_laikai(1) ; ( Pradiniai_laikai(1)*2 + Pradiniai_laikai(2))/3 ; Pradiniai_laikai(2:end)];
    handles.RRI=[0 ; NaN ; diff(Pradiniai_laikai)] ;
elseif isempty(Pradiniai_laikai);
    handles.Laikai=1;
    handles.RRI=[ NaN];
else
    handles.Laikai=Pradiniai_laikai;
    handles.RRI=[0];
end

%Grafikai
axes(handles.axes_rri);
cla;
hold on;


% EKG grafikas
if and(~isempty(handles.EKG),...
        length(handles.EKG_laikai)== length(handles.EKG) );
    set(handles.checkbox_ekg,'Value',1);
    set(handles.checkbox_ekg,'Visible','on');
    %hold off;
    % EKGposlinkis Y ašyje
    EKGposlinkis=min(handles.RRI(find(handles.RRI(:)>0)));
    if isempty(EKGposlinkis); EKGposlinkis=0; end;
    handles.EKG_=mat2gray(handles.EKG)*100-125+EKGposlinkis;
    handles.EKG_lin=plot(handles.EKG_laikai,handles.EKG_,'color','r');
    %handles.EKG_lin=get(handles.axes_rri,'Children');
    %try
    handles.EKG_R=0.1^20*(handles.RRI)-25+EKGposlinkis;
    handles.EKG_tsk=plot(handles.Laikai,handles.EKG_R,'o','color','g');
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
    set(handles.checkbox_ekg,'Visible','off');
    handles.EKG_lin=[];
    handles.EKG_tsk=[];

end;

% RRI grafikas
handles.RRI_lin=plot(handles.Laikai,handles.RRI,'color','b');
% linijos=get(handles.axes_rri,'Children');
% handles.RRI_lin=linijos(find(~ismember(linijos,[handles.EKG_lin handles.EKG_tsk])));
handles.RRI_tsk=plot(handles.Laikai,handles.RRI,'o','color','k');
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
    %error(' ');
    if get(handles.checkbox_ekg,'Value'); xlangas=30 ; else xlangas=300 ; end;
    handles.scrollHandles = scrollplot2('Axis','XY','MinX',0,...
        'WindowSizeX',min(xlangas,max(handles.Laikai))  ,...
        'MaxY', min(1500,30+max(handles.RRI))  , ...
        'WindowSizeY', max(300,...
            min(1500,50+max(handles.RRI)) - ...
            max(0,min(handles.RRI(find(handles.RRI > 0)))-80) )) ;
    ax=get(handles.scrollHandles,'ParentAxesHandle');
    scrl=get(handles.scrollHandles,'ScrollPatchHandle');
catch err;
    warning(err.message);
    %old_unit=get(handles.pushbutton_atstatyti, 'Units');
    %set(hFig, 'Units','pixels');
    p1=get(handles.pushbutton_atstatyti,'Position');
    p2=get(handles.axes_rri,'Position');
    set(handles.axes_rri,'Position',[p2(1) p1(2)+p1(4)+2 p2(3) p2(2)+p2(4)-(p1(2)+p1(4)+2)]);
end;

refreshdata(handles.figure1,'caller');
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = pop_RRI_perziura_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%uiwait;
%guidata(hObject, handles);
% Get default command line output from handles structure
try
    varargout{1} = handles.output;
catch
    varargout{1} = [] ;
end;

% The figure can be deleted now
try delete(handles.figure1); catch; end;
%close(mfilename);

% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%guidata(hObject, handles);
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
guidata(hObject, handles);
uiresume;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(lokaliz('User closes window...'));
button = questdlg(lokaliz('Return QRS times?'),lokaliz('Closing'),lokaliz('Yes'),lokaliz('No'),lokaliz('Cancel'),lokaliz('Yes'));
switch button
    case lokaliz('No')
        delete(hObject);
    case lokaliz('Yes')
        pushbutton_OK_Callback(hObject, eventdata, handles);
    otherwise
        disp(lokaliz('Canceled'));
end;


function edit_ribos_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ribos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ribos as text
%        str2double(get(hObject,'String')) returns contents of edit_ribos as a double
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);

RRI_=get([handles.RRI_lin handles.RRI_tsk],'YData');
if iscell(RRI_); RRI=RRI_{1};
else RRI=RRI_;
end;

% Taškų žymėjimas
b0=brush(handles.figure1);
brush(handles.figure1,'on');
guidata(hObject, handles);
%set(b0, 'ActionPreCallback', @(hObject,eventdata)pushbutton_atnaujinti_Callback(hObject,eventdata,handles), 'enable', 'on' );
%set(b0, 'ActionPreCallback', @(hObject,eventdata)atnaujinimas(hObject,eventdata,handles), 'enable', 'on' );
%set(b0, 'ActionPreCallback', 'set(handles.pushbutton_atnaujinti,''BackgroundColor'',[1 1 0])');
%set(b0, 'ActionPostCallback', @(handles)set(handles.pushbutton_atnaujinti,'BackgroundColor','remove'));
%set(b0, 'enable', 'on' );
%set(b0, 'ActionPreCallback', @(gcf,eventdata)pop_RRI_perziura('pushbutton_atnaujinti_Callback',gcf,eventdata,guidata(gcf)), 'enable', 'on' );
%set(b0, 'ActionPostCallback', @(hObject,eventdata)pop_RRI_perziura('pushbutton_atnaujinti_Callback',hObject,eventdata,guidata(hObject)), 'enable', 'on' );
%set(b0, 'ActionPostCallback', , 'enable', 'on' );
%     function atnaujinimas(hObject,eventdata,handles)
%         %@(hObject,eventdata)pushbutton_atnaujinti_Callback(hObject,eventdata,handles);
%         pushbutton_atnaujinti_Callback(hObject,eventdata,handles);
%         guidata(hObject, handles);
%     end
guidata(hObject, handles);
ribos=str2num(get(handles.edit_ribos,'String'));
try
    hB = findobj(handles.figure1,'-property','BrushData');
    set(hB,'BrushData', [RRI<ribos(1)] - [RRI==0] );
    set(hB,'BrushData', ([RRI<ribos(1)] - [RRI==0] + [RRI>ribos(2)]) );
catch err;
end;
set(handles.figure1,'ButtonDownFcn', 'brush off');
axes(handles.axes_rri);
guidata(hObject, handles);

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
Pradiniai_laikai=get(handles.axes_rri,'UserData');
handles.Laikai=0.001*Pradiniai_laikai;
handles.RRI=[0 ; diff(Pradiniai_laikai)] ;
set([handles.RRI_lin handles.RRI_tsk handles.EKG_tsk],'XData',handles.Laikai);
set([handles.RRI_lin handles.RRI_tsk handles.EKG_tsk],'YData',handles.RRI);
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
edit_ribos_Callback(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_atnaujinti.
function pushbutton_atnaujinti_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_atnaujinti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Kai žmogus ranka ištrina taškus, gali būti,
% kad linijinis ir taškinis grafikas truputį skirsis

%linijos=get(handles.axes_rri,'Children');
%rri_lin=linijos(find(ismember(linijos,[handles.RRI_lin handles.RRI_tsk])));

susaldyk(hObject, eventdata, handles);
guidata(hObject,handles);
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
    RRI__=[];
    for i=1:length(Laikai__);
        ri1=find(Laikai_{1}==Laikai__(i));
        ri2=find(Laikai_{2}==Laikai__(i));
        ri3=find(Laikai_{3}==Laikai__(i));
        if isempty(ri1); r1=NaN; else r1=RRI1(ri1); end;
        if isempty(ri2); r2=NaN; else r2=RRI2(ri2); end;
        if isempty(ri3); r3=NaN; else r3=RRI3(ri3); end;
        r=(r1+r2+r3)/3; % NaN + 1 = NaN
        try
        RRI__(i,1)=r;
        catch err;
            r
            Pranesk_apie_klaida(err);
            pause(5);
            uiresume;
            rethrow(err);
        end;
    end;

else
    RRI__=RRI_;
end;

if length(RRI__)>1;

    idx=find(~isnan(RRI__));
    %Laikai3=Laikai__([1 ; idx]);
    Laikai3=Laikai__(idx);
    RRI___=[0 ; 1000 * diff(Laikai3)];

    %if handles.veiksena ;
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

set(rri_lin,'XData',Laikai');
set(rri_lin,'YData',RRI');
set(handles.EKG_lin,'XData',handles.EKG_laikai);
if and(~isempty(handles.EKG),get(handles.checkbox_ekg,'Value'));
    EKGposlinkis=min(RRI(find(RRI(:)>0)));
    if isempty(EKGposlinkis); EKGposlinkis=0; end;
    handles.EKG_=mat2gray(handles.EKG)*100-125+EKGposlinkis;
    set(handles.EKG_lin,'YData',handles.EKG_);
    try
        %brush(handles.figure1,'on');
        set(handles.EKG_lin,'BrushData',0);
    catch err;
        Pranesk_apie_klaida(err,'','',0);
        %warning(err.message);
    end;

    handles.EKG_R=0.1^20*(RRI')-25+EKGposlinkis;
    set(handles.EKG_tsk,'XData',Laikai');
    set(handles.EKG_tsk,'YData',handles.EKG_R);

else
    set(handles.EKG_lin,'XData',[0]);
    set(handles.EKG_lin,'YData',[NaN]);
    set(handles.EKG_tsk,'XData',[0]);
    set(handles.EKG_tsk,'YData',[NaN]);
end;
%edit_ribos_Callback(hObject, eventdata, handles);
b0=brush(handles.figure1);
%set(b0, 'ActionPreCallback', 'disp(0)', 'enable', 'on' );
%set(b0, 'ActionPostCallback', @(hObject,eventdata)pushbutton_atnaujinti_Callback(hObject,eventdata,handles), 'enable', 'on' );

susildyk(hObject, eventdata, handles);
guidata(hObject, handles);
refreshdata(handles.figure1,'caller');
guidata(hObject, handles);
assignin('base','handles',handles);

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

ck=get(hObject,'CurrentKey');
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
    case 'downarrow'
        %disp('v');
        lim_dbr=get(handles.axes_rri,'YLim');
        lim_max=get(handles.scrollHandles(2),'YLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=max(lim_dbr(1) - lim_plt * 0.2, lim_max(1) - lim_plt * 0.2);
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'YLim',lim_nj);
    case 'leftarrow'
        %disp('<');
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=max(lim_dbr(1) - lim_plt * 0.2, lim_max(1) - lim_plt * 0.2);
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
    case 'rightarrow'
        %disp('>');
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=min(lim_dbr(2) + lim_plt * 0.2, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
    case 'pageup'
        %disp('<');
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=max(lim_dbr(1) - lim_plt * 1.0, lim_max(1) - lim_plt * 0.2);
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
    case 'pagedown'
        %disp('>');
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=min(lim_dbr(2) + lim_plt * 1.0, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
    case 'home'
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=lim_max(1) - lim_plt * 0.2;
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
    case 'end'
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=lim_max(2) + lim_plt * 0.2;
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
    case {'subtract','hyphen'}
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=max(lim_dbr(1) - lim_plt * 0.125, lim_max(1) - lim_plt * 0.2);
        lim_nj2=min(lim_dbr(2) + lim_plt * 0.125, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,'XLim',lim_nj);
    case 'add'
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=lim_dbr(1) + lim_plt * 0.1;
        lim_nj2=lim_dbr(2) - lim_plt * 0.1;
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,'XLim',lim_nj);
    otherwise
        %disp(ck);
end;
catch err;
end;
guidata(hObject, handles);

function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
modifiers = get(gcf,'currentModifier');
try
if ismember('control',modifiers);
    if eventdata.VerticalScrollCount > 0;
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=lim_dbr(1) + lim_plt * 0.1;
        lim_nj2=lim_dbr(2) - lim_plt * 0.1;
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,'XLim',lim_nj);
    else
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj1=max(lim_dbr(1) - lim_plt * 0.125, lim_max(1) - lim_plt * 0.2);
        lim_nj2=min(lim_dbr(2) + lim_plt * 0.125, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj1 lim_nj2];
        set(handles.axes_rri,'XLim',lim_nj);
    end;
else
    if eventdata.VerticalScrollCount > 0
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=min(lim_dbr(2) + lim_plt * 0.2, lim_max(2) + lim_plt * 0.2);
        lim_nj=[lim_nj - lim_plt lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
    else
        lim_dbr=get(handles.axes_rri,'XLim');
        lim_max=get(handles.scrollHandles(1),'XLim');
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        lim_nj=max(lim_dbr(1) - lim_plt * 0.2, lim_max(1) - lim_plt * 0.2);
        lim_nj=[lim_nj lim_plt + lim_nj];
        set(handles.axes_rri,'XLim',lim_nj);
    end;
end;
catch err;
end;
guidata(hObject, handles);

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
                for i=find(duom==1);
                    RRI(1,i)=NaN;
                end;
                set(objektai(y),'YData',RRI');
            catch
            end;
        end;

        pushbutton_atnaujinti_Callback(hObject, eventdata, handles);


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

% --- Executes on button press in checkbox_ekg.
function checkbox_ekg_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ekg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ekg
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes on button press in checkbox_rri.
function checkbox_rri_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rri
pushbutton_atnaujinti_Callback(hObject, eventdata, handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Importuoti_laikus_Callback(hObject, eventdata, handles)
% hObject    handle to Importuoti_laikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
[f,p]=uigetfile({'*.txt'; '*.*' ;});
susildyk(hObject, eventdata, handles);
drawnow;
if or(isempty(f),f==0) ; return ; end;
SeniLaikai=get(handles.axes_rri,'UserData');
try
    Laikai=dlmread(fullfile(p,f));
    if mean(diff(Laikai(:))) < 100;
        Laikai=Laikai*1000;
    end;
    set(handles.axes_rri,'UserData',Laikai);
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
catch err;
    warning(err.message);
    w=warndlg(err.message);
    uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
end;
susildyk(hObject, eventdata, handles);
drawnow;


% --------------------------------------------------------------------
function Importuoti_RRI_Callback(hObject, eventdata, handles)
% hObject    handle to Importuoti_laikus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
[f,p]=uigetfile({'*.dat'; '*.txt'; '*.*' ;});
susildyk(hObject, eventdata, handles);
drawnow;
if or(isempty(f),f==0) ; return ; end;
SeniLaikai=get(handles.axes_rri,'UserData');
Senas_EKG=handles.EKG;
Senas_EKG_=handles.EKG_laikai;
try
    Laikai=dlmread(fullfile(p,f));
    if mean(Laikai(:)) < 100;
        Laikai=Laikai*1000;
    end;
    Laikai=[0 cumsum(Laikai)];
    set(handles.axes_rri,'UserData',Laikai);
    handles.EKG=[];
    handles.EKG_laikai=[];
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
catch err;
    warning(err.message);
    w=warndlg(err.message);
    uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    handles.EKG=Senas_EKG;
    handles.EKG_laikai=Senas_EKG_;
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
end;
susildyk(hObject, eventdata, handles);
drawnow;


% --------------------------------------------------------------------
function Eksportuoti_laikus_Callback(hObject, eventdata, handles)
% hObject    handle to Eksportuoti_laikus (see GCBO)
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

idx=find(~isnan(RRI));
%idx=[1 idx];
Laikai=Laikai(idx);
handles.output=1000*Laikai';
if iscell(Laikai_);  Laikai=Laikai_{1};
else Laikai=Laikai_;
end;
RRI_=get([handles.RRI_lin handles.RRI_tsk],'YData');
if iscell(RRI_); RRI=RRI_{1};
else RRI=RRI_;
end;
idx=find(~isnan(RRI));
Laikai=Laikai(idx);
R_laikai=1000*Laikai';
guidata(hObject, handles);
if isempty(R_laikai);
    w=warndlg('Nebus ko eksportuoti!');
    uiwait(w);
    susildyk(hObject, eventdata, handles);
else
    [f,p]=uiputfile({'*.txt'; '*.*' ;});Laikai_=get([handles.RRI_lin handles.RRI_tsk],'XData');
    susildyk(hObject, eventdata, handles);
    if or(isempty(f),f==0) ; return ; end;
    try
    dlmwrite(fullfile(p,f), ...
        num2cell(R_laikai),...
        'precision','%.3f',...
        'newline', 'pc') ;
    catch err;
        warning(err.message);
        w=warndlg(err.message);
        uiwait(w);
    end;
end;


% --------------------------------------------------------------------
function Eksportuoti_RRI_Callback(hObject, eventdata, handles)
% hObject    handle to Eksportuoti_laikus (see GCBO)
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

idx=find(~isnan(RRI));
%idx=[1 idx];
Laikai=Laikai(idx);
handles.output=1000*Laikai';
if iscell(Laikai_);  Laikai=Laikai_{1};
else Laikai=Laikai_;
end;
RRI_=get([handles.RRI_lin handles.RRI_tsk],'YData');
if iscell(RRI_); RRI=RRI_{1};
else RRI=RRI_;
end;
idx=find(~isnan(RRI));
Laikai=Laikai(idx);
R_laikai=1000*Laikai';
%R_laikai=Laikai';
RRI=diff(R_laikai);
guidata(hObject, handles);
if isempty(R_laikai);
    w=warndlg('Nebus ko eksportuoti!');
    uiwait(w);
    susildyk(hObject, eventdata, handles);
else
    [f,p]=uiputfile({'*.dat'; '*.*' ;});
    susildyk(hObject, eventdata, handles);
    if or(isempty(f),f==0) ; return ; end;
    try
    dlmwrite(fullfile(p,f), ...
        num2cell(RRI),...
        'precision','%.0f',...
        'newline', 'pc') ;
    catch err;
        warning(err.message);
        w=warndlg(err.message);
        uiwait(w);
    end;
end;

function susaldyk(hObject, eventdata, handles)
v=findall(handles.figure1);
for i=1:length(v);
    try
        set(v(i),'Enable','off');
    catch
    end;
end;
guidata(hObject, handles);
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
    set(handles.Aptikti_EKG_QRS,'Enable','off');
    %set(handles.Eksportuoti_laikus,'Enable','off');
end;

if isempty(get(handles.axes_rri,'UserData'));
    set(handles.Eksportuoti,'Enable','off');
end;

figure(handles.figure1);
guidata(hObject, handles);
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

guidata(hObject, handles);

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
function Importuoti_Callback(hObject, eventdata, handles)
% hObject    handle to Importuoti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Eksportuoti_Callback(hObject, eventdata, handles)
% hObject    handle to Eksportuoti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Importuoti_LabChartMAT_Callback(hObject, eventdata, handles)
% hObject    handle to Importuoti_BiopacACQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
[f,p]=uigetfile({'*.mat'; '*.*' ;});
susildyk(hObject, eventdata, handles);
drawnow;
if or(isempty(f),f==0) ; return ; end;
SeniLaikai=get(handles.axes_rri,'UserData');
try
    Labchart_data=load(fullfile(p,f),'-mat');
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
        handles.EKG_laikai=[...
            ([Labchart_data.datastart(KanaloNr,blokas):Labchart_data.dataend(KanaloNr,blokas)] ...
            - Labchart_data.datastart(KanaloNr,blokas) ) / Labchart_data.samplerate(KanaloNr,blokas)]';
        set(handles.checkbox_ekg,'Value',1);
        assignin('base','EKG_laikai',handles.EKG_laikai);
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
            Pranesk_apie_klaida(err, 'EKG QRS aptikimas', f, 0);
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


    dabartines_fig=findobj(handles.figure1);
    delete(dabartines_fig(find(ismember(dabartines_fig,handles.pradines_fig)==0)));
    set(handles.axes_rri,'Position',handles.axes_rri_padetis);

    handles=pirmieji_grafikai(hObject, eventdata, handles);
    brush(handles.figure1,'on');

    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
catch err;
    Pranesk_apie_klaida(err, 'Importuoti_LabChartMAT', f, 0);
    %warning(err.message);
    %w=warndlg(err.message);
    %uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
end;
susildyk(hObject, eventdata, handles);
figure(handles.figure1);
drawnow;


% --------------------------------------------------------------------
function Importuoti_BiopacACQ_Callback(hObject, eventdata, handles)
% hObject    handle to Importuoti_BiopacACQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
susaldyk(hObject, eventdata, handles);
[f,p]=uigetfile({'*.acq'; '*.*' ;});
susildyk(hObject, eventdata, handles);
drawnow;
if or(isempty(f),f==0) ; return ; end;
SeniLaikai=get(handles.axes_rri,'UserData');
try
    acq_data=load_acq(fullfile(p,f));
    figure(handles.figure1);
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
        handles.EKG_laikai=[double([nuo:iki] - nuo ) / 1000 * ...
            double(acq_data.hdr.graph.sample_time) ]';
        set(handles.checkbox_ekg,'Value',1);
        assignin('base','EKG_laikai',handles.EKG_laikai);
    %else
    %    handles.EKG=[];
    %    handles.EKG_laikai=[];
    end;

    try
        Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles);
    catch err;
        Pranesk_apie_klaida(err, 'EKG QRS aptikimas', f, 0);
    end;

    dabartines_fig=findobj(handles.figure1);
    delete(dabartines_fig(find(ismember(dabartines_fig,handles.pradines_fig)==0)));
    set(handles.axes_rri,'Position',handles.axes_rri_padetis);

    handles=pirmieji_grafikai(hObject, eventdata, handles);
    brush(handles.figure1,'on');

    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
catch err;
    Pranesk_apie_klaida(err, 'Importuoti_LabChartMAT', f, 0);
    %warning(err.message);
    %w=warndlg(err.message);
    %uiwait(w);
    set(handles.axes_rri,'UserData',SeniLaikai);
    pushbutton_atstatyti_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
end;
susildyk(hObject, eventdata, handles);
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
guidata(hObject, handles);
figure(handles.figure1);
drawnow;


function Aptikti_EKG_QRS_Callback2(hObject, eventdata, handles)
susaldyk(hObject, eventdata, handles);
sampling_rate= (length(handles.EKG_laikai)-1) / (handles.EKG_laikai(end)-handles.EKG_laikai(1)) ;
QRS_algoritmai={...
    'Pan-Tompkin (1985), pg. Sedghamiz (2014)' ...
    'Ramakrishnan et al. (2014)' ...
    'Suppappola-Sun (1994), iš ECGlab2.0' ...
    'adaptyvus Sedghamiz (2014) algoritmas'};
mode=listdlg('ListString',QRS_algoritmai,...
    'SelectionMode','single',...
    'InitialValue',2,...
    'PromptString',lokaliz('QRS detection algoritm:'),...
    'OKString',lokaliz('OK'),...
    'CancelString',lokaliz('Cancel'));
susildyk(hObject, eventdata, handles);

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
[RR_idx]=QRS_detekt(handles.EKG,sampling_rate,mode);
catch err;
    if ishandle(f)
        delete(f);
    end;
    rethrow(err);
end;
if ishandle(f)
    delete(f);
end;
Laikai=handles.EKG_laikai(RR_idx)*1000; %Laikai=(RR_idx-1)/sampling_rate*1000;
set(handles.axes_rri,'UserData',Laikai);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Duomenys_Callback(hObject, eventdata, handles)
% hObject    handle to Duomenys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
