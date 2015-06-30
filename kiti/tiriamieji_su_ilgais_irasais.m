function [s_g,laikai,s_filtras]=tiriamieji_su_ilgais_irasais(ALLEEG,laiko_minimum_sek)

%laiko_minimum_sek=20;

laikai=[];
s_g={};
s_filtras='';

s=unique({ALLEEG.subject});
if isempty(s); return; end;
c=unique({ALLEEG.condition});
if isempty(c); return; end;
for i=1:length(ALLEEG);

    laikai(...
        find(ismember(s,ALLEEG(i).subject)),...
        find(ismember(c,ALLEEG(i).condition)))...
        = ALLEEG(i).xmax ;
end;

s_g=s(find(laikai(:,1)>=laiko_minimum_sek));

for i=2:length(c);
    s_g=intersect(s_g,...
        s(find(laikai(:,i)>=laiko_minimum_sek)));
end;

s_filtras=sprintf('%s*.set;',s_g{:});
laikai=laikai(find(ismember(s,s_g)),:);

%return;

disp(['Tiriamųjų, kurių visi įrašai bent ' num2str(laiko_minimum_sek) ' sek trukmės, yra ' num2str(length(s_g)) ':' ]);
disp(s_g');
disp('Jų failų filtras:');
disp(s_filtras);
