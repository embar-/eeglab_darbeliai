function eeg_perziura(varargin)
% eeg_perziura - EEG peržiūros/lyginimo varikliukas
%
% eeg_perziura(EEG)
% eeg_perziura(EEG1, EEG2)
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

if nargin > 0;
    if ischar(varargin{1});
        switch lower(varargin{1})
            case {'atnaujinti'};
                eeg_perziura_atnaujinti(varargin{2:end});
            case {'atsakas'};
                eeg_perziura_atsakas(varargin{2:end});
            case {'atstatyk_pele'};
                set(gcf,'pointer','arrow');
            case {'perkurti'};
                eeg_perziura_perkurti(varargin{2:end});
            case {'ribozenkliu_perjungimas'};
                eeg_ribozenkliu_perjungimas(varargin{2:end});
            otherwise;
                eeg_perziura_sukurti(varargin{2:end});
        end;
        return;
    elseif ischar(varargin{end});
        switch lower(varargin{end})
            case {'ratukas'};
                eeg_perziura_atsakas_ratukui(varargin{1:end-1});
        end;
        return;
    elseif isobject(getappdata(gcf,'parentAx')) && (length(findobj(gcf,'tag','scrollAx')) == 2);
        eeg_perziura_perkurti(varargin{:});
    else
        eeg_perziura_sukurti(varargin{:});
    end;
end;


function [EEG1,EEG2]=perkeisk_eeg(a, varargin)
if nargin > 1; % EEG1 - naujas, juodas
    EEG1=varargin{1};
else EEG1=[];
end;
if nargin > 2; % EEG2 - senas, raudonas
     EEG2=varargin{2};
else EEG2=[];
end;

try if isequal(EEG1.times,EEG2.times);
        setappdata(a,'reikia_ribozenkliu',1);
    end;
catch;  setappdata(a,'reikia_ribozenkliu',1);
end;

EEG1=perkeisk_eeg2(EEG1);
EEG2=perkeisk_eeg2(EEG2);

sukeisk=0;
if ~isempty(EEG2.times) && length(EEG1.times)/EEG1.srate > length(EEG2.times)/EEG2.srate;
    sukeisk=1;
elseif EEG1.nbchan > EEG2.nbchan && length(EEG1.times)/EEG1.srate == length(EEG2.times)/EEG2.srate;
    sukeisk=1;
end;
if sukeisk; % EEG1 <-> EEG2
    EEG=EEG1; EEG1=EEG2; EEG2=EEG;
end;

% Y mažinimo koeficientas
y_koef=round(20*sqrt(sqrt(mean([...
    median(std(EEG1.data,[],2,'omitnan'),'omitnan') ...
    median(std(EEG2.data,[],2,'omitnan'),'omitnan')], 'omitnan'))));
if size(y_koef) ~= [1 1]; y_koef=50; end;
setappdata(a,'y_koef',y_koef);

% Kanalų suderinimas
try    l1={EEG1.chanlocs.labels};
catch; l1=[1:EEG1.nbchan]; %arrayfun(@(i) sprintf('%d', i), [1:EEG1.nbchan], 'UniformOutput', false);
end;
try    l2={EEG2.chanlocs.labels};
catch; l2=[1:EEG2.nbchan]; %arrayfun(@(i) sprintf('%d', i), [1:EEG2.nbchan], 'UniformOutput', false);
end;
assignin('base','l1',l1);
assignin('base','l2',l2);
if isequal(l1,l2);
    set(a,'YTick', 1:length(l1));
    set(a,'YTickLabel', l1);
