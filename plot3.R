powerdata <- read.table("household_power_consumption.txt",header=T,sep=";",
                        na.strings="?",nrows=2075259,check.names=F,
                        stringsAsFactors=F,comment.char="", quote='\"')

powerdata$Date <- as.Date(powerdata$Date, format="%d/%m/%Y") ##changes format of "Date"

data <- subset(powerdata, subset=(Date == "2007-02-01" | Date == "2007-02-02")) ##selects the 2 days we need in the project

mydata <- paste(as.Date(data$Date), data$Time)

data$mydata <- as.POSIXct(mydata)

## PLOT 3
with(data, {
  plot(Sub_metering_1~mydata, type="l",
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~mydata,col='Red')
  lines(Sub_metering_3~mydata,col='Blue')
})
legend(col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Saving to file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
