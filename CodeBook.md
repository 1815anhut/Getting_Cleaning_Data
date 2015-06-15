### Getting and cleaning data: Course project

Author:  A Hutchison  
Created: 10 June 2015  
File:    CodeBook.md  

___
# Codebook

This file describes the data structure and processing needed to carry out the course project for the Corsera course "Getting and Cleaning Data", provided by John Hopkins University.

___
### Source Data

This analysis uses data from the *Human Activity Recognition Using Smartphones Data Set*, available from  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones[1].

The data is smartphone (Samsung Galaxy S II) accelerator and gyroscope readings taken from 30 subjects aged between 19 and 48 years during six *activities*: walking, walking_upstairs, walking_downstairs, sitting, standing and lying.

The specific data set provided by the course team for the project is available as a compressed archive file from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

**Source data file structures**

All the source data files are text files without header rows and without row labels. The data is partitioned into two, identically structured sets, *test* and *training*. The project merges these into a single dataset.

Six of the files in the given archive file are relevant to this project:

`1. subject_test.txt    Numeric subject identifier for test subjects`
`2. Y_test.txt          Numeric activity code for test subjects`
`3. Y_test.txt          Data for test subjects: 561 element numeric vector `
`4. subject_train.txt   Numeric subject identifier for training subjects`
`5. Y_train.txt         Numeric activity code for training subjects`
`6. Y_train.txt         Data for training subjects: 561 element numeric vector`

### Prerequisites

To run the *run_analysis.R* script you will need to have R-console or R-Studio on your computer, with the packages "sqldf" and "reshape2" installed.

The script assumes that no changes have been made to the directory structure of the source data archive file provided by the course team.  The path to the top data directory is hard-coded into the R script file at line 34: this will need to be changed to point to your "UCI HAR Dataset" directory.

___

### Processing summary

The *run_analysis.R* script:  

1.  Step 1: **Merge data sets**: 
  - Read  the 3 "test" data files (the raw data, the subject labels and the activity labels) into data tables, and combine them into a single data table using cbind.
  -  Read  the 3 "training" data files (the raw data, the subject labels and the activity labels) into data tables, and combine them into a single data table cbind.
  - Combine  the test and training data tables using rbind into a single table called *combined_set*. 
2. Step 2: **Limit data to mean and standard deviation columns:**
  - Read in the variable names from *features.txt* and convert the text names into a vector.
  - Use grepl to produce a logical vector set to TRUE for only those columns where the variable names contains "mean()" or "std()".
  - Ensure the subject ID and activity columns are included by setting columns 1 and 2 to TRUE in the logical vector.
  - Subset *combined_set**, retaining only the columns flagged in the logical vector. This produces a new data table called *analysis_set* containing only the wanted columns.
3. Step 3: **Set meaningful activity names:** 
  - Read the activity names from *activity_labels.txt* into a data table and set meaningful column names.
  - Use the *sqldf* function (from the package of the same name) to link the activity name data table to *analysis_set* on the numeric activity code, and create a new data table holding all the columns from the restricted data table and the activity name from the activity table.
4. Step 4: **Set meaningful column names:**
  - Recreate the *feature_list* vector of column names from *analysis_set* to ensure the values are up-to-date.
  - Apply the "grub" function to the name vector to tidy up the names: remove "()", replace the prefixes "f" and "t" with "Time" and "Freq" respectively, and replace hyphens with underscores.  
  - Reset *analysis_set* column names from the revised name vector. The resulting names are still quite cryptic, for example with "Acc" for accelerometer readings, but it was felt that expanding such abbreviations would result in impractically long variable names.
5. Step 5: **Create new "average value" data set:**
  - Change the *analysis_set* data table from wide to long format using the "melt" function, making the data frame *analysis_long*. The "subject_id" and "activity" (text activity name) are given as ID columns and preserved in the long-format data. The remaining variable names and their values form the other two columns of the "long" data.  Note that the numeric version of the activity code is discarded, as it effectively duplicates the text name.
  - Using the "dcast" function calculate the mean value of each variable by subject_id and by activity, storing the result in the data frame *new_data*. dcast produces a wide-format "tidy" data frame where each column stores the mean of a given mean or standard-deviation variable from the *analysis_set* data, and each row is an observation of one patient carrying out one activity. The resulting table has 180 rows and 68 columns.
  - The *new_data* frame is exported as a comma-separated text file (*Average_Data.txt*).

### Data dictionary

