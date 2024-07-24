% eeg_ikelk - duomenų įkėlimas EEGLAB struktūros pavidalu kone iš bet
% kokios vienos EEG rinkmenos [EEG] = eeg_ikelk(kelias,rinkmena)
%
% (C) 2015-2017, 2019, 2024 Mindaugas Baranauskas

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
function [EEG] = eeg_ikelk(Kelias, Rinkmena, varargin)

%% Pradiniai kintamieji, paruošimas
EEG = [];

% naudotojo parametrai kaip struktūra
try
    g = struct(varargin{:});
catch
    g = struct;
end

% Papildinių tikrinimas numatytuoju atveju nesikartoja
persistent INFORMUOTA_APIE_PAPILDINIUS
tikrinti_papildinius = 1;
if isfield(g,'tikrinti_papildinius')
    tikrinti_papildinius = g.tikrinti_papildinius;
end
if tikrinti_papildinius
    trukstami_papildniai = [drb_uzklausa('papildiniai')];
else
    trukstami_papildniai = NaN;
end

% pop_loadset parametras loadmode
loadmode = 'all';
if isfield(g,'loadmode')
    loadmode = g.loadmode;
end

% Rinkmenos kelias
[Kelias_,Rinkmena_] = rinkmenos_tikslinimas(Kelias,Rinkmena);
if ~exist(fullfile(Kelias_,Rinkmena_),'file')
    [wrn_b] = warning('off','backtrace');
    warning(sprintf('%s\n%s\n%s', [lokaliz('Rinkmena nerasta') ':'], ...
       fullfile(Kelias,Rinkmena), fullfile(Kelias_,Rinkmena_)));
    EEG = []; % Belieka tuščią grąžinti...
    warning(wrn_b);
    return;
end
Kelias_ir_rinkmena = fullfile(Kelias_, Rinkmena_);

% Galūnė ir veiksmų eiliškumas
[~, ~, galune] = fileparts(Rinkmena_);
if isfield(g,'fja') && ~isempty(g.fja) && ischar(g.fja)
    fjos = {g.fja};
