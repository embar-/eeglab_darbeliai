function varargout=drb_uzklausa(varargin)
% drb_uzklausa - bendrų užklausų kvietimas „Darbelių“ languose 
%
% (C) 2015-2016 Mindaugas Baranauskas

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

if nargin > 0; uzklausa=varargin{1};
else           uzklausa='';
end;

switch lower(uzklausa)
    case {'ivykiai'}
        varargout=drb_uzklausa_ivykiai(varargin{2:end});
    case {'kanalai'}
        varargout=drb_uzklausa_kanalai(varargin{2:end});
    case {'katalogas'}
        varargout=drb_uzklausa_katalogas(varargin{2:end});
    otherwise
        warning(lokaliz('Netinkami parametrai'));
        help(mfilename);
        varargout={};
end


function [katalogas]=drb_uzklausa_katalogas(varargin)
%% Pasirinkti katalogą
if nargin > 0; tipas=varargin{1};
else           tipas='nepatikslintas';
end;
if nargin > 1; c=varargin{2}; % pradinis
else           c=pwd;
end;
if nargin > 2; papildomi=varargin{3};
else           papildomi={};
end;

if ismember(fileparts(c), {'' '.' '..'}); c=pwd; end; p={c};
p0=''; while ~strcmp(p{1},p0); p=[fileparts(p{1}) p]; p0=p{2}; end;
p1=p(2:end);
d=dir(c);
d0={d(find([d.isdir])).name};
d1=arrayfun(@(x) fullfile(regexprep(c,[filesep '$'],''), d0{x}), 3:length(d0),'UniformOutput', false);
l=dir(fileparts(c));
l0={l(find([l.isdir])).name};
l1=arrayfun(@(x) Tikras_Kelias(fullfile(regexprep(fileparts(c),[filesep '$'],''), l0{x})), 3:length(l0),'UniformOutput', false);

% ankstesnių seansų kelių įkėlimas
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));   
catch %err; warning(err.message);
end;

switch tipas
    case { 'atverimui' 'ikelimo' 'input' }
        papildomi=[papildomi {[ (fileparts(which('eeglab'))) filesep 'sample_data' ]} ];
        try papildomi=[papildomi Darbeliai.keliai.atverimui ]; catch; end;
        paaiskinimas=lokaliz('Ikeltinu duomenu aplankas');
    case { 'saugojimui' 'irasymo' 'output' }
        papildomi=[papildomi {regexprep({tempdir}, [filesep '$'], '' )} ];
        try papildomi=[papildomi Darbeliai.keliai.saugojimui ]; catch; end;
        paaiskinimas=lokaliz('Saugotinu duomenu aplankas');
    otherwise
        paaiskinimas='';
end;

s0=papildomi;
s1={} ; 
for x=1:length(s0) ; 
    if strcmp(s0{x}, Tikras_Kelias(s0{x}));
        s1=[s1 s0{x}] ;
    end;
end;

p=unique([c p1 d1 l1 s1 {pwd}]);
a=listdlg(...
    'Name', lokaliz('Pasirinkite aplanka'), ...
    'PromptString', paaiskinimas, ...
    'ListString', p,...
    'SelectionMode', 'single',...
    'InitialValue', find(ismember(p,c)),...
    'ListSize', [700 300],...
    'OKString', lokaliz('OK'),...
    'CancelString', lokaliz('Cancel'));
if isempty(a);
    katalogas={''};
else
    katalogas={Tikras_Kelias(p{a})};
end;

function [pasirinkti_ivykiai]=drb_uzklausa_ivykiai(varargin)
%% Pasirinkite įvykius
if nargin > 0; katalogas=varargin{1};
else           katalogas=pwd;
end;
if nargin > 1; rinkmenos=varargin{2}; % pradinis
else           rinkmenos=filter_filenames('*.set;*.bdf;*.edf;*.cnt');
end;
if nargin > 2; seni=varargin{3};
else           seni={};
end;
if nargin > 3; rinktis_viena=varargin{4};
else           rinktis_viena=false;
end;

pasirinkti_ivykiai={{}};

[~,visi_galimi_ivykiai,bendri_ivykiai]=eeg_ivykiu_sarasas (katalogas, rinkmenos);
if ismember('boundary',visi_galimi_ivykiai);
    i=find(ismember(visi_galimi_ivykiai,'boundary')==0);
    visi_galimi_ivykiai=visi_galimi_ivykiai(i);
end;
if ismember('boundary',bendri_ivykiai);
    i=find(ismember(bendri_ivykiai,'boundary')==0);
    bendri_ivykiai=bendri_ivykiai(i);
end;
if isempty(visi_galimi_ivykiai);
    warndlg(lokaliz('No events found.'),lokaliz('Selection of events'));
    return;
end;
pateikiami_ivykiai={};
pradinis_pasirinkimas=[];
pateikiami_bendri_v=0;
if ~isempty(bendri_ivykiai);
    if length(rinkmenos) == 1;
        pateikiami_ivykiai={bendri_ivykiai{:}};
        pateikiami_bendri_v=0;
        pradinis_pasirinkimas=[1:length(bendri_ivykiai)];
    else
        pateikiami_ivykiai={lokaliz('(all common:)') bendri_ivykiai{:} };
        pateikiami_bendri_v=1;
        pradinis_pasirinkimas=[2:length(bendri_ivykiai)+1];
    end;
end;
nebendri_idx=find(ismember(visi_galimi_ivykiai,bendri_ivykiai) == 0);
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
    pateikiami_ivykiai={pateikiami_ivykiai{:} lokaliz('(not common:)') visi_galimi_ivykiai{nebendri_idx} };
    pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_ivykiai);
    if ~pateikiami_bendri_v;
        pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_ivykiai) + pateikiami_bendri_v + 1 ) ];
    end;
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
if ~isempty(seni);
    pradinis_pasirinkimas=find(ismember(pateikiami_ivykiai,seni)==1);
