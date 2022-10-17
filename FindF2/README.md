# findF2DataFromFinalReportDocument.R Tutorial

## About
This script will take in a Final Report file from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k and a text file of individual names, to produce a subset Final Report file with only individuals specified in a file.

The script will find the columns in the Final Report file containing information from the individuals and output them to a new .csv file.

The script will give you the option to convert the Final Report file into IUPAC format and export to a .csv file to facilitate upload into CottonGen.org.

### Modifying the Script
You do not need to change anything in this script.  Simply follow the prompts in the console.

## Formatting Your Data
findF2DataFromFinalReportDocument.R assumes your Final Report follows the above protocol listed on CottonGen’s website.  It can handle the report in either a text or csv file type.  I recommend you rename your Final Report file name to not include any spaces.

findF2DataFromFinalReportDocument.R will also require another file in addition to the Final Report.  This file will be a list of the samples you wish to find in the Final Report.  Please create this list as text file with 1 sample name per line.  Again, I recommend not including any spaces in the name of this file as well.  You do not need a header. 

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture1.png?raw=true)

## Tutorial
1.	Start the script: 
To run in R console:
	Open the file in the console and click source
To run in command line:
	source("findF2DataFromFinalReportDocument.R")
	or
	chmod +x findF2DataFromFinalReportDocument.R
	./ findF2DataFromFinalReportDocument.R
2.	The script will first prompt you to enter in the path to your current path directory
 
![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture2.png?raw=true)
 
3.	The script will then ask you to input the name of the text file that contains a list of the samples you wish to find in the Final Report file.  Please include the .txt extension in the name you give R
  
![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture3.png?raw=true)
 
4.	The script will then ask you to enter 1 if the final report file is a .csv file (comma delimited excel file) or 2 if the final report was printed to a text, .txt, file format.
5.	At the next prompt, type in the name of the final report file.  Please include the file extension in the name (.csv or .txt) or the script will throw an error.   
![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture4.png?raw=true)

6.	If the final report file is not in the correct format according to the instructions in the protocol TAMU CottonSNP63K Array https://www.cottongen.org/data/community_projects/tamu63k , the script will throw an error and quit.
7.	If the final report was in the correct format, the script will let you know that it is working.  Then it will prompt you to name the new file.  The script will output the subset to the new file.  The script will then let you know that your data is now in the new file and the matrix is also stored in a variable in R that you can now manipulate.   

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture5.png?raw=true)

8.	The script will then inform you if the Final Report is missing any of the samples from the list.  If will offer to subset the missing samples and print the new list to a new file.  

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture6.png?raw=true)

9.	The script will then give you the option to convert the Final Report to IUPAC format.  

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/FindF2/F2Picture7.png?raw=true)

10.	At the next prompt, input a name for the IUPAC .csv file.

#### Citations
If you use these tools please cite Schoonmaker, Ashley (2019). findF2DataFromFinalReportDocument.R (Version 1.0) [Source code]. https://www.cottongen.org/data/community_projects/tamu63k

#### Meaning of Errors
	“You have entered an invalid key.  Please try again.”
		This error will appear after either the yes/no questions or after asking if the file is txt or csv.  This error indicates you have entered something other than a variation of yes or no for the first and something other than 1 or 2 for the latter.  
	“Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k”
		This error indicates that your Final Report File does not following the protocol listed on the above website.  Please refer to the website for instructions on how to print your data from GenomeStudio.

