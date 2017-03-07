function versija=Darbeliu_versija
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
versija='Darbeliai';
try
    fid_vers=fopen(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai.versija'));
    versija=regexprep(regexprep(fgets(fid_vers),'[ ]*\n',''),'[ ]*\r','');
    fclose(fid_vers); 
catch
end;
