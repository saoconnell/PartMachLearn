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
##      PARTITION THE DATA TRAIN = 80%
###--------------------------------------------------------------------

load(file="data/raw_data.Rdata")

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
describe(harTest$classe)
describe(harTrain$classe)


###--------------------------------------------------------------------
##      TRAINING CONTROL
###--------------------------------------------------------------------
fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 10)

set.seed(825)
gbmFit1 <- train(classe ~ ., data = harTrain,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)
gbmFit1

