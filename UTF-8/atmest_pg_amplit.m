% Atkarpėlių, viršijančių amplitudės ribas, atmetimas
% Didelė dalis kodo yra iš ERPLAB
%
% Removing time intervals by amplitude
% Big part part of code is prom ERPLAB
%
% (C) 2007 The Regents of the University of California, Javier Lopez-Calderon and Steven Luck
% (C) 2010,2011 Javier Lopez-Calderon
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

function [EEG]=atmest_pg_amplit(EEG, ampth, winms, chanArray, varargin)


    if isempty(chanArray);
        chanArray=1:EEG.nbchan;
    end;

    %ampth=[70];
    %winms=1500;
    stepms=winms/2;
    forder=[] ;%stepms;
    shortseg=0;
    shortisi=2000;
    colorseg=[ 1 0.9765 0.5294];
    firstdet=0;
    winoffset=0;
    fcutoff=[];

    shortisisam  = floor(shortisi*EEG.srate/1000);  % to samples
    shortsegsam  = floor(shortseg*EEG.srate/1000);  % to samples
    winoffsetsam = floor(winoffset*EEG.srate/1000); % to samples

    [WinRej, chanrej] = basicrap2(EEG, chanArray, ampth, winms, stepms, firstdet, fcutoff, forder); %, filter, forder)

    if isempty(WinRej)
        fprintf('\nCriterion was not found. No rejection was performed.\n');
    else
        %colorseg = [1.0000    0.9765    0.5294];
        if ~isempty(shortisisam)
            [WinRej, chanrej ] = joinclosesegments2(WinRej, chanrej, shortisisam);
        end
        if ~isempty(shortsegsam)
            [WinRej, chanrej ] = discardshortsegments(WinRej, chanrej, shortsegsam);
        end
        if ~isempty(winoffsetsam)
            [WinRej, chanrej ] = movesegments(WinRej, chanrej, winoffsetsam, EEG.pnts);
        end

        colormatrej = repmat(colorseg, size(WinRej,1),1);
        matrixrej = [WinRej colormatrej chanrej];
        assignin('base', 'WinRej', WinRej);
        fprintf('\n %g segments were marked.\n\n', size(WinRej,1));

        commrej = sprintf('disp(''WinRej=''); disp(WinRej); EEG = eeg_eegrej( EEG, WinRej);');
        % call figure
        %WinRej
        %disp('------------------');
        %eegplot(EEG.data, 'winrej', matrixrej, 'srate', EEG.srate,'butlabel','REJECT','command', commrej,'events', EEG.event,'winlength', 50);

        EEG= eeg_eegrej( EEG, WinRej) ;
        EEG = eeg_checkset( EEG );
        if length(EEG.event)>=1;
            if EEG.event(end).latency>EEG.pnts;
                EEG = pop_editeventvals(EEG,'delete',length(EEG.event));
                EEG = eeg_checkset( EEG );
            end;
        end;
        if length(EEG.event)>=1;
            if EEG.event(1).latency<1;
                EEG = pop_editeventvals(EEG,'delete',1);
                EEG = eeg_checkset( EEG );
            end;
        end;

    end;
    EEG = eeg_checkset( EEG );

%%













function [winrej chanrej] = basicrap2(EEG, chanArray, ampth, windowms, stepms, firstdet, fcutoff, forder)

