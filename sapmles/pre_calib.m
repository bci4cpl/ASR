%%%%% 24-07-2019
%% this script will create a calibration state to be used in an ASR data cleaning process
clear all; clc;
% preperations for dev
% delete for production
load('D:\Google Drive\eeg-projects\pythonlib\eegutils\sample\038-000-PRE_EO-03-Dec-2018-0.90579.mat')
raw = EEG; clear EEG; 
%% Params
CUTOFF = 10;


%%

eeglab nogui
EEG = pop_importdata('dataformat','array','nbchan',0,'data','raw','srate',512,'pnts',0,'xmin',0);
EEG = pop_select( EEG,'nochannel',1); % remove the first time channel

load('gTec_Chanlocs.mat')
% EEG.chanlocs = ChanLocs;


%%
EEG_ASR_C = {};

EEG_C = clean_flatlines(EEG);
% if isempty(EEG.chanlocs)== 0
%     EEG_C = clean_channels(EEG_C);
% else
%     EEG_C = clean_channels_nolocs(EEG_C);
% end
EEG_C = clean_drifts(EEG_C);

state = asr_calibrate(EEG_C.data, EEG_C.srate, CUTOFF);

