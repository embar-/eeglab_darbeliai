function eeg_issaugoti(EEG, KELIAS_SAUGOJIMUI, RINKMENA_SAUGOJIMUI)
% (C) 2014-2016 Mindaugas Baranauskas

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

if isempty(EEG) ;
    informuok(lokaliz('Nera ka saugoti'));
    return ;
end;
try
    if or(EEG.nbchan==0,isempty(EEG.data));
        informuok(lokaliz('Nera ka saugoti'));
        return ;
    end;
    if EEG.pnts<=1;
        informuok(lokaliz('Nera ka saugoti'));
        return ;
    end;
    if ~isdir(KELIAS_SAUGOJIMUI)
        mkdir(KELIAS_SAUGOJIMUI);
    end;
    KELIAS_SAUGOJIMUI=Tikras_Kelias(KELIAS_SAUGOJIMUI);
    RinkmenaSaugojimuiSuKeliu=fullfile(KELIAS_SAUGOJIMUI, RINKMENA_SAUGOJIMUI);
    if exist([regexprep(RinkmenaSaugojimuiSuKeliu,'.set$','') '.set'], 'file') == 2;
        informuok([lokaliz('Rinkmena jau yra!') ' ' lokaliz('Perrasysime rinkmena!')]);
    end;
    disp(RinkmenaSaugojimuiSuKeliu);
    [~, ~, ~] = pop_newset([], EEG, 0, ...
        'setname', regexprep(regexprep(RINKMENA_SAUGOJIMUI,'.cnt$',''),'.set$',''), ...
        'savenew',RinkmenaSaugojimuiSuKeliu);
catch err;
    %Pranesk_apie_klaida(err,lokaliz('Save file'),RINKMENA_SAUGOJIMUI);
    informuok(err.message);
    vel=lokaliz('Bandyti pakartotinai');
    button = questdlg(...
            { lokaliz('Klaida issaugant') KELIAS_SAUGOJIMUI RINKMENA_SAUGOJIMUI ...
            ' ' lokaliz('Bandyti pakartotinai?')}, ...
            lokaliz('Klaida issaugant'), ...
            lokaliz('Atsisakyti'), vel, vel);
        switch button
            case vel;
                eeg_issaugoti(EEG, KELIAS_SAUGOJIMUI, RINKMENA_SAUGOJIMUI);
            otherwise
                return;
        end;
end;

function informuok(pranesimas)
wrn=warning('off','backtrace');
warning(pranesimas);
warning(wrn.state, 'backtrace');


