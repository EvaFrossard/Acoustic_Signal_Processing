function [x,t] = genSin(fs, T, f0, A0, phi0)
%genSin     Generates sinusoid with multiple frequency components
%
%USAGE
%   [x,t] = genSin(fs)
%   [x,t] = genSin(fs,T,f0,A0,phi0)
%  
%INPUT ARGUMENTS
%     fs : sampling frequency in Hertz
%      T : duration of sinusoid in seconds (default, T = 0.1)
%     f0 : vector of frequency components in Hertz (default, f0 = 1E3)
%     A0 : vector of amplitude values (default, A0 = ones(size(f0)))
%   phi0 : vector of phase offset values (default, phi0 = zeros(size(f0)))
% 
%OUTPUT ARGUMENTS
%   x : sinusoid [fs * T x 1]
%   t : time vector in seconds [fs * T x 1]
% 
%   genSin(...) plots the sinusoid in a new figure.
%
%   ***********************************************************************

%% CHECK INPUT ARGUMENTS
%
% Check for the proper number of arguments
if nargin < 1 || nargin > 5
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 2 || isempty(T);    T    = 0.1;             end
if nargin < 3 || isempty(f0);   f0   = 1E3;             end
if nargin < 4 || isempty(A0);   A0   = ones(size(f0));  end
if nargin < 5 || isempty(phi0); phi0 = zeros(size(f0)); end

% Check for the Nyquist theorem (fs > 2*max(f0)
if max(f0) > fs / 2
    error('Highest frequency component is above Nyquist frequency.')
end

%% GENERATE SINUSOID WITH MULTIPLE FREQUENCY COMPONENTS
%
% Discrete-time (column) array
Ts = 1 / fs;
t = (0:Ts:(T-Ts))';

% Number of frequency components
nFreqCom = numel(f0);

% Number of samples
N = round(T * fs);

% (Column) Array to store output signal (allocate memory)
x = zeros(N, 1);

for ii = 1 : nFreqCom
    x = x + A0(ii) * sin(2 * pi * f0(ii) * t + phi0(ii));
end

%% PLOT SIGNAL
%
% If there is no variable to store output
if nargout == 0
    figure;
    plot(t,x);
    xlabel('Time (s)')
    ylabel('Amplitude')
    title('Sinusoid wave')
    xlim([t(1) t(end)])
end
