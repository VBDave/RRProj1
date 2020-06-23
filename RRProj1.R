 ##  Dataset: Activity monitoring data [52K]  
 ##https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip
 ##The variables included in this dataset are:
 ##steps: Number of steps taking in a 5-minute interval (missing values are coded as \color{red}{\verb|NA|}NA)  
 ##date: The date on which the measurement was taken in YYYY-MM-DD format  
 ##interval: Identifier for the 5-minute interval in which measurement was taken  
 ##The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.

 ##Loading Libraries:
library(data.table)
library(ggplot2)
library(knitr)
library(lubridate)
 ##Loading Data:
fileUrl <-  "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl,destfile=paste0(getwd(),'/repdata%2Fdata%2Factivity.zip'), method = "curl")
unzip("repdata%2Fdata%2Factivity.zip")
 ##Create Data Table:
ActivityData <- data.table::fread(input = "activity.csv")
 ##Format Dates in Table:
ActivityData$date<-as.Date(ActivityData$date)
 ##  1. Calculate the total number of steps taken per day  
Daily_Steps <- ActivityData[, c(lapply(.SD, sum, na.rm = FALSE)), .SDcols = c("steps"), by = .(date)] 
 ##2. Make a histogram of the total number of steps taken each day  
hist(Daily_Steps$steps,xlab="Steps",breaks=5,main="Histogram of Steps per Day")
 ##3. Calculate and report the mean and median of the total number of steps taken per day  
Daily_Steps[, .(Mean_Steps = mean(steps, na.rm = TRUE), Median_Steps = median(steps, na.rm = TRUE))]
 ##1. Make a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)  
Interval_Steps <- ActivityData[, c(lapply(.SD, mean, na.rm = TRUE)), .SDcols = c("steps"), by = .(interval)]
plot(Interval_Steps$interval,Interval_Steps$steps, type="l",xlab="Time",ylab="Average Steps")
 ##2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
Interval_Steps[steps == max(steps), .(max_interval = interval)]
