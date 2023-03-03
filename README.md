# Scripts for Analysis of Cotton Leaf Curl Virus QTL mapping

This project contains the R scripts use in the Cotton Leaf Curl Virus paper.  These include selecting subsets of the Illumina's Genome Studio Final Reports generated from the CottonSNP63K array (Hulse-Kemp, Lemm, et al., 2015), creating JoinMap .loc files from the filtered marker sets, and converting Final Reports into IUPAC format (as requierd to upload rawdata to CottonGen database).  

Go to each script's folder for more details on the scripts and tutorials on how to run each part independently.

These scripts were developed for ease of use when analyzing multiple populations for Quantitative Trait Loci (QTL) mapping as well as facilitiating deposit of rawdata to CottonGen database for any study using Illumina arrays. For the anaylses in the paper, the R scripts were used for each of the populations.  Note: These scripts were initially developed this way because we did not have access to the actual parents of the crosses, only multiple representatives of the paernt line.  For this reason, we needed to look more closely at what markers were being filtered and for what reasons.  Later on, the scripts were condensed into a shiny app for use in future projects. 

**For easier use, an R Shiny app was developed encasing each of these scripts. Most users can go immediately to using the Shiny app at the link below.** 

# **[iCottonQTL Shiny Web App](https://gbru-ars.shinyapps.io/iCottonQTL/)

## Simple Steps to Run Shiny App

[Detailed steps](https://github.com/USDA-ARS-GBRU/Cotton_CottonLeafCurlVirus_QTLmapping/tree/main/Shiny) are in the Shiny folder.

### Joinmap Tab

1. Upload one or more Final Report from Illumina's Genome Studio exported following standard protocol listed here: [CottonGen Website](https://www.cottongen.org/data/community_projects/tamu63k) in cvs or txt format
             Optional: Upload a .txt list of the samples in the Final Report to subset the dataset if project encompasses less samples than what is in the Final Report.

2. Select the population type and the level of heterzygosity per marker to remove (default set to remove markers with less than 5% heterozygosity).

3. Give the names for Parent A and Parent B as listed in the Final Report files.

4.  Download the .loc file by clicking the button.  A button is also available to download a .csv file of the subsetted dataset with just the functional polymorphic markers for easy input into R to manipulate the data yourself.


### IUPAC tab

1. Upload **one** Final Report from Illumina's Genome Studio exported following standard protocol listed here: https://www.cottongen.org/data/community_projects/tamu63k in .csv or .txt format

2.  Download the IUPAC formated .csv


**related to this paper**

**cite**

Schoonmaker, A.N.; Hulse-Kemp, A.M.; Youngblood, R.C.; Rahmat, Z.; Atif Iqbal, M.; Rahman, M.-u.; Kochan, K.J.; Scheffler, B.E.; Scheffler, J.A. Detecting Cotton Leaf Curl Virus Resistance Quantitative Trait Loci in Gossypium hirsutum and iCottonQTL a New R/Shiny App to Streamline Genetic Mapping. Plants 2023, 12, 1153. https://doi.org/10.3390/plants12051153


Hulse-Kemp, A. M., Lemm, J., Plieske, J., Ashrafi, H., Buyyarapu, R., Fang, D. D., … Stelly, D. M. (2015). Development of a 63K SNP Array for Cotton and High-Density Mapping of Intraspecific and Interspecific Populations of Gossypium spp. G3&amp;#58; Genes|Genomes|Genetics, 5(6), 1187–1209. https://doi.org/10.1534/g3.115.018416
