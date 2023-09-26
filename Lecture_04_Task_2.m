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
s_exp = genMeasSig(Tsweep, fs, f0, f1, Tsilence, Tin, Tout, isExp );


%% Create the inverse filter
%
% Implement the following function using the provided template.
[hinvB, Hinv] = getInverse(s_exp);

% Investigate the inverse filter by looking at the time signal, the
% magnitude spectrum, etc.

% Discrete-time vector
Ts = 1 / fs;
t = (0:Ts/2:(Tsweep-Ts))';
t = cat(1,t,ones(1,1));;

% time signal plot
%figure;
%plot(t,hinvB);
%xlabel('Time (s)')
%ylabel('Amplitude')
%xlim([0 t(end)])

%% What happens if the sweep signal does not span the entire frequency range?

%% Apply the inverse filter to the original sweep
[s, t] = genChirp(fs,f0,Tsweep,f1,0,isExp);
[hinvA, HinvA] = getInverse(s);

% time signal plot
figure;
plot(t,hinvA);
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0 t(end)])


