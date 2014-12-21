## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 3
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(reshape2)   # for melt and dcast
library(ggplot2)    # for ggplot
library(grid)       # for unit function used in theme function

## Question #3:
##     Of the four types of sources indicated by the type (point, nonpoint,
##     onroad, nonroad) variable, which of these four sources have seen
##     decreases in emissions from 1999-2008 for Baltimore City?  Which have
##     seen increases in emissions from 1999-2008? Use the ggplot2 plotting
##     system to make a plot answer this question.

## Answer #3:
##     The NON-ROAD, NONPOINT, and ON-ROAD emissions sources have all seen at
##     least small decreases in Baltimore City, Maryland from 1998-2008.  The
##     POINT emissions source has seen a small overall increase in that
##     timeframe, which includes significant increases between 1999/2002 and
##     2002/2005 before dropping back down in 2008 to close to its 1999 value.

##
## CODE TO SUBMIT GOES BELOW THIS POINT
##

# Read in the two data files.
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")

# Subset to get just the entries for Baltimore City, Maryland.
NEI_Baltimore <- NEI[which(NEI$fips == 24510),]

# Create table summarizing the total emissions for each year by source type.
dataMelt <- melt (NEI_Baltimore, id.vars=c("year", "type"),
                  measure.vars=c("Emissions"))
annualEmissions <- dcast (dataMelt, year + type ~ variable, sum)

# Coerce the year and type columns to type factor for use with ggplot.
annualEmissions$year <- as.factor(annualEmissions$year)
annualEmissions$type <- as.factor(annualEmissions$type)
colnames(annualEmissions)[2] <- c("Source") # re-label type column

# Open PNG file to save plot to.
png(file="plot3.png",width=720,height=960,bg="transparent")

# Create base ggplot.  Specify the grouping to be by type (so that the data
# points are connected by lines) and specify that type data is to be in color.
g <- ggplot(annualEmissions, aes(year, Emissions, color=Source, group=Source))

# Increase the left and bottom margins to give more room for the axis labels.
g <- g + theme(plot.margin=unit(c(2,2,1,1),"in"))

# Connect the data points via a line.
g <- g + geom_line(size=1)

# Display the data for each type in a separate panel.
g <- g + facet_grid(Source ~ .)

# Label the x and y axis.
g <- g + labs(x = "Year") + labs(y = "Total PM2.5 Emissions (in tons)")

# Label the overall plot.
g <- g + labs(title = "Baltimore City, Maryland PM2.5 Emissions, 1999-2008, By Source")

# Output the plot.
print (g)

# Close the PNG device to finish saving the image.
dev.off()