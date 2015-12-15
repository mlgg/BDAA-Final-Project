####BDAA-Final-Project

Components of README.md

	1. General Information About BDAA-Final-Project Contents
	2. Definition of Problem
	3. Definition of Software
	4. Results
	5. Reproducibility

======================================================================================================================================
####General Information About BDAA-Final-Project Contents

The relevant project files in this repository include:

	1. Data files:
		
		a) "Water_Right_Applications.csv" 
				- (https://data.wa.gov/Natural-Resources-Environment/Water-Right-Applications/9ubz-5r4b) 
    		- this dataset contains all relevant information taken from Water Right Applications in Washington State, and includes the following fields:

        		1.  "WR_DOC_ID" -- database key for the document                        
        		2.  "DOCUMENT_NUMBER" -- Washington State document ID number
        	  3.  "DOCUMENT_TYPE" -- indicates whether the application is new or a change to an existing water right
        	  4.  "PURPOSE_CODE_LIST" -- short code indicating the purpose for which the water is to be used
        	  5.  "PERSON_LAST_OR_ORGANIZATION_NAME" -- name of person/organization making the application
        	  6.  "PRIORITY_DATE" -- date on which the application was made
        	  7.  "YEAR_APPLIED" -- year in which the applciation was made
        	  8.  "CFS" -- cubic feet per second water flow at this source
        	  9.  "GPM" -- gallons per minute water flow at this source
        	  10. "DOMESTIC_UNITS" -- number of residential connections to be made to this source
        	  11. "ACRE_FEET" -- acre feet water volume from this source
        	  12. "ACRE_IRR" -- acres to be irrigated by this source
        	  13. "COUNTY_NAME" -- county in which the source is located
        	  14. "WRIA_NUMBER" -- watershed identification number
        	  15. "WATERSHED" -- name of watershed supplying source
        	  16. "CERT_NUM" -- certification number, no further explanation provided
        	  17. "TRS" -- no explanation provided
        	  18. "QUAD_DESIGNATION" -- designation of geographic quadrant in which the water source exists
        	  19. "SOURCE_NAME" -- specific name of the water source
        	  20. "TRIBUTARY_NAME" -- specific tributary contributing to the water source
        	  21. "IMAGE_URL" -- when available, link to scan of the original paper application
        	  22. "MAP_URL" -- links to the location shown on a map
        	  23. "Latitude1" -- latitude of source
        	  24. "Longitude1" -- longitude of source
        	  25. "Location" -- geographic coordinates of source (latitude and longitude)
          	
    b) "Purpose Code Key" (available as a download from the "About" tab in the above website)
       - this is a small table which keys the "PURPOSE_CODE" to a "PURPOSE_DESCRIPTION" for a better explanation of what the water will          be used for
       
2) Script to process and clean data, and create vizualizations in a folder called "Visualization Outputs"

    a) "WRA_Visualization_Script.R"  

3) The visualizations produced by the script, all in the folder "Visualization Outputs"

    a) "County WRAs.png"  -- barplot of total water rights applications per county from 1990 to 2015
    b) "Top Six Counties WRAs.png" -- linegraph showing trends in water rights applications from 1990 to 2015, for the six counties                                         with the most total applications
    c) "Purpose for WRAs.png" -- barplot showing total count of applications for each type of water use purpose, 1990 to 2015
    d) "Purpose Facet Plot.png" -- facet barplot showing the number of applications for each type of purpose, per year from 1990 to                                      2015
    e) "Top Five Purposes for WRAs.png" -- facet lineplot showing the top five purposes for applications from 1990 to 2015, for each                                             of the six counties with the highest number of total applications
    f) "watersheds count.png" -- barplot showing total count of applications for each watershed being drawn from
    g) "Source Locations.png" -- dotplot on Google map of Washington State showing location of source for each water right application                                  from 1990 to 2015
    
4) Word file containing both visualizations and associated analysis

    a) "Conclusions.docx"
    
======================================================================================================================================
####Definition of Problem

Water rights in the western half of the United States are controversial and complicated, and are likely to become moreso over the course of the century as the climate continues to change.  Therefore, I have chosen to work with an open government dataset showing key details from each of the new and renewing Water Right Applications in Washington State.  My goal was to use visualization to highlight areas of interest and paths of potential further investigation--essentially, to use visualization as a component of the data analysis.  The visualizations and conlusions are included in the final write up, the Word document "Conclusions".  The underlying purpose of this project, however, was to push my ability to produce a variety of plot types.  Prior to this project I have done only simple, uncolored barplots and scatter plots from the R base package. 

======================================================================================================================================
####Definition of Software

Software used for data processing: RStudio, version 0.99.489
 - no unusual techniques were necessary, I used a combination of pre-existing functions and a few if- and for-loops to process and       clean the datasets; plotting was done with the ggplot2 package
System specs are as follows:
 - operating system: Windows 8.1, 64x
 - processor: Intel(R) Core(TM) i3 CPU M350 @ 2.27GHz

======================================================================================================================================
####Results

The results are as expected after all troubleshooting is complete.  During code-development I had to do a lot of troubleshooting in the form of learning how to use new techniques correctly (for me) and also standard checking for mispellings and missing characters.  All told, the project probably took me around 40+ hours due to the fact that I was learning on the go.
The results of this project exist primarily in the form of plot files.  These are available in the "Visualization Outputs" folder individually and are incorporated into the "Conclusions" Word document.  Recommendations for further improvement are also included in this document.

======================================================================================================================================
####Reproducibility

The following files are required to reproduce this project:  "Water Right Applications" (dataset), "Purpose Code Key" (dataset), "WRA Visualizations Script" (processing, cleaning and plot production script).

To reproduce the base visualizations download these three files to the same location and then run the script in R.  Obviously the associated analysis cannot be reproduced via software.

