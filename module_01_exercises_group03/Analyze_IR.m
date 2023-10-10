%% Clear stuff
clear
close all
clc

%% Install subfolders
addpath signals
addpath tools

%% User parameters
% Sampling frequency
fsHz = 48E3;

% Impulse response (2nd signal)
IR = load('meas_2023_9_27_9_52_40.mat');

%% Load response
% Load impulse response
h = IR.h_norm;

% Truncate the IR (if needed) to remove most of the part that is just noise,
% keeping a short part to allow estimating the noise floor.

%% Calculate the EDC and reverberation time
% Choose an appropriate truncation time for the EDC calculation
trunctime = 3.6;

% Calculate the EDC
[EDC_log, ~] = calcEDC(h, fsHz, trunctime);

% Plot the EDC
calcEDC(h, fsHz, trunctime);

% Choose appropriate fitting points for the RT60 calculation
L1 = -5;    % [dB] Starting level for line fitting
L2 = -25;   % [dB] End level for line fitting

% Select which EDC to process
EDC_channel1 = EDC_log(:,1);
EDC_channel2 = EDC_log(:,2);

% Calculate  the reverberation time
getReverbTime(EDC_channel1, fsHz, L1, L2);

%% Direct-to-reverberant energy ratio
% Select IRs with different source to receiver distances

% Split the direct path and the reverberant tail
% timeDirect = ;
% [d,r] = splitIR(h(:,1:2),fsHz,timeDirect);
% 
% % Calculate the DRR
% drr = ;

%% ENERGY DECAY RELIEF (STFT)
% Truncate IR
trunctime = 3.6;

[IR_trun, ~] = truncateSignal(h, fsHz, trunctime, true);

% Window size
winSec = 32E-3;

% Block size and step size
N = 2 * round(winSec * fsHz / 2);
R = round(N / 4);

% Create analysis and synthesis window function
w = cola(N,R,'hamming','ola');

% DFT size
M = pow2(nextpow2(N));

% STFT
[X1, t1, f1] = STFT(IR_trun(:,1),fsHz,w,R,M);
plotSTFT(t1,f1,X1,fsHz,[],80);

% Energy decay relief in dB
sqr_stft1 = abs(X1).^2;
reverse_stft1 = flip(sqr_stft1, 2);
EDR1 = cumsum(reverse_stft1,2);
EDR1 = flip(EDR1,2);
EDRdB1 = 10*log10(EDR1);

% Normalize to 0 dB
EDRdB1 = EDRdB1 - max(max(EDRdB1));

% Truncate to floordB
% Minimum EDR in dB
floordB = -60;
EDRdB1 = max(max(EDRdB1, floordB), floordB);

% Plot the EDRdB
figure();
mesh(t1, f1,EDRdB1);
xlabel('Time [s]');
ylabel('Frequency [Hz]');
zlabel('Magnitude [dB]');
ylim([0 fsHz/2]);
