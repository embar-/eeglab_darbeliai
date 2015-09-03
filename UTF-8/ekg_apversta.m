% ar_apversta=ekg_apversta(EKG,Hz,fig) 
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
if size(EKG,1) > 1; EKG=EKG'; end;

% Rasti gerą findpeaks
rehash toolbox;
findpeaks_paths=galima_fja('findpeaks',...
     '[~]=findpeaks([1 2 1],''MINPEAKDISTANCE'',1);');
% Q
[P1R,L1R]=findpeaks( EKG,'MINPEAKDISTANCE',round(0.6*Hz));
[P2R,L2R]=findpeaks(-EKG,'MINPEAKDISTANCE',round(0.6*Hz));

% T 
[P1Ta,L1Ta]=T_radimas( EKG,Hz,L1R, 1, 0.1, 0.35);
[P1Tb,L1Tb]=T_radimas( EKG,Hz,L1R,-1, 0.1, 0.35);
[P2Ta,L2Ta]=T_radimas(-EKG,Hz,L2R, 1, 0.1, 0.35);
[P2Tb,L2Tb]=T_radimas(-EKG,Hz,L2R,-1, 0.1, 0.35);

i=~isnan(P1Ta); P1Ra=P1R(i); L1Ra=L1R(i); P1Ta=P1Ta(i); L1Ta=L1Ta(i); 
i=~isnan(P1Tb); P1Rb=P1R(i); L1Rb=L1R(i); P1Tb=P1Tb(i); L1Tb=L1Tb(i); 
i=~isnan(P2Ta); P2Ra=P2R(i); L2Ra=L2R(i); P2Ta=P2Ta(i); L2Ta=L2Ta(i);
i=~isnan(P2Tb); P2Rb=P2R(i); L2Rb=L2R(i); P2Tb=P2Tb(i); L2Tb=L2Tb(i);

m=median(EKG);
m1a=median(P1Ra+P1Ta)-2*m;
m2a=median(P2Ra+P2Ta)+2*m;
m1b=median(P1Rb+P1Tb)-2*m;
m2b=median(P2Rb+P2Tb)+2*m;
[~,d]=max([ m1a m2a m1b m2b ]);
ar_apversta=~mod(d,2);

if fig;
    if d <= 2;
        grafikas(EKG, Hz, ar_apversta, L1Ra, P1Ra, L1Ta, P1Ta, L2Ra, P2Ra, L2Ta, P2Ta);
    else
        grafikas(EKG, Hz, ar_apversta, L1Tb, P1Tb, L1Rb, P1Rb, L2Tb, P2Tb, L2Rb, P2Rb);
    end;
end;


% Atstatyti findpeaks
if ~isempty(findpeaks_paths);
    addpath(findpeaks_paths);
end;

function [PT,LT]=T_radimas(EKG,Hz,LR,koef,R_plotis, T_plotis)
% koef=1 arba -1
% R_plotis=0.1 arba 0.2 sek
% T_plotis=0.35 sek
PT=nan(size(LR)); LT=nan(size(LR));
for i=1:length(LR);
    if koef > 0; nuo=LR(i); iki=min(length(EKG),LR(i)+round(koef*T_plotis*Hz));
    else         nuo=max(1,LR(i)+round(koef*T_plotis*Hz)); iki=LR(i);
    end;
    [x,o]=setdiff(nuo:iki,(LR(i)-round(R_plotis*Hz)):(LR(i)+round(R_plotis*Hz)));
    if ~isempty(x);
        if koef > 0;
            [r,v]=max(EKG(x));
            t=LR(i)+o(v)-1;
        else
            [r,v]=max(EKG(x(length(x)-[0:length(x)-1])));
            t=LR(i)-o(v)-round(R_plotis*Hz);
        end;
        PT(i)=r;
        LT(i)=t;
    end;    
end;

function grafikas(EKG, Hz, ar_apversta, L1R, P1R, L1T, P1T, L2R, P2R, L2T, P2T)
figure;
hold('on')
plot([1:length(EKG)]/Hz,EKG,'color','red');
plot(L1R/Hz, P1R, 'o', 'color',[  ar_apversta,1-ar_apversta, ar_apversta]);
plot(L1T/Hz, P1T, '*', 'color',[  ar_apversta,1-ar_apversta, ar_apversta]);
plot(L2R/Hz,-P2R, 'o', 'color',[1-ar_apversta, ar_apversta,1-ar_apversta]);
plot(L2T/Hz,-P2T, '*', 'color',[1-ar_apversta, ar_apversta,1-ar_apversta]);
title(fastif(ar_apversta,'Apversta','Neapversta'));

