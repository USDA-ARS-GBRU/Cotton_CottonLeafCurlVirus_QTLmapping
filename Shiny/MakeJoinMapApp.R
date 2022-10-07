    output$markerHetBar <- renderPlot({
        # generate bins based on input$bins from ui.R
        data <- read.csv(file$datapath, skip = 9, check.names = FALSE)
        rownames(data) = data[,1]
        data = data[,c(2:ncol(data))]
        data <- as.data.frame(data, check.names = FALSE)
        
        rownames(table) = table[,1]
        cat("table", dim(table), " \n")
        table_s = table[rownames(table) %in% rownames(data),]
        f2_poly = data[table_s[,5]=="FunctionalPolymorphic",]
        dataFunctional = data[rownames(data) %in% rownames(f2_poly),]
        
        temp = c(1:ncol(dataFunctional))
        cat("temp", dim(temp), "\n")
        
        for(i in 1:nrow(dataFunctional)){
            for (j in 1:ncol(dataFunctional)){
                tmp = c(1:ncol(dataFunctional))
                if((dataFunctional[i,j] != "AA") && (dataFunctional[i,j] != "TT") && (dataFunctional[i,j] != "CC") && (dataFunctional[i,j] != "GG") && (dataFunctional[i,j] != "--")){
                    tmp[j] = 1
                } else{
                    tmp[j] = 0}
            }
            temp = rbind(temp,tmp)
        }
        #remove that temporary holder row
        temp = temp[-1,]
        hetPercent = rowSums(temp) / ncol(dataFunctional) * 100
        
        naCount = str_count(dataFunctional[1,], pattern = "--") / ncol(dataFunctional) * 100
        for(i in 2:nrow(dataFunctional)){
            tmp = str_count(dataFunctional[i,], pattern = "--")
            naCount = rbind(naCount, tmp) / ncol(dataFunctional) * 100
        }
        row = rownames(dataFunctional)
        df <- data.frame(row,hetPercent,naCount)
        #x    <- faithful[, 2]
        #bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        #hist(x, breaks = bins, col = 'darkgray', border = 'white')
        ggplot(df, aes(x = hetPercent, y = row)) + 
            geom_col(fill = 'royalblue4') +
            scale_y_continuous(labels = df::row(accuracy = 1)) +
            labs(title = element_text("Het and NA percentatges Per Marker")) +
            ylab("Percent of Individuals")
    })
