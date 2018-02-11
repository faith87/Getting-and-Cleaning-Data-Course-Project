# Getting-and-Cleaning-Data-Course-Project

This is my submission for the course project for the Getting and Cleaning Data course. 
The file has already been downloaded and unzipped into this folder in my computer: 
"C:/Users/ptobach/Documents/courseraproject/UCI HAR Dataset/"

The R script, run_analysis.R, does the following:
1. Clean up workspace
2. Load the dplyr module 
3. Set working directory to the location where the UCI HAR Dataset was unzipped
4. Read data from files (features, activity type, training and test data sets)
5. Assign column names to the training and test data
6. Combine test and training data into one dataset
7. Combine subject IDs and activity labels from the test and training data 
8. Extract only the measurements on the mean and standard deviation for each measurement. 
9. Use descriptive activity names to name the activities in the data set
10. Clean up the variable names
11. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
