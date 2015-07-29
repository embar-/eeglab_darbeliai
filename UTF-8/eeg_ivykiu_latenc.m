function [Laikai, Tipai, Rodykles, Laiku_skirtumas]=eeg_ivykiu_latenc(EEG, varargin)
% eeg_ivykiu_latenc - įvykių latencija, atsižvelgiant į karpymus (boundary)
% [Laikai, Tipai, Rodykles] = eeg_ivykiu_latenc(EEG, 'type', IVYKIS) 
% [Laikai, Tipai, Rodykles] = eeg_ivykiu_latenc(EEG, 'index', INDEKSAI) 
% 
% Neatsižvelgiant į karpymus, rezultatas panašus kaip
% [~, Laikai]=eeg_getepochevent(EEG, IVYKIS);
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

Laikai=[]; Tipai={}; Rodykles=[]; Laiku_skirtumas=[];
try
    g=struct(varargin{:});
catch err; Pranesk_apie_klaida(err, mfilename, '?', 0);
end;

Ivykiai={EEG.event.type};
if isempty(Ivykiai); 
    return; %error(lokaliz('No events found.')); 
end;
if ~iscellstr(Ivykiai);
    Ivykiai=arrayfun(@(i) num2str(i), 1:length(Ivykiai), 'UniformOutput', false);
end;
Rodykles=1:length(Ivykiai);
tipas_ir_latencija=[Ivykiai', {EEG.event.latency}', num2cell(Rodykles)'];

try Rodykles=find(ismember(Rodykles,[g(1).index])); catch; end;

Ivykiai2={}; try Ivykiai2={g(1).type}; catch; end; % YRA ĮVYKIAI
if ~isempty(Ivykiai2)
    rodykles2=ismember(tipas_ir_latencija(Rodykles,1),Ivykiai2) ;
    if ~any(rodykles2);
        Rodykles=[]; return;
        %error([lokaliz('No selected events found in selected files.') ' ' Ivykiai2] );
    end;
    Rodykles=Rodykles(rodykles2);
end;

Ivykiai3={}; try Ivykiai3={g(1).notype}; catch; end; % NĖRA ĮVYKIŲ
if ~isempty(Ivykiai3)
    rodykles3=~ismember(tipas_ir_latencija(Rodykles,1),Ivykiai3) ;
    if ~any(rodykles3);
        Rodykles=[]; return;
        %error([lokaliz('No selected events found in selected files.') ' ' Ivykiai2] );
    end;
    Rodykles=Rodykles(rodykles3);
end;

Tipai=tipas_ir_latencija(Rodykles,1) ;
Laiko_idx=cell2mat(tipas_ir_latencija(Rodykles,2)) ;
if isinteger(Laiko_idx);
    Laikai   = EEG.times(Laiko_idx)'; % ms
else
    %Laikai = eeg_point2lat( Laiko_idx, [], EEG.srate, [EEG.xmin EEG.xmax]*1000, 1E-3);
    Laikai   = (Laiko_idx-1)/EEG.srate*1000+EEG.xmin*1000; % ms
end;
Laiku_skirtumas=zeros(length(Rodykles),1);

try if g(1).boundary == 0 ; return; end; catch; end; % Neprašo atsižvelgti į karpymą

rodykles_bnd=find(ismember(tipas_ir_latencija(:,1),{'boundary'}));
if isempty(rodykles_bnd); return; end; % Jei nekarpyta – galima baigti

trukmes_bnd=[EEG.event(rodykles_bnd).duration]/EEG.srate*1000;
rodykles_bnd_i=find(rodykles_bnd < max(Rodykles));
for bnd_i=rodykles_bnd_i(:)';
    Laiku_skirtumas(Rodykles>rodykles_bnd(bnd_i))=...
    Laiku_skirtumas(Rodykles>rodykles_bnd(bnd_i))+trukmes_bnd(bnd_i);
end;

Laikai=Laikai+Laiku_skirtumas;

return;
