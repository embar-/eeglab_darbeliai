function pop_eeg_perziura(varargin)
% eeg_perziura - EEG įrašų peržiūra naujame lange
% pop_eeg_perziura(EEG)
% pop_eeg_perziura(EEG1, EEG2)
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

if nargin == 0; help(mfilename); return; end;
if isstruct(varargin{1});
    EEG1=varargin{1};
    if nargin > 1
        if isstruct(varargin{2});
            EEG2=varargin{2};
            g=struct(varargin{3:end});
        else
            EEG2=[];
            g=struct(varargin{2:end});
        end;
    end;
else
    help(mfilename); return;
    %g=struct(varargin{:});
end;

if isfield(g,'title'); pvd=g.title; 
elseif isempty(EEG2)
    pvd=EEG1.setname;
else
    pvd=[ EEG1.setname ' + ' EEG2.setname ] ;
end;


f=figure('toolbar','none','menubar','none','NumberTitle','off','units','normalized','outerposition',[0 0 1 1],'name', pvd);
a=axes('units','normalized','position',[0.08 0.05 0.9 0.9 ]);

zymeti=0;
if isfield(g,'zymeti'); zymeti=g.zymeti; end;
if zymeti; setappdata(a,'zymeti',1); end;

if isempty(EEG2)
    eeg_perziura(EEG1);
else
    eeg_perziura(EEG1,EEG2);
end;

