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

set.seed(3456)
trainIndex <- createDataPartition(raw.data$classe, p = .8,
                                  list = FALSE,
                                  times = 1)
head(trainIndex)

harTrain <- raw.data[ trainIndex,]
harTest  <- raw.data[-trainIndex,]

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