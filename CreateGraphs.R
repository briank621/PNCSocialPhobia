createGraphs = function(subjectMat, groupMat, thresholds, covars, atlas){
    modality = 'fmri'
    groups = c('Control', 'SP', 'SPADHD')
    #groups = c('SPADHD')
    g = vector('list', length(thresholds))
    g.group = vector('list', length(thresholds))
    
    for (j in seq_along(thresholds)) {
        #print(dim(subjectMat[[j]]))
        #print(dim(groupMat[[j]]))
        g[[j]] <- make_brainGraphList(subjectMat[[j]], atlas, modality=modality,
                                      gnames=covars.fmri$SUBJID, grpNames=covars.fmri$status,
                                      weighted=NULL, threshold=thresholds[j], diag=FALSE)
        #g.group[[j]] <- make_brainGraphList(groupMat[[j]], atlas, modality=modality, threshold=thresholds[j],
                                               # gnames=groups)
    }
    
    return(c(g, g.group))
}