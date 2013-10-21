## fake R make script to run scripts 
## realistically, this is probably where I will end up with my day-to-day
## analyses - I don't see myself using make 

## clean out any previous work
outputs <- c("ETFDataNormoReact.csv",                       # 01_importingETFDataFiles.R
             "overviewFigure_ETFDataNormoReact.pdf",        # 01_importingETFDataFiles.R
             "allFitsETFReactivityNormoxia.csv",            # 02_ETFCurveFitting.R
             "quickLookSigmoidalNormoxiaBySubject.pdf",     # 02_ETFCurveFitting.R 
             "sigmoidalallGroupsETFReactivityNormoxia.pdf", # 02_ETFCurveFitting.R
             list.files(pattern = "*.png$"))                # 02_ETFCurveFitting.R
file.remove(outputs)

## run my scripts
source("01_importingETFDataFiles.R")
source("02_ETFCurveFitting.R")
