% clear all;clc;
%%
eeglab nogui
EEG = pop_importdata('dataformat','array','nbchan',0,'data','raw','srate',512,'pnts',0,'xmin',0);
EEG = pop_select( EEG,'nochannel',1); % remove the first time channel

load('gTec_Chanlocs.mat')
% EEG.chanlocs = ChanLocs;


%%
EEG_ASR_C = {};

EEG_C = clean_flatlines(EEG);
if isempty(EEG.chanlocs)== 0
    EEG_C = clean_channels(EEG_C);
else
    EEG_C = clean_channels_nolocs(EEG_C);
end
EEG_C = clean_drifts(EEG_C);

EEG_ASR_C{1}.cutoff = 0;
EEG_ASR_C{1}.data =EEG_C;
c = parula(size(cut_off_arr,2));
for cutoffinx = 2:size(cut_off_arr,2)
    fprintf(['ASR clean with cutoff:\t' num2str(cut_off_arr(cutoffinx)) '\t***********\n\n']);
    EEG_ASR_C{cutoffinx}.cutoff = CUTOFF;
    EEG_ASR_C{cutoffinx}.data = clean_asr(EEG_C,cut_off_arr(cutoffinx));
    vis_artifacts(EEG_ASR_C{cutoffinx}.data,EEG_ASR_C{1}.data,'OldColor',c(cutoffinx,:));
end
fprintf('Finish---\n');