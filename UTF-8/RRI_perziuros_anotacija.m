% RRI_perziuros_anotacija
% objektas=RRI_perziuros_anotacija(['prideti'|'slepti'|'salinti'],gcf,gca)
% handle = RRI_perziuros_anotacija(['add'|'hide'|'remove'],gcf,gca)
%
% (C) 2015 Mindaugas Baranauskas

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
% licencijos kopija; jeia ne - rašykite Free Software Foundation, Inc., 59
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

function anotObj=RRI_perziuros_anotacija(varargin)

if nargin > 0 ; act=varargin{1};
else            act='prideti';
end;
if nargin > 1 ; hFig=varargin{2};
else            hFig=gcf;
end;
if nargin > 2 ; cAx=varargin{3};
else            cAx=gca;
end;

anotObj=findall(hFig,'Type','textbox','Tag','Anot');
if isempty(anotObj);
    try anot=getappdata(hFig,'anotObj'); catch; end;
    if ishandle(anot); anotObj=anot; end;
end;

% Vykdyti pasirinktą veiksmą
try
    switch act
        case {'slepti' 'hide'}
            try set(anotObj,'Visible','off'); catch; end;
        case {'salinti' 'remove'}
            try delete(anotObj); catch; end; 
            anotObj=[];
        otherwise
            anotObj=RRI_perziuros_anotacija_prideti(hFig,cAx);
    end;
catch %err; Pranesk_apie_klaida(err,mfilename,'',0);
end;


