function lokaliz_rengykle

%
% (C) 2014 Mindaugas Baranauskas
%
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

s={'lokaliz.mat' '../lokaliz.mat'};
for i=1:length(s);
    r=s{i};
    if exist(r,'file') == 2;
        break;
    end;
end;
r=which(r);
load(r,'-mat');
f=figure;
set(f,'Name',r,'NumberTitle','off');
l= ismember(ones(1,size(LC_TXT,2)),1);
t=uitable(f,'data',LC_TXT,'ColumnName', {LC_info.LANG }, 'Units', 'normalized', 'position', [0.02 0.15 0.96 0.8],'ColumnEditable',l,'tag','lentele', 'userdata',LC_info,...
    'CellEditCallback','LC_TXT=get(findobj(gcf,''tag'',''lentele''),''data''); LC_info=get(findobj(gcf,''tag'',''lentele''),''userdata''); save(get(gcf,''name''),''LC_info'', ''LC_TXT'') ; clear(''lokaliz'');');
set(t,'units','pixels');
d=get(t,'position'); p=(d(3)-70)/3;
set(t,'ColumnWidth',{p p p});
set(t,'units','normalized');
e=uicontrol('style','edit', 'Units', 'normalized', 'position', [0.12 0.05 0.86 0.05], 'tag','filtras','callback', ...
    ['LC_TXT=get(findobj(gcf,''tag'',''lentele''),''data'');  disp(''--''); '...
    ' for i=1:3; disp(LC_TXT(ismember(LC_TXT(:,i), atrinkti_teksta(LC_TXT(:,i), [''*'' get(gcbo,''string'') ''*'' ])),:) ); end;' ...
    ' disp(''--''); ']);
p=uicontrol('style','pushbutton', 'String', '+', 'Units', 'normalized', 'position', [0.02 0.05 0.1 0.05], 'callback', ...
    ['LC_TXT=get(findobj(gcf,''tag'',''lentele''),''data'');'...
    'LC_TXT{1+size(LC_TXT,1),1}=get(findobj(gcf,''tag'',''filtras''),''string'');'...
    'set(findobj(gcf,''tag'',''lentele''),''data'', LC_TXT);']);

