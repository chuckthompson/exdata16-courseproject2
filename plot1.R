## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 1
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(plyr)   # for ddply


# Read in the two data files.
NEI_file <- "summarySCC_PM25.rds"
SCC_file <- "Source_Classification_Code.rds"

if (file.exists(NEI_file)) {
    NEI <- readRDS(NEI_file)
} else {
    stop ("Data file ", NEI_file, "not in current working directory.")
}
if (file.exists(SCC_file)) {
    SCC <- readRDS(SCC_file)
} else {
    stop ("Data file ", SCC_file, "not in current working directory.")
}


## Question #1:
##     Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
##     Using the base plotting system, make a plot showing the total PM2.5 emission from all sources
##     for each of the years 1999, 2002, 2005, and 2008.

# Create a table that summarizes the total emissions for each year.
annualEmissions <- ddply(NEI, "year", summarise, Emissions = sum(Emissions))


## Plot the just generated data table as a histogram.

# Open the PNG file to which to save the plot.
png(file="plot1.png",width=480,height=480,bg="transparent")

# Set formatting parameters for the plot
options (scipen=50)  # Prevent y-axis tick labels being printed in scientific notation
par (mar=c(6,6,2,2))  # Increase the left and bottom margins to give more room for the axis labels

# Plot the actual data as a bar plot
barplot (annualEmissions$Emissions, names.arg=annualEmissions$year)

# And label the plot
title (xlab = "Year", ylab = "Total PM2.5 Emissions", main="US PM2.5 Emissions, 1999-2008")

# Close the PNG device to finish saving the image.
dev.off()