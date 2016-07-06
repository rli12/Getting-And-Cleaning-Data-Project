# 1. Merge the training and the test sets to create one data set.

# Read text files into separate datasets first
features <- read.table("./features.txt", header = FALSE)

# Read activty and subject files with distinuishable column names
activity <- read.table("./activity_labels.txt", header = FALSE, col.names = c("activityID", "activityName"))
trainingsubject <- read.table("./train/subject_train.txt", header = FALSE, col.names = "subjectID")

# Read x training data  into df with features as the columns
xTrain <- read.table("./train/x_train.txt", header = FALSE)
names(xTrain) <- features$V2

# Read y labels training data
yTrain <- read.table("./train/y_train.txt", header = FALSE, col.names = "activityID")

# Merge the data set for training data
trainingData <- cbind(yTrain, trainingsubject, xTrain)

#Repeat same steps but for the test data set
testsubject <- read.table("./test/subject_test.txt", header = FALSE, col.names = "subjectID")

xTest <- read.table("./test/x_test.txt", header = FALSE)
names(xTest) <- features$V2

yTest <- read.table("./test/y_test.txt", header = FALSE, col.names = "activityID")

testData <- cbind(yTest, testsubject, xTest)

# Now combine the test and training data set
combinedData <- rbind(trainingData, testData)

# 2. Extract only measurements only on the mean and standard deviation

# Take feature names with mean() or std()
subdataFeaturesNames <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

# Subset by the feature
selectedNames<-c("activityID", "subjectID", as.character(subdataFeaturesNames))

# 3. Use descriptive activity names to name the activities in the data set
newData = merge(newData,activity, by = "activityID", all.x = TRUE)

names(newData)<-gsub("^t", "time", names(newData))
names(newData)<-gsub("^f", "frequency", names(newData))
names(newData)<-gsub("Acc", "Accelerometer", names(newData))
names(newData)<-gsub("Gyro", "Gyroscope", names(newData))
names(newData)<-gsub("Mag", "Magnitude", names(newData))
names(newData)<-gsub("BodyBody", "Body", names(newData))

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

library(plyr)

finalData <- aggregate(. ~subjectID + activityID, newData, mean)
finalData <- finalData[order(finalData$subjectID,finalData$activityID),]
write.table(finalData, file = "tidydata.txt",row.name=FALSE)