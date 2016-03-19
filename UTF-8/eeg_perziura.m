function eeg_perziura(varargin)
% eeg_perziura - EEG peržiūros/lyginimo varikliukas
%
% eeg_perziura(EEG)
% eeg_perziura(EEG1, EEG2)
%
% (C) 2015-2016 Mindaugas Baranauskas

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

try
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
            case {'zymejimas_prasideda'};
                eeg_zymejimas_prasideda(varargin{2:end});
            case {'zymejimas_tesiasi'};
                eeg_zymejimas_tesiasi(varargin{2:end});
            case {'zymejimas_baigiasi'};
                eeg_zymejimas_baigiasi(varargin{2:end});
            case {'gauk_zymejimo_sriti'};
                eeg_zymejimo_sriti_gauk(varargin{2:end});
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
catch err; 
    Pranesk_apie_klaida(err, '', '', 0);
    set(gcf,'pointer','arrow');
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

reikia_ribozenkliu=~isempty(getappdata(a,'reikia_ribozenkliu'));

if ~isempty(EEG1); disp('EEG1 perkeitimas...'); end;
EEG1=perkeisk_eeg2(EEG1, reikia_ribozenkliu);
if ~isempty(EEG2); disp('EEG2 perkeitimas...'); end;
EEG2=perkeisk_eeg2(EEG2, reikia_ribozenkliu);

sukeisk=0;
if EEG1.trials == 1 && EEG2.trials > 1 && length(EEG2.times)/EEG2.srate/EEG2.trials < length(EEG1.times)/EEG1.srate ;
    sukeisk=1;
elseif ~isempty(EEG2.times) && length(EEG1.times)/EEG1.srate > length(EEG2.times)/EEG2.srate && EEG1.trials <= EEG2.trials;
    sukeisk=1;
elseif EEG1.nbchan > EEG2.nbchan && length(EEG1.times)/EEG1.srate == length(EEG2.times)/EEG2.srate;
    sukeisk=1;
end;

if sukeisk; % EEG1 <-> EEG2
    EEG=EEG1; EEG1=EEG2; EEG2=EEG;
end;

if ~isempty(getappdata(a,'zymeti')) && EEG1.trials > 1 && EEG2.trials == 1;
    warning('zymeti == 1 && EEG1.trials > 1 && EEG2.trials == 1');
    setappdata(a, 'zymeti', []);
end;

% epochuotų duomenų langų suvienodinimas
if EEG1.trials > 1 && EEG2.trials > 1;
    trukme1=EEG1.xmax_org - EEG1.xmin_org;
    trukme2=EEG2.xmax_org - EEG2.xmin_org;
    skirtumas=1000*(trukme1-trukme2);
    if skirtumas > 0; 
        s1=skirtumas+1000/EEG1.srate-1000/EEG2.srate+EEG2.xmin-EEG1.xmin;
        for uniq_ep_i=find([EEG2.event.laikas_ms]>=EEG2.times(EEG2.pnts+1)); 
            EEG2.event(uniq_ep_i).laikas_ms=EEG2.event(uniq_ep_i).laikas_ms+s1*floor((EEG2.event(uniq_ep_i).laikas_ms/EEG2.times(EEG2.pnts+1)));
        end;
        for i=1:EEG2.trials-1; li=i*(EEG2.pnts+1);
            EEG2.times(li:end)=EEG2.times(li:end)+s1;
            EEG2.times_nan(li:end)=EEG2.times_nan(li:end)+s1;
        end;
        s2=min(skirtumas,1000*max(0,EEG2.xmin_org-EEG1.xmin_org));
        EEG2.times=EEG2.times+s2;
        for uniq_ep_i=find(ismember({EEG2.event.type},{'boundary'})==0); EEG2.event(uniq_ep_i).laikas_ms=[EEG2.event(uniq_ep_i).laikas_ms]+s2; end;
    elseif skirtumas < 0; 
        s1=0-skirtumas+1000*(1/EEG2.srate-1/EEG1.srate);
        for uniq_ep_i=find([EEG1.event.laikas_ms]>=EEG1.times(EEG1.pnts+1)); 
            EEG1.event(uniq_ep_i).laikas_ms=EEG1.event(uniq_ep_i).laikas_ms+s1*floor((EEG1.event(uniq_ep_i).laikas_ms/EEG1.times(EEG1.pnts+1)));
        end;
        for i=1:EEG1.trials-1; li=i*(EEG1.pnts+1); 
            %for ei=find([EEG1.event.laikas_ms]>=EEG1.times(li)); EEG1.event(ei).laikas_ms=[EEG1.event(ei).laikas_ms]+s1; end;
            EEG1.times(li:end)=EEG1.times(li:end)+s1;
            EEG1.times_nan(li:end)=EEG1.times_nan(li:end)+s1;
        end;
        s2=min(0-skirtumas,1000*max(0,EEG1.xmin_org-EEG2.xmin_org));
        EEG1.times=EEG1.times+s2;
        for uniq_ep_i=find(ismember({EEG1.event.type},{'boundary'})==0); EEG1.event(uniq_ep_i).laikas_ms=[EEG1.event(uniq_ep_i).laikas_ms]+s2; end;
    end;
    EEG1.xmin=0.001*min(EEG1.times); if isempty(EEG1.xmin); EEG1.xmin=NaN; end;
    EEG1.xmax=0.001*max(EEG1.times); if isempty(EEG1.xmax); EEG1.xmax=0; end;
end;

