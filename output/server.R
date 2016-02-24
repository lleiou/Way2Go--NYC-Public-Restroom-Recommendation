server <- function(input, output) {
        set.seed(122)
        d_test<-geocode("3260 Henry Hudson Parkway,Bronx")
        newdata<-tdata
        name1 <-newdata$Name
        location1 <- newdata$Location
        handicap1<-newdata$Handicap
        #separate the location name(bold) and the address(italic) into two lines
        name1 <- paste("<b>",name1,"</b>")
        location1 <- paste("<i>",location1,"</i>")
        handicap1 <- paste("<i>","handicap:",handicap1,"</i>")
        content1 <- paste(sep =  "<br/>",name1,location1,handicap1 )
        my_address<-eventReactive(input$go,{input$address})
        GPS<-eventReactive(input$mylocation,{getCurrentPosition()})
        
        
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
                        setView(code$lon, code$lat,zoom=13)%>%
                        addPopups(code$lon, code$lat,"I'm Here", 
                                  options = popupOptions(closeButton = TRUE))%>%
                        hideGroup("Restrooms")%>%
                        addMarkers(data =newdata,icon=ToiletIcon,group = "newdata",popup=content1)%>%
                        addCircles(code$lon, code$lat,radius = input$range,color="red",group = "newdata")
                
                
        })
        observe({
          t<-GPS()
          code<-cbind(t$longitude,t$latitude) 
          tdata_sub<-tdata[,7:8] 
          tdata_sub1<-tdata_sub[,c(2,1)]
          newdata<-subset(tdata,distHaversine(code,tdata_sub1) <= input$range)
          output$table <- DT::renderDataTable(DT::datatable(data <-newdata))
          leafletProxy("map_output") %>%
            clearPopups()%>%
            clearGroup("newdata")%>%
            #run if we get address put in else show my address 
            setView(code[1], code[2],zoom=13)%>%
            addPopups(code[1], code[2],"I'm Here", 
                      options = popupOptions(closeButton = TRUE))%>%
            hideGroup("Restrooms")%>%
            
            addMarkers(data =newdata,icon=ToiletIcon,group = "newdata",popup=content1)%>%
            addCircles(code[1], code[2],radius = input$range,color="red",group = "newdata")
          
          
        })
        
        observeEvent(input$switch1,output$map_output<-renderLeaflet({map3}))
        output$plot1<-renderPlot({map1})
        output$plot2<-renderLeaflet({map3})
        output$plot3<-renderPlot({map_pop})
        output$plot4<-renderPlot({map_hos})
        output$plot_1<-renderPlotly({plot_1})
        output$plot_2<-renderPlotly({plot_2})
        output$plot_3<-renderPlotly({plot_3})
        output$plot_4<-renderPlotly({plot_4})
        output$plot_5<-renderPlotly({plot_5})
        output$plot_6<-renderPlotly({plot_6})
        
        
}
             


