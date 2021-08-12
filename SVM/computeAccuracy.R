computeAccuracy = function(data, numFolds, kernel){
  folds = createFolds(data$status, k = numFolds, returnTrain = TRUE)

  # https://www.rdocumentation.org/packages/caret/versions/6.0-86/topics/trainControl
  # index refers to training set, that's why createFolds needs returnTrain = TRUE
  trc = trainControl(method="cv", search="grid", savePredictions = "final", index = folds, classProbs=TRUE, summaryFunction = twoClassSummary)
  
  model = train(
    status ~., data = data, method = "svmPoly",
    trControl = trc,
    preProcess = c("center","scale"),
    tuneGrid = expand.grid(C=2^(-2:8), degree=1:10, scale=2^(-2:5)),
    #tuneGrid = expand.grid(C=2^(-2:8), sigma=1:10/100),
    metric="ROC"
  )

  return(model)
}