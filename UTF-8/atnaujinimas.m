%
% atnaujinimas()
%
% Lietuviškai: Parsiųsti ir diegti EEGLAB papildinį
% NAUDOJIMAS: 
% atnaujinimas(url,vardas,failas_identifik)
% 
%              url - papildinio ZIP archyvo URL
%           vardas - papildinio pavadinimas
% failas_identifik - jei tas failas yra, tariama, kad kompiuteryje jau
%                    yra įdiegta (sena) papildinio versija
%
%
% English: download and install EEGLAB plugin
% USAGE: 
% atnaujinimas(url,name,file_to_identify)
%
%              url - plugin ZIP archive URL
%             name - name of plugin
% file_to_identify - if this file exist, we assume, that (old) version
%                    of plugin is already installed
%
%%
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

function atnaujinimas(varargin)
% Pagrindinė funkcija


% mfilename_folder=regexprep(mfilename('fullpath'),[ mfilename '$'],'');
% if ~strcmp(mfilename_folder,tempdir);
%     disp(mfilename_folder);    
%     copyfile([mfilename('fullpath') '.m'], fullfile(tempdir, 'atnaujinimas.m') , 'f');
% end;

if nargin > 0;     url=varargin{1};
else     
  % url='https://www.dropbox.com/sh/mpt7uwlrhsu55n4/AAB-XzFkhDjXlCIKxDF6H1VPa/Darbeliai.zip?dl=1';
  % url='https://github.com/embar-/eeglab_darbeliai/archive/master.zip' ;
  url='https://github.com/embar-/eeglab_darbeliai/archive/stable.zip' ;
end;

if nargin > 1;     name=varargin{2};
else     name='Darbeliai';
end;

if nargin > 2;     file_to_identify=varargin{3};
else     file_to_identify='eegplugin_darbeliai.m';
end;

if nargin > 3;     files_to_preserve=varargin{4};
else     files_to_preserve={'Darbeliai_config.mat'};
end;


rehash;
path_new=fullfile(regexprep(which('eeglab.m'),'eeglab.m$','plugins') );

if (exist(file_to_identify) == 2) ;
    path_old=fullfile(regexprep(which(file_to_identify),[ file_to_identify '$' ],'')) ;
    if strcmp(fullfile(pwd,'.'),fullfile(path_old,'.')) ;
       try 
           cd('..'); 
       catch err; 
       end;
    end;
    try
       for fpi=1:length(files_to_preserve);
          fp=files_to_preserve{fpi};
          try
             copyfile(fullfile(path_old,fp),fullfile(tempdir,fp),'f');
          catch err;
          end;
       end;
    catch err;
    end;
    path_deactivated=fullfile(regexprep(which('eeglab.m'),'eeglab.m$','deactivatedplugins') , name );
    try   
        rmpath(path_deactivated);
        rmdir(path_deactivated, 's'); 
    catch err;    
    end;
    mkdir(path_deactivated);
    rmpath(genpath(path_old));
    try   
        rmpath(path_old);
        movefile(path_old , path_deactivated , 'f') ; 
    catch err ;
        disp(err.message);
    end;  
    try
        if ismember(path,path_deactivated);
            rmpath(genpath(path_deactivated));
        end;
    catch err;
    end;    
end;

status = 0;

try
    disp('Parsiunčiame archyvą...');
    [filestr,status] = urlwrite(url,fullfile(path_new,[ name '.zip' ])) ;    
catch err ;
    disp(err.message) ;
    disp(char(['Nepavyko parsisiųsti' url [{}] 'Galbūt neturite teisės rašyti į aplanką ' path_new ]));
    try   
        if strcmp(path_old(end),filesep);
            path_old=path_old(1:end-1);
        end ;
        path_old_sep=find(ismember(path_old,filesep));
        path_old_parrent=path_old(1:path_old_sep(end));
        movefile(fullfile(path_deactivated,'*'), path_old_parrent, 'f') ;
        rmdir(path_deactivated);
        addpath(path_old);
    catch err; 
        %disp(err.message);        
    end;
    return;
end;

% Jei pavyko parsiųsti, bandyk išpakuoti
if status == 1 ;
    try
        unzip(filestr,path_new);
        delete(filestr);
        disp(char(['Parsiuntėme ir įdiegėme papildinį!' [{}] ' ' ]));
        try
           for fpi=1:length(files_to_preserve);
              fp=files_to_preserve{fpi};
              try
                 copyfile(fullfile(tempdir,fp),fullfile(path_new,fp),'f');
              catch err;
              end;
           end;
        catch err;
        end;
        try
           eeglab;
        catch err;
        end;
    catch err;
        disp(err.message);
        disp(char(['Parsiuntėme ' filestr [{}] 'Bet nepavyko išpakuoti į ' path_new ]));
        try
            if strcmp(path_old(end),filesep);
                path_old=path_old(1:end-1);
            end ;
            path_old_sep=find(ismember(path_old,filesep));
            path_old_parrent=path_old(1:path_old_sep(end));
            movefile(fullfile(path_deactivated,'*'), path_old_parrent, 'f') ;
            rmdir(path_deactivated);
            addpath(path_old);
        catch err;
             %disp(err.message);
        end;
    end;
    try   
        savepath ;
    catch err;
        disp(err.message) ;
        %disp('Bet turite rankiniu budu issaugoti kelia.');
    end;
else
    disp(char(['Nepavyko parsiųsti ' url [{}] 'Galbūt nėra interneto ryšio.']));
    try   
        if strcmp(path_old(end),filesep);
            path_old=path_old(1:end-1);
        end ;
        path_old_sep=find(ismember(path_old,filesep));
        path_old_parrent=path_old(1:path_old_sep(end));
        movefile(fullfile(path_deactivated,'*'), path_old_parrent, 'f') ;
        rmdir(path_deactivated);
        addpath(path_old);
    catch err; 
        %disp(err.message);        
    end;
end;

%%
function restore_plugin(path_deactivated,path_old)
% Sugrąžina papildinį į seną aplanką
% path_deactivated - aplankas, į kurį buvo perkeltas deaktyvuojant
% path_old - kelias, į kurį sugrąžinama
if strcmp(path_old(end),filesep); 
   path_old=path_old(1:end-1);
end ;
path_old_sep=find(ismember(path_old,filesep));
path_old_parrent=path_old(1:path_old_sep(end));
movefile(fullfile(path_deactivated,'*'), path_old_parrent, 'f') ;
rmdir(path_deactivated);
addpath(path_old); % savepath ;
