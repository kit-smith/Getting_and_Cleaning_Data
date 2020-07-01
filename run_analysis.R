library(mgsub)
library(dplyr)

file.name <- "getdata_projectfiles_UCI HAR Dataset.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

if(!file.exists(file.name)){
    download.file(url, file.name)
}

if(!file.exists(dir)){
    unzip(file.name)
}
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

s.test <- read.table("UCI HAR Dataset/test/subject_test.txt")
s.train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x.test <- read.table("UCI HAR Dataset/test/X_test.txt")
x.train <- read.table("UCI HAR Dataset/train/X_train.txt")
y.test <- read.table("UCI HAR Dataset/test/y_test.txt")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt")

data <- rbind(x.test,x.train)
activity <- rbind(y.test,y.train)
subject <- rbind(s.test, s.train)

means <- grep("mean()|std()", features[,2])
data<-data[,means]

labels <- sapply(features[,2], function(x) {gsub("[()]","",x)})
colnames(data) <- labels[means]
names(subject) <- "subject"
names(activity) <- "activity"

full_data <- cbind(subject, activity, data)

full_data$activity <- (mgsub(full_data$activity, c(1:6),activity.labels[,2]))

data_set2 <- full_data %>%
    group_by(subject,activity) %>%
    summarise_all(funs(mean))

if(!file.exists("tidydata.txt")){
    write.table(data_set2, "tidydata.txt", sep = ",")
}

