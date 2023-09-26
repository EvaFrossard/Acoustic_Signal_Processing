clear
close all
clc

% Install subfolders
addpath irs
addpath signals
addpath tools

%% EXERCISE: Overlap-save method (LECTURE 03, SLIDE 52)
% •	write a function convolveFFT_OLS.m 
% •	select various BRIRs
% •	process left and right BRIR channels separately
% •	construct a binaural signal by combining the processed left- and right-ear channels
% •	listen to the binaural signal using soundsc()

%% USER PARAMETERS
% 
% Name of binaural room impulse response (BRIR)
fNameIR = 'surrey_room_d_0_degree.wav';

% Signal name
fNameSignal = 'speech@24kHz.wav';

%% LOAD SIGNALS
% 
% Read impulse response
[h,fsHz] = readIR(fNameIR);

% Read audio signal (automatically resample input to match the sampling
% frequency of the impulse response) 
x = readAudio(fNameSignal,fsHz);

%% PERFORM CONVOLUTION
% 
% Be careful, h is of dimension [nSamples x 2 channels]

cL = conv(x,h(:,1));
cR = conv(x,h(:,2));

N = optimalN(numel(x),numel(h));

yL = convolveFFT_OLS(x,h(:,1),N,true);
yR = convolveFFT_OLS(x,h(:,2),N,true);

binaural = cat(2,yL, yR);

if 1
    % Play binaural signal
    soundsc(binaural,fsHz)
end