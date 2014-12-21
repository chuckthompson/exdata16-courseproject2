## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 1
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(plyr)   # for ddply

## Question #1:
##     Have total emissions from PM2.5 decreased in the United States from
##     1999 to 2008?  Using the base plotting system, make a plot showing the
##     total PM2.5 emission from all sources for each of the years 1999, 2002,
##     2005, and 2008.

## Answer #1:
##     The plot shows that total emissions from PM2.5 did decrease in the US
##     from 1999 to 2008, with at least a small drop between every year
##     in the dataset.

##
## CODE TO SUBMIT GOES BELOW THIS POINT
##

# Read in the two data files.
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")

# Create table summarizing the total emissions for each year.
annualEmissions <- ddply(NEI, "year", summarise, Emissions = sum(Emissions))

# Open PNG file to save plot to and set formatting parameters for it.
png(file="plot1.png",width=480,height=480,bg="transparent")
options (scipen=50)  # Prevent y-axis tick labels in scientific notation

# Plot the data as a bar plot with the plot appropriately labeled.
barplot (annualEmissions$Emissions, names.arg=annualEmissions$year)
title (xlab = "Year", ylab = "Total PM2.5 Emissions (in tons)",
       main="Total US PM2.5 Emissions, 1999-2008")

# Close the PNG device to finish saving the image.
dev.off()