function [rez]=ECR_Labchart(com,comtext,tickrate)

rez=[];

g.LabchartCom=com;
g.LabchartComtext=comtext;
g.LabchartTickrate=tickrate;

LabChart_tkst_iv=(g.LabchartComtext(g.LabchartCom(  find(g.LabchartCom(:,4) == 2), 5) ,1:3));
LabChart_tkst_iv_=unique(cellfun(@(i) LabChart_tkst_iv(i,:), num2cell(1:length(LabChart_tkst_iv)),'UniformOutput', false ));
if ismember('ECG', LabChart_tkst_iv_);
   LabChart_EKG_raktas='ECG';
elseif ismember('HRV', LabChart_tkst_iv_);
   LabChart_EKG_raktas='HRV';
%elseif ~isempty(LabChart_tkst_iv_);
%   LabChart_EKG_raktas=LabChart_tkst_iv_{1};
else
    LabChart_EKG_raktas='';
%    error('LabChart_EKG_raktas=?');
end;

Labchart_skaitiniu_ivykiu_idx=find(g.LabchartCom(:,4)==1);
LabChart_sktm_iv=(g.LabchartComtext(g.LabchartCom(Labchart_skaitiniu_ivykiu_idx, 5), 1:3));
LabChart_sktm_iv_=unique(cellfun(@(i) LabChart_sktm_iv(i,:), num2cell(1:length(LabChart_sktm_iv)),'UniformOutput', false ));


% Vienas kanalas gali turėti kelis blokus, 
% jei įrašymas buvo sustabdytas, o po to toliau įrašinėta
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
    return;
    error('LabChart įraše nėra skaičiais užkoduotų įvykių!');
end;

if length(g.LabchartTickrate) > 1;
   g.LabchartTickrate=g.LabchartTickrate(blokas);
end;


iList = 1;
g.LabChart_QRS=[];
for icomMain = [find(g.LabchartCom(:,2)==blokas)]' ; % 1: colCom ;
    comtextMark = g.LabchartCom(icomMain, 5);
    comtextMark = g.LabchartComtext(comtextMark,:);
    comtextMark = deblank(comtextMark);
    % LabChart R danteliai apibudinti tekstu, o ivykiai yra skaiciai
    if ~isempty(find(isstrprop(comtextMark, 'digit')==0));
        is_LabChart_EKG_raktas=0;
        if and(length(comtextMark) > 2, ~isempty(LabChart_EKG_raktas))
           if strcmp(comtextMark(1:3),LabChart_EKG_raktas);
              is_LabChart_EKG_raktas=1;
           end;
        end;
        if is_LabChart_EKG_raktas  
            %laikas, milisekundemis
           g.LabChart_QRS(iList,1) = g.LabchartCom(icomMain,3) * ( 1000 / g.LabchartTickrate ) ;%* g.Labchart_laiko_daugiklis ;
           iList = iList+1;
        end;
    end ;
end ;
g.LabChart_QRS(1,2:3) = NaN;
% skirtumai, milisekundemis
g.LabChart_QRS(2:end,2) = diff(g.LabChart_QRS(:,1));
% skirtumai, k/min
g.LabChart_QRS(2:end,3) = 1000 * 60 ./ g.LabChart_QRS(2:end,2);

iList = 1;
g.LabChart_iv={};
for icomMain = [find(g.LabchartCom(:,2)==blokas)]' ; % 1: colCom ;
    comtextMark = g.LabchartCom(icomMain, 5);
    comtextMark = g.LabchartComtext(comtextMark,:);
    comtextMark = deblank(comtextMark);
    
    % LabChart R danteliai apibudinti tekstu, 
    % o ivykiai yra skaiciai
    if isstrprop(comtextMark, 'digit') ;
      comtextMark = str2num(comtextMark) ;
        % LabChart ivykis
        g.LabChart_iv{iList,1} = comtextMark ;
        % LabChart ivykio laikas, milisekundemis
        g.LabChart_iv{iList,2} = g.LabchartCom(icomMain,3) * ( 1000 / g.LabchartTickrate ) ;% * g.Labchart_laiko_daugiklis ;
        % ŠR prieš įvykį
        iki_idx=find(g.LabChart_iv{iList,2} >= g.LabChart_QRS(:,1));
        po_idx=find(g.LabChart_iv{iList,2} < g.LabChart_QRS(:,1));
        po_idx=po_idx(find(g.LabChart_iv{iList,2} + (7 * 1000) >= g.LabChart_QRS(po_idx,1)));
        if ~isempty(iki_idx);
            idx=[iki_idx(end) ; po_idx];
            g.LabChart_iv{iList,3} = g.LabChart_QRS(iki_idx(end),3);
            g.LabChart_iv{iList,4} = (g.LabChart_QRS(idx,1) - g.LabChart_iv{iList,2} ) / 1000 ;
            g.LabChart_iv{iList,5} = g.LabChart_QRS(idx,3) - g.LabChart_iv{iList,3} ;
            if g.LabChart_iv{iList,4}(end) < 5;
                g.LabChart_iv=g.LabChart_iv(1:(iList-1),:);
            else
                iList = iList+1;
            end;
        else            
            g.LabChart_iv=g.LabChart_iv(1:(iList-1),:);
        end;
    end ;
