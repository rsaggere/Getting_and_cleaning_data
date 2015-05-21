# Getting_and_cleaning_data
## Project Work

A full description of this project is available at the below URL: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The R script "run_analysis.R" reads several files and generates 1 tidy data set as a output file.

The data for this project is available at the URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

As per the requirements of the project, it is assumed that the zip file has already been downloaded and unzipped.When this file is unzipped, it creates a new folder called "UCI HAR Dataset", within which are the following files:

    'features_info.txt' : Technical details about each feature

    'features.txt': List of all features.

    'activity_labels.txt': List of class labels and their activity name.

    'train/X_train.txt': Training set.

    'train/y_train.txt': Training labels.

    'train/subject_train.txt': ID's of subjects in the training data

    'test/X_test.txt': Test set.

    'test/y_test.txt': Test labels.

    'test/subject_test.txt': ID's of subjects in the training data
    
The script does attempt to load two libraries i.e. "reshape2" and "sqldf". If these two libraries are not available, the script tries to download it - hence it is necessary for the host (where this script runs) to have an internet connection.