else
    if isempty(l2)
        if isempty(EEG2.data);
            set(a,'YTick', 1:length(l1));
            set(a,'YTickLabel', l1);
            setappdata(a,'reikia_ribozenkliu',1);
        else % FIXME
        end;
    elseif isempty(l1);
        if isempty(EEG1.data);
            set(a,'YTick', 1:length(l2));
            set(a,'YTickLabel', l2);
            setappdata(a,'reikia_ribozenkliu',1);
        else % FIXME
        end;
    elseif iscellstr(l1) && (length(unique(l1)) == size(EEG1.data,1)) && ...
           iscellstr(l2) && (length(unique(l2)) == size(EEG2.data,1));
        if ~any(~ismember(l1,l2));
            data1=nan(length(l2),size(EEG1.data,2));
            for i=1:length(l1);
                data1(ismember(l2,l1{i}),1:size(EEG1.data,2))=EEG1.data(i,:);
            end;
            EEG1.data=data1;
            EEG1.nbchan=EEG2.nbchan;
            set(a,'YTick', 1:length(l2));
            set(a,'YTickLabel', l2);
        elseif ~any(~ismember(l2,l1));
            data2=nan(length(l1),size(EEG2.data,2));
            for i=1:length(l2);
                data2(ismember(l1,l2{i}),1:size(EEG2.data,2))=EEG2.data(i,:);
            end;
            EEG2.data=data2;
            EEG2.nbchan=EEG1.nbchan;
            set(a,'YTick', 1:length(l1));
            set(a,'YTickLabel', l1);
        %elseif EEG.urchanlocs
        else
            if length(l1) > length(l2); k1=l1; k2=l2; else  k1=l2; k2=l1; end;
            l=[k1 k2]; [~,i]=unique(l); l=l(sort(i)); 
            % Papildomai pertvarkyti, bet tolesnės 5 eilutės nebūtinos
            [~,k2j]=ismember(l2,l);
            for i=find(diff(k2j)<0);
                if i == 1; j=1; else j=find(ismember(l,k2(i-1))); end;
                l=[l(1:j) l2(i) l(j+1:end)]; [~,i]=unique(l); l=l(sort(i));
            end;
            
            n=length(l);
            data1=nan(n,size(EEG1.data,2));
            data2=nan(n,size(EEG2.data,2));
            for i=1:length(l1);
                data1(ismember(l,l1{i}),1:size(EEG1.data,2))=EEG1.data(i,:);
            end;
            for i=1:length(l2);
                data2(ismember(l,l2{i}),1:size(EEG2.data,2))=EEG2.data(i,:);
            end;
            EEG1.data=data1; EEG1.nbchan=n;
            EEG2.data=data2; EEG2.nbchan=n;
            set(a,'YTick', 1:n);
            set(a,'YTickLabel', l);
        end;
    %else % FIXME
            %isempty([EEG1.chanlocs.urchan]) && ~isempty([EEG2.chanlocs.urchan])
            %l1([EEG2.chanlocs.urchan])
    end;
end;


function eeg_ribozenkliu_perjungimas(varargin)
try g=struct(varargin{:}); catch; end;
try    f=g(1).figure; if ~isobject(f); f=gcf; end;
catch; f=gcf; %figure;
end;
try    a=g(1).axes; if ~isobject(a); a=gca; end;
catch; a=getappdata(f,'main_axes');
end;
scrl_lin=findobj(findobj(f,'tag','scrollAx','userdata','x'),'tag','scrollDataLine');
x1t=min(get(a,'XLim')); 
x1l=get(scrl_lin(1),'xdata'); x1l=x1l(~isnan(x1l));
[~,x1i]=min(abs(x1l-x1t));
eeg_perziura_perkurti(getappdata(a,'EEG1'), getappdata(a,'EEG2'), 'atnaujinti', 0);
x2l=get(scrl_lin(1),'xdata'); x2l=x2l(~isnan(x2l));
try eeg_perziura_atnaujinti('x',x2l(x1i)); catch; end;


function eeg_perziura_perkurti(varargin)
try g=struct(varargin{3:end}); catch; end;
try    f=g(1).figure; if ~isobject(f); f=gcf; end;
catch; f=gcf; %figure;
end;
set(f,'pointer','watch'); drawnow;
try    a=g(1).axes; if ~isobject(a); a=gca; end;
catch; a=getappdata(f,'main_axes');
end;

if nargin == 0;
    [EEG1,EEG2]=perkeisk_eeg(a, getappdata(a,'EEG1'), getappdata(a,'EEG2'));
else    
    [EEG1,EEG2]=perkeisk_eeg(a, varargin{:});
end;
setappdata(a,'EEG1',EEG1);
setappdata(a,'EEG2',EEG2);

set(findobj(f,'tag','scrollAx','userdata','x'),'XLim',[min(EEG1.xmin,EEG2.xmin)-1 1+max(EEG1.xmax,EEG2.xmax)]);
set(findobj(f,'tag','scrollAx','userdata','y'),'YLim',[0.1 max(EEG1.nbchan,EEG2.nbchan)+0.9]);
scrl_lin=findobj(findobj(f,'tag','scrollAx','userdata','x'),'tag','scrollDataLine');
set(scrl_lin(1),'color','k','xdata',0.001*EEG1.times_nan,'ydata',max(EEG1.nbchan,EEG2.nbchan)*2/3+zeros(size(EEG1.times)));
set(scrl_lin(2),'color','r','xdata',0.001*EEG2.times_nan,'ydata',max(EEG1.nbchan,EEG2.nbchan)*1/2+zeros(size(EEG2.times)));
atnaujinti=1; try atnaujinti=g(1).atnaujinti; catch; end;

%Plotis
if     (EEG1.trials > 1) && isempty(EEG2.times);
    plotis=(EEG1.xmax_org - EEG1.xmin_org);
elseif (EEG2.trials > 1) && isempty(EEG1.times);
    plotis=(EEG2.xmax_org - EEG2.xmin_org);
