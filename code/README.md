---
title: "Human Activity Prediction"
author: "Stephen OConnell"
date: "September 20, 2014"
output: html_document
---

## Summary

This is a summary of the code files used during the analysis of the 
HAR data.

Program                     |  Description
--------------------------- | ------------------------------------------------------------------
final_model_comparison.R    | Reads the output from the 6 different models, compares the results and produces the final report.
model_submission.R          | Reads the final test cases and submits the results for scoring
modeling.R                  | Experiment with various settings to determine the trade off of elapsed time vs. model creation settings.
nnet_modeling.R             | Reads the raw data file, splits data, stratified on classe, using a common seed, builds a neural net model, and runs cross validation to determine model accuracy.             
pp_nnet_modeling.R          |
pp_rf_modeling.R            |
pp_svm_modeling.R           |
preprocessing_data.R        |
raw_data_modeling.R         |
rf_modeling.R               |
svm_modeling.R              |

This is the end of the README.md