# Samples instructions
## offline_clean.m
This sample matlab code will clean the EEG data provided using the ASR paradigm examining different cutoff values.

To properly run this sample firt load an EEG array (channels x samples) into the ```raw``` variable. 
Set the ```sr``` variable to the recordings sample rate (usually 512 or 256).

A different set of /cutoff@ values can be changed by altering the ```cut_off_arr``` in the beginning of the code.
```matlab
cut_off_arr = [0 5 10 20 50 100]; % change this variable to the desired cutoff values.
```

to run it all type ```offline_clean``` at the matlab`s command prompt.
make sure that the folder __@project_root@/clean_rawdata1.00__ is in the path of your current session.

### Prerequisits
please make sure ```eeglab``` is in your system path.

### Output

1. The code will generate a comparison plot for each cutoff sample that you specified. 
The source data will be colored and the cleaned data will be ploted on top in black ink.

2. A cell structure will be avaliable in the variable ```EEG_ASR_C``` that will hold the analysis results:
each cell will be a struct with the fields: ```cutoff``` the cutoff of this analysis and ```data``` that is the cleaned data.
a special case is the first cell with a ```data = 0``` member. The ```data``` member of this cell holds the original data before ASR. 
That is, the original data after preprocessing.

## online_clean.m
this script will fetch data using LSL
https://github.com/sccn/labstreaminglayer in chunks. this contineous data
will be cleaned using the state variable (in the workspce) that is the
result of the offline calibrations. The results of running the script will be moving online plot describing the __raw__ data comared to the __asr cleaned__ data one on top the other.

### prerequisits:
       1. run the pre_calib.m script. you shuld have now a 'state' variable
       in the environment EEG (eeg lab struct) and (EEG_C) cleaned EEGLAB
       struct.
       2. make sure you have matlab-lsl in the working path
       3. get some data with the EEG label to be transmitted over LSL


 :camel: 
