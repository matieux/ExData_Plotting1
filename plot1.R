rm(list = ls())
options(stringsAsFactors = FALSE)
library(dplyr)
dataFile <- "household_power_consumption.txt"

data <- read.csv(dataFile, sep=";", header = TRUE, row.names = NULL) %>%
	filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
	rename(date = Date, time = Time, globalActivePower = Global_active_power,
		   globalReactivePower = Global_reactive_power, voltage = Voltage,
		   globalIntensity = Global_intensity, subMetering1 = Sub_metering_1,
		   subMetering2 = Sub_metering_2, subMetering3 = Sub_metering_3) %>%
	mutate(globalActivePower = as.numeric(globalActivePower))

hist(data$globalActivePower, 
	 xlab = "Global Active Power (kilowatts)", 
	 main = "Global Active Power", 
	 col = "red")

dev.copy(png, file="plot1.png")
dev.off()