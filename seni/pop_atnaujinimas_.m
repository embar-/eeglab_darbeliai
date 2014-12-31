%
% Atnaujinti
%
% (C) 2014 Mindaugas Baranauskas
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

function varargout = pop_atnaujinimas_(varargin)

Tekstas=[{}];
sena_versija='';
nauja_versija='';
curdir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );

if length(varargin) > 1 ;
    sena_versija=varargin{2};
else    
     try
         fid_vers=fopen(fullfile(curdir,'Darbeliai.versija'));
         vers=fgets(fid_vers);
         sena_versija=vers(1:end-1);
         fclose(fid_vers);
     catch err;
         disp(err.message);
     end;
end ;
if ~isempty(sena_versija)
    Tekstas=[  lokaliz('Naudojate') ; sena_versija '.' ; {' '} ];
end;

if length(varargin) > 2 ;  
   nauja_versija=varargin{3};   
else   
    url='https://www.dropbox.com/s/q57pntndm704isv/Darbeliai.versija?dl=1';
    status=0;
    disp(lokaliz('Checking for updates...'));
    try
    [filestr,status] = urlwrite(url,fullfile(tempdir,'Darbeliai_versija.txt'));
    catch err;
    end;
    if status
        fid_nvers=fopen(filestr);
        nauja_versija=fgets(fid_nvers);
 	   nauja_versija=nauja_versija(1:end-1);
        %disp(size(nauja_versija));
        fclose(fid_nvers); 
        try delete(filestr); catch err; end;
    end;
end ;
if isempty(nauja_versija);
    Tekstas=[ Tekstas ; [lokaliz('Ar norite pabandyti atnaujinti?') ]];
elseif strcmp(sena_versija,nauja_versija)
    Tekstas=[ Tekstas ; [lokaliz('You use latest version.') ' ' lokaliz('Update anyway?') ]];
else
    Tekstas=[ Tekstas ; lokaliz('Rasta nauja versija') ': ' ; [nauja_versija '.'] ];
    Tekstas=[ Tekstas ; ' ' ;[lokaliz('Ar norite pabandyti atnaujinti?') ]];
end;

choice = questdlg(Tekstas, lokaliz('Update_noun'), ...
    lokaliz('Close'), lokaliz('Update'), lokaliz('Update')) ;

switch choice
    case lokaliz('Update')
        disp(lokaliz('Palaukite!'));
        disp(lokaliz('Atnaujinima...'));
        try
            atnaujinimas();
        catch err;
            disp(err.message);
        end;
end ;



