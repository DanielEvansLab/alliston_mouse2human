# Code for shiny app

## Deploy

```
library(rsconnect)
#Only need to run setAccountInfo the first time deploying from a computer. I deployed from parrot head node. If I use a different head node, I might need to run this again. 
rsconnect::setAccountInfo(name='...', token='...', secret> ...')
# set BioC repositories so shinyapps.io can install bioc packages
options(repos = BiocManager::repositories())
# getOption("repos")
# output of this command should show repositories BioCsoft, BioCann, BioCexp, BioCworkflows, and CRAN
# Make sure you're in the directory containing app.R
deployApp(appFiles = c("app.R", "data"))
```


