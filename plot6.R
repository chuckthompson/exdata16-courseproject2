## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 6
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(plyr)       # for ddply
library(ggplot2)    # for ggplot
library(grid)       # for unit function used in theme function

## Question #6:
##     Compare emissions from motor vehicle sources in Baltimore City with
##     emissions from motor vehicle sources in Los Angeles County, California
##     (fips == "06037"). Which city has seen greater changes over time in
##     motor vehicle emissions?

## Answer #6:
##     Los Angeles County has clearly seen the greater changes in emissions
##     from motor vehicles from 1999 to 2008.  Baltimore City has been on a
##     steady decline, having around half the emissions in 2008 that it did in
##     1999.  Los Angeles County, by comparison, has higher total emissions in
##     2008 than it did in 1999 with even higher totals in the two
##     intermediate data point years of 2002 and 2005.

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
NEI_Baltimore <- NEI_subset[which(NEI_subset$fips == "24510"),]

# Subset to get just the entries for Los Angeles County, California.
NEI_LosAngeles <- NEI_subset[which(NEI_subset$fips == "06037"),]

# Create table summarizing the total emissions for each year.
annualEmissions <- ddply(NEI_Baltimore, "year", summarise,
                         Location = "Baltimore City",
                         Emissions = sum(Emissions))
annualEmissions <- rbind(annualEmissions, 
                         ddply(NEI_LosAngeles, "year", summarise,
                               Location = "Los Angeles County",
                               Emissions = sum(Emissions)))

# Coerce the year column to type factor for use with ggplot.
annualEmissions$year <- as.factor(annualEmissions$year)

# Open PNG file to save plot to.
png(file="plot6.png",width=960,height=960,bg="transparent")

# Create the base ggplot.  Specify the grouping to be by Location.
g <- ggplot(annualEmissions,
            aes(year, Emissions, color=Location, group=Location))

# Increase the left and bottom margins to give more room for the axis labels.
g <- g + theme(plot.margin=unit(c(2,2,1,1),"in"))
g <- g + theme_bw()

# Display the data as a bar plot, this time with each year a different color.
g <- g + geom_bar(stat="identity", aes(fill=year))

# With each location in its own plot.
g <- g + facet_grid(. ~ Location)

# Label and x and y axis.
g <- g + labs(x = "Year") +
    labs(y = "Total Motor Vehicle PM2.5 Combustion-Related Emissions (in tons)")

# Label the overall plot
g <- g +
    labs(title = "Baltimore City & Los Angeles County Motor Vehicle Related PM2.5 Emissions, 1999-2008")

# Output the plot
print (g)

# Close the PNG device to finish saving the image.
dev.off()