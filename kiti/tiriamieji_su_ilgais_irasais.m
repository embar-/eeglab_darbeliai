function [s_g,laikai,s_filtras]=tiriamieji_su_ilgais_irasais(ALLEEG,laiko_minimum_sek)
% (C) 2014-2015 Mindaugas Baranauskas

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
