function [drbst,s,gitst]=github_darbeliu_versijos(varargin)
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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% (C) 2015 Mindaugas Baranauskas
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

if nargin > 0; naujausia=varargin{1};
else           naujausia=0;
end;
drbst=struct('versija','','url_versijai','','url_atnaujinimui','','komentaras','');
try [s,gitst]=github_releases('embar-','eeglab_darbeliai','application/zip',naujausia);
catch
    disp('Patikrinkite interneto ryšį!');
    s=[]; gitst=[];
    return;
end;
for i=1:length(s);
    switch s(i).branch
        case {'stable'}
            drbst(i).stabili_versija = 1;
        case {'master'}
            drbst(i).stabili_versija = 0;
        otherwise
            drbst(i).stabili_versija =-1;
    end;
    drbst(i).versija=[ s(i).tag ];
    drbst(i).versija_=[ s(i).tag ' (' ...
        fastif(drbst(i).stabili_versija == 1,...
        lower(lokaliz('Stable version')),...
        lower(lokaliz('Trunk version'))) ...
        fastif(isempty(s(i).binname),'', [' - ' s(i).binname] ) ')' ];
    drbst(i).url_versijai=['https://raw.githubusercontent.com/embar-/eeglab_darbeliai/' s(i).tag '/Darbeliai.versija'];
    drbst(i).url_atnaujinimui=s(i).bin_url;
    drbst(i).sukurta=s(i).created;
    drbst(i).komentaras=sprintf('%s\n \n--\n %s / %s\n %s (%s)',...
        regexprep(regexprep(s(i).comment,'\\n','\n'),'\\r',''),...
        s(i).created,...
        s(i).publish,...
        s(i).binname,...
        num2str(s(i).downloads));
end;

function [s,gitst]=github_releases(user, repo, archive, latest)
s=struct('tag','','branch','','binname','','bin_url','','downloads','',...
    'created','','publish','','comment','');
git_url=['https://api.github.com/repos/' user '/' repo '/releases'];
if latest;
    git_url=[ git_url '/latest' ];
end;
git_rsp=urlread(git_url);
gitst  =json2matlab(git_rsp);
if isempty(gitst);
    return;
end;
tag={};
branch={};
binname={};
bin_url={};
downloads={};
created={};
publish={};
comment={};
for i=1:length(gitst);
    try
        zi=find(ismember({gitst(i).assets.content_type},archive));
        if isempty(zi);
            j=1; bin_url{end+1}  = gitst(i).zipball_url;
                 downloads{end+1}= NaN;
                 binname{end+1}  = '';
        elseif length(zi) == 1;
            j=1; bin_url{end+1}  = gitst(i).assets(zi).browser_download_url;
                 downloads{end+1}= gitst(i).assets(zi).download_count;
                 binname{end+1}  = gitst(i).assets(zi).name;
        else
            j=zi;
            for  z=1:length(zi);
                 bin_url{end+1}  = gitst(i).assets(zi(z)).browser_download_url;
                 downloads{end+1}= gitst(i).assets(zi(z)).download_count;
                 binname{end+1}  = gitst(i).assets(zi(z)).name;
            end;
        end;
    catch err;
        j=1;     bin_url{end+1}  = gitst(i).zipball_url;
                 downloads{end+1}= NaN;
                 binname{end+1}  = '';
    end;
    tag(end+1:end+j)    ={gitst(i).tag_name};
    branch(end+1:end+j) ={gitst(i).target_commitish};
    created(end+1:end+j)={gitst(i).created_at};
    publish(end+1:end+j)={gitst(i).published_at};
    comment(end+1:end+j)={gitst(i).body};
end;

s=struct(...
    'tag',      tag,...
    'branch',   branch,...
    'binname',  binname,...
    'bin_url',  bin_url,...
    'downloads',downloads,...
    'created',  created,...
    'publish',  publish,...
    'comment',  comment);


function s=json2matlab(jsonstr)
evalstr=strrep(jsonstr, '''','´');
evalstr=strrep(strrep(evalstr, '"}','''}'),'{"','{''');
evalstr=strrep(strrep(evalstr,'":',''','),':"',',''');
evalstr=strrep(strrep(evalstr,'",',''','),',"',',''');
evalstr=strrep(strrep(evalstr,'[{','{{'),'}]','}}');
evalstr=strrep(evalstr,'''label'',null','''label'',''''');
jsoncel=eval(evalstr);
s=struktynas1(jsoncel);


function s=struktynas1(c)
(1:length(c)/2)*2-1;
if iscellstr(c((1:length(c)/2)*2-1));
    s=struktynas2(c);
else
    s=struct();
    for i=1:length(c);
        s1=struktynas2(c{i});
        fn = fieldnames(s1);
        for fi = 1:size(fn,1)
            s(i).(fn{fi}) = s1.(fn{fi});
        end
    end;
end;


function s=struktynas2(c)
i=find(cellfun(@iscell, c));
l=find(cell2mat(cellfun(@length, c(i),'UniformOutput',false)) > 1);
for k1=1:length(l);
    c{i(l(k1))}=c(i(l(k1)));
end;
s=struct(c{:});
for k2=1:length(i);
    s.(c{i(k2)-1})=struktynas1(s.(c{i(k2)-1}));
end;
