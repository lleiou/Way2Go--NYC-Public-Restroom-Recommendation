server <- function(input, output) {
        set.seed(122)
        d_test<-geocode("3260 Henry Hudson Parkway,Bronx")
        content <- paste(sep ="<br/>","3260 Henry Hudson Parkway","Bronx,NY 10463")
        my_address<-eventReactive(input$go,{input$address})
        
        
        output$map_output <- renderLeaflet({map})
        observe({
                code<-geocode(my_address())
                tdata_sub<-tdata[,7:8] 
                tdata_sub1<-tdata_sub[,c(2,1)]
                newdata<-subset(tdata,distHaversine(code,tdata_sub1) <= input$range)
                output$table <- DT::renderDataTable(DT::datatable(data <-newdata))
                leafletProxy("map_output") %>%
                        clearPopups()%>%
                        clearGroup("newdata")%>%
                        #run if we get address put in else show my address 
                        setView(code$lon, code$lat,zoom=11)%>%
                        addPopups(code$lon, code$lat,"I'm Here", 
                                  options = popupOptions(closeButton = TRUE))%>%
                        hideGroup("Restrooms")%>%
                        
                        
                        addMarkers(data =newdata,icon=ToiletIcon,group = "newdata",popup = ~htmlEscape(Location))%>%
                        addCircles(code$lon, code$lat,radius = input$range,color="red",group = "newdata")
                
                
        })
        
}
             


