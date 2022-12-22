function [RR_idx,RRI]=QRS_detekt(EKG, sampling_rate, mode, varargin)
%[RR_idx,RRI]=QRS_detekt(EKG,sampling_rate)
%[RR_idx,RRI]=QRS_detekt(EKG,sampling_rate,mode)
%
% mode – veiksena(-os) arba algoritmas (-ai):
%        1 arba 'PT'  - Pan ir Tompkin
%        2 arba 'DPI' - Ramakrishnan ir kt. pagal „Dynamic Plosion Index“
%        3 arba 'ECGlab', 'MOBD' - Suppappola ir Sun pagal 
%               „multiplication of backward differences“
%        4 – Sedghamiz adaptive detector
%        Jei nenurodyta jokia veiksena, naudojama 'PT'.
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
% (C) 2014-2015, 2020 Mindaugas Baranauskas
%%

SR=sampling_rate;
qrs=[]; 
RR_idx=[];

if length(EKG)/SR < 2.5 ; 
   warning('EKG too short!');
   return; 
end;


if nargin < 3 ;
    mode = 'PT';
end

if nargin > 3 ;
    leisti_apversti=varargin{1};
else
    leisti_apversti=1;
end;

for i=1:length(mode)
    RR_idx_1=QRS_detekt_single(EKG, SR, mode(i), leisti_apversti);
    if i == 1
        RR_idx=RR_idx_1;
    else
        [idx_,D_]=knnsearch(RR_idx_1,RR_idx);
        if isempty(idx_); RR_idx=[]; break; end;
        sut_i=find( D_/SR <= 0.066 );
        RR_idx_a=RR_idx(sut_i);
        RR_idx_b=RR_idx_1(idx_(sut_i));
        if median(EKG([RR_idx_a ; RR_idx_b])) < median(EKG);
            EKG=-EKG;
        end;
        RR_idx=arrayfun(@(x) ...
            one_peak_index(EKG,RR_idx_a(x),RR_idx_b(x)), [1:length(sut_i)])';
        RR_idx=unique(RR_idx);
    end;
end;

RRI=1000/SR*diff(RR_idx);


function [RR_idx]=QRS_detekt_single(EKG, SR, mode, leisti_apversti);

RR_idx=[];

switch lower(mode)

    case {1 , '1', 'pt' }
        %% Pan-Tompkin algorithm, implemented by Hooman Sedghamiz, 2014
        % PAN.J, TOMPKINS. W.J,"A Real-Time QRS Detection Algorithm" IEEE
        % TRANSACTIONS ON BIOMEDICAL ENGINEERING, VOL. BME-32, NO. 3, MARCH 1985.

        % Check if there is no some custom 'findpeaks.m'
        rehash toolbox;
        findpeaks_paths=galima_fja('findpeaks',...
           '[~]=findpeaks([1 2 1],''MINPEAKDISTANCE'',1);');
        
        % Check upside-down EKG 
        if leisti_apversti;
            if ekg_apversta(EKG,SR,0); EKG=-EKG; end;
        end;
        
        % QRS
        %[qrs_amp_raw,qrs_i_raw,delay]=...
        [~,qrs_i_raw,~]=...
            QRS_detekt_Pan_Tompkin(EKG,SR,0);
        RR_idx=[qrs_i_raw]';

        % Atstatyti findpeaks
        if ~isempty(findpeaks_paths);
            addpath(findpeaks_paths);
        end;

        
    case {2 , '2', 'dpi' }
        %% Dynamic Plosion Index
        % A. G. Ramakrishnan, A. P. Prathosh, T. V. Ananthapadmanabhaha.
        % "Threshold-Independent QRS Detection Using the Dynamic Plosion Index".
        % IEEE Signal Processing Letters, accepted for publication, 2014.
        % DOI: 10.1109/LSP.2014.2308591
        wind=1800 ; % default value by authors is wind=1800
        param=5 ; % default value by authors is param=5
        qrs=QRS_detekt_DPI(EKG,SR,wind,param);
        RR_idx=[qrs(2:end)]';
        
        
    case {3, '3' , 'ecglab', 'mobd' }
        %% from ECGlab 2.0: multiplication of backward differences (MOBD)
        % Suppappola, S.; Sun, Y., "Nonlinear transforms of ECG signals
        % for digital QRS detection: A quantitative analysis",
        % IEEE Trans. Biomed. Eng., 41/4, April 1994
        % DOI: 10.1109/10.284971
        qrs=QRS_detekt_mobd(EKG,SR);
        RR_idx=qrs;
        
        
    case {4, '4'}
        %% Adaptive detector, writen by Hooman Sedghamiz, 2014
        
        % Check upside-down EKG 
        if leisti_apversti;
            if ekg_apversta(EKG,SR,0); EKG=-EKG; end;
        end;
        
        %[R_i,R_amp,S_i,S_amp,T_i,T_amp,Q_i,Q_amp,heart_rate,buffer_plot]= ...
        R_i = QRS_detekt_adaptive_Sedghamiz(double(EKG),SR,0);
        RR_idx=R_i';
        
        
    otherwise
        warning('Unknown mode');
end;



function i=one_peak_index(signal,i1,i2)
i_min=min([i1 i2]);
i_max=max([i1 i2]);
d=signal([i_min:i_max]);
[~,i]=max(d);
i=i_min+i-1;

