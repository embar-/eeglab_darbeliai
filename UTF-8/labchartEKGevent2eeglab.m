function [newEEGlabEvents,Poslinkis_vidutinis,Poslinkio_paklaidos] = labchartEKGevent2eeglab(varargin)
% labchart event to eeglab event. 
% Script is suitable for numeric events, 
% so 300 temporaly will be marker for R wave and only in the end it will be replaced with string
%
% usage:
%  newEEGlabEvents = LabchartEventToEEGLAB('EEGlabTimes', EEG.times, 'EEGlabEvent', EEG.event, 'LabchartCom', com, 'LabchartComtext', comtext, 'LabchartTickrate', tickrate); 
%
% (c) 2014 Aleksas Voicikas
% (c) 2014 Mindaugas Baranauskas

%argumentu tvarkymas
if ~isempty(varargin)
g = struct(varargin{:});
else
    g=[];
end;

try g.EEGlabEvent; catch, error('no EEGlabevents'); end;
try g.SaveDir; catch, g.SaveDir =0; end;
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

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sekanti eilute tik testavimui:
% g= [] ; g.LabchartCom = com ; g.LabchartComtext = comtext ; g.LabchartTickrate = tickrate ; g.EEGlabTimes = EEG.times ; g.EEGlabEvent =  EEG.event ;


% LabChart programa, lyginant su EEG, turi tendencija kiekviena paskesni
% ivyki vis truputeli veliau pazymeti, todel per mazdaug 5 minutes
% susidaro net 8 milisekundziu LabChart nuskubejimas (EEG atsilikimas),
% be to ir pats issibarstymas gali siekti iki ~5 ms

g.Labchart_laiko_daugiklis =  902076 / 902101 ;
g.Leidziama_paklaida = 7 ; % milisekundemis
g.papildomai_atmesti_ivykius = [] ;

newEEGlabEvents = struct('type', {}, 'value', {}, 'latency' ,{}, 'duration', {}, 'urevent', {});
g.Poslinkis.paklaidos=[];
Poslinkis_vidutinis=[];
Poslinkio_paklaidos=[];

[colCom, ~] = size(g.LabchartCom);
colEEGlab = length(g.EEGlabEvent);

g.listOfTimes = {} ;

%%

% Pereik per EEGLab ivykius, kurie potencialiai bendri su LabChart 

iList = 1;
g.listOfTimes.EEG={};
for icolEEGlab = 1:colEEGlab ;
    tipas=g.EEGlabEvent(1,icolEEGlab).type;
    if isnumeric(tipas);
        EventName=num2str(tipas);
    else
        EventName=deblank(tipas);
    end
    if isstrprop(EventName, 'digit') ;
        EventName = str2num(EventName);
        %if  ( EventName ~= 0 ) ;
        %  if ( EventName ~= 300 ) ;
            g.listOfTimes.EEG{iList,1} = EventName;
            g.listOfTimes.EEG{iList,2} = g.EEGlabTimes(single(g.EEGlabEvent(1,icolEEGlab).latency ));    
            % aternatyva galetu buti (tik vietoj 512 butu EEG.srate reiksme): 
            % g.listOfTimes.EEG{iList,2} = g.EEGlabEvent(1,icolEEGlab).latency  * 1000 / 512 ; 
            try 
                g.listOfTimes.EEG{iList,3} = g.EEGlabEvent(1,icolEEGlab).urevent ; 
            catch, 
                g.listOfTimes.EEG{iList,3} = 0; 
            end;
            iList = iList+1;
        %  end ;
        %end;
    end;
end ;
if isempty(g.listOfTimes.EEG);
    error('Neradome tinkamų EEG įvykių');
end;
g.Unikalus_kodai.EEG=     unique(cell2mat(g.listOfTimes.EEG(     :,1)));

%%
% Pereik per LabChart ivykius, kurie potencialiai bendri su EEGLab

LabChart_TXT_events=(g.LabchartComtext(g.LabchartCom(  find(g.LabchartCom(:,4) == 2), 5) ,1:3));
LabChart_TXT_events_=unique(cellfun(@(i) LabChart_TXT_events(i,:), num2cell(1:length(LabChart_TXT_events)),'UniformOutput', false ));
if ismember('ECG', LabChart_TXT_events_);
   LabChart_key='ECG';
