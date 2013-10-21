
library(segmented)   ## needed for running the segmented analysis
library(plyr)        ## group aggregation and group graphing
library(minpack.lm)  ## sigmoidal curve fitting
library(lubridate)   ## dealing with time in a sensible manner - avoids POSIXct etc
library(lattice)     ## needed for graphing
library(ggplot2)     ## needed for graphing 

ETFData <- read.csv("ETFDataNormoReact")


## I know there is a way to do this wil colClasses, but I did not want to specify
## ALL of the column types.  I shoould create a vector for this in the future to 
## avoid this step - N.B. this will also speed up 01_importing step
ETFData$subject  <- sprintf("%05s", as.factor(ETFData$subject)) 


## fitting linear, segmented linear and sigmoidal to MCA blood flow velocity 
## and endtidal breathing data  

linETF  <- function (ds) {
  arrange(ds, time)                # this ensures that data is in timeseries order 
                                   # ** only works within subject*condition combinations
  lin <- lm(MCAint ~ ETCO2, ds,    # linear model, subset to start at min ETCO2 to end 
            subset = (time >= time[which.min(ETCO2)])) 
  linVals  <- c(coef(lin)[2], summary(lin)$r.squared, summary(lin)$adj.r.squared)
  names(linVals) <- c("linSlope", "linR^2", "linR^2Adj") 
  return(linVals)
}

linearFits <- ddply(ETFData, ~ subject + group, linETF)

segLinETF  <- function (ds){
  lin <- lm(MCAint ~ ETCO2, ds, subset = (time >= time[which.min(ETCO2)]))
  segLin <- segmented(lin, seg.Z = ~ ETCO2, psi = 30)  #run a piecewise linear fit on xy; start 30   
  segLinVals  <- c(slope(segLin)$ETCO2[1], slope(segLin)$ETCO2[2], 
                   summary(segLin)$r.squared, summary(segLin)$adj.r.squared)
  names(segLinVals) <- c("segLinSlope1", "segLinSlope2", "segLinR^2", "segLinR^2Adj") 
  return (segLinVals)
} 

## using plyr to fit segmented linear fit to all subjects
## failwith is an important funciton here because there are a few subjects
## that do not have a segmentable relationship and the whole plyr call 
## fails otherwise 
segmentedLinearFits  <- ddply(ETFData, ~ subject, failwith(NULL, segLinETF))

sigFit  <- function (ds) {
  x <- ds$ETCO2
  y <- ds$MCAint
  # sigmoidal, 4 parameter fit: gives us the coefficients for the function
  sigmoidFit <- nlsLM(y ~ a + (b/(1+exp(d*(x-c)))) , start = list (a=40, b =130, c=35, d=2))
  xSig = min(x):max(x)                                # using the actual ETCO2 range to create the sigmoid curve
  ySig= coef(sigmoidFit)[1] + (coef(sigmoidFit)[2]/(1+exp(-(xSig-coef(sigmoidFit)[3])/coef(sigmoidFit)[4]))) # calculate the curve using the coefficients in the function
  sigVals  <- coef(sigmoidFit)
  names(sigVals) <- c("sigMaxAsymp", "sigYRange", "sigInflPoint", "sigSlopeIndex") 
  return (sigVals)
}

sigmoidalFits <- ddply(ETFData, ~ subject + group, sigFit)

## combine different fits by subject 
## merge occurs twice (because 3 datasets)
allFitsTable <- merge(linearFits, segmentedLinearFits, 
                      by.x = "subject", by.y = "subject", all = TRUE)
sigmoidalFits$group  <- NULL
allFitsTable <- merge(allFitsTable, sigmoidalFits, 
                      by.x = "subject", by.y = "subject", all = TRUE)
allFitsTable <- arrange(allFitsTable, group, subject)

## write this table to file as will be used for stats etc later on 
write.table(allFitsTable, "allFitsETFReactivityNormoxia", sep = "\t", row.names = FALSE)


ggplot(allFitsTable, aes(x = group, y = linSlope)) +
         geom_point()

