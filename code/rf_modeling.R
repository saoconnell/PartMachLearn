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
##       user  system elapsed 
##     931.13    5.95  939.81 
##
###--------------------------------------------------------------------
harControl <- trainControl(method = "repeatedcv",
                          number = 4,
                          ## repeated ten times
                          repeats = 3)

set.seed(825)

system.time(
rd.rf.FIT <- train(classe ~ ., data = harTrain,
                 method = "rf",
                 trControl = harControl,
                 verbose = FALSE)
)

save(rd.rf.FIT, file="data/rd_rf_FIT.Rdata")

rd.rf_yHat <- predict(rd.rf.FIT, harTest)

confusionMatrix(harTest$classe, rd.rf_yHat)

plot(rd.rf.FIT)

##---------------------------------------------------------
## FINAL
##---------------------------------------------------------

load(file="data/test_raw_data.Rdata")
FINAL.rd.rf_yHat <- predict(rd.rf.FIT, test.raw.data)

as.character(FINAL.rd.rf_yHat)
