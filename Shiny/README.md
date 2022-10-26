**APP LINK**

## Extended Steps and Notes to Run Shiny App


### Joinmap Tab


1. Upload one or more Final Report from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k in cvs or txt format.  The Final Report should be in the same format as it was downloaded - the app expects the report to have the header.  The app will double check that the file is in the appropriate format.  If your file is not in the correct format, please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k
            
**Optional:** Upload a .txt list of the samples in the Final Report to subset the dataset if project encompasses less samples than what is in the Final Report

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture1.png?raw=true)
            
The file should look like this.  The sample names should be exactly the same as they are listed in the Final Report.
            
2. Select the population type and the level of heterzygosity per marker to remove (default set to remove markers with less than 5% heterozygosity).  Population types include F2, F3, F4, and F5 which are what is listed in the header of the .loc file.  We recommend removing at least the markers with less than 5% heterozygosity.  

3. Give the names for Parent A and Parent B as listed in the Final Report files.

4.  Download the .loc file by clicking the button.  A button is also available to download a csv file of the subsetted dataset with just the functional polymorphic markers for easy input into R to manipulate the data yourself.


### IUPAC tab

1. Upload **one** Final Report from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k in cvs or txt format

2.  Download the IUPAC formated csv.  You will be prompted to name the file (a default name will be suggested) and selected a folder on your computer to download to.  The script will output the IUPAC formatted final report to this new file.

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/IUPACFormat/IUPicture4.png?raw=true)
 
 
Example final IUPAC .csv file.  (Numbers as the name are just the placeholder for this example)