% epochuotų ir neepochuotų duomenų susiejimas
if isfield(EEG1.event, 'urevent') && isfield(EEG2.event, 'urevent');
    %assignin('base','EEG1',EEG1); assignin('base','EEG2',EEG2);
    urid1={EEG1.event.urevent}; urid1(arrayfun(@(i) isempty(urid1{i}), 1:length(urid1)))={NaN}; urid1=cell2mat(urid1);
    urid2={EEG2.event.urevent}; urid2(arrayfun(@(i) isempty(urid2{i}), 1:length(urid2)))={NaN}; urid2=cell2mat(urid2);
    urid1_sutampa_i=find(ismember(urid1,urid2));
    [~,urid2_sutampa_i]=ismember(urid1(urid1_sutampa_i),urid2);
    urid_sutampa_tipas1={EEG1.event(urid1_sutampa_i).type};
    urid_sutampa_tipas2={EEG2.event(urid2_sutampa_i).type};
    sutampa_ivykiai=0;
    if iscellstr(urid_sutampa_tipas1) && iscellstr(urid_sutampa_tipas2)
        if strcmp(urid_sutampa_tipas1,urid_sutampa_tipas2);
            sutampa_ivykiai=1;
        end;
    end;
    if sutampa_ivykiai;
        disp('EEG1 ir EEG2 sugretinimas...');
        sk=[EEG2.event(urid2_sutampa_i).laikas_ms] - [EEG1.event(urid1_sutampa_i).laikas_ms]; % sutampačių įvykių laikų poslinkiai        
        if EEG1.trials <= 1;
            if max(sk)-min(sk) < max(1000/EEG1.srate,1000/EEG2.srate);
                m=median(sk);
                EEG1.times=EEG1.times+m;
                EEG1.times_nan=EEG1.times_nan+m;
                for i=1:length(EEG1.event);
                    EEG1.event(i).laikas_ms=EEG1.event(i).laikas_ms+m;
                end;
            end;
        else            
            if EEG2.trials > 1;
                [plotis1,pli]=max([trukme1,trukme2]);
                if pli == 1; plotis1=plotis1+1/EEG1.srate; else plotis1=plotis1+1/EEG2.srate; end;
                epochu_poslinkiai=sk/1000/plotis1;
                sveikos_epochos_=arrayfun(@(i) epochu_poslinkiai(i) == round(epochu_poslinkiai(i)), 1:length(epochu_poslinkiai));
                sveikos_epochos=find(sveikos_epochos_);
                for nsvei=find(~sveikos_epochos_);
                    sk(nsvei)=sk(sveikos_epochos(find(sveikos_epochos>nsvei,1,'first')));
                end;
            end;
            epochos=[EEG1.event.epoch];
            epochos_sutampanciu=epochos(urid1_sutampa_i); %[EEG1.event(urid1_sutampa_i).epoch]; % sutampančių įvykių epochos
            [~,uniq_ep_i]=unique(epochos_sutampanciu); % įvykių indeksai, ties kuriais prasideda unikalios epochos
            urev=[];
            for ii=1:length(uniq_ep_i);
                i_nuo=uniq_ep_i(ii); % EEG1 ivykio, NUO kurio darbuojamės, indeksas sutampančių įvykių sąraše
                if ii == length(uniq_ep_i);
                    i_iki=uniq_ep_i(end); % EEG1 ivykio, IKI kurio darbuojamės, indeksas sutampančių įvykių sąraše
                else i_iki=uniq_ep_i(ii+1)-1;
                end;
                %disp(['[suti: ' num2str(i_nuo) ':' num2str(i_iki) '; urev:' num2str(urid1(urid1_sutampa_i(i_nuo))) ':' num2str(urid1(urid1_sutampa_i(i_iki))) ']']);
                if EEG2.trials > 1; eposl=sveikos_epochos_(i_nuo); else eposl=1; end;
                ti1=(epochos_sutampanciu(i_nuo)-eposl)*(EEG1.pnts+1)+1;
                ti2=(epochos_sutampanciu(i_iki))*(EEG1.pnts+1);
                %disp(['[xtšk: ' num2str(ti1) ':' num2str(ti2) ']']);
                EEG1.times(    ti1:ti2)=EEG1.times    (ti1:ti2) + sk(i_nuo);
                EEG1.times_nan(ti1:ti2)=EEG1.times_nan(ti1:ti2) + sk(i_nuo);
                
                for eii=unique(epochos_sutampanciu(i_nuo:i_iki));
                    % pereiname prie visų EEG1 įvykių
                    vis=find(epochos == eii);
                    %disp(['[vis: ' num2str(min(vis)) ':' num2str(max(vis)) ']']);
                    kartojasi=find(ismember(urid1(vis), urev));
                    if any(kartojasi);
                        besikartojantys=urid1(vis(kartojasi));
                        if EEG2.trials > 1;
                            vi1 =find(ismember(urid1,besikartojantys(1)));
                            vi1i=ismember(vi1,vis(kartojasi(1)));
                            vi2 =find(ismember(urid2,besikartojantys(1)));
                            vi2 =vi2(find(vi2>=vi1(vi1i),1,'first'));
                        else
                            vi2=find(ismember(urid2,besikartojantys(1)),1,'first');
                        end;
                        t2=EEG2.event(vi2).laikas_ms;
                        t1=EEG1.event(vis(kartojasi(1))).laikas_ms;
                        sk_=t2-t1;
                        if EEG2.trials > 1;
                            i_nuo_n=find(sk>sk_,1,'first');
                            if ~isempty(i_nuo_n);
                                sk(i_nuo)=sk(i_nuo_n);
                            end;
                        end;
                    else
                        sk_=sk(i_nuo);
                    end;
                    for vi=vis;
                        %disp([ num2str(eii) 'e ' num2str(vi) 'i [' num2str(EEG1.event(vi).urevent) '/' num2str(urid2(urid2_sutampa_i(i_nuo))) 'u]: ' EEG1.event(vi).type ' ' num2str(EEG1.event(vi).laikas_ms/1000) ' + ' num2str(sk_/1000) ' -> ' num2str((EEG1.event(vi).laikas_ms + sk_)/1000)]);
                        EEG1.event(vi).laikas_ms=EEG1.event(vi).laikas_ms + sk_;
                    end;
                    %disp('-');
                    urev=[urev EEG1.event(vis).urevent];
                end;
                %disp('--');
                
            end;
            ivTipai={EEG1.event.type};
            if EEG2.trials <= 1;
                EEG1.event(ismember(ivTipai,{'boundary'}))=[];
            end;            
        end;
        EEG1.xmin=0.001*min(EEG1.times); if isempty(EEG1.xmin); EEG1.xmin=NaN; end;
        EEG1.xmax=0.001*max(EEG1.times); if isempty(EEG1.xmax); EEG1.xmax=0; end;
    end;
end;

% Y mažinimo koeficientas
%disp('Tinkamo Y koeficiento radimas...');
data1=EEG1.data(~isnan(EEG1.data));
data2=EEG2.data(~isnan(EEG2.data));
if ~exist('rms','file') == 2 ;
    rms1=rms(data1);
    rms2=rms(data2);
else
    rms1=std(data1,[],1);
    rms2=std(data2,[],1);
end;
y_koef=round(36*sqrt(sqrt(mean([rms1(~isnan(rms1)) rms2(~isnan(rms2))]))));
if or(size(y_koef) ~= [1 1], ismember(y_koef, [0 NaN])) ; 
    y_koef=600 / max(EEG1.nbchan, EEG2.nbchan); 
end;
setappdata(a,'y_koef',y_koef);

if ~isempty(getappdata(a,'zymeti'));
    %assignin('base','EEG1',EEG1); assignin('base','EEG2',EEG2);
    disp('Aptinkami EEG1 ir EEG2 laiko atitikmenys...');
    if ~isequal(EEG1.times,EEG2.times);
        t=artimiausi(EEG1.times,EEG2.times,1000/min(EEG1.srate,EEG2.srate));
        if ~any(isnan(t));
            d=nan(size(EEG1.data,1),length(EEG2.times));
            d(:,t)=EEG1.data;
            EEG1.data=d;
            tnan=nan(1,length(EEG2.times));
            tnan(t)=EEG1.times_nan;
            EEG1.times_nan=tnan;
            EEG1.times=EEG2.times;
        else
            warning('zymeti == 1 && EEG1.times ~= EEG2.times');
            setappdata(a, 'zymeti', []);
        end;
    end;
