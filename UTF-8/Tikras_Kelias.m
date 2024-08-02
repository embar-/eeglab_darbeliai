function kelias = Tikras_Kelias(kelias_tikrinimui)

%
% (C) 2014,2017 Mindaugas Baranauskas
%

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

[wrn_b]=warning('off','backtrace');
kelias_dabar=pwd;
if ~ischar(kelias_tikrinimui)
    kelias=pwd;
    warning(wrn_b);
    return;
end
if isunix
    kelias_tikrinimui=regexprep(kelias_tikrinimui,'^file://','');
end
aukstesnis=fileparts(kelias_tikrinimui);
while ~exist(kelias_tikrinimui,'dir') && ~strcmp(kelias_tikrinimui,aukstesnis)
    kelias_tikrinimui=aukstesnis;
    aukstesnis=fileparts(kelias_tikrinimui);
end
try
    cd(kelias_tikrinimui);
catch
end
warning(wrn_b);
kelias=pwd;
cd(kelias_dabar);
