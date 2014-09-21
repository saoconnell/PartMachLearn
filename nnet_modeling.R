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
## TRAINING ELAPSED TIMES
## FIRST PASS:
##     user  system elapsed 
##   421.98    0.66  428.69 
###--------------------------------------------------------------------
harControl <- trainControl(method = "repeatedcv",
                          number = 4,
                          ## repeated ten times
                          repeats = 3)

set.seed(825)

system.time(
rd.nnet.FIT <- train(classe ~ ., data = harTrain,
                 method = "nnet",
                 trControl = harControl,
                 verbose = FALSE)
)

save(rd.nnet.FIT, file="data/rd_nnet_FIT.Rdata")

nnet_yHat <- predict(rd.nnet.FIT, harTest)

confusionMatrix(harTest$classe, nnet_yHat)

plot(rd.nnet.FIT)

##---------------------------------------------------------
## FINAL
##---------------------------------------------------------

load(file="data/pp_test_transformed.Rdata")
FINAL.rd.nnet_yHat <- predict(rd.nnet.FIT, test.raw.data)
dim(harTrain)

as.character(FINAL.rd.nnet_yHat)


FINAL.rd.nnet_yHat <- predict(rd.nnet.FIT, test.raw.data, type="prob")
heatmap(as.matrix(FINAL.rd.nnet_yHat))
