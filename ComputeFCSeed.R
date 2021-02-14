computeFCSeed = function(A.pos.norm.sub, roi, controlGroup, experimentalGroup, nodes, atlasObject){
    
    numSP = length(experimentalGroup)
    numControl = length(controlGroup)
    maxIndex = nodes - 1
    pvalues = data.table(p.value=numeric(), region1Name=character(), region2Name=character(), region1Index=numeric(), region2Index=numeric())[1:maxIndex]
    progress = txtProgressBar(min = 0, max = nodes, initial = 0, style = 3)
    for(index in 1:nodes){
        if(roi == index){
            next
        }
        spCount = 1
        controlCount = 1
        for(subject in 1:n){
            if(is.element(subject, controlGroup)){
                controlList[controlCount] = A.pos.norm.sub[[1]][roi,index,subject]
                controlCount = controlCount + 1
            }
            else if(is.element(subject, experimentalGroup)){
                spList[spCount] = A.pos.norm.sub[[1]][roi,index,subject]
                spCount = spCount + 1
            }

        }     
        ttest = perm.t.test(spList, controlList, R = 10000)
        pvalues[index] = list(ttest$perm.p.value, atlasObject$name[index], atlasObject$name[roi], index, roi)
        setTxtProgressBar(progress, index)
    }
    
    return(pvalues)
    
}