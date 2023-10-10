function [ EDCdB, t ] = calcEDC( h, fs, trunctime )
% Returns the logarithmic energy decay curve for a given impulse response.
%
%USAGE
%   [EDC_log, t] = calcEDC(h, fs)
%  
%INPUT ARGUMENTS
%          h : M channel impulse response (N samples long) [N x M]
%         fs : sampling rate in Hz
%    tructime: Time in [s] at which IR is truncated before calculating the
%              EDC.

%OUTPUT ARGUMENTS
%    EDC_log : logarithmic energy decay curve [tSamples x M]
%          t : time vector [tSamples x 1]

if nargin < 3 || isempty(trunctime) || (trunctime * fs) > size(h,1)
    tSample = size(h,1);
else 
    tSample = floor(trunctime * fs);
end

v = 1;

if(v)
    % Truncate
    % Keep the values until time "tSample"
    hChannels = size(h,2);
    hTrun = h(1:tSample, :);
    
    % Get rid off of the noise floor at the beginning
    [values, indexes] = max(hTrun);
    max_index = max(indexes);
    
    hFin = hTrun(max_index + 1:end, :);
    hFin_size = size(hFin);
    EDCdB = zeros(hFin_size);
    
    for channel = 1 : hChannels
        num = cumsum(hFin(:,channel).^2);
        den = num(end);
        frac = 1 - num/den;
        EDCdB(:, channel) = 10*log10(frac);
    end
else
    % Truncate
    % Window with length of IR [N x M]
    IR_size = size(h);
    IR_samples = IR_size(1);
    IR_channels = IR_size(2);
    
    win = ones(IR_samples,IR_channels);
    
    % Make the samples zero after trunctime
    win(tSample+1:end, :) = 0;
    
    % Apply window to IR 
    htrun = h.*win;
    
    % Get rid off noise floor at the beginning
    
    % Calculate EDC
    % Get the value where the noise floor at the beginning disappears
    [Values, indexes] = max(htrun);
    max_index = max(indexes);
    
    hfin = htrun(max_index:end, :);
    hfin_size = size(hfin);
    EDCdB = zeros(hfin_size);
    
    for i = 1:IR_channels
        num = cumsum(hfin(:,i).^2);
        den = num(end);
        frac = 1 - num/den;
        EDCdB(:,i) = 10*log10(frac);
    end
end

% Return time vector
T = length(EDCdB)/fs;
ts = 1/fs;
t = 0:ts:T-ts;

if nargout == 0
    plot(t, EDCdB);
    xlabel("Time [s]");
    ylabel("Energy Decay [dB]");
    title("Energy Decay Curve (EDC)");
    legend('Channel 1', 'Channel 2');
    grid on;
    xlim([0 t(end-300)]);
end
