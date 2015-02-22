##The following code downloads and unzips the data
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="localcopyfitness", method="curl")
unzip("localcopyfitness")

##This code notes the date of download
datedownloaded<-date()
datedownloaded

##Imports the data.table library
library(data.table)

##Read in the data files
act<-fread("activity_labels.txt")
feat<-read.table("features.txt")
id1<-read.table("test/subject_test.txt")
x1<-read.table("test/X_test.txt")
y1<-read.table("test/y_test.txt")
id2<-read.table("train/subject_train.txt")
x2<-read.table("train/X_train.txt")
y2<-read.table("train/y_train.txt")

##Merges test and train data
X<-rbind(x1, x2)
Y<-rbind(y1, y2)
ID<-rbind(id1, id2)

##Assigns names to the columns
colnames(Y) <- "Activity"
colnames(ID) <- "Subjects"

##Grabs the ALL mean and standard deviation data from the observation as the assignment was not specific as to which ones to take.
meanset<-feat[grep("mean", feat$V2), ]
stdset<-feat[grep("std", feat$V2), ]
xmeanset<-X[,meanset[,1]]
xstdset<-X[,stdset[,1]]

##Assigns names to the columns
colnames(xmeanset) <- meanset$V2
colnames(xstdset) <- stdset$V2


##The for loop replaces activity keys with the names of the activities
for(i in act$V1){
        Y[which(Y==i),] <- act$V2[i]
}

## This code merges everything into a data frame.
data<-cbind(ID,Y,xmeanset,xstdset)

## This will write the clean data into a file.  Change the "cleanData.txt" to what ever you would like the file to be called.
write.table(data, "cleanData.txt",quote = FALSE, sep = "\t", row.names = FALSE)


##This goes through cleanData and calculates averages for the observations
num <- 1
cleanMean <- matrix(data=NA,nrow=dim(unique(data["Subjects"]))[1]*length(act$V1),ncol=length(data[1,]))
for(action in act$V1){
        for(sub in 1:dim(unique(data["Subjects"]))[1]){
                selected = data[which(data["Activity"]==act$V2[action] & data["Subjects"]==sub),]
                for(k in 3:length(selected[1,])){
                        cleanMean[num,k] <- mean(selected[,k])
                }
                cleanMean[num,1]<-sub
                cleanMean[num,2]<-act$V2[action]
                num <- num+1
        }
}

## This assigns the column names to the new data frame
colnames(cleanMean)<-c("Subjects", "Activity",as.character(meanset[,2]),as.character(stdset[,2]))

##This will write the clean data into a file.  Change the "cleanDataMean.txt" to what ever you would like the file to be called.
write.table(cleanMean, "cleanDataMean.txt",quote = FALSE, sep = "\t", row.names = FALSE)
