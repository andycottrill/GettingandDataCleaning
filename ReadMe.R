###  This is a ReadMe file

# The data for this assignment is from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Loaded into a folder called Dataset_data

# An R script called run_analysis.R was used to to explore, investigate and change the data so that a tidy data file 
# could be made at the end. 

# A summary of the run_analysis.R is shown here.
# DownLoad and unzip the data and explore subject and activity data using R 
# Read the README file which was downloaded and describes the dataset

# Read in the test and training datasets and look at the data
# Check the activity and label information in two files activity_labels.txt and features.txt

# Search for the column names with mean and standard deviation (std) so only columns with mean and standard deviation are extracted
# Reload the two datasets X_test.txt and X_train.txt

# Merge the training and the test sets using cbind to create two datasets from six files 
# Merge the training and test datasets using rbind forming one file

# Rename the column names from V1 to V552 with descriptive variable names

# Change numbers from 1 to 6 in the second column to descriptive activity labels

# Tidy the data like the mtcars example, load the reshape2 package to reshape the data  
# Make a tidy data set with the average of each variable for each activity and each subject.
# This tidy data set is called tidydata.txt

# Write this new file to a text file called tidydata.txt

# A Codebook.md lists the variables in the new tidy dataset 'tidydata.txt' which is made at the end of the run_analysis.R script.

# The ReadMe file provides a summary of the files used in this assignment (this file)

