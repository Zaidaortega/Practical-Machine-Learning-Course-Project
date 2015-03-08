## GETTING AND CLEANING DATA
powerdata <- read.table("household_power_consumption.txt",header=T,sep=";",
                        na.strings="?",nrows=2075259,check.names=F,
                        stringsAsFactors=F,comment.char="", quote='\"')

powerdata$Date <- as.Date(powerdata$Date, format="%d/%m/%Y") ##changes format of "Date"

data <- subset(powerdata, subset=(Date == "2007-02-01" | Date == "2007-02-02")) ##selects the 2 days we need in the project

mydata <- paste(as.Date(data$Date), data$Time)

data$mydata <- as.POSIXct(mydata)

#PLOT 2
plot(data$Global_active_power ~ data$mydata, type="l", ylab="Global Active Power (kilowatts)", xlab="")

dev.copy(png, file="plot2.png", height=480, width=480) ##saves the plot with the appropiate size

dev.off()
