clear; clc; close all

load eeg.mat; % eeg
Fs = 256;
dt = 1/Fs;
% N_ch - number of EEG channels

%%
Ch1 = eeg(1,1:10000);
t = (1:length(Ch1))*dt;
plot(t,Ch1)

% Define Baseline period without artifacts

%% 1. create Xc: caibration data (a matrix of N_ch-by-N_tc, N_tc = Number of clean 1-sec time windows times Fs)
%1 split into 1 sec windows (pseudo epoching)
wnd_size = 1 * Fs; % secnonds * Fs 
win_n = size(eeg)/ wnd_size; % TODO: have to trim from eeg the mod of the deviation
epdata = reshape(eeg, [channels, wnd_size, wnd_n]);

%2 calculate RMS for each channel in each window
epdata = RMS(epdata);

%3 calculate z-scorr for each channel
zepdata = zscore(epdata);

%4 reject windows with Z>5.5 or Z<-3.5
wnd_reject = zepdata > 5.5 || zepdata < -3.5;

%5 concatenate the other windows

%% 2. rejection creiteria on a PC space
clear;clc
Fs = 30;
Xc = randn(3,127);

%1 covarience matrix of Xc
Xc_cov = cov(Xc'); % N_ch-by-N_ch

% 1a Diagonalize Xc_cov
[Vxc,Dxc] = eig(Xc_cov);
Dxc_sqrt = sqrt(Dxc);

%2 find Mc such that Mc*Mc'=Xc_cov
Mc = Vxc*Dxc_sqrt*Vxc';

%3 Diagonalize Mc
Vc = Vxc;
Dc = Dxc_sqrt;
% [Vc,Dc] = eig(Mc); % Direct calculation. Not needed.
% (Test: Vc'*Vc = eye(N_ch) )

%4 calculate projection of Xc on the PC space
Yc = transpose(Vc)*Xc;

% Divide Yc into 0.5-sec windows
N_win = round(Fs/2); % number of samples in each 0.5-sec window
Num_of_Windows = floor(size(Yc,2)/N_win);
N_ch = size(Yc,1);
Yc_epoched = reshape(Yc(:,1:Num_of_Windows*N_win),N_ch,N_win,Num_of_Windows);

% Find mean and std of each 0.5-sec window
Yc_epoched_RMS = RMS(Yc_epoched);
%Yc_epoched_RMS = squeeze(Yc_epoched_RMS);
Yc_mean = mean(Yc_epoched');
Yc_std = std(Yc_epoched');

% Find threshold T_i = mue_i + k*sigma_i
T = Yc_mean + k*Yc_std;

%% 3. Apply to data X

% C_x = cov(X'); % cov of data
% [V,D] = eig(C_x);

% Identify components to be rejected

% Construct matrix of remaining components V_trunc


% X_clean = Mc*(V_trunc'*Mc)'*V'*X;




