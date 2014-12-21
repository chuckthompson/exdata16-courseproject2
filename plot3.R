## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 2 - Question 3
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


## Question #3:
##     Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
##     which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?
##     Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a
##     plot answer this question.


# Subset to get just the entries for Baltimore City, Maryland
NEI_Baltimore <- NEI[which(NEI$fips == 24510),]

# Create a table that summarizes the total emissions for each year by source type.
dataMelt <- melt (NEI_Baltimore, id.vars=c("year", "type"), measure.vars=c("Emissions"))
annualEmissions <- dcast (dataMelt, year + type ~ variable, sum)

# Coerce the year and type columns to type factor for use with qplot.
annualEmissions$year <- as.factor(annualEmissions$year)
annualEmissions$type <- as.factor(annualEmissions$type)

## Plot the just generated data table as a histogram.

# Open the PNG file to which to save the plot.
png(file="plot3.png",width=960,height=960,bg="transparent")

# Create the base ggplot.  Specify the grouping to be by type (so that the data points are
# connected by lines) and also specify that we want the type data to be in color.
g <- ggplot(annualEmissions, aes(year, Emissions, color=type, group=type))

# Increase the left and bottom margins to give more room for the axis labels
g <- g + theme(plot.margin=unit(c(2,2,1,1),"in"))

# Make the line connecting the data points be a bit thicker.
g <- g + geom_line(size=2)

# Display the data for each type in a separate panel.
g <- g + facet_grid(type ~ .)

# Label and x and y axis.
g <- g + labs(x = "Year") + labs(y = "Total PM2.5 Emissions")

# Label the overall plot
g <- g + labs(title = "Baltimore City, Maryland PM2.5 Emissions, 1999-2008, By Source")

# Output the plot
print (g)

# Close the PNG device to finish saving the image.
dev.off()