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
  
  # Read the data about motor vehicles emmission
  vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
  vehiclesSCC <- SCC[vehicles,]$SCC
  vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]
  
  # Get the Baltimore data
  baltimoreVehiclesNEI <- vehiclesNEI[vehiclesNEI$fips==24510,]
  
  # Initialize the graphic file device to be used
  png("plot5.png", width=480, height=480)
  
  ggp <- ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
    geom_bar(stat="identity",fill="grey",width=0.75) +
    theme_bw() +  guides(fill=FALSE) +
    labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
    labs(title=expression("PM"[2.5]*" Emissions of Motor Vehicle Source, Baltimore (1999-2008)"))
  
  print(ggp)
  
  # Close the file service
  dev.off()
}