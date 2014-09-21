---
title: "Human Activity Prediction"
author: "Stephen OConnell"
date: "September 20, 2014"
output: html_document
---

## Summary

The following is a summary of the approach I used to create the final model for predicting the specific
activity in the test dataset.

The original experimental design, data collection, data pre-processing and analysis is documented on the following web page and in the following paper:

__HAR Projects Page:__

http://groupware.les.inf.puc-rio.br/har

__Qualitative Activity Recognition of Weight Lifting Exercises__

http://groupware.les.inf.puc-rio.br/work.jsf?p1=11201

##  Startegy

Before starting out the project I developed the following strategy for developing the final model.

1. During the data preprocessing I would create two datasets for building the models.  The first dataset
was just the raw data trimmed down to only the features that contributed information to the model.  The second
dataset was created by passing the first dataset through carets preprocessing function to perform the following
transformations:
  c('BoxCox', 'center', 'scale', 'pca')

2. Use three different algorithms to perform the classifications.  As this was a non-linear classification problem
I selected the following algorithms to compare.

-  nnet
-  rf
-  svmRadial

3. Create models for each algorithm with each of the data sets, so I would have 6 separate models to predict with.

4. Train the models with 70% training and 30% testing, and used 4 fold cross validation with 3 passes.  I decided
on this approach after an initial experiment with training a model with 10 fold, 10 times.  I realized the model
construction time would be too significant for the marginal increase in model performance.  

5. Compare the model performance using the confusionMatix to select the better performing model/dataset combination.

6. If there were differences, I would use the probabilities for each classification as the tie breaker.


## Preprocessing - Feature Selection

### Raw Data

My first pass at preprocessing the data was to eliminate the samples and features that did not contribute information
that could be used in the model building phase.

I first removed all the rows that had new_window = 'yes'.  I removed these as they are unique cases of transitioning between
exercises, which is not something that contribute information to the model.  These rows also have values in
features that are not consistent with the new_window = 'no'.

I then removed the first 7 columns from the dataset.  These columns contained either text, non-categorical data, and time series 
data, which are not useful in building a model to predict the activity.

-  V1
-  user_name
-  raw_timestamp_part_1
-  raw_timestamp_part_2
-  cvtd_timestamp
-  new_window
-  num_window

There were several columns (features) that were either "" or NA.  I removed the columns from the raw data as they were useless
predicting the activity.

To insure the remaining features were contributing unique information to the model, I looked for near zero/near zero variance features and features that were highly correlated.  The near zero evaluation did not find any features that could be eliminate based on this evaluation.  There were however features that were highly correlated.  I used .75 as the cutoff and removed the correlated variables.

After completing the above feature selection process I reduced the number of features from 159 to 32.  

I performed the same feature selection process on the test data set as well.

### Caret PreProcess Raw Data

To determined if additional preprocessing of the data would improve the results I decided to 
use the caret preProcess function on the data set created in the first pass.  

I choose an aggressive approach to see if these transformations would improve the model building process.

  __c('BoxCox', 'center', 'scale', 'pca')__

The resulting dataset was reduced from 32 features to 23 features.

I performed the same transformation on the test data set as well.


## Model Creation

I created a model for each algorithm/dataset combination, for a total of 6 different models:

__Naming Convention__

__Data Set__

- rd = raw data
- pp = preprocessed data

__Algorithm__

- rf = random forest
- nnet - neural net
- svm = support vector machine
<TABLE border=1>
<TR> <TH>  </TH> <TH> Accuracy </TH>  </TR>
  <TR> <TD align="right"> rd.rf </TD> <TD align="right"> 0.99 </TD> </TR>
  <TR> <TD align="right"> rd.nnet </TD> <TD align="right"> 0.43 </TD> </TR>
  <TR> <TD align="right"> rd.svm </TD> <TD align="right"> 0.92 </TD> </TR>
  <TR> <TD align="right"> pp.rf </TD> <TD align="right"> 0.97 </TD> </TR>
  <TR> <TD align="right"> pp.nnet </TD> <TD align="right"> 0.59 </TD> </TR>
  <TR> <TD align="right"> pp.svm </TD> <TD align="right"> 0.92 </TD> </TR>
   </TABLE>