% PURPOSE: subroutine for pop_continuousartdet.m
%          Rejects commonly recorded artifactual potentials (c.r.a.p.)
%
% FORMAT
%
% [winrej chanrej] = basicrap(EEG, chanArray, ampth, windowms, stepms, firstdet, fcutoff, forder)
%
% INPUTS
%
% EEG         - continuous EEG dataset (EEGLAB's EEG structure)
% chanArray   - channel index(ices) to look for c.r.a.p.  (default all channels)
% ampth       - 1 single value for peak-to-peak threshold within the moving window.
%               2 values for extreme thresholds within the moving window, e.g [-200 200] or [-150 220]
% windowms    - moving window width in msec (default 2000 ms)
% stepms      - moving window step in msec (default 1000 ms)
% firstdet    - 1 means move the moving-window after detecting the first artifactual channel (faster). 0 means scan all channel
%               then move the window (slower).
% fcutoff     - 2 values for frequency cutoffs. empty means no filtering (default)
% forder      - 1 value indicating the order (number of points) of the FIR filter to be used. Default 26
%
% OUTPUTS
%
% EEG         - continuous crap-free EEG dataset
%
% Example 1:
% Reject segment of data where the amplitude (mean value removed) is >= than 200 uV or <= than -300 uV.
% Use a moving window of 2000 ms, 1000 ms step, exploring channels 1 to 12.
%
% EEG = basicrap(EEG, chanArray, ampth, windowms, stepms, firstdet, fcutoff, forder)

% >> EEG = basicrap(EEG, 1:12, [-300 200], 2000, 1000, );
%
%
% Reference:
% [1] ERP Boot Camp: Data Analysis Tutorials. Emily S. Kappenman, Marissa L. Gamble, and Steven J. Luck. UC Davis
%
%
% See also pop_continuousartdet.m filter_tf.m filtfilt.m
%
%
% *** This function is part of ERPLAB Toolbox ***
% Author: Javier Lopez-Calderon
% Center for Mind and Brain
% University of California, Davis,
% Davis, CA
% 2010

% 2014-10-18 Mindaugas Baranauskas
% don't exit if length(EEG.event)<1

%b8d3721ed219e65100184c6b95db209bb8d3721ed219e65100184c6b95db209b
%
% ERPLAB Toolbox
% Copyright © 2007 The Regents of the University of California
% Created by Javier Lopez-Calderon and Steven Luck
% Center for Mind and Brain, University of California, Davis,
% javlopez@ucdavis.edu, sjluck@ucdavis.edu
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

winrej  = [];
chanrej = [];
if nargin<8
        forder = 26;
end
if nargin<7
        forder  = [];
        fcutoff = [];
end
if nargin<6
        firstdet = 1;
end
if nargin<5
        stepms = 2500;
end
if nargin<4
        windowms = 5000;
end
if ~isempty(EEG.epoch)
        msgboxText =  'basicrap() only works for continuous datasets.';
        error(msgboxText)
end

fs      = EEG.srate;
winpnts = floor(windowms*fs/1000); % to samples
stepnts = floor(stepms*fs/1000);% to samples
dursam1 = EEG.pnts;

%
% for searching boundaries inside EEG.event.type
%
if length(EEG.event)<1
    fprintf('\nbasicrap.m.m did not found remaining event codes.\n')
    indxbound = [];
elseif ischar(EEG.event(1).type)
    codebound = {EEG.event.type}; %strings
    indxbound = strmatch('boundary', codebound, 'exact');
else
    indxbound = [];
end


if ~isempty(indxbound)
        timerange = [ EEG.xmin*1000 EEG.xmax*1000 ];
        if timerange(1)/1000~=EEG.xmin || timerange(2)/1000~=EEG.xmax
                posi = round( (timerange(1)/1000-EEG.xmin)*EEG.srate )+1;
                posf = min(round( (timerange(2)/1000-EEG.xmin)*EEG.srate )+1, EEG.pnts );
                pntrange = posi:posf;
        end
        if exist('pntrange','var')
                latebound = [ EEG.event(indxbound).latency ] - 0.5 - pntrange(1) + 1;
                latebound(latebound>=pntrange(end) - pntrange(1)) = [];
                latebound(latebound<1) = [];
                latebound = [0 latebound pntrange(end) - pntrange(1)];
        else
                latebound = [0 [ EEG.event(indxbound).latency ] - 0.5 EEG.pnts ];
        end
        latebound = round(latebound);
else
        latebound = [0 EEG.pnts];
        fprintf('\nWARNING: boundary events were not found.\n');
        fprintf('\tSo, basicrap.m will be applied over the full range of data.\n\n');
end

nibound  = length(latebound);
q = 1;
k = 1;
nchan = length(chanArray);
meanoption = 0; % do nothing about the mean of data
disp('Please wait. This might take several seconds...')

while q<=nibound-1  % segments among boundaries
        bp1   = latebound(q)+1;
        bp2   = latebound(q+1);
        if ~isempty(fcutoff)
                if fcutoff(1)~=fcutoff(2)
                        if length(bp1:bp2)>3*forder
                                % FIR coefficients
                                [b, a labelf] = filter_tf(1, forder, fcutoff(2), fcutoff(1), EEG.srate); % FIR
                                if q==1
                                        fprintf('\nYour data are temporary being %s filtered at a cutoff = [%.1f %.1f]\nworking...\n\n', lower(labelf), fcutoff(1), fcutoff(2));
                                end
                                % FIR lowpass
                                % FIR highpass
                                % FIR bandpass
                                % FIR notch
                                if isdoublep(EEG.data)
                                        EEG.data(chanArray,bp1:bp2) = filtfilt(b,a, EEG.data(chanArray,bp1:bp2)')';
                                else
                                        EEG.data(chanArray,bp1:bp2) = single(filtfilt(b,a, double(EEG.data(chanArray,bp1:bp2))')');
                                end
                                fproblems = nnz(isnan(EEG.data(chanArray,bp1:bp2)));
                                if fproblems>0
                                        msgboxText = ['Oops! filter is not working properly. Data have undefined numerical results.\n'...
                                                'We strongly recommend that you change some filter parameters,\n'...
                                                'for instance, decrease filter order.'];
                                        %msgboxText = sprintf(msgboxText);
                                        error(msgboxText);
                                end
                        else
                                fprintf('\nWARNING: EEG segment from sample %d to %d was not filtered\n', bp1,bp2);
                                fprintf('because number of samples must be >= 3 x filter''s order.\n\n');
                        end
                else
                        if fcutoff(1)==0
                                meanoption = 1; % remove mean
                                if q==1
                                        fprintf('\nThe mean of your data is temporary being remove out.\nworking...\n\n');
                                end
                        else
                                meanoption = 2; % get only the mean
                                if q==1
                                        fprintf('\nThe mean of your data is temporary being isolated for assessment.\nworking...\n\n');
                                end
                        end
                end
        end

        %
        % Moving window
        %
        j = bp1;
        while j<=bp2-(winpnts-1)
                t1   = j+1;
                t2   = j+winpnts-1;
                chanvec = zeros(1, EEG.nbchan);
                for ch=1:nchan
                        % get the data window
                        datax2 = EEG.data(chanArray(ch), t1:t2);
                        if meanoption==1 % remove the mean from the data
                                datax2 = datax2 - mean(datax2);
                        end
                        vmin = min(datax2); vmax = max(datax2);
                        if length(ampth)==1
                                if meanoption~=2
                                        vdiff = abs(vmax - vmin);
                                else % assess only the mean of the data
                                        vdiff = mean(datax2);
                                end
                                if vdiff>ampth
                                        chanvec(chanArray(ch)) = 1;
                                end
                                if firstdet; break;end
                        else
                                if meanoption==2 % assess only the mean of the data
                                        vmin = mean(datax2);
                                        vmax = vmin;
                                end
                                if vmin<=ampth(1) || vmax>=ampth(2)
                                        chanvec(chanArray(ch)) = 1;
                                end
                                if firstdet; break;end
                        end
                end
                if nnz(chanvec)>0
                        winrej(k,:) = [t1 t2]; % start and end samples for rejection
                        chanrej(k,:)= chanvec;
                        k=k+1;
                end
                j=j+stepnts;
        end
        q = q + 1; % next segment
end




%%

function v = isdoublep(x)

% Author: Javier Lopez Calderon

try
      if strcmpi(class(x),'double')
            v=1;
      else
            v=0;
      end
catch
      v=0;
end








%%

function [WinRej2 ChanRej2 ] = discardshortsegments(WinRej, chanrej, shortsegsam, dwarning)

% PURPOSE: subroutine for pop_continuousartdet.m
%          discards short marked segments after continuous artifact detection
%
% FORMAT
%
% [WinRej2 ChanRej2 ] = discardshortsegments(WinRej, chanrej, shortsegsam, dwarning);
%
% INPUTS:
%
% WinRej         - latency array. Each row is a pair of values (start end), so the array has 2 columns.
% chanrej        - marked channels array
% shortsegsam    - duration threshold in seconds (marked windows lower than this value will be unmarked)
% dwarning       - display warning. 1 yes; 0 no
%
% OUTPUT
%
% WinRej2        - latency array for marked windows that were not shorter than the specified value at shortsegsam.
% ChanRej2       - marked channels array belonging to WinRej2
%
%
% *** This function is part of ERPLAB Toolbox ***
% Author: Javier Lopez-Calderon
% Center for Mind and Brain
% University of California, Davis,
% Davis, CA
% 2011

%b8d3721ed219e65100184c6b95db209bb8d3721ed219e65100184c6b95db209b
%
% ERPLAB Toolbox
% Copyright © 2007 The Regents of the University of California
% Created by Javier Lopez-Calderon and Steven Luck
% Center for Mind and Brain, University of California, Davis,
% javlopez@ucdavis.edu, sjluck@ucdavis.edu
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

WinRej2= []; ChanRej2 = [];
if nargin<4
        dwarning = 1;
end
if dwarning
        fprintf('\nWARNING: Marked segments shorter than %g samples will unmarked.\n\n', shortsegsam);
end
nwin     = size(WinRej,1);
indxgood = [];
k=1;
for j=1:nwin
        widthw = WinRej(j,2) - WinRej(j,1);
        if widthw>shortsegsam
                indxgood(k) = j;
                k=k+1;
        end
end
WinRej2 = WinRej(indxgood,:);
if ~isempty(chanrej)
        ChanRej2= chanrej(indxgood,:);
end







%%

function [WinRej2 ChanRej2 ] = joinclosesegments2(WinRej, chanrej, shortisisam)

% PURPOSE: subroutine for pop_continuousartdet.m
%          joins together marked segments that are closer than a specific time value.
%
% FORMAT
%
% [WinRej2 ChanRej2 ] = joinclosesegments(WinRej, chanrej, shortisisam);
%
% INPUTS:
%
% WinRej         - latency array. Each row is a pair of values (start end), so the array has 2 columns.
% chanrej        - marked channels array
% shortisisam    - inter window time. (marked windows closer than this value will be joined together)
%
%
% OUTPUT
%
% WinRej2        - latency array for the resulting marked windows
% ChanRej2       - marked channels array belonging to WinRej2
%
%
% *** This function is part of ERPLAB Toolbox ***
% Author: Javier Lopez-Calderon
% Center for Mind and Brain
% University of California, Davis,
% Davis, CA
% 2011

% 2014-10-18 Mindaugas Baranauskas
% Fixed crash, then size(ChanRej2,2) and size(chrej2,2) is not the same

%b8d3721ed219e65100184c6b95db209bb8d3721ed219e65100184c6b95db209b
%
% ERPLAB Toolbox
% Copyright © 2007 The Regents of the University of California
% Created by Javier Lopez-Calderon and Steven Luck
% Center for Mind and Brain, University of California, Davis,
% javlopez@ucdavis.edu, sjluck@ucdavis.edu
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

WinRej2= []; ChanRej2 = [];
fprintf('\nWARNING: Marked segments that are closer than %g samples will be join together.\n\n', shortisisam);
chanrej = uint8(chanrej);
a = WinRej(1,1);
b = WinRej(1,2);
m = 1;
working = 0;
columns=size(chanrej,2);
chrej2 = uint8(zeros(1,columns));
nwin = size(WinRej,1);
for j=2:nwin
    isi = WinRej(j,1) - WinRej(j-1,2);
    if isi<shortisisam
        b = WinRej(j,2);
        chrej2 = bitor(chrej2, bitor(chanrej(j,:),chanrej(j-1,:)));
        if length(chrej2)<size(chanrej,2);
            warning('unexpected value');
            chrej2 = uint8(zeros(1,columns));
        end;
        working = 1;
        if j==nwin
            WinRej2(m,:)  = [a b];
            ChanRej2(m,1:columns) = chrej2;
        end
    else
        if working==1
            WinRej2(m,:)  = [a b];
            ChanRej2(m,1:columns) = chrej2;
            %                     a = WinRej(j,1);
            working = 0;
        else
            WinRej2(m,:)  = [a b];
            ChanRej2(m,1:columns) = chanrej(j-1);
            %                     a = WinRej(j,1);
            %                     b = WinRej(j,2);
        end
        a = WinRej(j,1);
        b = WinRej(j,2);
        chrej2 = uint8(zeros(1,columns));
        m = m + 1;
    end
end
ChanRej2  = double(ChanRej2);





%%

function [WinRej chanrej] = movesegments(WinRej, chanrej, winoffsetsam, pnts)

% PURPOSE: subroutine for pop_continuousartdet.m
%
% Author: Javier Lopez-Calderon
% Center for Mind and Brain
% University of California, Davis,
% Davis, CA
% 2011

fprintf('\nWARNING: Marked segments will be displaced in %g samples.\n\n', winoffsetsam);
WinRej = WinRej + winoffsetsam;
WinRej(WinRej<1) = 1;
WinRej(WinRej>pnts) = pnts;
[WinRej chanrej] = discardshortsegments(WinRej, chanrej, 0, 0);

