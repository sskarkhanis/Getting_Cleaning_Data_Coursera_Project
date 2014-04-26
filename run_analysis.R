##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## by Sandeep Karkhanis

# runAnalysis.r File Description:

# 01.Reading training and test set
# 02.Combining training, test set
# 03.Merging activity_type with data from step 2. to include descriptive activity names 
# 04.Labeling the variables with descriptive names 
# 05.Creating 2nd Independent data set by aggegrating the table by activity & subject id per participant
# 06.Exporting the tidyData set 

##########################################################################################################

#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++#
                  # 01.Reading training and test set
#++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++#

#set working directory to the location where extracted UCI HAR Dataset files reside
setwd('/Users/SKarkhanis/Desktop/UCI HAR Dataset/');

# Reading Data in; since the data doesn't have column names, header=FALSE
features     = read.table('./features.txt',header=FALSE); #imports Features File
activityType = read.table('./activity_labels.txt',header=FALSE); #imports activity labels file
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subjectTrain file
xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports xTrain file
yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports yTrain file

# Assigining column names to the imported Training data
colnames(activityType)  = c('activityId','activityType');
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";
colnames(subjectTrain)  = "subjectId";

# creating the final Training set by merging the xTrain, yTrain and subjectTrain sets
trainingData = cbind(yTrain,subjectTrain,xTrain);

# reading the test data ; since the data doesn't have column names, header=FALSE
subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subjectTest file
xTest       = read.table('./test/x_test.txt',header=FALSE); #imports xTest file
yTest       = read.table('./test/y_test.txt',header=FALSE); #imports yTest file

# assigining column names to Test data
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";
colnames(subjectTest) = "subjectId";

# creating the final Test set by merging the xTest, yTest and subjectTest sets
testData = cbind(yTest,subjectTest,xTest);

#++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++#
  # 02.Combining training, test set to create a final data set
#++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++#

#Concatenating the training & test data sets
finalData = rbind(trainingData,testData);

# Storing the column names from the finalData into a character vector 'colNames',
# this will be used to select the desired mean() & stddev() columns
colNames  = colnames(finalData); 

# Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

# subset finalData table based on the logicalVector to keep only desired columns
finalData = finalData[logicalVector==TRUE];

#+++++++++++++++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++++++++++++++#
  # 03.Merging activity_type with data from step 2. to include descriptives activity names 
#+++++++++++++++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++++++++++++++#

# merge the finalData set with the acitivityType table to include descriptive activity names
finalData = merge(finalData,activityType,by='activityId',all.x=TRUE);

# Updating the colNames vector to include the new column names after merge
colNames  = colnames(finalData); 

#++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++#
  # 04. Labeling the variables with descriptive names
#++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++#

# Cleaning up the variable names to make them more descriptive
for (i in 1:length(colNames)) 
{
   colNames[i] = gsub("\\()","",colNames[i])
   colNames[i] = gsub("-std$","StdDev",colNames[i])
   colNames[i] = gsub("-mean","Mean",colNames[i])
   colNames[i] = gsub("^(t)","time",colNames[i])
   colNames[i] = gsub("^(f)","freq",colNames[i])
   colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
   colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
   colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
   colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
   colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
   colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
   colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

# reassigning the new descriptive column names to the finalData set
colnames(finalData) = colNames;

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++++++++++++++++++++++#
  # 05. Creating 2nd Independent data set by aggegrating the table by activity & subject id per participant
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++++++++++++++++++++++#

# Creating a new table, finalData2 without the activityType column as a precursor to the next step for aggregating the finalData set
finalData2  = finalData[,names(finalData) != 'activityType'];

# Summarizing the finalData2 table to include only the average of each variable for each activity and each subject
tidyData    = aggregate(finalData2[,names(finalData2) != c('activityId','subjectId')],by=list(activityId=finalData2$activityId,subjectId = finalData2$subjectId),mean);

# merging the tidyData with activityType to include descriptive acitvity names
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

#++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++#
# 06.Exporting the tidyData set 
#++++++++++++++++++++++++++++++++++#++++++++++++++++++++++++++++++#
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t');
