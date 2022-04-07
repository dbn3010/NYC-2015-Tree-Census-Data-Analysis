library(shiny)
library(tidyverse)
library(ggplot2)
library(treemapify)
library(RColorBrewer)
library(knitr)
library(kableExtra)

#tree <- read.csv('Tree_Data.csv')


function(input, output) {

  ### Reactive Filter
  reactData <- reactive({
      
    tree <- tree[tree[,"borough"] %in% unlist(input$borough),]
    tree <- tree[tree[,"part_problem"] == input$problem,]
    tree <- tree[tree[,"guards"] == input$guards,]
    tree <- tree[tree[,"sidewalk"] == input$sidewalk,]
    tree <- tree[tree[,"tree_dbh"] <= input$dbh,]
    
    tree
    
  })
  
  ### Overall bar plot
  output$overall <- renderPlot({
    
    barPlot <- ggplot(reactData(), aes(x = borough)) +
      geom_bar(fill = "steelblue") +
      geom_text(stat = 'count', aes(label = ..count..), vjust = 1, color = 'white') + 
      labs(title = "Distribution of trees across New York boroughs", x = "Boroughs", y = "Count of Trees") +
      theme_light() + 
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(axis.text = element_text(size = 12)) +
      theme(axis.title = element_text(size = 16, face = "bold")) +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    
    barPlot
    
  })
  
  ### Boxplot
  output$boxplot <- renderPlot({
    
    tree_dat <- reactData()[which(reactData()[,"health"] != ""),]
    tree_dat$health = factor(tree_dat$health, levels = c("Good", "Fair", "Poor"), ordered = TRUE)
    tree_dat <- na.omit(tree_dat)
    
    boxgraph <- ggplot(data = tree_dat) + 
      geom_boxplot(mapping = aes(x = tree_dbh, y =health, group = health), notch = TRUE, fill= "steelblue") + 
      labs(title = "Boxplot of Tree Diameter ~ Tree Health", x = "Diameter at Breast Height", y = "Health of tree") + 
      theme_light() + 
      theme(legend.position = "none") + 
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(axis.text = element_text(size = 12)) +
      theme(axis.title = element_text(size = 16, face = "bold")) +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    
    #print boxplot
    print(boxgraph)
    
  })
  
  
  ### Text plot
  output$text <- renderText({
    total_trees <-  reactData() %>% group_by(borough) %>% summarise(ntrees = n())
    borname <- ""
    for (var in input$borough) {
      borname <- paste0(borname, " ", var)
    }
    paste('There are', sum(total_trees[, 2]), 'number of trees in', borname, ".")
  })
  
  
  ### Text plot
  output$text1 <- renderText({
    total_trees <-  reactData() %>% group_by(health) %>% summarise(ntrees = n())
    paste0(round(sum(total_trees[total_trees$health == "Good",  "ntrees"])/sum(total_trees[, "ntrees"]),2)*100, "% of the trees have Good health and ",
           round(sum(total_trees[total_trees$health == "Poor",  "ntrees"])/sum(total_trees[, "ntrees"]),2)*100, "% of the trees have Poor health.")
  })
  
  ### Text plot
  output$text2 <- renderText({
      
    meanData <- reactData()
    meanval <- meanData %>% group_by(health) %>% summarise(mean =  mean(tree_dbh))
    paste0("The average diameter of trees with Good health is ", round(meanval[meanval$health == "Good", "mean"], 2) ,
           " , Fair health is ", round(meanval[meanval$health == "Fair", "mean"], 2) ,
           " and Poor health is ", round(meanval[meanval$health == "Poor", "mean"], 2), "." )
    
  })
  
  ### Text plot
  output$text3 <- renderText({
    tree_data <- reactData() %>% select(borough, spc_latin) %>% group_by(borough, spc_latin) %>% count() %>% ungroup()
    tree_data_borough <- reactData() %>%  select(borough) %>% group_by(borough) %>%  count() %>%  ungroup()
    tree_final <- tree_data %>% inner_join(tree_data_borough, by = 'borough')
    tree_final$perc <- tree_final$n.x/tree_final$n.y
    tree_final <- tree_final %>% group_by(borough) %>% arrange(desc(perc), .by_group = TRUE) %>% mutate(csum = cumsum(perc))
    tree_final$csum <- tree_final$csum * 100
    tree_data_final <- tree_final %>% dplyr::filter(csum <= 80) %>% select(borough, spc_latin, n.x)
    names(tree_data_final)[3] <- "nTrees"
    
    
    spc_total <- tree_data_final %>% group_by(spc_latin) %>% summarise(sum = sum(nTrees)) %>% arrange(-sum) 
    spc_top <- spc_total %>% top_n(5)
    perc <- round(sum(spc_top$sum)/sum(spc_total$sum),2)*100
    
    spcname <- ""
    for (var in spc_top$spc_latin) {
      spcname <- paste0(var, ", ", spcname)
    }
    
    paste0("The top 5 species in New York are : ", spcname, " covering aorund ", perc, "% of total tree cover.")
    
  })

  ### Table output
  output$table <- renderTable({
    total_trees <-  reactData() %>% group_by(status) %>% summarise(ntrees = n())
    names(total_trees) <- c("Tree Status", "# of Trees")
    total_trees
    
  }, striped = TRUE, bordered = TRUE)
  
  ### Table output
  output$table_h <- renderTable({
    total_trees <-  reactData() %>% group_by(health) %>% summarise(ntrees = n())
    names(total_trees) <- c("Tree Health", "# of Trees")
    total_trees
    
  }, striped = TRUE, bordered = TRUE)
  
  
  ### Tree Map
  output$treemap <- renderPlot({
    
    tree_data <- reactData() %>% select(borough, spc_latin) %>% group_by(borough, spc_latin) %>% count() %>% ungroup()
    tree_data_borough <- reactData() %>%  select(borough) %>% group_by(borough) %>%  count() %>%  ungroup()
    tree_final <- tree_data %>% inner_join(tree_data_borough, by = 'borough')
    tree_final$perc <- tree_final$n.x/tree_final$n.y
    tree_final <- tree_final %>% group_by(borough) %>% arrange(desc(perc), .by_group = TRUE) %>% mutate(csum = cumsum(perc))
    tree_final$csum <- tree_final$csum * 100
    tree_data_final <- tree_final %>% dplyr::filter(csum <= 80) %>% select(borough, spc_latin, n.x)
    names(tree_data_final)[3] <- "nTrees"
  
    
    treemap <- ggplot(data = tree_data_final,
           aes(area = nTrees, fill = borough, subgroup = borough, subgroup2 = spc_latin, 
                                label = paste0(spc_latin, "\n", prettyNum(nTrees, big.mark = ",")))) +
      geom_treemap(alpha = 0.8) +
      geom_treemap_text(fontface = "italic", colour = "black", place = "centre", size = 13) + 
      scale_fill_manual(values = brewer.pal(n = 5, name = 'Set1'))
    
    print(treemap)
    
  })
  
  
}

