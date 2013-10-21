stat545a-2013-hw06_inskip-jes
=============================

Homework_06

I have tried to make this example as close as possible to my own lab workflow. 
We combine a number of different physiological signals from different pieces of equipment into one proprietary software
program (LabChart).  I then export as a .csv file after testing.  I have one .csv file for each subject that we test.  


Instructions for use: 

Download into an empty directory (I would do this using Download ZIP option):

* Input data: [`00812_normoxia`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/00812_normoxia)
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

* Scripts: [`01_importingETFDataFiles.R`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/01_importingETFDataFiles.R)
            and [`02_ETFCurveFitting`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/02_ETFCurveFitting.R)

* Makefile-like script: [`Makefile.R`](https://github.com/jinskip/stat545a-2013-hw06_inskip-jes/blob/master/makeFile.R)


Open R and start a fresh RStudio session:

* Set working directory to location where files have been downloaded

    Open makeFile.R, and click on "Source"
