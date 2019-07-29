%% 29/07/2019
% this script will fetch data using LSL
% https://github.com/sccn/labstreaminglayer in chunks. this contineous data
% will be cleaned using the state variable (in the workspce) that is the
% result of the offline calibrations
%
% prerequisits:
%       1. run the pre_calib.m script. you shuld have now a 'state' variable
%       in the environment EEG (eeg lab struct) and (EEG_C) cleaned EEGLAB
%       struct.
%       2. make sure you have matlab-lsl in the working path
%       3. get some data with the EEG label to be transmitted over LSL


%
% some general plot parameters
chan_select = 1:10;
color_spec = parula(10);
buff_length = 5120; % smplaes. for seconds buff_length/srate
plot_scale = 50;

% asr specific parameters
maxdims = 0.66;
usegpu = 0;

%% reading data and clean it
warning('off','MATLAB:subscripting:noSubscriptsSpecified');

% instantiate the library
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});

disp('Now receiving chunked data...');

% some contineous plotting initializations.
figure (1)
plot_buff = zeros(EEG.nbchan,buff_length);
plot_time_bff = zeros(buff_length,1);
plot(plot_buff');
xlim([0 buff_length]);
plot_color_raw = color_spec(5,:);

% some ASR parameters - to be uncluded in header or other parameterized
% system
windowlen = max(0.5,1.5*EEG.nbchan/EEG.srate); 
stepsize = floor(EEG.srate*windowlen/2);

asr_buff = zeros(EEG.nbchan, stepsize);
asr_plot_buff = ones(EEG.nbchan,buff_length);
plot_color_asr = color_spec(7,:);



while true
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    sz = size(stamps,2);
    if sz > 0
        
        % remove excess channels from data. In this vesrion it is
        % hypothesized theat the first channel is the time channel and
        % therefore removed. TODO: remove previeusly marked bad channels.
        data_ = chunk;
        
        % cycle the time buff
        plot_time_bff = circshift(plot_time_bff, -sz);
        insr_in_ = buff_length - sz + 1;
        plot_time_bff(insr_in_:end) = stamps/10000;
        
        % cycle a buffer with the new sample to create the sample window
        % that will be fed to the ASR.
        asr_buff = circshift(asr_buff, -sz,2);
        insr_in_ = stepsize - sz + 1;
        asr_buff(:,insr_in_:end) = data_;
        
        
        % do the actual ASAR analysis
        [signal.data,state] = asr_process(asr_buff, EEG.srate,state,windowlen,windowlen/2,stepsize,maxdims,[],usegpu);
        % shift signal content back (to compensate for processing delay)
%         signal.data(:,1:size(state.carry,2)) = [];
    
        % asr plotting preperations.
        sa_asr = size(signal.data,2);
        asr_plot_buff = circshift(asr_plot_buff, -sa_asr,2);
        insr_in_ = buff_length - sa_asr + 1 ;
        asr_plot_buff(:,insr_in_:end) = signal.data;
        
        % original data plotting preperations
        plot_buff = circshift(plot_buff, -sa_asr,2);
        insr_in_ = buff_length - sa_asr + 1;
        plot_buff(:,insr_in_:end) = asr_buff;
        
        % plotting the data into a moving plot.
        t = linspace(1, buff_length/EEG.srate ,size(asr_plot_buff,2));
        leadplot(plot_buff(chan_select,:), asr_plot_buff(chan_select,:),t, plot_scale, plot_color_raw, plot_color_asr, .5, .08, .1);
%         xlim([0 buff_length]);
        ylim([-(plot_scale + 5) 5]);
        
        pause(0.05);
    end
end