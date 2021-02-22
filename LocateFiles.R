#paths = c('/Result04_DPASF1', '/Result04_DPASF2', '/Result04_DPASF3', '/Result04_DPASF4', '/Result04_DPASF5')
paths = c('/Gender/SPADHD_DPARSF')
basedir = '/home/xin/BrainImaging2016'
matfiles = list()
for (path in paths) {
    matfiles = c(matfiles, list(list.files(paste(basedir, path, '/Results/ROISignals_FunImgARCWF', sep=''), 'ROICorrelation_FisherZ_sub_[0-9]+.txt', full.names=T)), recursive=TRUE)
}

# Filter subjects
selectedSubjectFiles = rep(NA, length(covars.fmri$SUBJID))
count = 1
for (subjectID in covars.fmri$SUBJID){
    found = FALSE
    for (path in matfiles){
        if(endsWith(path, paste('ROICorrelation_FisherZ_sub_', subjectID, '.txt', sep=''))){
            selectedSubjectFiles[count] = path;
            found = TRUE;
            count = count + 1
        }
    }
    if(! found){
        #print(subjectID)
        covars.fmri = covars.fmri[covars.fmri$SUBJID != subjectID]
    }
    else{
        #covars.fmri = covars.fmri[covars.fmri$SUBJID != subjectID]
    }
}

matfiles = list(A=selectedSubjectFiles[!is.na(selectedSubjectFiles)])
file.copy(matfiles$A, 'aal_global_datafiles') # move over all the files to a separate folder