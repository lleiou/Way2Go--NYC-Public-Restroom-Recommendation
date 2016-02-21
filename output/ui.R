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

header <- dashboardHeader(title = "Search for Restroom!")
siderbar<-dashboardSidebar(
        sidebarMenu(
                menuItem("Map", tabName = "map", icon = icon("fa fa-map")),
                menuItem("Chart",tabName = "chart", icon = icon("fa fa-bar-chart"), 
                         badgeLabel = "new", badgeColor = "green")
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
                                                 sliderInput("range", "Choose a range", 1, 50000,5000)
                        
                                             )
                                     )
                            ),
                          fluidRow(box(title = "table",width=800,DT::dataTableOutput("table")) )           
                         ),
        #Second tab Item
              tabItem(tabName = "chart")
        )
)

ui<-dashboardPage(header,siderbar,body, title = "Simple Shiny",skin="purple")