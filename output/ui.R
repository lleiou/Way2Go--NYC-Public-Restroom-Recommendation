library(shinydashboard)
library(shinyapps)
library(shiny)
library(dplyr)
library(leaflet)
library(data.table)
library(rgeos)
library(rgdal)
library(ggmap)

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
                       box(width = NULL, solidHeader = TRUE,
                           leafletOutput("map_output", height = 500)),
                       box(width = NULL,
                            uiOutput("restroomTable")
                       )),
                column(width = 3,
                       box(width = NULL, status = "warning",
                           textInput("address", "My location:"),
                           actionButton("go", "Go!"),
                           p("Click the button to update the value displayed in the main panel.")),
                        box(width = NULL, status = "warning",
                           
                           selectInput("range","Choose a range",choices=c(
                                   "100 m" = 100,
                                   "200 m" = 200,
                                   "300 m" = 300,
                                   "400 m" = 400,
                                   "500 m" = 500,
                                   "1000 m" = 1000),
                                   selected = NULL ),
                           actionButton("refresh", "Refresh!"))
                       
                       
                      )
                 )
               ),
        #Second tab Item
        tabItem(tabName = "chart",
        # Boxes need to be put in a row (or column)
        fluidRow(
                box(title="Histgram", status = "primary",solidHeader = TRUE, 
                    background="yellow", plotOutput("plot1", height = 250)),
                
                box(title = "Controls", status = "warning", solidHeader = TRUE,
                    #inputId="slider"
                    sliderInput("slider", "Number of observations:", 1, 100, 50),
                    textInput("text", "Text input:"))
                )
                )
)
)

ui<-dashboardPage(header,siderbar,body, title = "Simple Shiny",skin="purple")