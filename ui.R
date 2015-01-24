
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("(Quasi-)Monte Carlo Estimation of Pi"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("sampleSize",
                "Sample Size:",
                min = 1,
                max = 100000,
                value = 100),
    #checkboxInput("includeQuasiMC",
    #              "Include Quasi-Monte Carlo Estimate"),
    selectInput("secondPlot","Second Plot:",c("Trace","Quasi-Monte Carlo Samples")),
    tags$div(tags$h3("Explanation"),
             tags$p("This app aims to (briefly) introduce the user to the potential of Monte Carlo methods in general and Quasi-Monte Carlo methods specifically"),
             tags$p("Imagine we knew that the area of a circle was pi * R^2 but we didn't know the value of pi"),
             tags$p("We can estimate the area of a circle by taking random points in 2D space and testing if they fall within the cirlce"),
             tags$p("The area is then approximately the number of points in the circle divided by the total number of points"),
             tags$p("The accuracy of the approximation depends on the number of points generated"),
             tags$p("With the second plot set to trace, use the slider to see how the approximation changes as the sample size increase"),
             tags$p("Another way to improve the estimate of the area is to take points not entirely at random but which are evenly distributed in 2D space"),
             tags$p("This is Quasi-Monte Carlo. Set the second plot to show the Quasi-Monte Carlo samples and compare them with the standard Monte Carlo samples above"),
             tags$p("Refer to the Wikipedia articles on"),
             tags$a(href="http://en.wikipedia.org/wiki/Monte_Carlo_method","Monte Carlo"),
             tags$p("and"),
             tags$a(href="http://en.wikipedia.org/wiki/Quasi-Monte_Carlo_method","Quasi-Monte Carlo"),
             tags$p("if this has captured your interest!"))
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("circlePlot"),
    plotOutput("secondPlot"),
    textOutput("estimate"),
    textOutput("quasiEstimate")
  )
))
