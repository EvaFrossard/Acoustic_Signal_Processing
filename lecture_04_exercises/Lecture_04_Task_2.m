%% Clear stuff
clear variables
close all

% Install subfolders
addpath tools

%% EXERCISE: Inverse filter (LECTURE 04, Slide 33)
% (1) Apply windowing and zero-padding to the sweep to create the
% measurement signal. Implement the windowing in fade.m, and zero-padding
% in padZeros.m

% (2) Construct the inverse filter for the measurement signal (use the
% getInverse.m template).

% (3) Plot the inverse filter time and frequency domains.

% (4) Apply the inverse filter to the original sweep.

%% USER PARAMETERS
% 
fs = 48000; % Sampling frequency
Tsweep = 1; % Sweep duration
f0 = 10; % Start frequency
f1 = fs/2; % Stop frequency
Tsilence = 1; % Silence duration
Tin = 2E-3; % Fade-in duration
Tout = 1E-4; % Fade-out duration

% Select linear or exponential frequency increase
isExp = true;

%% CREATE SIGNALS
% 
% Generate the measurement signal
s_exp = genMeasSig(Tsweep, fs, f0, f1, Tsilence, Tin, Tout, isExp);

%% PLOR ORIGINAL SIGNAL
T = length(s_exp)/fs;
ts = 1/fs;
t = 0:ts:T-ts;
S_exp = fft(s_exp);
frequencies = (0:length(S_exp)-1) * (fs/length(S_exp));

% Sweep exponential
figure(1);
% Time plot
subplot(2,1,1);
plot(t, s_exp);
title('Exponential sweep (time domain');
xlim([0 2]);
ylim([-1.1 1.1]);
xlabel('Time [s]');
ylabel('Amplitude [-]');

% Frequency plot
subplot(2,1,2);
plot(frequencies, abs(S_exp));
title('Exponential sweep (frequency domain');
xlim([0 fs/2]);
xlabel('Frequency [Hz]');
ylabel('Magntiude [-]');

%% Create the inverse filter
%
% Implement the following function using the provided template.
[hinvB, Hinv] = getInverse(s_exp);

Hinv_db = 20*log10(abs(Hinv));

% Investigate the inverse filter by looking at the time signal, the
% magnitude spectrum, etc.
figure(2);
subplot(2,1,1);
plot(t,hinvB);
title('Inverse filter (time domain)');
xlabel('Time [s]');
ylabel('Amplitude [-]');

subplot(2,1,2);
semilogx(Hinv_db);
title('Inverse filter (frequency domain)');
xlabel('Frequency [Hz]');
ylabel('Magntiude [dB]');
%xlim([-fs/4 fs/4]);
ylim([-80 -20]);

R = 100;
M = 1024;
w = genWin(1000, 'hann', 'periodic');
[hinvB_stft, t_invB, f_invB] = STFT(hinvB, fs,w,R,M);
plotSTFT(t_invB, f_invB, hinvB_stft, fs, false, 60);

%% What happens if the sweep signal does not span the entire frequency range?

%% Apply the inverse filter to the original sweep
h = getIR(s_exp, Hinv);
figure(5);
stem(t', h);