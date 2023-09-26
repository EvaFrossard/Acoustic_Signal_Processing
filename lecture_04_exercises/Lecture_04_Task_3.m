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

%% Investigate the black box system provided in blackBox.p (check Test_Black_Box.m)

