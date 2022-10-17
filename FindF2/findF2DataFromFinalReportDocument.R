#!/usr/bin/env Rscript

#Written by Ashley Schoonmaker
#Hulse-Kemp Lab 2019

#****************************************
#To run in command line type the following
#source("findF2DataFromFinalReportDocument.R")
#
#This script will take in a FinalReport file from Illumina's
#Genome Studio exported following standard protocol listed
#here: https://www.cottongen.org/data/community_projects/tamu63k
#and a text file of individual names,
#to produce a subsetted FinalReport file with only individuals
#specified in a file.
#
#example sample file format (no header necessary):
#ff_01
#ff_02
#ff_03
#The script will find the columns containing
#information from the individuals and output them to a new file
#
#Optionally the script will convert the whole file or selected subset file
#into IUPAC format to facilitate upload into CottonGen.org
#****************************************

#set working directory
#you can comment out this line if the working directory is already set
print("Please enter the path to your working directory")
working.directory <- readline(prompt = ": ")
setwd(working.directory)

#give the name of the text file that contains a list of the names of the individuals you want to find in the final report
print("Please enter the name of the text file that contains a list of the individual names you want to find")
print("Ex: example.txt")
namelist.file <- readline(prompt = ": ")
name.list <- read.delim(namelist.file, header = FALSE)
name.list <- base::t(name.list)
name.list <- base::t(name.list)

#ask if the report file is csv or text
print("If the Final Report file is a .csv put 1")
print("If it is a .txt put 2")
query <- readline(prompt = ": ")
#check if input query is valid
while(query != "1" && query != "2"){
  print("You have entered an invalid key.  Please try again.")
  query <- readline(prompt = ": ")
}
print("Please enter the name of the Final Report file")
print("Ex: FinalReport.csv or FinalReport.txt")
finalReport.file <- readline(prompt = ": ")
#if query = 1, use the csv command
#if query = 2, use the text doc command
if (query == "1")
{
  data <- read.csv(finalReport.file, skip = 9, check.names = FALSE)
} else
{
  data <- read.delim(finalReport.file, skip = 9, check.names = FALSE)
}

#set the row names to be the 1st column
rownames(data) <- data[,1]
#remove 1st column
data <- data[,-1]

#check the format of the Final Report file
#first 8 should be TT, CC, TT, GG, AA, --, TT, AC
#-- acceptable given these 1st 7 are functionalMonomorphic
t1 <- data[1,1] == "TT" || data[1,1] == "--"
t2 <- data[2,1] == "CC" || data[2,1] == "--"
t3 <- data[3,1] == "TT" || data[3,1] == "--"
t4 <- data[4,1] == "GG" || data[4,1] == "--"
t5 <- data[5,1] == "AA" || data[5,1] == "--"
t6 <- data[6,1] == "--"
t7 <- data[7,1] == "TT" || data[7,1] == "--"
t8 <- data[8,1] == "AC" || data[8,1] == "--"
for(i in ncol(data)){
  tp <- data[1,i] == "TT" || data[1,i] == "--"
  t1 <- rbind(t1, tp)
  tp <- data[2,i] == "CC" || data[2,i] == "--"
  t2 <- rbind(t2, tp)
  tp <- data[3,i] == "TT" || data[3,i] == "--"
  t3 <- rbind(t3, tp)
  tp <- data[4,i] == "GG" || data[4,i] == "--"
  t4 <- rbind(t4, tp)
  tp <- data[5,i] == "AA" || data[5,i] == "--"
  t5 <- rbind(t5, tp)
  tp <- data[6,i] == "--"
  t6 <- rbind(t6, tp)
  tp <- data[7,i] == "TT" || data[7,i] == "--"
  t7 <- rbind(t7, tp)
  tp <- data[8,i] == "AC" || data[8,i] == "--"
  t8 <- rbind(t8, tp)
}
#check if the Report file is in the correct format
if (isTRUE(t1) && isTRUE(t2) && isTRUE(t3) && isTRUE(t4) && isTRUE(t5) && isTRUE(t6) && isTRUE(t7) && isTRUE(t8))
{
  #if the Report file is incorrect, throw an error and exit the script
  stop("Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k")
}


populationData <- data[,colnames(data) %in% name.list]
namesNotInReport <- name.list[!name.list %in% colnames(data)]


