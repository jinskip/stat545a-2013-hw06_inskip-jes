## fake R make script to run scripts 

## clean out any previous work
outputs <- c("ETFDataNormoReact.csv",     # 01_importingETFDataFiles.R
             
             list.files(pattern = "*.png$"))
file.remove(outputs)

## run my scripts
source("01_importingETFDataFiles.R")
