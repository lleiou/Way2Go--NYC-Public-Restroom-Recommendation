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
header<-dashboardHeader(title = "Simple Shiny")
        
siderbar<-dashboardSidebar(
                sidebarMenu(
                        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                        menuItem("Widgets", tabName = "widgets", icon = icon("th")),
                        menuItem("Summary",tabName = "summary", icon = icon("list-alt"), badgeLabel = "new", badgeColor = "green")
                )
        )
body<-dashboardBody(
                tabItems(
                        # First tab content
                        tabItem(tabName = "dashboard",
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
                        ),
                        
                        # Second tab content:
                        tabItem(tabName = "widgets", 
                                fluidRow(
                                        leafletOutput("mymap"),
                                p(),
                                actionButton("recalc", "New points"),
                                textInput("address", "Address:"),
                                textInput("range","Choose a range:")
                                )
                                ),
                        #Third tab content
                        tabItem(tabName = "summary",
                                fluidRow(
                                        box(width = 10,
                                                title = "Summary",
                                                verbatimTextOutput("stats")
                                                )
                                        )
                                )
                )
        )

ui<-dashboardPage(header,siderbar,body, title = "Simple Shiny",skin="purple")

server <- function(input, output) {
        set.seed(122)
        histdata <- rnorm(500)
        output$plot1 <- renderPlot({data <- histdata[seq_len(input$slider)]
                hist(data)
                })
        output$stats<-renderPrint ({
                        summary(histdata)       
        })
       d_test<-geocode("3260 Henry Hudson Parkway,Bronx")
       content <- paste(sep ="<br/>","3260 Henry Hudson Parkway","Bronx,NY 10463")
       point<-reactive({geocode(input$address)
        })
        output$mymap <- renderLeaflet({
                data<-fread("NYCT.csv")
                #run if we get address put in else show my address 
                if (input$address == "") {
                 leaflet(data) %>%
                        #sets the center of the map view and the zoom level;
                        setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
                        addTiles() %>%
                        addMarkers(popup = ~htmlEscape(Location))%>%
                        addPopups(d_test$lon, d_test$lat, content,
                                  options = popupOptions(closeButton = FALSE))
                }
                else {
                        if (input$range == ""){
                        leaflet(data) %>%
                                #sets the center of the map view and the zoom level;
                                setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
                                addTiles() %>%
                                addMarkers(popup = ~htmlEscape(Location))%>%
                                addPopups(geocode(input$address)$lon, geocode(input$address)$lat, input$address,
                                          options = popupOptions(closeButton = FALSE))
                        }
                        else {
                                leaflet(data) %>%
                                        #sets the center of the map view and the zoom level;
                                        setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
                                        addTiles() %>%
                                        addMarkers(popup = ~htmlEscape(Location))%>%
                                        addPopups(geocode(input$address)$lon, geocode(input$address)$lat, input$address,
                                                  options = popupOptions(closeButton = FALSE))
                        }
                }
        })
}

shinyApp(ui, server)