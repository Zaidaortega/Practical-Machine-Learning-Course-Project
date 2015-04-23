library(plyr)

# 1. Merging the training and the test sets to create one data set
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
## Creating the dataset "x"
x_data <- rbind(x_train, x_test)
## Creating the dataset "y"
y_data <- rbind(y_train, y_test)
## Creating dataset "subject"
subject_data <- rbind(subject_train, subject_test)

# 2. Extracting only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("features.txt")
## Getting only columns containnig mean() or std()
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
## Subsetting and correcting those columns
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]

# 3. Using descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

# 4. Appropriately label the data set with descriptive variable names
## correcting column names and merging it
names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)
