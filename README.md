#README
##Instructions
1.	Download raw data  
	<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
2.	Unzip file and put the "getdata-projectfiles-UCI HAR Dataset" folder into working directory
3.	Open RStudio and set working directory
4.	Download and run the run_analysis.R script in RStudio  

##Results
* tidydata.txt
* tidydatamean.txt

##R Script: run_analysis.R
### Step 1: Set Working Directory
`wd <- getwd()`
### Step 2: Create file paths to the raw data
List of file paths needed for the Test dataset   
`fp_test <- list.files(path = paste0(wd, "/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test"), pattern = ".txt", full.names = T)`  
List of file paths needed for the Training dataset  
`fp_train <- list.files(path = paste0(wd, "/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train"), pattern = ".txt", full.names = T)`  
List of column names of the features examined in the Test and Training datasets  
`colnames_features <- read.table(file = paste0(wd, "/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt"), stringsAsFactors = F)`
###Step 3: Combine Test and Training datasets into one dataset
Read all the files for the Test dataset into a data frame  
`df_test <- do.call("cbind", lapply(fp_test, FUN=function(files){read.table(files)}))`  
Reorder columns  
`df_test <- df_test[,c(1,563,2:562)]`  
Read all the files for the Training dataset into a data frame  
`df_train <- do.call("cbind", lapply(fp_train, FUN=function(files){read.table(files)}))`  
Reorder columns  
`df_train <- df_train[,c(1,563,2:562)]`  
Combine the Test and Training data frames into one data frame  
`df <- rbind(df_test,df_train)`
###Step 4: Label the columns of the combined dataset
`colnames_features <- colnames_features[,2]`  
`colnames(df) <- c("subject", "activity", colnames_features)`
###Step 5: Define the attributes within the combined dataset
Used the `car` package in RStudio and relabelled the numeric values within the activity column which were defined in the file activity_labels.txt within the UCI HAR Dataset folder  
`require(car)`  
`df$activity <- recode(df$activity,'1 = "walking";2 = "walkingupstairs";3 = "walkingdownstairs";4="sitting";5 = "standing";6 = "laying"', as.factor.result = T)`  
Redefined the subject column as a factor
`df$subject <- factor(df$subject)`  
###Step 6: Extract only the Mean and Standard Deviation columns (as well as subject and activity)
`n <- names(df)`  
`df <- df[,c(1:2, grep("std()", n, fixed = T), grep("mean()", n, fixed = T))]`
###Step 7: Clean the column names to remove capitalization and symbols
Get the current column names  
`names <- names(df)`  
Define the first letter of the columns  
`names <- gsub("^t", "time", names)`  
`names <- gsub("^f", "frequency", names)`  
Remove symbols  
`names <- gsub("()","", names, fixed = T)`  
`names <- gsub("-", "", names)`  
Remove capitalization and define shortened names to better understand what is being displayed within that column  
`names <- gsub("[B]ody", "body", names)`  
`names <- gsub("[G]yro", "gyroscope", names)`  
`names <- gsub("[G]ravity", "gravity", names)`  
`names <- gsub("[A]cc", "accelerometer", names)`  
`names <- gsub("[J]erk", "jerk", names)`  
`names <- gsub("[X]", "xaxis", names)`  
`names <- gsub("[Y]", "yaxis", names)`  
`names <- gsub("[Z]", "zaxis", names)`  
`names <- gsub("[M]ag","magnitude", names)`  
`names <- gsub("std", "standarddeviation", names)`  
Remove duplicate body  
`names <- gsub("bodybody", "body", names)`  
Update the names in the combined dataset  
`names(df) <- names`
###Step 8: Sort the combined dataset by subject, then activity
`sortnames <- c("subject", "activity")`  
`df <- df[do.call("order", df[sortnames]), ]`
###Step 9: Create tidydata.txt file within the working directory
`write.table(df, file = "tidydata.txt")`
###Step 10: Create a summarized table of subject and activity, taking the means of all the variables 
Using the `reshape2` package in RStudio `melt` the combine dataset by the subject and activty and `dcast` the melted dataset by the average all of the other columns and rows  
`require(reshape2)`  
`df_melt <- melt(df, id = c("subject", "activity"))`  
`df_mean <- dcast(df_melt, subject ~ activity, mean)`
###Step 11: Create tidydatamean.txt file within the working directory
`write.table(df_mean, "tidydatamean.txt")`  
###Step 12: Remove R objects within the environment
`rm(list = ls())`