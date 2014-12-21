## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 5
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(plyr)       # for ddply
library(ggplot2)    # for ggplot
library(grid)       # for unit function used in theme function

## Question #5:
##     How have emissions from motor vehicle sources changed from 1999-2008
##     in Baltimore City?

## Answer #5:
##     Emissions from motor vehicle sources in Baltimore City have decreased
##     from 1999 to 2008 with the most substantial reduction occurring
##     between 1998 and 2002.

##
## CODE TO SUBMIT GOES BELOW THIS POINT
##

# Read in the two data files.
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")

# Select the entries that contain vehicle in SCC.Level.Two.  This will yield a
# subset of the entries with a Data.Category value of Onroad or Nonroad, the
# two categories that motor vehicles can be in.  Those categories also contain
# some invalid entries for this question, however, such as aircraft.  Filtering
# on SCC.Level.Two appears to be an effective way to get entries that fit a
# fairly typical DMV definition of "motor vehicle" while exluding cases that
# obviously do not fit.
filter <- SCC[grep("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE),]

# The filter just created has the relevant SCC codes for the data entries
# we want.  Use it to select them from the full NEI dataset.
NEI_subset <- NEI[NEI$SCC %in% filter[,"SCC"],]

# Subset to get just the entries for Baltimore City, Maryland.
NEI_Baltimore <- NEI_subset[which(NEI_subset$fips == 24510),]

# Create table summarizing the total emissions for each year.
annualEmissions <- ddply(NEI_Baltimore, "year", summarise,
                         Emissions = sum(Emissions))

# Coerce the year column to type factor for use with ggplot.
annualEmissions$year <- as.factor(annualEmissions$year)

# Create table summarizing the total emissions for each year.
png(file="plot5.png",width=960,height=960,bg="transparent")

# Create the base ggplot.
g <- ggplot(annualEmissions, aes(year, Emissions, group=1))

# Increase the left and bottom margins to give more room for the axis labels.
g <- g + theme(plot.margin=unit(c(2,2,1,1),"in"))

# This time we'll display the data as a bar plot.
g <- g + geom_bar(stat="identity", fill="red")

# Label and x and y axis.
g <- g + labs(x = "Year") +
    labs(y = "Total Motor Vehicle PM2.5 Combustion-Related Emissions (in tons)")

# Label the overall plot
g <- g +
    labs(title = "Baltimore City, Maryland Motor Vehicle Related PM2.5 Emissions, 1999-2008")

# Output the plot.
print (g)

# Close the PNG device to finish saving the image.
dev.off()