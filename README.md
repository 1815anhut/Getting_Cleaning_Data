
## Getting and cleaning data: Course project

Author:  A Hutchison  
Created: 10 June 2015  
File:    Readme.md  

### Source Data

This analysis uses data from the *Human Activity Recognition Using Smartphones Data Set*, supplied by the course team.  Futher information on the data is available from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones[1].

The data comprise accelerometer and gyroscope readings from 30 volunteers during each of 6 activities: walking, walking updstairs, walking downstairs, sitting, standing and laying. Data was collected using Samsung Galaxy S II 'phones. Subjects were randomly partitioned into "test" and "training" groups.

### Repository Files

This repository contains the following files:

- run_analysis.R
- CodeBook.md
- README.md (this file)

*run_analysis.R* is an R script to carry out the processing for the course project: in summary it: 

1. Merges the test and training data sets into a single data frame.
2. Restricts the merged data set to the measurements of mean and standard deviation.
3. Assigns meaningful activity names to the data rows.
4. Assigns meaningful variable names to the data columns.
5. Produces a second, tidy, data set containing the average value for each variable over each activity and each subject.

*CodeBook.md* describes the data and processing used to extract the required information from the raw data and produce the data set containing average values (*Average_Data.txt*). It also gives a data dictionary for the derived data set.

#### Reference

1. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.]