elseif (EEG2.trials > 1) && (EEG2.trials > 2);
    if (EEG1.xmax_org - EEG1.xmin_org) == (EEG2.xmax_org - EEG2.xmin_org);
        plotis=(EEG1.xmax_org - EEG1.xmin_org);
    end;
else plotis=1;
end;
plotis=plotis*ceil(5/plotis);

if atnaujinti;
    eeg_perziura_atnaujinti('x',min(EEG1.xmin,EEG2.xmin),'plotis',plotis);
end;


function eeg_perziura_sukurti(varargin)
%% Naujai kurti EEG peržiūrai
if nargin == 0; return; end;
try g=struct(varargin{3:end}); catch; end;
try    f=g(1).figure; if ~isobject(f); f=gcf; end;
catch; f=gcf; %figure;
end;
set(f,'pointer','watch'); drawnow;
try    a=g(1).axes; if ~isobject(a); a=gca; end;
catch; a=gca; % axes; % getappdata(f,'main_axes');
end;
cla(a);

[EEG1,EEG2]=perkeisk_eeg(a, varargin{:});

hold(a,'on');
p2=plot(a,[EEG2.xmin 0 EEG2.xmax],[1 NaN (EEG2.nbchan) ],'hittest','off','color','r');
p1=plot(a,[EEG1.xmin 0 EEG1.xmax],[1 NaN (EEG1.nbchan) ],'hittest','off','color','k'); %[ 0 0 0.4]);
set(a,'YDir','reverse', 'TickDir', 'out', 'XGrid', 'on', 'XMinorGrid', 'off', 'XMinorTick', 'on');
setappdata(f,'parentAx',a);
setappdata(a,'EEG1',EEG1);
setappdata(a,'EEG2',EEG2);
setappdata(a,'grafikas1',p1);
setappdata(a,'grafikas2',p2);
setappdata(a,'MouseDragFnc','eeg_perziura(''atnaujinti'');');
setappdata(a,'MouseInMainAxesFnc', {@eeg_perziura,'atstatyk_pele'});
setappdata(a,'MouseOutMainAxesFnc',{@eeg_perziura,'atstatyk_pele'});

% Slikikliai
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
scrollHandles = scrollplot2('Axis','XY', ...
    'MinY', 0.2, ...
    'MaxY', max(EEG1.nbchan,EEG2.nbchan)+0.8, ...
    'MinX', min(EEG1.xmin,EEG2.xmin), ...
    'MaxX', min(EEG1.xmin,EEG2.xmin)+5);
set(scrollHandles(1),'XLim',[min(EEG1.xmin,EEG2.xmin)-1 1+max(EEG1.xmax,EEG2.xmax)]);
set(scrollHandles(2),'YLim',[0.1 max(EEG1.nbchan,EEG2.nbchan)+0.9]);
scrl_lin=findobj(findobj(f,'tag','scrollAx','userdata','x'),'tag','scrollDataLine');
set(scrl_lin(1),'color','k','xdata',0.001*EEG1.times_nan,'ydata',max(EEG1.nbchan,EEG2.nbchan)*2/3+zeros(size(EEG1.times)),'hittest','off');
set(scrl_lin(2),'color','r','xdata',0.001*EEG2.times_nan,'ydata',max(EEG1.nbchan,EEG2.nbchan)*1/2+zeros(size(EEG2.times)),'hittest','off');
setappdata(a,'scrl_lin',scrl_lin);

% Kontekstinis meniu
c=uicontextmenu;
uimenu(c,'label',['+ ' lokaliz('Artinti')], 'callback','eeg_perziura(''atsakas'',''add'');');
uimenu(c,'label',['- ' lokaliz('Tolinti')], 'callback','eeg_perziura(''atsakas'',''subtract'');');
p=uimenu(c,'label',lokaliz('Laiko plotis'));
uimenu(p,'label',lokaliz('Nustatyti...'),'callback',...
    ['ans=inputdlg([lokaliz(''Laiko plotis'') '':''],''Darbeliai'',1,{num2str(abs(diff(get(gca,''XLim''))))}); ' ...
    'if ~isempty(ans); eeg_perziura(''atnaujinti'',''plotis'',str2num(ans{1})); end;']);
uimenu(p,'label','1 s','separator','on','callback','eeg_perziura(''atnaujinti'',''plotis'',1);');
uimenu(p,'label','5 s', 'callback','eeg_perziura(''atnaujinti'',''plotis'',5);');
uimenu(p,'label','10 s','callback','eeg_perziura(''atnaujinti'',''plotis'',10);');
uimenu(p,'label','30 s','callback','eeg_perziura(''atnaujinti'',''plotis'',30);');
k=uimenu(c,'label',lokaliz('Y koeficientas'));
uimenu(k,'label',lokaliz('Nustatyti...'),'callback',...
    ['ans=inputdlg([lokaliz(''Y koeficientas'') '':''],''Darbeliai'',1,{num2str(getappdata(gca,''y_koef''))}); ' ...
    'if ~isempty(ans); eeg_perziura(''atnaujinti'',''y_koef'',str2num(ans{1})); end;']);
