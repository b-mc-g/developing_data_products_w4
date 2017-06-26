
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(randomForest)
library(caret)
library(ggplot2)

# Create Random Forest Model

set.seed(299)

build_RFModel <- function() {
      Control <- trainControl(method = "cv", number = 5)
      FModel<- train(Species ~ ., data = iris,
                     method = "rf",
                     trControl = Control,
                     allowParallel=TRUE)
      return(FModel)
}

WhichIris <- function(trainedModel, inputs) {
      prediction <- predict(trainedModel,
                            newdata = inputs,
                            type = "prob",
                            predict.all = TRUE)
      return(renderTable(prediction))
}


shinyServer(function(input, output, session) {
      
      output$table <- renderTable({iris
      })
      
# Show plots of Petal & Sepal Width and Length which are overlayed 
# reactively with Slider Values using a blue vertical line   
      
      output$plotPWidth <- renderPlot({
            ggplot(iris, aes(x = Petal.Width,
                             group = Species,
                             fill = as.factor(Species))) + 
                  geom_density(position = "identity", alpha = 0.5) +
                  scale_fill_discrete(name = "Species") +
                  theme_bw() +
                  xlab("Petal Width") +
                  geom_vline(xintercept = input$PWidth,
                             color = "blue",
                             size = 1.5) +
                  scale_x_continuous(limits = c(round(min(iris$Petal.Width) / 2, 1),
                                                round(max(iris$Petal.Width) * 1.25, 1)))
            
      })
      
      output$plotPLength <- renderPlot({
            ggplot(iris, aes(x = Petal.Length,
                             group = Species,
                             fill = as.factor(Species))) + 
                  geom_density(position = "identity", alpha = 0.5) +
                  scale_fill_discrete(name = "Species") +
                  theme_bw() +
                  xlab("Petal Length") +
                  geom_vline(xintercept = input$PLength,
                             color = "blue",
                             size = 1.5) +
                             scale_x_continuous(limits = c(round(min(iris$Petal.Length) / 2, 1),
                                                round(max(iris$Petal.Length) * 1.25, 1)))
            
      })
      
      output$plotSLength <- renderPlot({
            ggplot(iris, aes(x = Sepal.Length,
                             group = Species,
                             fill = as.factor(Species))) + 
                  geom_density(position = "identity", alpha = 0.5) +
                  scale_fill_discrete(name = "Species") +
                  theme_bw() +
                  xlab("Sepal Length") +
                  geom_vline(xintercept = input$SLength,
                             color = "blue",
                             size = 1.5) +
                  scale_x_continuous(limits = c(round(min(iris$Sepal.Length) / 2, 1),
                                                round(max(iris$Sepal.Length) * 1.25, 1)))
            
      })
      
      output$plotSWidth <- renderPlot({
            ggplot(iris, aes(x = Sepal.Width,
                             group = Species,
                             fill = as.factor(Species))) + 
                  geom_density(position = "identity", alpha = 0.5) +
                  scale_fill_discrete(name = "Species") +
                  theme_bw() +
                  xlab("Sepal Width") +
                  geom_vline(xintercept = input$SWidth,
                             color = "blue",
                             size = 1.5) +
                  scale_x_continuous(limits = c(round(min(iris$Sepal.Width) / 2, 1),
                                                round(max(iris$Sepal.Width) * 1.25, 1)))
            
      })
      
# Create  Random Forwct Model using a reactive expression and the build RFModel function defined in server.R
      
            CreateModel <- reactive({
            build_RFModel()
      })
      
# Given Petal & Sepal Length and Width Values, predict the Iris species based on the Random Forest Model built above
# and when the "Predict Species" button is pressed

                  
# Check for the event and create a popup (see bottom right) for progress indication during mmodel creation
            
      observeEvent(
            eventExpr = input[["SubmitBtn"]],
            handlerExpr = {
                  withProgress(message = 'Generating the RF model...', value = 0, {
                        RFModel <- CreateModel()
                  })
                  
# Collect the values from the sliders for input into the  prediction step
# The server calculation are displayed after the user selects values and presses the Predict Species button
                  
                  Petal.Length <- input$PLength
                  Petal.Width <- input$PWidth
                  Sepal.Length <- input$SLength
                  Sepal.Width <- input$SWidth
                  
                  Submission <- data.frame ( Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)
                  
                  PredictedResult <- WhichIris(RFModel, Submission)
                  output$prediction <- PredictedResult #generate the prediction table
            })
})
