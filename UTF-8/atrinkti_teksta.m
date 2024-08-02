function atrinktas_tekstas=atrinkti_teksta(teksto_eilutes,teksto_filtras)
% atrinktas_tekstas=atrinkti_teksta(teksto_eilutes,teksto_filtras)
%
% Atrinkti tekstą (pvz., rinkmenų sąrašą) pagal reguliarios išraiškos filtrą(-us).
% Jei norima vienu meu naudoti kelis filtrus, juos atskirkite kabliataškiu.
%
% Pvz.:
% atrinkti_teksta({'labas.txt' 'gražus.cvs' 'rytas.edf'},'g*.*;l*.*')
% ans = 
%    'gražus.cvs'    'labas.txt'
%
% atrinkti_teksta({'labas.txt' 'gražus.cvs' 'rytas.edf'},'*as*')
% ans = 
%    'labas.txt'    'rytas.edf'
%
% (c) 2014, 2016 Mindaugas Baranauskas
% (c) 2016 Vilniaus universitetas


atrinktas_tekstas={};
if ischar(teksto_eilutes);
   teksto_eilutes=cellstr(teksto_eilutes);
end;
if ~iscellstr(teksto_eilutes);
    return;
end;
if ismember(';',teksto_filtras);
   teksto_filtrai=regexp(teksto_filtras,';', 'split');
   for i=1:length(teksto_filtrai);
      tmp=atrinkti_teksta(teksto_eilutes,teksto_filtrai{i});
      atrinktas_tekstas=[atrinktas_tekstas{:} tmp];
      [~,idx]=unique(atrinktas_tekstas);
      atrinktas_tekstas=atrinktas_tekstas(sort(idx));
   end;
else
    teksto_filtras=strrep(teksto_filtras, '\', '\\' );
    teksto_filtras=strrep(teksto_filtras, '.', '\.' );
    teksto_filtras=strrep(teksto_filtras, '(', '\(' );
    teksto_filtras=strrep(teksto_filtras, ')', '\)' );
    teksto_filtras=strrep(teksto_filtras, '[', '\[' );
    teksto_filtras=strrep(teksto_filtras, ']', '\]' );
    teksto_filtras=strrep(teksto_filtras, '*', '.*' );
    atrinktas_tekstas=regexp(teksto_eilutes, [ '^' teksto_filtras '$' ] , 'match');
    atrinktas_tekstas=[atrinktas_tekstas{:}];
end;


