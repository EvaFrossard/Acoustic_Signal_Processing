clear
close all
clc

% Install subfolders 
addpath tools
addpath signals

%% EXERCISE: Aliasing (LECTURE 01, SLIDE 22 - 24)
% •	write a function genChirp.m 
% •	initialize user parameters (e.g. sampling frequency, chirp parameters,
%   decimation factors ... etc)  
% •	create a chirp signal x
% •	downsample x using various decimation factors (D = 1, 2 and 4) and
%   listen to the resulting signals 
% •	preprocess x with an FIR filter (b = fir1(31,0.95/D)) prior to
%   downsampling and listen to the resulting signals
% •	repeat the previous two points using a speech signal

%% USER PARAMETERS

Fs = 24000; % Sampling frequency (24kHz)
f0 = 0.1 * 10^3; % Initial frequency (0.1 kHz)
f1 = 10 * 10^3; % Final frequency (10 kHz)
t0 = 0; % Initial time
T = 2; % Final time
phi0 = 0;
decim = [1 2 4];
bChirp = true;

%% CREATE CHIRP SIGNAL

if bChirp
    chirp = genChirp(Fs, f0, T, f1, phi0);
else
    chirp = readAudio('speech@24kHz.wav', Fs);
end


%% ITERATE ACROSS DECIMATION FACTORS

% Check decimation values
if any(rem(decim, 1) ~= 0)
    error('Decimation factors must be integer values.')
end

% Allocate memory (create array of arrays)
x = cell(length(decim), 1);
xLP = cell(length(decim), 1);

for i = 1 : length(decim)
    % Low-Pass filter
    LPF = fir1(31, 0.95 / decim(i));

    %  Apply low-pass filter
    chirpLP = filter(LPF,1,chirp);

    % Decimate signals
    x{i} = chirp(1:decim(i):end);
    xLP{i} = chirpLP(1:decim(i):end);

end

prompt = "What decimation want to hear?";
option = input(prompt);
if(option == 1 || option == 2 || option == 4)
    decimFs = Fs/option;
    soundsc(x{find(decim == option, 1)}, decimFs);
    pause;
    soundsc(xLP{find(decim == option, 1)}, decimFs);
else
    error('Those decimation factors are not valid')
end
