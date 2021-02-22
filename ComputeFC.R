computeFC = function(A.pos.norm.sub, controlGroup, experimentalGroup, nodes, atlasObject){

    numSP = length(experimentalGroup)
    numControl = length(controlGroup)
    
    spList = rep(0, numSP)
    controlList = rep(0, numControl)
    n = dim(A.pos.norm.sub[[1]])[3]
    index = 1
    maxIndex = ((nodes * (nodes - 1)) / 2)
    pvalues = data.table(p.value=numeric(), region1Name=character(), region2Name=character(), region1Index=numeric(), region2Index=numeric())[1:maxIndex]
    progress = txtProgressBar(min = 0, max = maxIndex, initial = 0, style = 3)
    for(i in 1:nodes){
        for(j in 1:nodes){
            if(i >= j){
                next
            }
            spCount = 1
            controlCount = 1
            for(subject in 1:n){
                if(is.element(subject, controlGroup)){
                    controlList[controlCount] = A.pos.norm.sub[[1]][i,j,subject]
                    controlCount = controlCount + 1
                }
                else if(is.element(subject, experimentalGroup)){
                    spList[spCount] = A.pos.norm.sub[[1]][i,j,subject]
                    spCount = spCount + 1
                }
            }     
            ttest = perm.t.test(spList, controlList, R = 10000)
            pvalues[index] = list(ttest$perm.p.value, atlasObject$name[i], atlasObject$name[j], i, j)
            setTxtProgressBar(progress, index)
            index = index + 1
        }
        
    }
    
    return(pvalues)
    
}