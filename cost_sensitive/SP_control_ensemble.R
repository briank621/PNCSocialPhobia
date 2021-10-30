library(caret)
library(caretEnsemble)
library(randomForest)
library(ROSE)

# alldata = read.table(file=paste(getwd(),"/Documents/quant/PNCSocialPhobia/cost_sensitive/SPvHCFCAll_data.csv", sep='')
                     # , sep=',',header = T)
alldata = read.table(file=paste("/home/brian","/Documents/quant/PNCSocialPhobia/cost_sensitive/ControlSPCombined.csv", sep='')
                     , sep=',',header = T)
alldata$status = as.factor(alldata$status)

nfolds=4
set.seed(21)
subdata = createFolds(alldata$status, nfolds)

results = NULL
for (p in 1:4){
  
  if (p==1){
    temp1 <-subdata$Fold1
  } else if(p==2) {
    temp1 <-subdata$Fold2
  } else if(p==3) {
    temp1 <-subdata$Fold3
  } else{
    temp1 <-subdata$Fold4
  } 
  
  
  mytrain <- alldata[-temp1, ]
  mytest <- alldata[temp1, ]
  xtrain <- alldata[-temp1, ]
  xtest <- alldata[temp1, ]
  ytrain <- alldata[-temp1,]
  ytest <- alldata[temp1,]
  
  data.rose = ROSE(status~., data=mytrain, p=.55, hmult.majo=0.5, hmult.mino=.25, seed=321)$data
  table(data.rose$status)
  
 # need to get this model working
  
 myControl <- trainControl(method="cv", number =5, savePredictions = "final", classProbs=TRUE, index= createFolds(data.rose$status, 5))
  
  model_list <- caretList(status ~., data=data.rose, trControl = myControl,    
                          tuneList = list(
   rf1=caretModelSpec(method="rf", tuneGrid=data.frame(.mtry=6)),
 
   glmnet1=caretModelSpec(method="glmnet", tuneGrid=expand.grid(alpha = 0:1,lambda = seq(0.001, 10, length = 20))),

  nn=caretModelSpec(method="nnet", tuneLength=2, trace=FALSE),

    svm1=caretModelSpec(method="svmLinear", tuneGrid=expand.grid(C = c(0.1, 1, 10, 100, 1000)))
                          )
                          )

  


  model1 <- caretStack(model_list, method="gbm",verbose=FALSE, tuneLength=10,  metric="ROC", trControl=trainControl(method="repeatedcv", number=5, repeats=5, savePredictions="final", classProbs=TRUE,summaryFunction=twoClassSummary))
 # model1 <- caretStack(model_list, method="gbm",verbose=FALSE, tuneLength=10,  metric="ROC", trControl=trainControl(method="boot", number=25, savePredictions="final", classProbs=TRUE,summaryFunction=twoClassSummary))
  # browser()
  yhat <- predict(model1, xtest)
  # table(ytest, yhat)
  CM = confusionMatrix( yhat, ytest$status, positive="SP")
  temp = c( CM$overall[1], CM$byClass[1], CM$byClass[2])
  results= rbind(results, temp) 
  # browser()
}


results
colMeans(results)
# Accuracy Sensitivity Specificity 
# 0.7245833   0.7500000   0.7104167 


