end;
%assignin('base','EEG1',EEG1); assignin('base','EEG2',EEG2);

% Kanalų suderinimas
try    l1={EEG1.chanlocs.labels};
catch; l1=[1:EEG1.nbchan]; %arrayfun(@(i) sprintf('%d', i), [1:EEG1.nbchan], 'UniformOutput', false);
end;
try    l2={EEG2.chanlocs.labels};
catch; l2=[1:EEG2.nbchan]; %arrayfun(@(i) sprintf('%d', i), [1:EEG2.nbchan], 'UniformOutput', false);
end;
% assignin('base','l1',l1);
% assignin('base','l2',l2);
if isequal(l1,l2);
    set(a,'YTick', 1:length(l1));
    set(a,'YTickLabel', l1);
else
    if isempty(l2)
        if isempty(EEG2.data);
            set(a,'YTick', 1:length(l1));
            set(a,'YTickLabel', l1);
        else % FIXME
        end;
    elseif isempty(l1);
        if isempty(EEG1.data);
            set(a,'YTick', 1:length(l2));
            set(a,'YTickLabel', l2);
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
    %elseif % FIXME
            %isempty([EEG1.chanlocs.urchan]) && ~isempty([EEG2.chanlocs.urchan])
            %l1([EEG2.chanlocs.urchan])
    elseif length(l1) >= length(l2);
            set(a,'YTick', 1:length(l1));
            set(a,'YTickLabel', l1);
    else
            set(a,'YTick', 1:length(l2));
            set(a,'YTickLabel', l2);
    end;
end;

function idx=artimiausi(x1,x2,skirtumas)
x1=x1(:); if size(x1,1) == 1; x1=x1'; end;
x2=x2(:); if size(x2,1) == 1; x2=x2'; end;
[n,idx]=ismember(x1,x2);
if ~any(~n); return; end;
x1_=unique(x1);
[~,x1ir]=ismember(x1,x1_);
if isempty(which('knnsearch'));
    %[idx,D]=knnsearch(x2,x1);
    [idx_,D_]=knnsearch(x2,x1_); % jei dubliuojasi x1, šis variantas bus greitesnis
