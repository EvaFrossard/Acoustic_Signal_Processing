%% Clear stuff
clear variables
clear mex
close all
clc
%% Add paths
addpath audio-playback tools
startupHeaAudio
%setpref('dsp','portaudioHostApi',3)  % Sets audio output API to ASIO

%% User parameters
fs = 48000;         %Hz, sampling frequency
Tsweep = 0.1;         %s time for sweep
Tsilence = 2; %s silence following sweep
fstart = 5;         %Hz, Start frequency
fstop = fs/2;       %Hz,  Stop frequency
Tfadein = 0.1;   %s, Length of fade in 
Tfadeout = 4/fs;       %s, Length of fade out
Ttotal = Tsweep + Tsilence;       %s, total time for sweep + silence

channelsRec = [1 2]; %Which soundcard channels to record on
channelsPlay = 1; % Which soundcard channel to play on

%% Generate sweep signal
s_exp = genMeasSig(Tsweep,fs,fstart,fstop,Tsilence,Tfadein,Tfadeout);
s_exp = s_exp .* db2mag(-9);

%% Create the inverse filter
[hinv, Hinv] = getInverse(s_exp);

%% Reconvolve with measurement signal as sanity check
d = getIR(s_exp, Hinv);

%% Init audio object for sound recording and playback
ao = HeaAudioDSP;
ao.fs = fs;
% Select recording and playback channels
ao.channelsPlay = channelsPlay;
ao.channelsRec = channelsRec;

%% Play stimulus and record
disp('Measurement start.');
y = ao.playrec(s_exp);
disp('Measurement completed.');

%% Recover IR
% for ii=1:width(y)
h = getIR(y,Hinv); %h(:,ii) = getIR(y(:,ii),Hinv);
h_norm = h ./ max(max(abs(h))); % Normalize IRs to the overall maximum
% end
%% Plot the ETC
T = length(h)/fs; %measurement time
t = 0:1/fs:T-1/fs;
t = t.';

ETC = 10*log10(h_norm.^2);
plot (t,ETC) %choose truncation time by looking at this plot 
             %(when there is no decay anymore, it is only backgroud noise)
             
%% Plot the spectrograms
% STFT parameters
N = 1024;          % Window size
M = N;             % Number of DFT points
R = 512;           % Step size
w = blackman(N);   % Analysis window
% Calculate the STFTs
DRdB = 60;
bLog = false;
[YA,tSec,fHz] = stft(y,fs,w,R,M);
HA = stft(h,fs,w,R,M);
HA_norm = stft(h_norm,fs,w,R,M);
plotSTFT(tSec,fHz,YA,fs,bLog,DRdB);title('Recorded sweep');
plotSTFT(tSec,fHz,HA,fs,bLog,DRdB);title('Impulse response');
plotSTFT(tSec,fHz,HA_norm,fs,bLog,DRdB);title('Impulse response normalized');


%% Save and add variables of importance
% audiowrite(['irs\latest_measured_' int2str(Ttotal) '.wav'],h_norm,fs,'BitsPerSample',24);
save(sprintf('bi_%d_%d_%d_%d_%d_%d.mat',fix(clock)),'s_exp','Hinv','y','h_norm','fs','Tsweep','Tsilence');
% save(sprintf('Tsweep_%d_Tsilence_%d.mat'),'Tsweep','Tsilence');