__Observations__

The random forest with the raw data was the clear winner on accuracy.

An interesting comparison is the neural net difference in the raw data and the preprocessed data.  The preprocessed data brought the accuracy up 16%.  This is probably just a by-product of how nnet builds a model.  Several more nnet construction would be required to determine if the dataset was making the difference.

For svm the preprocessed dataset did not impact the performance of the model.

In all these cases, just building one model is not enough evidence that the data was really making a difference.  This would
require more experimentation to determine if the preprocessed data was an improvement or detriment to model performance.


## Results

For the final submission I went with random forest/raw data combination (rd.rf).  There is a difference for problem_num_3 between rd.rf and pp.rf.  I reviewed the probabilities for these two selections and there was as small difference, rd.rf .490 vs. pp.rf .494.  However, I used the rd.rf submission in its complete form.  I leaned on the overall performance of rd.rf in making this decision, since the probabilities were so close.

<!-- html table generated in R 3.1.0 by xtable 1.7-3 package -->
<!-- Sun Sep 21 15:26:38 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH>  1 </TH> <TH>  2 </TH> <TH>  3 </TH> <TH>  4 </TH> <TH>  5 </TH> <TH>  6 </TH> <TH>  7 </TH> <TH>  8 </TH> <TH>  9 </TH> <TH>  10 </TH> <TH>  11 </TH> <TH>  12 </TH> <TH>  13 </TH> <TH>  14 </TH> <TH>  15 </TH> <TH>  16 </TH> <TH>  17 </TH> <TH>  18 </TH> <TH>  19 </TH> <TH>  20 </TH>  </TR>
  <TR> <TD align="right"> rd.rf </TD> <TD> B </TD> <TD> A </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> E </TD> <TD> D </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> B </TD> <TD> C </TD> <TD> B </TD> <TD> A </TD> <TD> E </TD> <TD> E </TD> <TD> A </TD> <TD> B </TD> <TD> B </TD> <TD> B </TD> </TR>
  <TR> <TD align="right"> pp.rf </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> E </TD> <TD> D </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> B </TD> <TD> C </TD> <TD> B </TD> <TD> A </TD> <TD> E </TD> <TD> E </TD> <TD> A </TD> <TD> B </TD> <TD> B </TD> <TD> B </TD> </TR>
  <TR> <TD align="right"> rd.nnet </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> B </TD> <TD> C </TD> <TD> D </TD> <TD> D </TD> <TD> A </TD> <TD> A </TD> <TD> D </TD> <TD> C </TD> <TD> D </TD> <TD> A </TD> <TD> D </TD> <TD> E </TD> <TD> A </TD> <TD> B </TD> <TD> B </TD> <TD> E </TD> </TR>
  <TR> <TD align="right"> pp.nnet </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> E </TD> <TD> D </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> B </TD> <TD> C </TD> <TD> B </TD> <TD> A </TD> <TD> E </TD> <TD> E </TD> <TD> A </TD> <TD> B </TD> <TD> B </TD> <TD> B </TD> </TR>
  <TR> <TD align="right"> rd.svm </TD> <TD> B </TD> <TD> A </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> E </TD> <TD> D </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> B </TD> <TD> C </TD> <TD> B </TD> <TD> A </TD> <TD> E </TD> <TD> E </TD> <TD> A </TD> <TD> B </TD> <TD> B </TD> <TD> B </TD> </TR>
  <TR> <TD align="right"> pp.svm </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> E </TD> <TD> D </TD> <TD> B </TD> <TD> A </TD> <TD> A </TD> <TD> A </TD> <TD> C </TD> <TD> B </TD> <TD> A </TD> <TD> E </TD> <TD> E </TD> <TD> A </TD> <TD> B </TD> <TD> B </TD> <TD> B </TD> </TR>
   </TABLE>
