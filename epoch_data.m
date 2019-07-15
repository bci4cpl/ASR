% Epoching a contineous data
%
% In: 
%       data:   EEG data to be epoched channels x samples
%       t:      single epoch (window) time in miliseconds
%       Fs:     frequency of samples (samples per second)
%
% Out:
%       epoched:    EEG data epoched with channels x samples x epochs
%       N_win:      Number of samples in each epoch (windows) equivalent to
%                   size(epoched,2)                                             
%       Num_of_Windows: number of epoche generated. equivalent to
%       size(epoched,3)
function [epoched, N_win, Num_of_Windows] = epoch_data(data, t, Fs)

    N_win = round(t*Fs/1000); % number of samples in each 0.5-sec window
    Num_of_Windows = floor(size(data,2)/N_win);
    N_ch = size(data,1);
    epoched = reshape(data(:,1:Num_of_Windows*N_win),N_ch,N_win,Num_of_Windows);
end