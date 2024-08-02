function lokaliz_rengykle

%
% (C) 2014, 2023, 2024 Mindaugas Baranauskas
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
if isempty(r)
    function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
    r=fullfile(function_dir,s{1});
    LC_info=struct('LANG', {'--' 'en' 'lt'}, 'COUNTRY', {'' 'US' 'LT'}, 'VARIANT', {'' '' ''});
    LC_TXT={ ...
        'LT' 'Lithuanian' 'Lietuviškai'; ...
        'EN' 'English'    'Angliškai'  ; ...
        } ;
else
    load(r, 'LC_info','LC_TXT', '-mat');
    copyfile(r,[r '~'],'f')
end

f=figure;
set(f,'Name',r,'NumberTitle','off','Units', 'normalized');
set(f,'Position',[0.05 0.1 0.6 0.8]);
l= ismember(ones(1,size(LC_TXT,2)),1);
k=arrayfun(@(i) regexprep(sprintf('%s_%s', LC_info(i).LANG, LC_info(i).COUNTRY),'_$',''), 1:length(LC_info), 'UniformOutput', false); % {'--'}    {'en_US'}    {'lt_LT'}
if isempty(k) || isempty(k{1})
    k(1) = {'--'};
end
t=uitable(f,'data',LC_TXT,'ColumnName',k , 'Units', 'normalized', 'position', [0.02 0.15 0.96 0.8],'ColumnEditable',l,'tag','lentele', 'userdata',LC_info,...
    'CellEditCallback','LC_TXT=get(findobj(gcf,''tag'',''lentele''),''data''); LC_info=get(findobj(gcf,''tag'',''lentele''),''userdata''); save(get(gcf,''name''),''LC_info'', ''LC_TXT'') ; clear(''lokaliz'');');
set(t,'units','pixels');
d=get(t,'position'); p=(d(3)-70)/3;
set(t,'ColumnWidth',{p p p});
set(t,'units','normalized');
%cmd=['LC_TXT=get(findobj(gcf,''tag'',''lentele''),''data'');  ans={}; '...
%    ' for i=1:3; ans=[ans; (LC_TXT(ismember(LC_TXT(:,i), atrinkti_teksta(LC_TXT(:,i), [''*'' get(gcbo,''string'') ''*'' ])),:) )]; end;' ...
%    ' if ~isempty(ans); ans=unique(cell2table(ans,''VariableNames'',get(findobj(gcf,''tag'',''lentele''),''ColumnName'')),''rows'',''stable''); disp(ans); else  disp(''--''); end; '];
uicontrol('style','edit', 'Units', 'normalized', 'position', [0.02 0.05 0.86 0.05], 'tag','filtras','callback', @atranka);
uicontrol('style','pushbutton', 'String', '+', 'Units', 'normalized', 'position', [0.88 0.05 0.1 0.05], 'callback', @naujas);
set(f,'ResizeFcn',@LangoDydisPasikeite)

function atranka(h,~)
f=ancestor(h,'figure','toplevel');
h_lent=findobj(f,'tag','lentele');
LC_TXT=get(h_lent,'data');  
ids=[]; 
for i=1:3
    atr=atrinkti_teksta(LC_TXT(:,i), ['*' get(gcbo,'string') '*' ]);
    if ~isempty(atr)
        ids1=find(ismember(LC_TXT(:,i), atr));
        ids=[ids; ids1]; %#ok
    end
end
ids=unique(ids);
if ~isempty(ids)
    ats=LC_TXT(ids,:);
    for i=1:numel(ats)
        % kartais langelis būna tuščias ir skaitinis - tada jį reikia konvertuoti į raidinį
        if isempty(ats{i}) && isnumeric(ats{i})
            ats{i}=' '; 
        end
    end
    ats=cell2table(ats,'VariableNames',get(h_lent,'ColumnName'),'RowNames',arrayfun(@num2str,ids,'UniformOutput',false)); 
    disp(ats); 
else
    disp('--');
end

function naujas(h,varargin)
f=ancestor(h,'figure','toplevel');
h_lent=findobj(f,'tag','lentele');
h_fltr=findobj(f,'tag','filtras');
LC_TXT=get(h_lent,'data');
LC_TXT(1+size(LC_TXT,1),[1,end])={get(h_fltr,'string')};
set(h_lent,'data', LC_TXT);

function LangoDydisPasikeite(h,~)
f=ancestor(h,'figure','toplevel');
t=findobj(f,'tag','lentele');
set(t,'units','pixels');
d=get(t,'position'); p=(d(3)-70)/3;
set(t,'ColumnWidth',{p p p});
set(t,'units','normalized');
