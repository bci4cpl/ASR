# ASR 

An EEG artefact removal method implementd both for offline and online applications
[demo from Intheon ](https://www.youtube.com/watch?v=qYC_3SUxE-M)

The implemented algorithm takes 3 parts:
1. Train a rejection threshold from pre recorded baseline calibration data
   1. split the contineous data into 1sec epochs
   1. transform into channelwize cross samples RMS (e.g. a channel x epoch)
   1. Z score 
   1. Reject epocs not fulfiled -3.5<z<5.5
   1. Concatenate *real* EEG clean EEG epochs
1. rejection creiteria on a PC space
1. Apply the trained parameter on a moving online window to create a clean EEG data


# Prerequisits
Written in matlab 2019a, 2018a. other versions not checked
optional EEGLAB in the matlab path for some intermediate visualizations

# Refferences
EEG lab sscn main article [web](https://sccn.ucsd.edu/wiki/Artifact_Subspace_Reconstruction_(ASR)).

Implementation with cognionics dry ssytem [PubMed](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4710679/).

Evaluation_of_Artifact_Subspace_Reconstruction_for_Automatic_EEG_Artifact_Removal [link](https://www.researchgate.net/publication/325921646)
