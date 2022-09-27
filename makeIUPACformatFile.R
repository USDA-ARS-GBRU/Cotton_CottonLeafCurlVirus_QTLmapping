#!/usr/bin/env Rscript

#Written by Ashley Schoonmaker
#Hulse-Kemp Lab 2019

#****************************************
#To run in command line type the following
#source("makeIUPACformatFile.R")
#
#This script will take in a FinalReport file from Illumina's
#Genome Studio exported following standard protocol listed
#here: https://www.cottongen.org/data/community_projects/tamu63k
#
#The script will convert the Final Report file
#into IUPAC format to facilitate upload into CottonGen.org
#****************************************

print("Please enter the path to your working directory")
working.directory <- readline(prompt = ": ")
setwd(working.directory)

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

print("Making the new matrix.  This may take a few minutes.")
population.recast <- data
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
rownames(population.recast) <- rownames(data)
colnames(population.recast) <- colnames(data)
#ask the user for a name to print the data to a file
print("Please enter a file name to output the selected data to")
print("Ex: FinalReport_IUPAC.csv")
writeReport.file <- readline(prompt = ": ")   #get input from user
write.csv(population.recast, file = writeReport.file)

#end of script