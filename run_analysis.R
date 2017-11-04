library(data.table)# for fread and summarizing

## Step 1.Merge the training and the test sets to create one data set.

# Load the train data
x_train<-fread("X_train.txt")
y_train<-fread("y_train.txt")
subject_train<-fread("subject_train.txt")

# Load the test data
x_test<-fread("X_test.txt")
y_test<-fread("y_test.txt")
subject_test<-fread("subject_test.txt")

# Load feature names and activity labels
feature_names<-fread("features.txt")
activity_labels<-fread("activity_labels.txt")

# Give column name for subject data
names(subject_train)<-"subjectID"
names(subject_test)<-"subjectID"

# Add column names for x data
names(x_train)<-feature_names$V2
names(x_test)<-feature_names$V2

# Add column names for y data
names(y_train)<-"activity"
names(y_test)<-"activity"

# Combine train data
train_data<-cbind(subject_train,y_train,x_train)

# Combine test data
test_data<-cbind(subject_test,y_test,x_test)

#Combine test and train data
combined_data<-rbind(train_data,test_data)

## Step 2.Extract only the measurements on the mean and standard deviation for each measurement.
# using regex to find column names that contain "mean()" or "std()". 
mean_and_std_cols<-grepl("mean\\(\\)|std\\(\\)",names(combined_data))

# making the columns "subjectID" and "activity" to True
mean_and_std_cols[1:2]<-TRUE

# Keep only the required columns
combined_data<-combined_data[,mean_and_std_cols,with=FALSE]

## Step 3.Use descriptive activity names to name the activities in the data set
combined_data$activity<-factor(activity_labels[combined_data$activity,V2])

## Step 4.Appropriately label the data set with descriptive variable names.
# This is already done with "subjectId" and "activity"

## Step 5.From the data set in step 4, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.
tidy_data<-combined_data[,lapply(.SD,mean),by=c("subjectID","activity")]

# write the tidy data set to a file
write.table(tidy_data, "tidy_data.txt", row.names=FALSE,quote=FALSE)