library(plyr)      # for data aggregation
library(reshape2)  # for function colsplit() 
library(lubridate) # for working with time ms()

setwd("~/Rwork/ETF/Ranalyses")

dataImport  <- function(ds) {

# read in all csv files by making a list with all normoxic files
   ds <- ldply(list.files(pattern = "_normoxia"), function(filename) {                   
      dat <- read.csv(filename, as.is = ("Time"))     ## don't make Time a factor
      dat$subj <- sub("^([^.]*).*", "\\1", filename)  ## add filename col no suffix
      return(dat)
      }) 
   ## splits subj into subject and condition (sep _)
   ds <- cbind(ds, colsplit(ds$subj, "_", 
                            c('subject', 'condition')))   

   ## remove split col (could improve by not duplicating)    
   ds$subj  <- NULL                               

   ## treats subject number as factor which helps with graphing 
   ## as should be non-continuous and adds leading zeros to subject   
   ds$subject  <- sprintf("%05s", as.factor(ds$subject))  

   ## remove extra lines with NA in cols 1 through 4 excel nonsense 
   ds <- ds[complete.cases(ds[,1:4]), ]                   
   
   ## remove meaningless variables that we have been dragging around!
   ds <- subset(ds, select = -c(PETCO2_mean, PETO2_mean)) 

}

ETFDataNormo <- dataImport(ETFData)

## data tidying from awful excel work that was done previously 
## this is not pretty, but wouldn't work properly inside main function

ETFDataNormo$X  <- NULL   ## removing extra cols from excel nonsense 
ETFDataNormo$X.1 <- NULL  ## note this was better than choosing cols to keep by number
ETFDataNormo$X.2 <- NULL
ETFDataNormo$X.3 <- NULL

## taking control of my time
ETFDataNormo$Time  <- ms(ETFDataNormo$Time)   ## converts time to R version of time (minutes seconds)

## taking control of column titles by replacing them with sensible ones 
## creating and using a lookup table so can easilly be used again

lookup <- data.frame(current = c("Time", "SAP", "DAP", "MAP", "ECG_bpm",
                                "ECG_period", "MCAv_MAP", "MCAv_SAP",
                                "MCAv_DAP", "Flow_bpm", "O2sat", "TPR", "SV", 
                                 "CO", "Flow_height", "Comment", 
                                 "MCAv_meanint", "ETCO2", "ETO2", 
                                 "X6s.shift.MCAv_meanint", "Inspired.volume", 
                                 "subject", "condition"),
                     replacement = c("time", "SAP", "DAP", "MAP", "ECGbpm", 
                                     "ECGper", "MCAmean", "MCAmax", "MCAmin", 
                                     "flowBpm", "O2Sat", "TPR", "SV", "CO", 
                                     "flowHeight", "comment", "MCAint", 
                                     "ETCO2", "ETO2", "MCAint6s", "inspVol", 
                                     "subject", "condition") )

colnames(ETFDataNormo) <- lookup$replacement[
                                  match(colnames(ETFDataNormo), 
                                  lookup$current)
                                  ]

# add in group information from look up table already created
# with subject number and group information
ETFlookup <- read.delim("lookupTableETF", sep = ",")
ETFDataNormoReact  <-  join(ETFDataNormo, ETFlookup, by = 'subject')


## while all this data might be needed at some point for this particular 
## analysis I am only interested in a subset that runs from the minimum
## ETCO2 to the end of the file. Here is this defined by the time being 
## greater or equal to the time at the minETCO2 

minETFToEnd  <- function (ds) {
  subset(ds, subset = ds$time >= ds$time[which.min(ds$ETCO2)])
}

ETFDataNormoReact  <- ddply(ETFDataNormoReact, ~ subject + group, minETFToEnd)



## reorder data 
ETFDataNormoReact <- arrange(ETFDataNormoReact, group, subject)

## write data to csv file 
write.csv(ETFDataNormoReact, "ETFDataNormoReact", row.names = FALSE) 

# other files for hypoxia and hyperoxia will be created and named accordingly
# at a later date


