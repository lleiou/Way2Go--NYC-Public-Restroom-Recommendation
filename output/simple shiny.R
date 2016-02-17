library(shinydashboard)
library(shinyapps)
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
                                        box(
                                                title="Histgram", status = "primary",solidHeader = TRUE, 
                                                background="yellow", plotOutput("plot1", height = 250)
                                             ),
                                        
                                        box(
                                                title = "Controls", status = "warning", solidHeader = TRUE,
                                                sliderInput("slider", "Number of observations:", 1, 100, 50),
                                                textInput("text", "Text input:")
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
}

shinyApp(ui, server)