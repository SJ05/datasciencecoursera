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
  
  # Read the data about coal combustion-realted sources
  combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
  coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
  coalCombustion <- (combustionRelated & coalRelated)
  combustionSCC <- SCC[coalCombustion,]$SCC
  combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]
  
  # Initialize the graphic file device to be used
  png("plot4.png", width=480, height=480)
  
  ggp <- ggplot(combustionNEI,aes(factor(year),Emissions/10^5)) +
    geom_bar(stat="identity",fill="grey",width=0.75) +
    theme_bw() +  guides(fill=FALSE) +
    labs(x="year", y=expression("US Total PM"[2.5]*" Emission (10^5 Tons)")) + 
    labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions, US (1999-2008)"))
  
  print(ggp)
  
  # Close the file service
  dev.off()
}