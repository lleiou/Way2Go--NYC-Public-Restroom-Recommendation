library(shinydashboard)
library(shiny)
library(dplyr)
library(leaflet)
library(data.table)
library(rgeos)
library(rgdal)
library(ggmap)
library(geosphere)
library(DT)
library(shinyapps)

source("plot.R")

header <- dashboardHeader(title = "Way2Go")
siderbar<-dashboardSidebar(
        sidebarMenu(
                menuItem("Locate", tabName = "map", icon = icon("fa fa-map-marker"),badgeLabel = "TryMe!", badgeColor = "green"),
                menuItem("Statistic Analysis",tabName = "stats", icon = icon("fa fa-bar-chart"), 
                         
                         menuSubItem("Density Map",icon = icon("fa fa-map"),tabName = "chart1"),
                         menuSubItem("Income map",icon = icon("fa fa-usd"),tabName = "chart2"),
                         menuSubItem("Bar Chart",icon = icon("fa fa-area-chart"),tabName = "chart3")),
                menuItem("About Us", tabName = "About", icon = icon("fa fa-user"))
        )
)
body <- dashboardBody(
        
        tabItems(
                # First tab content
                tabItem(tabName = "map",
                        fluidRow(
                                column(width = 9,
                                       box(width = NULL, solidHeader = TRUE,leafletOutput("map_output", height = 500)
                                       )
                                       
                                ),
                                column(width = 3,
                                       box(width = NULL, status = "warning",
                                           textInput("address", "My location:"),
                                           actionButton("go", "Go!"),
                                           p("Click the button to update the value displayed in the main panel.") 
                                       ),
                                       box(width = NULL, status = "warning",
                                           sliderInput("range", "Choose a range", 1, 2000,1000),
                                           p("Distance in meter")
                                           
                                       ),
                                       fluidRow(width=150, height=80,
                                                actionButton("mylocation", "My Location"),
                                                actionButton("switch1","Switch"),
                                                p("Click the button to update the value displayed in the main panel."),
                                                img(src = "images.png",width=80, height=80))
                                )
                        ),
                        fluidRow(box(title = "table",width=800,DT::dataTableOutput("table")) )           
                ),
                #Second tab Item
                tabItem(tabName = "chart1",
                        fluidRow(
                                tabBox(width=12,height = 10,
                                       title = "",
                                       # The id lets us use input$tabset1 on the server to find the current tab
                                       id = "tabset1", 
                                       tabPanel("Restroom Density Map", plotOutput("plot1")),
                                       tabPanel("Population Density Map", plotOutput("plot3")),
                                       tabPanel("Housing Price Density Map", plotOutput("plot4"))
                                )
                                
                        )),
                tabItem(tabName="chart2",
                        fluidRow(
                                leafletOutput("plot2",width=720, height=600)
                        )),
                
                tabItem(tabName ="chart3" ,
                        fluidRow(
                                tabBox(width=12,height = 10,
                                       # The id lets us use input$tabset1 on the server to find the current tab
                                       id = "tabset2", 
                                       
                                       tabPanel("Plot1", plotlyOutput("plot_1"),h2("General Analysis"),p("The main data we use comes form NYC Open Data, we not only consider the restrooms in public parks, since the number of parks in the city is limited, so not everyone can find a park nearby, so we also take into account the public restrooms in other public facilities like public libraries, public hosoitals, fast food restaurants and so on. By adding more public facilities into the dataset, our investigation makes more sense and have a better realistic meaning.
                                                                                                         
                                                                                                         ")),
                                       tabPanel("Plot2", plotlyOutput("plot_2"),p("However, simply making this inference cannot satisfy our needs. The zip code is just a separation of the geographical areas, which contains less information about the region it represents, what's more, different areas have different situations, putting them together means ignoring their difference, which does no good to our investigation. It might help if we could look at the data by different groups, here in NYC, we consider to use the borough as the standard of separation.
                                                                                  
                                                                                  ")),
                     tabPanel("Plot3", plotlyOutput("plot_3"),p("But this is just the total number of the toilets in different districts, which fails to fonsider the population of each district. Here, to make the question simple, we make an assumption that given other factors the same, the huge the population, the more people need to use the public restroom. Thus, what really interest us is the ratio of number of toilet under a zipcode to the total population under the zipcode. The ratio not only tells the pressure of people's using public restrooms, but also becomes a proper indicator in our recommendation system.")),
                     tabPanel("Plot4", plotlyOutput("plot_4"),p("From this plot we can see that the relationship has some change, although Manhattan has a higher number of public restrooms in total, the number that everyone can own is almost the same as that in other boroughs. The same situation happens in Brooklyn, where the number of toilets : population is pretty low. We can make an inference that it is harder for people in these two boroughs to use the toilet as easy and quick as possible.

                                                                ")),
                     tabPanel("Plot5", plotlyOutput("plot_5"),p("As we discussed before, it makes more sense to see the number of restrooms that everyone can ow.")),
                     tabPanel("Plot6", plotlyOutput("plot_6"),h2("Conclusion and Advice"),p("It turns out that the higher the housing price is, the less restroom every person owns, indicates that the more the higher the population, the less part of the restrooms a man can own, which might be because there are less place for public facilities in higher housing price areas, and it costs higher to build public restrooms in these areas.

                                                                                            , which indicates that it's harder to use the toilet in places like CBD or CVD."),p("On the other hand, the higher the population the less restroom a man can own, which means that it is harder to use the public restrooms in high population areas, such as places of interests, terminals (wait in a long line) and so on.
                                                                                                                                                                                
                                                                                                                                                                                "),p("So now we try to figure out a resonable explaination of the distribution above. Here we choose some factors that interest us: population of every borough, gdp of every borough, we draw a scatterplot matrix at first, and then get rid of the factors that doesn't show strong coorelation with the density of the toilet."),p("To sum up, we find a genral pattern for the distribution of the public restrooms in NYC, and also the problems that reflct from this pattern.From our investigation on the data above, we stronly suggest the local government in Queens and Brooklyn to build more public restrooms in the areas where housing price is low and population is high."),p("To sum up, we find a genral pattern for the distribution of the public restrooms in NYC, and also the problems that reflct from this pattern.From our investigation on the data above, we stronly suggest the local government in Queens and Brooklyn to build more public restrooms in the areas where housing price is low and population is high."),p("Above is our analysis of the restroom data, since we have already known well about the relationship between factors, we might want to take advantage of it. Thus, we created a recommendation system for people outdoors in NYC, by inputing some key factors we have mentioned above, we can help the user to go to the most satisfying restroom as quick as possible."),p("We call our app: Way2Go."))
              )
            )),
    
    
    tabItem(tabName = "About",box(title="About Us",width = 400,height = 500,p("Click the button to update the value displayed in the main panel.")))
    
    
  )
)


ui<-dashboardPage(header,siderbar,body, title = "Simple Shiny",skin="purple")