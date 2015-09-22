rm(list = ls())
options(stringsAsFactors = FALSE)
library(dplyr)
dataFile <- "household_power_consumption.txt"

data <- read.csv(dataFile, sep=";", header = TRUE, row.names = NULL) %>%
	filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
	tbl_df %>%
	rename(date = Date, time = Time, globalActivePower = Global_active_power,
		   globalReactivePower = Global_reactive_power, voltage = Voltage,
		   globalIntensity = Global_intensity, subMetering1 = Sub_metering_1,
		   subMetering2 = Sub_metering_2, subMetering3 = Sub_metering_3) %>%
	mutate(globalActivePower = as.numeric(globalActivePower)) %>%
	mutate(dateTime = paste(date, time)) %>%
	arrange(dateTime)
	
x <- lapply(data$dateTime, function(x) {
	as.numeric(strptime(x, "%d/%m/%Y %H:%M:%S") ) } )	
y <- data$globalActivePower
# Need to add a dummy measure to display 'Sat' on axis
x[[2881]] <- x[[2880]] + 60; y[[2881]] <- 0
ticks <- c(x[[1]], x[[1441]], x[[2881]])
axisX <- lapply(
	ticks,
	function(x) { format(strptime(x, "%s"), "%a") } )

plot(x, y, type = "l", xaxt = "n",
	 ylab = "Global Active Power (kilowatts)", xlab = "")
axis(side = 1, at = ticks, labels = axisX)

dev.copy(png, file="plot2.png")
dev.off()
	
