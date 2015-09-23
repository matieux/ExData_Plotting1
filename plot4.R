# Environment Cleaning
rm(list = ls())
options(stringsAsFactors = FALSE)
library(dplyr)
dataFile <- "household_power_consumption.txt"

# Data preparation
data <- read.csv(dataFile, sep=";", header = TRUE, row.names = NULL) %>%
	filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
	tbl_df %>%
	rename(date = Date, time = Time, globalActivePower = Global_active_power,
		   globalReactivePower = Global_reactive_power, voltage = Voltage,
		   globalIntensity = Global_intensity, subMetering1 = Sub_metering_1,
		   subMetering2 = Sub_metering_2, subMetering3 = Sub_metering_3) %>%
	mutate(globalActivePower = as.numeric(globalActivePower)) %>%
	mutate(voltage = as.numeric(voltage)) %>%
	mutate(subMetering1 = as.numeric(subMetering1),
		   subMetering2 = as.numeric(subMetering2),
		   subMetering3 - as.numeric(subMetering3)) %>%
	mutate(globalReactivePower = as.numeric(globalReactivePower)) %>%
	mutate(dateTime = paste(date, time)) %>%
	arrange(dateTime)
	
par(mfrow = c(2,2))
# Plot 1
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
	 ylab = "Global Active Power", xlab = "")
axis(side = 1, at = ticks, labels = axisX)

# Plot 2
y <- data$voltage
y[[2881]] <- y[[2880]]
plot(x, y, type = "l", xaxt = "n", ylim = c(234, 246),
	 ylab = "Voltage", xlab = "datetime")
axis(side = 1, at = ticks, labels = axisX)

# Plot 3
y1 <- data$subMetering1
y2 <- data$subMetering2
y3 <- data$subMetering3
# Need to add a dummy measure to display 'Sat' on axis
y1[[2881]] <- 0
y2[[2881]] <- 0
y3[[2881]] <- 0
ticks <- c(x[[1]], x[[1441]], x[[2881]])
axisX <- lapply(
	ticks,
	function(x) { format(strptime(x, "%s"), "%a") } )
plot(x, y1, type = "l", xaxt = "n",
	 ylab = "Energy sub metering", xlab = "")
axis(side = 1, at = ticks, labels = axisX)
lines(x, y2, col = "red")
lines(x, y3, col = "blue")
legend("topright", 
	   legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
	   lty =1, col = c("black", "red", "blue"), bty = "n")

# Plot 4
y <- data$globalReactivePower
y[[2881]] <- y[[2880]]
plot(x, y, type = "l", xaxt = "n",
	 ylab = "Global_reactive_power", xlab = "datetime")
axis(side = 1, at = ticks, labels = axisX)

dev.copy(png, file="figure/plot4.png")
dev.off()
