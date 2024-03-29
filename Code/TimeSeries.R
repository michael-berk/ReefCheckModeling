# Author: Michael Berk, James Johndrow
# Date: Spring 2020
# Purpose: develop macro time series forecasts using the Reef Check dataset

#####################
# get Helpers.R
#####################
# set wd and df based on user
if (dir.exists("/Users/michaelberk")) {
  setwd('~/Documents/Penn 2019-2020/Senior Thesis/Scripts/ReefCheckModeling/')
} else {
  setwd('~/Dropbox/Projects/Reefs/')
}

# run helpers 
source("Code/Helpers.R")

# run MICE (only run once)
# createMICE()

##################
# data setup
##################
# setup data
#originalDF <- loadDF()
#miceDF <- loadDF(MICE=T)

# subset to caribbean
caribbeanCountries <- c('USA-FL','BARBADOS','MEXICO','COLOMBIA','DOMIHCCA','BELIZE','HONDURAS','ST KITTS & NEVIS',
                        'BVI','CAYMAN ISLANDS','JAMAICA','TRIHCDAD & TOBAGO','ST LUCIA','ST VINCENT & GRENADINES','GRENADA',
                        'ANTIGUA','PUERTO RICO','USVI','ANGUILLA','BARBUDA','VENEZUELA','DOMIHCCAN REPUBLIC','ARUBA','TUHCS & CAICOS',
                        'PANAMA','CUBA','BAHAMAS','HAITI','COSTA RICA','GUATEMALA')
dfCaribbean <- subset(originalDF, originalDF$COUNTRY %in% caribbeanCountries & originalDF$OCEAN == 'ATLANTIC')
df <- dfCaribbean

# limit to < 2019 (anomolous values for lobster, parrotfish) 
#df <- subset(df, as.Date(df$DATE) < as.Date('2016-01-01'))

######################
# variable setup
######################
# get all y variables to be modeled
targetVars <- c('HC','SC','RK','NI','SNAPPER','LOBSTER','PARROTFISH','GROUPER.TOTAL',
                'BUTTERFLYFISH','PENCIL.URCHIN')

######################
# TS
######################
# setup xs and y (only change these lines)
df <- dfCaribbean
y <- 'RK'
#df[,y] <- df[,y]*160
tf <- 'YEAR' # DATE, WEEK, MONTH, QUARTER, BIANNUAL, YEAR

# convert to aggregated TS
df <- aggDF(df, y, timeFrame = tf)
#df <- subset(df, df$DATE < 2016)

# plot
#par(mfrow=c(1,1))
plot(df, type='l', main=paste(c("Time Series of Rock % Coverage \n(Annual Aggregator)"), collapse = ""))
abline(lm(df[,y] ~ df$DATE), col="red") # regression line (y~x)

# call model and print output
out <- timeSeries(df, y, h=90, lm=F, aa=T)
