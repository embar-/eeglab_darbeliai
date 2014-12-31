function x_txt=num2str2(x)

if isempty(x);
    x_txt='';
    return;
end;

if ~isnumeric(x);
    x_txt=x;
    return;
end;

x_txt=num2str(x(1));
x_diff=diff(x);
x_not_seq=find(x_diff~=1);
for i=1:length(x_diff);
    if ismember(i, x_not_seq);
        x_txt=[ x_txt ' ' num2str(x(1+i)) ];
    elseif or(ismember(1+i, x_not_seq),i==length(x_diff));
        x_txt=[ x_txt ':' num2str(x(1+i)) ];
    end;
end;