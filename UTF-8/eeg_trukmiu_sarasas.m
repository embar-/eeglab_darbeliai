function [trukmiu_intervalai,persidengiantis_intervalas,maziausia_trukme,ar_patikrintos_visos_rinkmenos]=...
    eeg_trukmiu_sarasas (KELIAS, RINKMENOS)
%
% (C) 2015 Mindaugas Baranauskas
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

tici=tic;

trukmiu_intervalai=NaN(length(RINKMENOS),2);
persidengiantis_intervalas=[NaN NaN];
maziausia_trukme=NaN;
ar_patikrintos_visos_rinkmenos=true;

prad_kelias=pwd;
try
    cd(KELIAS);
catch err;
    warning(err.message);
    return;
end;
KELIAS=pwd;
cd(prad_kelias);

if ~iscellstr(RINKMENOS);
    if ischar(RINKMENOS);
        RINKMENOS={RINKMENOS};
    else
        return;
    end;
end;

if isempty(RINKMENOS); return; end;

f=statusbar2015(lokaliz('Palaukite!'));
statusbar2015('off',f);

for i=1:length(RINKMENOS);
    try
        [KELIAS_,Rinkmena_]=rinkmenos_tikslinimas(KELIAS,RINKMENOS{i});
        TMPEEG=[];
        TMPEEG = pop_loadset('filename',Rinkmena_,'filepath',KELIAS_,'loadmode','info');
        if ~isempty(TMPEEG);
            intervalas=[TMPEEG.xmin TMPEEG.xmax];
            trukmiu_intervalai(i,:)=intervalas;
            persidengiantis_intervalas=[...
                max(persidengiantis_intervalas(1), intervalas(1)), ...
                min(persidengiantis_intervalas(2), intervalas(2))];
            maziausia_trukme=...
                min(maziausia_trukme,intervalas(2)-intervalas(1));
        end;
    catch err;
        ar_patikrintos_visos_rinkmenos=false;
        warning(err.message);
    end;

    % statusbar
    tok=toc(tici);
    p=i/length(RINKMENOS);
    if and(tok>1,p<0.5);
        statusbar2015('on',f);
    end;
    if isempty(statusbar2015(p,f));
        break;
    end;

end;

if ishandle(f)
    delete(f);
end;
