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
phi = 0;
Tsilence = 1; % Silence duration
Tin = 2E-3; % Fade-in duration
Tout = 3E-4; % Fade-out duration

% Select linear  exponential frequency increase
isExp = true;


%% CREATE SIGNALS
% 
% Generate the measurement signal
%s_exp = genMeasSig(fs,f0,Tsweep,f1,0,isExp);
[s_exp,t] = genMeasSig(Tsweep, fs, f0, f1, Tsilence, Tin,  Tout, isExp );

%% Create the inverse filter
%
% Implement the following function using the provided template.
[hinvB, Hinv] = getInverse(s_exp);

% Investigate the inverse filter by looking at the time signal, the
% magnitude spectrum, etc.
figure(1)
plot(hinvB)

h = getIR(s_exp, Hinv);
figure(2)
plot(h)

%% What happens if the sweep signal does not span the entire frequency range?

%% Apply the inverse filter to the original sweep