elseif ismember('HRV', LabChart_TXT_events_);
   LabChart_key='HRV';
else
   LabChart_key='';
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

iList = 1;
g.listOfTimes.LabChart={};
for icomMain = [find(g.LabchartCom(:,2)==blokas)]' ; % 1: colCom ;
    comtextMark = g.LabchartCom(icomMain, 5);
    comtextMark = g.LabchartComtext(comtextMark,:);
    comtextMark = deblank(comtextMark);
    
    % LabChart rupimi duomenys (R danteliai) apibudinti tekstu, 
    % o tarp LabChart ir EEG bandri ivykiai yra skaiciai
    if isstrprop(comtextMark, 'digit') ;
      % LabChart 0 ivyki koduokim kaip 299
      comtextMark = str2num(comtextMark) ;
      if comtextMark == 0 ; 
          comtextMark = 299 ;
      end ; 
       % Pasitaike irasas, kuriame buvo 255 kodas, bet neaisku, kas tai
       %if ( comtextMark ~= 255 ) ;
        % LabChart ivykio laikas, milisekundemis
        g.listOfTimes.LabChart{iList,1} = comtextMark ;
        g.listOfTimes.LabChart{iList,2} = g.LabchartCom(icomMain,3) * ( 1000 / g.LabchartTickrate ) * g.Labchart_laiko_daugiklis ;
        iList = iList+1;
       %end ;
    else 
        is_LabChart_key=0;
        if and(length(comtextMark) > 2, ~isempty(LabChart_key))
           if strcmp(comtextMark(1:3),LabChart_key);
              is_LabChart_key=1;
           end;
        end;
        if is_LabChart_key
           % R dantelius laikinai zymesime 300 .        
           g.listOfTimes.LabChart{iList,1} = 300 ; % g.New_R_event_type ;
           g.listOfTimes.LabChart{iList,2} = g.LabchartCom(icomMain,3) * ( 1000 / g.LabchartTickrate ) * g.Labchart_laiko_daugiklis ;
           iList = iList+1;
        end;
    end ;
end ;
if isempty(g.listOfTimes.LabChart);
    error('Neradome tinkamų LabChart įvykių');
end;
g.Unikalus_kodai.LabChart=unique(cell2mat(g.listOfTimes.LabChart(:,1)));

%%

g.Unikalus_kodai.bendri=intersect(g.Unikalus_kodai.LabChart,g.Unikalus_kodai.EEG) ;

% jei nera bendru, tai grazinkim tuscia
if isempty(g.Unikalus_kodai.bendri) ;
    % newEEGlabEvents = g.EEGlabEvent ;
    error('Neradome bendrų įvykių');
    %return ;
end ;

g.Bendri.LabChart = cell2mat(g.listOfTimes.LabChart(find(ismember(cell2mat(g.listOfTimes.LabChart(:,1)), g.Unikalus_kodai.bendri)),:) );
g.Bendri.EEG      = cell2mat(g.listOfTimes.EEG     (find(ismember(cell2mat(g.listOfTimes.EEG(     :,1)), g.Unikalus_kodai.bendri)),:) ) ;
[g.Bendri.LabChart_dydis, ~] = size(g.Bendri.LabChart) ;
[g.Bendri.EEG_dydis, ~] = size(g.Bendri.EEG) ;

% Nagrineti du g.Unikalus_kodai.bendri atvejus: 
% 1) kai yra vienas besikartojantis ivykio kodas
% 2) kai yra skirtingi kodai, bet jie nesikartoja

g.TaiPaprastasAtvejis = false ;

if length(g.Unikalus_kodai.bendri) == 1 ;
% 1) kai yra vienas besikartojantis ivykio kodas    
    if g.Bendri.LabChart_dydis == g.Bendri.EEG_dydis ;
        g.TaiPaprastasAtvejis = true ; 
    % jeigu yra vienas besikartojantis kodas, bet skiriasi kiekis LabChart ir EEG - 
    % dar bus galima zaisti su poslinkiais...
    end;
    
