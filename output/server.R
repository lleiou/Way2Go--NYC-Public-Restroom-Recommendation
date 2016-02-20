server <- function(input, output) {
        set.seed(122)
        histdata <- rnorm(500)
        output$plot1 <- renderPlot({data <- histdata[seq_len(input$slider)]
        hist(data)
        })
        output$stats<-renderPrint ({
                summary(histdata)       
        })
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
#                 else {
#                         if (input$range == ""){
#                                 leaflet(data) %>%
#                                         #sets the center of the map view and the zoom level;
#                                         setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
#                                         addTiles() %>%
#                                         addMarkers(popup = ~htmlEscape(Location))%>%
#                                         addPopups(geocode(input$address)$lon, geocode(input$address)$lat, input$address,
#                                                   options = popupOptions(closeButton = FALSE))
#                         }
                        else {
                                leaflet(data) %>%
                                        #sets the center of the map view and the zoom level;
                                        setView(lng=-73.96884112664793,lat =40.78983730268673, zoom=11) %>% 
                                        addTiles() %>%
                                        addMarkers(popup = ~htmlEscape(Location))%>%
                                        addPopups(geocode(input$address)$lon, geocode(input$address)$lat, input$address,
                                                  options = popupOptions(closeButton = FALSE))
                        }
        })
}