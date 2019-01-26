# Libraries needed for the functions to run
library(ggplot2)
library(RColorBrewer)

# Check if the data needed is already available
if(!file.exists("airpollution")) {
  # Create a directory where your data will be put
  dir.create("./airpollution")
  # Set the url where the data set will be
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  # Download and unzip the file:
  download.file(url, destfile = "./airpollution.zip" )
  unzip("./airpollution.zip", exdir = "./airpollution" )
} else {
  # Load the data:
  NEI <- readRDS("./airpollution/summarySCC_PM25.rds")
  SCC <- readRDS("./airpollution/Source_Classification_Code.rds")
  
  totals <- aggregate(Emissions ~ year,NEI, sum)
  
  # Initialize the graphic file device to be used
  png("plot1.png", width=480, height=480)
  
  barplot(totals$Emissions, xlab="Year", ylab="PM2.5 Emissions (Tons)", main = "PM2.5 Emission Totals From All US Sources", names.arg = totals$year)
  
  # Close the file service
  dev.off()
}