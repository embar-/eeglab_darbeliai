function nr=max_pakatalogio_nr(katalogas)
d=dir(katalogas);
d0={d(find([d.isdir])).name};
d1=arrayfun(@(x) textscan(d0{x},'%[0123456789]'), 3:length(d0),'UniformOutput', false);
d2=[d1{:}];
if isempty(d2); nr=0; return; end;
d2=d2(find(~cellfun(@isempty,d2)));
d3=[d2{:}];
d4=[]; for i=1:length(d3); d4=[d4 str2num(d3{i})]; end;
nr=max(d4);
if isempty(nr); nr=0; end;
