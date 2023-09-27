%% Clear stuff
clear variables
close all

% Install subfolders
addpath tools

%% EXERCISE: Recovering the IR (LECTURE 04, Slide 34)
% (1) Create the function getIR.m that returns the IR of system given its
% output to the measurement signal and the inverse filter.

% (2) Check the 3 presets of the provided "black box" system
% (Test_Black_Box.m). Measure the IRs using your system.

% (3) Characterize the presets based on analyzing your measured IRs.

%% User parameters
fs = 48000; % Sampling frequency
Tsweep = 1; % Sweep duration
f0 = 10; % Start frequency
f1 = fs/2; % Stop frequency
Tsilence = 1; % Silence duration
Tin = 2E-3; % Fade-in duration
Tout = 1E-4; % Fade-out duration

% Select linear or exponential frequency increase
isExp = true;

%% Generate sweep signal
s_exp = genMeasSig(Tsweep,fs,f0,f1,Tsilence,Tin,Tout,isExp);

%% Create the inverse filter
[hinv, Hinv] = getInverse(s_exp);

%% Create a measurement system
% Implement the function below:
h = getIR(s_exp, Hinv);
T = length(h)/fs;
ts = 1/fs;
t = 0:ts:T-ts;
stem(t', h);

%% Investigate the black box system provided in blackBox.p (check Test_Black_Box.m)
y_a = blackBox(s_exp, fs, 'system_a');
ha = getIR(y_a, Hinv);

T = length(ha)/fs;
ts = 1/fs;
t = 0:ts:T-ts;

figure();
plot(t',ha);
xlim([0 0.01]);

figure();
semilogx(db(fft(ha)));
xlim([10 5e4]);

%%
y_b = blackBox(s_exp, fs, 'system_b');
hb = getIR(y_b, Hinv);

T = length(hb)/fs;
t = 0:ts:T-ts;

% figure();
% plot(t', hb);

R = 100;
M = 1024;
w = genWin(1000, 'hann', 'periodic');
[y_b_stft, t_y_b, f_y_b] = STFT(y_b, fs, w, R, M);
plotSTFT(t_y_b, f_y_b, y_b_stft, fs, false, 60);

[hb_stft, t_hb, f_hb] = STFT(hb, fs, w, R, M);
plotSTFT(t_hb, f_hb, hb_stft, fs, false, 60);

%% 
y_c = blackBox(s_exp, fs, 'system_c');
hc = getIR(y_c, Hinv);

T = length(hc)/fs;
t = 0:ts:T-ts;

% figure();
% plot(t', hc);

[y_c_stft, t_y_c, f_y_c] = STFT(y_c, fs, w, R, M);
plotSTFT(t_y_c, f_y_c, y_c_stft, fs, false, 60);

[hc_stft, t_hc, f_hc] = STFT(hc, fs, w, R, M);
plotSTFT(t_hc, f_hc, hc_stft, fs, false, 60);
