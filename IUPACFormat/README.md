# makeIUPACformatFile.R Tutorial

## About
This script will take in a Final Report file from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k

The script will convert then Final Report file into IUPAC format and export to a .csv file to facilitate upload into CottonGen.org.

Formatting Your Data
makeIUPACformatFile.R assumes your Final Report follows the above protocol listed on CottonGen’s website.  It can handle the report in either a text or csv file.  I recommend you rename your final report file name to not include any spaces.

Modifying the Script
You do not need to change anything in this script.  Simply follow the prompts in the console.

Tutorial
1.	Start the script:
To run in R console:
	Open the file in the console and click source
To run in command line:
	source("makeIUPACformatFile.R")
	or
	chmod +x makeIUPACformatFile.R
	./makeIUPACformatFile.R
2.	The script will first prompt you to enter in the path to your current path directory
 
3.	The script will then ask you to enter 1 if the final report file is a .csv file (comma delimited excel file) or 2 if the final report was printed to a text, .txt, file format.
4.	At the next prompt, type in the name of the final report file.  Please include the file extension in the name (.csv or .txt) or the script will throw an error.   
5.	If the final report file is not in the correct format according to the instructions in the protocol TAMU CottonSNP63K Array https://www.cottongen.org/data/community_projects/tamu63k , the script will throw an error and quit.
6.	If the final report was in the correct format, the script will let you know that it is working.  Then it will prompt you to name the new file.  The script will output the IUPAC formatted final report to this new file.  Please include the file extension name (.csv only) or the script will throw an error and require you to start over.
 
 
Example final IUPAC .csv file.  (Numbers as the name are just the placeholder for this example)

Citations
If you use these tools please cite Schoonmaker, Ashley (2019). makeIUPACformatFile.R (Version 1.0) [Source code]. https://www.cottongen.org/data/community_projects/tamu63k

Meaning of Errors
	“You have entered an invalid key.  Please try again.”
		This error will appear after either the yes/no questions or after asking if the file is txt or csv.  This error indicates you have entered something other than a variation of yes or no for the first and something other than 1 or 2 for the latter.  
	“Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k”
		This error indicates that your Final Report File does not following the protocol listed on the above website.  Please refer back to the website for instructions on how to print your data from GenomeStudio.