else
    warning('function "knnsearch" not found!');
    idx_=nan(size(x1_)); D_=idx_;
    l=length(x1_); %l=min(10000,l);
    % skaidyti, kad neviršytų MATLAB kintamųjų dydžio ribojimų
    zgsn=5000; % sumažink, jei randi klaidą: Out of memory. Type HELP MEMORY for your options.
    %tic;
    veiksena=isempty(which('dsearchn'));
    for z=1:ceil(l/zgsn);
        if mod(z,100) == 1; disp(' ');  end; fprintf('.');
        i=(zgsn*(z-1)+1):min((zgsn*(z)),l);
        x1__=x1_(i);
        k=find(x2 <= max(x1__)+skirtumas,1,'last');
        if ~isempty(k);
            x2_=x2(1:min(k+1,length(x2)));
            j=find(x2_ >= min(x1__)-skirtumas,1,'first');
            if ~isempty(j);
                x2__=x2_(max(j-1,1):end);
                if veiksena
                    C = abs(bsxfun(@minus,x2__,x1__')); [D1,idx1] = min(C(:,1:size(C,2)));
                else
                    [idx1,D1]=dsearchn(x2__,x1__);
                end;
                if ~isempty(idx1);
                    idx_(i)=idx1+max(j-1,1)-1;
                    D_(i)=D1;
                end;
            end;
        end;
    end;
    %disp(' '); toc;
end;
idx=idx_(x1ir);
D=D_(x1ir);
pertoli=find(D > skirtumas);
idx(pertoli)=nan(size(idx(pertoli)));

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
    try EEG1=varargin{1};
        EEG2=varargin{2};
        if isequal(EEG1.times,EEG2.times);
            setappdata(a,'reikia_ribozenkliu',1);
        else
            setappdata(a,'reikia_ribozenkliu',[]);
        end;
    catch; setappdata(a,'reikia_ribozenkliu',1);
    end;
    [EEG1,EEG2]=perkeisk_eeg(a, varargin{:});
end;
setappdata(a,'EEG1',EEG1);
setappdata(a,'EEG2',EEG2);

%Plotis
leisti_tarpus=0;
if     (EEG1.trials > 1) && isempty(EEG2.times);
    plotis1=(EEG1.xmax_org - EEG1.xmin_org);
elseif (EEG2.trials > 1) && isempty(EEG1.times);
    plotis1=(EEG2.xmax_org - EEG2.xmin_org);
elseif (EEG1.trials > 1) && (EEG2.trials > 1);
    if (EEG1.xmax_org - EEG1.xmin_org) == (EEG2.xmax_org - EEG2.xmin_org);
        plotis1=(EEG1.xmax_org - EEG1.xmin_org);
    else [plotis1,i]=max([(EEG1.xmax_org - EEG1.xmin_org),(EEG2.xmax_org - EEG2.xmin_org)]);
        if i==1; plotis1=plotis1+1/EEG1.srate; else plotis1=plotis1+1/EEG2.srate; end;
    end;
else plotis1=1;
     leisti_tarpus=1;
end;
plotis2=ceil(5/plotis1);
setappdata(a,'zingsnis',1/plotis2);
plotis=plotis1*plotis2;

% Riboženkliai
km=get(a,'UIContextMenu'); 
kmr=findobj(km,'Tag','Tarpas vietoj ribozenklio');
if ~leisti_tarpus;
     setappdata(a,'reikia_ribozenkliu',1);
     set(kmr,'Enable','off');
else set(kmr,'Enable','on');
end;
if isempty(getappdata(a,'reikia_ribozenkliu'));
     set(kmr,'Checked','on');
else set(kmr,'Checked','off');
end;
kmk=findobj(km,'Tag','Sukeisti');
if isempty(getappdata(a,'zymeti'));
     set(kmk,'Enable','on');
else set(kmk,'Enable','off');
end;
XLim_tmp=[min(EEG1.xmin,EEG2.xmin) max(EEG1.xmax,EEG2.xmax)];
if length(XLim_tmp) ~= 2 || isequal(XLim_tmp, [0 0]) || any(isnan(XLim_tmp));
    XLim=[0 5];
else
    XLim=[min(EEG1.xmin,EEG2.xmin)-plotis1 plotis1+max(EEG1.xmax,EEG2.xmax)];
end;
YLim=[0.1 max(EEG1.nbchan,EEG2.nbchan)+0.9];
set(a,'YLim',YLim);
set(findobj(f,'tag','scrollAx','userdata','y'),'YLim',YLim);
set(findobj(f,'tag','scrollAx','userdata','x'),'XLim',XLim);
scrl_a_x=findobj(f,'tag','scrollAx','userdata','x');
set(scrl_a_x,'YLim',[0 1]);
scrl_lin=findobj(scrl_a_x,'tag','scrollDataLine');
set(scrl_lin(1),'color','k','xdata',0.001*EEG1.times_nan,'ydata',2/3+zeros(size(EEG1.times)));
set(scrl_lin(2),'color','r','xdata',0.001*EEG2.times_nan,'ydata',1/2+zeros(size(EEG2.times)));
atnaujinti=1; try atnaujinti=g(1).atnaujinti; catch; end;


if atnaujinti;
    eeg_perziura_atnaujinti('x',min(EEG1.xmin,EEG2.xmin),'plotis',plotis);
end;


function eeg_perziura_sukurti(varargin)
%% Naujai kurti EEG peržiūrai
if nargin == 0; return; end;
try g=struct(varargin{3:end}); catch; end;
try    f=g(1).figure;
    if ~ismember(f,findobj('type','figure')); 
        f=figure('toolbar','none','menubar','none','units','normalized','outerposition',[0 0 1 1]); 
    end;
catch; f=figure;
end;
set(f,'pointer','watch'); drawnow;
try    a=g(1).axes; if ~isobject(a); a=gca; end;
catch; a=gca; % axes; % getappdata(f,'main_axes');
end;
cla(a);

try EEG1=varargin{1};
    EEG2=varargin{2};
    if isequal(EEG1.times,EEG2.times);
        setappdata(a,'reikia_ribozenkliu',1);
    end;
catch; setappdata(a,'reikia_ribozenkliu',1);
end;

[EEG1,EEG2]=perkeisk_eeg(a, varargin{:});

hold(a,'on');
p2=plot(a,[EEG2.xmin 0 EEG2.xmax],[1 NaN (EEG2.nbchan) ], 'hittest','off', 'color','r'); % , 'LineWidth', 1
p1=plot(a,[EEG1.xmin 0 EEG1.xmax],[1 NaN (EEG1.nbchan) ], 'hittest','off', 'color','k'); %[ 0 0 0.4]);
set(a,'YDir','reverse', 'TickDir', 'out', 'XGrid', 'on', 'XMinorGrid', 'off', 'XMinorTick', 'on');
setappdata(f,'parentAx',a);
setappdata(a,'EEG1',EEG1);
setappdata(a,'EEG2',EEG2);
setappdata(a,'grafikas1',p1);
setappdata(a,'grafikas2',p2);
setappdata(a,'MouseDragFnc','eeg_perziura(''atnaujinti'');');
setappdata(a,'MouseInMainAxesFnc', {@eeg_perziura,'atstatyk_pele'});
setappdata(a,'MouseOutMainAxesFnc',{@eeg_perziura,'atstatyk_pele'});


% Plotis ir ERP laiko žymekliai
leisti_tarpus=0;
plotis1=gauk_erp_ploti(EEG1,EEG2);
if isempty(plotis1);
    plotis1=1;
    leisti_tarpus=1;
else%if 1 == 0 % tai tik eksperimentavimui
    ERP_N=round(max(EEG1.xmax,EEG2.xmax)/plotis1);
    if isfield(EEG1, 'xmin_org');
        if isfield(EEG2, 'xmin_org');
            ERP_xmin=min([EEG1.xmin_org EEG2.xmin_org]);
        else
            ERP_xmin=EEG1.xmin_org;
        end;
    elseif isfield(EEG2, 'xmin_org');
        ERP_xmin=EEG2.xmin_org;
    else
        ERP_xmin=NaN;
    end;
    if ~isnan(ERP_xmin);
        ERP_x_0=plotis1 * (-1 + (1:ERP_N));
        ERP_m_lntl=[];
        ERP_x_lntl=[];
        ERP_x_zgsn=0.5;
        for ERP_x_i=[fix(ERP_xmin/ERP_x_zgsn):0 ceil(max(ERP_xmin/ERP_x_zgsn,1)):floor((ERP_xmin+plotis1)/ERP_x_zgsn)];
            tmp=ERP_x_0 - ERP_xmin + ERP_x_i * ERP_x_zgsn;
            ERP_x_lntl(end+1, 1:ERP_N)=tmp;
            ERP_m_lntl(end+1, 1:ERP_N)=zeros(1,ERP_N) + ERP_x_i * ERP_x_zgsn;
        end;
        if ~isequal(unique(ERP_x_lntl(:)), ERP_x_lntl(:));
            ERP_x_lntl1=ERP_x_lntl(1,1); ERP_x_lntl=ERP_x_lntl(2:end,:); ERP_x_lntl=[ERP_x_lntl1 ERP_x_lntl(:)'];
            ERP_m_lntl1=ERP_m_lntl(1,1); ERP_m_lntl=ERP_m_lntl(2:end,:); ERP_m_lntl=[ERP_m_lntl1 ERP_m_lntl(:)'];
        end;
        assignin('base','ERP_x_lntl',ERP_x_lntl)
        set(a, 'XTick', ERP_x_lntl(:));
        set(a, 'XTickLabel', ERP_m_lntl(:));
        set(a, 'XMinorTick', 'off', 'XMinorGrid', 'off');
    end;
end;
plotis2=ceil(5/plotis1);
setappdata(a,'zingsnis',1/plotis2);
plotis=plotis1*plotis2;

% Slikikliai
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
if isempty(EEG1.times);
    minx=0.001*min(min(EEG1.times_nan),min(EEG1.times_nan));
else
    minx=0.001*min(EEG1.times_nan);
end;
if isempty(minx);
    minx=0;
end;
%max(EEG1.nbchan,EEG2.nbchan)
scrl_lin1y=2/3+zeros(size(EEG1.times));
if isempty(getappdata(a,'zymeti'));
    scrl_lin2y=1/2+zeros(size(EEG2.times));
else
    n=find(isnan(EEG1.times-EEG1.times_nan)-isnan(EEG1.times));
    scrl_lin2y=nan(size(EEG2.times_nan));
    scrl_lin2y(n)=1/2+zeros(size(n));
end;
asis_pradine=gca;
axes(a);
scrollHandles = scrollplot2(a,'Axis','XY', ...
    'MinY', 0.2, ...
    'MaxY', max(EEG1.nbchan,EEG2.nbchan)+0.8, ...
    'MinX', minx, ...
    'MaxX', minx+5);
axes(asis_pradine);
XLim_tmp=[min(EEG1.xmin,EEG2.xmin) max(EEG1.xmax,EEG2.xmax)];
if length(XLim_tmp) ~= 2 || isequal(XLim_tmp, [0 0]) || any(isnan(XLim_tmp));
    XLim=[0 5];
else
    XLim=[min(EEG1.xmin,EEG2.xmin)-plotis1 plotis1+max(EEG1.xmax,EEG2.xmax)];
end;
set(scrollHandles(1),'XLim',XLim);
set(scrollHandles(2),'YLim',[0.1 max(EEG1.nbchan,EEG2.nbchan)+0.9]);
scrl_a_x=findobj(f,'tag','scrollAx','userdata','x');
set(scrl_a_x,'YLim',[0 1]);
scrl_lin=findobj(scrl_a_x,'tag','scrollDataLine');
if length(scrl_lin) > 1;
    set(scrl_lin(1),'color','k','xdata',0.001*EEG1.times_nan,'ydata',scrl_lin1y,'hittest','off');
    set(scrl_lin(2),'color','r','xdata',0.001*EEG2.times_nan,'ydata',scrl_lin2y,'hittest','off');
else
    warning('scrl_lin');
end;
setappdata(a,'scrl_lin',scrl_lin);

% Kontekstinis meniu
figura_pradine=gcf;
figure(f);
c=uicontextmenu('tag','kontekstinis_meniu');
figure(figura_pradine);
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
ribozenkliai_v=fastif(isempty(getappdata(a,'reikia_ribozenkliu')),'on','off');
ribozenkliai_g=fastif(leisti_tarpus,'on','off');

uimenu(c,'label',lokaliz('Tarpas vietoj ribozenklio'), 'Tag', 'Tarpas vietoj ribozenklio', ...
    'Checked',ribozenkliai_v, 'Enable', ribozenkliai_g, 'callback', [ ...
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
leisti_sukeisti=fastif(isempty(getappdata(a,'zymeti')),'on','off');
uimenu(c,'label','EEG1 <-> EEG2', 'Tag','Sukeisti', 'Enable',leisti_sukeisti, 'separator','on','callback', ...
    [ 'setappdata(gcf,''laikinas'',getappdata(gca,''EEG1'')); ' ...
    'setappdata(gca,''EEG1'', getappdata(gca,''EEG2'')); ' ...
    'setappdata(gca,''EEG2'', getappdata(gcf,''laikinas'')); eeg_perziura(''atnaujinti''); ' ...
    'scrl_lin=getappdata(gca,''scrl_lin'') ; setappdata(gcf,''laikinas'',get(scrl_lin(1),''color'')); ' ...
    'set(scrl_lin(1),''color'',get(scrl_lin(2),''color'')); set(scrl_lin(2),''color'',getappdata(gcf,''laikinas''));' ]);
%set(f,'UIContextMenu',c);
set(a,'UIContextMenu',c);

% Galutinis paruošimas
setappdata(f,'main_axes',a);
setappdata(f,'scrollHandles',scrollHandles);
eeg_perziura_atnaujinti('figure', f, 'axes', a, 'plotis', plotis);
setappdata(a,'ribu_trauka',0.2);
set(f,'KeyPressFcn','eeg_perziura(''atsakas'')');
set(f,'WindowScrollWheelFcn',{@eeg_perziura,'ratukas'});
if isempty(getappdata(a,'zymeti')); return; end;
set(a,'ButtonDownFcn', 'eeg_perziura(''zymejimas_prasideda'');');
setappdata(a,'MouseInMainAxesFnc',{@eeg_perziura, 'zymejimas_tesiasi'});
set(f,'WindowButtonUpFcn', 'eeg_perziura(''zymejimas_baigiasi'');');


function EEG=perkeisk_eeg2(EEG, reikia_ribozenkliu)
if isempty(EEG);
    [~, EEG] = pop_newset([],[],[]);
end;
if isfield(EEG, 'event_org');
     EEG.event=EEG.event_org;
else EEG.event_org=EEG.event;
end;
if isfield(EEG, 'times_org');
     EEG.times=EEG.times_org;
else EEG.times_org=EEG.times;
end;
dim3=size(EEG.data,3);
if dim3 > 1;
    dim1=size(EEG.data,1);
    EEG.data(:,end+1,:)=nan([dim1,1,dim3]);
    dim2=size(EEG.data,2);
    EEG.data=EEG.data(:,:);
    EEG.times=[0:(dim2-1)*dim3-1]/EEG.srate*1000; % ms
    EEG.times=reshape(EEG.times, dim2-1, dim3);
    EEG.times_nan=[EEG.times; nan(1,dim3)]; EEG.times_nan=EEG.times_nan(:)';
    EEG.times(end+1,:)=EEG.times(end,:)+0.5/EEG.srate*1000; EEG.times=EEG.times(    :)';
    EEG.xmin_org=EEG.xmin;
    EEG.xmax_org=EEG.xmax;
    for i=0:dim3;
        l=0.5 + i * dim2 - i; %  ...- i dėl to, kad įterpiam NaN gale
        j=find([EEG.event.latency] > l, 1, 'first');
        if isempty(j);
            j=1+length(EEG.event);
        else
            EEG.event(j+1:end+1) = EEG.event(j:end);
        end;
        EEG.event(j).type = 'boundary';
        EEG.event(j).latency  = l;
        EEG.event(j).duration = 0;
        EEG.event(j).urevent  = [];
    end;
    EEG.event(end).epoch  = EEG.event(end-1).epoch;
    EEG.xmin=0.001*min(EEG.times); if isempty(EEG.xmin); EEG.xmin=NaN; end;
    EEG.xmax=0.001*max(EEG.times); if isempty(EEG.xmax); EEG.xmax=0; end;
end;
EEG.xmin=0.001*min(EEG.times); if isempty(EEG.xmin); EEG.xmin=0; end;
EEG.xmax=0.001*max(EEG.times); if isempty(EEG.xmax); EEG.xmax=0; end;
if size(EEG.data,2) ~= length(EEG.times) && isfield(EEG, 'times_nan');
    EEG.data=EEG.data(:,~isnan(EEG.times_nan));
end;
[ivLaikai, ivTipai, ivRodykles, ~, EEG.times_bnd] = eeg_ivykiu_latenc(EEG, 'boundary', ~reikia_ribozenkliu);
for i=ivRodykles;
    EEG.event(i).laikas_ms=ivLaikai(i);
    EEG.event(i).type     =ivTipai{i};
end;
if dim3 <= 1 ;
    if ~reikia_ribozenkliu;
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
try
    EEG1=getappdata(parentAx,'EEG1');
    EEG2=getappdata(parentAx,'EEG2');
catch; return;
end;
if isempty(EEG1.data) && isempty(EEG2.data);
    for i=1:2;
    set(getappdata(parentAx,['grafikas' num2str(i)]),'XData', [], 'YData', []);
    delete(findobj(parentAx,'tag',['zymekliaiA' num2str(i)]));
    delete(findobj(parentAx,'tag',['zymekliaiB' num2str(i)]));
    end;
    return;
end;

parentAx_unt=get(parentAx,'units');
set(parentAx,'units','pixels');
parentAx_pos=get(parentAx,'position');
set(parentAx,'units',parentAx_unt);
try
    LY=get(parentAx, 'YLim');
    if LY(1) <= 0; LY(1)=0.01; end;
    LX=get(parentAx, 'XLim');
catch; return;
end;
% Pakeisti X ašies centravimą ir plotį
try cx=g(1).x;
catch
    cx=LX(1);
end;
try plotis=g(1).plotis;
    if ~isfield(g,'x'); g.x=[min(LX) min(LX)+plotis]; end;
catch
    plotis=(max(LX)-min(LX));
end;
plotis1=gauk_erp_ploti(EEG1,EEG2);
if ~isempty(plotis1);
    cx=plotis1*round(cx/plotis1);
    if plotis > 1.9*plotis1;
        plotis=plotis1*round(plotis/plotis1) ;
    else
        setappdata(parentAx,'zingsnis',1);
        if plotis < plotis1
            plotis=plotis1;
        end;
    end;
end;
if or(cx ~= LX(1), plotis ~= (max(LX)-min(LX))) ;
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
end;
try setappdata(parentAx,'y_koef',g(1).y_koef(1)); catch; end;

zymekliu_spalvosA={ [0 0.9 0] [0.8 0 0.8]}; % {'g' 'm'}
zymekliu_spalvosB={ 'b' [1 0.8 0]}; % {'g' 'm'}
zymekliu_sukeitimas=(EEG1.nbchan > EEG2.nbchan) && ~isempty(EEG2.times);
if ~isempty(getappdata(parentAx,'zymeti'));
   zymekliu_spalvosA=zymekliu_spalvosA([2 1]);
   zymekliu_spalvosB=zymekliu_spalvosB([2 1]);
   zymekliu_sukeitimas=1;
end;
if zymekliu_sukeitimas;
    zymekliu_kryptis={ 'right' 'left' };
else
    zymekliu_kryptis={ 'left' 'right' };
end;
zymekliai_pilni = isempty(EEG1.data) || isempty(EEG2.data) || ~isempty(getappdata(parentAx,'zymeti'));
% Matomų taškų atrinkimas
for i=[1 2];
    eval([ 'EEG=EEG' num2str(i) ';' ]);
    ix=find(EEG.times(EEG.times <= (LX(2)+2/EEG.srate)*1000) >= (LX(1)-2/EEG.srate)*1000);
    EEG.grafikoX=[0.001*EEG.times(ix) 0]; %disp([i min(EEG.grafikoX(1:end-1)) max(EEG.grafikoX(1:end-1))]);
    iy=[max(ceil(LY(1)),1):min(floor(LY(2)),EEG.nbchan)];
    EEG.grafikoY=EEG.data(iy,ix) ./ getappdata(parentAx,'y_koef');
    if isempty(getappdata(parentAx,'apversti'));
        EEG.grafikoY=-EEG.grafikoY;
    end;
    eval([ 'EEG' num2str(i) '=EEG;' ]);
end

% Y suderinimas tarp EEG1 ir EEG2
if ~isempty(getappdata(parentAx,'derinti_Y'))
    derinti_Y=1;
elseif zymekliai_pilni;
    derinti_Y=0;
elseif any(ismember(EEG1.grafikoX,EEG2.grafikoX));
    derinti_Y=2;
else
    derinti_Y=0;
end;
if derinti_Y
    d1=size(EEG1.grafikoY,1); grafikoX_tmp1=EEG1.grafikoX(1:end-1);
    d2=size(EEG2.grafikoY,1); grafikoX_tmp2=EEG2.grafikoX(1:end-1);
    suderintos_med=nan(max(d1,d2),1);
    for eil=1:max(d1,d2);
        grafikoY_tmp1=[]; if eil <= d1; grafikoY_tmp1=EEG1.grafikoY(eil,:); end;
        grafikoY_tmp2=[]; if eil <= d2; grafikoY_tmp2=EEG2.grafikoY(eil,:); end;
        med=[];
        if ~isempty(grafikoY_tmp1) && ~isempty(grafikoY_tmp2);
            if isequal(...
                    grafikoY_tmp1(ismember(grafikoX_tmp1,grafikoX_tmp2)),...
                    grafikoY_tmp2(ismember(grafikoX_tmp2,grafikoX_tmp1)));
                grafikoY_tmp=[grafikoY_tmp1 grafikoY_tmp2];
                med=median(grafikoY_tmp(~isnan(grafikoY_tmp)));
            elseif derinti_Y == 1;
                med=median(grafikoY_tmp2(~isnan(grafikoY_tmp2)));
            end;
        end;
        if ~isempty(med);
            suderintos_med(eil)=med;
        end;
    end;
end;

% atvaizdavimas grafiškai
for i=[1 2];
    eval([ 'EEG=EEG' num2str(i) ';' ]);
    for eil=1:size(EEG.grafikoY,1);
        EEG.grafikoX(eil,:)=EEG.grafikoX(1,:);
        grafikoY_tmp=EEG.grafikoY(eil,:);
        if derinti_Y;
            med=suderintos_med(eil);
            if isnan(med);
                med=median(grafikoY_tmp(~isnan(grafikoY_tmp)));
            end;
        else
            med=median(grafikoY_tmp(~isnan(grafikoY_tmp)));
        end;
        EEG.grafikoY(eil,:)=EEG.grafikoY(eil,:)-med+eil+ceil(LY(1))-1;
    end;
    EEG.grafikoY=[EEG.grafikoY nan(size(EEG.grafikoY,1),1)]';
    EEG.grafikoY=EEG.grafikoY(:)';
    EEG.grafikoX=EEG.grafikoX';
    EEG.grafikoX=EEG.grafikoX(:)';
    if ~isequal(size(EEG.grafikoY),size(EEG.grafikoX));
        EEG.grafikoY=nan(size(EEG.grafikoX));
    end;
    grafikas=getappdata(parentAx,['grafikas' num2str(i)]);
    set(grafikas,'XData', EEG.grafikoX, 'YData', EEG.grafikoY);
    delete(findobj(parentAx,'tag',['zymekliaiA' num2str(i)]));
    delete(findobj(parentAx,'tag',['zymekliaiB' num2str(i)]));
    if isfield(EEG.event, 'laikas_ms') %&& ~and( ~isempty(getappdata(parentAx,'zymeti')) , i == 1 );
        zi=find([EEG.event(find([EEG.event.laikas_ms] <= LX(2)*1000)).laikas_ms] >= LX(1)*1000);
        zx=0.001 * [EEG.event(zi).laikas_ms]'; zx_=[zx zx zx]'; zx_=zx_(:);
        if (isequal(i,1) - 0.5) * (0.5 - zymekliu_sukeitimas) > 0 ;
            if zymekliai_pilni; zyk=max(LY); else zyk=mean(LY); end;
            zy=[min(LY)+zeros(size(zx)) zyk*ones(size(zx)) nan(size(zx))]'; zyL=min(LY)-abs(diff(LY))/parentAx_pos(4)*5;
        else
            if zymekliai_pilni; zyk=min(LY); else zyk=mean(LY); end;
            zy=[zyk*ones(size(zx)) max(LY)*ones(size(zx)) nan(size(zx))]';  zyL=max(LY)+abs(diff(LY))/parentAx_pos(4)*5;
        end;
        zy=zy(:);
        zm={EEG.event(zi).type} ;
        %if iscellstr(zm);
            bi=ismember(zm,{'boundary'}); bi=[bi; bi; bi]; bi=bi(:); zm=strrep(zm,'boundary','');
            plot(parentAx, zx_(bi), zy(bi),'hittest','off','tag',['zymekliaiB' num2str(i)], 'color',zymekliu_spalvosB{i}, 'LineWidth', 2);
        %else bi=zeros(size(zx_));
        %end;
        if isempty(getappdata(parentAx,'nereikia_ivykiu'));
            plot(parentAx, zx_(~bi), zy(~bi),'hittest','off','tag',['zymekliaiA' num2str(i)], 'color',zymekliu_spalvosA{i}, 'LineWidth', 1);
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
pk=getappdata(ax,'zingsnis'); if isempty(pk); pk=0.2; end;
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
            lim_max=get(scrollHandles(1),'XLim');
            lim_dbr=get(ax,'XLim');
            lim_plt=(lim_dbr(2)-lim_dbr(1));
            switch ck
                case 'leftarrow'
                    %disp('<');
                    if any(ismember({'alt' 'control' 'shift'},modifiers));
                        lk=lk*5;
                    end;
                    lim_nj=max(lim_dbr(1) - lim_plt * pk, lim_max(1) - lim_plt * lk);
                    lim_nj=[lim_nj lim_plt + lim_nj];
                case 'rightarrow'
                    %disp('>');
                    if any(ismember({'alt' 'control' 'shift'},modifiers));
                        lk=lk*5;
                    end;
                    lim_nj=min(lim_dbr(2) + lim_plt * pk, lim_max(2) + lim_plt * lk);
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
            eeg_zymejimas_tesiasi;
        case {'subtract' 'hyphen' 'add'}
            switch diff(ismember({'shift' 'control'}, modifiers))
                case  1; asisR='x'; asisN=1;
                case -1; asisR='y'; asisN=2;
                otherwise
                    eeg_perziura_atsakas(ck,{'control'});
                    eeg_perziura_atsakas(ck,{'shift'});
                    return;
            end;
            lim_dbr=get(ax,[asisR 'lim']);
            lim_plt=(lim_dbr(2)-lim_dbr(1));
            switch ck
                case {'subtract' 'hyphen'}
                    lim_max=get(scrollHandles(asisN),[asisR 'lim']);
                    lim_nj1=max(lim_dbr(1) - lim_plt * 0.125, lim_max(1) - lim_plt * lk);
                    lim_nj2=min(lim_dbr(2) + lim_plt * 0.125, lim_max(2) + lim_plt * lk);
                    if asisN == 1 && strcmp(get(findobj(get(ax,'UIContextMenu'),'Tag','Tarpas vietoj ribozenklio'),'Enable'),'off');
                        pk=pk*0.8; if pk<0.2; pk=pk*2; end; setappdata(ax,'zingsnis',pk);
                    end;
                case 'add'
                    lim_nj1=lim_dbr(1) + lim_plt * 0.1;
                    lim_nj2=lim_dbr(2) - lim_plt * 0.1;
                    if asisN == 1 && strcmp(get(findobj(get(ax,'UIContextMenu'),'Tag','Tarpas vietoj ribozenklio'),'Enable'),'off');
                        pk=pk*1.25; if pk>0.5; pk=pk/2; end; setappdata(ax,'zingsnis',pk);
                    end;
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
        else lk=getappdata(ax,'zingsnis'); if isempty(lk); lk=0.2; end;
        end;
        lim_dbr=get(ax,[asisR 'lim']);
        lim_max=get(scrollHandles(asisN),[asisR 'lim']);
        lim_plt=(lim_dbr(2)-lim_dbr(1));
        if eventdata.VerticalScrollCount > 0; % Y ašis ir taip apversta
            lim_nj=min(lim_dbr(2) + lim_plt * lk, lim_max(2));% + lim_plt * 0.2);
            lim_nj=[lim_nj - lim_plt lim_nj];
            set(ax,[asisR 'lim'],lim_nj);
        else
            lim_nj=max(lim_dbr(1) - lim_plt * lk, lim_max(1));% - lim_plt * 0.2);
            lim_nj=[lim_nj lim_plt + lim_nj];
            set(ax,[asisR 'lim'],lim_nj);
        end;
    end;
catch %err; Pranesk_apie_klaida(err,mfilename,'',0);
end;
eeg_perziura_atnaujinti;
if asisN == 1 && ~ismember('control',modifiers);
    eeg_zymejimas_tesiasi;
end;


function eeg_zymejimas_prasideda(varargin)
% Shift   - leidžia tęsti žymėjimą net atleidus pelės klavišą iki kito spragtelėjimo
% Control - leidžia atžymėti gretimas pažymėtas epochas
a=getappdata(gcf,'main_axes');
try
    if ~isempty(getappdata(a,'nebaigta_zymeti'));
        setappdata(a,'nebaigta_zymeti',[]);
        return;
    end;
catch; return;
end;
x=get(a,'CurrentPoint');
if isempty(x); return; end;
x=x(1,1);
setappdata(a,'spragtelejimo_vieta',x);
if isempty(getappdata(a,'zymeti')); return; end;
modifiers=get(gcf,'currentModifier');
EEG1=getappdata(a,'EEG1');
EEG2=getappdata(a,'EEG2');
[~,xi]=min(abs(EEG1.times-1000*x));
ni=find(isnan(EEG1.times-EEG1.times_nan)-isnan(EEG1.times));
if isfield(EEG1.event,'type');
    ribu_ms1=[EEG1.event(ismember({EEG1.event.type},{'boundary'})).laikas_ms];
    ribu_ms2=[EEG2.event(ismember({EEG2.event.type},{'boundary'})).laikas_ms];
    ribu_ms=unique([ribu_ms1 ribu_ms2]);
    [~,ri]=min(abs(ribu_ms-1000*x)); r=0.001*(ribu_ms(ri));
end;
if ismember(xi,ni) && ~ismember('shift', modifiers)...
        && x > EEG1.xmin && x < EEG1.xmax ...
        && (~ismember({'alt'}, get(gcf, 'SelectionType')) || ismember('control', modifiers));
    if EEG1.trials <= 1 || ismember('control', modifiers) || isempty(ri);
        d=[diff(ni) 0];
        di=find(d > 2);
        [~,xii1]=find(ni(di) <= xi, 1, 'last');
        [~,xii2]=find(ni(di) >= xi, 1, 'first');
        if isempty(xii1); xi1=ni(1);   else xi1=ni(di(xii1)+1); end;
        if isempty(xii2); xi2=ni(end); else xi2=ni(di(xii2)-1); end;
    else
        [~,xi1]=min(abs(EEG1.times-ribu_ms(ri)));
        ribu_ms=setdiff(ribu_ms,ribu_ms(ri));
        [~,qi]=min(abs(ribu_ms-1000*x));
        [~,xi2]=min(abs(EEG1.times-ribu_ms(qi)));
        if xi1 > xi2; xi3=xi1; xi1=xi2; xi2=xi3; end;
    end;
    %disp([EEG1.times(xi1) EEG1.times(xi2)] * 0.001) % jau pažymėtas intervalas ms
    EEG1.times_nan(xi1:xi2)=EEG1.times(xi1:xi2);
    EEG1.data(:,xi1:xi2)=EEG2.data(:,xi1:xi2);
    scrl_lin=getappdata(a,'scrl_lin');
    set(scrl_lin(1),'xdata',0.001*EEG1.times_nan);
    scrl_lin2y=get(scrl_lin(2),'ydata'); scrl_lin2y(xi1:xi2)=nan(1,length(xi1:xi2));
    set(scrl_lin(2),'ydata',scrl_lin2y);
    setappdata(a,'spragtelejimo_vieta',[]);
    setappdata(a,'EEG1',EEG1);
    eeg_perziura_atnaujinti;
    return;
end;
setappdata(a,'EEG1_',EEG1);
if ~isfield(EEG1.event,'type'); return; end;
if abs(x-r) <= getappdata(a,'ribu_trauka');
    setappdata(a,'spragtelejimo_vieta',r);
end;
if EEG1.trials > 1 && x > EEG1.xmin && x < EEG1.xmax ...
        && (~ismember({'alt'}, get(gcf, 'SelectionType')) || ismember('control', modifiers)) ;
    ribu_ms=setdiff(ribu_ms,ribu_ms(ri));
    [~,qi]=min(abs(ribu_ms-1000*x)); q=0.001*(ribu_ms(qi));
    eeg_zymejimas_tesiasi('x1',r,'x2',q);
    setappdata(a,'EEG1_',getappdata(a,'EEG1'));
end;

function eeg_zymejimas_tesiasi(varargin)
g=struct(varargin{:});
a=getappdata(gcf,'main_axes');
try
    if isempty(getappdata(a,'zymeti')); return; end;
catch; return;
end;
if ~ismember(get(gcf, 'SelectionType'),{'normal' 'extend' 'open'}); % su Shift arba be jokių
    setappdata(a,'spragtelejimo_vieta',[]);
    return;
end;

if isfield(g, 'x1'); x1=g.x1;
else x1=getappdata(a,'spragtelejimo_vieta');
end;
if isempty(x1); return; end;
EEG1=getappdata(a,'EEG1_');
EEG2=getappdata(a,'EEG2');
if isfield(g, 'x2'); x2=g.x2;
else x2=get(a,'CurrentPoint'); x2=x2(1,1);
    if isfield(EEG1.event,'type');
        ribu_ms1=[EEG1.event(ismember({EEG1.event.type},{'boundary'})).laikas_ms];
        ribu_ms2=[EEG2.event(ismember({EEG2.event.type},{'boundary'})).laikas_ms];
        ribu_ms=unique([ribu_ms1 ribu_ms2]);
        [~,i]=min(abs(ribu_ms-1000*x2)); r=0.001*(ribu_ms(i));
        if isempty(i);
            %nekeisti x2
        elseif EEG1.trials > 1;
            if x1 < x2 && i < length(ribu_ms);
                x2=0.001*(ribu_ms(i + (x2 > r) ));
            elseif x1 > x2 && i > 1;
                x2=0.001*(ribu_ms(i - (x2 < r)));
            else
                x2=r;
            end;
        elseif abs(x2-r) <= getappdata(a,'ribu_trauka'); 
            x2=r;
        end;
    end;
end;
if x1 > x2; x3=x1; x1=x2; x2=x3; end;
ix=find(EEG1.times(EEG1.times <= x2*1000) >= x1*1000);
EEG1.data(:,ix)=nan(size(EEG1.data,1),length(ix));
EEG1.times_nan(ix)=NaN(1,length(ix));
setappdata(a,'EEG1',EEG1);
n=find(isnan(EEG1.times-EEG1.times_nan)-isnan(EEG1.times));
scrl_lin=getappdata(a,'scrl_lin');
set(scrl_lin(1),'xdata',0.001*EEG1.times_nan);
scrl_lin2y=nan(size(EEG2.times_nan));
scrl_lin2y(n)=max(EEG1.nbchan,EEG2.nbchan)*1/2+zeros(size(n));
set(scrl_lin(2),'ydata',scrl_lin2y);
setappdata(a,'derinti_Y',1);
eeg_perziura_atnaujinti;

function eeg_zymejimas_baigiasi
try
    a=getappdata(gcf,'main_axes');
catch; return;
end;
if ismember('shift', get(gcf,'currentModifier')); 
    setappdata(a,'nebaigta_zymeti',1);
end;
if ~isempty(getappdata(a,'nebaigta_zymeti')); return; end;
setappdata(a,'spragtelejimo_vieta',[]);
if isempty(getappdata(a,'zymeti')); return; end;

function [laikas]=eeg_zymejimo_sriti_gauk(varargin)
% Lauti pažymėtos srities intervalus, sekundėmis
laikas=[];
a=getappdata(gcf,'main_axes');
try
    if isempty(getappdata(a,'zymeti')); return; end;
catch; return;
end;
EEG1=getappdata(a,'EEG1');
n=isnan(EEG1.times-EEG1.times_nan)-isnan(EEG1.times);
ni=find( n);
ne=find(~n);
if ~any(ni); return; end;
di1=find([diff(ni) 0] > 1); d1=ni([1 di1 end]);
di2=find([diff(ne) 0] > 1); d2=ne(di2)+1;
d=unique([d1 d2]);
laikai=EEG1.times(d)*0.001;
if mod(length(laikai),2); laikai=unique([laikai EEG1.times(ne(end))*0.001]); end;
laikai=reshape(laikai,2,length(laikai)/2)'

function plotis1=gauk_erp_ploti(EEG1,EEG2)
% Vienos epochos plotis
x_ribos_org1=isfield(EEG1, 'xmax_org') && isfield(EEG1, 'xmin_org');
x_ribos_org2=isfield(EEG2, 'xmax_org') && isfield(EEG2, 'xmin_org');
if     (EEG1.trials > 1) && isempty(EEG2.times) && x_ribos_org1;
    plotis1=(EEG1.xmax_org - EEG1.xmin_org) + 1/EEG1.srate;
elseif (EEG2.trials > 1) && isempty(EEG1.times) && x_ribos_org2;
    plotis1=(EEG2.xmax_org - EEG2.xmin_org) + 1/EEG1.srate;
elseif (EEG1.trials > 1) && (EEG2.trials > 1) && x_ribos_org1 && x_ribos_org2;
    if (EEG1.xmax_org - EEG1.xmin_org) == (EEG2.xmax_org - EEG2.xmin_org);
        plotis1=(EEG1.xmax_org - EEG1.xmin_org) + 1/EEG1.srate;
    else [plotis1,i]=max([(EEG1.xmax_org - EEG1.xmin_org),(EEG2.xmax_org - EEG2.xmin_org)]);
        if i==1; plotis1=plotis1+1/EEG1.srate; else plotis1=plotis1+1/EEG2.srate; end;
    end;
else plotis1=[];
end;
