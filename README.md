---
title: "CODEBOOK -Getting and Cleaning Data Course Project"
author: "Zaida Ortega"
date: "Thursday, April 23, 2015"
output: html_document
---
###Instructions
####  The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
####  One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
####http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
####Here are the data for the project: 
####https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
####You should create one R script called run_analysis.R that does the following: 
####1. Merges the training and the test sets to create one data set.
####2. Extracts only the measurements on the mean and standard deviation for each measurement. 
####3. Uses descriptive activity names to name the activities in the data set
####4. Appropriately labels the data set with descriptive variable names. 
####5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Introduction
####We first need to install plyr:
```{r}
library(plyr)
```


### 1. Merging the training and the test sets to create one dataset
```{r}
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
```

```{r}
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
```

#### Creating the dataset "x":
```{r}
x_data <- rbind(x_train, x_test)
```
#### Creating the dataset "y":
```{r}
y_data <- rbind(y_train, y_test)
```
#### Creating dataset "subject":
```{r}
subject_data <- rbind(subject_train, subject_test)
```

####We are reading the follow datasets: features.txt, activity_labels.txt, subject_train.txt, x_train.txt, y_train.txt, subject_test.txt, x_test.txt, y_test.txt, into tables, assigning column names and merging in one dataset.


### 2. Extracting only the measurements on the mean and standard deviation for each measurement. 
```{r}
features <- read.table("features.txt")
```
#### Getting only columns containnig mean() or std():
```{r}
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
```
#### Subsetting and correcting those columns:
```{r}
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]
```

### 3. Using descriptive activity names to name the activities in the data set
```{r}
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"
```

### 4. Appropriately label the data set with descriptive variable names
#### correcting column names and merging it:
```{r}
names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)
```

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#### 66 <- 68 columns but last two (activity & subject)
```{r}
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)
```

####6. Finally, averages_data contains the relevant averages which will be later stored in a .txt file. ddply() from the plyr package is used to apply colMeans() and ease the development.
