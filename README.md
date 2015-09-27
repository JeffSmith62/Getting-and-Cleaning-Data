# Getting-and-Cleaning-Data
*******************************************************************
Coursera Data Science Specialization
Getting and Cleaning Data
Course Project – creating Tidy Data Set from Smartphones Dataset
9/27/2015
*******************************************************************
The objective of the project is to transform data gathered from smartphones into a tidy data set.  A single ZIP file downloaded and and 8 data files are loaded into R and a subset of tidy data is written.   The final data set only contains variables for Standard Deviation and Mean The script preforming the analysis is called run_analysis.R

******************************************************************
Packages
******************************************************************
The final script requires the dplyr and plyr packages

******************************************************************
Load Data Files
******************************************************************
A single ZIP file is downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This file contains 8 files that are loaded into R.  The data was separated into Test and Train sets.  Both sets have the same structure.  Test contains 29% of the data and Train contains 71%.  The data in both sets (test and train) makes up a complete data set. The files are descriptions are:

X_test.txt/X_train.txt – actual data sets.  One column for each variable.  561 variables.
y_test.txt/y_test.txt – contains the “activity” for each row in the data sets
subject_test.txt/subject_train.txt – has the “subject” or participant for each row of the data sets
activity_labels.txt -  text labels for the activity in the y_test.txt/y_test.txt files
features.txt – text labels of the variables.  561 rows.

The relationships of the tables are as follows (replace “test” with “train”): 
activity_labels > y_test > X_test < subject

Features.txt matches to the columns in X_test.

The data sets are loaded into the following data frames:

X_test.txt/X_train.txt – tstx/trnx
y_test.txt/y_train.txt – tsty/trny
subject_test.txt/subject_train.txt – tsts/trns
activity_labels.txt  - al
features.txt – feat


******************************************************************
Prepare data to be combined
******************************************************************
The Test and Train data needs to be combined to form a complete dataset.  However, this needs to be done after the Test/Train data has been merged together to maintain data integrity.  

All of the columns in the loaded data have generic column names such as V1, V2, V3.  The column names need to be changed to unique names.  Columns with the same names in different data frames contain the same data and can be combined or used to merge the data.  The columns in the data frames are:

al – activity_id, activity
feat – varID(“V” concatentated with the Index Column), varname
tsts/trns – subject
tsty/trny - activity_id
tstx/trnx – unchanged, V1:V561

The data frame “featlist” is a subset of the data frame feat is created which includes only rows with varnames containing std(), mean(), and meanfreq().

******************************************************************
Build Tidy Data Sets
******************************************************************
The Test data frames tsts (subject), tsty (activity), and the tstx (data) are combined into a single data frame.  This process only brings in the columns from tstx that match the featlist.  Process is repeated for the Train data frames.  The data is merged with the al data frame containing the Activity Labels and then the Test and Train data is combined into a single data set.  The combined data frame has 10,299 rows with 82 columns, 79 of which are variables

The combined data set is melted, with the variables columns flipped to rows – the resulting data frame has 4 columns and 813,621 rows or 10,299 rows* 79 columns.  A final complete data frame is created that appends the Activity labels from the feat data frame based on the activity_id.

The indtidy data frame is created that contains an independent tidy data set is created that averages the values for each Subject, Activity and Variable.  The contents of this data frame is written to ./data/indtidy.txt.





