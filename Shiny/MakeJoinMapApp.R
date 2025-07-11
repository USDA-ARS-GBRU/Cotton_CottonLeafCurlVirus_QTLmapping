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
library(reshape2)
library(gridExtra)
library(tools)
table = read.csv("TableS1 - Sheet1.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("iCottonQTL"),
    p("Please cite: Schoonmaker, A. N., Rahmat, M. Z., Iqbal, M. A., Mehboob-ur-Rahman, Youngblood, R. C., Kochan, K. J., Scheffler, B. E., Hulse-Kemp, A. M., & Scheffler, J. A. Detecting Cotton Leaf Curl Virus Resistance Quantitative Trait Loci in Gossypium hirsutum and iCottonQTL a New R/Shiny App to Streamline Genetic Mapping in Cotton. Plants. 2023"),
    p("This application is designed to streamline the downstream pre-processing of cotton genotyping data derived from the Illumina Array technology (CottonSNP63K). For additional details/tutorial on utilizing the application please see the github link"),
    tags$a(href="https://github.com/USDA-ARS-GBRU/Cotton_CottonLeafCurlVirus_QTLmapping", "Simple Steps Github Link"),
    br(),
    tags$a(href="https://github.com/USDA-ARS-GBRU/Cotton_CottonLeafCurlVirus_QTLmapping/tree/main/Shiny", "Extended Steps Github Link"),
    tabsetPanel(
        tabPanel("Generate Input File for JoinMap", fluid = TRUE,
                 sidebarLayout(
                     sidebarPanel(
                         p("Example Final Report and example Sample List download available here:"),
                         tags$a(href="https://github.com/USDA-ARS-GBRU/Cotton_CottonLeafCurlVirus_QTLmapping/tree/main/Shiny/Example%20Files", "Example Files"),
                         fileInput("file1", "Choose TXT/CSV Final Report File(s)", multiple = TRUE, accept = c("text/csv", 
                                                                                                               "text/comma-separated-values,text/plain",
                                                                                                               ".csv", ".txt", ".txt.gz")),
                         fileInput("file3", "Optional: Choose TXT File Containing List of Sample Names", accept = c("text/csv", 
                                                                                                                    "text/comma-separated-values,text/plain",
                                                                                                                    ".csv", ".txt")),
                         selectInput("variable", "Select the Population Type:",
                                     c("F2" = "F2",
                                       "F3" = "F3",
                                       "F4" = "F4")),
                         numericInput("naIndLevel", 
                                      label = "Please give the Maximum Missing Data Level per Sample (see graph) in decimal (ex: 100% is 1)  *This default will output all samples, user may change this, but in doing so may reduce the number of samples exported to the .loc file*", 
                                      value = "", 
                                      width = "100%",
                                      min=0,
                                      max=1),
                         numericInput("hetLevel", 
                                   label = "Please give the Minimum Heterozygosity Level allowed per marker (calculated at the Overall Population Level) in decimal (ex: 5% is 0.05)", 
                                   value = "", 
                                   width = "100%",
                                   min=0,
                                   max=1),
                         numericInput("naLevel", 
                                   label = "Please give the Maximum Missing Data Level per marker (calculated at the Overall Population Level) in decimal (ex: 10% is 0.1)", 
                                   value = "", 
                                   width = "100%",
                                   min=0,
                                   max=1),
                         selectInput(inputId = "parentAInput", 
                                     label = "Select designated Sample for Parent A", 
                                     choices = "Pending Upload"),
                         selectInput(inputId = "parentBInput", 
                                     label = "Select designated Sample for Parent B", 
                                     choices = "Pending Upload"),
                         # Button
                         h5("Download JoinMap .Loc Input File (May take a min. Do not click more than once)"),
                         downloadButton("downloadData", "Download .Loc File"),
                         h5("Download CSV of the Functional Polymorphic Markers (May take a min. Do not click more than once)"),
                         downloadButton("downloadFunctional", "Download Markers", style="width:180px; text-align: left"),
                         downloadButton("downloadGraph", "Download Graph", style="width:180px; text-align: left"),
                         downloadButton("downloadHetData", "Download Graph Data", style="width:180px; text-align: left")
                     ),
                     mainPanel(
                         #plotOutput("markerHetBar"),
                         plotOutput("markerIndBar", width = "100%")
                     )
                 )
        ),
        tabPanel("CottonGen Upload Format", fluid = TRUE,
                 sidebarLayout(
                     sidebarPanel(
                         fileInput("file4", "Choose CSV File", accept = ".csv"),
                         #actionButton(inputId = "submit", label = "Submit"),
                         # Button
                         textInput("projectID", 
                                   label = "Please give the unique name for your dataset", 
                                   value = "", 
                                   width = "100%",
                                   placeholder = "TAMU_SNP63K_genotype"),
                         downloadButton("downloadIUPAC", "Download")
                         
                     ),
                     mainPanel(
                         p("Upload Final Report to the server and click download.  This app will convert the genomic SNP data to IUPAC nomenclature and output a csv in the format required to submission to CottonGen."),
                         p("User will need to open the downloaded file to input the species name for each sample under the 'species' column."),
                         img(src = "formatImage.PNG", height = 250, width = 400),
                         br(),
                         br(),
                         p("Please email the completed file to: jing.yu@wsu.edu"),
                         a(actionButton(inputId = "email1", label = "Click to Open Email", 
                                        icon = icon("envelope", lib = "font-awesome")),
                           href="mailto:jing.yu@wsu.edu"),
                         #tags$a(href="https://www.cottongen.org/data/submission", "CottonGen Submission"),
                         plotOutput("IUPACcheck", width = "100%")
                         
                     )
                 )
        )
    )
)

