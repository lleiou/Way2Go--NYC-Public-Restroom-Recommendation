library(shinydashboard)
library(shiny)
library(dplyr)
library(leaflet)
library(data.table)
library(rgeos)
library(rgdal)
library(ggmap)
library(geosphere)
library(DT)
# source("../output/leaflet.R")
# source("../lib/DensityMapbyZipCode.R")
# source("../lib/NewMap.R")
header <- dashboardHeader(title = "Search for Restroom!")
siderbar<-dashboardSidebar(
        sidebarMenu(
                menuItem("Locate", tabName = "map", icon = icon("fa fa-map-marker"),badgeLabel = "TryMe!", badgeColor = "green"),
                menuItem("Statistic Analysis",tabName = "stats", icon = icon("fa fa-bar-chart"), 
                         
                         menuSubItem("Density Map",icon = icon("fa fa-map"),tabName = "chart1"),
                         menuSubItem("Income map",icon = icon("fa fa-usd"),tabName = "chart2"))
                   )
                          )
body <- dashboardBody(
      
          tabItems(
                     # First tab content
                   tabItem(tabName = "map",
                            fluidRow(
                                     column(width = 9,
                                            box(width = NULL, solidHeader = TRUE,leafletOutput("map_output", height = 500)
                                                )
                                            
                                            ),
                                     column(width = 3,
                                           box(width = NULL, status = "warning",
                                                textInput("address", "My location:"),
                                                actionButton("go", "Go!"),
                                                 p("Click the button to update the value displayed in the main panel.") 
                                            ),
                                            box(width = NULL, status = "warning",
                                                 sliderInput("range", "Choose a range", 1, 2000,1000),
                                                p("Distance in meter")
                        
                                             ),
                                           fluidRow(width=150, height=80,
                                               actionButton("mylocation", "My Location"),
                                               actionButton("switch1","Switch1"),
                                               p("Click the button to update the value displayed in the main panel."),
                                               img(src = "images.png",width=80, height=80))
                                        )
                            ),
                          fluidRow(box(title = "table",width=800,DT::dataTableOutput("table")) )           
                         ),
        #Second tab Item
              tabItem(tabName = "chart1",
                      fluidRow(
                              tabBox(width=12,height = 10,
                                      title = "",
                                      # The id lets us use input$tabset1 on the server to find the current tab
                                      id = "tabset1", 
                                      tabPanel("Restroom Density Map", plotOutput("plot1")),
                                      tabPanel("Tab2", "Tab content 2"),
                                      tabPanel("Tab3", "Tab content 3")
                              )
                            
                      )),
                      tabItem(tabName="chart2",
                      fluidRow(
                              leafletOutput("plot2",width=720, height=600)
                              ))  
        )
)


ui<-dashboardPage(header,siderbar,body, title = "Simple Shiny",skin="purple")