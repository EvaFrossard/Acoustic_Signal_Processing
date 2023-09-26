%% Clear stuff
clear variables
close all

% Install subfolders
addpath tools


%% EXERCISE: Exponential sweep (LECTURE 04, Slide 21)
%
% (1) Derive the expression for the exponential sweep
% (2) Extend the function genChirp.m to include exponential sweeps
% (3) Create a linear and an exponential chirp
% (4) Compare the two signals in the time, frequency and STFT domain

%% USER PARAMETERS
% 
fs = 48000; % Sampling frequency
T = 1; % Sweep duration
f0 = 10; % Start frequency
f1 = fs/2; % Stop frequency
phi0 = 0; % Phase offset

% Select linear or exponential frequency increase
isExp1 = false;
isExp2 = true;


%% CREATE SIGNALS
% 
% Create a linear sweep 
data = genChirp(fs,f0,T,f1,phi0,isExp1);
% Create a logarithmic sweep
%data = genChirp(fs,f0,T,f1,phi0,isExp2);


%% FREQUENCY ANALYSIS
% Calculate the magnitude spectra
% Compute the FFT (Fast Fourier Transform) of the signal
N = length(data); % Length of the signal
X = fft(data);

% Calculate the corresponding frequency axis
f = (0:N-1) * (fs / N);

% Calculate the magnitude spectrum
magnitude_spectrum = abs(X);

% Plot the magnitude spectrum
figure;
semilogx(f, magnitude_spectrum);
%plot(f, magnitude_spectrum);
title('Magnitude Spectrum of the Signal');
xlabel('Frequency (Hz) with a log scale');
ylabel('Magnitude');
% Calculate the STFTs

%% SHOW RESULTS
% 
% Plot the time-domain signals

% Plot the magnitude spectra

% Plot the STFTs
