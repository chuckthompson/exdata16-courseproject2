## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 5
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load libraries with needed functions.
library(reshape2)   # for melt and dcast
library(grid)
library(ggplot2)


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


## Question #5:
##     How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

# Select the entries that contain vehicle in SCC.Level.Two.  This will yield a subset of the entries
# with a Data.Category value of Onroad or Nonroad, the two categories that motor vehicles can be in.
# Those categories also contain some invalid entries for this question, however, such as aircraft.
# Filtering on SCC.Level.Two appears to be an effective way to get entries that fit a fairly
# typical DMV definition of "motor vehicle" while exluding cases that obviously do not fit.
filter <- SCC[grep("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE),]

# The filter just created has the relevant SCC codes for the data entries we want.  Use it to
# select them from the full NEI dataset.
NEI_subset <- NEI[NEI$SCC %in% filter[,"SCC"],]

# Subset to get just the entries for Baltimore City, Maryland
NEI_Baltimore <- NEI_subset[which(NEI_subset$fips == 24510),]

# Create a table that summarizes the total emissions for each year.
annualEmissions <- ddply(NEI_Baltimore, "year", summarise, Emissions = sum(Emissions))

# Coerce the year column to type factor for use with qplot.
annualEmissions$year <- as.factor(annualEmissions$year)

## Plot the just generated data table as a histogram.

# Open the PNG file to which to save the plot.
png(file="plot5.png",width=960,height=960,bg="transparent")

# Create the base ggplot.
g <- ggplot(annualEmissions, aes(year, Emissions, group=1))

# Increase the left and bottom margins to give more room for the axis labels
g <- g + theme(plot.margin=unit(c(2,2,1,1),"in"))

# Make the line connecting the data points be a bit thicker.
g <- g + geom_line(size=2)

# Label and x and y axis.
g <- g + labs(x = "Year") + labs(y = "Total Motor Vehicle Combustion-Related Emissions")

# Label the overall plot
g <- g + labs(title = "Baltimore City, Maryland Motor Vehicle Related PM2.5 Emissions, 1999-2008")

# Output the plot
print (g)

# Close the PNG device to finish saving the image.
dev.off()