#read relevant data
train_x <- read.table("./train/X_train.txt",header = F)
train_y <- read.table("./train/y_train.txt",header = F)
test_x <- read.table("./test/X_test.txt",header = F)
test_y <- read.table("./test/y_test.txt",header = F)
subject_train <- read.table("./train/subject_train.txt", header = F)
subject_test <- read.table("./test/subject_test.txt", header = F)
featrures <- read.table("./features.txt",header = F, stringsAsFactors = F)


#combine x y and subject of train and test
total_x <- rbind(train_x, test_x)
total_y <- rbind(train_y, test_y)
total_subject <- rbind(subject_train, subject_test)

#combine all the x,y,subject into one big data.frame 
total_data <- cbind(total_subject, total_y, total_x)
colnames(total_data)[2] <- "y"
colnames(total_data)[1] <- "subject"

#grab colnames that contain "mean" and "std"
colnames(total_data)[3:563] <- c(featrures$V2)
data_del <- total_data[,c(1,2,grep("mean|std",colnames(total_data), ignore.case = F))]

#add column "activities" into the data.frame
activity_labels <- read.table("./activity_labels.txt", header = F)
merge_data <- merge(activity_labels, data_del, by.x = "V1", by.y = "y", sort = F)
colnames(merge_data)[colnames(merge_data) == "V2"] <- "activities"

#tidy the data
#delete the useless column V1
merge_data <- merge_data[,2:ncol(merge_data)]
melt_data <- melt(merge_data, id = c("activities", "subject"))
#calculate the average of each measurement
mean_data <- dcast(melt_data, activities + subject ~ variable, mean)

#output the tidy.txt
write.table(x = mean_data, file = "./Getting-and-Cleaning-Data-Week4/tidy.txt")