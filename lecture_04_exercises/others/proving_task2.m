clear
close all
clc

%% USER PARAMETERS
% 
fs = 48000; % Sampling frequency
Tsweep = 3; % Sweep duration
f0 = 1; % Start frequency
f1 = fs/2; % Stop frequency
Tsilence = 1; % Silence duration
Tin = 2E-3; % Fade-in duration
Tout = 1E-4; % Fade-out duration

% Select linear or exponential frequency increase
isExp = true;

%% CREATE SIGNALS
% 
% Generate the measurement signal
s1 = genMeasSig(Tsweep, fs, f0, f1, 0, 0, 0);

s_exp = genMeasSig(Tsweep, fs, f0, f1, 0, 1, Tout);

T = length(s_exp)/fs;
ts = 1/fs;
t = 0:ts:T-ts;
t0 = 0:ts:3-ts;

figure(1);
subplot(2,1,1);
plot(t0, s1);
xlim([0 3]);

subplot(2,1,2);
plot(t, s_exp);
xlim([0 3]);
