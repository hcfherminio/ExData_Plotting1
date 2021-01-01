#plot 1
#first reading only the two rows that we are interested using fread and grep
library(data.table)
library(dplyr)
library(lubridate)
 
#getting column name since grep will not hold this information
coln<-colnames(fread(cmd="grep '^Date' household_power_consumption.txt",sep=";",na.strings = "?"))
#reading only two days that we are using Feb 1 and 2 2007
dat <- fread(cmd="grep -E '^1/2/2007|^2/2/2007' household_power_consumption.txt",sep=";",na.strings = "?")
#getting colnames back again
colnames(dat)<-coln

#getting a better time column (including date and hours in a single column)
#easier to convert to date class
dat<- dat%>%
      mutate(Time=paste(Date,Time)) %>%#getting complete Time
      select(-Date)%>%#removing column that is not going to be used
      mutate(Time=dmy_hms(Time))#getting dates in the right format (POSIXct)

#now lets do plot number 2!
#using basic plot of time series
quartz(height = 7,width = 7 )#graphic device (72dpi around 7 inches)
with(dat,plot(Time,Global_active_power,type="l",
              lty=1,col="darkgreen",
              ylab="Global Active Power (kilowatts)"))
dev.copy(png,file="figure/plot2.png")
dev.off()
