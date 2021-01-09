computeAUC = function(dt.g.all.sub.graph, covars.fmri, thresholds, metric, subjectColumn="Study.ID", small.dt, graph.dt){

    subjectStatus = covars.fmri[,.(SUBJID, status)]
    result = data.table(SUBJID=character(), metric = numeric())
    colnames(result)[2] = metric
    numThres = length(thresholds)
    
    for(row in 1:nrow(subjectStatus)){
        subjectResult = rep(NA, numThres)
        subjectID = subjectStatus[row]$SUBJID
        badThresholds = numeric()
        for(i in 1:numThres){
            checkThreshold = thresholds[i]
            subjectResult[i] = dt.g.all.sub.graph[get(subjectColumn)==subjectID & threshold == checkThreshold][[metric]]
            #if(small.dt[threshold==checkThreshold&SUBJID==subjectID]$sigma < 1 || 
             #  graph.dt[threshold==checkThreshold&SUBJID==subjectID]$max.comp <= 235)
             #   badThresholds = append(badThresholds, i);
        }
        if(length(badThresholds) > 0){
            auc = trapz(thresholds[-badThresholds], subjectResult[-badThresholds])
        }
        else{
            auc = trapz(thresholds, subjectResult)
        }
        result = rbind(result, list(subjectID, auc))
    }
    return(result)
    
}