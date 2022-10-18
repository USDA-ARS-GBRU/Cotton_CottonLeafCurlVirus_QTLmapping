# Scripts for Analysis of Cotton Leaf Curl Virus QTL mapping

This project contains the R scripts use in the Cotton Leaf Curl Virus paper.  These include selecting subsets of the Illumina's Genome Studio Final Reports generated from the CottonSNP63K array (Hulse-Kemp, Lemm, et al., 2015), creating JoinMap .loc files from the filtered marker sets, and translating Final Reports into IUPAC format.  Go to each script's folder for more details on the scripts and tutorials on how to run.

These are the scripts I developed for ease of use when analyzing multiple populations for QTLs.  For the anaylses in the paper, the R scripts were used for each of the populations.  I developed them this way because we did not have access to the actual parents of the crosses, only representatives of the line.  For this reason, I needed to look more closely at what markers I was filtering and for what reasons.  Later on, the scripts were condensed into a shiny app for use in future projects.

For easier use, a shiny app was developed encasing each of these scripts.  Further notes are in the Shiny folder.

**APP LINK**

## Simple Way to Run Shiny App

### Joinmap Tab

Note:  This was written for cotton projects but this tab can be used for other QTL projects given the 2 parents are known.

1. Upload one or more Final Report from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k in cvs or txt format
             Optional: Upload a .txt list of the samples in the Final Report to subset the dataset if project encompasses less samples than what is in the Final Report

2. Select the population type and the level of heterzygosity per marker to remove (default set to remove markers with less than 5% heterozygosity)

3. Give the names for Parent A and Parent B as listed in the Final Report files

4.  Download the .loc file by clicking the button.  A button is also available to download a csv file of the subsetted dataset with just the functional polymorphic markers for easy input into R to manipulate the data yourself.


### IUPAC tab

1. Upload **one** Final Report from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k in cvs or txt format

2.  Download the IUPAC formated csv


**related to ** this paper **

**cite**


Hulse-Kemp, A. M., Lemm, J., Plieske, J., Ashrafi, H., Buyyarapu, R., Fang, D. D., … Stelly, D. M. (2015). Development of a 63K SNP Array for Cotton and High-Density Mapping of Intraspecific and Interspecific Populations of Gossypium spp. G3&amp;#58; Genes|Genomes|Genetics, 5(6), 1187–1209. https://doi.org/10.1534/g3.115.018416
