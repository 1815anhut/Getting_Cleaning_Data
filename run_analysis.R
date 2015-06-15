#############################################################################
##
## Corsera: Getting and Cleaning Data Course Project
##
## Author:    A Hutchison
## Created:   10 June 2015
## File name: run_analysis.R
## --------------------------------------------------------------------------
## Processing:
##
## Uses data from the "Human Activity Recognition Using Smartphones
## Data Set", as provided by the course team.
##
## This script:
## 1. Merges the test and training data sets into a single data frame.
## 2. Restricts the merged data set to the measurements of mean and standard
##    deviation.
## 3. Assigns meaningful activity names to the data rows.
## 4. Assigns meaningful variable names to the data columns.
## 5. Produces a second, tidy, data set containing the average value for each
##    variable over each activity and each subject.
##
#############################################################################

## =============================================================== INITIALISE

rm(list=ls())   # Clear the workspace

library(sqldf)
library(reshape2)

            # Move to directory containing the extracted source data.

work_dir <- "D:/Corsera/GettingData/UCI HAR Dataset"
setwd(work_dir)

## Step 1. =================================  READ IN RAW DATA AND MERGE SETS
##            File structures are described in the codebook.md file

              # Import "test" data set: combine subject id,
              # activity id and data into 1 frame.

test_sub      <- read.table("./test/subject_test.txt" )  # subject ID
test_act      <- read.table("./test/Y_test.txt")         # activity codes
test_data     <- read.table("./test/X_test.txt")         # test data set

test_set      <- cbind(test_sub, test_act, test_data)

              # Import "training" data set: combine subject id,
              # activity id and data into 1 frame

train_sub     <- read.table("./train/subject_train.txt")  # subject ID
train_act     <- read.table("./train/Y_train.txt")        # activity codes
train_data    <- read.table("./train/X_train.txt")        # training data set

train_set     <- cbind(train_sub, train_act, train_data)

              # Combine test and training data sets into a single, tidy, set.
              # The data has one data variable per column, and each row is
              # an observation for a given subject doing a given activity.

combined_set  <- rbind(test_set, train_set)

rm(test_sub, test_act, test_data, test_set,tempry)       # tidy up workspace
rm(train_sub,train_act,train_data,train_set)

## Step 2. ==================================== LIMIT TO MEAN AND STD COLUMNS
##            Want to retain only those columns giving means and standard
##            deviations: these columns have names "mean()" and "std()"
##            respectively.

              # Read in the dataset column names, convert name texts into
              # a vector, and prefix with the subject and activity column names.

tempry        <- read.table("features.txt", stringsAsFactors = FALSE)
feature_list  <- tempry[,2]
feature_list  <- c("subject_id","act_id", feature_list)
rm(tempry)

              # Produce logical vector where TRUE = column is a valid mean
              # or std dev column.

validcols     <- ( grepl("std()",        feature_list, ignore.case=TRUE) |
                   grepl("mean()",       feature_list, ignore.case=TRUE) )  &
                  !grepl("meanfreq",     feature_list, ignore.case=TRUE)    &
                  !grepl("mean,",        feature_list, ignore.case=TRUE)    &
                  !grepl("gravitymean",  feature_list, ignore.case=TRUE)

validcols[1:2] <- c(TRUE,TRUE)  # Force inclusion of subject id and activity

              # Set column names and select only the required columns.

colnames(combined_set) <- feature_list
analysis_set           <- combined_set[,validcols]

## Step 3. ====================================== SET MEANINGFUL ACTIVITY NAMES

              # Read in the activity labels, set column names

activity_lab           <- read.table("activity_labels.txt")
colnames(activity_lab) <- c("act_id","activity")

              # Add a column "activity" to the analysis_set for the text,
              # activity names and set its values depending on the activity code.

sqlstr        <- "select activity_lab.activity, analysis_set.*
                  from analysis_set inner join activity_lab
                  on analysis_set.act_id = activity_lab.act_id"

analysis_set  <- sqldf(sqlstr, stringsAsFactors=FALSE)

## Step 4. ====================================== SET MEANINGFUL COLUMN NAMES
##            Tidy up column names to make them a bit more informative.

feature_list  <- colnames(analysis_set)                # Refresh the column name list
feature_list  <- gsub("\\()", "",      feature_list)   # Remove ()
feature_list  <- gsub("-",    "_",     feature_list)   # Replace hyphen with underscore
feature_list  <- gsub("^(f)", "Freq_", feature_list)   # Replace prefix "f" with "Freq_"
feature_list  <- gsub("^(t)", "Time_", feature_list)   # Replace prefix "f" with "Time_"
colnames(analysis_set) <- feature_list                 # Replace with updated names

## Step 5. ======================================= PRODUCE NEW "AVERAGE" DATA SET

              # Convert the data to "long" format, retaining the subject_id and
              # activity text name as identifiers. The numeric activity code
              # "act_id" is removed from the dataset, just leaving the activity texts.

analysis_long <- melt(analysis_set, id=c("subject_id","activity"),
                      measure.vars=feature_list[-c(1,2,3)] )

              # Calculate the mean of all variables over each subject/activity
              # combination, and cast back into "wide" format. This makes a
              # "tidy" dataset with one row for each subject/activity combination
              # and one column for the mean of each data variable.

new_data      <- dcast(analysis_long, activity + subject_id ~ variable, mean)

              # Export the average data set.

write.table(new_data, file="Average_Data.txt", row.name=FALSE)

