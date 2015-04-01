% 
% Pamėginti parsiųsti ir įdiegti RAGU,
%
% (C) 2014 Mindaugas Baranauskas
%
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

url='http://www.thomaskoenig.ch/Ragu_src.zip';

rehash;

if ~(exist('Ragu.m','file') == 2) ;
    path__=fullfile(regexprep(which('eeglab.m'),'eeglab.m$','plugins'),'thomaskoenig' , 'Ragu' );
else
    path__=fullfile(regexprep(which('Ragu.m'),'Ragu.m$','')) ;
    path_deactivated=fullfile(regexprep(which('eeglab.m'),'eeglab.m$','deactivatedplugins') , 'Ragu' );
    try
        rmdir(path_deactivated, 's');
    catch err;
    end;
    %mkdir(path_deactivated);
    movefile(path__ , path_deactivated ) ;
end;

status = 0;
try
    mkdir(path__);
    disp('Parsiunčiame Ragu...');
    [filestr,status] = urlwrite(url,fullfile(path__,'Ragu_src.zip')) ;
    
catch err ;
    disp(['Nepavyko parsiųsti RAGU. Galbūt neturite teisės rašyti į aplanką ' path__ ]);
    try
        rmdir(path__, 's');
        movefile(path_deactivated, path__ ) ;
        addpath(path__); savepath ;
    catch err;
    end;
end;

if status == 1 ;
    try
        unzip(filestr,path__);
        delete(filestr);
        addpath(path__);
        addpath(regexprep(path__,'Ragu$',''));
        disp('Parsiuntėme ir įdiegėme RAGU');
        eeglab;
    catch err;
        disp('RAGU parsiuntėme, bet nepavyko išpakuoti.');
        try
            rmdir(path__,'s');
            movefile(path_deactivated, path__ ) ;
            addpath(path__); savepath ;
        catch err;
        end;
    end;
    try
        savepath ;
    catch err;
        %disp('Bet turite rankiniu būdu išsaugoti kelią.');
    end;
else
    disp('Nepavyko parsiųsti RAGU. Galbūt nėra interneto ryšio.');
    try
        rmdir(path__,'s');
        movefile(path_deactivated, path__ ) ;
        addpath(path__); savepath ;
    catch err;
    end;
end;

rehash toolbox;

