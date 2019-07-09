clear; clc; close all

load eeg.mat; % eeg
Fs = 256;
dt = 1/Fs;

%%
Ch1 = eeg(1,1:10000);
t = (1:length(Ch1))*dt;
plot(t,Ch1)

% Define Baseline period without artifacts

