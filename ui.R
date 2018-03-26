# UI for work.pals
# March 2018

shinyUI(fluidPage(
  
  # Application title
  tags$h2("Network diagram of investigators"),
  p("Input your researchers` ", tags$a(href="https://orcid.org/content/orcid-public-data-file", "ORCID IDs"), ' and a diagram will be drawn with the width of the line proportional to the number of joint publications. Right click on the graph to save it. The diagram is drawn using the ', tags$a(href="https://cran.r-project.org/web/packages/diagram/index.html", "diagram package"), '.', sep=''),
  
strong("If there are missing links then please first check your ", tags$a(href="https://orcid.org/", "ORCID profile"),"as that may need updating."),

       p("The diagram will only include public works from the ORCID record that have a DOI. I cannot guarantee that the estimated number of joint papers are correct or complete."),

p("Please ", tags$a(href='mailto:a.barnett@qut.edu.au', 'e-mail'), ' me if you find a bug or have any suggested improvements. You might also like my ', tags$a(href="https://aushsi.shinyapps.io/orcid/", "other app"), "that creates a list researcher`s papers.", sep=''),

  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = "numInvestigators",
                   label = "Number of investigators",
                   min = 2,
                   max = 10,
                   step = 1,
                   value = 3),
      
      textInput(inputId = "orcid.id1",
                label = "ORCID ID (16 digits with 3 dashes)",
                value='0000-0003-3637-2423'),

      textInput(inputId = "orcid.id2",
                label = "ORCID ID (16 digits with 3 dashes)",
                value='0000-0001-6339-0374'),
      
      conditionalPanel(
        condition = "input.numInvestigators >= 3",
        textInput(inputId = "orcid.id3",
                  label = "ORCID ID (16 digits with 3 dashes)",
                  value='0000-0002-5559-3267')
      ),
      
      conditionalPanel(
        condition = "input.numInvestigators >= 4",
        textInput(inputId = "orcid.id4",
                  label = "ORCID ID (16 digits with 3 dashes)",
                  value='')
      ),
      
      conditionalPanel(
        condition = "input.numInvestigators >= 5",
        textInput(inputId = "orcid.id5",
                  label = "ORCID ID (16 digits with 3 dashes)",
                  value='')
      ),
      
      conditionalPanel(
        condition = "input.numInvestigators >= 6",
        textInput(inputId = "orcid.id6",
                  label = "ORCID ID (16 digits with 3 dashes)",
                  value='')
      ),
      
      conditionalPanel(
        condition = "input.numInvestigators >= 7",
        textInput(inputId = "orcid.id7",
                  label = "ORCID ID (16 digits with 3 dashes)",
                  value='')
      ),
      
      conditionalPanel(
        condition = "input.numInvestigators >= 8",
        textInput(inputId = "orcid.id8",
                  label = "ORCID ID (16 digits with 3 dashes)",
                  value='')
      ),
      
      conditionalPanel(
        condition = "input.numInvestigators >= 9",
        textInput(inputId = "orcid.id9",
                  label = "ORCID ID (16 digits with 3 dashes)",
                  value='')
      ),
      
      conditionalPanel(
        condition = "input.numInvestigators >= 10",
        textInput(inputId = "orcid.id10",
                  label = "ORCID ID (16 digits with 3 dashes)",
                  value='')
      ),
     
      # not working as desired 
    #  checkboxInput(inputId ="include.nums", "Include number of joint publications", TRUE),
      
    selectInput("box.type", "Node type",
                c("Square" = "square",
                  "Circle" = "circle",
                  "Diamond" = "diamond",
                  "Hexagon" = "hexa")),
    
    numericInput(inputId = "box.size",
                   label = "Node size",
                   min = 0.01,
                   max = 1.5,
                   step = 0.01,
                   value = 0.09),

      numericInput(inputId = "box.height",
                   label = "Node height",
                   min = 0.01,
                   max = 1.5,
                   step = 0.01,
                   value = 0.45),
      
      numericInput(inputId = "box.cex",
                   label = "Text size in node",
                   min = 1,
                   max = 3,
                   step = 0.05,
                   value = 1.25),
      
      selectInput("text.colour", "Text colour in node",
                  c("Black" = "black",
                    "White" = "white",
                    "Grey" = "grey",
                    "Green" = "green",
                    "Red" = "red",
                    "Blue" = "blue")),
      
      selectInput("box.colour", "Node fill colour",
                  c("White" = "white",
                    "Grey" = "grey",
                    "Green" = "green",
                  "Red" = "red",
      "Blue" = "blue")),
      
      selectInput("number.colour", "Node line colour",
                  c("Black" = "black",
                    "Grey" = "grey",
                    "Green" = "green",
                    "Red" = "red",
                    "Blue" = "blue"), 'blue'),
      
selectInput("line.colour", "Line colour",
            c("Black" = "black",
              "Grey" = "grey",
              "Green" = "green",
            "Red" = "red",
"Blue" = "blue"), 'grey'),

numericInput(inputId = "curve",
             label = "Line curve (0 = straight line)",
             min = 0.0,
             max = 1,
             step = 0.01,
             value = 0.0),

numericInput(inputId = "dtext",
             label = "Position of numbers relative to lines",
             min = 0.01,
             max = 1.5,
             step = 0.01,
             value = 0.3),

# report
downloadButton("report", "Generate Word document")

      ), # end of sidebar panel
    
    mainPanel(
      plotOutput(outputId = 'network'),
      h3('Warnings:'),
      textOutput(outputId = 'warnings')
    ) # end of main panel

)))
