computeSingleRegionAUC = function(dt.g.all.sub.vertex, nodeName, covars.fmri, thresholds, metric){
    
    # This function computes differences in
    # regional metrics (nodal efficiency, nodal degree) between SP and Control Groups
    
    subjectStatus = covars.fmri[,.(SUBJID, status)]
    result = data.table(SUBJID=character(), metric = numeric())
    metricName = paste(metric, nodeName, sep='_')
    colnames(result)[2] = metricName
    numThres = length(thresholds)
    
    for(row in 1:nrow(subjectStatus)){
        subjectResult = rep(NA, numThres)
        subjectID = subjectStatus[row]$SUBJID
        for(i in 1:numThres){
            checkThreshold = thresholds[i]
            subjectResult[i] = dt.g.all.sub.vertex[SUBJID==subjectID & region == nodeName & 
                                                       threshold == checkThreshold][[metric]]
        }
        auc = trapz(thresholds, subjectResult)
        result = rbind(result, list(subjectID, auc))
    }
    return(result)
}