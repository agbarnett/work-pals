# orcid.R
# Take ORCID ID and make a list of papers
# use rcrossref to get better formatted data
# Version for shiny
# May 2017

# TO DO, add affiliation, guess from most recent paper?

# set token as an environmental variable (March 2018)
x <- "07073399-4dcc-47b3-a0a8-925327224519"
Sys.setenv(ORCID_TOKEN=x)

# main function
my.network = function(orcid.ids, remove.labels=T){

  n.names = length(orcid.ids)
  
  # a) get names (loop)
  names = all.dois = NULL
  for (k in 1:n.names){
    bio = orcid_id(orcid = orcid.ids[k], profile='profile') # get basics
    first = bio[[1]]$`name`$`given-names`$value
    surname = bio[[1]]$`name`$`family-name`$value
    # add affiliation here?
    name = paste(gsub(' ', '', first), '\n', gsub(' ', '', surname), sep='')
    names = c(names, name)
    
    

  # b) get works and transform to DOss
    d = works(orcid_id(orcid = orcid.ids[k])) # get works as a tibble
    dois = identifiers(d, type='doi') # get DOIs, not available for all papers
    frame =  data.frame(k=k, name=name, dois=dois)
    all.dois = rbind(all.dois, frame)
  }
  
  # matrix M of links
  M = matrix(nrow = n.names, ncol = n.names, byrow = TRUE, data = 0)

  # find common papers
  tab = with(all.dois, table(dois, k))
  tab[tab>1] = 1
  tab = tab[rowSums(tab)>1, ] # rows with a match
  for (j in 1:nrow(tab)){
    pairs = as.numeric(names(which(tab[j,] == 1)))
    combs = combn(pairs, 2)
    for (k in 1:ncol(combs)){
      M[combs[1,k], combs[2,k]] = M[combs[1,k], combs[2,k]] + 1
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
  return(to.return)
}
