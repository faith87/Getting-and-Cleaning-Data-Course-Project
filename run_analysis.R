
##Clean up workspace
rm(list=ls())

##Load CRAN module
library(dplyr)

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd("C:/Users/ptobach/Documents/courseraproject/UCI HAR Dataset/")

# Read in the data from files
features <-  read.table('./features.txt',header=FALSE); 
ActivityType <- read.table('./activity_labels.txt',header=FALSE)
trainingsubjects <- read.table('./train/subject_train.txt',header=FALSE); 
trainingvalues <- read.table('./train/x_train.txt',header=FALSE); 
trainingactivity <- read.table('./train/y_train.txt',header=FALSE);

# Assign column names to the data imported above
colnames(ActivityType) <- c('ActivityID','ActivityType');
colnames(trainingsubjects) <- "SubjectID";
colnames(trainingvalues)<- features[,2]; 
colnames(trainingactivity) <- "ActivityID";

# Create the final training set by merging trainingactivity, trainingsubjects, and trainingvalues
trainingData = cbind(trainingsubjects,trainingactivity, trainingvalues);

# Read in the test data
testsubjects <- read.table('./test/subject_test.txt',header=FALSE); 
testvalues <- read.table('./test/x_test.txt',header=FALSE); 
testactivity <- read.table('./test/y_test.txt',header=FALSE); 

# Assign column names to the test data imported above
colnames(testsubjects) <- "SubjectID";
colnames(testvalues) <- features[,2]; 
colnames(testactivity) <- "ActivityID";

# Create the final test set by merging the testvalues, testactivity and testsubjects data
testData <- cbind(testsubjects, testactivity, testvalues);

# Combine training and test data to create a final data set
totaldata <- rbind(trainingData, testData);

#Combine the Subject and Activity IDs from the Training and Test sets
SubjectData <- rbind(trainingsubjects, testsubjects)
ActivityData <- rbind(trainingactivity, testactivity)


## Extract only the measurements on the mean and standard deviation for each measurement. 
# Create a vector for the column names from the totaldata, which will be used to select the desired mean() & stddev() columns
colNames  <- colnames(totaldata); 

# Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector <-  (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

# Subset totaldata table based on the logicalVector to keep only desired columns
totaldata <- totaldata[logicalVector==TRUE];

# Use descriptive activity names to name the activities in the data set

ActivityData [,1] <- ActivityType[ActivityData [,1], 2]
colnames(ActivityData) <- "Activity"
# Combine the totaldata set with the Subject and Activity labels to include descriptive activity names
totaldata <- cbind(SubjectData, ActivityData, totaldata)

# Update the colNames vector to include the new column names after merge
colNames  <-  colnames(totaldata); 

# Clean up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","Standard Deviation",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","TimeDomain",colNames[i])
  colNames[i] = gsub("^(f)","FrequencyDomain",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyroscope",colNames[i])
  colNames[i] = gsub("AccMag","AccelerometerMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccelerometerJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroscopeMagnitude",colNames[i])
};

# Reassign the new descriptive column names to the totaldata set
colnames(totaldata) = colNames;

# Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Group by subject and activity and summarise using mean
tidydata <- totaldata %>% 
  group_by(SubjectID, Activity) %>%
  summarise_all(funs(mean))

# output to file "tidydata.txt"
write.table(tidydata, "tidydata.txt", row.names = FALSE, 
            quote = FALSE)





