clear
% close all
clc

% Install subfolders
addpath tools
addpath signals

%% USER PARAMETERS
%
%
% Sampling frequency in Hertz
fsHz = 16E3;           


%% CREATE SIGNALS
%
%
% Speech signal
x = readAudio('speech@24kHz.wav',fsHz);
x = awgn(x,0,'measured');

%% STFT
% 
% 
% Compute the STFT
[X,t,f] = stft(x,fsHz);

% Spectrogram in dB
XdB = 20 * log10(abs(X));

%% SHOW RESULTS
% 
% 
% Show STFT with linear frequency axis
figure;
imagesc(t,f,XdB); 
axis xy; 
colormap(colormapVoicebox);
ylim([0 fsHz/2])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Linear frequency axis')

% Logarithmic frequency grid
fLogHz = 2.^(-20:20) * 1E3;
fLogHz = fLogHz(fLogHz >= f(2) & fLogHz <= fsHz/2);

% Show STFT with logarithmic frequency axis
figure; 
pcolor(t,f,XdB);
shading flat;
colormap(colormapVoicebox);
set(gca,'yscale','log')
set(gca,'ytick',fLogHz,'yticklabel',num2str(fLogHz'))
ylim([0 fsHz/2])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Logarithmic frequency axis')

