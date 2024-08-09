%
% filter_filenames()
%
% Lietuviškai: filtruoti failų pavadinimus
% NAUDOJIMAS:
% failai=filter_filenames(raktažodis,veiksena)
%
%       raktažodis - parinktis, kuri perduodama dir komandai. Kelis
%                    raktažodžius atskirkite kabliataškiu (;), pvz., '*.set;*.cnt'.
%                    Tuščias raktažodis bus interpretuojamas kaip '*'.
%         veiksena - [0|1]:
%                    0 – rezultatas kiekvienam raktažodžio nariui grąžinamas
%                        atskirame narvelyje;
%                    1 – grąžinamas vienas nesikartojančių failų sąrašas (numatyta).
%
% English: filter names of files
% USAGE:
% files=filter_filenames(key_string,mode)
%
%       key_string - string to pass to dir command. To pass several strings,
%                    separate with semicolon (;), e.g. '*.set;*.cnt'.
%                    Empty key_string will be interpreted as '*'.
%             mode - [0|1]:
%                    0 - return result for each key_string element to
%                        separate cell;
%                    1 – return list of unique filenames in one cell (default).
%
%%
%
% (C) 2014 Mindaugas Baranauskas
%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Ši programa yra laisva. Jūs galite ją platinti ir/arba modifikuoti
% remdamiesi Free Software Foundation paskelbtomis GNU Bendrosios
% Viešosios licencijos sąlygomis: 3 licencijos versija, arba (savo
% nuožiūra) bet kuria vėlesne versija.
%
% Ši programa platinama su viltimi, kad ji bus naudinga, bet BE JOKIOS
% GARANTIJOS; taip pat nesuteikiama jokia numanoma garantija dėl TINKAMUMO
% PARDUOTI ar PANAUDOTI TAM TIKRAM TIKSLU. Daugiau informacijos galite 
% rasti pačioje GNU Bendrojoje Viešojoje licencijoje.
%
% Jūs kartu su šia programa turėjote gauti ir GNU Bendrosios Viešosios
% licencijos kopiją; jei ne - žr. <https://www.gnu.org/licenses/>.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%%

function [files]=filter_filenames(varargin)
files={};
if nargin > 0
    filter_string=varargin{1};
else
    filter_string='*';
end

if nargin > 1
    mode=varargin{2};
else
    mode=1;
end


if isempty(filter_string)
    filter_string='*';
end

if ~ischar(filter_string)
    if iscellstr(filter_string)
        for i=1:length(filter_string)
            files=[files ;  filter_filenames(filter_string{i},mode)]; %#ok
        end
        if mode
            files={files{:}};
            [~,i]=unique(files);
            files=files(sort(i));
        end
        return;
    else
        warning('*');
        filter_string='*';
    end
end
while strfind(filter_string,'**')
    filter_string=strrep(filter_string,'**','*');
end

flt=textscan(filter_string, '%s', 'delimiter', ';');
dir_out=cellfun(@(x) filter_filenames2(flt{1}{x}, (x == 1)), num2cell(1:length(flt{1})),'UniformOutput',false);
for i=1:length(dir_out)
    files_and_dirs={dir_out{i}.name};
    files_idx=find([dir_out{i}.isdir] == 0 );
    files=[files ; { files_and_dirs(files_idx) } ]; %#ok
end

if mode
    path_orig=pwd; path0='';
    files_absolute={};
    files2={};
    for f=[files{:}]
        [path1,file1,ext1]=fileparts(f{1});
        if ~isempty(path1) && ~strcmp(path0,path1)
            cd(path_orig); 
            try cd(path1); catch; end
            path0=path1;
        end
        file_absolute=fullfile(pwd,[file1 ext1]);
        if ~ismember(file_absolute, files_absolute)
            files_absolute=[files_absolute {file_absolute}]; %#ok
            files2=[files2, {f{1}}]; %#ok
        end
    end
    [~,i]=unique(files2);
    files=files2(sort(i));
    cd(path_orig);
end

function rez=filter_filenames2(str, naujai)
rez=struct('name',{},'isdir',{});
persistent dir_; 
if naujai
    dir_='' ; 
end
[dir_n,f,t]=fileparts(str);
if ~isempty(dir_n)
    dir_=dir_n;
    if ~strcmp(dir_(end),filesep)
        dir_=[dir_ filesep];
    end
    dir_=filter_dir(dir_ );
    str=[f t];
