# CodeBook
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
##Dataset: tidydata.txt
###Data
The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities ("laying","sitting","standing","walking","walkingdownstairs","walkingupstairs") wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the smartphone captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.  
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.  
###Column names within the tidydata set
tidydata set dimensions: 10,299 rows by 68 columns  
**Column names**  
**1. subject**  
Factor variable with 30 levels  
30 volunteers within an age bracket of 19-48 years    
**2. activity**  
Factor variable with 6 levels  
6 activities tested ("laying","sitting","standing","walking","walkingdownstairs","walkingupstairs")  
**3. timebodyaccelerometerstandarddeviationxaxis**  
Numeric variable  
The standard deviation of the x axis value of time domain signal measured by the accelerometer produced by body acceleration.  
**4. timebodyaccelerometerstandarddeviationyaxis**  
Numeric variable  
The standard deviation of the y axis value of time domain signal measured by the accelerometer produced by body acceleration.  
**5. timebodyaccelerometerstandarddeviationzaxis**  
Numeric variable  
The standard deviation of the z axis value of time domain signal measured by the accelerometer produced by body acceleration.  
**6. timegravityaccelerometerstandarddeviationxaxis**  
Numeric variable  
The standard deviation of the x axis value of time domain signal measured by the accelerometer produced by gravity acceleration.  
**7. timegravityaccelerometerstandarddeviationyaxis**  
Numeric variable  
The standard deviation of the y axis value of time domain signal measured by the accelerometer produced by gravity acceleration.  
**8. timegravityaccelerometerstandarddeviationzaxis**  
Numeric variable  
The standard deviation of the z axis value of time domain signal measured by the accelerometer produced by gravity acceleration.  
**9. timebodyaccelerometerjerkstandarddeviationxaxis**  
Numeric variable  
The standard deviation of the x axis value of time domain signal measured by the accelerometer produced by body jerk.  
**10. timebodyaccelerometerjerkstandarddeviationyaxis**  
Numeric variable  
The standard deviation of the y axis value of time domain signal measured by the accelerometer produced by body jerk.  
**11. timebodyaccelerometerjerkstandarddeviationzaxis**  
Numeric variable  
The standard deviation of the z axis value of time domain signal measured by the accelerometer produced by body jerk.  
**12. timebodygyroscopestandarddeviationxaxis**  
Numeric variable  
The standard deviation of the x axis value of time domain signal measured by the gyroscopes produced by body angular velocity.  
**13. timebodygyroscopestandarddeviationyaxis**  
Numeric variable  
The standard deviation of the y axis value of time domain signal measured by the gyroscopes produced by body angular velocity.  
**14. timebodygyroscopestandarddeviationzaxis**  
Numeric variable  
The standard deviation of the z axis value of time domain signal measured by the gyroscopes produced by body angular velocity.  
**15. timebodygyroscopejerkstandarddeviationxaxis**  
Numeric variable  
The standard deviation of the x axis value of time domain signal measured by the gyroscopes produced by body angular velocity jerk.  
**16. timebodygyroscopejerkstandarddeviationyaxis**  
Numeric variable  
The standard deviation of the y axis value of time domain signal measured by the gyroscopes produced by body angular velocity jerk.  
**17. timebodygyroscopejerkstandarddeviationzaxis**  
Numeric variable  
The standard deviation of the z axis value of time domain signal measured by the gyroscopes produced by body angular velocity jerk.  
**18. timebodyaccelerometermagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of time domain signal measured by the accelerometer produced by body acceleration.  
**19. timegravityaccelerometermagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of time domain signal measured by the accelerometer produced by gravity acceleration.  
**20. timebodyaccelerometerjerkmagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of time domain signal measured by the accelerometer produced by body jerk.  
**21. timebodygyroscopemagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of time domain signal measured by the gyroscope produced by body angular velocity.  
**22. timebodygyroscopejerkmagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of time domain signal measured by the gyroscope produced by body angular velocity jerk.  
**23. frequencybodyaccelerometerstandarddeviationxaxis**  
Numeric variable  
The standard deviation of the x axis value of frequency domain signals measured by the accelerometer produced by body acceleration.  
**24. frequencybodyaccelerometerstandarddeviationyaxis**  
Numeric variable  
The standard deviation of the y axis value of frequency domain signals measured by the accelerometer produced by body acceleration.  
**25. frequencybodyaccelerometerstandarddeviationzaxis**  
Numeric variable  
The standard deviation of the z axis value of frequency domain signals measured by the accelerometer produced by body acceleration.  
**26. frequencybodyaccelerometerjerkstandarddeviationxaxis**  
Numeric variable  
The standard deviation of the x axis value of frequency domain signals measured by the accelerometer produced by body jerk.  
**27. frequencybodyaccelerometerjerkstandarddeviationyaxis**  
Numeric variable  
The standard deviation of the y axis value of frequency domain signals measured by the accelerometer produced by body jerk.  
**28. frequencybodyaccelerometerjerkstandarddeviationzaxis**  
Numeric variable  
The standard deviation of the z axis value of frequency domain signals measured by the accelerometer produced by body jerk.  
**29. frequencybodygyroscopestandarddeviationxaxis**  
Numeric variable  
The standard deviation of the x axis value of frequency domain signals measured by the gyroscope produced by body angular velocity.  
**30. frequencybodygyroscopestandarddeviationyaxis**  
Numeric variable  
The standard deviation of the y axis value of frequency domain signals measured by the gyroscope produced by body angular velocity.  
**31. frequencybodygyroscopestandarddeviationzaxis**  
Numeric variable  
The standard deviation of the z axis value of frequency domain signals measured by the gyroscope produced by body angular velocity.  
**32. frequencybodyaccelerometermagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of frequency domain signals measured by the accelerometer produced by body acceleration.  
**33. frequencybodyaccelerometerjerkmagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of frequency domain signals measured by the accelerometer produced by body jerk.  
**34. frequencybodygyroscopemagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of frequency domain signals measured by the gyroscope produced by body angular velocity.  
**35. frequencybodygyroscopejerkmagnitudestandarddeviation**  
Numeric variable  
The standard deviation of the magnitude of frequency domain signals measured by the gyroscope produced by body angular velocity jerk.  
**36. timebodyaccelerometermeanxaxis**  
Numeric variable  
The average of the x axis of time domain signal measured by the accelerometer produced by body acceleration.  
**37. timebodyaccelerometermeanyaxis**  
Numeric variable  
The average of the y axis of time domain signal measured by the accelerometer produced by body acceleration.  
**38. timebodyaccelerometermeanzaxis**  
Numeric variable  
The average of the z axis of time domain signal measured by the accelerometer produced by body acceleration.  
**39. timegravityaccelerometermeanxaxis**  
Numeric variable  
The average of the x axis of time domain signal measured by the accelerometer produced by gravity acceleration.  
**40. timegravityaccelerometermeanyaxis**  
Numeric variable  
The average of the y axis of time domain signal measured by the accelerometer produced by gravity acceleration.  
**41. timegravityaccelerometermeanzaxis**  
Numeric variable  
The average of the z axis of time domain signal measured by the accelerometer produced by gravity acceleration.  
**42. timebodyaccelerometerjerkmeanxaxis**  
Numeric variable  
The average of the x axis of time domain signal measured by the accelerometer produced by body jerk.  
**43. timebodyaccelerometerjerkmeanyaxis**  
Numeric variable  
The average of the y axis of time domain signal measured by the accelerometer produced by body jerk.  
**44. timebodyaccelerometerjerkmeanzaxis**  
Numeric variable  
The average of the z axis of time domain signal measured by the accelerometer produced by body jerk.  
**45. timebodygyroscopemeanxaxis**  
Numeric variable  
The average of the x axis of time domain signal measured by the gyroscope produced by body angular velocity.  
**46. timebodygyroscopemeanyaxis**  
Numeric variable  
The average of the y axis of time domain signal measured by the gyroscope produced by body angular velocity.  
**47. timebodygyroscopemeanzaxis**  
Numeric variable  
The average of the z axis of time domain signal measured by the gyroscope produced by body angular velocity.  
**48. timebodygyroscopejerkmeanxaxis**  
Numeric variable  
The average of the x axis of time domain signal measured by the gyroscope produced by body angular velocity jerk.  
**49. timebodygyroscopejerkmeanyaxis**  
Numeric variable  
The average of the y axis of time domain signal measured by the gyroscope produced by body angular velocity jerk.  
**50. timebodygyroscopejerkmeanzaxis**  
Numeric variable  
The average of the z axis of time domain signal measured by the gyroscope produced by body angular velocity jerk.  
**51. timebodyaccelerometermagnitudemean**  
Numeric variable  
The average magnitude of time domain signal measured by the accelerometer produced by body acceleration.  
**52. timegravityaccelerometermagnitudemean**  
Numeric variable  
The average magnitude of time domain signal measured by the accelerometer produced by gravity acceleration.  
**53. timebodyaccelerometerjerkmagnitudemean**  
Numeric variable  
The average magnitude of time domain signal measured by the accelerometer produced by body jerk.  
**54. timebodygyroscopemagnitudemean**  
Numeric variable  
The average magnitude of time domain signal measured by the gyroscope produced by body angular velocity.  
**55. timebodygyroscopejerkmagnitudemean**  
Numeric variable  
The average magnitude of time domain signal measured by the gyroscope produced by body angular velocity jerk.  
**56. frequencybodyaccelerometermeanxaxis**  
Numeric variable  
The average of the x axis of frequency domain signals measured by the accelerometer produced by body acceleration.  
**57. frequencybodyaccelerometermeanyaxis**  
Numeric variable  
The average of the y axis of frequency domain signals measured by the accelerometer produced by body acceleration.  
**58. frequencybodyaccelerometermeanzaxis**  
Numeric variable  
The average of the z axis of frequency domain signals measured by the accelerometer produced by body acceleration.  
**59. frequencybodyaccelerometerjerkmeanxaxis**  
Numeric variable  
The average of the x axis of frequency domain signals measured by the accelerometer produced by body jerk.  
**60. frequencybodyaccelerometerjerkmeanyaxis**  
Numeric variable  
The average of the y axis of frequency domain signals measured by the accelerometer produced by body jerk.  
**61. frequencybodyaccelerometerjerkmeanzaxis**  
Numeric variable  
The average of the z axis of frequency domain signals measured by the accelerometer produced by body jerk.  
**62. frequencybodygyroscopemeanxaxis**  
Numeric variable  
The average of the x axis of frequency domain signals measured by the gyroscope produced by body angular velocity.  
**63. frequencybodygyroscopemeanyaxis**  
Numeric variable  
The average of the y axis of frequency domain signals measured by the gyroscope produced by body angular velocity.  
**64. frequencybodygyroscopemeanzaxis**  
Numeric variable  
The average of the z axis of frequency domain signals measured by the gyroscope produced by body angular velocity.  
**65. frequencybodyaccelerometermagnitudemean**  
Numeric variable  
The average magnitude of frequency domain signals measured by the accelerometer produced by body acceleration.  
**66. frequencybodyaccelerometerjerkmagnitudemean**  
Numeric variable  
The average magnitude of frequency domain signals measured by the accelerometer produced by body jerk.  
**67. frequencybodygyroscopemagnitudemean**  
Numeric variable  
The average magnitude of frequency domain signals measured by the gyroscope produced by body angular velocity.  
**68. frequencybodygyroscopejerkmagnitudemean**  
Numeric variable  
The average magnitude of frequency domain signals measured by the gyroscope produced by body angular velocity jerk.  
##tidydatamean.txt
###Data
The average of each variable for each activity and each subject
###Column names within the tidydatamean set
tidydatamean set dimensions: 30 rows by 7 columns  
**Column names**  
**1. subject**  
Factor variable with 30 levels  
The 30 subjects tested  
**2. laying**  
Numeric variable  
The average of all variables for laying by each subject  
**3. sitting**  
Numeric variable  
The average of all variables for sitting by each subject  
**4. standing**  
Numeric variable  
The average of all variables for standing by each subject  
**5. walking**  
Numeric variable  
The average of all variables for walking by each subject  
**6. walkingdownstairs**  
Numeric variable  
The average of all variables for walkingdownstairs by each subject  
**7. walkingupstairs**  
Numeric variable  
The average of all variables for walkingupstairs by each subject