uimenu(k,'label','10','separator','on','callback', 'setappdata(gca,''y_koef'', 10); eeg_perziura(''atnaujinti'');');
uimenu(k,'label','25', 'callback', 'eeg_perziura(''atnaujinti'',''y_koef'', 25);');
uimenu(k,'label','50', 'callback', 'eeg_perziura(''atnaujinti'',''y_koef'', 50);');
uimenu(k,'label','100','callback', 'eeg_perziura(''atnaujinti'',''y_koef'',100);');
uimenu(k,'label','200','callback', 'eeg_perziura(''atnaujinti'',''y_koef'',200);');
uimenu(c,'label',lokaliz('Eiti laikan...'),'separator','on','callback',...
    ['ans=inputdlg(lokaliz(''Eiti laikan''),''Darbeliai'',1,{num2str(min(get(gca,''XLim'')))}); ' ...
    'if ~isempty(ans); eeg_perziura(''atnaujinti'',''x'',str2num(ans{1})); end;']);
uimenu(c,'label','|<', 'callback','eeg_perziura(''atsakas'',''home'');');
uimenu(c,'label','0 s', 'callback','eeg_perziura(''atnaujinti'',''x'',0);');
uimenu(c,'label','>|', 'callback','eeg_perziura(''atsakas'',''end'');');
uimenu(c,'label',lokaliz('Rodyti ivykius'),'separator','on', 'Checked','on', 'callback', [ ...
    'if strcmp(get(gcbo,''Checked''),''on''); ' ...
    '   setappdata(gca,''nereikia_ivykiu'', 1); set(gcbo,''Checked'',''off'');' ...
    '   delete(findobj(gca,''tag'',''zymekliaiA1'')); delete(findobj(gca,''tag'',''zymekliaiA2''));' ...
    'else setappdata(gca,''nereikia_ivykiu'',[]); set(gcbo,''Checked'',''on''); eeg_perziura(''atnaujinti''); end;']);
uimenu(c,'label',[lokaliz('+-') ' ' lokaliz('Apversti asis')], 'Checked','on', 'callback', [ ...
    'if strcmp(get(gcbo,''Checked''),''on''); ' ...
    '     setappdata(gca,''apversti'', 1); set(gcbo,''Checked'',''off'');' ...
    'else setappdata(gca,''apversti'',[]); set(gcbo,''Checked'',''on'');' ...
    'end; eeg_perziura(''atnaujinti''); ']);
ribozenkliai=fastif(isempty(getappdata(a,'reikia_ribozenkliu')),'on','off');
uimenu(c,'label',lokaliz('Tarpas vietoj ribozenklio'), 'Checked',ribozenkliai, 'callback', [ ...
    'if strcmp(get(gcbo,''Checked''),''on''); ' ...
    '     setappdata(gca,''reikia_ribozenkliu'', 1); set(gcbo,''Checked'',''off'');' ...
    'else setappdata(gca,''reikia_ribozenkliu'',[]); set(gcbo,''Checked'',''on'');' ...
    'end; eeg_perziura(''ribozenkliu_perjungimas''); ']);
t=uimenu(c,'label',lokaliz('Tinklelis'));
uimenu(t,'label',lokaliz('Grubus'), 'Checked','on', 'callback',...
    ['if strcmp(get(gcbo,''Checked''),''on''); ' ...
    '     set(gca,''XGrid'', ''off''); set(gcbo,''Checked'',''off'');' ...
    'else set(gca,''XGrid'', ''on'') ; set(gcbo,''Checked'',''on''); end;'])
uimenu(t,'label',lokaliz('Smulkus'), 'Checked','off', 'callback',...
    ['if strcmp(get(gcbo,''Checked''),''on''); ' ...
    '     set(gca,''XMinorGrid'', ''off''); set(gcbo,''Checked'',''off'');' ...
    'else set(gca,''XMinorGrid'', ''on'') ; set(gcbo,''Checked'',''on''); end;'])
%uimenu(c,'label','Tempti','Callback','p=pan; set(p, ''Motion'',''horizontal'',''ActionPostCallback'',''eeg_perziura(''''atnaujinti'''');'', ''Enable'',''on'') ;');
uimenu(c,'label','EEG1 <-> EEG2','separator','on','callback', ...
    [ 'setappdata(gcf,''laikinas'',getappdata(gca,''EEG1'')); ' ...
    'setappdata(gca,''EEG1'', getappdata(gca,''EEG2'')); ' ...
    'setappdata(gca,''EEG2'', getappdata(gcf,''laikinas'')); eeg_perziura(''atnaujinti''); ' ...
    'scrl_lin=getappdata(gca,''scrl_lin'') ; setappdata(gcf,''laikinas'',get(scrl_lin(1),''color'')); ' ...
    'set(scrl_lin(1),''color'',get(scrl_lin(2),''color'')); set(scrl_lin(2),''color'',getappdata(gcf,''laikinas''));' ]);
