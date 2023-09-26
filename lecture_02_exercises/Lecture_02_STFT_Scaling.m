clear
close all
clc

% Install subfolders
addpath tools
addpath signals

%% USER PARAMETERS
%
%
% Sampling frequency in Hertz
fsHz = 16E3;           

% Duration of sinusoid in seconds
Tsec = 1;

% Sinusoidal frequency component(s)
f0 = 1000;

% Amplitude value(s)
A0 = 1;

% STFT parameters
winSec  = 20E-3;     % Window size in seconds
winType = 'hann';    % String defining window type
overlap = 0.5;       % Overlap factor

%% CREATE SIGNALS
%
%
% Sinusoid
x = genSin(fsHz,Tsec,f0,A0);
genSin(fsHz,Tsec,f0,A0);

%% STFT
% 
% 
% Compute parameters
N = 2 * round(winSec * fsHz / 2);
R = round(N * (1 - overlap));
w = genWin(N,winType,'periodic');
M = 2^(ceil(log2(N)));

% Derive amplitude correction factor
A = N / sum(w);

% Compute the STFT
[X,t,f] = STFT(x,fsHz,w,R,M);

% Discard negative frequencies
XC = X(1:M/2+1,:);
f = f(1:M/2+1);

% Compensate for energy of negative frequencies (except DC & Nyquist) 
XC(2:end-1,:) = XC(2:end-1,:) * 2;

% Compensate for window function and duration
XC = XC * A / N;

% Spectrogram in dB
XCdB = 20 * log10(abs(XC));

%% SHOW RESULTS
% 
% 
% Limit dynamic range of STFT
dynamicRange = 40;

% Show STFT with linear frequency axis
figure;
imagesc(t,f,XCdB,[-abs(dynamicRange) inf]); 
axis xy; 
colormap(colormapVoicebox);
colorbar;
ylim([0 fsHz/2])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Linear frequency axis')

% Logarithmic frequency grid
fLogHz = 2.^(-20:20) * 1E3;
fLogHz = fLogHz(fLogHz >= f(2) & fLogHz <= fsHz/2);

% Show STFT with logarithmic frequency axis
figure; 
pcolor(t,f,XCdB);
shading flat;
colormap(colormapVoicebox);
colorbar;
set(gca,'yscale','log','clim',[-abs(dynamicRange) inf])
set(gca,'ytick',fLogHz,'yticklabel',num2str(fLogHz'))
ylim([0 fsHz/2])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Logarithmic frequency axis')
