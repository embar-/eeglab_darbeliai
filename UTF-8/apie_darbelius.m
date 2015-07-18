function apie_darbelius(varargin)
% apie_darbelius - trumpa informacija apie Darbelius
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

function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
vers='Darbeliai';
try
    fid_vers=fopen(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai.versija'));
    vers=regexprep(regexprep(fgets(fid_vers),'[ ]*\n',''),'[ ]*\r','');
    fclose(fid_vers); 
catch
end;

if strcmp(char(java.util.Locale.getDefault()),'lt_LT');
    antr='Apie „Darbelius“';
else
    antr=[lokaliz('Apie') ' Darbeliai'];
end;

msg={vers 
    ' ' 
    '(c) 2014-2015 Mindaugas Baranauskas'};

% % Ženkliukas
% try
%     h=msgbox(' ', antr);
%     [ic,map]=imread(... %fullfile(matlabroot, 'toolbox', 'matlab', 'icons', 'csh_icon.png'),...
%         fullfile(matlabroot, 'toolbox', 'shared', 'controllib', 'general', 'resources', 'toolstrip_icons', 'Help_24.png'),...
%         'BackgroundColor',get(h,'Color'));
%     ic={'custom',ic,map};
% catch
%    ic={'help'};
%end;

s.Interpreter='none';
s.WindowStyle='replace';
%msgbox(msg, antr, ic{:}, s);
msgbox(msg, antr, s);





