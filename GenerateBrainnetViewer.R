generateBrainnetViewer = function(numberNodes, regions.dt, filePath){
    adj = matrix(0, nrow = numberNodes, ncol = numberNodes)
    for(i in 1:NROW(regions.dt)){
        region1 = regions.dt[i]$region1Index
        region2 = regions.dt[i]$region2Index
        adj[region1,region2] = regions.dt[i]$confInt
    }
    write.table(adj, file=filePath, row.names=FALSE, col.names=FALSE)
}