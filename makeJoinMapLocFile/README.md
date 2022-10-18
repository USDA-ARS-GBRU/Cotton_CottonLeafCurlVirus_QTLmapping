# makeJoinMapFile.R Tutorial
## About
This script will take the matrices of parent A, parent B, and the F2 data and convert to a JoinMap F2 .loc file.

## Formatting Your Data
makeJoinMapFile.R assumes that you have already created variables that contain the polymorphic makers between the parents for the cross.  The three variables you will need will be the matrices of the markers for parent A, parent B and the F2 samples.  The rows should be the list of markers and the columns should be each of the samples.  Each of the matrices should have the same number of markers and the markers should be in the same order.

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/makeJoinMapLocFile/JMPicture1.png?raw=true)

For example, I pulled out the markers that were polymorphic between parent A and parent B.  I then took this list and pulled out those markers for the F2 data.  


## Tutorial
1. Change “population” in this section to be the name of your population.  This is the name that JoinMap will read in and make the name of the node.
 
 ![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/makeJoinMapLocFile/JMPicture2.png?raw=true)
 
The section is surrounded by stars so it should be easy to find.

2. Edit this section so that parentA contains the matrix that has the data for one of the parents, parentB to contain the matrix that has the data for the other parent, and population to contain the matrix that has the data for the F2 population.
 
 ![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/makeJoinMapLocFile/JMPicture3.png?raw=true)
 
This section is also surrounded by stars

3. Now run the program

To run in R console:

&nbsp;&nbsp;&nbsp;Open the file in the console and click source

To run in command line:

&nbsp;&nbsp;&nbsp;source("makeJoinMapFile.R")
&nbsp;&nbsp;&nbsp;or 
&nbsp;&nbsp;&nbsp;chmod +x makeJoinMapFile.R
&nbsp;&nbsp;&nbsp;./makeJoinMapFile.R
	
4.	The script will begin converting your data to JoinMap format.  This may take a few minutes.

5.	Once it is done, the script will ask you for a file name to output the data.  Please include .loc at the end of the name.

![alt text](https://github.com/ahulsekemp/Cotton_CottonLeafCurlVirus_QTLmapping/blob/main/makeJoinMapLocFile/JMPicture4.png?raw=true)

 
### Citations
If you use these tools please cite Schoonmaker, Ashley (2019). makeJoinMapFile.R (Version 1.0) [Source code]. https://www.cottongen.org/data/community_projects/tamu63k

### Meaning of Errors
	
“The number of markers in your F2 population does not equal the number of markers in the parent populations.”
	Either the number of markers of one parent does not equal the other or the number of makers in the F2 population does not equal the parents.  You should go back and check your variables.