end ;

ivykiai=[g.LabChart_iv{:,1}];
rez.ivykiai=unique(ivykiai);
rez.X = linspace(-0.5,6,56);
for ivdx=1:length(rez.ivykiai);
    iv=rez.ivykiai(ivdx);
    Y = [] ;
    for i=find(ismember([g.LabChart_iv{:,1}],iv)) ; Y(end+1,1:length(rez.X))=interp1(g.LabChart_iv{i,4},g.LabChart_iv{i,5},rez.X); end ;
    rez.Y{ivdx}=mean(Y);
end;

%%

%return ;

%%

spalvos='rgbcmyk';
figure; hold('on');

for ivdx=1:length(rez.ivykiai);
    plot(rez.X,rez.Y{ivdx},spalvos(1+mod(ivdx,7)));    
end;

l=legend('show');
set(l,'String',num2str(rez.ivykiai'));
title('ECR');
xlabel('laikas, s');
ylabel('ŠR pokytis, k/min');

%%

return ;

%%
spalvos='rgbcmyk';
figure; hold('on');
for i=1:size(g.LabChart_iv,1) ; plot(g.LabChart_iv{i,4},g.LabChart_iv{i,5},spalvos(1+mod(i,7))); end ;
title('');
xlabel('laikas, s');
ylabel('ŠR pokytis, k/min');

%%


plot(X,mean(Y),'k','LineWidth',5);



%%%%%%



rez=[];
rez.Ym1=[];
rez.Ym2=[];
rez.Ym3=[];
rez.Yv=[];

m1=filter_filenames(fullfile(pwd,'m1','*.mat'));
m2=filter_filenames(fullfile(pwd,'m2','*.mat'));
m3=filter_filenames(fullfile(pwd,'m3','*.mat'));
v=filter_filenames(fullfile(pwd,'v','*.mat'));



for i=1:length(m1);
    load(m1{i});
    [rez.m1{i}]=ECR_Labchart(com,comtext,tickrate);
    if ~isempty(rez.m1{i});
    rez.Ym1(end+1,1:56)=rez.m1{1, i}.Y{find(rez.m1{1, i}.ivykiai == 1)};
    end;
end;

for i=1:length(m2);
    load(m2{i});
    [rez.m2{i}]=ECR_Labchart(com,comtext,tickrate);
    if ~isempty(rez.m2{i});
    rez.Ym2(end+1,1:56)=rez.m2{1, i}.Y{find(rez.m2{1, i}.ivykiai == 1)};
    end;
end;

for i=1:length(m3);
    load(m3{i});
    [rez.m3{i}]=ECR_Labchart(com,comtext,tickrate);
    if ~isempty(rez.m3{i});
    rez.Ym3(end+1,1:56)=rez.m3{1, i}.Y{find(rez.m3{1, i}.ivykiai == 1)};
    end;
end;

for i=1:length(v);
    load(v{i});
    [rez.v{i}]=ECR_Labchart(com,comtext,tickrate);
    if ~isempty(rez.v{i});
    rez.Yv(end+1,1:56)=rez.v{1, i}.Y{find(rez.v{1, i}.ivykiai == 1)};
    end;
end;

rez.X=rez.v{1, 1}.X;
figure;
plot(rez.X,mean(rez.Ym1),rez.X,mean(rez.Ym2),rez.X,mean(rez.Ym3),rez.X,mean(rez.Yv))
l=legend('show');
set(l,'String',{'m1' 'm2' 'm3' 'v'});

