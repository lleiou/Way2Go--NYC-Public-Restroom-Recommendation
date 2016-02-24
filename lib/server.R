#library(data.table)
library(dplyr)

#TData=read.csv(file="NYCT_NEW_ZIP.csv",header=TRUE)
TData=filter(TData,TData$Lat>0&TData$Lat<41&TData$Lon<73.6)


palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

shinyServer(function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    TData[,c(input$xcol,input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 3, cex = 3, lwd = 4)
  })
  
})