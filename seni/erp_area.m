% erp_area()
%%
% 
%
% Lietuviškai
% 
%     Naudojimas:
%         >> [plotas,x_pusei_ploto,y_pusei_ploto]=erp_area(EEG) 
%         >> [plotas,x_pusei_ploto,y_pusei_ploto]=erp_area(EEG, laiko_intervalas)
%         
%     Įvedimas:
%         EEG               - EEGLAB EEG duomenys
%         laiko_intervalas  - [pradžia pabaiga], milisekundėmis
% 
%     Išvedimas: 
%         plotas            - plotas po kreive (integralas)
%         x_pusei_ploto     - laikas, ties kuriuo plotas padalinamas į dvi
%                              lygias dalis, milisekundėmis
%         y_pusei_ploto     - amplitudė ties x_pusei_ploto
%                          
% 
% 
% English
% 
%     Usage:
%         >> [area,x_of_half_area,y_of_half_area]=erp_area(EEG) 
%         >> [area,x_of_half_area,y_of_half_area]=erp_area(EEG, time_interval)
%         
%     Input:
%         EEG            - EEGLAB EEG data
%         time_interval  - [start end] in miliseconds
% 
%     Output: 
%         area           - area (integral) under curve
%         x_of_half_area - time in miliseconds to split
%                          area in two equal parts
%         y_of_half_area - amplitude at x_of_half_area
%%
%
% (C) 2014 Mindaugas Baranauskas
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

function [area,x_of_half_area,y_of_half_area]=erp_area(EEG, varargin)

%milisekundemis
time_interval=[];
if nargin > 1;     
    time_interval=varargin{1};
end;
if isempty(time_interval);
    time_interval=[EEG.times(1) EEG.times(end)];
end;

[~, idx1] = min(abs(EEG.times - time_interval(1) )) ;
[~, idx2] = min(abs(EEG.times - time_interval(2) )) ;

area=[];
x_of_half_area=[];

for chan_i=1:size(EEG.data,1)  %EEG.nbchan;
    area(1,chan_i)=trapz(EEG.times(idx1:idx2), mean([EEG.data(chan_i,idx1:idx2,:)],3)) ;
    half_idx2=idx1 +1 ;
    while  abs(area(1,chan_i) / 2) > abs(trapz(EEG.times(idx1:half_idx2), mean([EEG.data(chan_i,idx1:half_idx2,:)],3))) ;
        half_idx2=half_idx2+1;
    end;
    x_of_half_area(1,chan_i)=EEG.times(half_idx2);
    y_of_half_area(1,chan_i)=mean([EEG.data(chan_i,half_idx2,:)]);
end;