library(shinydashboard)
library(shiny)
library(ggmap)
#library(dplyr)
library(leaflet)
library(data.table)
#library(rgeos)
#ibrary(rgdal)
#library(ggmap)

div(class = "my-class", "Div content")
div(class = "my-class", p("Paragraph text"))
header<-dashboardHeader(title = "Search for Restroom")
        
siderbar<-dashboardSidebar(
                sidebarMenu(
                        menuItem("Map", tabName = "map", icon = icon("fa fa-map")),
                        menuItem("Chart",tabName = "chart", icon = icon("fa fa-bar-chart"), badgeLabel = "new", badgeColor = "green")
                )
        )
body<-dashboardBody(
                tabItems(
                        # First tab content
                        tabItem(tabName = "map", 
                                fluidRow(
                                       leafletOutput("map_output", height=450,width = 800),
                                        p(),
                                        textInput("address", "My location:"),
                                        textInput("range","Choose a range:"),
                                        actionButton("go", "Go!"),
                                        p("Click the button to update the value displayed in the main panel.")
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
                             )
                       )        
                        
ui<-dashboardPage(header,siderbar,body, title = "Simple Shiny",skin="purple")

server <- function(input, output) {
        set.seed(122)
       
       d_test<-geocode("3260 Henry Hudson Parkway,Bronx")
       content <- paste(sep ="<br/>","3260 Henry Hudson Parkway","Bronx,NY 10463")
       
       my_address<-eventReactive(input$go,{input$address}
                                 )
       
       output$map_output <- renderLeaflet({map})
       
       
       observe({
           code<-geocode(my_address())
           leafletProxy("map_output") %>%
            clearShapes()%>%
           #run if we get address put in else show my address 
           setView(code$lon, code$lat,zoom=14)%>%
           addPopups(code$lon, code$lat,my_address(), 
                     options = popupOptions(closeButton = FALSE))
           
       })
       
       
}

shinyApp(ui, server)