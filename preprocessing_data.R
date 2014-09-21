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

raw.data <-data.frame(fread("data/pml-training.csv"))

#describe(raw.data)

## REMOVE THE NEW WINDOW ROWS
raw.data <- subset(raw.data, new_window == 'no')

## REMOVE THE DESCRIPTIVE COLUMNS
raw.data <- raw.data[,8:length(raw.data)]

## CREATE AN INDEX OF THE COLUMNS THAT ARE NOT 'NA'
good.col.indx <- !is.na(raw.data[1,])
raw.data <- raw.data[,good.col.indx]

## CREATE AN INDEX OF THE COLUMNS THAT ARE NOT ''
good.col.indx <- raw.data[1,] != ''
raw.data <- raw.data[,good.col.indx]

##-----------------------------------------------------------------------------
##          PRE-PROCESSING::  remove highly corrlated and near zero variance
##-----------------------------------------------------------------------------
str(raw.data)

###   NEAR ZERO -- THERE ARE NO NEAR ZERO OR ZERO VARIANCE
nzv <- nearZeroVar(raw.data, saveMetrics = TRUE)
nzv[nzv$nzv, ][1:10, ]

###   CORRELATION
descrCor <- cor(raw.data[,1:length(raw.data)-1])
summary(descrCor[upper.tri(descrCor)])

highlyCorDescr <- findCorrelation(descrCor, cutoff = 0.75)
raw.data <- raw.data[, -highlyCorDescr]
descrCor2 <- cor(raw.data[,1:length(raw.data)-1])
summary(descrCor2[upper.tri(descrCor2)])

describe(raw.data)


##-----------------------------------------------------------------------------
##      SAVE THE PRE-PROCESSED DATASET
##-----------------------------------------------------------------------------
save(raw.data, file="data/raw_data.Rdata")
