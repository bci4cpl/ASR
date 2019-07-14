clear; clc; close all

load eeg.mat; % eeg
Fs = 256;
dt = 1/Fs;

%%
Ch1 = eeg(1,1:10000);
t = (1:length(Ch1))*dt;
plot(t,Ch1)

% Define Baseline period without artifacts

%% 1. create Xc: caibration data
%1 split into 1 sec windows (pseudo epoching)
wnd_size = 1 * Fs; % secnonds * Fs 
win_n = size(eeg)/ wnd_size; % TODO: have to trim from eeg the mod of the deviation
epdata = reshape(eeg, [channels, wnd_size, wnd_n]);

%2 calculate RMS for each channel in each window
epdata = RMS(epdata);

%3 calculate z
zepdata = zscore(epdata);

%4 reject windows with -3.5<z<5.5
wnd_reject = zepdata < 5.5 && zepdata > -3.5;

%5 concatenate the other windows

%% 2. rejection creiteria on a PC space

%1 covarience matrix of Xc