end;
if ~iscellstr(pateikiami_ivykiai);
    warning(lokaliz('unexpected events types.'),lokaliz('Selection of events'));
    disp(pateikiami_ivykiai);
    return;
end;
if rinktis_viena;
    rinktis_kiek='single';
    if length(pradinis_pasirinkimas) > 1;
        pradinis_pasirinkimas=pradinis_pasirinkimas(1);
    end;
else
    rinktis_kiek='multiple';
end;
pasirinkti_ivykiai_idx=listdlg('ListString', pateikiami_ivykiai,...
    'SelectionMode',rinktis_kiek,...
    'PromptString', lokaliz('Select events:'),...
    'InitialValue',pradinis_pasirinkimas );
if isempty(pasirinkti_ivykiai_idx); return ; end;
pasirinkti_ivykiai={};
if ismember(pateikiami_bendri_v,pasirinkti_ivykiai_idx);
    pasirinkti_ivykiai={pasirinkti_ivykiai{:} bendri_ivykiai{:} };
end;
if ismember(pateikiami_nebendri_v,pasirinkti_ivykiai_idx);
    pasirinkti_ivykiai={pasirinkti_ivykiai{:} visi_galimi_ivykiai{nebendri_idx} };
end;
pasirinkti_ivykiai_idx_=pasirinkti_ivykiai_idx(find(ismember(pasirinkti_ivykiai_idx, [pateikiami_bendri_v pateikiami_nebendri_v])==0));
pasirinkti_ivykiai={unique({pasirinkti_ivykiai{:} pateikiami_ivykiai{pasirinkti_ivykiai_idx_}})};


function [pasirinkti_kanalai]=drb_uzklausa_kanalai(varargin)
%% Pasirinkite įvykius
if nargin > 0; katalogas=varargin{1};
else           katalogas=pwd;
end;
if nargin > 1; rinkmenos=varargin{2}; % pradinis
else           rinkmenos=filter_filenames('*.set;*.bdf;*.edf;*.cnt');
end;
if nargin > 2; seni=varargin{3};
else           seni={};
end;
if nargin > 3; rinktis_viena=varargin{4};
else           rinktis_viena=false;
end;

pasirinkti_kanalai={{}};

[~,visi_galimi_kanalai,bendri_kanalai]=eeg_kanalu_sarasas (katalogas, rinkmenos);
if isempty(visi_galimi_kanalai);
    warndlg(lokaliz('No channels found.'),lokaliz('Selection of channels'));
    return;
end;
pateikiami_kanalai={};
pradinis_pasirinkimas=[];
pateikiami_bendri_v=0;
if ~isempty(bendri_kanalai);
    if length(rinkmenos) == 1;
        pateikiami_kanalai={bendri_kanalai{:}};
        pateikiami_bendri_v=0;
        pradinis_pasirinkimas=[1:length(bendri_kanalai)];
    else
        pateikiami_kanalai={lokaliz('(all common:)') bendri_kanalai{:} };
        pateikiami_bendri_v=1;
        pradinis_pasirinkimas=[2:(length(bendri_kanalai)+1)];
    end;
end;
nebendri_idx=find(ismember(visi_galimi_kanalai,bendri_kanalai) == 0);
pateikiami_nebendri_v=0;
if ~isempty(nebendri_idx);
    pateikiami_kanalai={pateikiami_kanalai{:} lokaliz('(not common:)') visi_galimi_kanalai{nebendri_idx} };
    pateikiami_nebendri_v=1+pateikiami_bendri_v + length(bendri_kanalai);
    if ~pateikiami_bendri_v;
        pradinis_pasirinkimas=[(pateikiami_nebendri_v +1) : (length(visi_galimi_kanalai) + pateikiami_bendri_v + 1 ) ];
    end;
end;
%vis tik nepaisyti pradinis_pasirinkimas, jei netuščias ankstesnis pasirinkimas
if ~isempty(seni);
    pradinis_pasirinkimas=find(ismember(pateikiami_kanalai,seni)==1);
end;
if ~iscellstr(pateikiami_kanalai);
    warning(lokaliz('unexpected channels types.'),lokaliz('Selection of channels'));
    disp(pateikiami_kanalai);
    return;
end;
if rinktis_viena;
    rinktis_kiek='single';
    if length(pradinis_pasirinkimas) > 1;
        pradinis_pasirinkimas=pradinis_pasirinkimas(1);
    end;
else
    rinktis_kiek='multiple';
end;
pasirinkti_kanalai_idx=listdlg('ListString', pateikiami_kanalai,...
    'SelectionMode',rinktis_kiek,...
    'PromptString', lokaliz('Select channels:'),...
    'InitialValue',pradinis_pasirinkimas );
if isempty(pasirinkti_kanalai_idx); return ; end;
pasirinkti_kanalai={};
if ismember(pateikiami_bendri_v,pasirinkti_kanalai_idx);
    pasirinkti_kanalai={pasirinkti_kanalai{:} bendri_kanalai{:} };
end;
if ismember(pateikiami_nebendri_v,pasirinkti_kanalai_idx);
    pasirinkti_kanalai={pasirinkti_kanalai{:} visi_galimi_kanalai{nebendri_idx} };
end;
pasirinkti_kanalai_idx_=pasirinkti_kanalai_idx(find(ismember(pasirinkti_kanalai_idx, [pateikiami_bendri_v pateikiami_nebendri_v])==0));
pasirinkti_kanalai={unique({pasirinkti_kanalai{:} pateikiami_kanalai{pasirinkti_kanalai_idx_}})};