server <- function(input, output, session) {
    options(shiny.maxRequestSize=100*1024^2)
    default_val <- 0.05
    default_val2 <- 0.1
    default_val3 <- 1
    observe({
        if (!is.numeric(input$hetLevel)) {
            updateNumericInput(session, "hetLevel", value = default_val)
        }
    })
    observe({
        if (!is.numeric(input$naLevel)) {
            updateNumericInput(session, "naLevel", value = default_val2)
        }
    })
    observe({
        if (!is.numeric(input$naIndLevel)) {
            updateNumericInput(session, "naIndLevel", value = default_val3)
        }
    })
    data = reactive({
        req(input$file1[1,1])
        
        if (tolower(tools::file_ext(input$file1[[1, 'datapath']])) == "csv")
        {
            data <- read.csv(input$file1[[1, 'datapath']], skip = 9, check.names = FALSE)
        } else if (tolower(tools::file_ext(input$file1[[1, 'datapath']])) == "gz") {
            data <- read.delim(gzfile(input$file1[[1, 'datapath']]), skip = 9, check.names = FALSE)
            }
        else {
            data <- read.delim(input$file1[[1, 'datapath']], skip = 9, check.names = FALSE)
        }
        if(nrow(input$file1) > 1){
            for(i in 2:length(input$file1[,1])){
                #ext <- tools::file_ext(file$datapath)
                if (tolower(tools::file_ext(input$file1[[i, 'datapath']])) == "csv")
                {
                    tmp <- read.csv(input$file1[[i, 'datapath']], skip = 9, check.names = FALSE)
                } else
                {
                    tmp <- read.delim(input$file1[[i, 'datapath']], skip = 9, check.names = FALSE)
                }
                tmp = as.data.frame(tmp)
                data = cbind(data, tmp)
            }}
        #set the row names to be the 1st column
        rownames(data) <- data[,1]
        #remove 1st column
        data <- data[,-1]
        rownames(table) = table[,1]
        table_s = table[rownames(table) %in% rownames(data),]
        f2_poly = data[table_s[,2]=="FunctionalPolymorphic",]
        dataFunctional = data[rownames(data) %in% rownames(f2_poly),]
        if(!is.null(input$file3)==T){
            name.list <- read.delim(input$file3[[1, 'datapath']], header = FALSE)

            name.list <- base::t(name.list)
            name.list <- base::t(name.list)
            dataFunctional <- dataFunctional[,colnames(data) %in% name.list]
        }
        updateSelectInput(session,"parentAInput",choices=colnames(dataFunctional)) 
        updateSelectInput(session,"parentBInput",choices=colnames(dataFunctional)) 
        
        return(dataFunctional)
    })
    
    
    output$downloadData <- downloadHandler(
        filename = function() {
            file2 <- input$file1[1,1]
            #ext <- tools::file_ext(input$file1[[1, 'datapath']])
            file2 <-tools::file_path_sans_ext(file2)
            paste(file2, "_JoinMapFile.loc", sep = "")
        },
        content = function(filename) {
            req(input$file1[1,1])
            req(data())
            req(input$parentAInput)
            req(input$parentBInput)
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
                cat("popt =", input$variable)
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
                #initialize output matrix
                population.recast <- population
                #create parent matrices of the same dim as population
                parentA.matrix = matrix(rep(parentA, ncol(f2_keep)), ncol=ncol(parentA))
                parentB.matrix = matrix(rep(parentB, ncol(f2_keep)), ncol=ncol(parentB))

                #initialize all cells as het initially
                population.recast[,] <- "H"
                
                population.recast[population == "--"] <- "-"
                population.recast[population==parentA.matrix] <- "A"
                population.recast[population==parentB.matrix] <- "B"
                #write.csv(population.recast, file = "pop3.csv")
                return(population.recast)
            }
            
            dataFunctional <- as.data.frame(data(), check.names = FALSE)
            
            #*********
            #get parent A and parent B from user input
            parentA <- dataFunctional[ , input$parentAInput, drop = FALSE]
            parentB <- dataFunctional[ , input$parentBInput, drop = FALSE]

            #separate into different arrays
            #remove from f2 population array
            dataNoParents <- dataFunctional[ , -which(names(dataFunctional) %in% c(input$parentAInput,input$parentBInput))]
            
            naPercentInd = apply(dataNoParents, 
                               MARGIN = 2,
                               function(x) sum(x %in% c("--"))) / nrow(dataNoParents)
            
            if (naPercentInd[1] <= as.numeric(input$naIndLevel)){temp = TRUE
            } else {temp = FALSE}
            for(i in 2:length(naPercentInd)){
                if (naPercentInd[i] <= as.numeric(input$naIndLevel)){tmp = TRUE
                } else {tmp = FALSE}
                temp = rbind(temp,tmp)
            }
            
            dataNoParents1 = dataNoParents[,temp]
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

            #reduced has markers where the parents are different and neither are het for the marker
            f2_reduced = dataNoParents1[temp,]
            parentA_reduced = parentA[temp,, drop=FALSE]
            parentB_reduced = parentB[temp,, drop=FALSE]

            #now get het of population
            hetPercent = apply(f2_reduced, 
                               MARGIN = 1,
                               function(x) sum(! (x %in% c("AA", "CC", "GG", "TT", "--")))) / ncol(f2_reduced)
            
            if (hetPercent[1] >= as.numeric(input$hetLevel)){temp = TRUE
            } else {temp = FALSE}
            for(i in 2:length(hetPercent)){
                if (hetPercent[i] >= as.numeric(input$hetLevel)){tmp = TRUE
                } else {tmp = FALSE}
                temp = rbind(temp,tmp)
            }
            
            parentA_keep1 = parentA_reduced[temp,, drop=FALSE]
            parentB_keep1 = parentB_reduced[temp,, drop=FALSE]
            f2_keep1 = f2_reduced[temp,]

            naPercent = apply(f2_keep1, 
                               MARGIN = 1,
                               function(x) sum(x %in% c("--"))) / ncol(f2_keep1)
            
            if (naPercent[1] <= as.numeric(input$naLevel)){temp = TRUE
            } else {temp = FALSE}
            for(i in 2:length(naPercent)){
                if (naPercent[i] <= as.numeric(input$naLevel)){tmp = TRUE
                } else {tmp = FALSE}
                temp = rbind(temp,tmp)
            }
            parentA_keep = parentA_keep1[temp,, drop=FALSE]
            parentB_keep = parentB_keep1[temp,, drop=FALSE]
            f2_keep = f2_keep1[temp,]

            population.recast <- makeJoinMapArray(population = f2_keep, parentA = parentA_keep, parentB = parentB_keep)

            makeJoinMapF2File(outFile = filename, population.recast = population.recast)
        }
    )
    output$downloadFunctional <- downloadHandler(
        filename = function() {
            file2 <- input$file1[1,1]
            #ext <- tools::file_ext(input$file1[[1, 'datapath']])
            file2 <-tools::file_path_sans_ext(file2)
            paste(file2, "_FunctionalPolymorphicMarkers.csv", sep = "")
        },
        content = function(filename) {
            req(data())
            write.csv(data(), filename, row.names = TRUE)
        }
    )
    hetPercent = reactive({
        req(input$file1[1,1])
        req(data())
        dataFunctional <- as.data.frame(data(), check.names = FALSE)
        het = apply(dataFunctional, 
                    MARGIN = 2,
                    function(x) sum(! (x %in% c("AA", "CC", "GG", "TT", "--")))) / nrow(dataFunctional) * 100
        
        return(het)
    })
    naCount = reactive({
        req(input$file1[1,1])
        req(data())
        dataFunctional <- as.data.frame(data(), check.names = FALSE)
        naCount = apply(dataFunctional, 
                        MARGIN = 2,
                        function(x) sum( (x %in% c("--")))) / nrow(dataFunctional) * 100
        
        return(naCount)
    })
    output$markerIndBar <- renderPlot({
        req(input$file1[1,1])
        validate(
            need(file_ext(input$file1[1,1]) %in% c(
                'text/csv',
                'text/comma-separated-values',
                'text/tab-separated-values',
                'text/plain',
                'text',
                'txt',
                'csv',
                'tsv',
                'gz'
            ), "Wrong File Format try again!"))
        stopVar = "good"
        for(i in 1:length(input$file1[,1])){
            #ext <- tools::file_ext(file$datapath)
            if (tolower(tools::file_ext(input$file1[[i, 'datapath']])) == "csv")
            {
                tmp <- read.csv(input$file1[[i, 'datapath']], skip = 9, check.names = FALSE)
            } else
            {
                tmp <- read.delim(input$file1[[i, 'datapath']], skip = 9, check.names = FALSE)
            }
            rownames(tmp) <- tmp[,1]
            #remove 1st column
            tmp <- tmp[,-1]
            for (i in 1:ncol(tmp)){
                if (isTRUE(tmp[1,i] == "TT" || tmp[1,i] == "--") && isTRUE(tmp[2,i] == "CC" || tmp[2,i] == "--") && isTRUE(tmp[3,i] == "TT" || tmp[3,i] == "--") && isTRUE(tmp[4,i] == "GG" || tmp[4,i] == "--") && isTRUE(tmp[5,i] == "AA" || tmp[5,i] == "--") && isTRUE(tmp[6,i] == "--") && isTRUE(tmp[7,i] == "TT" || tmp[7,i] == "--") && isTRUE(tmp[8,i] == "AC" || tmp[8,i] == "--")){
                    #if the Report file is incorrect, throw an error and exit the script
                    #stop("Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k")
                    stopVar = "good"
                } else if (isTRUE(tmp[1,i] %in% c("TT", "TC", "CC", "--")) &&
                          isTRUE(tmp[2,i] %in% c("AA", "AG", "GG", "--")) &&
                          isTRUE(tmp[3,i] %in% c("AA", "AG", "GG", "--")) && 
                          isTRUE(tmp[4,i] %in% c("AA", "AC", "CC", "--")) && 
                          isTRUE(tmp[5,i] %in% c("AA", "AC", "CC", "--"))) {
                    stopVar = "good"
                } else {
                    stopVar = "bad"
                    validate(
                        need(stopVar == "good", "Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k")
                    )
                    }
            }
        }

        req(naCount())
        req(hetPercent())
        dataFunctional <- as.data.frame(data(), check.names = FALSE)
        df <- data.frame("hetPercent" = hetPercent(), "naCount" = naCount(), "column" = colnames(dataFunctional))
        df.m <- melt(df, id.vars='column')
        samples = length(df$column)
        if(samples <= 20){
            step = 1
        } else{
            step = 5
        }
        #df.m$col <- factor(df.m$col, levels = unique(df.m$col), ordered = TRUE)
        ggplot(data = df.m, mapping = aes(column, value)) +
            geom_bar(aes(fill = variable), position = "dodge", stat="identity") +
            scale_x_discrete(limits=df$column,breaks=df$column[seq(1,length(df$column),by=step)]) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
            labs(title = element_text("Percentages Per Sample")) +
            ylab("Percentages Per Sample") + xlab("") +
            ggtitle("Percentage of Heterzygous and N/A Markers per Sample") +
            coord_flip()
        
    })
    output$downloadGraph <- downloadHandler(
        filename = function() {
            file2 <- input$file1[1,1]
            #ext <- tools::file_ext(input$file1[[1, 'datapath']])
            file2 <-tools::file_path_sans_ext(file2)
            paste(file2, "_HetGraph.png", sep = "")
        },
        content = function(filename) {
            req(input$file1[1,1])
            req(data())
            req(naCount())
            req(hetPercent())
            dataFunctional <- as.data.frame(data(), check.names = FALSE)
            df <- data.frame("hetPercent" = hetPercent(), "naCount" = naCount(), "column" = colnames(dataFunctional))
            
            df.m <- melt(df, id.vars='column')
            plot = ggplot(data = df.m, mapping = aes(column, value)) +
                geom_bar(aes(fill = variable), position = "dodge", stat="identity") +
                scale_x_discrete(limits=df$column,breaks=df$column[seq(1,length(df$column),by=5)]) +
                theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
                labs(title = element_text("Percentatges Per Sample")) +
                ylab("Percentatges Per Sample") + xlab("Sample Name (Every 5th Shown)") +
                ggtitle("Percentage of Heterzygous and N/A Markers per Sample") +
                coord_flip()
            ggsave(filename, plot = plot, device = "png", width = nrow(df)/10)
        }
    )
    output$downloadHetData <- downloadHandler(
        filename = function() {
            file2 <- input$file1[1,1]
            #ext <- tools::file_ext(input$file1[[1, 'datapath']])
            file2 <-tools::file_path_sans_ext(file2)
            paste(file2, "_HetandNAPercents.csv", sep = "")
        },
        content = function(filename) {
            req(data())
            req(hetPercent())
            req(naCount())
            dataFunctional <- as.data.frame(data(), check.names = FALSE)
            df <- data.frame("hetPercent" = hetPercent(), "naCount" = naCount())
            
            write.csv(df, filename, row.names = TRUE)
        }
    )
    dataIUPAC = reactive({
        req(input$file4)

        if (tolower(tools::file_ext(input$file4[[1, 'datapath']])) == "csv")
        {
            data <- read.csv(input$file4[[1, 'datapath']], skip = 9, check.names = FALSE)
        } else
        {
            data <- read.delim(input$file4[[1, 'datapath']], skip = 9, check.names = FALSE)
        }
        return(data)
    })
    output$downloadIUPAC <- downloadHandler(
        filename = function() {
            file5 <- input$file4
            #ext <- tools::file_ext(file2$datapath)
            file5 <-tools::file_path_sans_ext(file5)
            paste(file5, "_IUPAC.csv", sep = "")
        },
        content = function(filename) {
            req(input$file4)
            req(dataIUPAC())
            data = as.data.frame(dataIUPAC(), check.names = FALSE)
            
            population.recast <- data
            population.recast[data == "TT"] <- "T"
            population.recast[data == "AA"] <- "A"
            population.recast[data == "CC"] <- "C"
            population.recast[data == "GG"] <- "G"
            population.recast[data == "AG"] <- "R"
            population.recast[data == "GA"] <- "R"
            population.recast[data == "CT"] <- "Y"
            population.recast[data == "TC"] <- "Y"
            population.recast[data == "GT"] <- "K"
            population.recast[data == "TG"] <- "K"
            population.recast[data == "AC"] <- "M"
            population.recast[data == "CA"] <- "M"
            population.recast[data == "GC"] <- "S"
            population.recast[data == "CG"] <- "S"
            population.recast[data == "TA"] <- "W"
            population.recast[data == "AT"] <- "W"
            population.recast[data == "--"] <- "-"
            temp <- as.data.frame(matrix(unlist(population.recast), nrow=length(unlist(population.recast[1]))))
            population.recast <- temp
            #rownames(population.recast) <- rownames(data)
            #colnames(population.recast) <- colnames(data)
            population.recast.t <- t(population.recast)
            rownames(population.recast.t) <- colnames(data)
            colnames(population.recast.t) <- rownames(data)
            colnames(population.recast.t) <- population.recast.t[1,]
            population.recast.t <- population.recast.t[-1,]
            species <- rep(NA, times = (nrow(population.recast.t)))
            genus <- rep("Gossypium", times = (nrow(population.recast.t)))
            stock_name <- rownames(population.recast.t)
            iupac <- cbind(stock_name, genus, species, population.recast.t)
            if (!(is.na(input$projectID))){
                dataset_name <- rep(input$projectID, times = (nrow(population.recast.t)))
            } else{
                dataset_name <- rep(NA, times = (nrow(population.recast.t)))
            }
            iupac <- cbind(dataset_name, iupac)
            write.csv(iupac, filename, na = "", row.names = FALSE)
        }
    )
    output$IUPACcheck <- renderPlot({
        req(input$file4)
        req(dataIUPAC())
        validate(
            need(file_ext(input$file4) %in% c(
                'text/csv',
                'text/comma-separated-values',
                'text/tab-separated-values',
                'text/plain',
                'text',
                'txt',
                'csv',
                'tsv'
            ), "Wrong File Format try again!"))
        stopVar = "good"
            #ext <- tools::file_ext(file$datapath)
            if (tolower(tools::file_ext(input$file4[[1, 'datapath']])) == "csv")
            {
                tmp <- read.csv(input$file4[[1, 'datapath']], skip = 9, check.names = FALSE)
            } else
            {
                tmp <- read.delim(input$file4[[1, 'datapath']], skip = 9, check.names = FALSE)
            }
            rownames(tmp) <- tmp[,1]
            #remove 1st column
            tmp <- tmp[,-1]
            for (i in 1:ncol(tmp)){
                if (isTRUE(tmp[1,i] == "TT" || tmp[1,i] == "--") && isTRUE(tmp[2,i] == "CC" || tmp[2,i] == "--") && isTRUE(tmp[3,i] == "TT" || tmp[3,i] == "--") && isTRUE(tmp[4,i] == "GG" || tmp[4,i] == "--") && isTRUE(tmp[5,i] == "AA" || tmp[5,i] == "--") && isTRUE(tmp[6,i] == "--") && isTRUE(tmp[7,i] == "TT" || tmp[7,i] == "--") && isTRUE(tmp[8,i] == "AC" || tmp[8,i] == "--")){
                    #if the Report file is incorrect, throw an error and exit the script
                    #stop("Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k")
                    stopVar = "good"
                } else if (isTRUE(tmp[1,i] %in% c("TT", "TC", "CC", "--")) &&
                           isTRUE(tmp[2,i] %in% c("AA", "AG", "GG", "--")) &&
                           isTRUE(tmp[3,i] %in% c("AA", "AG", "GG", "--")) && 
                           isTRUE(tmp[4,i] %in% c("AA", "AC", "CC", "--")) && 
                           isTRUE(tmp[5,i] %in% c("AA", "AC", "CC", "--"))) {
                    # THIS test is for the 27K array
                    #if the Report file is incorrect, throw an error and exit the script
                    #stop("Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k")
                    stopVar = "good"
                } else{
                    stopVar = "bad"
                    validate(
                        need(stopVar == "good", "Your Final Report is not in the correct format.  Please refer back to GenomeStudio and print the Final Report as a tab-delimited matrix according to the rules found here https://www.cottongen.org/data/community_projects/tamu63k")
                    )
                }
            }
        
    })
}

shinyApp(ui, server)
