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
M = 1024;
R = 100;
w = ones(10000,1);  %Make this the same length as the one which has been zero padded in the project

% Select linear or exponential frequency increase
isExp1 = false;
isExp2 = true;


%% CREATE SIGNALS
% 
% Create a linear sweep 
[x,t] = genChirp(fs,f0,T,f1,phi0,isExp1);

% Create a logarithmic sweep
[x1,t1] = genChirp(fs,f0,T,f1,phi0,isExp2);


%% FREQUENCY ANALYSIS
% Calculate the magnitude spectra

X = fft(x);
%X = fftshift(X); 
fv = linspace((-fs/2),fs/2,length(x));

X1 = fft(x1);
%X1 = fftshift(X1); 
fv1 = linspace((-fs/2),fs/2,length(x1));


% Calculate the STFTs
[Xstft,t,f] = STFT(x,fs,w,R,M);
[Xstft1,t1,f1] = STFT(x1,fs,w,R,M);
%% SHOW RESULTS
% 
% Plot the time-domain signals
figure(1)
plot(x);
hold on
plot(x1);
% Plot the magnitude spectra

figure(2);
semilogx(db(fft(x)))
hold on
semilogx(db(fft(x1)))
xlim([-fs/4 fs/4]);
% Plot the STFTs
bLog = true;
DRdB = 60;

h = plotSTFT(t,f,Xstft,fs,bLog,DRdB)
h1 = plotSTFT(t,f,Xstft1,fs,bLog,DRdB)