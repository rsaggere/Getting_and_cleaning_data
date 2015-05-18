# The script:
#  1)  does not download data file nor does it unzip it
#  2)  needs to run in the directory where the zip AND the unzipped directory
#      is present
#  3)  uses the library: reshape2 and sqldf. If not present it will attempt
#      to install it. Hence, the machine is expected to have internet connection

# Check if required packages are installed else attempt to install them
if (!("reshape2" %in% rownames(installed.packages())) ) {
  print("Installng required package: reshape2")
  install.packages("reshape2",repos="http://cran.us.r-project.org")
} 
if (!("sqldf" %in% rownames(installed.packages())) ) {
  print("Installng required package: sqldf")
  install.packages("sqldf",repos="http://cran.us.r-project.org")
} 
## Load required libraries
library(reshape2)
library(sqldf)

## Read the various files available under UCI HAR Dataset
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Read features.txt and extract only the name
features <- read.table("UCI HAR Dataset/features.txt")
feature_names <- features[ ,2]

## Read activity_labels.txt and assign valid column names
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("activity_id","activity_name"))

## Assign column names to x_test and x_train
colnames(x_test) <- feature_names
colnames(x_train) <- feature_names

## Assign valid column names to other data frames
colnames(y_test) <- "activity_id"
colnames(y_train) <- "activity_id"
colnames(subject_train) <- "subject_id"
colnames(subject_test) <- "subject_id"

## Combine all test data frames into one
test_data <- cbind(subject_test, y_test, x_test)

## Combine all train data frames into one
train_data <- cbind(subject_train, y_train, x_train)

## Combine above 2 data frames into 1
comb_data <- rbind(train_data,test_data)

## Get the positions of columns that have the word "mean" in them &
## select only those columns into a new data frame

mean_index <- grep("mean",names(comb_data),ignore.case=TRUE)
mean_columns <- names(comb_data)[mean_index]

## Similarly, get the positions of columns that have the word "std" in them &
## select only those columns into a new data frame

std_index <- grep("std",names(comb_data),ignore.case=TRUE)
std_columns <- names(comb_data)[std_index]

## Create a new data frame with activity_id, subject_id with mean & std cols
df1 <- comb_data[,c("subject_id","activity_id",mean_columns,std_columns)]

## Create another data frame with textual description of activity_id
df2 <- merge(activity_labels,df1,by.x="activity_id",by.y="activity_id",all=TRUE)

## Melt the data set
melt_df <- melt(df2,id=c("activity_id","activity_name","subject_id"))

## Calculate the average of each variable for each activity and each subject
mean_df <- sqldf("select activity_id,activity_name,subject_id,variable,avg(value) from melt_df group by activity_id,activity_name,subject_id,variable")

## Pivot the data and store in a new data frame called final
final <- dcast(mean_df,activity_id + activity_name + subject_id ~ variable)

## Write the data set
write.table(final,"./project_output.txt",row.name=FALSE)
