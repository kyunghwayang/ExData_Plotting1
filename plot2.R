library(dplyr)

# Read a subset of the data (2007-02-01 to 2007-02-02)
file <- "household_power_consumption.txt"
df <- read.table(file, header=TRUE, sep=";") %>%
        filter (Date %in% c("1/2/2007", "2/2/2007"))

df <- df %>% filter(Global_active_power !="?")

# strptime (charstring, format): converts character string to POSIXlt class.
df$DT <- strptime (paste(df$Date, df$Time, sep=" "), "%d/%m/%Y %H:%M:%S")


# Convert Global Active Powe to numeric.
df$Global_active_power <- as.numeric(df$Global_active_power)


plot(df$DT, df$Global_active_power, 
     type="l",
     ylab="Global Active Power (kilowatts)",
     xlab="")

dev.copy(png, file="plot2.png")
dev.off()
