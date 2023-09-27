clear
close all
clc

%%
% Define your signal and sampling parameters
Fs = 1000;  % Sampling frequency (Hz)
t = 0:1/Fs:1 - (1/Fs);  % Time vector from 0 to 1 second
f1 = 10;  % Frequency of your signal in Hz
signal = sin(2*pi*f1*t);  % Example signal (sine wave)

% Define the duration of the fade-in (in seconds)
fade_in_duration = 0.2;  % Adjust as needed

fade_in_signal = fade(signal,0.2*Fs, 0.3*Fs, 1);
% Plot the original and fade-in signals
figure;
subplot(2,1,1);
plot(t, signal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, fade_in_signal);
title('Signal with Hann Window Fade-In');
xlabel('Time (s)');
ylabel('Amplitude');

% Play the original and fade-in signals (optional)
sound(signal, Fs);
pause(1);  % Pause for the duration of the original signal
sound(fade_in_signal, Fs);