%set(f,'UIContextMenu',c);
set(a,'UIContextMenu',c);

% Plotis
if     (EEG1.trials > 1) && isempty(EEG2.times);
    plotis=(EEG1.xmax_org - EEG1.xmin_org);
elseif (EEG2.trials > 1) && isempty(EEG1.times);
    plotis=(EEG2.xmax_org - EEG2.xmin_org);
elseif (EEG2.trials > 1) && (EEG2.trials > 2);
    if (EEG1.xmax_org - EEG1.xmin_org) == (EEG2.xmax_org - EEG2.xmin_org);
        plotis=(EEG1.xmax_org - EEG1.xmin_org);
    end;
else plotis=1;
end;
plotis=plotis*ceil(5/plotis);

% Galutinis paruošimas
setappdata(f,'main_axes',a);
setappdata(f,'scrollHandles',scrollHandles);
eeg_perziura_atnaujinti('plotis',plotis);
set(f,'KeyPressFcn','eeg_perziura(''atsakas'')');
set(f,'WindowScrollWheelFcn',{@eeg_perziura,'ratukas'});


function EEG=perkeisk_eeg2(EEG)
if isempty(EEG);
    [~, EEG] = pop_newset([],[],[]);
end;
dim3=size(EEG.data,3);
if dim3 > 1;
    dim2=size(EEG.data,2);
    EEG.data=EEG.data(:,:);
    EEG.times=[0:size(EEG.data,2)-1]/EEG.srate*1000; % ms
    EEG.xmin_org=EEG.xmin;
    EEG.xmax_org=EEG.xmax;
    for i=0:dim3;
        l=0.5 + i * dim2;
        j=find([EEG.event.latency] > l, 1, 'first');
        if isempty(j);
            j=1+length(EEG.event);
        else
            EEG.event(j+1:end+1) = EEG.event(j:end);
        end;
        EEG.event(j).type = 'boundary';
        EEG.event(j).latency  = l;
        EEG.event(j).duration = 0;
    end;
end;
if isfield(EEG, 'event_org');
     EEG.event=EEG.event_org;
else EEG.event_org=EEG.event;
end;
if isfield(EEG, 'times_org');
     EEG.times=EEG.times_org;
else EEG.times_org=EEG.times;
end;
EEG.xmin=0.001*min(EEG.times); if isempty(EEG.xmin); EEG.xmin=0; end;
EEG.xmax=0.001*max(EEG.times); if isempty(EEG.xmax); EEG.xmax=0; end;
if size(EEG.data,2) ~= length(EEG.times) && isfield(EEG, 'times_nan');
    EEG.data=EEG.data(:,~isnan(EEG.times_nan));
end;
reikia_ribozenkliu=~isempty(getappdata(gca,'reikia_ribozenkliu'));
[ivLaikai, ivTipai, ivRodykles, ~, EEG.times_bnd] = eeg_ivykiu_latenc(EEG, 'boundary', ~reikia_ribozenkliu);
for i=ivRodykles;
    EEG.event(i).laikas_ms=ivLaikai(i);
