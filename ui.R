
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# Loading required libraries

library(shiny)
library(BH)
require(markdown)
require(data.table)
library(dplyr)
library(DT)

# A two Column format  is  used

shinyUI(fluidPage(

# Application title
  titlePanel("Predicting an Iris species using Petal & Sepal Length and Width Measurements"),

# Sidebar with a slider input for Petal and Sepal Width and Length. 4 in all
  sidebarLayout(
    sidebarPanel(
          
            sliderInput("PWidth", 
                  "Set Petal Width:", 
                  min = round(min(iris$Petal.Width) / 2, 1),
                  max = round(max(iris$Petal.Width) * 1.25, 1),
                  value = round(mean(iris$Petal.Width), 1)),
            
            sliderInput("PLength", 
                  "Set Petal Length:",
                  min = round(min(iris$Petal.Length) / 2, 1),
                  max = round(max(iris$Petal.Length) * 1.25, 1),
                  value = round(mean(iris$Petal.Length ), 1)),
            
            
            sliderInput("SWidth", 
                        "Set Sepal Width:", 
                        min = round(min(iris$Sepal.Width) / 2, 1),
                        max = round(max(iris$Sepal.Width) * 1.25, 1),
                        value = round(mean(iris$Sepal.Width), 1)),
            
            sliderInput("SLength", 
                        "Set Sepal Length:",
                        min = round(min(iris$Sepal.Length) / 2, 1),
                        max = round(max(iris$Sepal.Length) * 1.25, 1),
                        value = round(mean(iris$Sepal.Length ), 1)),
      
            actionButton(
                  inputId = "SubmitBtn",
                  label = "Predict Species")
    
            ),
    
    
# Show plots of Petal & Sepal Width and Length which are overlayed with Slider Values using a blue vertical line
    
    mainPanel(
          tabsetPanel(
                
# Create tabs for Plots with Prediction table, Data and an About info tab
                
                  tabPanel("Plot",
                  
                  plotOutput("plotPWidth", height = "120px"),
                  plotOutput("plotPLength", height = "120px"),
                  plotOutput("plotSWidth", height = "120px"),
                  plotOutput("plotSLength", height = "120px"),
                  
# Outout he prediction results in a table format
     
                  tableOutput("prediction")
                         ),

# Tabulate the "iris" data on a seperate tab for convenience           

                tabPanel("Data",
                  tableOutput("table")
                         ),

# The About info is stored in the about.md file in the working directory              
                tabPanel("About",
                         mainPanel(
                               includeMarkdown("about.md")
                         )
                ) 
    )
  )
)))
