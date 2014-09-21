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


###--------------------------------------------------------------------
##      TRAINING CONTROL
## TRAINING ELAPSED TIMES
## FIRST PASS:

###--------------------------------------------------------------------
harControl <- trainControl(method = "repeatedcv",
                          number = 4,
                          ## repeated ten times
                          repeats = 3)

set.seed(825)

system.time(
pp.nnet.FIT <- train(classe ~ ., data = harTrain,
                 method = "nnet",
                 trControl = harControl,
                 verbose = FALSE)
)

save(pp.nnet.FIT, file="data/pp_nnet_FIT.Rdata")

pp.nnet_yHat <- predict(pp.nnet.FIT, harTest)

confusionMatrix(harTest$classe, pp.nnet_yHat)

plot(pp.nnet.FIT)

##---------------------------------------------------------
## FINAL
##---------------------------------------------------------

load(file="data/pp_test_transformed.Rdata")
FINAL.pp.nnet_yHat <- predict(pp.nnet.FIT, pp.test.transformed)

as.character(FINAL.pp.nnet_yHat)


