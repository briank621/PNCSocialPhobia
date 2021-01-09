computeSmall = function(g.all.sub, thresholds, numRandom){
    # This function returns a data table with small world statistics (normalized)
    # for each density / subject
    
    numSubjects = length(g.all.sub[[1]]$graphs)
    numThresholds = length(thresholds)
    small.dt = data.table()
    progress = txtProgressBar(min = 0, max = numSubjects * length(thresholds), initial = 0, style = 3)
    
    for(j in 1:numThresholds){
        for(i in 1:numSubjects){
            testGraph = g.all.sub[[j]]$graphs[[i]]
            randomGraphs = sim.rand.graph.par(testGraph, N=numRandom, clustering=FALSE)
            randomGraphList = as_brainGraphList(list(randomGraphs), type="random")
            subjectdt = small.world(as_brainGraphList(testGraph), randomGraphList)
            small.dt = rbind(small.dt, subjectdt)
            setTxtProgressBar(progress, i + (j - 1) * numSubjects)
        }
    }
    
    return(small.dt)
  
}