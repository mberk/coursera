
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(randtoolbox)

shinyServer(function(input, output) {
  
  generateRandomNumbers <- reactive({
    set.seed(123)
    x <- runif(input$sampleSize)
    y <- runif(input$sampleSize)
    #if(input$includeQuasiMC)
    #{
      r <- sobol(input$sampleSize,dim=2)
      return(list(x=x,y=y,quasiX=r[,1],quasiY=r[,2]))
    #}
    #else
    #{
    #  return(list(x=x,y=y)) 
    #}
  })
  
  output$circlePlot <- renderPlot({
    
    plot(x=c(0,1),y=c(0,1),xlab="x",ylab="y",type="n")    
    xy <- generateRandomNumbers()
    inCircle <- (xy$y-0.5)^2 + (xy$x-0.5)^2 < 0.5^2
    
    points(x=xy$x,y=xy$y,cex=0.25,col=ifelse(inCircle,"blue","red"))
    
    curve(sqrt(0.5^2-(x-0.5)^2)+0.5,from=0,to=1,add=TRUE,col="black",lwd=2) 
    curve(-sqrt(0.5^2-(x-0.5)^2)+0.5,from=0,to=1,add=TRUE,col="black",lwd=2)
  })
  
  output$secondPlot <- renderPlot({
    if(input$secondPlot=="Trace")
    {
      xy <- generateRandomNumbers()
      
      inCircle <- (xy$y-0.5)^2 + (xy$x-0.5)^2 < 0.5^2
      
      if(input$sampleSize>1000 & input$sampleSize<10000)
      {
        plot(4*cumsum(inCircle)/(1:length(xy$x)),type="l",xlab="Samples",
             ylab="Estimate",
             ylim=c(2.8,3.3))
      }
      else if(input$sampleSize>10000 & input$sampleSize<50000)
      {
        plot(4*cumsum(inCircle)/(1:length(xy$x)),type="l",xlab="Samples",
             ylab="Estimate",
             ylim=c(3.0,3.3))
      }
      else if(input$sampleSize>50000)
      {
        plot(4*cumsum(inCircle)/(1:length(xy$x)),type="l",xlab="Samples",
             ylab="Estimate",
             ylim=c(3.1,3.2))
      }    
      else
      {
        plot(4*cumsum(inCircle)/(1:length(xy$x)),type="l",xlab="Samples",
             ylab="Estimate")
      }
      
      #if(input$includeQuasiMC)
      #{
        inCircle <- (xy$quasiY-0.5)^2 + (xy$quasiX-0.5)^2 < 0.5^2
        lines(4*cumsum(inCircle)/(1:length(xy$x)),col="blue")
        
        legend("topright",
               legend=c("Monte Carlo","Quasi-Monte Carlo"),
               lty=rep("solid",2),
               col=c("black","blue"))
      #}
      
      abline(h=pi,col="red")
    }
    else if(input$secondPlot=="Quasi-Monte Carlo Samples")
    {
      plot(x=c(0,1),y=c(0,1),xlab="x",ylab="y",type="n")    
      xy <- generateRandomNumbers()
      inCircle <- (xy$quasiY-0.5)^2 + (xy$quasiX-0.5)^2 < 0.5^2
      
      points(x=xy$quasiX,y=xy$quasiY,cex=0.25,col=ifelse(inCircle,"blue","red"))
      
      curve(sqrt(0.5^2-(x-0.5)^2)+0.5,from=0,to=1,add=TRUE,col="black",lwd=2) 
      curve(-sqrt(0.5^2-(x-0.5)^2)+0.5,from=0,to=1,add=TRUE,col="black",lwd=2)
    }
  })
  
  output$estimate <- renderText({
    xy <- generateRandomNumbers()
    
    inCircle <- (xy$y-0.5)^2 + (xy$x-0.5)^2 < 0.5^2
    result <- paste0("Monte Carlo estimate: ",4 * sum(inCircle)/length(xy$x))
    return(result)
  })
  
  output$quasiEstimate <- renderText({
    #if(input$includeQuasiMC)
    #{
      xy <- generateRandomNumbers()
    
      inCircle <- (xy$quasiY-0.5)^2 + (xy$quasiX-0.5)^2 < 0.5^2
      result <- paste0("Quasi-Monte Carlo estimate: ",
                       4 * sum(inCircle)/length(xy$x))
    #}
    #else
    #{
    #  result <- ""
    #}
    return(result)
  })
})
