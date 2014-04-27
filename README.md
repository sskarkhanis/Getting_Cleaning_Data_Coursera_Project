Getting_Cleaning_Data_Coursera_Project
======================================

This repository contains the R code and ReadME.md as part of the Coursera Getting and Cleaning Data in R Course.
  !!Since all the description is available here, no separate CodeBook is provided!!
Following files are included  run_analysis.R and ReadMe.md

========================================================
## ReadMe File
## Coursera Getting and Cleaning Data Course Project
## by Sandeep Karkhanis
========================================================

#+++++++++++++#
Note
#+++++++++++++#
This ReadMe.md file describes
- assumptions used in the analysis
- how the run_analysis.r script works
- the variables, the data, and any transformations performed to clean up the data

#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++
# ReadMe.md File Layout
#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++

# 01. Brief Project Description
# 02. Assumptions 
# 03. Raw Data Description
# 04. Working of the run_analysis.R script
# 05. Tidy Data Description

#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++
# 01. Brief Project Description
#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++

# The purpose of this project is to demonstrate the ability to collect, work with, and clean a 
# data set. The goal is to prepare tidy data that can be used for later analysis.
# The data linked to from the course website represent data collected from the accelerometers
# from the Samsung Galaxy S smartphone. A full description is available at the site where the 
# data was obtained under: 

#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++
02. Assumptions
#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++

# 01. The data files needed for this project are available under,
#     "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# 02. I assume the original data files have been downloaded & extracted locally in appropriate 
#     folders
# 03. The raw data files (inertia signals) placed under the inertia folder are NOT included in 
#     this analysis
# 04. Variable Selection Criteria
#     The raw sensor data fetaures are being extracted by the application of a set of signal
#     filters. The features are chosen because they are assumed to have significance to the 
#     activity labelling problem.
#     Hence, for the sake of this analysis, I have only selected variables ending with mean() 
#     & std() ONLY and ignored the variable names followed by an axis e.g. "tBodyAcc-mean()-X",
#     "tBodyGyro-mean()-X", "meanFreq()" etc.
# 05. Variable & File names, data folder structure remain the same.
# 06. In the tidyData set, the columns are averages of averages i.e. average of mean / std dev    
#     values; hence, I have not included this aspect in the variable names in the tidyData set                
#     instead expalined it in the ReadMe.md

#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++
# 03. Raw Data Description
#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++
# The data comes from the Human Activity Recognition Using Smartphones Experiment
# A group of 30 volunteers within an age bracket of 19-48 years participated in this experiement 
# Each person performed 6 activities namely, Walking, walking Upstairs, Walking Downstairs,
# Sitting, Standing, and Laying while wearing a Samsung Galaxy SII on their waist. 
# Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 
# 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to    
# label the data manually. 
# The obtained dataset was randomly partitioned into two sets, where70% of the volunteers was 
  selected for generating the training data and 30% the test data.
# In essence, a Gyroscope is a device for measuring or maintaining orientation, based on the 
# principles of angular momentum & allows accurate recognition of movement within a 3D space
# In contrast, an accelerometer is a compact device designed to measure non-gravitational
# acceleration.

# UCI HAR Dataset Description
# The dataset includes the following files,
#     - 'README.txt'
#     - 'features_info.txt': Shows information about the variables used on the feature vector
#     - 'features.txt': List of all features.
#     - 'activity_labels.txt': Links the class labels with their activity name.
#     - 'train/X_train.txt': Training set.
#     - 'train/y_train.txt': Training labels.
#     - 'test/X_test.txt': Test set.
#     - 'test/y_test.txt': Test labels.

# Variable Description
# For each participant, there are several things being measured along the XYZ axes,
#     - Angular Velocity, Acceleration, Maginutude, Angle along with some derived values,
#       e.g. Jerk is derived from Acceleration and Angular Velocity
#        - tBodyAcc-XYZ | tGravityAcc-XYZ | tBodyAccJerk-XYZ | tBodyGyro-XYZ
#        - tBodyGyroJerk-XYZ | tBodyAccMag | tGravityAccMag | tBodyAccJerkMag
#        - tBodyGyroMag | tBodyGyroJerkMag | fBodyAcc-XYZ | fBodyAccJerk-XYZ
#        - fBodyGyro-XYZ | fBodyAccMag | fBodyAccJerkMag
#        - fBodyGyroMag | fBodyGyroJerkMag |
#     - Using, the Euclidean norm, the magnitude of the inputs listed above were calculated
#     - The variable have a time (prefix t) and frequency (prefix f) domain component.
#     - Variables are normalized and bounded within [-1,1]
#     - These signals were used to estimate statistical variables [mean, std deviation, min, max
#       ,skew, kurtosis] for each of the feature vector pattern: '-XYZ' is used to denote 3 
#       axial signals in the X, Y and Z directions.
#     - A listing of the statistical variables created is described under the file "FeatureInfo"
#     - A complete list of the 561 variables is available in the file "Features.txt"

