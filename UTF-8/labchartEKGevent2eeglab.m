function [newEEGlabEvents,Poslinkis_vidutinis,Poslinkio_paklaidos] = labchartEKGevent2eeglab(varargin)
% Add labchart events from comments (R peaks) into eeglab events. 
% Script works by allignement of numeric events.
%
% usage:
%  newEEGlabEvents = labchartEKGevent2eeglab('EEGlabTimes', EEG.times, 'EEGlabEvent', EEG.event, 'LabchartCom', com, 'LabchartComtext', comtext, 'LabchartTickrate', tickrate); 
%
% (c) 2014 Aleksas Voicikas
% (c) 2014,2017 Mindaugas Baranauskas

%% Argumentu tvarkymas
if ~isempty(varargin)
g = struct(varargin{:});
else
    g=[];
end;

try g.EEGlabEvent; catch, error('no EEGlabevents'); end;
try g.SaveDir; catch, g.SaveDir = 0; end;
try g.LabchartCom; catch, error('no labchart com'); end;
try g.EEGlabTimes; catch, error('no EEGlab Times'); end;
try g.LabchartComtext; catch, error('no labchart comtext'); end;
try g.LabchartTickrate; catch, error('no labchart tickrate'); end;
try g.New_R_event_type; catch, error('no event type for EKG R wave'); end;

