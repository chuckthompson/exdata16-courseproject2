## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 2
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


## Question #2:
##     Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
##     from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# Subset to get just the entries for Baltimore City, Maryland
NEI_Baltimore <- NEI[which(NEI$fips == 24510),]

# Create a table that summarizes the total emissions for each year.
annualEmissions <- ddply(NEI_Baltimore, "year", summarise, Emissions = sum(Emissions))


## Plot the just generated data table as a histogram.

# Open the PNG file to which to save the plot.
png(file="plot2.png",width=480,height=480,bg="transparent")

# Set formatting parameters for the plot
options (scipen=50)  # Prevent y-axis tick labels being printed in scientific notation
par (mar=c(6,6,2,2))  # Increase the left and bottom margins to give more room for the axis labels

# Plot the actual data as a bar plot
barplot (annualEmissions$Emissions, names.arg=annualEmissions$year)

# And label the plot
title (xlab = "Year", ylab = "Total PM2.5 Emissions", main="Baltimore City, Maryland PM2.5 Emissions, 1999-2008")

# Close the PNG device to finish saving the image.
dev.off()