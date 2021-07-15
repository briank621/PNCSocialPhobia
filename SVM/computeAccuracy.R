computeAccuracy = function(data, numFolds, kernel){
  folds = createFolds(data$status, k = numFolds, returnTrain = TRUE)

  # https://www.rdocumentation.org/packages/caret/versions/6.0-86/topics/trainControl
  # index refers to training set, that's why createFolds needs returnTrain = TRUE
  trc = trainControl(method="cv", search="grid", savePredictions = "final", index = folds, classProbs=TRUE, summaryFunction = twoClassSummary)
  
  model = train(
    status ~., data = data, method = "svmRadial",
    trControl = trc,
    preProcess = c("center","scale"),
    tuneGrid = expand.grid(C=2^(-2:8), sigma=1:10/100),
    metric="ROC"
  )
  # browser()
  # numCorrect = sum(model$pred$pred == model$pred$obs)
  # accuracies = numCorrect / nrow(data)
  # confMatrix = table(model$pred$pred, model$pred$obs)
  # sens = sensitivity(confMatrix, negative='Control', positive='SP')
  # spec = specificity(confMatrix, negative='Control', positive='SP')
  # print("")
  # print(paste("Accuracy: ", round(accuracies, 4)))
  # print(paste("Sensitivity: ", round(sens, 4)))
  # print(paste("Specificity: ", round(spec, 4)))
  return(model)
}