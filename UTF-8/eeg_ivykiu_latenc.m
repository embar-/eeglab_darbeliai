function [ivLaikai, ivTipai, ivRodykles, ivLaikuSkirtumai, Laikai]=eeg_ivykiu_latenc(EEG, varargin)
% eeg_ivykiu_latenc - įvykių latencija, atsižvelgiant į karpymus (boundary)
% [Ivykiu_Laikai, Ivykiu_Tipai, Ivykiu_Rodykles, Ivykiu_Poslinkiai, Laikai] = eeg_ivykiu_latenc(EEG)
% [Ivykiu_Laikai, Ivykiu_Tipai, Ivykiu_Rodykles, Ivykiu_Poslinkiai] = eeg_ivykiu_latenc(EEG, 'type', IVYKIS) 
% [Ivykiu_Laikai, Ivykiu_Tipai, Ivykiu_Rodykles, Ivykiu_Poslinkiai] = eeg_ivykiu_latenc(EEG, 'index', INDEKSAI) 
% 
% Neatsižvelgiant į karpymus, rezultatas panašus kaip
% [~, Ivykiu_Laikai]=eeg_getepochevent(EEG, IVYKIS);
% 
% (C) 2015 Mindaugas Baranauskas

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


ivLaikai=[]; ivTipai={}; ivRodykles=[]; ivLaikuSkirtumai=[]; Laikai=EEG.times;

try
    g=struct(varargin{:});
catch err; Pranesk_apie_klaida(err, mfilename, '?', 0);
end;

if nargout >= 5 && any(ismember(fieldnames(g),{'type' 'notype' 'index'})); 
    % būtina prasukti su 'boundary' įvykiu, geriau be jokių parametrų
    error(lokaliz('Internal error'));
end;

if ~isfield(EEG,'event'); return; end;
if ~isfield(EEG.event,'type'); return; end;
Ivykiai={EEG.event.type};
if isempty(Ivykiai); return; end;
if ~iscellstr(Ivykiai);
    Ivykiai=arrayfun(@(i) num2str(Ivykiai{i}), 1:length(Ivykiai), 'UniformOutput', false);
end;
ivRodykles=1:length(Ivykiai);
tipas_ir_latencija=[Ivykiai', {EEG.event.latency}', num2cell(ivRodykles)'];

try ivRodykles=find(ismember(ivRodykles,[g(1).index])); catch; end;

Ivykiai2={}; try Ivykiai2={g.type}; catch; end; % YRA ĮVYKIAI
if ~isempty(Ivykiai2)
    rodykles2=ismember(tipas_ir_latencija(ivRodykles,1),Ivykiai2) ;
    if ~any(rodykles2);
        ivRodykles=[]; return;
        %error([lokaliz('No selected events found in selected files.') ' ' Ivykiai2] );
    end;
    ivRodykles=ivRodykles(rodykles2);
end;

Ivykiai3={}; try Ivykiai3={g(1).notype}; catch; end; % NĖRA ĮVYKIŲ
if ~isempty(Ivykiai3)
    rodykles3=~ismember(tipas_ir_latencija(ivRodykles,1),Ivykiai3) ;
    if ~any(rodykles3);
        ivRodykles=[]; return;
        %error([lokaliz('No selected events found in selected files.') ' ' Ivykiai2] );
    end;
    ivRodykles=ivRodykles(rodykles3);
end;

ivTipai=tipas_ir_latencija(ivRodykles,1) ;
Laiko_idx=cell2mat(tipas_ir_latencija(ivRodykles,2)) ;
if isinteger(Laiko_idx);
    ivLaikai   = EEG.times(Laiko_idx)'; % ms
else
    %Laikai = eeg_point2lat( Laiko_idx, [], EEG.srate, [EEG.xmin EEG.xmax]*1000, 1E-3);
    ivLaikai   = (Laiko_idx-1)/EEG.srate*1000+EEG.xmin*1000; % ms
end;
ivLaikuSkirtumai=zeros(length(ivRodykles),1);

try if g(1).boundary == 0 ; return; end; catch; end; % Neprašo atsižvelgti į karpymą

rodykles_bnd=find(ismember(tipas_ir_latencija(:,1),{'boundary'}));
if isempty(rodykles_bnd); return; end; % Jei nekarpyta – galima baigti

% Perstumti EEG.event.latency atitikmens reikšmes
if isfield(EEG.event, 'duration');
    trukmes_bnd=[EEG.event(rodykles_bnd).duration]/EEG.srate*1000; % ms
else
    trukmes_bnd=nan(size(rodykles_bnd));
end;
trukmes_bnd_nan_i=isnan(trukmes_bnd);
if any(trukmes_bnd_nan_i);
    warning([ 'EEG.event(' num2str(find(trukmes_bnd_nan_i)) ').type == ''boundary'' && EEG.event(' num2str(find(trukmes_bnd_nan_i)) ').duration == NaN ' ]);
end;
rodykles_bnd_i=find(rodykles_bnd <= max(ivRodykles));
for bnd_i=rodykles_bnd_i(:)';
    ivLaikuSkirtumai(ivRodykles >= rodykles_bnd(bnd_i))=...
    ivLaikuSkirtumai(ivRodykles >= rodykles_bnd(bnd_i))+trukmes_bnd(bnd_i);
end;

bndrs_lat_orig=(cell2mat(tipas_ir_latencija(rodykles_bnd,2))-1) /EEG.srate*1000+EEG.xmin*1000; % ms;
ivLaikai = ivLaikai + ivLaikuSkirtumai;

% Pakeisti EEG.times atitikmens reikšmes

if any((bndrs_lat_orig < max(Laikai)) > min(Laikai));
    try if g(1).warn == 1 ; 
        warning(lokaliz('Record is not contiguous!'));
        end;
    catch
    end;
elseif ~any(bndrs_lat_orig < max(Laikai));
    return;
end;
if nargout < 5; return; end;

if ismember({'boundary'},ivTipai);
    ivLaikuSkirtumai_bnd=ivLaikuSkirtumai(rodykles_bnd);
else
    error(lokaliz('Internal error'));
end;

bndrs_n=find(bndrs_lat_orig(:)'<max(Laikai),1,'last');
if bndrs_n;
    ti=Laikai>bndrs_lat_orig(bndrs_n);
    Laikai(ti)=Laikai(ti)+ivLaikuSkirtumai_bnd(bndrs_n);
    for bi=bndrs_n-(1:bndrs_n-1);
        ti=Laikai(Laikai<bndrs_lat_orig(bi+1))>bndrs_lat_orig(bi);
        Laikai(ti)=Laikai(ti)+ivLaikuSkirtumai_bnd(bi);
    end;
end;

return;
