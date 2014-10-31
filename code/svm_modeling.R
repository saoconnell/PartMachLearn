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


###--------------------------------------------------------------------
##      TRAINING CONTROL
## TIMING:
##   FIRST PASS:
##      user  system elapsed 
##    955.40   39.84  996.52 
###--------------------------------------------------------------------
harControl <- trainControl(method = "repeatedcv",
                          number = 4,
                          ## repeated ten times
                          repeats = 3)

set.seed(825)

system.time(
rd.svm.FIT <- train(classe ~ ., data = harTrain,
                 method = "svmRadial",
                 trControl = harControl,
                 verbose = TRUE)
)

save(rd.svm.FIT, file="data/rd_svm_FIT.Rdata")

rd.svm_yHat <- predict(rd.svm.FIT, harTest)

confusionMatrix(harTest$classe, rd.svm_yHat)

plot(rd.svm.FIT)

##---------------------------------------------------------
## FINAL
##---------------------------------------------------------

load(file="data/test_raw_data.Rdata")
FINAL.rd.svm_yHat <- predict(rd.svm.FIT, test.raw.data)

as.character(FINAL.rd.svm_yHat)