linFitByGroup <- ggplot(ETFData, aes(x = ETCO2, y = MCAint, color = subject)) +
                   geom_point() + 
                   geom_smooth(aes(group = subject), method = "lm", se = FALSE) + 
                   facet_wrap(~ group) +
                   theme(legend.position = "none") 
ggsave("linearFitByGroupNormoxia", linFitByGroup)

## individual linear fits for closer identification of individuals
## includes legend 

d_ply(ETFData, ~ group, function(z) {
  group <- z$group
  p <- ggplot(z, aes(x = ETCO2, y = MCAint, color = subject)) +
    ggtitle (paste0("Linear cerebral reactivity at normoxia_", group)) +
    geom_point() + geom_smooth(aes(group = subject), 
                               method = "lm", se = FALSE) + 
    theme(legend.position="bottom")
  print(p)
  group <- gsub(" ", "_", group)
  ggsave(paste0("Linear cerebral reactivity at normoxia_", group, ".png"))
})


## this is the same function as above, but instead of the output being one line
## per subject of coefficient data, it is making a dataframe of the fitted data
## this will then be used to plot fitted and real data 
sigFitPlot  <- function (ds) {
  x <- ds$ETCO2
  y <- ds$MCAint
  # sigmoidal, 4 parameter fit: gives us the coefficients for the function
  sigmoidFit <- nlsLM(y ~ a + (b/(1+exp(-(x-c)/d))), start = list (a=40, b =130, c=35, d=2))
  xSig <- min(x):max(x)                                # using the actual ETCO2 range to create the sigmoid curve
  ySig <- coef(sigmoidFit)[1] + (coef(sigmoidFit)[2]/(1+exp(-(xSig-coef(sigmoidFit)[3])/coef(sigmoidFit)[4]))) # calculate the curve using the coefficients in the function
  data.frame(xSig = xSig, ySig = ySig)
}

## to aggregate the fitted data by subject and group 
sigmoidalFitPlot <- ddply(ETFData, ~ subject + group, sigFitPlot)

## this is a quick and dirty way to look at the shape of the sigmoids 
## between subjects using lattice. Nice to quickly identify ones that might
## need further investigation - somewhat blinded in that don't have group
## names attached at this point 
quickLookSigmoidalNormoxia <- xyplot(ySig ~ xSig | subject, sigmoidalFitPlot, type = "l")
pdf("quickLookSigmoidalNormoxiaBySubject.pdf") # starts writing a PDF to file
plot(quickLookSigmoidalNormoxia)                    # makes the actual plot
dev.off()


allGroupsETFNormoxiaSigmoidal  <- ggplot(sigmoidalFitPlot, 
  aes(x = xSig, y = ySig, color = subject)) +
  geom_line(size = 1) +  
  geom_point(data = ETFData, aes(x = ETFData$ETCO2, y = ETFData$MCAint)) +
  facet_wrap(~ group) +
  theme(legend.position = "none") + 
  ylab("Middle cerebral artery blood flow velocity (MCAv, m/sec)") +
  xlab("End-tidal carbon dioxide (ETCO2, mmHg)") 
  ggsave("sigmoidalAllGroupsETFReactivityNormoxia.pdf", 
       plot = allGroupsETFNormoxiaSigmoidal)





## I have struggled with plotting the segmented line data 
## I know that I can get ggplot to do this.
## I have used goAnywhere to get a look at what exactly the plot.segmented()  
## function is calling when it plots, but I have not yet been able to 
## decipher it. Once I do, I can create a dataset with this information 
## and then ggplot can call this dataset to generate the plot 

segLinGraph <- function (ds){
  lin <- lm(MCAint ~ ETCO2, ds, subset=(time >= time[which.min(ETCO2)]))
  segLin <- segmented(lin, seg.Z = ~ ETCO2, psi=30)  #run a piecewise linear fit on xy; start 30   
  plot (segLin)
}   

testSegLinGraph  <- segLinGraph(subset(ETFData, subject == "00812"))


