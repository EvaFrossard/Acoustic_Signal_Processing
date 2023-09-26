% %% Clear stuff
% clear variables
% clear mex
% close all
% clc
% %% Add paths
% addpath audio-playback tools
% startupHeaAudio
% %setpref('dsp','portaudioHostApi',3)  % Sets audio output API to ASIO
% 
% %% User parameters
% fs = 48000;         %Hz, sampling frequency
% Tsweep = 4;         %s time for sweep
% Tsilence = 4; %s silence following sweep
% fstart = 5;         %Hz, Start frequency
% fstop = fs/2;       %Hz,  Stop frequency
% Tfadein = 0.1;   %s, Length of fade in 
% Tfadeout = 4/fs;       %s, Length of fade out
% Ttotal = Tsweep + Tsilence;       %s, total time for sweep + silence
% 
% channelsRec = [1 2]; %Which soundcard channels to record on
% channelsPlay = 1; % Which soundcard channel to play on
% 
% %% Generate sweep signal
% s_exp = genMeasSig(Tsweep,fs,fstart,fstop,Tsilence,Tfadein,Tfadeout);
% s_exp = s_exp .* db2mag(-18);
% 
% %% Create the inverse filter
% [hinv, Hinv] = getInverse(s_exp);
% 
% %% Reconvolve with measurement signal as sanity check
% d = getIR(s_exp, Hinv);
% 
% %% Init audio object for sound recording and playback
% ao = HeaAudioDSP;
% ao.fs = fs;
% % Select recording and playback channels
% ao.channelsPlay = channelsPlay;
% ao.channelsRec = channelsRec;
% 
% %% Play stimulus and record
% disp('Measurement start.');
% y = ao.playrec(s_exp);
% disp('Measurement completed.');
%% Recover IR
h = getIR(y,Hinv);
h_norm = h ./ max(max(abs(h))); % Normalize IRs to the overall maximum
%% Plot the ETC
figure;
plot(10*log10(h_norm.^2))

%% Plot the spectrograms

N = 2*round(0.032*fs/2);
R = N/2;
w = hann(N);
M = N;
[X,t,f] = stft(y(:,1),fs,w,R,M);

h = plotSTFT(t,f,X,fs,0,120)
%% Save and add variables of importance
%save(sprintf('meas_%d_%d_%d_%d_%d_%d.mat',fix(clock)),'s_exp','Hinv','y','h_norm','fs','Tsweep','Tsilence');
% audiowrite([sprintf('meas_%d_%d_%d_%d_%d_%d.mat',fix(clock)) '.wav'],h_norm,fs,'BitsPerSample',24);
