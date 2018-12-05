# This script is for the Getting and Cleanign Data Project in Coursera
# Please see the README.md and Codebook for this script.

# packages needed for the libraries to run. Please see https://www.rdocumentation.org/ for more info
# package for downloading files 
install.packages("downloader")
install.packages("plyr")

# libraries needed for the functions to run
library(downloader)
library(plyr)

# Checks if the data folder exist
if(!file.exists("datascience3")) {
	# create a directory for the  location of the downloaded zip file
	dir.create("datascience3")
}

# set the url where the data set will be
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download the data
download(fileURL, dest="./datascience3/UCI Project.zip", mode="wb")

# unzip the data
unzip(zipfile = "datascience3/UCI Project.zip",exdir="./datascience3")

# Read the activity names
activityNames <- read.table("./datascience3/UCI HAR Dataset/activity_labels.txt")

# Read the trainings data:
subjectTrain <- read.table("./datascience3/UCI HAR Dataset/train/subject_train.txt")
XTrain <- read.table("./datascience3/UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("./datascience3/UCI HAR Dataset/train/y_train.txt")

# Read the testing data:
subjectTest <- read.table("./datascience3/UCI HAR Dataset/test/subject_test.txt")
XTest <- read.table("./datascience3/UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("./datascience3/UCI HAR Dataset/test/y_test.txt")

# Read the feature data:
features <- read.table('./datascience3/UCI HAR Dataset/features.txt')

# Put column names for the train data
colnames(XTrain) <- features[,2] 
colnames(YTrain) <-"activity"
colnames(subjectTrain) <- "subject"

# Put column names for the test data
colnames(XTest) <- features[,2] 
colnames(YTest) <- "activity"
colnames(subjectTest) <- "subject"

colnames(activityNames) <- c('activity','activityName')

# Merge the train and test data
mergeTrain <- cbind(YTrain, subjectTrain, XTrain)
mergeTest <- cbind(YTest, subjectTest, XTest)
mergedData <- rbind(mergeTrain, mergeTest)

# Remove the created tables to save some memory
rm(subjectTrain, XTrain, YTrain, subjectTest, XTest, YTest)

# Extract only the data on mean and standard deviation
meanStandardDeviation <- grepl("subject|activity|mean|std", colnames(mergedData))

# Get the Merged Data
mergedData <- mergedData[, meanStandardDeviation]

# Set the activity names
mergedData$activity <- factor(mergedData$activity, levels = activityNames[, 1], labels = activityNames[, 2])

# Assigned the column names
columnNames <- colnames(mergedData)

# remove special characters
columnNames <- gsub("[\\(\\)-]", "", columnNames)

# Expand the abbreviations
columnNames <- gsub("^t", "TimeDomain.", columnNames)
columnNames <- gsub("^f", "FrequencyDomain.", columnNames)
columnNames <- gsub("Acc", "Acceleration", columnNames)
columnNames <- gsub("Gyro", "AngularSpeed", columnNames)
columnNames <- gsub("GyroJerk", "AngularAcceleration", columnNames)
columnNames <- gsub("Mag", "Magnitude", columnNames)
columnNames <- gsub("mean", ".Mean", columnNames)
columnNames <- gsub("std", ".StandardDeviation", columnNames)
columnNames <- gsub("Freq\\.", "Frequency.", columnNames)
columnNames <- gsub("Freq$", "Frequency", columnNames)

# Correct typo
columnNames <- gsub("BodyBody", "Body", columnNames)

# Use the new labels as column names
colnames(mergedData) <- columnNames

# Split the data into subsets
TidyData <- aggregate(. ~subject + activity, mergedData, mean)

# Re-arrange the data according to subject then activity
TidyData <- TidyData[order(TidyData$subject,TidyData$activity),]

# Write the data into a new text file
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)

# Write the data into a new csv file
write.table(TidyData, file = "tidydata.csv",row.name=FALSE)
