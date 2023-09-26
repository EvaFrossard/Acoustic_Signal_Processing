clear
close all
clc

% Install subfolders
addpath tools

%% EXERCISE: Overlap-save method (LECTURE 03, SLIDE 52)
% •	write a function convolveFFT_OLS.m 
% •	select various BRIRs
% •	process left and right BRIR channels separately
% •	construct a binaural signal by conbining the left- and right-ear channels
% •	listen to the binaural signal
% •	compare processing speed when using the function convolve (be careful,
%   this will only be possible for relatively short impulse responses) 

%% USER PARAMETERS
%
% Number of random signal samples
Nx = 48E3;

% Number of random impulse response samples
Nh = 512;

%% CREATE SIGNALS
%
% Create random signal
x = rand(Nx,1);
% x = [1 2 5 6 8 9 10 3 7 15 12 9 4 0 1 4 5 2 7 9]';
% x = [1 2 4 1 3]';

% Create random impulse response
h = randn(Nh,1);
% h = [8 6 5 2]';
% h = [2 1 2]';

% Choose N for Overlap-save method
N = optimalN(Nx,Nh);

%% PERFORM CONVOLUTIONS
%
% Time-domain convolution
tic;
y1 = convolve(x,h);
t1 = toc;

% Frequency domain convolution
tic;
y2 = convolveFFT_OLS(x,h,N, true);
t2 = toc;

%% SHOW RESULTS
%
fprintf('Time-domain convolution: \t\t\t\t\t%f seconds\n', t1);
fprintf('Frequency-domain convolution: \t\t\t\t%f seconds\n', t2);

% Erros threshold
thres = 1E-12;

% Check RMS error between linear reference and FFT-based approaches
assert(rms(y1-y2)<thres,'Time-domain and frequency-domain convolution differ.')
