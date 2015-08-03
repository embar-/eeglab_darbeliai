% lokaliz()
%
% Naudojimas:
%   lokalizuotas_tekstas = localiz(originalus_tekstas);
%
% Usage:
%   lokalizd_text = lokaliz(original_text);
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

function txt=lokaliz(orig_txt)

persistent LC_TXT LC_info LC_current_locale warning_no_translation function_dir;

msg='';
txt='';
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
i=[];
LANG_id_fallback=2;
data_file='lokaliz.mat';
try
    enc=feature('DefaultCharacterSet');
catch
    enc=get(0,'language');
end;

% create example of locale_txt.mat :
% LC_info=struct('LANG', {'--' 'en' 'lt'}, 'COUNTRY', {'' 'US' 'LT'}, 'VARIANT', {'' '' ''});
% LC_TXT={ ...
%      'OK_button'     'OK'     'Gerai'    ; ...
%      'Cancel_button' 'Cancel' 'Atšaukti' ; ...
%      'Close_button'  'Close'  'Užverti'  ; ...
%      'Copy_button'   'Copy'   'Kopijuoti'; ...
%          } ;
% save('locale_txt.mat', LC_info, LC_TXT ) ;

try
   if isempty(LC_current_locale);
       if usejava('awt');
           LC=javaObject ('java.util.Locale','');
           LC_current_locale=LC.getDefault();
       else
           try load('Darbeliai_config.mat','-mat');
               lnt=[{'getLanguage' 'getCountry' 'getVariant'}; Darbeliai.nuostatos.lokale' ];
               LC_current_locale=struct(lnt{:});
           catch
               LC_current_locale=struct('getLanguage','--','getCountry','','getVariant','');
           end;
       end;
   end;
   if or(isempty(LC_TXT),isempty(LC_info)) ;
      %disp('load locale');
      try
         load(fullfile(function_dir,data_file));
      catch err;
          LC_info=struct('LANG', {'--'}, 'COUNTRY', {''}, 'VARIANT', {''});
          LC_TXT={''};
      end;
   end ;
   LANG_id=find(ismember({LC_info.LANG},char(LC_current_locale.getLanguage())));
   %disp(LANG_id);
   if length(LANG_id) > 1;
       LANG_id=intersect(LANG_id,find(ismember({LC_info.COUNTRY},char(LC_current_locale.getCountry()))));
   end;
   if length(LANG_id) > 1;
       LANG_id=intersect(LANG_id,find(ismember({LC_info.VARIANT},char(LC_current_locale.getVariant()))));
   end;
   if isempty(LANG_id);
       LANG_id=LANG_id_fallback;
       if isempty(warning_no_translation);
       warning_no_translation=1;
       n=num2str(1+length(LC_info));
       msg=sprintf( [ '\nCurrently there is no translation for %s_%s locale.\n' ...
           'Your can lokaliz it youself! \n' ...
           '1) import localization file by executing:' ...
           '\n  load('' %s%s '');\n' ...
           '2) create info about new language by executing: ' ...
           '\n  LC_info(' n ').LANG=''%s'';' ...
           '\n  LC_info(' n ').COUNTRY=''%s'';'  ...
           '\n  LC_info(' n ').VARIANT=''%s'';\n'   ...
           '3) edit ' n ' column in LC_TXT variable;\n' ...
           '4) write your localization to disk by executing:' ...
           '\n  save(''%s%s'',... \n   ''LC_info'', ''LC_TXT'') ;\n' ...
           '5) clear catch by executing:' ...
           '\n  clear(''lokaliz'');\n' ] , ...
           char(LC_current_locale.getLanguage()),  ...
           char(LC_current_locale.getCountry()), ...
           function_dir, data_file,...
           char(LC_current_locale.getLanguage()),  ...
           char(LC_current_locale.getCountry()),  ...
           char(LC_current_locale.getVariant()), ...
           function_dir, data_file);
       %error(msg);
       end;
   end;

   i=find(ismember(LC_TXT(:,1),orig_txt));
   if length(i) > 1 ;
       i=i(1);
   end;
   %if isempty(i) ;
      %load(data_file);
      %i=find(ismember(LC_TXT(:,1),orig_txt),1);
      if isempty(i) ;
         n=num2str(1+size(LC_TXT,1));
         l=cellfun(@(x) ([LC_info(x).LANG '_' LC_info(x).COUNTRY]), num2cell(2:length(LC_info)), 'UniformOutput',false) ;
         k=[ num2cell(2:size(LC_TXT,2)) ; l ];
         if isempty(k);
             k={2 ; [char(LC_current_locale.getLanguage()) '_' char(LC_current_locale.getCountry())] };
         end;
         msg=sprintf([ '%s\n' ...
           'String ''%s'' is not included for translation.\n' ...
           'Your can improve localization! \n' ...
           '1) import localization file by executing:' ...
           '\n  load(''%s%s'');\n' ...
           '2) add keyword to 1st column of LC_TXT variable by executing:' ...
           '\n  LC_TXT{' n ',1}=''%s'';\n' ...
           '3) add translations for ' ...
           sprintf('%s, ', l{:}) 'by executing:\n' ...
           sprintf(['  LC_TXT{' n ',%d}=''translation to %s'';\n' ], k{:}) ...
           '4) write your localization to disk by executing:' ...
           '\n  save(''%s%s'',... \n   ''LC_info'', ''LC_TXT'') ;\n' ...
           '5) clear catch by executing:' ...
           '\n  clear(''lokaliz'');\n' ], ...
           msg, orig_txt, ...
           function_dir, data_file, orig_txt, ...
           function_dir, data_file);
      end;
   %end;

   %disp(i);

   txt=[LC_TXT{i,LANG_id}];
   if isempty(txt);
      if and(~isempty(i),~isempty(LANG_id));
          msg=sprintf([ '\n' ...
           'String ''%s'' is not translated to ' char(LC_current_locale) '.\n' ...
           'Your can improve localization! \n' ...
           '1) import localization file by executing:' ...
           '\n  load(''%s%s'');\n' ...
           '2) add translation for ' char(LC_current_locale) ' by executing:\n' ...
           sprintf(['  LC_TXT{%d,%d}=''translation to %s'';\n' ], i, LANG_id, char(LC_current_locale)) ...
           '3) write your localization to disk by executing:' ...
           '\n  save(''%s%s'',... \n   ''LC_info'', ''LC_TXT'') ;\n' ...
           '4) clear catch by executing:' ...
           '\n  clear(''lokaliz'');\n' ], ...
           orig_txt, ...
           function_dir, data_file, ...
           function_dir, data_file);
          warning(msg);
          msg='';
      end;
      txt=[LC_TXT{i,LANG_id_fallback}];
   end;

   if ~strcmp(enc,'UTF-8');
       bytes=unicode2native(txt,enc);
       %disp(bytes);
       txt=native2unicode(bytes,enc);
   end;


   if ~isempty(msg);
%       if ~strcmp(enc,'UTF-8');
%           msg=sprintf([ msg '\n' ...
%              'NOTE: all data in ' function_dir data_file ' should be in unicode (UTF-8) encoding!\n' ...
%              'Try switch to unicode by executing\n' ...
%              ' feature(''DefaultCharacterSet'',''UTF-8'');\n' ...
%              'Return to current encoding by executing:\n' ...
%              ' feature(''DefaultCharacterSet'',''' enc ''');\n' ]);
%       end;
       msg=sprintf(['\n' msg ]);
       error(msg);
   end;

catch err ;
   warning(err.message);
   if isempty(txt);
      txt=orig_txt;
   end;
end;


