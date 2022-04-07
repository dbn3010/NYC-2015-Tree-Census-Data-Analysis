
library(shiny)


fluidPage(
  

  headerPanel('NYC 2015 Tree Census Data'),
  fluidRow(
    
    column(3, img(height = 70, width = 70, src = "neu.png")),
    column(8, ""), 
    column(1, img(height = 80, width = 80, src = "nycparks.png"))
    
    
  ),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(inputId = "borough",
                         label = "Borough in New York:",
                         choices = list('Bronx' = 'Bronx', 
                                        'Queens' = 'Queens',
                                        'Brooklyn' = 'Brooklyn',
                                        'Manhattan' = 'Manhattan',
                                        'Staten Island' = 'Staten Island'),
                         selected = c('Bronx','Queens','Brooklyn','Manhattan','Staten Island')),
      
      hr(),
      
      sliderInput(inputId = "dbh",
                  label = "Tree Diameter",
                  min = 0,
                  max = 50,
                  value = 50
        
      ),
      
      hr(),
      
      checkboxGroupInput(inputId = "problem",
                   label = "Trees with Problem",
                   choices = list('Root' = 'Root', 
                                  'Trunk' = 'Trunk',
                                  'Branch' = 'Branch',
                                  'Multiple' = 'Multiple',
                                  'None' = 'None'),
                   selected = c('None', 'Root', 'Trunk', 'Branch', 'Multiple')
      ),
      
      checkboxGroupInput(inputId = "guards",
                   label = "Trees with Guard",
                   choices = list('Helpful' = 'Helpful', 
                                  'Harmful' = 'Harmful',
                                  'Unsure' = 'Unsure',
                                  'None' = 'None'),
                   selected = c('Helpful', 'Harmful', 'Unsure', 'None')
      ),
      
      checkboxGroupInput(inputId = "sidewalk",
                  label = "Trees with Sidewalk",
                  choices = list('Damage' = 'Damage', 
                                 'NoDamage' = 'NoDamage',
                                 'Unsure' = 'Unsure'),
                  selected = c('NoDamage', 'Damage', 'Unsure')
      ),
      
      
      
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Summary of Tree Count in New York", 
                 br(),
                 textOutput('text1'),
                 br(),
                 tags$head(tags$style("#text{color: steelblue;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
                 )
                 ),
                 tags$head(tags$style("#text1{color: steelblue;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
                 )
                 ),
                 br(),
                 splitLayout(tableOutput("table"), tableOutput("table_h"), align="center"),
                 br(),
                 br(),
                 textOutput('text'),
                 br(),
                 plotOutput("overall"),
                 
        ),
       tabPanel("Tree Attributes Analysis", 
                br(),
                textOutput('text2'),
                br(),
                tags$head(tags$style("#text2{color: steelblue;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
                )
                ),
                br(),
                plotOutput("boxplot",height = "466")
                ),
       tabPanel("Top Species and Boroughs",
                br(),
                textOutput('text3'),
                br(),
                tags$head(tags$style("#text3{color: steelblue;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
                )
                ),
                br(),
                plotOutput('treemap')
                
                )
      
      )
      
      
    )
    
  )
)
