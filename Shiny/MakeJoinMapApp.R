#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#####################
#Select Specific samples
#####################

library(shiny)
library(dplyr)
library(stringr)
library(ggplot2)
table = read.csv("TableS1 - Sheet1.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Choose CSV File", accept = ".csv"),
            selectInput("variable", "Select the Population Type:",
                        c("F2" = "F2",
                          "F3" = "F3",
                          "F4" = "F4")),
            textInput("hetLevel", 
                      label = "Please give the heterozygousity Level", 
                      value = "", 
                      width = "100%",
                      placeholder = "0.05"),
            textInput("parentAInput", 
                      label = "Please give the name of one of the parents in the cross", 
                      value = "", 
                      width = "100%",
                      placeholder = "Parent A"),
            textInput("parentBInput", 
                      label = "Please give the name of the other parent in the cross", 
                      value = "", 
                      width = "100%",
                      placeholder = "Parent B"),
            actionButton(inputId = "submit", label = "Submit"),
            # Button
            downloadButton("downloadData", "Download JoinMap Loc File")
            
        ),
        mainPanel(
            plotOutput("markerHetBar"),
            plotOutput("markerIndBar")
        )
    )
)

server <- function(input, output) {
    options(shiny.maxRequestSize=50*1024^2)
    #output$value1 <- reactive({ input$parentAInput })
    #output$value2 <- reactive({ input$parentBInput })
    #output$value3 <- reactive({ input$variable })
    observeEvent( input$submit, {
        file <- input$file1
        ext <- tools::file_ext(file$datapath)
        
        req(file)
        validate(need(ext == "csv", "Please upload a csv file"))
        
        #read.csv(file$datapath, skip = 9, check.names = FALSE)
        data <- read.csv(file$datapath, skip = 9, check.names = FALSE)
        #set the row names to be the 1st column
        #rownames(data) <- data[,1]
        #remove 1st column
        #data <- data[,-1]
        
        #check the format of the Final Report file
        #first 8 should be TT, CC, TT, GG, AA, --, TT, AC
        #-- acceptable given these 1st 7 are functionalMonomorphic
        for (i in ncol(data)){
            if (isFALSE(data[1,i] == "TT" || data[1,i] == "--") && isFALSE(data[2,i] == "CC" || data[2,i] == "--") && isFALSE(data[3,i] == "TT" || data[3,i] == "--") && isFALSE(data[4,i] == "GG" || data[4,i] == "--") && isFALSE(data[5,i] == "AA" || data[5,i] == "--") && isFALSE(data[6,i] == "--") && isFALSE(data[7,i] == "TT" || data[7,i] == "--") && isFALSE(data[8,i] == "AC" || data[8,i] == "--"))
                #if (isFALSE(t1) && isFALSE(t2) && isFALSE(t3) && isFALSE(t4) && isFALSE(t5) && isFALSE(t6) && isFALSE(t7) && isFALSE(t8))
            {
                #if the Report file is incorrect, throw an error and exit the script
                stop("Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k")
            }
        }
        
    })
    
    
    output$downloadData <- downloadHandler(
        filename = function() {
            file2 <- input$file1
            ext <- tools::file_ext(file2$datapath)
            paste(file2, "_JoinMapFile.loc", sep = "")
        },
        content = function(filename) {
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
                #write.csv(population.recast, file = "pop3.csv")
                return(population.recast)
            }
            
            file <- input$file1
            ext <- tools::file_ext(file$datapath)
            
            req(file)
            validate(need(ext == "csv", "Please upload a csv file"))
            cat("enter program \n")
            #read.csv(file$datapath, skip = 9, check.names = FALSE)
            data <- read.csv(file$datapath, skip = 9, check.names = FALSE)
            rownames(data) = data[,1]
            data = data[,c(2:ncol(data))]
            data <- as.data.frame(data, check.names = FALSE)
            cat("data", dim(data), " \n")
            cat(typeof(data), "\n")
            #print(head(data), "\n")
            #print(colnames(data), "\n")
            #table = read.csv("TableS1 - Sheet1.csv")
            rownames(table) = table[,1]
            cat("table", dim(table), " \n")
            table_s = table[rownames(table) %in% rownames(data),]
            f2_poly = data[table_s[,5]=="FunctionalPolymorphic",]
            dataFunctional = data[rownames(data) %in% rownames(f2_poly),]
            cat("dataFunctional", dim(dataFunctional), " \n")
            cat("f2_poly", dim(f2_poly), " \n")
            
            #*********
            #get parent A and parent B from user input
            parentA <- dataFunctional[ , input$parentAInput, drop = FALSE]
            cat(input$parentAInput, "\n")
            cat("parentA", dim(parentA), "\n")
            parentB <- dataFunctional[ , input$parentBInput, drop = FALSE]
            cat("parentB", dim(parentB), "\n")
            #separate into different arrays
            #remove from f2 population array
            dataNoParents <- dataFunctional[ , -which(names(dataFunctional) %in% c(input$parentAInput,input$parentBInput))]
            cat(dim(dataNoParents), "\n")
            #need to drop down to functional markers
            #****
            #*
            #only making the ABH format here
            #so remove het in parents
            if((parentA[1,1] == parentB[1,1]) || ((parentA[1,1] != "AA") && (parentA[1,1] != "TT") && (parentA[1,1] != "CC") && (parentA[1,1] != "GG")) || ((parentB[1,1] != "AA") && (parentB[1,1] != "TT") && (parentB[1,1] != "CC") && (parentB[1,1] != "GG"))){
                temp = FALSE
            } else{
                temp = TRUE}
            for(i in 2:nrow(parentA)){
                if((parentA[i,1] == parentB[i,1]) || ((parentA[i,1] != "AA") && (parentA[i,1] != "TT") && (parentA[i,1] != "CC") && (parentA[i,1] != "GG")) || ((parentB[i,1] != "AA") && (parentB[i,1] != "TT") && (parentB[i,1] != "CC") && (parentB[i,1] != "GG"))){
                    tmp = FALSE
                } else{
                    tmp = TRUE}
                temp = rbind(temp,tmp)
            }
            cat("temp", dim(temp), "\n")
            #reduced has markers where the parents are different and neither are het for the marker
            f2_reduced = dataNoParents[temp,]
            cat("f2_reduced", dim(f2_reduced), "\n")
            parentA_reduced = parentA[temp,, drop=FALSE]
            cat("parentA_reduced", dim(parentA_reduced), "\n")
            parentB_reduced = parentB[temp,, drop=FALSE]
            cat("parentB_reduced", dim(parentB_reduced), "\n")
            #now get het of population
            hetPercent = apply(f2_reduced, 
                               MARGIN = 1,
                               function(x) sum(! (x %in% c("AA", "CC", "GG", "TT", "--")))) / ncol(dataFunctional)
            
            cat("hetPercent", dim(hetPercent), "\n")
            
            if (hetPercent[1] >= 0.05){temp = TRUE
            } else {temp = FALSE}
            for(i in 2:length(hetPercent)){
                if (hetPercent[i] >= 0.05){tmp = TRUE
                } else {tmp = FALSE}
                temp = rbind(temp,tmp)
            }
            
            parentA_keep = parentA_reduced[temp,, drop=FALSE]
            cat("parentA_keep", dim(parentA_keep), "\n")
            parentB_keep = parentB_reduced[temp,, drop=FALSE]
            cat("parentB_keep", dim(parentB_keep), "\n")
            f2_keep = f2_reduced[temp,]
            cat("f2_keep", dim(f2_keep), "\n")
            population.recast <- makeJoinMapArray(population = f2_keep, parentA = parentA_keep, parentB = parentB_keep)
            #write.csv(f2_keep, filename, row.names = FALSE)
            makeJoinMapF2File(outFile = filename, population.recast = population.recast)
        }
    )
    output$markerHetBar <- renderPlot({
        req(input$file1)
        filename = function() {
            file2 <- input$file1
            ext <- tools::file_ext(file2$datapath)
            paste(file2, "_JoinMapFile.loc", sep = "")
        }
        file <- input$file1
        ext <- tools::file_ext(file$datapath)
        
        req(file)
        validate(need(ext == "csv", "Please upload a csv file"))
        data <- read.csv(file$datapath, skip = 9, check.names = FALSE)
        rownames(data) = data[,1]
        data = data[,c(2:ncol(data))]
        data <- as.data.frame(data, check.names = FALSE)
        
        rownames(table) = table[,1]
        #cat("table", dim(table), " \n")
        table_s = table[rownames(table) %in% rownames(data),]
        f2_poly = data[table_s[,5]=="FunctionalPolymorphic",]
        dataFunctional = data[rownames(data) %in% rownames(f2_poly),]
        
        hetPercent = apply(dataFunctional, 
              MARGIN = 1,
              function(x) sum(! (x %in% c("AA", "CC", "GG", "TT", "--")))) / ncol(dataFunctional) * 100
        

        #hetPercent = rowSums(temp) / ncol(dataFunctional) * 100
        cat("hetPercent", length(hetPercent), dim(hetPercent), "\n")
        naCount = apply(dataFunctional, 
                           MARGIN = 1,
                           function(x) sum( (x %in% c("--")))) / ncol(dataFunctional) * 100
        #naCount2 = rowSums(naCount) / ncol(dataFunctional) * 100
        #cat("naCount2", length(naCount2), dim(naCount2), "\n")
        #row = rownames(dataFunctional)
        #cat("row", length(row), dim(row), "\n")
        #hetCount = cbind(hetPercent, naCount2, rownames(dataFunctional))
        #cat("hetCount", length(hetCount), dim(hetCount), "\n")
        df <- data.frame("hetPercent" = hetPercent, "naCount" = naCount, "row" = rownames(dataFunctional))
        #colnames(df[,3]) = "row"
        #colnames(df)[3] = "row"
        
        ggplot(data = df, mapping = aes(x = hetPercent, y = row)) + 
            geom_col(fill = 'royalblue4') +
            #scale_y_continuous(labels = df::row(accuracy = 1)) +
            labs(title = element_text("Het and NA percentatges Per Marker")) +
            ylab("Percent of Individuals")
    })
    output$markerIndBar <- renderPlot({
        req(input$file1)
        filename = function() {
            file2 <- input$file1
            ext <- tools::file_ext(file2$datapath)
            paste(file2, "_JoinMapFile.loc", sep = "")
        }
        file <- input$file1
        ext <- tools::file_ext(file$datapath)
        
        req(file)
        validate(need(ext == "csv", "Please upload a csv file"))
        data <- read.csv(file$datapath, skip = 9, check.names = FALSE)
        rownames(data) = data[,1]
        data = data[,c(2:ncol(data))]
        data <- as.data.frame(data, check.names = FALSE)
        
        rownames(table) = table[,1]
        #cat("table", dim(table), " \n")
        table_s = table[rownames(table) %in% rownames(data),]
        f2_poly = data[table_s[,5]=="FunctionalPolymorphic",]
        dataFunctional = data[rownames(data) %in% rownames(f2_poly),]
        
        hetPercent = apply(dataFunctional, 
                           MARGIN = 2,
                           function(x) sum(! (x %in% c("AA", "CC", "GG", "TT", "--")))) / ncol(dataFunctional) * 100
        
        
        #hetPercent = rowSums(temp) / ncol(dataFunctional) * 100
        cat("hetPercent", length(hetPercent), dim(hetPercent), "\n")
        naCount = apply(dataFunctional, 
                        MARGIN = 2,
                        function(x) sum( (x %in% c("--")))) / ncol(dataFunctional) * 100
        #naCount2 = rowSums(naCount) / ncol(dataFunctional) * 100
        #cat("naCount2", length(naCount2), dim(naCount2), "\n")
        #row = rownames(dataFunctional)
        #cat("row", length(row), dim(row), "\n")
        #hetCount = cbind(hetPercent, naCount2, rownames(dataFunctional))
        #cat("hetCount", length(hetCount), dim(hetCount), "\n")
        df <- data.frame("hetPercent" = hetPercent, "naCount" = naCount, "column" = colnames(dataFunctional))
        #colnames(df[,3]) = "row"
        #colnames(df)[3] = "row"
        
        ggplot(data = df, mapping = aes(x = hetPercent, y = column)) + 
            geom_col(fill = 'royalblue4') +
            #scale_y_continuous(labels = df::row(accuracy = 1)) +
            labs(title = element_text("Het and NA percentatges Per Marker")) +
            ylab("Percent of Individuals")
    })
}

shinyApp(ui, server)
