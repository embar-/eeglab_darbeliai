% [KELIAS,Rinkmena]=rinkmenos_tikslinimas(KELIAS0,Rinkmena0)
% Patikslinti kelią ir rinkmeną, jei kartais Rinkmena0 savyje turi
% santykinį poaplankį (tada prie KELIO pridedamas tas santykinis poaplankis)
% arba net visą absoliutų kelią (tada KELIAS0 ignoruojamas, o naudojamas
% su Rinkmena0 einantis kelias).

%
% (C) 2015,2019 Mindaugas Baranauskas
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


function [KELIAS,Rinkmena,KELIAS_su_RINKMENA]=rinkmenos_tikslinimas(KELIAS0,Rinkmena0)
% Jei "Rinkmena0" savyje turi santykinį poaplankį arba net visą absoliutų kelią, patikslinti kelią ir rinkmeną.
    [KELIAS1,Rinkmena,galune]=fileparts(Rinkmena0);
    Rinkmena=[Rinkmena galune];
    if isempty(KELIAS1) && exist(fullfile(Tikras_Kelias(KELIAS0),Rinkmena),'file')
        % Jei kintamajame "Rinkmena0" nebuvo poaplankio, pradinis "KELIAS" greičiausiai geras,
        % belieka patikslinti per "Tikras_Kelias"
        KELIAS=Tikras_Kelias(KELIAS0);
    elseif strcmp(Tikras_Kelias(KELIAS1),KELIAS1) && exist(fullfile(Tikras_Kelias(KELIAS1),Rinkmena),'file') 
        % jei "KELIAS_" yra absoliutus, o ne santykinis kelias
        KELIAS=Tikras_Kelias(KELIAS1);
    else
        % Poaplankį pridėkime prie pradinio kelio
        KELIAS2=Tikras_Kelias(fullfile(KELIAS0,KELIAS1));
        if exist(fullfile(KELIAS2,Rinkmena),'file')
            KELIAS=KELIAS2;
        %elseif exist(fullfile(pwd,KELIAS1,Rinkmena),'file')
        %    KELIAS=pwd;
        else
            error(lokaliz('Rinkmena nerasta'));
        end
    end
    KELIAS_su_RINKMENA=fullfile(KELIAS,Rinkmena);
