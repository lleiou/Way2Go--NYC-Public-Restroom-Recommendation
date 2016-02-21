server <- function(input, output) {
        set.seed(122)
        d_test<-geocode("3260 Henry Hudson Parkway,Bronx")
        content <- paste(sep ="<br/>","3260 Henry Hudson Parkway","Bronx,NY 10463")
        my_address<-eventReactive(input$go,{input$address})
        
        
        output$map_output <- renderLeaflet({map})
        observe({
                code<-geocode(my_address())
                leafletProxy("map_output") %>%
                        clearPopups()%>%
                        #run if we get address put in else show my address 
                        setView(code$lon, code$lat,zoom=14)%>%
                        addPopups(code$lon, code$lat,my_address(), 
                                  options = popupOptions(closeButton = FALSE))
                
        })
      
        
        
                tdata_sub<-tdata[,7:8] 
        tdata_sub1<-tdata_sub[,c(2,1)]
        
        # range_1<-eventReactive(input$refresh,{input$range})
        
        output$map_output<- renderLeaflet({
                newdata<-subset(tdata,distHaversine(d_test,tdata_sub1) <= input$range)
                output$table <- DT::renderDataTable(DT::datatable(data <-newdata))
                map %>%
        
        # observe({ 
                       
                        #leafletProxy("map_output") %>%
                        #clearPopups()%>%
                        #run if we get address put in else show my address 
                        setView(d_test$lon, d_test$lat,zoom=11)%>%
                        hideGroup("Restrooms")%>%
                        addMarkers(data =newdata,icon=ToiletIcon)%>%
                        addCircles(d_test$lon, d_test$lat,
                                         radius = input$range,color="red")
#                         addPopups(d_test$lon, d_test$lat,
#                                   options = popupOptions(closeButton = FALSE))
                
        # })
})
}