end;
if ~reikia_ribozenkliu && dim3 <= 1 ;
    EEG.times_nan=EEG.times_bnd;
    bndrs=ismember(ivTipai','boundary');
    for i=find(bndrs); 
        n=find(EEG.times_bnd >= ivLaikai(i),1,'first');
        if ~isempty(n);
            EEG.times_bnd(1,n+1:end+1)=EEG.times_bnd(1,n:end);
            EEG.times_nan(1,n+1:end+1)=EEG.times_nan(1,n:end);
            EEG.data( :,n+1:end+1)=EEG.data( :,n:end);
            EEG.times_bnd(n)=ivLaikai(i);
            EEG.times_nan(n)=NaN;
            EEG.data(:,n)=nan(size(EEG.data,1),1);
        end;
    end;
    EEG.times=EEG.times_bnd;
    EEG.event=EEG.event(~bndrs);
    EEG.xmin=0.001*min(EEG.times); if isempty(EEG.xmin); EEG.xmin=NaN; end;
    EEG.xmax=0.001*max(EEG.times); if isempty(EEG.xmax); EEG.xmax=0; end;
else
    EEG.times_nan=EEG.times_org;
    EEG.times_bnd=EEG.times_org;
end;

function eeg_perziura_atnaujinti(varargin)
%% atnaujinti jau sukurtą vaizdą
try g=struct(varargin{:});
catch err; Pranesk_apie_klaida(err, mfilename, '?', 0);
end;
try    f=g(1).figure;
catch; f=gcf;
end;
try    parentAx=g(1).axes;
catch; parentAx=getappdata(f,'main_axes');
end;
if ~isobject(parentAx); return; end;

LY=get(parentAx, 'YLim');
LX=get(parentAx, 'XLim');
% Pakeisti X ašies centtravimą
try plotis=g(1).plotis;
    if ~isfield(g,'x'); g.x=[min(LX) min(LX)+plotis]; end;
catch
    plotis=(max(LX)-min(LX));
end;
try cx=g(1).x;
    scrollAx_x=findobj(f,'tag','scrollAx','userdata','x');
    AxLim=get(scrollAx_x,'xLim');
    if length(cx) > 1;
        plotis=abs(diff(cx(1:2)));
        cx=cx(1);
    end;
    plotis=min(plotis,abs(diff(AxLim)));
    cx=max(min(AxLim),cx);
    cx=min(max(AxLim)-plotis,cx);
    LX=[cx cx+plotis];
    set(parentAx, 'xLim', LX);
catch
end;
try setappdata(parentAx,'y_koef',g(1).y_koef(1)); catch; end;

parentAx_unt=get(parentAx,'units');
set(parentAx,'units','pixels');
parentAx_pos=get(parentAx,'position');
set(parentAx,'units',parentAx_unt);
EEG1=getappdata(parentAx,'EEG1');
EEG2=getappdata(parentAx,'EEG2');
zymekliu_spalvosA={ [0 0.9 0] [0.8 0 0.8]}; % {'g' 'm'}
zymekliu_spalvosB={ 'b' [1 0.8 0]}; % {'g' 'm'}
zymekliu_sukeitimas=(EEG1.nbchan > EEG2.nbchan) && ~isempty(EEG2.times);
if zymekliu_sukeitimas;
    zymekliu_kryptis={ 'right' 'left' };
else
    zymekliu_kryptis={ 'left' 'right' };
end;
for i=[1 2];
    if isequal(i,1);
        EEG=EEG1; EEG_=EEG2;
    else
        EEG=EEG2; EEG_=EEG1;
    end;
    ix=find(EEG.times(EEG.times <= (LX(2)+2/EEG.srate)*1000) >= (LX(1)-2/EEG.srate)*1000);
    grafikoX=[0.001*EEG.times(ix) 0]; %disp([i min(grafikoX(1:end-1)) max(grafikoX(1:end-1))]);
    iy=[max(ceil(LY(1)),1):min(floor(LY(2)),EEG.nbchan)];
    grafikoY=EEG.data(iy,ix) ./ getappdata(parentAx,'y_koef');
    if isempty(getappdata(parentAx,'apversti'));
        grafikoY=-grafikoY;
    end;
    for eil=1:length(iy);
        grafikoX(eil,:)=grafikoX(1,:);
        grafikoY_=grafikoY(eil,:);
        med=median(grafikoY_(~isnan(grafikoY_)));
        grafikoY(eil,:)=grafikoY(eil,:)-med+iy(eil);
    end;
    grafikoY=[grafikoY nan(length(iy),1)]';
    grafikoY=grafikoY(:)';
    grafikoX=grafikoX';
    grafikoX=grafikoX(:)';
    if ~isequal(size(grafikoY),size(grafikoX));
        grafikoY=nan(size(grafikoX));
    end;
    grafikas=getappdata(parentAx,['grafikas' num2str(i)]);
    set(grafikas,'XData', grafikoX, 'YData', grafikoY);
    if isfield(EEG.event, 'laikas_ms');
        delete(findobj(parentAx,'tag',['zymekliaiA' num2str(i)]));
        delete(findobj(parentAx,'tag',['zymekliaiB' num2str(i)]));
        zi=find([EEG.event(find([EEG.event.laikas_ms] <= LX(2)*1000)).laikas_ms] >= LX(1)*1000);
        zx=0.001 * [EEG.event(zi).laikas_ms]'; zx_=[zx zx zx]'; zx_=zx_(:);
        if (isequal(i,1) - 0.5) * (0.5 - zymekliu_sukeitimas) > 0 ;
            if isempty(EEG_.data); zyk=max(LY); else zyk=mean(LY); end;
            zy=[min(LY)+zeros(size(zx)) zyk*ones(size(zx)) nan(size(zx))]'; zyL=min(LY)-abs(diff(LY))/parentAx_pos(4)*5;
        else
            if isempty(EEG_.data); zyk=min(LY); else zyk=mean(LY); end;
            zy=[zyk*ones(size(zx)) max(LY)*ones(size(zx)) nan(size(zx))]';  zyL=max(LY)+abs(diff(LY))/parentAx_pos(4)*5;
        end;
        zy=zy(:);
        zm={EEG.event(zi).type} ;
        if iscellstr(zm);
            bi=ismember(zm,{'boundary'}); bi=[bi; bi; bi]; bi=bi(:); zm=strrep(zm,'boundary','');
            plot(parentAx, zx_(bi), zy(bi),'hittest','off','tag',['zymekliaiB' num2str(i)], 'color',zymekliu_spalvosB{i}, 'LineWidth', 2);
        else
            bi=zeros(size(zx_));
        end;
        if isempty(getappdata(parentAx,'nereikia_ivykiu'));
            plot(parentAx, zx_(~bi), zy(~bi),'hittest','off','tag',['zymekliaiA' num2str(i)], 'color',zymekliu_spalvosA{i});
            %zx=zx+abs(diff(LX))/parentAx_pos(3)*5
            text(zx,zyL+zeros(size(zx)), zm,...
                'color',zymekliu_spalvosA{i},'Parent',parentAx,'FontUnits','points','FontSize',10,'FontName','Arial','Interpreter','none',...
                'Rotation',90,'hittest','off','Tag',['zymekliaiA' num2str(i)],'HorizontalAlignment',zymekliu_kryptis{i});
        end;
    end;
end;
eeg_perziura('atstatyk_pele');


function eeg_perziura_atsakas(varargin)
% reagavimas į klaviatūros paspaudimus
ax=getappdata(gcf,'main_axes');
scrollHandles=getappdata(gcf,'scrollHandles');
if nargin > 0; ck=varargin{1};
else           ck=get(gcf,'CurrentKey');
end;
if nargin > 1; modifiers=varargin{2};
else           modifiers=get(gcf,'currentModifier');
end;
lk=0.02;
try
    switch ck
        %case 'escape'
        %    try delete(gcf); catch; end;
        
        case {'downarrow' 'uparrow'} % Y ašis apversta!
            if ~any(ismember({'alt' 'control' 'shift'},modifiers));
                lim_dbr=get(ax,'YLim');
                lim_max=get(scrollHandles(2),'YLim');
                lim_plt=(lim_dbr(2)-lim_dbr(1));
                switch ck
                    case 'downarrow' %; disp('v');
                        lim_nj=min(lim_dbr(2) + lim_plt * lk, lim_max(2) + lim_plt * lk);
                        lim_nj=[lim_nj - lim_plt lim_nj];
                    case 'uparrow'   %; disp('^');
                        lim_nj=max(lim_dbr(1) - lim_plt * lk, lim_max(1) - lim_plt * lk);
                        lim_nj=[lim_nj lim_plt + lim_nj];
                end;
                set(ax,'YLim',lim_nj);
                eeg_perziura_atnaujinti;
            elseif ismember({'control'},modifiers);
                if ismember({'shift'},modifiers); 
                     ct={'control' 'shift'}; 
                else ct={'control'};
                end;
                switch ck
                    case 'downarrow' %; disp('v');
                        eeg_perziura_atsakas('subtract', ct)
                    case 'uparrow'   %; disp('^');
                        eeg_perziura_atsakas('add', ct)
                end;
            elseif ismember({'shift'},modifiers);
                switch ck
                    case 'downarrow' %; disp('v');
                        eeg_perziura_atsakas('subtract', {'shift'})
                    case 'uparrow'   %; disp('^');
                        eeg_perziura_atsakas('add', {'shift'})
                end;
            elseif ismember({'alt'},modifiers)
                y_koef=getappdata(ax,'y_koef');
                switch ck
                    case 'downarrow' %; disp('v');
                        y_koef=y_koef*1.25;
                    case 'uparrow'   %; disp('^');
                        y_koef=y_koef*0.8;
                end;
                setappdata(ax,'y_koef',y_koef);
                eeg_perziura_atnaujinti;
            end;
            
        case {'leftarrow' 'rightarrow' 'pageup' 'pagedown' 'home' 'end'}
            lim_dbr=get(ax,'XLim');
            lim_max=get(scrollHandles(1),'XLim');
            lim_plt=(lim_dbr(2)-lim_dbr(1));
            switch ck
                case 'leftarrow'
                    %disp('<');
                    if any(ismember({'alt' 'control' 'shift'},modifiers));
                        lk=lk*5;
                    end;
                    lim_nj=max(lim_dbr(1) - lim_plt * 0.2, lim_max(1) - lim_plt * lk);
                    lim_nj=[lim_nj lim_plt + lim_nj];
                case 'rightarrow'
                    %disp('>');
                    if any(ismember({'alt' 'control' 'shift'},modifiers));
                        lk=lk*5;
                    end;
                    lim_nj=min(lim_dbr(2) + lim_plt * 0.2, lim_max(2) + lim_plt * lk);
                    lim_nj=[lim_nj - lim_plt lim_nj];
                case 'pageup'
                    %disp('<');
                    lim_nj=max(lim_dbr(1) - lim_plt * 1.0, lim_max(1) - lim_plt * lk);
                    lim_nj=[lim_nj lim_plt + lim_nj];
                case 'pagedown'
                    %disp('>');
                    lim_nj=min(lim_dbr(2) + lim_plt * 1.0, lim_max(2) + lim_plt * lk);
                    lim_nj=[lim_nj - lim_plt lim_nj];
                case 'home'
                    lim_nj=lim_max(1);% - lim_plt * lk;
                    lim_nj=[lim_nj lim_plt + lim_nj];
                case 'end'
                    lim_nj=lim_max(2);% + lim_plt * lk;
                    lim_nj=[lim_nj - lim_plt lim_nj];
            end;
            set(ax,'XLim',lim_nj);
            eeg_perziura_atnaujinti;
        case {'subtract' 'add'}
            switch diff(ismember({'shift' 'control'}, modifiers))
                case  1; asisR='x'; asisN=1;
                case -1; asisR='y'; asisN=2;
                otherwise
                    eeg_perziura_atsakas(ck,{'control'});
                    eeg_perziura_atsakas(ck,{'shift'});
                    return;
            end;
            lim_dbr=get(ax,[asisR 'lim']);
            switch ck
                case 'subtract'
                    lim_max=get(scrollHandles(asisN),[asisR 'lim']);
                    lim_plt=(lim_dbr(2)-lim_dbr(1));
                    lim_nj1=max(lim_dbr(1) - lim_plt * 0.125, lim_max(1) - lim_plt * lk);
                    lim_nj2=min(lim_dbr(2) + lim_plt * 0.125, lim_max(2) + lim_plt * lk);
                case 'add'
                    lim_plt=(lim_dbr(2)-lim_dbr(1));
                    lim_nj1=lim_dbr(1) + lim_plt * 0.1;
                    lim_nj2=lim_dbr(2) - lim_plt * 0.1;
            end;
            lim_nj=[lim_nj1 lim_nj2];
            set(ax,[asisR 'lim'],lim_nj);
            eeg_perziura_atnaujinti;
        otherwise
            %disp(ck); disp(modifiers);
    end;
catch err;
    Pranesk_apie_klaida(err,mfilename,'',0);
end;


function eeg_perziura_atsakas_ratukui(~,eventdata)
% Pelės ratuko sukimas
ax=getappdata(gcf,'main_axes');
scrollHandles=getappdata(gcf,'scrollHandles');
modifiers = get(gcf,'currentModifier');
asisR='x'; asisN=1;
act=hittest;
try
    if ~isempty(findall(act,'-property','Tag'));
        if ismember(get(act,'Tag'),{'scrollAx' 'scrollPatch' 'scrollBar'});
            if strcmp(get(act,'UserData'),'y')
                asisR='y'; asisN=2;
            end;
        end;
    end;
catch % Paprastai klaida būna, jei kompiuteris lagina
    return;
end;
try
    if ismember('control',modifiers);
        if eventdata.VerticalScrollCount > 0;
            if asisN == 1
                eeg_perziura_atsakas('add',{'control'});
            else eeg_perziura_atsakas('add',{'shift'});
            end;
        else
            if asisN == 1
                eeg_perziura_atsakas('subtract',{'control'});
            else eeg_perziura_atsakas('subtract',{'shift'});
            end;
        end;
    elseif ismember('alt',modifiers);
        y_koef=getappdata(ax,'y_koef');
        if eventdata.VerticalScrollCount > 0
            y_koef=y_koef*0.8;
        else
            y_koef=y_koef*1.25;
        end;
        setappdata(ax,'y_koef',y_koef);
    else
        if   ismember('shift',modifiers);
             lk=1;
        else lk=0.2;
        end;
        if eventdata.VerticalScrollCount > 0; % Y ašis ir taip apversta
            lim_dbr=get(ax,[asisR 'lim']);
            lim_max=get(scrollHandles(asisN),[asisR 'lim']);
            lim_plt=(lim_dbr(2)-lim_dbr(1));
            lim_nj=min(lim_dbr(2) + lim_plt * lk, lim_max(2));% + lim_plt * 0.2);
            lim_nj=[lim_nj - lim_plt lim_nj];
            set(ax,[asisR 'lim'],lim_nj);
        else
            lim_dbr=get(ax,[asisR 'lim']);
            lim_max=get(scrollHandles(asisN),[asisR 'lim']);
            lim_plt=(lim_dbr(2)-lim_dbr(1));
            lim_nj=max(lim_dbr(1) - lim_plt * lk, lim_max(1));% - lim_plt * 0.2);
            lim_nj=[lim_nj lim_plt + lim_nj];
            set(ax,[asisR 'lim'],lim_nj);
        end;
    end;
catch err;
    Pranesk_apie_klaida(err,mfilename,'',0);
end;
eeg_perziura_atnaujinti;

