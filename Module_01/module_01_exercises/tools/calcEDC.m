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

% Truncate
win = ones(length(h(:,1)),1); 
win(fs*trunctime+1:end) = 0;
htrun = h.*win;

%% Calculate EDC

num = cumsum(htrun(:,1).^2);
frac = 1-num/num(end);
EDCdB = 10*log10(frac);
% Return time vector
t = 0:1/fsHz:length(EDCdB);
end

