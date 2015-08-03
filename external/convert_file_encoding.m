function convert_file_encoding(infile,outfile,from_encoding,to_encoding)

% if encoding is empty - use default current locale

if isempty(from_encoding);
   V= version('-release') ;
   % For MATLAB R2010b or later:
   if or(strcmp(V,'2010b'), str2num(V(1:end-1)) > 2010 )
      ret = feature('locale');
      from_encoding = ret.encoding;
   % For MATLAB R2008a through R2010a:
   elseif str2num(V(1:end-1)) >= 2008
      ret = feature('locale');
      [t,r] = strtok(ret.ctype,'.');
      from_encoding = r(2:end);
   end;
end;


if isempty(to_encoding);
   V= version('-release') ;
   if or(strcmp(V,'2010b'), str2num(V(1:end-1)) > 2010 )
      ret = feature('locale');
      to_encoding = ret.encoding;
   elseif str2num(V(1:end-1)) >= 2008
      ret = feature('locale');
      [t,r] = strtok(ret.ctype,'.');
      to_encoding = r(2:end);
   end;
end;

if strcmp(from_encoding,to_encoding);
    copyfile(infile, outfile, 'f');
    return;
end;

if strcmp(infile(end-2:end),'mdl');
    isMDL = 1;
else
    isMDL = 0;
end
 
 
fpIn = fopen(infile,'r','n',from_encoding);
fpOut = fopen(outfile,'w','n',to_encoding);
 
while feof(fpIn) == 0
    lineIn = fgets(fpIn);
    if isMDL && strncmp('SavedCharacterEncoding',strtrim(lineIn),22)
        lineIn = regexprep(lineIn,from_encoding,to_encoding);
    end
 
    fwrite(fpOut,lineIn,'char');
end
 
fclose(fpIn);
fclose(fpOut);
end

