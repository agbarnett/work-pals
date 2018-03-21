# server for work.pals
# March 2018

shinyServer(function(input, output) {
  
  source('network.R')

  # reactive function to get publication data
  results <- reactive({
    id.no.spaces1 = input$orcid.id1
    id.no.spaces1 = gsub(' $', '', id.no.spaces1) # remove trailing space

    id.no.spaces2 = input$orcid.id2
    id.no.spaces2 = gsub(' $', '', id.no.spaces2) # remove trailing space
 
    id.no.spaces3 = input$orcid.id3
    id.no.spaces3 = gsub(' $', '', id.no.spaces3) # remove trailing space
    
    id.no.spaces4 = input$orcid.id4
    id.no.spaces4 = gsub(' $', '', id.no.spaces4) # remove trailing space
 
    id.no.spaces5 = input$orcid.id5
    id.no.spaces5 = gsub(' $', '', id.no.spaces5) # remove trailing space
    
    id.no.spaces6 = input$orcid.id6
    id.no.spaces6 = gsub(' $', '', id.no.spaces6) # remove trailing space
    
    id.no.spaces7 = input$orcid.id7
    id.no.spaces7 = gsub(' $', '', id.no.spaces7) # remove trailing space
    
    validate(
      need(nchar(id.no.spaces1) == 19, 
           paste("ID 1 needs fixing. ORCID IDs should be 16 numbers separated by three dashes, e.g., 0000-0002-2358-2440", sep=''))
    )

    validate(
      need(nchar(id.no.spaces2) == 19, 
           paste("ID 2 needs fixing. ORCID IDs should be 16 numbers separated by three dashes, e.g., 0000-0002-2358-2440", sep=''))
    )
    
    
    # bind IDs
    ids.no.spaces  = c(id.no.spaces1,id.no.spaces2,id.no.spaces3,id.no.spaces4,id.no.spaces5,id.no.spaces6,id.no.spaces7)
    ids.no.spaces = ids.no.spaces[ids.no.spaces!=''] # remove missing IDs
    
    withProgress(message = 'Getting data from ORCID/Crossref', 
                 detail = 'This may take a while...', value=0, {
      res = my.network(orcid.ids=ids.no.spaces)
                   incProgress(1)
    })
    return(res)
  })
  
  # table of papers:
  output$network <- renderPlot({
    par(mai=c(0.02,0.02,0.02,0.02))
    plotmat(results()$M.dash, name = results()$names, curve=0, arr.width = 0, dtext=0.1, box.col = input$box.colour,
                 box.lwd = 2, cex = 1.1, box.size = input$box.size, shadow.size=0, box.cex=input$box.cex,
                 box.type = input$box.type, txt.col = input$text.colour,
            box.prop = input$box.height, arr.lcol=input$line.colour, arr.lwd=results()$M)
    
    })
  
  # report for download; see https://shiny.rstudio.com/articles/generating-reports.html
  # and here http://stackoverflow.com/questions/37018983/how-to-make-pdf-download-in-shiny-app-response-to-user-inputs
  output$report <- downloadHandler(
    filename = function(){
      paste("report.docx", sep='') # could expand, e.g., see here: 
    },
    content = function(file){
      
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      #tempReport <- "C:/temp/report.Rmd"
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      
      params = list(orcid.id = input$orcid.id, 
           style = input$style)
      
      out = rmarkdown::render(
          input = tempReport,
          output_file = file,
          params = params,
          envir = new.env(parent = globalenv())
        ) 
      file.rename(out, file)
    }
  )
  
})
