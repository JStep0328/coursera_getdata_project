## run_analysis.R

## Set Working Directory
## setwd("~/Coursera/03 Getting and Cleaning Data/Course Project")
wd <- getwd()

## Create File Paths to the data
fp_test <- list.files(path = paste0(wd, "/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test"), pattern = ".txt", full.names = T)
fp_train <- list.files(path = paste0(wd, "/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train"), pattern = ".txt", full.names = T)
colnames_features <- read.table(file = paste0(wd, "/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt"), stringsAsFactors = F)

## Create Test dataset
df_test <- do.call("cbind", lapply(fp_test, FUN=function(files){read.table(files)}))
# reorder columns
df_test <- df_test[,c(1,563,2:562)]

## Create Train data
df_train <- do.call("cbind", lapply(fp_train, FUN=function(files){read.table(files)}))
# reorder columns
df_train <- df_train[,c(1,563,2:562)]

##

## Combine Test and Train
df <- rbind(df_test,df_train)

## Label the dataset
colnames_features <- colnames_features[,2]
colnames(df) <- c("subject", "activity", colnames_features)

## Define activities
require(car)
df$activity <- recode(df$activity,'1 = "walking";2 = "walkingupstairs";3 = "walkingdownstairs";4="sitting";5 = "standing";6 = "laying"', as.factor.result = T)
# Make subject a Factor
df$subject <- factor(df$subject)

## Only pull data from the Mean and Standard Deviation columns
n <- names(df)
df <- df[,c(1:2, grep("std()", n, fixed = T), grep("mean()", n, fixed = T))]


## Clean the column names to remove capitalization and symbols
names <- names(df)
names <- gsub("^t", "time", names)
names <- gsub("^f", "frequency", names)
names <- gsub("()","", names, fixed = T)
names <- gsub("-", "", names)
names <- gsub("[B]ody", "body", names)
names <- gsub("[G]yro", "gyroscope", names)
names <- gsub("[G]ravity", "gravity", names)
names <- gsub("[A]cc", "accelerometer", names)
names <- gsub("[J]erk", "jerk", names)
names <- gsub("[X]", "xaxis", names)
names <- gsub("[Y]", "yaxis", names)
names <- gsub("[Z]", "zaxis", names)
names <- gsub("[M]ag","magnitude", names)
names <- gsub("std", "standarddeviation", names)
names <- gsub("bodybody", "body", names)
names(df) <- names

## Sort by subject, then activity
sortnames <- c("subject", "activity")
df <- df[do.call("order", df[sortnames]), ]

## Write tidydata.txt file to working directory
write.table(df, file = "tidydata.txt")

## Create a summarized table of subject and activity, taking the means of all the variables 
require(reshape2)
df_melt <- melt(df, id = c("subject", "activity"))
df_mean <- dcast(df_melt, subject ~ activity, mean)

## Write tidydatamean.txt file to working directory
write.table(df_mean, "tidydatamean.txt")

## Remove objects
rm(list = ls())