```
--------------------------------------------------------------------------------------------------------
Col| Variable                     | Type  | Desc.
--------------------------------------------------------------------------------------------------------
1  | activity                     | Factor| 6 levels: 1=WALKING, 2=WALKING_UPSTAIRS, 3=WALKING_DOWNSTAIRS, 
2  |                              |       | 4=SITTING,  5=STANDING 6=LAYING
3  | subject_id                   | int   | Subject identifier, integer values 1=30
4  | Time_BodyAcc_mean_X          | float | 
5  | Time_BodyAcc_mean_Y          | float | 
6  | Time_BodyAcc_mean_Z          | float | 
7  | Time_BodyAcc_std_X           | float | 
8  | Time_BodyAcc_std_Y           | float | .. A key to the interpretation of variable names
9  | Time_BodyAcc_std_Z           | float | .. is given below this table
10 | Time_GravityAcc_mean_X       | float | 
11 | Time_GravityAcc_mean_Y       | float | 
12 | Time_GravityAcc_mean_Z       | float | 
13 | Time_GravityAcc_std_X        | float | 
14 | Time_GravityAcc_std_Y        | float | 
15 | Time_GravityAcc_std_Z        | float | 
16 | Time_BodyAccJerk_mean_X      | float | 
17 | Time_BodyAccJerk_mean_Y      | float | 
18 | Time_BodyAccJerk_mean_Z      | float | 
19 | Time_BodyAccJerk_std_X       | float | 
20 | Time_BodyAccJerk_std_Y       | float | 
21 | Time_BodyAccJerk_std_Z       | float | 
22 | Time_BodyGyro_mean_X         | float | 
23 | Time_BodyGyro_mean_Y         | float | 
24 | Time_BodyGyro_mean_Z         | float | 
25 | Time_BodyGyro_std_X          | float | 
26 | Time_BodyGyro_std_Y          | float | 
27 | Time_BodyGyro_std_Z          | float | 
28 | Time_BodyGyroJerk_mean_X     | float | 
29 | Time_BodyGyroJerk_mean_Y     | float | 
30 | Time_BodyGyroJerk_mean_Z     | float | 
31 | Time_BodyGyroJerk_std_X      | float | 
32 | Time_BodyGyroJerk_std_Y      | float | 
33 | Time_BodyGyroJerk_std_Z      | float | 
34 | Time_BodyAccMag_mean         | float | 
35 | Time_BodyAccMag_std          | float | 
36 | Time_GravityAccMag_mean      | float | 
37 | Time_GravityAccMag_std       | float | 
38 | Time_BodyAccJerkMag_mean     | float | 
39 | Time_BodyAccJerkMag_std      | float | 
40 | Time_BodyGyroMag_mean        | float | 
41 | Time_BodyGyroMag_std         | float | 
42 | Time_BodyGyroJerkMag_mean    | float | 
43 | Time_BodyGyroJerkMag_std     | float | 
44 | Freq_BodyAcc_mean_X          | float | 
45 | Freq_BodyAcc_mean_Y          | float | 
46 | Freq_BodyAcc_mean_Z          | float | 
47 | Freq_BodyAcc_std_X           | float | 
48 | Freq_BodyAcc_std_Y           | float | 
49 | Freq_BodyAcc_std_Z           | float | 
50 | Freq_BodyAccJerk_mean_X      | float | 
51 | Freq_BodyAccJerk_mean_Y      | float | 
52 | Freq_BodyAccJerk_mean_Z      | float | 
53 | Freq_BodyAccJerk_std_X       | float | 
54 | Freq_BodyAccJerk_std_Y       | float | 
55 | Freq_BodyAccJerk_std_Z       | float | 
56 | Freq_BodyGyro_mean_X         | float | 
57 | Freq_BodyGyro_mean_Y         | float | 
58 | Freq_BodyGyro_mean_Z         | float | 
59 | Freq_BodyGyro_std_X          | float | 
60 | Freq_BodyGyro_std_Y          | float | 
61 | Freq_BodyGyro_std_Z          | float | 
62 | Freq_BodyAccMag_mean         | float | 
63 | Freq_BodyAccMag_std          | float | 
64 | Freq_BodyBodyAccJerkMag_mean | float | 
65 | Freq_BodyBodyAccJerkMag_std  | float | 
66 | Freq_BodyBodyGyroMag_mean    | float | 
67 | Freq_BodyBodyGyroMag_std     | float | 
68 | Freq_BodyBodyGyroJerkMag_mean| float | 
69 | Freq_BodyBodyGyroJerkMag_std | float | 
--------------------------------------------------------------------------------------------------------

Interpretation of variable names:  
Freq    - frequency domain  
Time    - time domain  
Acc     - accelerometer measurement  
Gyro    - gyroscope measurement  
X,Y,Z   - measurement in the X, Y or Z spatial dimension respectively 
Mag     - signal magnitude 
Body    - Measurement refers to subject body  
Gravity - Measurement adjusted for effect of gravity 
Jerk    - "Jerk" signal derived w.r.t. time from accelartion and angular momentum signals
mean    - source data was mean variable 
sd      - source data was standard deviation variable
-------------------------------------------------------------------------------------------------------

```


___

### Reference

1. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.]

