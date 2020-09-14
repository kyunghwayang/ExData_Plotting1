library(dplyr)

# Read a subset of the data (2007-02-01 to 2007-02-02)
file <- "household_power_consumption.txt"
df <- read.table(file, header=TRUE, sep=";") %>%
        filter (Date %in% c("1/2/2007", "2/2/2007"))

df <- df %>% filter(Sub_metering_1!="?" & Sub_metering_2 != "?" & Sub_metering_3 != "?")

# strptime (charstring, format): converts character string to POSIXlt class.
df$DT <- strptime (paste(df$Date, df$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)


# make a new data frame: DT and Sub_metering
g <- gl(3, nrow(df), labels=c("sub_metering_1", "sub_metering_2", "sub_metering_3"))
metering <- data.frame(DT=rep(df$DT, 3), 
                       SubType=g, 
                       Metering=c(df$Sub_metering_1, df$Sub_metering_2, df$Sub_metering_3))


with(metering, plot(DT, Metering, type="n", ylab="Energy sub metering", xlab=""))
with(subset(metering, SubType=="sub_metering_1"), lines(DT, Metering, type="l"))
with(subset(metering, SubType=="sub_metering_2"), lines(DT, Metering, type="l", col="red"))
with(subset(metering, SubType=="sub_metering_3"), lines(DT, Metering, type="l", col="blue"))
legend("topright", lty=1, col=c("black", "red","blue"), legend=c(levels(g)), y.intersp =0.5)


dev.copy(png, file="plot3.png")
dev.off()
