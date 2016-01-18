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
l1=arrayfun(@(x) fullfile(regexprep(fileparts(c),[filesep '$'],''), l0{x}), 3:length(l0),'UniformOutput', false);

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

p=unique([p1 d1 l1 s1 {pwd}]);
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

