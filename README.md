###README
##Steps to run this code:

1)Open the R script "run_analysis.r"" using R Studio.
2) Set working directory.
3) Run the script

##Code Options

1) The file will be downloaded and unzipped into your working directory
```
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="localcopyfitness", method="curl")
unzip("localcopyfitness")

datedownloaded<-date()
datedownloaded
```
2) Read in the files, if you have issues check your working directory and where you unzipped the file to.
library(data.table)
```
act<-fread("activity_labels.txt")
feat<-read.table("features.txt")
id1<-read.table("test/subject_test.txt")
x1<-read.table("test/X_test.txt")
y1<-read.table("test/y_test.txt")
id2<-read.table("train/subject_train.txt")
x2<-read.table("train/X_train.txt")
y2<-read.table("train/y_train.txt")
```
3) This code combines the data and cleans it for just the mean and Standard Deviation data.
```
X<-rbind(x1, x2)
Y<-rbind(y1, y2)
ID<-rbind(id1, id2)

colnames(Y) <- "Activity"
colnames(ID) <- "Subjects"


meanset<-feat[grep("mean", feat$V2), ]
stdset<-feat[grep("std", feat$V2), ]
xmeanset<-X[,meanset[,1]]
xstdset<-X[,stdset[,1]]

colnames(xmeanset) <- meanset$V2
colnames(xstdset) <- stdset$V2

for(i in act$V1){
        Y[which(Y==i),] <- act$V2[i]
}

data<-cbind(ID,Y,xmeanset,xstdset)
```
4) This will write the clean data into a file.  Change the "cleanData.txt" to what ever you would like the file to be called.
```
write.table(data, "cleanData.txt",quote = FALSE, sep = "\t", row.names = FALSE)

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
colnames(cleanMean)<-c("Subjects", "Activity",as.character(meanset[,2]),as.character(stdset[,2]))
```

5) This will write the clean mean data into a file.  Change the "cleanDataMean.txt" to what ever you would like the file to be called.
```
write.table(cleanMean, "cleanDataMean.txt",quote = FALSE, sep = "\t", row.names = FALSE)
```
