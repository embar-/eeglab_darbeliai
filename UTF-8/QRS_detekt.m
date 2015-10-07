function [RR_idx,RRI]=QRS_detekt(EKG, sampling_rate, mode, varargin)
%[RR_idx,RRI]=QRS_detekt(EKG,sampling_rate,mode)
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
% (C) 2014-2015 Mindaugas Baranauskas
%%

SR=sampling_rate;
qrs=[]; 
RR_idx=[];

if length(EKG)/SR < 2.5 ; 
   warning('EKG too short!');
   return; 
end;

if nargin > 3 ;
    leisti_apversti=varargin{1};
else
    leisti_apversti=1;
end;

switch mode

    case {1 , '1', 'PT' }
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
        [qrs_amp_raw,qrs_i_raw,delay]=...
            QRS_detekt_Pan_Tompkin(EKG,SR,0);
        RR_idx=[qrs_i_raw]';

        % Atstatyti findpeaks
        if ~isempty(findpeaks_paths);
            addpath(findpeaks_paths);
        end;

        
    case {2 , '2', 'DPI', 'dpi' }
        %% Threshold-Independent QRS Detection Using the Dynamic Plosion Index
        %  A. G. Ramakrishnan and A. P. Prathosh and T. V. Ananthapadmanabhaha.
        % "Threshold-Independent QRS Detection Using the Dynamic Plosion Index".
        %  IEEE Signal Processing Letters, accepted for publication, 2014.
        wind=1800 ; % default value by authors is wind=1800
        param=5 ; % default value by authors is param=5
        qrs=QRS_detekt_DPI(EKG,SR,wind,param);
        RR_idx=[qrs(2:end)]';
        
        
    case {3, '3' , 'ECGlab', 'ECGLAB', 'ecglab' }
        %% from ECGlab 2.0
        % Suppappola, S.; Sun, Y., "Nonlinear transforms of ECG signals
        % for digital QRS detection: A quantitative analysis",
        % IEEE Trans. Biomed. Eng., 41/4, April 1994
        qrs=QRS_detekt_mobd(EKG,SR);
        RR_idx=qrs;
        
        
    case {4, '4'}
        %% Adaptive detector, writen by Hooman Sedghamiz, 2014
        
        % Check upside-down EKG 
        if leisti_apversti;
            if ekg_apversta(EKG,SR,0); EKG=-EKG; end;
        end;
        
        [R_i,R_amp,S_i,S_amp,T_i,T_amp,Q_i,Q_amp,heart_rate,buffer_plot]= ...
            QRS_detekt_adaptive_Sedghamiz(double(EKG),SR,0);
        RR_idx=R_i';
        
        
    otherwise
        warning('Unknown mode');
end;


RRI=1000/SR*diff(RR_idx);

return;



