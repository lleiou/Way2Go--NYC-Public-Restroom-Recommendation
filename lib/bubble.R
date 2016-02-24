SalesPop <- read.csv("SalesPop.csv")

library(plotly)
# note how size is automatically scaled and added as hover text]
plot_ly(x = SalesPop$sales , y = SalesPop$population,  plot_bgcolor="blue", size =SalesPop$NumberofRestrooms  , color=SalesPop$borough, mode = "markers")
