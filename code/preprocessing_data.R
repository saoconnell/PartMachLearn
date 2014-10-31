###--------------------------------------------------------------------
###              LIBRARY
###--------------------------------------------------------------------

library(caret)
library(dplyr)
library(data.table)
library(lattice)
library(latticeExtra)
library(Hmisc)

###--------------------------------------------------------------------
##             PRE-PROCESSING::  Clear out non-data columns 
###--------------------------------------------------------------------

###  READ IN THE RAW DATA FOR TRAIN AND TEST
train.raw.data <-data.frame(fread("data/pml-training.csv"))

test.raw.data <-data.frame(fread("data/pml-testing.csv"))



#describe(raw.data)

## REMOVE THE NEW WINDOW ROWS
train.raw.data <- subset(train.raw.data, new_window == 'no')
test.raw.data <- subset(test.raw.data, new_window == 'no')

## REMOVE THE DESCRIPTIVE COLUMNS
train.raw.data <- train.raw.data[,8:length(train.raw.data)]
test.raw.data <- test.raw.data[,8:length(test.raw.data)]

## CREATE AN INDEX OF THE COLUMNS THAT ARE NOT 'NA'
good.col.indx <- !is.na(train.raw.data[1,])
train.raw.data <- train.raw.data[,good.col.indx]
test.raw.data <- test.raw.data[,good.col.indx]



## CREATE AN INDEX OF THE COLUMNS THAT ARE NOT ''
good.col.indx <- train.raw.data[1,] != ''
train.raw.data <- train.raw.data[,good.col.indx]
test.raw.data <- test.raw.data[,good.col.indx]

##-----------------------------------------------------------------------------
##          PRE-PROCESSING::  remove highly corrlated and near zero variance
##-----------------------------------------------------------------------------
str(train.raw.data)
str(test.raw.data)

###   NEAR ZERO -- THERE ARE NO NEAR ZERO OR ZERO VARIANCE
nzv <- nearZeroVar(train.raw.data[,1:length(train.raw.data)-1], saveMetrics = TRUE)
nzv[1:10, ]

###   CORRELATION CREATE THE CORRELATION MATRIX
descrCor <- cor(train.raw.data[,1:length(train.raw.data)-1])

###   CHECK THE DISTRIBUTION OF CORRELATIONS, THERE ARE HIGHLY CORRELATED VALUES
describe(descrCor[upper.tri(descrCor)])

###  REMOVED THE HIGHLY CORRELATED COLUMNS WITH CORRELATION OF .75 OR GREATER
highlyCorDescr <- findCorrelation(descrCor, cutoff = 0.75)
train.raw.data <- train.raw.data[, -highlyCorDescr]
test.raw.data <- test.raw.data[, -highlyCorDescr]

descrCor2 <- cor(train.raw.data[,1:length(train.raw.data)-1])
describe(descrCor2[upper.tri(descrCor2)])

describe(raw.data)

str(train.raw.data)
str(test.raw.data)
##-----------------------------------------------------------------------------
##      SAVE THE PRE-PROCESSED DATASET
##-----------------------------------------------------------------------------
save(train.raw.data, file="data/train_raw_data.Rdata")
save(test.raw.data, file="data/test_raw_data.Rdata")


##-----------------------------------------------------------------------------
##      PCA
##-----------------------------------------------------------------------------

###  READ IN THE RAW DATA FOR TRAIN AND TEST
pp.train.raw.data <- train.raw.data

pp.test.raw.data  <- test.raw.data


### PREPROCESS USING THE caret preProc FUNCTION
trans <- preProcess(pp.train.raw.data[,1:length(pp.train.raw.data)-1], 
                    method = c('BoxCox', 'center', 'scale', 'pca'))

pp.train.transformed <- predict(trans, pp.train.raw.data[,1:length(pp.train.raw.data)-1])
pp.test.transformed <- predict(trans, pp.test.raw.data[,1:length(pp.test.raw.data)-1])

pp.train.transformed$classe <- pp.train.raw.data$classe
pp.test.transformed$problem_id <- pp.test.raw.data$problem_id


##-----------------------------------------------------------------------------
##      SAVE THE PRE-PROCESSED DATASET
##-----------------------------------------------------------------------------
save(pp.train.transformed, file="data/pp_train_transformed.Rdata")
save(pp.test.transformed, file="data/pp_test_transformed.Rdata")
