#!/usr/bin/env Rscript

#Written by Ashley Schoonmaker
#Hulse-Kemp Lab 2019

#****************************************
#This script will take parentA, parentB, and F2 data and create a .loc file for JoinMap
#Edit the two portions of the script that is surrounded by stars
#****************************************

#this function will create a JoinMap file with the F2 format from the variables given
makeJoinMapF2File <- function(outFile, population.recast)
{
  #open file
  sink(outFile)
  #print the header
  #****************************************
  #****************************************
  #change population to the name of the population you are working on
  #****************************************
  cat("name = population")
  #****************************************
  #****************************************
  cat("\n")
  cat("popt = F2")
  cat("\n")
  cat(paste("nloc =", nrow(population.recast)))
  cat("\n")
  cat(paste("nind =", ncol(population.recast)))
  cat("\n")
  cat("\n")
  #move the names from the rows into rows variable
  rows <- rownames(population.recast)
  #for the length of rows, print the marker name, then print the row with a space every 5 characters
  for (i in 1:nrow(population.recast))
  {
    cat(rows[i])
    cat("\n")
    string <- paste(population.recast[i,], collapse = "")
    cat(gsub("(.{5})", "\\1 ", string))
    cat("\n")
  }
  cat("\n")
  cat("individual names:")
  cat("\n")
  cat("\n")
  cols <- colnames(population.recast)
  #print a list of the names of the individuals
  for (i in 1:ncol(population.recast))
  {
    cat(cols[i])
    cat("\n")
  }
  #close the file
  sink()
}

#this function will create an array where if the F2 individual for that marker matches
#that marker from parent A, it will put an "A" at that position
#if it matches that marker from parent B, it will put a "B"
#otherwise it will put an "H"
#any marker position in F2 with a "--" will be changed to a "-"
makeJoinMapArray <- function(population, parentA, parentB)
{
  #initialize array, will delete this row later
  tp <- c(1:ncol(population))
  #initialize column array, will delete this placeholder later
  temp <- ""
  #for each column of each row, determine if the F2 matches A or B or is heterozygous
  for(i in 1:nrow(population)){ for(j in 1:ncol(population)){
    if(population[i,j] == parentA[i,1]){
      x = 'A'} else if(population[i,j] == parentB[i,1]){
        x = 'B'} else if(population[i,j] == "--"){x = '-'} else{x = 'H'}
    temp <- cbind(temp,x)}
    #delete the placeholder at position 1
    temp <- temp[-1]
    #bind temp (row of length columns of population) to bottom of tp matrix
    tp <- rbind(tp,temp)
    if(i == nrow(population))
    {
      #set population.recast to equal matrix in tp if finished final row
      population.recast <- tp
    }
    #reset temp to placeholder ""
    temp <- ""}
  
  #get rid of the first row which was created as a placeholder
  population.recast <- population.recast[-1,]
  #get rownames from F2 population
  rownames(population.recast) <- rownames(population)
  #get colnames from F2 population
  colnames(population.recast) <- colnames(population)
  write.csv(population.recast, file = "pop3.csv")
  return(population.recast)
}

#****************************************
#****************************************
#edit this section only
#edit parent A to contain the variable with data from parent A
#edit parent B to contain the variable with data from parent B
#edit population to contain the varialbe with the data from the F2 cross
#****************************************
population <- changeme
parentA <- changeme
parentB <- changeme
#****************************************
#****************************************

#check if the matrices have the same number of rows
if (nrow(population) != nrow(parentA) || nrow(parentA) != nrow(parentB))
{
  stop("The number of markers in your F2 population does not equal the number of markers in the parent populations.")
}

population.recast <- makeJoinMapArray(population = population, parentA = parentA, parentB = parentB)
#ask user for a name for the JoinMap file
print("Please enter a .loc file name to output F2 JoinMap file to")
print("example.loc")
outFile <- readline(prompt = ": ")
makeJoinMapF2File(outFile = outFile, population.recast = population.recast)

#end of script
