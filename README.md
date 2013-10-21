stat545a-2013-hw06_inskip-jes
=============================

Homework_06: Final Project on workflow and automating R functions

I have tried to make this example as close as possible to my own lab workflow - i.e. it is imperfect in some ways! 
We combine a number of different physiological signals from different pieces of equipment into one proprietary software
program (LabChart).  I then export as a .csv file after testing.  I have one .csv file for each subject that we test. 
In this case, the .csv files have been opened and saved as .csv files in excel - as is common in my lab - therefore, I 
have spent a great deal of my time working on the first script that cleans this data.  This was a valuable exercise 
in learning how to manipulate messy data without the artisanal excel work, which is a specialty of my current supervisor. 

The data were recorded while subjects were supine and we were controlling the gasses that they breathe on a 
breath-by-breath basis (also known as end-tidal forcing or ETF).  

Subjects were individuals with no neurological damage (Controls), individuals with incomplete spinal cord 
injury (Incomplete), and individuals with complete high-level spinal cord injury (Complete). 

The main outcome measure is how the blood flow to the brain is altered by different levels of carbon dioxide (CO2).  
We know that the cerebral vasculature is sensitive to changes in CO2 (a vasoconstrictor) and we suspect that the 
sensitivity might be altered in individuals with complete spinal cord injury that disrupts the nerves that control the 
blood vessels in the brain.  The main two parameters that we are working with in this example are: end-tidal CO2 (ETCO2) 
which is the peak CO2 levels that you breathe out at the end of an exhale, and middle cerebral artery blood flow 
velocity (MCAv) which is used as a surrogate measure for blood flow as the vessel that we are investigating has been 
shown not to change diameter very much. 



Instructions for use: 

Download into an empty directory (I would do this using Download ZIP option - or clone to Desktop):

* Input data (subjectNumber_condition): 
              [`00812_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/00812_normoxia)
              [`03261_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/03261_normoxia)
              [`04670_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/04670_normoxia)
              [`04744_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/04744_normoxia)
              [`12106_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/12106_normoxia)
              [`14596_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/14596_normoxia)
              [`16239_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/16239_normoxia)
              [`16508_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/16508_normoxia)
              [`20852_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/20852_normoxia)
              [`25196_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/25196_normoxia)
              [`27628_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/27628_normoxia)
              [`36460_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/36460_normoxia)
              [`41078_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/41078_normoxia)
              [`43306_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/43306_normoxia)
              [`44016_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/44016_normoxia)
              [`56299_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/56299_normoxia)
              [`56652_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/56652_normoxia)
              [`60867_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/60867_normoxia)
              [`63606_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/63606_normoxia)
              [`70375_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/70375_normoxia)
              [`75190_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/75190_normoxia)
              [`75807_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/75807_normoxia)
              [`78430_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/78430_normoxia)
              [`78984_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/78984_normoxia)
              [`80068_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/80068_normoxia)
              [`85053_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/85053_normoxia)
              [`89336_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/89336_normoxia)

* Scripts: [`01_importingETFDataFiles.R`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/01_importingETFDataFiles.R)
            and [`02_ETFCurveFitting`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/02_ETFCurveFitting.R)

* Makefile-like script: [`Makefile.R`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/makeFile.R)


Open R and start a fresh RStudio session:

* Set working directory to location where files have been downloaded
* Open makeFile.R 
* Run makeFile.R

Output files should include: 
* Cleaned data: 
* Table with fits (linear, segmented linear, sigmoidal): [`allFitsETFReactivityNormoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/allFitsETFReactivityNormoxia)
  This will be useful to help us determine which fits we use for further analysis, and can be used to create figures directly 

* Figure 01: Quick xyplot of all subjects to review shape, outliers: [`overviewFigure_ETFDataNormoReact.pdf`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/overviewFigure_ETFDataNormoReact.pdf)
* Figure 02: Quick overview of sigmoid fits: [`quickLookSigmoidalNormoxiaBySubject.pdf`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/quickLookSigmoidalNormoxiaBySubject.pdf)
* Figure 03: Linear cerebral reactivity by group: Controls [`Linear cerebral reactivity at normoxia_control.png`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/Linear%20cerebral%20reactivity%20at%20normoxia_control.png)
* Figure 04: Linear cerebral reactivity by group: Complete SCI [`Linear cerebral reactivity at normoxia_complete.png`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/Linear%20cerebral%20reactivity%20at%20normoxia_complete.png)
* Figure 05: Linear cerebral reactivity by group: Incomplete SCI [`Linear cerebral reactivity at normoxia_incomplete.png`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/Linear%20cerebral%20reactivity%20at%20normoxia_incomplete.png)
* Figure 06: Sigmoidal cerebral reactivity by group: all groups [`sigmoidalAllGroupsETFReactivityNormoxia.pdf`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/sigmoidalAllGroupsETFReactivityNormoxia.pdf)


It should be said that these are all kind of mid-stage exploratory figures - none of which are ready for print!


There are some errors to be expected due to the fact that all types of fits do not work with all datasets.  
The segmented line fitting in particular has three errors from datasets that it will not work on.  With the failwith() 
function these errors do not derail the whole analysis, and it is OK that they fail because they just have no breaks 
(or the breaks occur too close to the start or end). 

When running the makeFile.R for the first time, there will be some error messages to do with deleting files that do 
not yet exist. 
