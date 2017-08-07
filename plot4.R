##Downloading and Unzipping dataset after check if it already exists in working directory

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename <- "eda_project1files.zip"

if(!file.exists(filename)){
  download.file(url, filename, method = "curl")
}

if(!file.exists("household_power_consumption.txt")){
  unzip(filename)
}

#Reading in data
data <- read.table("household_power_consumption.txt",  sep=";", header=T, dec=".", stringsAsFactors = FALSE)

#Creating datetime variable
data$datetime <- paste(data$Date, data$Time)
data$datetime <- as.POSIXct(strptime(data$datetime, format = "%d/%m/%Y %H:%M:%S"))

#Subsetting to wanted dates
data <- subset(data, datetime >= "2007-02-01 00:00:00" & datetime < "2007-02-02 24:00:00")

#Converting number variables from character to numeric
data[,3:9] <- lapply(data[,3:9], as.numeric)

#Plot 4
png('plot4.png')

par(mfrow=c(2,2))

#Topleft graph
with(data, plot(datetime, Global_active_power, type = "l", xlab = ""))

#Topright graph
with(data, plot(datetime, Voltage, type = "l"))

#Bottomleft graph
with(data, plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy Sub Metering"))
with(data, lines(datetime, Sub_metering_2, type="l", col = "red"))
with(data, lines(datetime, Sub_metering_3, type="l", col = "blue"))
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black", "red", "blue"), lwd = 1, cex = .75, bty = "n")

#Bottomright graph
with(data, plot(datetime, Global_reactive_power, type = "l"))

dev.off()