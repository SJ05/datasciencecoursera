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
  
  baltimoreNEI <- NEI[NEI$fips=="24510",]
  
  # Initialize the graphic file device to be used
  png("plot3.png", width=550, height=480)
  
  ggp <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
    geom_bar(stat="identity") +
    facet_grid(.~type,scales = "free",space="free") + 
    labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
    labs(title=expression("PM"[2.5]*" Emissions by Source Type, Baltimore City (1999-2008)"))
  
  print(ggp)
  
  # Close the file service
  dev.off()
}