library(shinydashboard)
library(shinyapps)
library(shiny)
library(dplyr)
library(leaflet)
library(data.table)
library(rgeos)
library(rgdal)
library(ggmap)

div(class = "my-class", "Div content")
div(class = "my-class", p("Paragraph text"))
header<-dashboardHeader(title = "Search for Restroom!")

siderbar<-dashboardSidebar(
        sidebarMenu(
                menuItem("Map", tabName = "map", icon = icon("fa fa-map")),
                menuItem("Chart",tabName = "chart", icon = icon("fa fa-bar-chart"), badgeLabel = "new", badgeColor = "green")
        )
)
body<-dashboardBody(
        tabItems(
#                 # First tab content
#                 tabItem(tabName = "dashboard",
#                         # Boxes need to be put in a row (or column)
#                         fluidRow(
#                                 box(
#                                         title="Histgram", status = "primary",solidHeader = TRUE, 
#                                         background="yellow", plotOutput("plot1", height = 250)
#                                 ),
#                                 
#                                 box(
#                                         title = "Controls", status = "warning", solidHeader = TRUE,
#                                         #inputId="slider"
#                                         sliderInput("slider", "Number of observations:", 1, 100, 50),
#                                         textInput("text", "Text input:")
#                                 )
#                         )
#                 ),
                
                # First tab content:
                tabItem(tabName = "map", 
                        fluidRow(
                                leafletOutput("mymap"),
                                p(),
                                actionButton("recalc", "New points"),
                                textInput("address", "Address:"),
                                textInput("range","Choose a range:")
                        )
                ),
                #Second tab content
                                tabItem(tabName = "chart",
                                        # Boxes need to be put in a row (or column)
                                        fluidRow(
                                                box(
                                                        title="Histgram", status = "primary",solidHeader = TRUE, 
                                                        background="yellow", plotOutput("plot1", height = 250)
                                                ),
                                                
                                                box(
                                                        title = "Controls", status = "warning", solidHeader = TRUE,
                                                        #inputId="slider"
                                                        sliderInput("slider", "Number of observations:", 1, 100, 50),
                                                        textInput("text", "Text input:")
                                                )
                                        )
                                )                
#                 tabItem(tabName = "summary",
#                         fluidRow(
#                                 box(width = 10,
#                                     title = "Summary",
#                                     verbatimTextOutput("stats")
#                                 )
#                         )
#                 )
        )
)

ui<-dashboardPage(header,siderbar,body, title = "Simple Shiny",skin="purple")