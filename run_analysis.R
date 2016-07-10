#Step 1
#load in features
features <- read.table("UCI HAR Dataset/features.txt")
#load in test dataset
set <- read.table("UCI HAR Dataset/test/X_test.txt")
subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
activity <- read.table("UCI HAR Dataset/test/y_test.txt")
#load in train datasets
set_train <- read.table("UCI HAR Dataset/train/X_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
#bind test and train datasets together
set <- rbind(set, set_train)
subject <- rbind(subject, subject_train)
activity <- rbind(activity, activity_train)

#Step 2 & Step 4
#find features that contain mean or std - anywhere, to ensure we have all.
#if the user of the final dataset doesn't require any final columns he/she can simply remove them
features_reqd <- rbind(features[grep("mean", features$V2),], features[grep("std", features$V2),])
#put them back in the original order
features_reqd <- features_reqd[order(features_reqd$V1),]
#transpose features so that we can use the variable names as the column names
features <- t(features)
#rename columns of set using features
colnames(set) <- features[2,]
##bind set with subject (1-30) and activity (1-6)
##set <- cbind(subject, activity, set)
#use that to keep only mean and std columns
setmeanstd <- set[][,features_reqd[,1]]
#rename column names of subject and activity to prepare them to be bound to setmeanstd
colnames(subject) <- "subject"
colnames(activity) <- "activity"
#bind subjects and activities to setmeanstd
setmeanstd <- cbind(subject, activity, setmeanstd)

#Step 3
#merge with activity_labels to convert numbers to labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
setmeanstd = merge(activity_labels, setmeanstd, by.x="V1", by.y="activity", all=TRUE)
#remove activity number since we now have textual labels
setmeanstd <- setmeanstd[,2:82]
#rename activity column (again)
names(setmeanstd)[1] <- "activity"

#Step 5
#load package
library(reshape2)
#first need to melt all of the features into one column
setmeanstdtidy <- melt(setmeanstd, id=c("subject","activity"))
#second need to aggregate this based on activity & subject
setmeanstdtidy <- dcast(setmeanstdtidy, activity + subject ~ variable, mean)
