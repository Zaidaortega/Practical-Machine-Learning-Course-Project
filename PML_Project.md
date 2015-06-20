---
title: "Practical Machine Learning - Course Project"
author: "Zaida Ortega"
date: "Saturday, June 20, 2015"
output: html_document
---

#Overview
Here we analyze data from accelerometers on the belt, forearm, arm, and dumbell. Training data is accelerometer data and a label identifying the quality of the activity the participant was doing. Testing data is accelerometer data without the identifying label. The goal is to make predictions about labels.

##Preparing data
###Loading packages:
```{r}
library(caret)
library(lattice)
library(ggplot2)
```

###Download training data from: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv
###Download test data from: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

###Preparing data:
```{r}
training <- read.csv2("./pml-training.csv", row.names = 1)
testing <- read.csv2("./pml-testing.csv", row.names = 1)
nsv <- nearZeroVar(training, saveMetrics = T)
training <- training[, !nsv$nzv]
nav <- sapply(colnames(training), function(x) if(sum(is.na(training[, x])) > 0.8*nrow(training)){return(T)}else{return(F)})
training <- training[, !nav]
```

###Fitting model with boosting:
####Fit model with boosting algorithm and 10-fold cross validation to predict classe with all other predictors.

```{r}
set.seed(123, training)
boostFit <- train(classe ~ ., method = "gbm", data = training, verbose = F, trControl = trainControl(method = "cv", number = 10))
boostFit
plot(boostFit, ylim = c(0.9, 1))
```
####Results show that the boosting algorithm generated a good model with accuracy = 0.997.

### Fitting model of random forest:
```{r}
set.seed(123)
rfFit <- train(classe ~ ., method = "rf", data = training, importance = T, trControl = trainControl(method = "cv", number = 10))
rfFit
plot(rfFit, ylim = c(0.9, 1))
imp <- varImp(rfFit)$importance
imp$max <- apply(imp, 1, max)
imp <- imp[order(imp$max, decreasing = T), ]
```

####The random forests algorithm is better even that the boosting model ,with an accuracy close to one.

###CHOSEN MODEL AND PREDICTIONS
####Random forests model has better accuracy, so it will be used to prediction.
####The final random forests model contains 500 trees with 40 variables tried at each split. The five most important predictors in this model are r rownames(imp)[1:5]. THE ESTIMATER OUT OF SAMPLE ERROR RATE FOR THIS RANDOM FOREST MODEL IS 0.004%, AS IT IS REPORTED IN THE FINAL MODEL.

```{r}
rfFit$finalModel
# prediction
(prediction <- as.character(predict(rfFit, testing)))
# write prediction files
pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("./prediction/problem_id_", i, ".txt")
    write.table(x[i], file = filename, quote = FALSE, row.names = FALSE, col.names = FALSE)
  }
}
pml_write_files(prediction)
```