#ask the user if they want to print the data to a file
print("Would you like to print the selected data to a new file? Yes/No")
query <- readline(prompt = ": ")
while (query != "Y" && query != "y" && query != "Yes" && query != "yes"&& query != "YES" && query != "No" && query != "no" && query != "NO" && query != "n" && query != "N"){
  print("You have entered an invalid key.  Please try again.")
  query <- readline(prompt = ": ")
}
if (query == "Y" || query == "y" || query == "Yes" || query == "yes"|| query == "YES")
{
  #ask the user for a name to print the data to a file
  print("Please enter a file name to output the selected data to")
  print("Ex: FinalReportSubset.csv")
  writeReport.file <- readline(prompt = ": ")   #get input from user
  write.csv(populationData, file = writeReport.file)
  #let the user know that the data now exists in a file and which variable also contains the data
  print(paste("Your data now exists in file", writeReport.file, "and in the variable populationData"))
} else if (query == "No" || query == "no" || query == "NO" || query == "n" || query == "N") {
  #if the user does not want the data in a file, let the user know which variable the
  #data exists in
  print("Your data now exists in the variable populationData")
}

#if the script did not find some of the individuals, let the user know
if (length(namesNotInReport) != 0)
{
  print("These individuals were not found in the report file.")
  #print the names not found to the console
  #print(namesNotInReport)
  #ask the user if they would like to print this info to a new file
  print("Would you like to print this information to a new file? Yes/No")
  query <- readline(prompt = ": ")
  while (query != "Y" && query != "y" && query != "YES" && query != "yes"&& query != "Yes" && query != "No" && query != "no" && query != "NO" && query != "n" && query != "N"){
    print("You have entered an invalid key.  Please try again.")
    query <- readline(prompt = ": ")
  }
  if (query == "Y" || query == "y" || query == "Yes" || query == "yes"|| query == "YES")
  {
    print("Please enter a file name to output the missing individual names to")
    print("Ex: MissingIndividuals.txt")
    writeMissing.file <- readline(prompt = ": ")
    write.table(namesNotInReport, file = writeMissing.file)
    print(paste("Your missing names now exist in file", writeMissing.file, "and in the variable namesNotInReport"))
  } else if (query == "No" || query == "no" || query == "NO" || query == "n" || query == "N") {
    #let the user know which variable contains the missing names
    print(paste("Your missing names now exist in the variable namesNotInReport"))
  }
}

#ask the user if they want to print the data to a IUPAC file
print("Would you like to print your data to an IUPAC file format? Yes/No")
query <- readline(prompt = ": ")
while (query != "Y" && query != "y" && query != "Yes" && query != "yes"&& query != "YES" && query != "No" && query != "no" && query != "NO" && query != "n" && query != "N"){
  print("You have entered an invalid key.  Please try again.")
  query <- readline(prompt = ": ")
}
if (query == "Y" || query == "y" || query == "Yes" || query == "yes"|| query == "YES")
{
  print("If you want to turn the full Final Report file to IUPAC format put 1")
  print("If you want to turn the smaller selected population to IUPAC format put 2")
  query <- readline(prompt = ": ")
  #check if input query is valid
  while(query != "1" && query != "2"){
    print("You have entered an invalid key.  Please try again.")
    query <- readline(prompt = ": ")
  }
  if (query == "1")
  {
    population <- data
  }else {
    population <- populationData
  }
  
  print("Making the new matrix.  This may take a few minutes.")
  population.recast <- population
  population.recast <- lapply(population.recast, function(x) {gsub("TT", "T", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("AA", "A", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("CC", "C", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("GG", "G", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("AG", "R", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("GA", "R", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("CT", "Y", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("TC", "Y", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("GT", "K", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("TG", "K", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("AC", "M", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("CA", "M", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("GC", "S", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("CG", "S", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("TA", "W", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("AT", "W", x)})
  population.recast <- lapply(population.recast, function(x) {gsub("--", "-", x)})
  temp <- as.data.frame(matrix(unlist(population.recast), nrow=length(unlist(population.recast[1]))))
  population.recast <- temp
  rownames(population.recast) <- rownames(population)
  colnames(population.recast) <- colnames(population)
  #ask the user for a name to print the data to a file
  print("Please enter a file name to output the selected data to")
  print("Ex: FinalReport_IUPAC.csv")
  writeReport.file <- readline(prompt = ": ")   #get input from user
  write.csv(population.recast, file = writeReport.file)
} else if (query == "No" || query == "no" || query == "NO" || query == "n" || query == "N") {

}



#end of script
