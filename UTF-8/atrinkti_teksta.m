function atrinktas_tekstas=atrinkti_teksta(teksto_eilutes,teksto_filtras)
atrinktas_tekstas={};
if ischar(teksto_eilutes);
   teksto_eilutes=cellstr(teksto_eilutes);
end;
if ~iscellstr(teksto_eilutes);
    return;
end;
if ismember(';',teksto_filtras);
   teksto_filtrai=regexp(teksto_filtras,';', 'split');
   for i=1:length(teksto_filtrai);
      tmp=atrinkti_teksta(teksto_eilutes,teksto_filtrai{i});
      atrinktas_tekstas=[atrinktas_tekstas{:} tmp];
      [~,idx]=unique(atrinktas_tekstas);
      atrinktas_tekstas=atrinktas_tekstas(sort(idx));
   end;
else
    teksto_filtras=strrep(teksto_filtras, '.', '\.' );
    teksto_filtras=strrep(teksto_filtras, '(', '\(' );
    teksto_filtras=strrep(teksto_filtras, ')', '\)' );
    teksto_filtras=strrep(teksto_filtras, '[', '\[' );
    teksto_filtras=strrep(teksto_filtras, ']', '\]' );
    teksto_filtras=strrep(teksto_filtras, '*', '.*' );
    atrinktas_tekstas=regexp(teksto_eilutes, [ '^' teksto_filtras '$' ] , 'match');
    atrinktas_tekstas=[atrinktas_tekstas{:}];
end;


