% ERP_savybes()
%%
% 
%
% Lietuviškai
% 
%     Naudojimas:
%         >> [plotas,vidut_amplitud,x_pusei_ploto,y_pusei_ploto,min_x,min_y,max_x,max_y]=ERP_savybes(EEG) 
%         >> [plotas,vidut_amplitud,x_pusei_ploto,y_pusei_ploto,min_x,min_y,max_x,max_y]=ERP_savybes(EEG, laiko_intervalas)
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
%         >> [area,mean_amplitude,x_of_half_area,y_of_half_area,min_x,min_y,max_x,max_y]=ERP_savybes(EEG) 
%         >> [area,mean_amplitude,x_of_half_area,y_of_half_area,min_x,min_y,max_x,max_y]=ERP_savybes(EEG, time_interval)
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

function [area,mean_amplitude,x_of_half_area,y_of_half_area,min_x,min_y,max_x,max_y]=ERP_savybes(EEGTMP, varargin)
EEGTMP=EEGTMP(1);
area=[];
x_of_half_area=[];
mean_amplitude=[];
y_of_half_area=[];
%milisekundemis
time_interval=[];
nauja_kanalu_tvarka={};
if nargin > 1;     
    time_interval=varargin{1};
end;
if isempty(time_interval);
    time_interval=[EEGTMP.times(1) EEGTMP.times(end)];
end;
if nargin > 2;     
    nauja_kanalu_tvarka=varargin{2};
end;

[~, idx1] = min(abs(EEGTMP.times - time_interval(1) )) ;
[~, idx2] = min(abs(EEGTMP.times - time_interval(2) )) ;
lango_trukme=EEGTMP.times(idx2) - EEGTMP.times(idx1) ;

try 
    %disp('size(EEGTMP.erp_data)='); disp(size(EEGTMP.erp_data));
    EEGTMP.data=EEGTMP.erp_data;
    lango_erp=[EEGTMP.erp_data(:,idx1:idx2,:)];
catch err;
    %Pranesk_apie_klaida(err,'','',0);
    try
    lango_erp=mean([EEGTMP.data(:,idx1:idx2,:)],3);
    catch err;
        %disp('size(EEGTMP.data)='); disp(size(EEGTMP.data));
        %disp(['idx1=' num2str(idx1)]); disp(['idx2=' num2str(idx2)]);
        %Pranesk_apie_klaida(err,'','',0);
        rethrow(err) ;
    end;
end;

i=1;

ChN=size(EEGTMP.data,1); %EEG.nbchan;
if any(isnan(EEGTMP.data));
    ChN=0;
end;

if ~isempty(nauja_kanalu_tvarka);
    stulpeliu=length(nauja_kanalu_tvarka);
    area=nan(i,stulpeliu);
    mean_amplitude=nan(i,stulpeliu);
    x_of_half_area=nan(i,stulpeliu);
    y_of_half_area=nan(i,stulpeliu);
    min_x=nan(i,ChN+1);
    min_y=nan(i,ChN+1);
    max_x=nan(i,ChN+1);
    max_y=nan(i,ChN+1);
end;

for chan_i=1:ChN;       
    if isempty(nauja_kanalu_tvarka);
        chan_i_=chan_i;
    else
        chan_i_=find(ismember(nauja_kanalu_tvarka,chan_i));
        %disp(['.' num2str(chan_i_)]);
    end;
    if chan_i_ ~= 0 ;
        area(i,chan_i_)=trapz(EEGTMP.times(idx1:idx2), lango_erp(chan_i,:)) ;
        mean_amplitude(i,chan_i_)=area(i,chan_i_) / lango_trukme;
        half_idx2=idx1 +1 ;
        while  abs(area(i,chan_i_) / 2) > abs(trapz(EEGTMP.times(idx1:half_idx2), mean([EEGTMP.data(chan_i,idx1:half_idx2,:)],3))) ;
            half_idx2=half_idx2+1;
        end;
        x_of_half_area(i,chan_i_)=EEGTMP.times(half_idx2);
        y_of_half_area(i,chan_i_)=mean([EEGTMP.data(chan_i,half_idx2,:)]);
    end;
end;

if ChN == 0 || size(lango_erp,1) == 0;
    min_y=NaN;
    min_x=NaN;
    max_y=NaN;
    max_x=NaN;
else
    min_y(i,1:ChN)=[min(lango_erp,[],2)]';
    min_x(i,1:ChN)=EEGTMP.times(idx1 - 1 + cell2mat([cellfun(@(x) find(ismember(lango_erp(x,:),min_y(i,x)),1), ...
        num2cell(1:ChN), ...
        'UniformOutput',false)]));
    max_y(i,1:ChN)=[max(lango_erp,[],2)]';
    max_x(i,1:ChN)=EEGTMP.times(idx1 - 1 + cell2mat([ ...
        cellfun(@(x) find(ismember(lango_erp(x,:),max_y(i,x)),1), ...
        num2cell(1:ChN), ...
        'UniformOutput',false)]));
    
    if ~isempty(nauja_kanalu_tvarka);
        nauja_kanalu_tvarka=pakeisk_reiksmes(nauja_kanalu_tvarka,ChN+1,0);
        min_x=min_x(nauja_kanalu_tvarka);
        min_y=min_y(nauja_kanalu_tvarka);
        max_x=max_x(nauja_kanalu_tvarka);
        max_y=max_y(nauja_kanalu_tvarka);
    end;
end;

function B = pakeisk_reiksmes(A, newval, oldval)

%   B = pakeisk_reiksmes(A,NEWVAL), for scalar NEWVAL, replaces all zero-valued
%   entries in A with NEWVAL.
%
%   B = pakeisk_reiksmes(A,NEWVAL,OLDVAL) replaces all occurrences of NEWVAL(k) in A
%   with OLDVAL(k).  NEWVAL and OLDVAL must match in size.

error(nargchk(2, 3, nargin, 'struct'))

if nargin == 2
    oldval = zeros(size(newval));  % Probably should throw a warning here.
end

%  Test that old and new value arrays have the same number of elements.
if numel(newval) ~= numel(oldval)
    error(['map:' mfilename ':mapError'], ...
        'Inconsistent sizes for old and new code inputs')
end

B = A;
for k = 1:numel(newval)
    B(A == oldval(k)) = newval(k);
end
