function EEGOUT=QRS_is_EEG(EEG, ecgchan, varargin)
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
%
% (C) 2014, Mindaugas Baranauskas
%
% Initial code belongs to fmrib_qrsdetect program:
% Copyright (C) 2004 University of Oxford
% Author:   Rami K. Niazy, FMRIB Centre
%           rami@fmrib.ox.ac.uk
%%

if nargin > 2 ;
    qrsevent = varargin{1};
else
    qrsevent = 'R' ;
end;

if nargin > 3 ;
    detect_mode = varargin{2};
else
    detect_mode = 'DPI' ;
end;

if nargin > 4 ;
    ecgdel = varargin{3};
else
    ecgdel = 'no' ;
end;


%Detect QRS
%----------
fprintf('\nFinding QRS Peaks...\n');

switch detect_mode
    case {0, '0', 5, '5', 'fmrib'}
        Peaks=QRS_detekt_fMRIb(EEG,ecgchan);
    otherwise
        EKG=double([EEG.data(ecgchan,:)]');
        SR=EEG.srate;
        [Peaks]=QRS_detekt(EKG,SR,detect_mode);
end;



%Add Peaks to events
%-------------------
fprintf('Writing QRS events to event structure...\n');
for index = 1:length(Peaks)
    EEG.event(end+1).type  = qrsevent;
    EEG.event(end).latency = Peaks(index);
    if EEG.trials > 1 | isfield(EEG.event, 'epoch');
        EEG.event(end).epoch = 1+floor((EEG.event(end).latency-1) / EEG.pnts);
    end
end

if EEG.trials > 1
    EEG = pop_editeventvals( EEG, 'sort', {  'epoch' 0 'latency', [0] } );
else
    EEG = pop_editeventvals( EEG, 'sort', { 'latency', [0] } );
end

if isfield(EEG.event, 'urevent')
    EEG.event = rmfield(EEG.event, 'urevent');
end

EEG = eeg_checkset(EEG, 'eventconsistency');
EEG = eeg_checkset(EEG, 'makeur');

% delete ECG channel
% ---------------
if strcmp(lower(ecgdel), 'yes')
	EEG = pop_select(EEG, 'nochannel', ecgchan);
end

%return command
%--------------
EEGOUT=eeg_checkset(EEG);