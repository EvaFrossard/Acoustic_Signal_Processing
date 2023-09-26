%% Clear stuff
clear
close all
clc

%% Install subfolders
addpath irs
addpath signals
addpath tools

%% user parameters
% Sampling frequency
fsHz = 48E3;

% Impulse response
roomName = "h_norm";

%% LOAD RESPONSE
%
% Load impulse response
%h = readIR(roomName,fsHz);

%% Trunacte and select which IRs to process
% Truncate the IR (if needed) to remove most of the part that is just noise,
% keeping a short part to allow estimating the noise floor.

%h = h_norm;

%% Calculate the EDC and reverberation time
% Choose an appropriate truncation time for the EDC calculation
trunctime = 2.5; % Taken from ETC plot.

% Calculate the EDC
[ EDC_log, t ] = calcEDC( h, fsHz, trunctime );

% Plot the EDC
figure()
plot(t,EDC_log)
xlabel('Time [s]');
ylabel('Energy Decay [dB]');
title('Reverberation time based on EDC');
% Choose appropriate fitting points for the RT60 calculation
L1 = -3;
L2 = -25;

% Select which EDC to process
% Calculate  the reverberation time
Rt60 = getReverbTime( EDC_log(:,1), fsHz, L1, L2)

%% Direct-to-reverberant energy ratio
% Select IRs with different source to receiver distances

% Split the direct path and the reverberant tail
%timeDirect = ;
[d,r] = splitIR(h(:,1:2),fsHz,timeDirect);

% Calculate the DRR
%drr = ;

%% ENERGY DECAY RELIEF (STFT)
%
% Minimum EDR in dB
%floordB = ;
% Window size
%winSec = ;

% Block size and step size
N = 2 * round(winSec * fsHz / 2);
R = round(N / 4);

% Create analysis and synthesis window function
w = cola(N,R,'hamming','ola');

% DFT size
M = pow2(nextpow2(N));

% STFT

% Energy decay relief in dB

% Normalize to 0 dB

% Truncate to floordB

% Plot the EDRdB
%%
