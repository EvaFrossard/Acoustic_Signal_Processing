clear
close all
clc

% Install subfolders
addpath tools
addpath signals

%% EXERCISE: STFT (LECTURE 02, SLIDE 46)
% •	write a function stft.m 
% •	initialize user parameters (sampling frequency, STFT parameters ... etc)
% •	load a signal x (e.g. speech or a linear chirp signal)
% •	visualize the STFT in dB for different window sizes

%% USER PARAMETERS
%
fsHz     = 32E3;           % Sampling frequency in Hertz
blockSec = 16E-3;          % Window size in seconds
stepSec  = blockSec / 4;   % Step size in seconds
winType  = 'hann';         % String defining window type

%% CREATE SIGNALS
%
% Speech signal
x1 = readAudio('speech@24kHz.wav',fsHz);

% Music excerpt
x2 = readAudio('DoYouDareToComputeTheSTFT.wav',fsHz);

% Create a chirp signal
f0 = 100;
f1 = fsHz/2;
x3 = genChirp(fsHz,f0,1,f1);

%% STFT
% 
% Compute parameters
N = 2 * round(blockSec * fsHz / 2);
R = round(stepSec * fsHz);
w = genWin(N,winType,'periodic');
M = pow2(nextpow2(N));

% Compute the STFTs
[X1,t1,f1] = STFT(x1,fsHz,w,R,M);
[X2,t2,f2] = STFT(x2,fsHz,w,R,M);
[X3,t3,f3] = STFT(x3,fsHz,w,R,M);

plotSTFT(t2,f2,X2, fsHz, true);
% imagesc(t2,f2,20 * log10(abs(X2)))