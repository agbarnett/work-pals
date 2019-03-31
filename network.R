# network.R
# Take ORCID IDs and make a network diagram in shiny
# March 2019
# TO DO, add affiliations, guess from most recent paper?

# examples
# orcid.ids = c('0000-0003-3637-2423','0000-0001-6339-0374','0000-0002-5559-3267','0000-0001-6463-6719') # me, Nick, Anisa, Nina
#orcid.ids = c('0000-0001-6339-0374', # adrian
#              '0000-0003-3400-2816', # james
#              '0000-0003-3205-9165', # ingrid Hickman
#              '0000-0001-5650-154X', # Sanj
#              '0000-0001-5008-8061', # powell
#              '0000-0002-6612-348X') # David 

# set token as an environmental variable (March 2018)
x <- "07073399-4dcc-47b3-a0a8-925327224519"
Sys.setenv(ORCID_TOKEN=x)

# main function
my.network = function(orcid.ids, remove.labels=TRUE){
  warnings = NULL
  n.names = length(orcid.ids)
  
  # check for repeated ORCID
  if(any(table(orcid.ids) > 1)){
    repeated = names(which(table(orcid.ids)>1))
    warn = paste('Repeated ORCIDs for ', repeated, '.\n', sep='')
    warnings = c(warnings, warn)
    # remove repeats
    orcid.ids = unique(orcid.ids)
    n.names = length(orcid.ids)
  }
  
  # a) get names (loop)
  names = all.dois = NULL
  person.number = 0 # need a specific person count for when people drop out
  for (k in 1:n.names){
    bio = orcid_id(orcid = orcid.ids[k], profile='profile') # get basics
    first = bio[[1]]$`name`$`given-names`$value
    surname = bio[[1]]$`name`$`family-name`$value
    # add affiliation here?
    name = paste(gsub(' ', '', first), '\n', gsub(' ', '', surname), sep='')
 
  # b) get works and transform to DOss
    d = works(orcid_id(orcid = orcid.ids[k])) # get works as a tibble
    if(nrow(d) == 0){
      warn = paste('No public works for ', gsub('\n', ' ', name), '\n.', sep='')
      warnings = c(warnings, warn)
      # reduce number of names
      n.names = n.names - 1 
    }
    if(nrow(d) > 0){
      person.number = person.number + 1
    #  cat('person.number', person.number,'\n')
      names = c(names, name) # add to list of names
      dois = identifiers(d, type='doi') # get DOIs, not available for all papers
      dois = dois[duplicated(dois)==F]
      # to do, get EIDs where there's no DOI
      frame =  data.frame(k=person.number, name=name, dois=dois)
      all.dois = rbind(all.dois, frame)
    }
  }
  # switch DOIs to lower case as this helps with matching
  all.dois$dois = tolower(all.dois$dois)
  
  # matrix M of links
  M = matrix(nrow = n.names, ncol = n.names, byrow = TRUE, data = 0)

  # find common papers
  tab = with(all.dois, table(dois, k))
  tab[tab>1] = 1
  tab = tab[rowSums(tab)>1, ] # rows with a match
  if(nrow(tab)>0){ # only if there's some matches
    for (j in 1:nrow(tab)){
      pairs = as.numeric(names(which(tab[j,] == 1)))
      combs = combn(pairs, 2)
      for (k in 1:ncol(combs)){
        M[combs[1,k], combs[2,k]] = M[combs[1,k], combs[2,k]] + 1
      }
    }
  }
  
  # remove labels (option)
  M.dash = M
  if(remove.labels==T){
    M.dash[M>0] = "' '"
  }
  
  # return key results for plotting
  to.return = list()
  to.return$M = M
  to.return$M.dash = M
  to.return$names = names
  to.return$warnings = warnings
  return(to.return)
}
