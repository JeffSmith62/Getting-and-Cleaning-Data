## Getting and Cleaning Data
## Course Project
## 9/27/2015

      # Load needed packages
library("dplyr")
library("plyr")

if(!file.exists("data")) {
      dir.create("data")
}
      ## Download HAR Data from UCI

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/UCIDataset.zip", method="curl")

######## Load data files

      ##    Data Sets for test and training subjects
tstx <- read.table(unz("./data/UCIDataset.zip", "UCI HAR Dataset/test/X_test.txt"))
trnx <- read.table(unz("./data/UCIDataset.zip", "UCI HAR Dataset/train/X_train.txt"))

      ##    Activity Identifier
tsty <- read.table(unz("./data/UCIDataset.zip", "UCI HAR Dataset/test/y_test.txt"))
trny <- read.table(unz("./data/UCIDataset.zip", "UCI HAR Dataset/train/y_train.txt"))

      ##    Subject Identifier
tsts <- read.table(unz("./data/UCIDataset.zip", "UCI HAR Dataset/test/subject_test.txt"))
trns <- read.table(unz("./data/UCIDataset.zip", "UCI HAR Dataset/train/subject_train.txt"))

      ##   Activity Lables
al<-read.table(unz("./data/UCIDataset.zip", "UCI HAR Dataset/activity_labels.txt"))

      ##    Load Feature Labels 
feat<-read.table(unz("./data/UCIDataset.zip", "UCI HAR Dataset/features.txt"), stringsAsFactors = FALSE)


      
###### Predare data to be combined

      ##    Rename column names for Activity Labels
al<-rename(al, c("V1"="activity_id", "V2"="activity"))
      ##    Create a new column in the feat dataframe adding "V" to the ID and match column names in training and test data sets
      ##    and renames column containing variable names to varname
feat$varID<-as.factor(paste("V", feat$V1, sep=""))
feat<-rename(feat, c("V2"="varname"))
      ##    Renames column storing subject in the subject data set
tsts<-rename(tsts,c("V1"="subject")); trns<-rename(trns,c("V1"="subject")) 
      ##    Renames column storing activity id in DF with Activity Labels
tsty<-rename(tsty,c("V1"="activity_id")); trny<-rename(trny,c("V1"="activity_id"))
      ##    Creates vector with varibles contain standard dev, mean, and meanFreq
      ##    used to identify variables to be included in final dataset
featlist<-c(grep("std()",feat$varname, fixed=TRUE),grep("mean()",feat$varname, fixed=TRUE),grep("meanFreq()",feat$varname, fixed=TRUE))

#### Build Tidy Data sets 
      ##    creates complete dataframes with Standard Deviation amd MEAN variables adding in subject and activity_id
tstSM<-cbind(tsts,tsty,tstx[,featlist] )
trnSM<-cbind(trns,trny,trnx[,featlist] )

      ##    combines test and training data and attaches the activity labels
comdat <- rbind(merge(al,tstSM,by = "activity_id"), merge(al,trnSM,by = "activity_id"))

      ##    melt table - flips the variables from columns to rows, creates tidy complete data set with vairable labels
meltdat<-melt(comdat, id=c("activity","subject"), measure.vars=C(vrbl$varID))
      ##    Merges variable labels to melted table
mergedat<-merge((select((feat[featlist,]),varname:varID)),meltdat,by.x="varID", by.y="variable",all.y=TRUE)
      ## clears unneeded meltdat
meltdata<-NULL
      ##    creates independent tidy dataset
indtidy<-ddply(mergedat, c("subject","activity","varname"), summarise,
               avg=mean(value)
                  )

#### creates output file

if(!file.exists("data")) {
      dir.create("data")
}
write.table(indtidy,file ="./data/indtidy.txt", row.names= FALSE)
