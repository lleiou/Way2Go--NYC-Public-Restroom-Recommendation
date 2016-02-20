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
      
        
#         
#                 tdata_sub<-tdata[,7:8] 
#         tdata_sub1<-tdata_sub[,c(2,1)]
#         range<- as.numeric(input$range)
#         range_1<-eventReactive(input$refresh,{input$range})
#         
#         output$map_output<- renderLeaflet({map})
#         
#         observe({ 
#                         newdata<-subset(tdata,distHaversine(code,tdata_sub1) <=range_1())
#                         leafletProxy("map_output") %>%
#                         clearPopups()%>%
#                         #run if we get address put in else show my address 
#                         setView(code$lon, code$lat,zoom=14)%>%
#                         hideGroup("Restrooms")%>%
#                         addMarkers(data =newdata, group = "Restrooms",popup = content, icon=ToiletIcon)%>%
#                         addPopups(code$lon, code$lat,my_address(), 
#                                   options = popupOptions(closeButton = FALSE))
#                 
#         })
        }
