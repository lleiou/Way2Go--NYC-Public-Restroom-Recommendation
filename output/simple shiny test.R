library(shinydashboard)
library(shiny)
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
                                        box(leafletOutput("map_output", height=450,width = 800)
                                      
                                  )
                                        
                                )
                        ),
                        
                        # Second tab content
                        tabItem(tabName = "widgets",h2("Widgets tab content")),
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

ui<- dashboardPage(header,siderbar,body, title = "Simple Shiny",skin="purple")

server <- function(input, output,session) {
        set.seed(122)
        histdata <- rnorm(500)
        output$plot1 <- renderPlot({data <- histdata[seq_len(input$slider)]
                hist(data)
                })
        output$stats<-renderPrint ({
                        summary(histdata)       
        })
        output$tmap_output <- renderLeaflet({tmap
          
        })
        output$wifimap_output <- renderLeaflet({wifimap
          
        })
        output$map_output <- renderLeaflet({map
          
        })
        
      
        
}

shinyApp(ui, server)