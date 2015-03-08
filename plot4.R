## GETTING AND CLEANING DATA
powerdata <- read.table("household_power_consumption.txt",header=T,sep=";",
                        na.strings="?",nrows=2075259,check.names=F,
                        stringsAsFactors=F,comment.char="", quote='\"')

powerdata$Date <- as.Date(powerdata$Date, format="%d/%m/%Y") ##changes format of "Date"

data <- subset(powerdata, subset=(Date == "2007-02-01" | Date == "2007-02-02")) ##selects the 2 days we need in the project

mydata <- paste(as.Date(data$Date), data$Time)

data$mydata <- as.POSIXct(mydata)

## PLOT 4

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

with(data, {
  plot(Global_active_power~mydata, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  plot(Voltage~mydata, type="l", 
       ylab="Voltage (volt)", xlab="")
  plot(Sub_metering_1~mydata, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~mydata,col='Red')
  lines(Sub_metering_3~mydata,col='Blue')
  plot(Global_reactive_power~mydata, type="l", 
       ylab="Global Rective Power (kilowatts)",xlab="")
})

dev.copy(png, file="plot4.png", height=480, width=480)

dev.off()
