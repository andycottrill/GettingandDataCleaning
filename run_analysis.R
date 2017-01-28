####  R file 
####  Week 4 Assignment for Data Cleaning and Data Analysis
####  Some Prerequisites:

rm(list=ls())                                       # clean up data environment in R 
getwd()
setwd("C:/Users/default.TOSHIBA/Desktop/Coursera")  # set local directory

#### Locate the data, and download to local drive:
dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataset_url, "Dataset.zip")   # download the data
unzip("Dataset.zip", exdir = "Dataset_data")   # Unzip the files and save to local folder called Dataset_data 


#### Reading the README with the downloaded data files tells us:
# There are six descriptive activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
# There are 30 people or subjects (30 IDs) used for the experiment.
# There are TWO main datasets: the test and training datasets.
# we dont need to use the Inertial folder files (notes online by 'thoughtfulbloke aka David Hood')


####   Lets READ some of the data from the test and training datasets:
# Note -----Dont use read.csv to read the files as there are multiple columns of data with blank spaces in X_test and X_train
# and there are no headers or variable names. 

## Test dataset  
subject_test <- read.table("Dataset_data/UCI HAR Dataset/test/subject_test.txt")   # subjects or number of people
X_test <- read.table("Dataset_data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("Dataset_data/UCI HAR Dataset/test/y_test.txt")               # numbers range from 1 to 6 activity

## Training dataset   
subject_train <- read.table("Dataset_data/UCI HAR Dataset/train/subject_train.txt") # subjects or number of people
X_train <- read.table("Dataset_data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("Dataset_data/UCI HAR Dataset/train/y_train.txt")             # numbers range from 1 to 6 activity

## Look at the data:
head(subject_test)  # 1 column of data 
tail(subject_test)
dim(subject_test)   # 2947 obs with 1 variable
head(X_train)       # Shows there is 561 variables  
tail(X_train)
dim(X_train)        # 561 variables with 7352 obs

## So there are two files with 561 variables X_test and X_train
## The other 4 files only have one variable.

### Check the activity and label information in the two following files:
activityLabels <- read.table("C:/Users/default.TOSHIBA/Desktop/Coursera/Dataset_data/UCI HAR Dataset/activity_labels.txt")
activityLabels     # Shows six activities as shown in README file
dim(activityLabels)
str(activityLabels)

activityLabels[,2] <- as.character(activityLabels[,2])   # Select second column with activities names.

featureLabels <- read.table("C:/Users/default.TOSHIBA/Desktop/Coursera/Dataset_data/UCI HAR Dataset/features.txt")
featureLabels    # Shows 561 names for the labels ....
                 # This confirms there is the same number of variables shown above in X_train and X_test datasets.

featureLabels[,2] <- as.character(featureLabels[,2]) # Select second column with features labels.

#### Now we can use this file featureLabels[,2] to search only for the column names with mean and standard deviation (std) 
featuresmeanstd <- grep(".*mean.*|.*std.*", featureLabels[,2])  # Choose only names with mean OR std in them
featuresmeanstd.names <- featureLabels[featuresmeanstd,2]       # there are 79 features with mean or std
featuresmeanstd.names                                           # lists 79 names from featureLabels table

###Reload the two datasets:
X_testmeanstd <- read.table("Dataset_data/UCI HAR Dataset/test/X_test.txt")[featuresmeanstd]
X_trainmeanstd <- read.table("Dataset_data/UCI HAR Dataset/train/X_train.txt")[featuresmeanstd]


### As Instructed in Assignment (1.notes), merge the training and test sets to create one dataset (but only with mean and std)
combinetest <- cbind(subject_test,y_test,X_testmeanstd)      # Add the files together by columns for test dataset   
combinetrain <- cbind(subject_train,y_train,X_trainmeanstd)  # Add the files together by columns for training dataset

### Merge the test and training datasets by row;
combinedtesttrain <- rbind(combinetest,combinetrain)
head(combinedtesttrain)
tail(combinedtesttrain)
dim(combinedtesttrain)    ##10299 obs and 81 variables (variables)

#### Rename the column names from V1 to V552 with descriptive variable names
colnames(combinedtesttrain) <- c("subject", "activity", featuresmeanstd.names)
colnames(combinedtesttrain)                                # shows the new 81 column names which we want

#### Now we want to change the numbers of 1 to 6 in the second column to descriptive activity labels
combinedtesttrain$activity <- factor(combinedtesttrain$activity,levels = activityLabels[,1], labels = activityLabels[,2])
head(combinedtesttrain)   # activity now has WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING 
tail(combinedtesttrain)
dim(combinedtesttrain)

str(combinedtesttrain)    # subject is currently an integer   - change to factor as well.

combinedtesttrain$subject <- as.factor(combinedtesttrain$subject)
str(combinedtesttrain)    # now shows subject with 30 levels 

#### Need to tidy the data like the mtcars example, load the reshape2 package to reshape data  
#### Make a tidy data set with the average of each variable for each activity and each subject.

library(reshape2)   
combinedtesttrainmelted <- melt(combinedtesttrain, id = c("subject", "activity"))   # now have 813621 obs and 4 variables
head(combinedtesttrainmelted)   # 4 variables in long list

combinedtesttrainMean <- dcast(combinedtesttrainmelted, subject + activity ~ variable, mean)  # 180 obs with 81 variables
head(combinedtesttrainMean)     # subject 1 and their activities
tail(combinedtesttrainMean)     # subject 30 and their activities

#### Write to a new file called 'tidydata' 
#### which shows the average of each variable for each activity and subject
write.table(combinedtesttrainMean, "tidydata.txt", row.names = TRUE, quote = FALSE)
tidydata <- read.table("tidydata.txt")
head(tidydata)   # 180 obs with 81 variables showing mean values for the activities and subjects
