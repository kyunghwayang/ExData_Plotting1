library(dplyr)

# Read a subset of the data (2007-02-01 to 2007-02-02)
file <- "household_power_consumption.txt"
df <- read.table(file, header=TRUE, sep=";") %>%
        filter (Date %in% c("1/2/2007", "2/2/2007"))



df$Global_active_power <- as.numeric(df$Global_active_power)


hist(df$Global_active_power,
        col="red", breaks=12, 
        main="Global Active Power",
        xlab="Global Active Power(kilowatts)")

dev.copy(png, file="plot1.png")
dev.off()