# As stated in the assumptions above, as part of the project, only mean() & stddev() estimates
# are included in the analysis.

#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++
# 04. Working of the run_analysis.R script
#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++

# runAnalysis.r File Description:

#  01.Reading training and test set
#     - First, we start by the setting the working directory where the UCI HAR Dataset is 
#       extracted using setwd() command
#     - Using the "read.table" command we import the following files,
#        * features, activityType, subjectTrain, xTrain, yTrain
#        * features, subjectTest, xTest, yTest
#     - Next, we assign column names in each of the files imported above
#     - Using the "cbind" command, we merge to create the Training & Test data sets

#  02.Combining training, test set
#     - I used "rbind" to concatenate the training & test sets into a table "finalData"
#     - At this point, finalData has all of the 561 columns along with subjectId & actiityID
#     - Next step is to subset finalData so that it only contains relevant mean(), stddev()
#     - A two-fold approach is used, 
#     - store the finalData columns in colNames vector
#     - a logicalVector is created using "grepl" expression; "grepl" searches for a specific
#       pattern in the argument and return a TRUE/FALSE value accordingly; the logical vector 
#       expression is made up of a series of AND / OR sub-expressions which either include or
#       negate the result of the corresponding sub-expression.
#     - next, the finalData is subset using the logicalVector to include only relevant columns 
 
#  03.Merging activity_type with data from step 2. to include descriptive activity names 
#     - the finalData set is merged with the acitivityType table to include descriptive activity names
#     - the colNames vector is updated to include the new column (mean & stdddev) names  after merge

#  04.Labeling the variables with descriptive names 
#     - Now that relevant activity names are included in finalData, next I make the variable names
#       more descriptive; this is achieved via for loop over colNames vector
#     - for each element of the vector, the loop runs a bunch of "gsub" expressions used for cleaning
#      "gsub" searches for a pattern and replaces it with given substitution; the pattern can be 
#       specified using regular expression commands to look for strings at the start, end or anywhere
#       in the element
#     - Once the column namess have been cleaned up they are substituted in the finalData set

#  05.Creating 2nd Independent data set by aggegrating the table by activity & subject id per 
#     participant
#     To create the tidyData set, a 3-step approach is used,
#     - First, I create a new finalData2 set without the "activityType" column as a precursor to the 
#       next step for aggregating the finalData set 
#     - Next, "aggregate" function is used to summarize the finalData2 by activity & subject id per
#       participant resulting in the tidyData set; the "mean" function is used since we desire average #        
#       values of the mean & std dev columns; since the new columns will be average of the values I have 
#       not included that aspect in the variable names instead it is documented here
#     - Finally, I merge the tidyData with activityType to include descriptive activity names


#  06.Exporting the tidyData set
#     - Using the "write.table" command, tidyData is exported as a tab delimited text file

#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++
# 05. Tidy Data Description
#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++
#     The columns of the tidyData set are described below,
#     - activityId, subjectId, activityType are same as before.
#     - columns "timeBodyAccMagnitudeMean" , "timeBodyAccMagnitudeStdDev" represent the average
#       time domain magnitude of body acceleration of the mean and std deviation respectively
#     - columns "timeGravityAccMagnitudeMean" & "timeGravityAccMagnitudeStdDev" represent the 
#       average time domain magnitude of angular velocity of the mean and std deviation 
#       respectively
#     - columns "timeBodyAccJerkMagnitudeMean" , "timeBodyAccJerkMagnitudeStdDev" represent the 
#       average time domain magnitude of jerk body acceleration of the mean and std deviation 
#       respectively
#     - columns "timeBodyGyroJerkMagnitudeMean" & "timeBodyGyroJerkMagnitudeStdDev" represent the 
#       average time domain magnitude of jerk angular velocity of the mean and std deviation 
#       respectively
#     - columns "freqBodyAccMagnitudeMean" , "freqBodyAccMagnitudeStdDev" represent the average
#       frequency domain magnitude of body acceleration of the mean and std deviation respectively
#     - columns "freqBodyAccJerkMagnitudeMean" & "freqBodyAccJerkMagnitudeStdDev" represent the 
#       average frequency domain magnitude of jerk acceleration of the mean and std deviation 
#       respectively
#     - columns "freqBodyGyroMagnitudeMean" & "freqBodyGyroMagnitudeStdDev" represent the 
#       average frequency domain magnitude of angular velocity of the mean and std deviation 
#       respectively
#     - columns "freqBodyAccJerkMagnitudeMean" & "freqBodyAccJerkMagnitudeStdDev" represent the 
#       average frequency domain magnitude of jerk angular velocity of the mean and std deviation 
#       respectively









