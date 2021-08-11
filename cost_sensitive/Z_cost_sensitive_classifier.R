

binge.train.train <- binge.lag1.train
binge.train.validation<-binge.lag1.validation
binge.train.train$bingnow<-as.factor(binge.train.train$bingnow)
binge.train.validation$bingnow<-as.factor(binge.train.validation$bingnow)

csc1.res=NULL
csc2.res=NULL
csc3.res=NULL
csc4.res=NULL
csc5.res=NULL

cost=seq(1,4,by=0.25)
for (k in 1:13) {
  i=cost[k]
  csc1 = CostSensitiveClassifier(status ~ ., data = data.training.train, control = Weka_control(`cost-matrix` = matrix(c(0, i, 1, 0), ncol = 2), W = "weka.classifiers.meta.RandomCommittee", M = TRUE))                
  csc2 = CostSensitiveClassifier(status ~ ., data = data.training.train,  control = Weka_control(`cost-matrix` = matrix(c(0, i, 1, 0), ncol = 2), W = "weka.classifiers.meta.Bagging", M = TRUE))
  csc3 = CostSensitiveClassifier(status ~ ., data = data.training.train,  control = Weka_control(`cost-matrix` = matrix(c(0, i, 1, 0), ncol = 2), W = "weka.classifiers.meta.RandomSubSpace", M = TRUE)) 
  csc4 = CostSensitiveClassifier(status ~ ., data = data.training.train,  control = Weka_control(`cost-matrix` = matrix(c(0, i, 1, 0), ncol = 2), W = "weka.classifiers.trees.RandomForest", M = TRUE))  
  csc5 = CostSensitiveClassifier(status ~ ., data = data.training.train,  control = Weka_control(`cost-matrix` = matrix(c(0, i, 1, 0), ncol = 2), W = "weka.classifiers.meta.LogitBoost", M = TRUE)) 
  
  y = data.training.validation$status
  yhat1= predict(csc1,newdata=data.training.validation)  
  csc1.res=rbind(csc1.res, myres(yhat1, y) )
  yhat2= predict(csc2,newdata=data.training.validation)  
  csc2.res=rbind(csc2.res, myres(yhat2, y) )
  yhat3= predict(csc3,newdata=data.training.validation)  
  csc3.res = rbind( csc3.res, myres(yhat3, y) )
  yhat4= predict(csc4,newdata=data.training.validation)  
  csc4.res = rbind(csc4.res, myres(yhat4, y) )
  yhat5= predict(csc5,newdata=data.training.validation)  
  csc5.res= rbind( csc5.res, myres(yhat5, y) )
} 


##########Cost Sensitive Analysis
opt1=1
opt2=1
opt3=1
opt4=1
opt5=1
speci.thresh=0.45
for (i in 1:12){
  if( (csc1.res[i,1]>=speci.thresh) &  (csc1.res[i+1,1]<speci.thresh) ) {
    opt1=i }
  if( (csc2.res[i,1]>=speci.thresh) &  (csc2.res[i+1,1]<speci.thresh) ) {
    opt2=i }
  if( (csc3.res[i,1]>=speci.thresh) &  (csc3.res[i+1,1]<speci.thresh) ) {
    opt3=i }
  if( (csc4.res[i,1]>=speci.thresh) &  (csc4.res[i+1,1]<speci.thresh) ) {
    opt4=i }
  if( (csc5.res[i,1]>=speci.thresh) &  (csc5.res[i+1,1]<speci.thresh) ) {
    opt5=i }
}

opt1<-cost[opt1]
opt2<-cost[opt2]
opt3<-cost[opt3]
opt4<-cost[opt4]
opt5<-cost[opt5]


csc1group.binge <- CostSensitiveClassifier(bingnow ~ ., data = binge.train.train,  control = Weka_control(`cost-matrix` =
                                                                                                            matrix(c(0,opt1, 1, 0), ncol = 2), W = "weka.classifiers.meta.RandomCommittee", M = TRUE)) 


csc2group.binge <- CostSensitiveClassifier(bingnow ~ ., data =binge.train.train, control = Weka_control(`cost-matrix` = 
                                                                                                          matrix(c(0, opt2, 1, 0), ncol = 2), W = "weka.classifiers.meta.Bagging", M = TRUE))


csc3group.binge <- CostSensitiveClassifier(bingnow ~ ., data = binge.train.train, control = Weka_control(`cost-matrix` = 
                                                                                                           matrix(c(0, opt3, 1, 0), ncol = 2), W = "weka.classifiers.meta.RandomSubSpace", M = TRUE)) 



csc4group.binge <- CostSensitiveClassifier(bingnow ~ ., data = binge.train.train, control = Weka_control(`cost-matrix` = 
                                                                                                           matrix(c(0, opt4, 1, 0), ncol = 2), W = "weka.classifiers.trees.RandomForest",M = TRUE))  



csc5group.binge <- CostSensitiveClassifier(bingnow ~ ., data = binge.train.train,  control = Weka_control(`cost-matrix` = 
                                                                                                            matrix(c(0, opt5, 1, 0), ncol = 2), W = "weka.classifiers.meta.LogitBoost", M = TRUE)) 

