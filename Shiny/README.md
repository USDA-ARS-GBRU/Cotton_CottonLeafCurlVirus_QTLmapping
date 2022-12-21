# [iCottonQTL Shiny Web App](https://gbru-ars.shinyapps.io/iCottonQTL/)

## Extended Steps and Notes to Run Shiny App


### Joinmap Tab


1. Upload one or more Final Reports from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k in .csv or tab-delimited .txt format.  The Final Report should be in the same format as it was downloaded - the Shiny app expects the report to have the header.  The app will double check that the file is in the appropriate format.  If your file is *not* in the correct format, please refer back to GenomeStudio and export the Final Report as a tab-delimited .txt format according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k
            
**Optional:** Upload a .txt list of the samples in the Final Report to subset the dataset if your project encompasses less samples than what is in the overall Final Report file.

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture1.png?raw=true)
            
The file should look like this.  The sample names should be exactly the same as they are listed in the Final Report.
            
2. Select the population type and the level of heterzygosity per marker to remove (default set to remove markers with less than 5% heterozygosity).  Population types include F2, F3, and F4 which will be listed in the header of the .loc file that will be generated.  We recommend removing at least the markers with less than 5% heterozygosity.  

**Disclaimer: Only F2, F3, or F4 are listed in the app.  If another population type is needed open the .loc file and change the population code on the second line to the correct Joinmap code.
popt = F3

3. Select the level of missing data allowed per sample.  Current default is set to 1 (100%) which allows for a sample to have up to 100% of the data missing.  See the graph for percentage of data missing per sample (calculated out of the Functional Polymorphic Markers).

**Disclaimer:  Changing this field may cause samples to be dropped from the .loc file that is created.

4. Select the levels of missing data and heterozygousity allowed per marker (calculated out of the total population size).  Set the missing data to the maximum percentage allowed (in decimal) and the minimum percentage allowed (in decimal) for heterozygousisty.  Default is set for F2 populations.

5. Give the names for Parent A and Parent B as listed in the Final Report files.  (Parents A and B cannot be the same.  The app will not create a .loc file.)

6.  Download the .loc file by clicking the button at the bottom of the console.  A button is also available to download a .csv file of the subsetted dataset with just the functional polymorphic markers for easy input into R to manipulate the data yourself.


### IUPAC tab

1. Upload **one** Final Report from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k in .csv or .txt format

2.  Download the IUPAC formated .csv.  The user will need to open the file and input the species name for each sample under the 'species' column.

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/IUPACFormat/IUPicture4.png?raw=true)
 
  
Example final IUPAC .csv file.  (Numbers as the sample name are just placeholders for this example.)
 
 3. Please email the completed file to: jing.yu@wsu.edu 
 The email button in the app opens Microsoft Outlook to a new email addresed to the CottonGen currator. 
 

