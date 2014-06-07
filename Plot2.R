# We will use "sqldf" to read partial file.

if(!require('sqldf')){
  install.packages('sqldf')
}
library(sqldf)

# Using read.csv.sql, we read the required data.

data.file <- "./data/household_power_consumption.txt"
sql <- "SELECT * FROM file WHERE Date='1/2/2007' OR Date='2/2/2007'"

d <- read.csv.sql(data.file, sql, sep=";", header=TRUE)

# Convert the data$Date & data$time into a datetime object.
date.time <- paste(d$Date, d$Time, sep = " ")
date.time <- strptime(date.time, format = "%d/%m/%Y %H:%M:%S")

# Append date.time to the dataframe
d$dateTime <- date.time

# Drop the old Date & Time Column
drops <- c("Date", "Time")
d <- d[,!(names(d) %in% drops)]

# Now create plot
png(filename = "plot2.png", width = 480, height = 480, bg = "transparent")
plot(d$dateTime, d$Global_active_power, type='l', xlab='', ylab='Global Active Power (kilowatts)')
dev.off()