end
if ismember(pathsep,dir_)
    seplocs = strfind(dir_,pathsep);
    loc1 = [1 seplocs(1:end-1)+1];
    loc2 = seplocs(1:end)-1;
    pathfolders = arrayfun(@(a,b) dir_(a:b), loc1, loc2, 'UniformOutput', false);
    %disp(pathfolders');
else
    pathfolders={dir_};
end
for i=1:length(pathfolders)
    if ismember('*',pathfolders{i})
        % arba filter_dir funkcija nesugebejo patikslinti kelio
        %warning('Nepavyko patikslinti %s kelio', pathfolders{i})
    else 
        try
            rez_=dir(fullfile(pathfolders{i}, str));
            %rez_=dir(strrep([pathfolders{i} str],'\','/')) % testavimui
            for j=1:length(rez_)
                rez_(j).name=fullfile(pathfolders{i}, rez_(j).name);
            end
            if isempty(rez)
                rez=rez_;
            else
                rez=[rez;rez_]; %#ok
            end
        catch
            warning('Netikėta klaida "%s" kelyje ieškant "%s" rinkmenų',pathfolders{i}, str)
        end
    end
end

function dirstr=filter_dir(dirstr)

if ~strcmp(dirstr(end),pathsep)
    dirstr=[dirstr pathsep];
end

if ismember('*',dirstr)
    seplocs = strfind(dirstr,pathsep);
    loc1 = [1 seplocs(1:end-1)+1];
    loc2 = seplocs(1:end)-1;
    pathfolders = arrayfun(@(a,b) dirstr(a:b), loc1, loc2, 'UniformOutput', false);
    dirstr='';
    for i=1:length(pathfolders)
        d=pathfolders{i};
        %disp(d);
        if ismember('*',d)
            [dir1, dir21, dir22]=fileparts(d);
            dir1=pasalink_pasvirusius_bruksnius_gale(dir1);
            dir2=[dir21 dir22];
            dir3='';
            while ismember('*',dir1) && ...
               ( ~isempty([dir21 dir22]) || ... % jei tuščia kartojant ciklą - reikia nebeįmanoma nieko daugiau pašalinti nuo galo
                  isempty(dir2)) % pirmas ciklo prasukimai, jei gale buvo filesep
                [dir1, dir21, dir22]=fileparts(dir1);
                dir1=pasalink_pasvirusius_bruksnius_gale(dir1);
                dir3=dir2;
                dir2=[dir21  dir22 filesep dir2]; %#ok
            end
            if isempty(dir1); dir1='.'; end
            %disp([dir1 filesep dir21 dir22 ' x ' dir3]);
            dir_out=dir([dir1 filesep dir21 dir22]);
            files_and_dirs={dir_out.name};
            dir_idx=find([dir_out.isdir] == 1 );
            dir_idx=intersect(dir_idx,find(ismember(files_and_dirs,{'.' '..'})==0));
            if ~isempty(dir_idx)
                dir3=pasalink_pasvirusius_bruksnius_gale(dir3);
                if ~strcmp(dir1(end),filesep); dir1=[dir1 filesep]; end; %#ok
                dirstr_c=cellfun(@(v) [dir1 v filesep dir3 pathsep], files_and_dirs(dir_idx), 'UniformOutput',false );
                dirstr_c=unique(dirstr_c);
                dirstr_= [dirstr_c{:}];
                dirstr=[dirstr filter_dir(dirstr_)]; %#ok
            elseif ismember('*',d)
                % kelyje su * nieko nera: nera kaip isskleisti,
                if isempty(dirstr)
                    % bet tiek reikia grazinti, kad neziuretu i "./" kataloga...
                    % ir butinai gale prideti filesep, kad nebutu netycia **
                    dirstr=[d filesep pathsep ];
                end
            else
                dirstr=[dirstr d pathsep ]; %#ok
            end
        else
            dirstr=[dirstr d pathsep ]; %#ok
        end
    end
end

function dir1=pasalink_pasvirusius_bruksnius_gale(dir1)
if ispc
    while ~isempty(dir1) && ( strcmp(dir1(end),'\') || strcmp(dir1(end),'/') )
        dir1=dir1(1:end-1);
    end
elseif isunix
    while length(dir1) > 1 && strcmp(dir1(end),'/')
        dir1=dir1(1:end-1);
    end
end
