## Getting and Cleaning Data Project
By: Sydney Bautista

### Data Set Information :
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Attribute Information :
For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### Please see [README.md](https://github.com/SJ05/datasciencecoursera/blob/master/3_Getting%20and%20Cleaning%20Data/README.md) regarding some information about the project. Below is a simple explanation about the code that has been created:
1. Merges the training and the test sets to create one data set.
1.1 Read the data
```r
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
```

1.2 Merge the training and testing data
```r
# Merge the train and test data
mergeTrain <- cbind(YTrain, subjectTrain, XTrain)
mergeTest <- cbind(YTest, subjectTest, XTest)
mergedData <- rbind(mergeTrain, mergeTest)

# Remove the created tables to save some memory
rm(subjectTrain, XTrain, YTrain, subjectTest, XTest, YTest)
```

2. Extracts only the measurements on the mean and standard deviation for each measurement.
```r
# Extract only the data on mean and standard deviation
meanStandardDeviation <- grepl("subject|activity|mean|std", colnames(mergedData))

# Get the Merged Data
mergedData <- mergedData[, meanStandardDeviation]
```

3. Uses descriptive activity names to name the activities in the data set
```r
# Set the activity names
mergedData$activity <- factor(mergedData$activity, levels = activityNames[, 1], labels = activityNames[, 2])
```

4. Appropriately labels the data set with descriptive variable names.
```r
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
```

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```r
# Split the data into subsets
TidyData <- aggregate(. ~subject + activity, mergedData, mean)

# Re-arrange the data according to subject then activity
TidyData <- TidyData[order(TidyData$subject,TidyData$activity),]

# Write the data into a new text file
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)

# Write the data into a new csv file
write.table(TidyData, file = "tidydata.csv",row.name=FALSE)
```
