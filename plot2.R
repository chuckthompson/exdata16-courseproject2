## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 2
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(plyr)   # for ddply

## Question #2:
##     Have total emissions from PM2.5 decreased in the Baltimore City,
##     Maryland (fips == "24510") from 1999 to 2008? Use the base plotting
##     system to make a plot answering this question.

## Answer #2:
##     The plot shows that overall, total emissions from PM2.5 in
##     Baltimore City have decreased from 1998 to 2008, though it was not a
##     straight line decrease as was observed with the US overall.

##
## CODE TO SUBMIT GOES BELOW THIS POINT
##

# Read in the two data files.
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")

# Subset to get just the entries for Baltimore City, Maryland.
NEI_Baltimore <- NEI[which(NEI$fips == 24510),]

# Create table summarizing the total emissions for each year.
annualEmissions <- ddply(NEI_Baltimore, "year", summarise,
                         Emissions = sum(Emissions))

# Open PNG file to save plot to and set formatting parameters for it.
png(file="plot2.png",width=480,height=480,bg="transparent")

# Plot the data as a bar plot with the plot appropriately labeled.
barplot (annualEmissions$Emissions, names.arg=annualEmissions$year)
title (xlab = "Year", ylab = "Total PM2.5 Emissions (in tons)",
       main="Total Baltimore City, Maryland PM2.5 Emissions, 1999-2008")

# Close the PNG device to finish saving the image.
dev.off()