% 2) kai yra skirtingi kodai, bet jie nesikartoja ir issirikiave taip pat
elseif and(and ( g.Bendri.LabChart_dydis == length(g.Unikalus_kodai.bendri), g.Bendri.EEG_dydis == length(g.Unikalus_kodai.bendri)), g.Bendri.LabChart(:,1) == g.Bendri.EEG(:,1)) ; 
    g.TaiPaprastasAtvejis = true ;
    g.papildomai_atmesti_ivykius = [ g.papildomai_atmesti_ivykius 299 ] ;
    
% atveju nenagrinekim (teoriskai galetu keli kodai kartotis; ju kiekis gali buti vienodas arba ne)
else return ;    
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
            g.Tarpai_tarp_ivykiu.daugmaz_sutampa = true ;
            tmp = findseq(g.Tarpai_tarp_ivykiu.potencialios_atskaitos3(:,1)) ;
            tmp = tmp(find(ismember(tmp(:,1),g.Tarpai_tarp_ivykiu.potencialios_atskaitos4)),:) ;
            tmp = tmp(find(tmp(:,4) == max(tmp(:,4))),:) ;
            % jei kartais butu kelios vienodai geros galimybes, tai pasirinkti pirmaji atskaitos taska
            tmp=tmp(1,:) ; 
            g.Tarpai_tarp_ivykiu.pasirinkta_atskaita = tmp(1,1) - 1 ;
            % pagal atskaitos taska surasti atitinkamus LabChart ir EGG ivykius
            g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(1:tmp(1,4),1) = [ tmp(1,2):tmp(1,3) ]  ;
            g.Tarpai_tarp_ivykiu.EEG_tinka_LabChart(1:tmp(1,4),2) = [ tmp(1,2):tmp(1,3) ] + g.Tarpai_tarp_ivykiu.pasirinkta_atskaita ;
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
    

% Naujam ivykiu sarasui naudokim senuosius EEG
% ir pridekim trukstamus is % LabChart (isskyrus 200:230 sriti )
g.Nauji.LabChart = cell2mat(g.listOfTimes.LabChart(find(ismember(cell2mat(g.listOfTimes.LabChart(:,1)), [ g.Unikalus_kodai.bendri ; g.papildomai_atmesti_ivykius ] ) == 0  ),:)) ;
g.Nauji.LabChart(:,2) = g.Nauji.LabChart(:,2) - g.Poslinkis.vidutinis ; 
g.Nauji.LabChart(:,3) = 0 ;
g.Nauji.EEG = cell2mat(g.listOfTimes.EEG(find(ismember(cell2mat(g.listOfTimes.EEG(:,1)), [200:230] ) == 0  ),:)) ;
g.Nauji.Bendri =  sortrows( [ g.Nauji.EEG ; g.Nauji.LabChart ] , 2 ) ; 
[g.Nauji.dydis, ~ ] = size(g.Nauji.Bendri) ;

for icom=1:g.Nauji.dydis ;
    if g.Nauji.Bendri(icom,1) == 300;
        newEEGlabEvents(1,icom).type    = g.New_R_event_type ;
    elseif g.Nauji.Bendri(icom,1) == 299;
        newEEGlabEvents(1,icom).type    = '0' ;
    else
        newEEGlabEvents(1,icom).type    = num2str(g.Nauji.Bendri(icom,1)) ;
    end;    
    [idx, ~]=FindTrigerTime(g.EEGlabTimes,g.Nauji.Bendri(icom,2));
    newEEGlabEvents(1,icom).latency = idx ;
    if g.Nauji.Bendri(icom,3) > 0 ;
        newEEGlabEvents(1,icom).urevent = g.Nauji.Bendri(icom,3) ;
    else
        newEEGlabEvents(1,icom).urevent = '' ;
    end;
end ;



Poslinkis_vidutinis=g.Poslinkis.vidutinis;
Poslinkio_paklaidos=g.Poslinkis.paklaidos;



function [idx, closest]=FindTrigerTime(times,triger)
  tmp = abs(times-triger);
  [idy idx] = min(tmp); %index of closest value
  closest = times(idx); %closest value


