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
png(filename = "plot3.png", width = 480, height = 480, bg = "transparent")

with(d, {
  plot(dateTime, Sub_metering_1, type='l', xlab='', ylab="Energy sub metering")
  lines(dateTime, Sub_metering_2, type='l', col='red')
  lines(dateTime, Sub_metering_3, type='l', col='blue')
})

legend('topright',
       legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       lwd='1',
       col=c('black', 'red', 'blue'))

dev.off()
