server <- function(input, output) {
        set.seed(122)
        d_test<-geocode("3260 Henry Hudson Parkway,Bronx")
        name1 <-newdata$Name
        location1 <- newdata$Location
        handicap1<-newdata$Handicap
        #separate the location name(bold) and the address(italic) into two lines
        name1 <- paste("<b>",name1,"</b>")
        location1 <- paste("<i>",location1,"</i>")
        handicap1 <- paste("<i>","handicap:",handicap1,"</i>")
        content1 <- paste(sep =  "<br/>",name1,location1,handicap1 )
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
                

                        
                        addMarkers(data =newdata,icon=ToiletIcon,group = "newdata",popup=content1)%>%
                        addCircles(code$lon, code$lat,radius = input$range,color="red",group = "newdata")
                
                
        })
        output$plot2<-renderLeaflet({map3})
        
}
             


