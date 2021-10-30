library(e1071)
library(ROSE)

# alldata = read.table(file="SPvHCFCAll_data.csv", sep=',',header = T)
alldata = read.table(file=paste(getwd(),"/Documents/quant/PNCSocialPhobia/cost_sensitive/combined.csv", sep='')
                     , sep=',',header = T)
alldata$status = as.factor(alldata$status)

nfolds=4
set.seed(21)
subdata <- createFolds(alldata$status, nfolds)

results = NULL
for (p in 1:4){
  if (p==1){
    temp1 <-subdata$Fold1
  } else if(p==2) {
    temp1 <-subdata$Fold2
  } else if(p==3) {
    temp1 <-subdata$Fold3
  } else {
    temp1 <-subdata$Fold4
  }
  
  data.rose = ROSE(status~., data=alldata[-temp1,], p=.55, hmult.majo=.25, hmult.mino=.25, seed=321)$data
  table(data.rose$status)
  
  tune.out <- tune(svm, status ~.,data=data.rose, kernel="linear", ranges=list(cost=c(0.001,0.03, 0.05, 0.1, 1)))

  summary(tune.out$best.model) 
  svmpred <- predict(tune.out$best.model, newdata=alldata[temp1,])
  table(alldata[temp1,]$status, svmpred)
  CM = confusionMatrix( svmpred, alldata[temp1,]$status, positive="SP")
  temp = c( CM$overall[1], CM$byClass[1], CM$byClass[2])
  results= rbind(results, temp) 
}

results
colMeans(results)
#Accuracy Sensitivity Specificity 
#0.7050000   0.7500000   0.6791667 

