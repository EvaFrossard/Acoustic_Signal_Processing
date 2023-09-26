clear
close all
clc

% Install subfolders 
addpath tools
addpath signals

%% EXERCISE: Uniform quantization (LECTURE 01, SLIDE 30)
% •	write a function quantize.m 
% •	initialize user parameters (e.g. number of bits)  
% •	load and normalize a speech signal x such that its maximum is 1
% •	perform quantization 
% •	listen to the quantized signal 

%% USER PARAMETERS

bits = [5 8 10 12];
type = 'midrise';

%% CREATE SIGNAL

% Load speech file
[x, fs] = readAudio("speech@24kHz.wav");

% Normalize signal to 1
x = x / max(abs(x));

%% PERFORM QUANTIZATION

% Allocate memory
quantization = cell(length(bits), 1);

for i = 1 : length(bits)
    nBits = bits(i);
    [q,delta] = quantize(x, nBits, type);
    quantization{i} = q;
end

prompt = "Enter the number of bits for quantization ";
option = input(prompt);
if(option == 5 || option == 8 || option == 10 || option == 12)
    soundsc(quantization{find(bits == option, 1)}, fs);    
else
    error('Those number of bits are not valid')
end
