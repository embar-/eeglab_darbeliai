function h=Pranesk_apie_klaida(varargin)
% h=Pranesk_apie_klaida(err, Darbelis, Rinkmena, dialogas)
%
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
% licencijos kopiją; jei ne - rašykite Free Software Foundation, Inc., 59
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
%
% (C) 2014, Mindaugas Baranauskas
%

if nargin > 0 ;
    err = varargin{1};
else
    err = lasterror ;%#ok
end;

if nargin > 1 ;
    Darbelis = varargin{2};
else
    Darbelis = '?' ;
end;

if nargin > 2 ;
    Rinkmena = varargin{3};
else
    Rinkmena = '?' ;
end;

if nargin > 3 ;
    dialogas = varargin{4};
else
    dialogas = 1 ;
end;

if nargin > 4 ;
    laukti  = varargin{5};
else
    laukti  = 0 ;
end;

%assignin('base', 'err', err)
disp(' ');

h=[];
t=datestr(now, 'yyyy-mm-dd HH:MM:SS'); disp(t);
msg=sprintf('%s\n\n%s\n',err.identifier, err.message); 
for i=1:(length(err.stack)-1); 
    msg=sprintf('%s\n> <a href="matlab:opentoline(''%s'',%d,1)">%s:%d</a>', msg, ...
        err.stack(i).file, ...
        err.stack(i).line, ...
        err.stack(i).name, ...
        err.stack(i).line ) ; 
end;
if ~isempty(err.stack);
    msg=sprintf('%s\n\n  %s\n\n',msg,err.stack(end).name);
end;
%msg=sprintf('%s\n\n',msg);
s=warning('off','backtrace');
warning(msg);

if strcmp('MATLAB:binder:loadFailure',err.identifier);
   warning(['<a href="matlab:web http://stackoverflow.com/questions/19268293/matlab-error-cannot-open-with-static-tls -browser">' ...
            'http://stackoverflow.com/questions/19268293/matlab-error-cannot-open-with-static-tls</a> ' ...
            fullfile(matlabroot,'toolbox','local','startup.m')  ...
            ' webutils.htmlrenderer(''basic''); ' ]);
   
   h=errordlg([ lokaliz('You must restart MATLAB because of internal error.') ...
       ' http://stackoverflow.com/questions/19268293/matlab-error-cannot-open-with-static-tls' ], ...
       'MATLAB','replace') ;
   set(h,'DeleteFcn', 'exit');
   %set(allchild(h),'Callback', 'exit');   
   waitfor(h); h=[];
   
   error(lokaliz('You must restart MATLAB because of internal error.'));
end;

warning(s.state,'backtrace');


if ~dialogas ;
    return;
end;

msg2=strrep(regexprep(err.message,'<a href="[^<]*">','"'),'</a>','"');
h=msgbox(sprintf(['%s\n\n' ...
    lokaliz('Time:') ' %s\n' ...
    lokaliz('Darbelis:') ' %s\n' ...
    lokaliz('Failas:') ' %s'], ...
    msg2, t, Darbelis, Rinkmena),err.identifier,'error');
    
if laukti;
   waitfor(h); h=[];
end;
