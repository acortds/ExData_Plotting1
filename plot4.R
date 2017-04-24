rm(list = ls())
pwd <- getwd()

if (!dir.exists("EPC")) {
  dir.create("EPC")
  setwd("EPC")
  # Download dataset
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, destfile = "Electric_Power_Consumption.zip",method = "curl")
  unzip("Electric_Power_Consumption.zip")
  setwd(pwd)
}

epc <- read.csv2("EPC/household_power_consumption.txt",header = TRUE, na.strings = "?", stringsAsFactors = FALSE)
epc <- data.frame(epc,as.POSIXlt(paste(epc$Date, epc$Time), format="%d/%m/%Y %H:%M:%S"))
colnames(epc) <- c("date","time","gap","grp","volt","gi","sm1","sm2","sm3","datetime")
epc <- subset(epc, datetime >= strptime("2007-02-01 00:00:00","%Y-%m-%d %T") & datetime <= strptime("2007-02-02 23:59:00","%Y-%m-%d %T"))

par(mfrow = c(2,2))
with(epc, plot(datetime,gap,type = "l",xlab = "",ylab="Global Active Power"))
with(epc, plot(datetime,volt,type = "l",ylab="Voltage"))
with(epc, {
  plot(datetime, sm1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering") 
  lines(datetime, sm2, col = "red")
  lines(datetime, sm3, col = "blue")
  legend("topright", lty = 1, col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty = "n")
})
with(epc, plot(datetime,grp,type = "l",ylab="Global_reactive_power"))

dev.copy(png,file="Plot4.png")
dev.off()

setwd(pwd)