allfields = fieldnames(g);
for index = 1:length(allfields)
	switch allfields{index}
	 case {'SaveDir', 'EEGlabTimes', 'EEGlabEvent', 'LabchartCom', 'LabchartComtext', 'LabchartTickrate', 'New_R_event_type'}
	 otherwise warning([ 'Nera tokio parametro '''  allfields{index} '''' ]); beep;  % return;
	end;
end;

%% Vidinių kintamųjų paruošimas

% Sekanti eilute tik testavimui:
% g= [] ; g.LabchartCom = com ; g.LabchartComtext = comtext ; g.LabchartTickrate = tickrate ; g.EEGlabTimes = EEG.times ; g.EEGlabEvent =  EEG.event ;


% LabChart programa, lyginant su EEG, turi tendencija kiekviena paskesni
% ivyki vis truputeli veliau pazymeti, todel per mazdaug 5 minutes
% susidaro net 8 milisekundziu LabChart nuskubejimas (EEG atsilikimas),
% be to ir pats issibarstymas gali siekti iki ~5 ms

g.Labchart_laiko_daugiklis =  902076 / 902101 ;
g.Leidziama_paklaida = 5 + 1000/g.LabchartTickrate ; % milisekundemis

g.EEG_event_fields=fieldnames(g.EEGlabEvent);
newEEGlabEvents = cell2struct(repmat({[]},numel(g.EEG_event_fields),0),g.EEG_event_fields);
g.Poslinkis.paklaidos=[];
Poslinkis_vidutinis=[];
Poslinkio_paklaidos=[];
g.listOfTimes = {} ;

%% Pereik per EEGLab ivykius, kurie potencialiai bendri su LabChart, t.y kurie yra skaičiai

iLE = 1;
g.listOfTimes.EEG={};
for ie = 1:length(g.EEGlabEvent);
    ivykis=g.EEGlabEvent(1,ie).type;
    if isnumeric(ivykis);
        ivykis=num2str(ivykis);
    end;
    ivykis=deblank(ivykis);
    if and(isstrprop(ivykis, 'digit'), ~isempty(ivykis));
        ivykis=str2num(ivykis);
        g.listOfTimes.EEG{iLE,1} = ivykis;
        g.listOfTimes.EEG{iLE,2} = g.EEGlabTimes(single(g.EEGlabEvent(1,ie).latency));
        iLE = iLE+1;
    end;
end ;
if isempty(g.listOfTimes.EEG);
    error('Neradome tinkamų EEG įvykių, t.y. užkoduotų skaičiais');
end;
g.Unikalus_kodai.EEG=unique(cell2mat(g.listOfTimes.EEG(:,1)));

%% % Pereik per LabChart ivykius, kurie potencialiai bendri su EEGLab

% R dantelių pavadinimai įvykių komentaruose
LabChart_TXT_events=(g.LabchartComtext(g.LabchartCom(  find(g.LabchartCom(:,4) == 2), 5) ,1:3));
LabChart_TXT_events_=unique(cellfun(@(i) LabChart_TXT_events(i,:), num2cell(1:length(LabChart_TXT_events)),'UniformOutput', false ));
if     ismember('ECG', LabChart_TXT_events_);
   LabChart_key='ECG';
elseif ismember('HRV', LabChart_TXT_events_);
   LabChart_key='HRV';
elseif ismember('Eve', LabChart_TXT_events_);
   LabChart_key='Eve';
   warning('Neradus EKG/HRV įvykių, naudosimi kiti komentarai.');
else
   LabChart_key='';
   warning('Tekstinių įvykių nėra, grąžinsime pradinę struktūrą.');
end;

% Vienas kanalas gali turėti kelis blokus, 
% jei įrašymas buvo sustabdytas, o po to toliau įrašinėta
Labchart_skaitiniu_ivykiu_idx=find(g.LabchartCom(:,4)==1);
Labchart_skaitiniu_ivykiu_idx_blokai=g.LabchartCom(Labchart_skaitiniu_ivykiu_idx,2);
Labchart_skaitiniu_ivykiu_blokai=unique(Labchart_skaitiniu_ivykiu_idx_blokai);
bloku_N=length(Labchart_skaitiniu_ivykiu_blokai);
if bloku_N == 1;
    blokas=Labchart_skaitiniu_ivykiu_idx_blokai(1);
elseif bloku_N > 1;
    %paieškokim bendrų su EEG
    Potencialiai_tinkami_blokai=[];
    for i=1:bloku_N;
        LabChart_skaitiniai_ivykiai_bloke=str2num(g.LabchartComtext(...
            g.LabchartCom(Labchart_skaitiniu_ivykiu_idx(...
            find(Labchart_skaitiniu_ivykiu_idx_blokai == Labchart_skaitiniu_ivykiu_blokai(i))),...
            5),:));
        if ~isempty(intersect(LabChart_skaitiniai_ivykiai_bloke,[g.Unikalus_kodai.EEG]'));
            Potencialiai_tinkami_blokai= ...
                [Potencialiai_tinkami_blokai Labchart_skaitiniu_ivykiu_blokai(i)];
        end;
    end;
    if isempty(Potencialiai_tinkami_blokai);
        error('Yra bendrų skaitinių įvykių, bet jie nesutampa!');
    end;
    disp([ 'Potencialiai tinkami LabChart blokai: ' num2str(Potencialiai_tinkami_blokai)]);
    blokas=mode(Labchart_skaitiniu_ivykiu_idx_blokai(find(ismember(...
        Labchart_skaitiniu_ivykiu_idx_blokai,Potencialiai_tinkami_blokai   ))));
    disp(['Pasirinktas blokas: ' num2str(blokas)]);
    % blokas=mode(g.LabchartCom(find(g.LabchartCom(:,4)==1),2));
else 
    error('LabChart įraše nėra skaičiais užkoduotų įvykių!');
end;

if length(g.LabchartTickrate) > 1;
   g.LabchartTickrate=g.LabchartTickrate(blokas);
end;

iLL = 1;
iLR = 1;
g.listOfTimes.LC_kt={};
g.listOfTimes.LC_R={};
for icomMain = [find(g.LabchartCom(:,2)==blokas)]' ;
    ivykis = g.LabchartCom(icomMain, 5);
    ivykis = deblank(g.LabchartComtext(ivykis,:));
    % LabChart komentaruose R danteliai apibudinti tekstu, 
    % o tarp LabChart ir EEG bandri ivykiai yra skaiciai
    if and(all(isstrprop(ivykis, 'digit')), ~isempty(ivykis));
      ivykis = str2num(ivykis) ;
        % LabChart ivykio laikas, milisekundemis
        g.listOfTimes.LC_kt{iLL,1} = ivykis ;
        g.listOfTimes.LC_kt{iLL,2} = g.LabchartCom(icomMain,3) * ( 1000 / g.LabchartTickrate ) * g.Labchart_laiko_daugiklis ;
        iLL = iLL+1;
    elseif ~isempty(LabChart_key)
        is_LabChart_key=0;
        if length(ivykis) > 2
           if strcmp(ivykis(1:3),LabChart_key);
              is_LabChart_key=1;
           end;
        end;
        if is_LabChart_key
           g.listOfTimes.LC_R{iLR,1} = NaN ; % g.New_R_event_type ;
           g.listOfTimes.LC_R{iLR,2} = g.LabchartCom(icomMain,3) * ( 1000 / g.LabchartTickrate ) * g.Labchart_laiko_daugiklis ;
           iLR = iLR+1;
        end;
    end ;
end ;
if isempty(g.listOfTimes.LC_kt);
    error('Neradome tinkamų LabChart įvykių');
end;
g.Unikalus_kodai.LabChart=unique(cell2mat(g.listOfTimes.LC_kt(:,1)));

%%

g.Unikalus_kodai.bendri=intersect(g.Unikalus_kodai.LabChart,g.Unikalus_kodai.EEG) ;

if isempty(g.Unikalus_kodai.bendri) ;
    error('Neradome bendrų įvykių, kurie būtų bendri LabChart ir EEG');
end ;

g.Bendri.LabChart = cell2mat(g.listOfTimes.LC_kt(find(ismember(cell2mat(g.listOfTimes.LC_kt(:,1)), g.Unikalus_kodai.bendri)),:) );
g.Bendri.EEG      = cell2mat(g.listOfTimes.EEG     (find(ismember(cell2mat(g.listOfTimes.EEG(     :,1)), g.Unikalus_kodai.bendri)),:) );
g.Bendri.LabChart_dydis = size(g.Bendri.LabChart,1) ;
g.Bendri.EEG_dydis      = size(g.Bendri.EEG,1) ;

% Nagrineti du g.Unikalus_kodai.bendri atvejus: 
% 1) kai yra vienas besikartojantis ivykio kodas
% 2) kai yra skirtingi kodai, bet jie nesikartoja

g.TaiPaprastasAtvejis = false ;
g.Unikalus_kodai.dydis=length(g.Unikalus_kodai.bendri);
if g.Unikalus_kodai.dydis == 1 ;
% 1) kai yra vienas besikartojantis ivykio kodas    
    if g.Bendri.LabChart_dydis == g.Bendri.EEG_dydis ;
        g.TaiPaprastasAtvejis = true ; 
    % jeigu yra vienas besikartojantis kodas, bet skiriasi kiekis LabChart ir EEG - 
    % dar bus galima zaisti su poslinkiais...
    end;
    
% 2) kai yra skirtingi kodai, bet jie nesikartoja ir issirikiave taip pat

elseif and ( g.Bendri.LabChart_dydis == g.Unikalus_kodai.dydis, g.Bendri.EEG_dydis == g.Unikalus_kodai.dydis) ;
    if g.Bendri.LabChart(:,1) == g.Bendri.EEG(:,1)
        g.TaiPaprastasAtvejis = true ;
    else
        error('Vidinė klaida');
    end;
% Kitu atveju nenagrinekim (teoriskai galetu keli kodai kartotis; ju kiekis gali buti vienodas arba ne)
else % return ;
    [g.Bendri.LabChart_dydis g.Bendri.EEG_dydis g.Unikalus_kodai.dydis ]
    L=g.Bendri.LabChart(:,1)
    E=g.Bendri.EEG(:,1)
    B=g.Unikalus_kodai.bendri
    error('Nepavyko');
end;

g.Netvarkingi_poslinkiai = true ; 

if g.TaiPaprastasAtvejis ;
    g.Poslinkis.kiekvieno = bsxfun(@minus,g.Bendri.LabChart(:,2),g.Bendri.EEG(:,2)) ;
    g.Poslinkis.vidutinis = mean(g.Poslinkis.kiekvieno) ;
    g.Poslinkis.paklaidos = g.Poslinkis.kiekvieno - g.Poslinkis.vidutinis ;
    % pasklaida kuriuo nors atveju didesne nei 5 ms - itartina
    if and(max(g.Poslinkis.paklaidos) < g.Leidziama_paklaida , min(g.Poslinkis.paklaidos) > 0 - g.Leidziama_paklaida ) ;
        g.Netvarkingi_poslinkiai = false ;
    end ;
end ;
    
if g.Netvarkingi_poslinkiai ;
    
    g.Tarpai_tarp_ivykiu.daugmaz_sutampa = false ;
    
    % pirma suraskime visu laiku tarpusavio skirtumus
    g.Tarpai_tarp_ivykiu.LabChart=diff(g.Bendri.LabChart(:,2)) ;
    g.Tarpai_tarp_ivykiu.EEG =    diff(g.Bendri.EEG(     :,2)) ;
        
    g.Tarpai_tarp_ivykiu.sumu_skirtumas =  sum(g.Tarpai_tarp_ivykiu.LabChart) - sum(g.Tarpai_tarp_ivykiu.EEG) ;
    if sqrt( g.Tarpai_tarp_ivykiu.sumu_skirtumas ^ 2) <= 2 * g.Leidziama_paklaida ;
        % Išbandykim paprasta toki atveji (3m_I_1):
        % Ivykiu skaicius skiriasi, bet laiko skirtumas 
        % tarp pirmo ir paskutiniojo ivykio 
        % yra vienodas. Beda tame, kad kazkodel LabChart parode nesama ivyki.
        g.Tarpai_tarp_ivykiu.daugmaz_sutampa = true ;
        g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart = [1 1] ;
        g.Laikai_nuo_pirmo_ivykio.LabChart = g.Bendri.LabChart(:,2) - g.Bendri.LabChart(1,2) ;
        for i=1:length(g.Tarpai_tarp_ivykiu.EEG) ;
            s = sum(g.Tarpai_tarp_ivykiu.EEG(1:i)) ;
            [idx, closest]=FindTrigerTime(g.Laikai_nuo_pirmo_ivykio.LabChart , s) ;
            if ( s - closest ) ^ 2 > (2 * g.Leidziama_paklaida) ^ 2 ;
                g.Tarpai_tarp_ivykiu.daugmaz_sutampa = false ;
            else
                g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart = [ g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart ; i + 1 idx ] ;
            end;
        end;
    end;
    
    if g.Tarpai_tarp_ivykiu.daugmaz_sutampa == false ;
        % Pabandykim toki atveji: sutampa dalis nuosekliai einanciu 
        % tarpu tarp laiku
        for i=1:length(g.Tarpai_tarp_ivykiu.EEG) ;
            g.Tarpai_tarp_ivykiu.potencialios_atskaitos1{i,1} = transpose((intersect( find(g.Tarpai_tarp_ivykiu.LabChart <  g.Tarpai_tarp_ivykiu.EEG(i) + 2 * g.Leidziama_paklaida) , find( g.Tarpai_tarp_ivykiu.LabChart >  g.Tarpai_tarp_ivykiu.EEG(i) - 2 * g.Leidziama_paklaida  )))) ; 
        end;
        % tikrinti, ar du gretimi kaimynai sutampa
        g.Tarpai_tarp_ivykiu.potencialios_atskaitos2_max=0;
        for i=1:(length(g.Tarpai_tarp_ivykiu.EEG) - 1) ;
            g.Tarpai_tarp_ivykiu.potencialios_atskaitos2{i,1} = intersect(g.Tarpai_tarp_ivykiu.potencialios_atskaitos1{i} + 1 ,g.Tarpai_tarp_ivykiu.potencialios_atskaitos1{i+1}) - i ; 
            g.Tarpai_tarp_ivykiu.potencialios_atskaitos2_max = max( length(g.Tarpai_tarp_ivykiu.potencialios_atskaitos2{i,1}), g.Tarpai_tarp_ivykiu.potencialios_atskaitos2_max) ;
        end;
        g.Tarpai_tarp_ivykiu.potencialios_atskaitos3 = zeros(length(g.Tarpai_tarp_ivykiu.potencialios_atskaitos2) - 1,g.Tarpai_tarp_ivykiu.potencialios_atskaitos2_max) ;
        g.Tarpai_tarp_ivykiu.potencialios_atskaitos3(:) = 9999999999999999999999999999999999 ;
        % tikrinti, ar trys gretimi kaimynai sutampa
        for i=1:(length(g.Tarpai_tarp_ivykiu.potencialios_atskaitos2) - 1) ;
            tmp = intersect(g.Tarpai_tarp_ivykiu.potencialios_atskaitos2{i} ,g.Tarpai_tarp_ivykiu.potencialios_atskaitos2{i+1}) ;
            g.Tarpai_tarp_ivykiu.potencialios_atskaitos3(i,1:length(tmp)) = tmp ;
        end;
        g.Tarpai_tarp_ivykiu.potencialios_atskaitos4 = unique(g.Tarpai_tarp_ivykiu.potencialios_atskaitos3) ;
        g.Tarpai_tarp_ivykiu.potencialios_atskaitos4 = g.Tarpai_tarp_ivykiu.potencialios_atskaitos4(g.Tarpai_tarp_ivykiu.potencialios_atskaitos4 ~= 9999999999999999999999999999999999 ) ;
        if ~isempty(g.Tarpai_tarp_ivykiu.potencialios_atskaitos4) ;
            tmp = findseq(g.Tarpai_tarp_ivykiu.potencialios_atskaitos3(:,1)) ;
            tmp = tmp(find(ismember(tmp(:,1),g.Tarpai_tarp_ivykiu.potencialios_atskaitos4)),:) ;
            tmp = tmp(find(tmp(:,4) == max(tmp(:,4))),:) ;
            if ~isempty(tmp)
                g.Tarpai_tarp_ivykiu.daugmaz_sutampa = true ;
                % jei kartais butu kelios vienodai geros galimybes, tai pasirinkti pirmaji atskaitos taska
                tmp=tmp(1,:) ;
                g.Tarpai_tarp_ivykiu.pasirinkta_atskaita = tmp(1,1) - 1 ;
                % pagal atskaitos taska surasti atitinkamus LabChart ir EGG ivykius
                g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(1:tmp(1,4),1) = [ tmp(1,2):tmp(1,3) ]  ;
                g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(1:tmp(1,4),2) = [ tmp(1,2):tmp(1,3) ] + g.Tarpai_tarp_ivykiu.pasirinkta_atskaita ;
            end;
        end;
    end ;
    
    if g.Tarpai_tarp_ivykiu.daugmaz_sutampa ;
        % ir jei EGG ivykius atitinkantys Labchart ivykiai tikrai
        % nesikartoja (yra unikalus)
        if g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(:,2) == unique(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(:,2)) ;
            g.Tarpai_tarp_ivykiu.EEG_ir_Labchart_palyginimas = [ g.Tarpai_tarp_ivykiu.LabChart(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(1:length(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart)-1,2),1) g.Tarpai_tarp_ivykiu.EEG(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(1:length(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart)-1,1),1) ] ;
            % ans = [ g.Bendri.LabChart(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(1:length(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart)-1,2),2) g.Bendri.EEG(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(1:length(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart)-1,1),2) ] ;
            g.Poslinkis.kiekvieno = bsxfun(@minus,g.Bendri.LabChart(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(:,2),2),g.Bendri.EEG(g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(:,1),2)) ;
            g.Poslinkis.vidutinis = mean(g.Poslinkis.kiekvieno) ;
            g.Poslinkis.paklaidos = g.Poslinkis.kiekvieno - g.Poslinkis.vidutinis ;
            % Del visa pikto patikrinti galutini varianta:
            g.Poslinkis.max= max(g.Poslinkis.paklaidos) ;
            g.Poslinkis.min= min(g.Poslinkis.paklaidos) ;
            str=['Maksimalus nukrypimas buvo (ms):   ' num2str(g.Poslinkis.max) ] ; disp(str);
            str=['Minimalus  nukrypimas buvo (ms):   ' num2str(g.Poslinkis.min) ] ; disp(str);
            str=['Nustatyta leidziama paklaida (ms): ' num2str(g.Leidziama_paklaida) ] ; disp(str);
            if and(g.Poslinkis.max < g.Leidziama_paklaida , g.Poslinkis.min > 0 - g.Leidziama_paklaida ) ;
                str='Valio! Algoritmas rado sutampancius ivykius, nors ivykiu skaicius skiriasi!' ; disp(str);
            else
                str='Vidine klaida: dar reikia tobulinti algoritma, ieskanti atitinkanciu ivykiu net tada, kai ivykiu kiekis skiriasi. Bandykite padidinti didziausia leidziama paklaida.' ; 
                error(str);
                %return
            end ;
        else
            error('Nepavyko');            
            %return ;
        end;
    else
        error('Nepavyko');
        %return;
    end;
        
end ;

% Naujam ivykių sąrašui naudokim senuosius EEG
% ir pridėkim R ivykius iš LabChart
g.Nauji.R_laikai = cell2mat(g.listOfTimes.LC_R) ;
g.Nauji.R_laikai(:,2) = g.Nauji.R_laikai(:,2) - g.Poslinkis.vidutinis ;
for ri=1:size(g.Nauji.R_laikai,1);
    g.Nauji.R_latenc(ri,1)=FindTrigerTime(g.EEGlabTimes,g.Nauji.R_laikai(ri,2));
end;
g.Nauji.R_latenc(:,2)=zeros(size(g.Nauji.R_latenc));
g.Nauji.EEG=[g.EEGlabEvent.latency]';
g.Nauji.EEG(:,2)=1:(size(g.Nauji.EEG));
g.Nauji.Bendri =  sortrows( [ g.Nauji.EEG ; g.Nauji.R_latenc ] , 1 ) ; 
for i=1:length(g.Nauji.Bendri);
    if g.Nauji.Bendri(i,2) == 0;
        newEEGlabEvents(1,i).type    = g.New_R_event_type ;
        newEEGlabEvents(1,i).latency = g.Nauji.Bendri(i,1);
        newEEGlabEvents(1,i).duration= 0;
    else
        newEEGlabEvents(1,i)         = g.EEGlabEvent(g.Nauji.Bendri(i,2));
    end;
end ;

Poslinkis_vidutinis=g.Poslinkis.vidutinis;
Poslinkio_paklaidos=g.Poslinkis.paklaidos;



function [idx, closest]=FindTrigerTime(times,triger)
  tmp = abs(times-triger);
  [~, idx] = min(tmp); %index of closest value
  closest = times(idx); %closest value


