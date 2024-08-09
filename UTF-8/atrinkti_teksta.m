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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Ši programa yra laisva. Jūs galite ją platinti ir/arba modifikuoti
% remdamiesi Free Software Foundation paskelbtomis GNU Bendrosios
% Viešosios licencijos sąlygomis: 3 licencijos versija, arba (savo
% nuožiūra) bet kuria vėlesne versija.
%
% Ši programa platinama su viltimi, kad ji bus naudinga, bet BE JOKIOS
% GARANTIJOS; taip pat nesuteikiama jokia numanoma garantija dėl TINKAMUMO
% PARDUOTI ar PANAUDOTI TAM TIKRAM TIKSLU. Daugiau informacijos galite 
% rasti pačioje GNU Bendrojoje Viešojoje licencijoje.
%
% Jūs kartu su šia programa turėjote gauti ir GNU Bendrosios Viešosios
% licencijos kopiją; jei ne - žr. <https://www.gnu.org/licenses/>.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%%

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


