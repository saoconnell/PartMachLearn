---
title: "Human Activity Prediction"
author: "Stephen OConnell"
date: "September 20, 2014"
output: html_document
---

## Feature Selection and Modeling Programs

The following is a summary of the code files used during the analysis of the 
HAR data.

- The processing program creates the raw and pre-processed data sets

- There are 6 modeling progams, one for each algorythm and dataset combination

- A final model comparison program summarizes the perfomance of the models and runs prediction using the final test data set for grading submission.

Program                     |  Description
--------------------------- | ------------------------------------------------------------------
final_model_comparison.R    | Reads the output from the 6 different models, compares the results and produces the final report.
model_submission.R          | Reads the final test cases and submits the results for scoring
modeling.R                  | Experiment with various settings to determine the trade off of elapsed time vs. model creation settings.
nnet_modeling.R             | Reads the raw data set, splits data, stratified on classe, using a common seed, builds a neural net model, and runs cross validation to determine model accuracy.             
pp_nnet_modeling.R          | Reads the pre-processed data set, splits data, stratified on classe, using a common seed, builds a Neural Net model, and runs cross validation to determine model accuracy
pp_rf_modeling.R            | Reads the pre-processed data set, splits data, stratified on classe, using a common seed, builds a Random Forest model, and runs cross validation to determine model accuracy
pp_svm_modeling.R           | Reads the pre-processed data set, splits data, stratified on classe, using a common seed, builds a Support Vector Machine (SVM) model, and runs cross validation to determine model accuracy
preprocessing_data.R        | Feature selection and pre-processing to create two data sets for training and test, a raw data set and a pre-processed data set.  The raw data set (rd) has only the features selected with contributing data, and no transformations.  The pre-processed data set (pp) as further feature selection and feature transformations.
raw_data_modeling.R         | Experiment with the model building using the raw data file.
rf_modeling.R               | Reads the raw data set, splits data, stratified on classe, using a common seed, builds a Random Forest model, and runs cross validation to determine model accuracy
svm_modeling.R              | Reads the raw data set, splits data, stratified on classe, using a common seed, builds a Support Vector Machine model, and runs cross validation to determine model accuracy

