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
  vehiclesBaltimoreNEI <- vehiclesNEI[vehiclesNEI$fips == 24510,]
  vehiclesBaltimoreNEI$city <- "Baltimore City"
  vehiclesLANEI <- vehiclesNEI[vehiclesNEI$fips=="06037",]
  vehiclesLANEI$city <- "Los Angeles"
  bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI)
  
  # Initialize the graphic file device to be used
  png("plot6.png", width=480, height=480)
  
  ggp <- ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
    geom_bar(aes(fill=year),stat="identity") +
    facet_grid(scales="free", space="free", .~city) +
    guides(fill=FALSE) + theme_bw() +
    labs(x="year", y=expression("PM"[2.5]*" Emission (Kilo-Tons)")) + 
    labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions, Baltimore & LA (1999-2008)"))
  
  print(ggp)
  
  # Close the file service
  dev.off()
}