function [galimi_ivykiai,visi_galimi_ivykiai,bendri_ivykiai]=...
    eeg_ivykiu_sarasas (KELIAS, RINKMENOS)
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
% (C) 2014 Mindaugas Baranauskas
%%

tici=tic;

galimi_ivykiai={};
visi_galimi_ivykiai={};
bendri_ivykiai={};

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


f=statusbar(lokaliz('Palaukite!'));
statusbar('off',f);

for i=1:length(RINKMENOS);
    try
        Rinkmena=RINKMENOS{i};
        [KELIAS_,Rinkmena_,galune]=fileparts(fullfile(KELIAS,Rinkmena));
        Rinkmena_=[Rinkmena_ galune];
        KELIAS_=Tikras_Kelias(KELIAS_);
        TMPEEG=[];
        TMPEEG = pop_loadset('filename',Rinkmena_,'filepath',KELIAS_,'loadmode','info');
        if ~isempty(TMPEEG);
            ivykiai={TMPEEG.event.type};
            if iscellstr(ivykiai);
                galimi_ivykiai{i,1}=unique(ivykiai);
            else
                ivykiai=[ivykiai{:}];
                if isnumeric(ivykiai);
                    warning([Rinkmena ': ' lokaliz('events are in numeric format.')]);
                    %warndlg({Rinkmena lokaliz('events are in numeric format.')},mfilename);
                    ivykiai=unique(ivykiai);
                    ivykiai=cellfun(@(i) {num2str(ivykiai(i))}, num2cell([1:length(ivykiai)]));
                    galimi_ivykiai{i,1}=ivykiai;
                else
                    disp(' ');
                    warning([Rinkmena ': ' lokaliz('unexpected events types.')]);
                    %warndlg({Rinkmena lokaliz('unexpected events types.')},mfilename);
                    disp(ivykiai);
                    galimi_ivykiai{i,1}={};
                end;
            end;
        end;
        
    catch err;
        warning(err.message);
    end;
    
    % statusbar
    tok=toc(tici);
    p=i/length(RINKMENOS);
    if and(tok>1,p<0.5);
        statusbar('on',f);
    end;
    if isempty(statusbar(p,f));
        break;
    end;
    
end;

% bent vienoje rinkmenoje rastas
visi_galimi_ivykiai=unique([galimi_ivykiai{:}]);

%tik bendri visoms rinkmenoms
if ~isempty(galimi_ivykiai);
    bendri_ivykiai=galimi_ivykiai{1};
end;
for i=2:length(galimi_ivykiai);
    bendri_ivykiai=intersect(bendri_ivykiai,galimi_ivykiai{i});
end;

if ishandle(f)
    delete(f);
end;

function [varargout] = Tikras_Kelias(kelias_tikrinimui)
kelias_dabar=pwd;
try
    cd(kelias_tikrinimui);
catch err;
end;
varargout{1}=pwd;
cd(kelias_dabar);