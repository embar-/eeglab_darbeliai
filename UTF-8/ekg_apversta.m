% ar_apversta=ekg_apversta(EKG,Hz) 
% Hz - sampling rate
%
% (C) 2015 Mindaugas Baranauskas
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
%%

function ar_apversta=ekg_apversta(EKG,Hz,fig)

EKG=double(EKG);

% Rasti gerą findpeaks
rehash toolbox;
findpeaks_paths=galima_fja('findpeaks',...
     'findpeaks([1 2 1],''MINPEAKDISTANCE'',1);');
% Q
[P1R,L1R]=findpeaks( EKG,'MINPEAKDISTANCE',round(0.6*Hz));
[P2R,L2R]=findpeaks(-EKG,'MINPEAKDISTANCE',round(0.6*Hz));

% T
P1T=[]; L1T=[];
for i=1:length(L1R);
    [x,o]=setdiff(L1R(i):min(length(EKG),L1R(i)+round(0.3*Hz)),(L1R(i)-round(0.1*Hz)):(L1R(i)+round(0.1*Hz)));
    if isempty(x);
        P1T=[P1T NaN];
        P1M=[P1M NaN];
        L1T=[L1T NaN];
    else
        [r,v]=max(EKG(x));
        t=L1R(i)+o(v)-1;
        P1T=[P1T r];
        L1T=[L1T t];
    end;    
end;
P2T=[]; L2T=[];
for i=1:length(L2R);
    [x,o]=setdiff(L2R(i):min(length(EKG),L2R(i)+round(0.3*Hz)),(L2R(i)-round(0.1*Hz)):(L2R(i)+round(0.1*Hz)));
    if isempty(x);
        P2T=[P2T NaN];
        L2T=[L2T NaN];
    else
        [r,v]=min(EKG(x));
        t=L2R(i)+o(v)-1;
        P2T=[P2T r];
        L2T=[L2T t];
    end;    
end;

i=~isnan(P1T); P1R=P1R(i); L1R=L1R(i); P1T=P1T(i); L1T=L1T(i); 
i=~isnan(P2T); P2R=P2R(i); L2R=L2R(i); P2T=P2T(i); L2T=L2T(i);

m=mean(EKG);
ar_apversta = (median(P1R+P1T)-m) < (median(P2R-P2T)-m);

if fig;
    figure;
    hold('on')
    plot([1:length(EKG)]/Hz,EKG,'color','red');
    plot(L1R/Hz, P1R, 'o', 'color',[  ar_apversta,1-ar_apversta, ar_apversta]);
    plot(L1T/Hz, P1T, '*', 'color',[  ar_apversta,1-ar_apversta, ar_apversta]);
    plot(L2R/Hz,-P2R, 'o', 'color',[1-ar_apversta, ar_apversta,1-ar_apversta]);
    plot(L2T/Hz, P2T, '*', 'color',[1-ar_apversta, ar_apversta,1-ar_apversta]);
    title(fastif(ar_apversta,'Apversta','Neapversta'));
end;


% Atstatyti findpeaks
if ~isempty(findpeaks_paths);
    addpath(findpeaks_paths);
end;
