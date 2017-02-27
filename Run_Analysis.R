# Load Data

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

x_data<-rbind(x_train,x_test)
y_data<-rbind(y_train,y_test)
subject_data<-rbind(subject_train,subject_test)



# Load Labels

       
features<-read.table("features.txt", sep="", header=FALSE) 

# Extract Mean and St. Dev from features and subset x

features[,2]<-gsub('-mean',"MEAN",features[,2])
features[,2]<-gsub('-std',"STD",features[,2])
features[,2]<-gsub('[-()]',"",features[,2])
datarow<-grep(".*MEAN*.|.*STD*.", features[,2])

x_data<-x_data[,datarow]
names(x_data)<-features[datarow,2]


# read and sort activities

activity<-read.table("activity_labels.txt", sep="", header=FALSE) 
y_data[,1]<-activity[y_data[,1],2]
names(y_data)<-c("activity")

# label subject data
names(subject_data)<-"subject"

data<-cbind(x_data,y_data,subject_data)

library(plyr)
av<-ddply(data, .(subject, activity), function(x) colMeans(x[, 1:79]))
write.table(av,"tidy_data.txt",row.names = FALSE)
