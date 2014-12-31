function qrs = QRS_detekt_mobd(data, varargin)
%
% QRS_detekt_mobd Finds QRS complexes using nonlinear MOBD transformation.
%
% qrs = QRS_detekt_mobd(data, fs, order, sign_consistent, refractory_period,
%                        adaptive_period, view_transform)
%
% Author: Vesal Badee
%
% Finds QRS complexes using nonlinear MOBD transformation.
%
% Inputs
%   data: vector containing ECG data.
%   fs: sampling frequency of data. Default = 1000.
%   order: MOBD order. Default = 4.
%   sign_consistent: boolean for use of MOBD sign consistency.
%                       Default = 1;
%   refractory_period: invalid detection period after a QRS detection.
%                       Default = 0.2 seconds.
%   adaptive_period: period to update adaptive threshold.
%                       Default = 0.25 seconds.
%   view_transform: boolean to display plot of data, MOBD transform and
%                       adaptive thresholds. Default = 0.
%
% Outputs
%   qrs: column vector containing peak positions with reference to data.
%
% Reference
% Suppappola, S.; Sun, Y., "Nonlinear transforms of ECG signals 
% for digital QRS detection: A quantitative analysis", 
% IEEE Trans. Biomed. Eng., 41/4, April 1994
%
% Modifications
% June 6, 2005: VB, Created
% 05/09/21 AC Changed view_transform option such that a figure is only
%             displayed if the view_transform option is on.
%
% Version 0.1 original filename findqrs_mobd.m

if (nargin<7) ;
    view_transform = 0; 
else
    view_transform = varargin{6};
end
if (nargin<6) ;
    adaptive_period = 0.25; 
else
    adaptive_period = varargin{5};
end
if (nargin<5) ;
    refractory_period = 0.2;
else
    refractory_period = varargin{4};
end
if (nargin<4) ;
    sign_consistent = 1;
else
    sign_consistent = varargin{3};
end
if (nargin<3) ;
    order = 4; 
else
    order = varargin{2};
end
if (nargin<2);
    fs = 1000; 
else
    fs = varargin{1};
end

%data = bpf(data, fs, 48, 15, 40);

adaptive_period = adaptive_period*fs;
refractory_period = refractory_period*fs;
est_avg_noise = 0;

qrs = [];
threshold = 0;
valid = 1; % true for valid interval for qrs to occur

saved_threshold = [];
saved_y = [];
adaptive_counter = 0;
refractory_counter = 0;
maxY = 0;
cumY = 0;

for i=order+1:order:length(data)

    % Calculate mobd transform
    x = [];
    for k=i:-1:i-order+1
        x = [x data(k)-data(k-1)];
    end
    y = prod(abs(x));    

    if (sign_consistent)
        for k=length(x):-1:2
            if (sign(x(k)) ~= sign(x(k-1)))
                y=0;
                break;
            end
        end
    end
    
    cumY = cumY + y;
    
    % End refractory period
    if (refractory_counter >= refractory_period)
        valid = 1;
        % reset threshold to max(y) during refractory period
        threshold = maxY;
        refractory_counter = 0;
        adaptive_counter = 0;
    end   
    
    % Check for qrs
    if (valid)
        adaptive_counter = adaptive_counter + order;        

        % Adapt threshold
        if (adaptive_counter >= adaptive_period)
            threshold = threshold/2;            
            if (threshold<est_avg_noise) threshold = est_avg_noise; end
            adaptive_counter = 0;
        end

        if  (y>threshold)
            qrs = [qrs; i-1];
            valid = 0; % enter refractory period
            maxY = 0;            
            refractory_counter = 0;
            adaptive_counter = 0;
            
            % update average noise
            if (length(qrs)>=2)
                est_avg_noise = (cumY/adaptive_period)+(est_avg_noise/2);
            end
            
            cumY = 0;
        end        
        
    else
        if (y>maxY) maxY=y; end
        refractory_counter = refractory_counter + order;
    end 
    
    if (view_transform)
        saved_y = [saved_y y*ones(1,order)];
        saved_threshold = [saved_threshold threshold*ones(1,order)];
    end
end

% remove first detection that occurred with threshold = 0
qrs = qrs(2:length(qrs));

if (view_transform)
    figure;
    subplot(211);
    plot(data); hold on;
    xax = 1:length(data);
    plot(xax(qrs),data(qrs),'ro'); hold off;
    subplot(212); plot(saved_y); hold on;
    plot(saved_threshold, '--'); hold off;
end

mobd_heart_rate_bpm = length(qrs)*60/(length(data)/fs);