## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 4
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(plyr)       # for ddply
library(ggplot2)    # for ggplot
library(grid)       # for unit function used in theme function

## Question #4:
##     Across the United States, how have emissions from coal
##     combustion-related sources changed from 1999-2008?

## Answer #4:
##     Overall US emissions from coal combustion-related sources have dropped
##     from 1999-2008, most signficantly between 2005 and 2008 following a
##     small increase between 2002 and 2005.

##
## CODE TO SUBMIT GOES BELOW THIS POINT
##

# Read in the two data files.
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")

# First, get all entries where EI.Sector contains "Comb" (i.e. combustion)
filter <- SCC[grep("Comb", SCC$EI.Sector),]

# Now select just the entries where either of Short.Name or EI.Sector contains
# "Coal".  The reason for not just selecting the entries where EI.Sector
# contains "Coal" is that there are a few cases where an "Other" entry in that
# column does have coal listed in Short.Name.  For example, row 477 has the
# EI.Sector type of "Fuel Comb - Residential - Other" and it's Short.Name
# includes "Anthracite Coal".
filter <- filter[union (grep("Coal", filter$Short.Name),
                        grep("Coal", filter$EI.Sector)),]

# The filter just created has the relevant SCC codes for the data entries
# we want.  Use it to select them from the full NEI dataset.
NEI_subset <- NEI[NEI$SCC %in% filter[,"SCC"],]

# Create table summarizing the total emissions for each year.
annualEmissions <- ddply(NEI_subset, "year", summarise,
                         Emissions = sum(Emissions))

# Coerce the year column to type factor for use with ggplot.
annualEmissions$year <- as.factor(annualEmissions$year)

# Open PNG file to save plot to.
png(file="plot4.png",width=960,height=960,bg="transparent")

# Create the base ggplot.
g <- ggplot(annualEmissions, aes(year, Emissions, group=1))

# Increase the left and bottom margins to give more room for the axis labels.
g <- g + theme(plot.margin=unit(c(2,2,1,1),"in"))

# Connect the data points via a line.
g <- g + geom_line(size=2)

# Label and x and y axis.
g <- g + labs(x = "Year") + labs(y = "Total PM2.5 Emissions (in tons)")

# Label the overall plot.
g <- g + 
    labs(title = "Total US PM2.5 Coal Combustion-Related Emissions, 1999-2008")

# Output the plot.
print (g)

# Close the PNG device to finish saving the image.
dev.off()