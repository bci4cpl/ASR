clear; clc; close all

load eeg.mat; % eeg
Fs = 256;
dt = 1/Fs;
% N_ch - number of EEG channels

%%
Ch1 = eeg(2,1:10000);
t = (1:length(Ch1))*dt;
plot(t,Ch1)

eeg_clean_ch = eeg(2:20,:);
% Define Baseline period without artifacts

%% 1. create Xc: caibration data (a matrix of N_ch-by-N_tc, N_tc = Number of clean 1-sec time windows times Fs)
%1 split into 1 sec windows (pseudo epoching)
epdata = epoch_data(eeg_clean_ch, 1000, Fs);
eegplot_CPL(epdata, 'srate',Fs);

%2 calculate RMS for each channel in each window
data_rms = rms(epdata,2);

%3 calculate z-scorr for each channel
zepdata = zscore(data_rms);

%4 reject windows with either channel Z>5.5 or Z<-3.5
wnd_reject = sum(zepdata > 5.5 | zepdata < -3.5);
epdata_c = epdata(:,:,wnd_reject ~= 1);
eegplot_CPL(epdata_c, 'srate',Fs);

%5 concatenate the other windows
Xc = reshape(epdata_c,size(eeg_clean_ch,1),[]);
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
% N_win = round(Fs/2); % number of samples in each 0.5-sec window
% Num_of_Windows = floor(size(Yc,2)/N_win);
% N_ch = size(Yc,1);
Yc_epoched = epoch_data(Yc, 500, Fs); % reshape(Yc(:,1:Num_of_Windows*N_win),N_ch,N_win,Num_of_Windows);

% Find mean and std of each 0.5-sec window
Yc_epoched_RMS = rms(Yc_epoched,2);
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




