computeRegionalAUC = function(dt.g.all.sub.vertex, covars.fmri, thresholds, metric){
    
    # This function computes differences in
    # regional metrics (nodal efficiency, nodal degree) between SP and Control Groups
    
    subjectStatus = covars.fmri[,.(SUBJID, status)]
    numSP = subjectStatus[,sum(status == "SP")]
    numControl = subjectStatus[,sum(status == "Control")]
    
    numThres = length(thresholds)
    pvalues = rep(NA, 264)
    progress = txtProgressBar(min = 0, max = 264, initial = 0, style = 3)
    for(nodei in 1:264){
        nodeName = power264[nodei]$name
        spList = rep(NA, numSP)
        controlList = rep(NA, numControl)
        spCount = 1
        controlCount = 1
        for(row in 1:nrow(subjectStatus)){
            subjectResult = rep(NA, numThres)
            subjectID = subjectStatus[row]$SUBJID
            for(i in 1:numThres){
                checkThreshold = thresholds[i]
                subjectResult[i] = dt.g.all.sub.vertex[SUBJID==subjectID & region == nodeName & 
                                                           threshold == checkThreshold][[metric]]
            }
            auc = trapz(thresholds, subjectResult)
            #print(auc)
            #print(subjectID)
            #print(subjectResult)
            if(subjectStatus[row]$status == "SP"){
                spList[spCount] = auc
                spCount = spCount + 1
            }
            else{
                controlList[controlCount] = auc
                controlCount = controlCount + 1
            }
        }
        #print("before perm")
        #print(spList)
        #print(controlList)
        #print(length(spList))
        result = perm.t.test(spList, controlList, R = 10000)
        #print("after perm")
        pvalues[nodei] = result$perm.p.value
        setTxtProgressBar(progress, nodei)
    }
    
    # FDR Correction
    adjustedP = p.adjust(pvalues, method = "fdr")
    
    return(list("significantNodes"=which(adjustedP < .05), "adjustedpvalues"=adjustedP, "rawpvalues"=pvalues))
    
}