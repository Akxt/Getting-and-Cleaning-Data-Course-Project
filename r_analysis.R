
library(dplyr)
library(data.table)

#Reading feature vector
features<-read.table("./UCI HAR Dataset/features.txt")

#Reading activity labels
activityLabels<- read.table("./UCI HAR Dataset/activity_labels.txt")


#Reading test Variables
xTest<-read.table("./UCI HAR Dataset/test/X_test.txt")
yTest<-read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest<-read.table("./UCI HAR Dataset/test/subject_test.txt")

#Reading training variables
xTrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain<-read.table("./UCI HAR Dataset/train/subject_train.txt")


#Merging train and test sets
xConsolidated<-rbind(xTest,xTrain)
yConsolidated<-rbind(yTest,yTrain)
subjectConsolidated<-rbind(subjectTest,subjectTrain)

# Extraction of only measurements on the mean and standard deviation
meanStdFeatures <- grep("-(mean|std)\\(\\)", features[, 2])
xConsolidated <- xConsolidated[, meanStdFeatures]



# Descriptive activity names to name the activities in the data set

yConsolidated[, 1] <- activityLabels[yConsolidated[, 1], 2]
names(yConsolidated) <- "activity"
names(subjectConsolidated) <- "subject"
names(xConsolidated) <- features[meanStdFeatures, 2]

#bind all the data in a single data set
consolidated <- cbind(xConsolidated, yConsolidated, subjectConsolidated)


# Creation of a second, independent tidy data set with the average of each variable for each activity and each subject.

averages = consolidated %>% group_by(activity,subject) %>%  dplyr::summarize_all(mean)
