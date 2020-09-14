library(dplyr)

# Read a subset of the data (2007-02-01 to 2007-02-02)
file <- "household_power_consumption.txt"
df <- read.table(file, header=TRUE, sep=";") %>%
        filter (Date %in% c("1/2/2007", "2/2/2007"))

df <- df %>% 
        filter(Sub_metering_1!="?" & Sub_metering_2 != "?" & Sub_metering_3 != "?") %>%
        filter(Voltage != "?" & Global_active_power !="?" & Global_reactive_power != "?" )



# strptime (charstring, format): converts character string to POSIXlt class.
df$DT <- strptime (paste(df$Date, df$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
df$Global_active_power <- as.numeric(df$Global_active_power)
df$Global_reactive_power <- as.numeric(df$Global_reactive_power)
df$Voltage <- as.numeric(df$Voltage)
df$Global_intensity <- as.numeric(df$Global_intensity)
df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)

# remove Date and Time
# df$Date <- NULL
# df$Time <- NULL

# prepare a plot frame
par(mfrow=c(2, 2), mar=c(4, 4, 4, 2))

# row 1, col 1
plot(df$DT, df$Global_active_power, 
     type="l",
     ylab="Global Active Power",
     xlab="")

# row 1, col 2
with(df, plot(DT, Voltage, type="l", xlab="datetime")) 
    
# row 2, col 1
g <- gl(3, nrow(df), labels=c("sub_metering_1", "sub_metering_2", "sub_metering_3"))
metering <- data.frame(DT=rep(df$DT, 3), 
                       SubType=g, 
                       Metering=c(df$Sub_metering_1, df$Sub_metering_2, df$Sub_metering_3))

with(metering, plot(DT, Metering, type="n", ylab="Energy sub metering", xlab=""))
with(subset(metering, SubType=="sub_metering_1"), lines(DT, Metering, type="l"))
with(subset(metering, SubType=="sub_metering_2"), lines(DT, Metering, type="l", col="red"))
with(subset(metering, SubType=="sub_metering_3"), lines(DT, Metering, type="l", col="blue"))

legend("topright",
       lty=rep(1, 3), col=c("black", "red","blue"), 
       legend=c(levels(g)),
       bty="n", # no border
       cex=0.7, # reduce the legend box size
       y.intersp = 0.5)

# row 2 col 2

with(df, plot(DT, Global_reactive_power, type="l", xlab="datetime"))

# print to a png file
dev.copy(png, file="plot4.png")
dev.off()

