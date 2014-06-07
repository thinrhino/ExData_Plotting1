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

# Function to plot Global Active Power vs datetime
plotGAP <- function(){
  with(d, {
    plot(dateTime, Global_active_power,
         type='l', xlab='',
         ylab='Global Active Power (kilowatts)')
  })
}
  
# Function to plot Voltage vs dateTime to current device.
plotVoltage <- function(){
  with(d, {
    plot(dateTime, Voltage, xlab='datetime', type='l')
  })
}

# Function to plot Energy sub metering
plotESM <- function(){
  with(d, {
    plot(dateTime, Sub_metering_1, type='l', xlab='', ylab="Energy sub metering")
    lines(dateTime, Sub_metering_2, type='l', col='red')
    lines(dateTime, Sub_metering_3, type='l', col='blue')
  })
}

# Function to plot Global reactive power vs DateTime to current device.
plotGRP <- function(){
  with(d, {
    plot(dateTime, Global_reactive_power, xlab='datetime', type='l')
  })
}

# Now create plot
png(filename = "plot4.png", width = 480, height = 480, bg = "transparent")

# Partition the plot into 2 x 2
par(mfrow=c(2,2))

# Plot the four graphs.
plotGAP()
plotVoltage()
plotESM()
plotGRP()

dev.off()