else
    if strcmpi(galune, '.SET')  % EEGLAB *.set
        fjos = {'pop_loadset'};
    elseif strcmpi(galune, '.MAT')  % MATLAB *.mat
        fjos = {'load'};
    else
        fjos = {};
        if strcmpi(galune, '.CNT')  % ANT Neuro
            if tikrinti_papildinius
                if exist('pop_loadeep_v4','file') == 2
                    fjos = {'pop_loadeep_v4'};  % ANT Eeprobe: ANTeepimport1.14
                elseif iscell(trukstami_papildniai) 
                    if isempty(trukstami_papildniai)
                        trukstami_papildniai = {[ lokaliz('Pabandykite idiegti papildinius') ':' ] 'ANTeepimport' };
                    else
                        trukstami_papildniai = [trukstami_papildniai(:)' {'ANTeepimport'}];
                    end
                end
            else 
                fjos = {'pop_loadeep_v4'};  % ANT Eeprobe: ANTeepimport1.14
            end
        elseif strcmpi(galune, '.ACQ')  % BIOPAC AcqKnowledge *.ACQ
            fjos = {'load_acq'};  % external/load_acq_20110222/load_acq.m
        end
        % Kitos bendrosios importavimo funkcijos
        if tikrinti_papildinius
            if (exist('sopen','file') == 2)  % BIOSIG
                fjos = [fjos(:)' {'pop_biosig'}];
            end
            if (exist('ft_read_header','file') == 2)  % FILEIO
                fjos = [fjos(:)' {'pop_fileio'}];
            end
        else
            fjos = [fjos(:)' {'pop_biosig' 'pop_fileio'}];
        end
        fjos = [fjos(:)' {'pop_loadset' 'load'}];  % paskutinės bandomos funkcijos, jei kitos nepadėtų
    end
end

if ~ismember(fjos{1},{'pop_loadset', 'load_acq'})
    % pop_loadset ir load_acq parašo rinkmenų pavadinimus, o kitais atvejais nurodykite mes
    fprintf('%s:\n%s\n', lokaliz('Duomenu ikelimas'), Kelias_ir_rinkmena)
end

%% Pats nuskaitymas
for fja_c1 = fjos  % pereiti per kiekvieną importavimo funkciją
    fja = fja_c1{1};
    try
        switch fja
            case 'pop_loadset'  % Importuoti kaip EEGLAB *.set
                EEG = pop_loadset('filename',Rinkmena_,'filepath',Kelias_,'loadmode',loadmode);

            case 'load'  % MATLAB *.mat
                fprintf('%s %s...\n', lokaliz('Trying again with'), 'MATLAB');
                load(Kelias_ir_rinkmena, 'EEG', '-mat');
                EEG = eeg_checkset(EEG);

            case 'pop_biosig'  % BIOSIG
                fprintf('%s %s...\n', lokaliz('Trying again with'), 'BIOSIG');
                EEG = pop_biosig(Kelias_ir_rinkmena);
                if isempty(EEG.data)
                    error(lokaliz('Empty dataset'));
                end
                EEG = eegh( ['EEG = pop_biosig(''' Kelias_ir_rinkmena ''')' ], EEG);

            case 'pop_loadeep_v4'
                EEG = pop_loadeep_v4(Kelias_ir_rinkmena);
                EEG = eegh( ['EEG = pop_loadeep_v4(''' Kelias_ir_rinkmena ''')' ], EEG);

            case 'load_acq'  % BIOPAC AcqKnowledge *.ACQ
                fprintf('%s %s...\n', lokaliz('Trying again with'), 'load_acq');
                acq = load_acq(Kelias_ir_rinkmena);
                [~, EEG] = pop_newset([],[],[]);
                EEG.data = acq.data';
                EEG.srate = 1000/double(acq.hdr.graph.sample_time);
                EEG.trials = 1;
                EEG.pnts = size(EEG.data,2);
                EEG.times = (EEG.pnts-1)*double(acq.hdr.graph.sample_time);
                EEG.xmin = 0;
                EEG.xmax = EEG.times(end)/1000;
                EEG.nbchan = acq.hdr.graph.num_channels;
                EEG.chanlocs = struct('labels',{acq.hdr.per_chan_data.comment_text});
                if ~isempty(acq.markers.szText)
                    tipai = regexprep(acq.markers.szText,'^Segment .*','boundary');
                    ltncj = num2cell(acq.markers.lSample+1);
                    EEG.event = struct('type',tipai,'latency',ltncj,'duration',0);
                end
                EEG = eegh( ['EEG = eeg_ikelk(''' Kelias ''', ''' Rinkmena ''', ''fja'', ''load_acq'')' ], EEG);

            case 'pop_fileio'  % FILEIO
                fprintf('%s %s...\n', lokaliz('Trying again with'), 'FILEIO');
                EEG = pop_fileio(Kelias_ir_rinkmena);
                EEG = eegh( ['pop_fileio(' Kelias_ir_rinkmena ')' ], EEG);
                % Sutvarkyti įvykių pavadinimus
                try tipai = regexprep({EEG.event.type},'[\0]*$','');
                    [EEG.event.type] = tipai{:};
                catch
                end

            otherwise
                fprintf('%s %s...\n', lokaliz('Trying again with'), fja);
                error(lokaliz('Internal error'))
        end
        break  % jei pavyko ateiti iki čia, nutraukti FOR ciklą ir nebetikrinti tolesnių importavimo f-jų

    catch klaida
        switch fja
            case 'pop_loadset'  % EEGLAB *.set
                fprintf('%s...\n', lokaliz('ne EEGLAB rinkmena'));
            case 'load'  % MATLAB *.mat
                fprintf('%s...\n', lokaliz('MATLAB negali nuskaityti'));
            case 'pop_biosig'  % BIOSIG
                fprintf('%s...\n', lokaliz('BIOSIG negali nuskaityti'));
            case 'pop_fileio'  % FILEIO
                fprintf('%s...\n', lokaliz('FILEIO negali nuskaityti'));
            case {'pop_loadeep_v4' 'load_acq'}
                fprintf('%s...\n', [fja ' negali nuskaityti']);
            otherwise
                Pranesk_apie_klaida(klaida, mfilename, Kelias_ir_rinkmena, 0);
        end
        EEG = [];  % nustatyti iš naujo į tuščią dėl visa ko
    end
end

if isempty(EEG)
    % Jokiai importavimo funkcijai nepavyko įkelti
    [wrn_b] = warning('off','backtrace');
    warning(lokaliz('Ikelti nepavyko'));
    if tikrinti_papildinius && isempty(INFORMUOTA_APIE_PAPILDINIUS)
        if iscell(trukstami_papildniai) && ~isempty(trukstami_papildniai)
            warning(sprintf('%s\n', trukstami_papildniai{:}));
            warndlg(trukstami_papildniai,lokaliz('Duomenu ikelimas'));
            INFORMUOTA_APIE_PAPILDINIUS = 1;
        end
    end
    warning(wrn_b);
    return  % Belieka tuščią grąžinti...
end

% Konvertuoti įvykius iš skaitinių į raidinius
try
    ivykiai = {EEG.event.type};
    if ~iscellstr(ivykiai)
        for i = 1:length(ivykiai)
            try
                EEG.event(i).type = num2str(EEG.event(i).type);
            catch
            end
        end
    end
catch
end
