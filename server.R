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

    id.no.spaces8 = input$orcid.id8
    id.no.spaces8 = gsub(' $', '', id.no.spaces8) # remove trailing space

    id.no.spaces9 = input$orcid.id9
    id.no.spaces9 = gsub(' $', '', id.no.spaces9) # remove trailing space

    id.no.spaces10 = input$orcid.id10
    id.no.spaces10 = gsub(' $', '', id.no.spaces10) # remove trailing space
    
    validate(
      need(nchar(id.no.spaces1) == 19, 
           paste("ID 1 needs fixing. ORCID IDs should be 16 numbers separated by three dashes, e.g., 0000-0002-2358-2440", sep=''))
    )

    validate(
      need(nchar(id.no.spaces2) == 19, 
           paste("ID 2 needs fixing. ORCID IDs should be 16 numbers separated by three dashes, e.g., 0000-0002-2358-2440", sep=''))
    )
    
    # bind IDs
    ids.no.spaces  = c(id.no.spaces1,id.no.spaces2,id.no.spaces3,id.no.spaces4,id.no.spaces5,id.no.spaces6,id.no.spaces7,id.no.spaces8,id.no.spaces9,id.no.spaces10)
    ids.no.spaces = ids.no.spaces[ids.no.spaces!=''] # remove missing IDs
    
    withProgress(message = 'Getting data from ORCID', 
                 detail = 'This may take a while...', value=0, {
      res = my.network(orcid.ids=ids.no.spaces) #, remove.labels=input$include.nums)
                   incProgress(1)
    })
    return(res)
  })
  
  # plot:
  output$network <- renderPlot({
    # plot
    par(mai=c(0.02,0.02,0.02,0.02))
    plotmat(results()$M.dash, name = results()$names, curve=input$curve, arr.width = 0, box.col = input$box.colour, box.lcol = input$number.colour,
                 box.lwd = 2, cex = 1.1, box.size = input$box.size, shadow.size=0, box.cex=input$box.cex,
                 box.type = input$box.type, txt.col = input$text.colour,
            dtext=input$dtext,
            box.prop = input$box.height, arr.lcol=input$line.colour, arr.lwd=results()$M)
    
    })

  # warnings
  output$warnings <- renderText({
    if(is.null(results()$warnings)==T){text = 'No warnings'}
    if(is.null(results()$warnings)==F){text = results()$warnings}
    return(text)
  })
  
  # report
  output$report <- downloadHandler(
    filename = function(){
      paste("report.docx", sep='') # 
    },
    content = function(file){
      
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      
      params = list(orcid.ids1 = input$orcid.id1, 
                    orcid.ids2 = input$orcid.id2, 
                    orcid.ids3 = input$orcid.id3, 
                    orcid.ids4 = input$orcid.id4, 
                    orcid.ids5 = input$orcid.id5, 
                    orcid.ids6 = input$orcid.id6, 
                    orcid.ids7 = input$orcid.id7, 
                    orcid.ids8 = input$orcid.id8, 
                    orcid.ids9 = input$orcid.id9, 
                    orcid.ids10 = input$orcid.id10, 
                    curve = input$curve,
                    dtext = input$dtext,
                    line.colour = input$line.colour,
                    box.colour = input$box.colour,
                    number.colour = input$number.colour,
                    text.colour = input$text.colour,
                    box.cex = input$box.cex,
                    box.height = input$box.height,
                    box.size = input$box.size,
                    box.type = input$box.type)
      
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
