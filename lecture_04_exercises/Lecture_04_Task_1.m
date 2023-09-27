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

R = 100; % Step size
M = 1024;
w = genWin(1000, 'hann', 'periodic');

% Select linear or exponential frequency increase
isExp1 = false;
isExp2 = true;

%% CREATE SIGNALS
% 
% Create a linear sweep 
[x_lin,t_lin] = genChirp(fs, f0, T, f1,phi0, isExp1);

% Create a exponential sweep
[x_exp, t_exp] = genChirp(fs, f0, T, f1,phi0, isExp2);

%% FREQUENCY ANALYSIS
% Calculate magntiude spectra
% Linear sweep
N_lin = length(x_lin);
X_lin = fft(x_lin);
X_lin_db = 20*log10(abs(X_lin)); %db(X_lin); % FFT magnitude to dbs
% fv_lin = linspace((-fs/2), fs/2, N_lin); % vector = [-fs/2, fs/2] with N_lin values
fv_lin = (0:length(X_lin)-1) .* fs/length(X_lin);

% Exponential sweep
N_exp = length(x_exp);
X_exp = fft(x_exp);
X_exp_db = 20*log10(abs(X_exp)); %db(X_exp);
% fv_exp = linspace((-fs/2), fs/2, N_exp);
fv_exp = (0:length(X_exp)-1) .* (fs/length(X_exp));

% Calculat STFTs
[X_lin_stft, t_lin1, f_lin1] = STFT(x_lin,fs, w, R, M);
[X_exp_stft, t_exp1, f_exp1] = STFT(x_exp, fs, w, R, M);

%% SHOW RESULTS
% 
% Plot the time-domain signals
figure(1);
subplot(2,1,1);
plot(t_lin, x_lin);
title('Linear sweep Time-Domain');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t_exp, x_exp);
title('Exponential sweep Time-Domain');
xlabel('Time (s)');
ylabel('Amplitude');

%%
% Plot the magnitude spectra DFT
figure(2);
subplot(2,1,1);
plot(fv_lin, abs(X_lin));
xlim([0 fs/2]);

subplot(2,1,2);
plot(fv_exp,abs(X_exp));
xlim([0 fs/2]);
%%

% Pot the magntiude spectra dB
figure(3);
subplot(2,1,1);
semilogx(X_lin_db);
xlim([-fs/4 fs/4]);
title('Linear sweep Time-Domain');
xlabel('Freq (Hz)');
ylabel('Magntiude (dB)');

subplot(2,1,2);
semilogx(X_exp_db);
xlim([-fs/4 fs/4]);
title('Linear sweep Time-Domain');
xlabel('Freq (Hz)');
ylabel('Magntiude (dB)');

% Plot the STFTs
h = plotSTFT(t_lin1, f_lin1, X_lin_stft, fs, false);

h1 = plotSTFT(t_exp1, f_exp1, X_exp_stft, fs, true);
