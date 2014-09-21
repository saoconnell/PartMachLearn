###---------------------------------------------------------------------------------
###  THE MODEL COMPARISON
###---------------------------------------------------------------------------------

###--------------------------------------------------------------------
###              LIBRARY
###--------------------------------------------------------------------

library(plyr)
library(caret)
library(dplyr)
library(data.table)
library(lattice)
library(latticeExtra)
library(Hmisc)


###--------------------------------------------------------------------
##      LOAD THE INDIVIDUAL MODELS
###--------------------------------------------------------------------


##  RAW DATA MODELS
load("data/rd_nnet_FIT.Rdata")
load("data/rd_rf_FIT.Rdata")
load("data/rd_svm_FIT.Rdata")


## PREPRECESSED MODELS
load("data/pp_nnet_FIT.Rdata")
load("data/pp_rf_FIT.Rdata")
load("data/pp_svm_FIT.Rdata")

###--------------------------------------------------------------------
##      PREDICT
###--------------------------------------------------------------------


results <- list()

##--------------------
##--------------------
## RAW DATA MODELS
##--------------------
##--------------------

###--------------------------------------------------------------------
##      PARTITION THE DATA TRAIN = 70%
###--------------------------------------------------------------------

load(file="data/train_raw_data.Rdata")

raw.data <- train.raw.data

## MAKE THE classe VARIABLE A FACTOR SO THE ALGORYTHMS WILL PERFORM CLASSIFICATION...
raw.data$classe <- as.factor(raw.data$classe)


set.seed(3456)

### I USED 70% MOSTLY TO REDUCE THE TRAINING TIME FOR SOME OF THE ALGORYTHMS
trainIndex <- createDataPartition(raw.data$classe, p = .7,
                                  list = FALSE,
                                  times = 1)

### CREATE THE TRAIN AND TEST SETS
harTrain <- raw.data[ trainIndex,]
harTest  <- raw.data[-trainIndex,]


### MAKE SURE THE THE SETS ARE STRATIFIED
describe(harTrain$classe)
describe(harTest$classe)


## RANDOM FOREST (rf)
rd.rf_yHat <- predict(rd.rf.FIT, harTest)
rd.rf.CM <- confusionMatrix(harTest$classe, rd.rf_yHat)
results["rd.rf"] <- rd.rf.CM$overall[1]


## NEURAL NET (nnet)
rd.nnet_yHat <- predict(rd.nnet.FIT, harTest)
rd.nnet.CM <- confusionMatrix(harTest$classe, rd.nnet_yHat)
results["rd.nnet"] <- rd.nnet.CM$overall[1]

## SUPPORT VECTOR MACHINCES (svm)
## NEURAL NET (nnet)
rd.svm_yHat <- predict(rd.svm.FIT, harTest)
rd.svm.CM <- confusionMatrix(harTest$classe, rd.svm_yHat)
results["rd.svm"] <- rd.svm.CM$overall[1]





##--------------------
##--------------------
## PREPROCESSED DATA
##--------------------
##--------------------

###--------------------------------------------------------------------
##      PARTITION THE DATA TRAIN = 70%
###--------------------------------------------------------------------

load(file="data/pp_train_transformed.Rdata")

raw.data <- pp.train.transformed

## MAKE THE classe VARIABLE A FACTOR SO THE ALGORYTHMS WILL PERFORM CLASSIFICATION...
raw.data$classe <- as.factor(raw.data$classe)


set.seed(3456)

### I USED 70% MOSTLY TO REDUCE THE TRAINING TIME FOR SOME OF THE ALGORYTHMS
trainIndex <- createDataPartition(raw.data$classe, p = .7,
                                  list = FALSE,
                                  times = 1)

### CREATE THE TRAIN AND TEST SETS
harTrain <- raw.data[ trainIndex,]
harTest  <- raw.data[-trainIndex,]


### MAKE SURE THE THE SETS ARE STRATIFIED
describe(harTrain$classe)
describe(harTest$classe)




## RANDOM FOREST (rf)
pp.rf_yHat <- predict(pp.rf.FIT, harTest)
pp.rf.CM <- confusionMatrix(harTest$classe, pp.rf_yHat)
results["pp.rf"] <- pp.rf.CM$overall[1]


## NEURAL NET (nnet)
pp.nnet_yHat <- predict(pp.nnet.FIT, harTest)
pp.nnet.CM <- confusionMatrix(harTest$classe, pp.nnet_yHat)
results["pp.nnet"] <- pp.nnet.CM$overall[1]

## SUPPORT VECTOR MACHINCES (svm)
## NEURAL NET (nnet)
pp.svm_yHat <- predict(pp.svm.FIT, harTest)
pp.svm.CM <- confusionMatrix(harTest$classe, pp.svm_yHat)
results["pp.svm"] <- pp.svm.CM$overall[1]


final_results <- data.frame(do.call('rbind', results))
names(final_results) <- 'Accuracy'

save(final_results, file="data/final_results.Rdata")


##--------------------------------------------------------------
## FINAL SUBMISSIONS
##--------------------------------------------------------------

submissions <- list()

load(file="data/test_raw_data.Rdata")
load(file="data/pp_test_transformed.Rdata")

## RANDOM FOREST
FINAL <- predict(rd.rf.FIT, test.raw.data)
submissions["rd.rf"] <- list(as.character(FINAL))
FINAL <- predict(pp.rf.FIT, pp.test.transformed)
submissions["pp.rf"] <- list(as.character(FINAL))


## Neural Nets nnet
FINAL <- predict(rd.nnet.FIT, test.raw.data)
submissions["rd.nnet"] <- list(as.character(FINAL))
FINAL <- predict(pp.rf.FIT, pp.test.transformed)
submissions["pp.nnet"] <- list(as.character(FINAL))

## SUPPORT VECTOR MACHINES
FINAL <- predict(rd.svm.FIT, test.raw.data)
submissions["rd.svm"] <- list(as.character(FINAL))
FINAL <- predict(pp.svm.FIT, pp.test.transformed)
submissions["pp.svm"] <- list(as.character(FINAL))


final_submission <- data.frame(do.call('rbind', submissions))
names(final_submission) <- sprintf("% d", seq(1:20))

save(final_submission, file="data/final_submission.Rdata")
