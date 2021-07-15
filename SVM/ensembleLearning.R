ensembleLearning = function(data, numFolds){
  folds = createFolds(data$status, k = numFolds, returnTrain = TRUE)
  
  # https://www.rdocumentation.org/packages/caret/versions/6.0-86/topics/trainControl
  # index refers to training set, that's why createFolds needs returnTrain = TRUE
  trc = trainControl(method="cv", search="grid", savePredictions = "final", index = folds, classProbs=TRUE, summaryFunction = twoClassSummary)
  
  modelList = caretList(status ~., data = data, metric = "ROC",
                        trControl = trc, 
                        tuneList = list(glm = caretModelSpec(method="glm"),
                                        gauss = caretModelSpec(method="gaussprRadial"),
                                        svm = caretModelSpec(method="svmRadial", tuneGrid = expand.grid(C=2^(-2:8), sigma=1:10/100)))
                      )
  model = caretEnsemble(modelList, metric="ROC", trControl=trc)
  # browser()
  
  # Might need to compute the predictions manually
  # numCorrect = sum(model$ens_model$pred$pred == model$ens_model$pred$obs)
  # accuracies = numCorrect / nrow(data)
  # confMatrix = table(model$ens_model$pred$pred, model$ens_model$pred$obs)
  # sens = sensitivity(confMatrix, negative='Control', positive='SP')
  # spec = specificity(confMatrix, negative='Control', positive='SP')
  # print("")
  # print(paste("Accuracy: ", round(accuracies, 4)))
  # print(paste("Sensitivity: ", round(sens, 4)))
  # print(paste("Specificity: ", round(spec, 4)))
  
  return(model)

}