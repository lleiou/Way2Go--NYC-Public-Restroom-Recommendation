
#library(data.table)

#TData=read.csv(file="NYCT_NEW_ZIP.csv",header=TRUE)

shinyUI(
  pageWithSidebar(
    headerPanel("NYCT K means"),
    sidebarPanel(
      selectInput('xcol', 'X Variable', names(TData)[8:9]),
      selectInput('ycol', 'Y Variable', names(TData[8:9]),
      selected=names(TData)[[8]]),
      numericInput('clusters', 'Cluster count', 3,
                   min = 1, max = 9)
      
    ),
    mainPanel(
      
      plotOutput("plot1")
    )
    
  )
  
)