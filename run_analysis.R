

## load.har.ds.from.zip: this function loads the human activity recognition data-set from the a temporary zip file
## decided to make this a function since same steps need to be executed for test and training dataset
load.har.ds.from.zip <- function(tmp.zip.file, data.set.type, headers, activity.labels ) {

    # First load the feature headers from features.txt and activity labels from the activity_labels.txt
    headers <- read.table(unzip(zipfile = temp.zip.file,files = file.path("UCI HAR Dataset","features.txt")), sep="", strip.white = T,stringsAsFactors = F,header = F, col.names =c("ActivityId","ActivityName"))
    activity.labels <- read.table(unzip(zipfile = temp.zip.file,files = file.path("UCI HAR Dataset","activity_labels.txt")), sep="", strip.white = T,stringsAsFactors = F,header = F, col.names =c("FeatureID","FeatureType"))
    
    
    #load the id of the subjects
    subject.file.name <- paste0("subject_", data.set.type, ".txt",collapse = "")
    subject.data <- read.table( file=unzip(zipfile = tmp.zip.file,files = file.path("UCI HAR Dataset",data.set.type,subject.file.name)), sep="", header = F, quote="\"")
    
    #load the activity ids
    activity.file.name <- paste0("y_", data.set.type, ".txt",collapse = "")
    activity.data <- read.table( file=unzip(zipfile = tmp.zip.file,files = file.path("UCI HAR Dataset",data.set.type,activity.file.name)), sep="", header = F, quote="\"")
    
    # Load the measurements for HAR
    # We use the col.names to fill up the headers from "features.txt"
    # fulfills 4.Appropriately labels the data set with descriptive variable names.
    data.file.name <- paste0("X_", data.set.type, ".txt",collapse = "")
    har.data <- read.table( file=unzip(zipfile = tmp.zip.file,files = file.path("UCI HAR Dataset",data.set.type,data.file.name)), sep="", header = F, quote="\"",col.names = headers$ActivityName)
    
    #This call suitably loads converts the activitiy ids in the factors
    #It uses the activity labels defined in activity_labels file
    #
    activity <- factor(activity.data[,1], levels = activity.labels$FeatureID, labels = activity.labels$FeatureType)
    
    # extract only the mean and standard deviations 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
    # label the activity ids  fulfills  "3.Use descriptive activity names to name the activities in the data set "
    har.data %>% select(matches("std()"), matches("mean()")) %>% mutate(subject.Id = subject.data[,1], activity = activity)
}

library(dplyr)
if ( packageVersion("dplyr") < "0.5.0" ) {
    warning("This requires dplyr package version 0.5.0+")
}



temp.zip.file <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp.zip.file)

#load the measurements , once from training dataset and once for test dataset
test.data <- load.har.ds.from.zip(temp.zip.file,"test",headers,activity.labels)
train.data <- load.har.ds.from.zip(temp.zip.file,"train",headers,activity.labels)


## 1.Merges the training and the test sets to create one data set.
total.data <- rbind(test.data, train.data)


#delete the temp file, free up the disk space
unlink(temp.zip.file)
## no longer need the test and train data, free up some memory
rm("test.data","train.data")


#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#uses dplyr 0.5.0
tidy.data.set <- total.data %>% group_by(subject.Id, activity) %>%  summarise_all(.funs = c(Mean="mean"))

#cleaning up the names, removing the dots and underscores
names(tidy.data.set) <-gsub("\\.+","", names(tidy.data.set))
names(tidy.data.set) <-gsub("_","", names(tidy.data.set))

write.table(tidy.data.set,file="tidy_data_set.txt",quote = F,row.names = F,col.names = T )