function anotObj=RRI_perziuros_anotacija_prideti(hFig,cAx)



    anotObj=findall(hFig,'Tag','Anot'); % 'Type','textbox',
    if length(anotObj) ~= 1; try delete(anotObj); catch; end; anotObj=[]; end;
    if isempty(anotObj);
        try anotObj=getappdata(hFig,'anotObj'); catch; end;
    end;
    if length(anotObj) ~= 1; try delete(anotObj); catch; end; anotObj=[]; end;
    
    % Rekomenduojama > MATLAB R2015a
    V= version('-release') ; 
    if str2num(V(1:end-1)) < 2015; 
        try delete(anotObj); catch; end; 
        anotObj=[];
        FaceAlpha=0; % tekstas nepermatomas ir taip, papildomo stačiakampio piešimas gadina vaizdą
        %return;
    else
        FaceAlpha=0.8; % beveik nepermatomas
    end;
    
    if isempty(anotObj) ; % disp('-')
        anotObj=annotation(hFig,'textbox',[0 0 0.2 0.2],'Tag','Anot','FitBoxToText','off','hittest','on',...
            'Margin',0,'LineStyle','none','EdgeColor','none','Backgroundcolor','w','FaceAlpha',FaceAlpha,...
            'HorizontalAlignment','center','VerticalAlignment','middle','Visible','off',...
            'color',[0 0 0],'BackgroundColor',[0.98 0.99 1],'Interpreter','tex','String','');
    end;
    setappdata(hFig,'anotObj',anotObj);
    
    % Susižinoti ekrano parametrus
    poz=getPos(cAx,'pixels'); 
    plotis=diff(get(cAx,'XLim')); 
    aukstis=diff(get(cAx,'YLim')); 
    ratioX=poz(3)/plotis;
    ratioY=poz(4)/aukstis;
    hFigCP=getCurrentPoint(hFig,'pixels');
    axesCP=getCurrentPoint(cAx, 'pixels');
    point_h=[]; point_hi=[]; point_i=[] ; point_x=[]; point_y=[]; point_d=Inf;
    
    % Numatytas tekstas, jei nebūtų nubraižytų taškų
    str={sprintf('%.0f ms\n%.3f s',axesCP(1,2),axesCP(1,1))};
    
    % Rasti artimiausią QRS žymelį
    %set(get(cAx,'Children'),'hittest','on');  drawnow; cld=hittest; set(get(cAx,'Children'),'hittest','off'); drawnow;
    clds=findall(get(cAx,'Children'),'Visible','on','-property','Marker','-not','Marker','none');
    if ~isempty(clds);
        dat=struct('x',[],'y',[],'b',[],'u',[]);
        for ci=1:length(clds); c=clds(ci);
            % Apskaičiuoti atstumą iki kiekvieno grafiko taško
            dat(ci).x=get(c,'XData')'; dat(ci).y=get(c,'YData')'; g1=find(~isnan(dat(ci).y)); % ignoruoti NaN
             %geox0 = ((dat(ci).x(g1)-axesCP(1,1)).*ratioX) ;
             %geoy0 = ((dat(ci).y(g1)-axesCP(1,2)).*ratioY) ;
             %assignin('base',['geox0_' get(c,'Tag') ], [...
             %    geox0 (dat(ci).x(g1)-axesCP(1,1)) dat(ci).x(g1) zeros(size(geox0))+axesCP(1,1) ...
             %    geoy0 (dat(ci).y(g1)-axesCP(1,2)) dat(ci).y(g1) zeros(size(geox0))+axesCP(1,2) ]);
            geox = ((dat(ci).x(g1)-axesCP(1,1)).*ratioX).^2 ; % assignin('base',['geox_' get(c,'Tag') ], geox / 1000);
            geoy = ((dat(ci).y(g1)-axesCP(1,2)).*ratioY).^2 ;      % assignin('base',['geoy_' get(c,'Tag') ], geoy);
            [d,i]=min(sqrt(   geox + geoy   )); % geometric distance, units close to pixels, at least for my testing monitor
            if point_d > d;
                point_h=c; point_hi=ci; point_i=g1(i); point_gi=i; point_d=d; point_x=dat(ci).x(point_i);  % point_y=dat(ci).y(point_i);
            end;
            %fprintf('%s: %6.0f: %6.0f\n', get(c,'Tag'), g1(i), d ); % for debuging distances
            
            % Grąžinti seną žymeklį
            try dat(ci).b=get(c,'BrushData');
            catch %err; Pranesk_apie_klaida(err,mfilename,'',0);
                try datamanager.enableBrushing(c); catch; end;
                dat(ci).b=zeros(size(dat(ci).x));
            end;
            try usd=get(c,'UserData');
                if and(~isempty(usd),size(usd,2)<length(dat(ci).b));
                    if unique(dat(ci).b(usd(1,:))) ~= 0; 
                        dat(ci).b(usd(1,:))=usd(2,:) ; % restore  state of old active points
                    end; 
                end;
                if ~isempty(dat(ci).b);
                    dat(ci).b=round([dat(ci).b > 0] + 0); % equalize if any % round acceps only numeric, not logical
                else 
                end;
                set(c,'UserData',[]);
                set(c,'BrushData',dat(ci).b); 
            catch %err ; disp(get(c,'Tag')); Pranesk_apie_klaida(err,mfilename,'',0);
            end;
        end;
        
        % Find Y value. Comment, if you don't need maximum value at x from any plot
        point_y_=arrayfun(@(i) dat(i).y(find(dat(i).x == point_x)), 1:length(dat),'UniformOutput', false);
        point_y=max(point_y_{find(~isempty(point_y_))});
        
        % % Naujas žymeklis, bet tik vienam - artimiausiam - taškui 
        %try set(point_h,'UserData',[point_i; dat(point_hi).b(point_i)]) ; % current state of new active points to memory
        %    dat(point_hi).b(point_i)=1; set(point_h,'BrushData',dat(point_hi).b);
        %catch %err ; Pranesk_apie_klaida(err,mfilename,'',0);
        %end;
        
        % Naujas žymeklis visiems taškams su tuo pačiu x
        xIDs=cellfun(@(i) find(dat(i).x == point_x), num2cell(1:length(dat)),'UniformOutput', false);
        try for ci=1:length(clds); c=clds(ci);
                nUsd=[xIDs{ci}; dat(ci).b(xIDs{ci})];
                set(c,'UserData',nUsd) ; % current state of new active points to memory
                dat(ci).b(xIDs{ci})=1; set(c,'BrushData',dat(ci).b);
            end;
        catch %err; disp(get(c,'Tag')); Pranesk_apie_klaida(err,mfilename,'',0);
        end;
        
        % Užrašo parinkimas priklausomai nuo atstumo
        if ~isempty(point_h);
            if point_d < 20
                str={sprintf('QRS id = %d\nRRI =\\bf %.0f\\rm ms\nt = \\bf%.3f\\rm s',point_gi,point_y,point_x)};
                %str={sprintf('QRS id = %d\nRRI =\\bf %.0f\\rm ms\nt = \\bf%.3f\\rm s \nd = %.3f',point_gi,point_y,point_x,point_d)};
            else %if isequal(overObcj,point_h);
                str={sprintf('QRS id = %d\nRRI =\\bf %.0f\\rm+%.0f ms\nt = \\bf%.3f\\rm+%.3f s',...
                    point_gi,point_y,axesCP(1,2)-point_y,point_x,axesCP(1,1)-point_x)};
                %str={sprintf('QRS id = %d\nRRI =\\bf %.0f\\rm+%.0f ms\nt = \\bf%.3f\\rm+%.3f s \nd = %.3f',...
                %    point_gi,point_y,axesCP(1,2)-point_y,point_x,axesCP(1,1)-point_x,point_d)};
                str=strrep(str,'+-','-');
                %else
                %    str={sprintf('%.0f ms\n%.3f s',axesCP(1,2),axesCP(1,1))};
            end;
        end;
    end;
    
    % Užbaigimas
    rodyti=getappdata(hFig,'anotRod');
    if ~isequal(rodyti,0);
        set(anotObj, 'Units','pixels','Position',[hFigCP + [20 -20] 150 -50],'Visible','on','UserData',tic,'String',str);
    end;
    refreshdata(hFig,'caller');
    drawnow;

    
function cp=getCurrentPoint(hObj,units)
oldu=get(hObj,'Units');
set(hObj,'Units',units);
try    cp=get(hObj,'CurrentPoint');
catch; cp=get(hObj,'PointerLocation');
end;
set(hObj,'Units',oldu);

function poz=getPos(hObj,units)
oldu=get(hObj,'Units');
set(hObj,'Units',units);
poz=get(hObj,'Position');
set(hObj,'Units',oldu);