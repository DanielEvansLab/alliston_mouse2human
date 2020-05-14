library(shiny)
library(DT)
library(tidyverse)
library(multtest)

dat <- read_rds("data/gene_dat.rds")

ui <- fluidPage( 
    titlePanel("Mouse2Human BMD and Fracture App"),
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput('mycols', 'Select columns to display', 
                               choices = names(dat)[!names(dat) %in% c("FRAC_ZSTAT", "FRAC_P", "BMD_ZSTAT", "BMD_P")], 
                               selected = names(dat)[!names(dat) %in% c("chr", "locus_start", "locus_end", "homologene_ID", "entrez_human", "FRAC_NSNPS", "BMD_NSNPS")]),
            radioButtons("batch_input", "Batch query input", c(
                "None selected" = "",
                "Human Gene Symbol" = "symbol_human",
                "Mouse Gene Symbol" = "symbol_mouse"
            )),
            conditionalPanel(
                condition = "input.batch_input != ''",
                textAreaInput(inputId = 'query_symbol', 
                            label = HTML("Enter gene symbols<br/>One gene per line<br/>Case sensitive"),
                            width = "70%"
                            ),
                actionButton("show_filter", HTML("Execute!<br/>Results in Batch query tab"))
            ),
            width = 3
        ),
        mainPanel(
            tabsetPanel(
		tabPanel("About", includeMarkdown("data/README_about.md")),
                tabPanel("Readme", includeMarkdown("data/README_results.md")),
                tabPanel("Full table", DT::DTOutput("genes")),
                tabPanel("Batch query", DT::DTOutput("genes_filtered")),
                tabPanel("Download", downloadButton("downloadData", "Download all data")),
		tabPanel("Code", includeMarkdown("data/README_code.md"))
            )
        )
    )
)


server <- function(input, output, session) {
    rv_filter <- eventReactive(input$show_filter, {
        #clean input of free text field
        myrows <- str_split(input$query_symbol, pattern = "\n")[[1]]
        if(input$batch_input == "symbol_human"){
            dat_filtered <- dat %>%
                filter(symbol_human %in% myrows) 
        } else if(input$batch_input == "symbol_mouse"){
            dat_filtered <- dat %>%
                filter(symbol_mouse %in% myrows) 
        }
        # Multiple testing FRAC_P
        if(sum(!is.na(dat_filtered$FRAC_P)) > 0){
          adjp1 <- mt.rawp2adjp(dat_filtered[["FRAC_P"]], proc = c("Bonferroni", "BH"))
          dat_filtered <- dat_filtered %>%
            mutate(FRAC_P_Bonf = adjp1$adjp[order(adjp1$index),"Bonferroni"])  %>%
            mutate(FRAC_P_BH = adjp1$adjp[order(adjp1$index),"BH"])
        }
        # Multiple testing BMD_P
        if(sum(!is.na(dat_filtered$BMD_P)) > 0){
          adjp1 <- mt.rawp2adjp(dat_filtered[["BMD_P"]], proc = c("Bonferroni", "BH"))
          dat_filtered <- dat_filtered %>%
            mutate(BMD_P_Bonf = adjp1$adjp[order(adjp1$index),"Bonferroni"]) %>%
            mutate(BMD_P_BH = adjp1$adjp[order(adjp1$index),"BH"])
        }
    }) #end reactive
    
    output$genes <- DT::renderDT({
        datatable(
            dat %>%
                select(c(input$mycols, "FRAC_ZSTAT", "FRAC_P", "BMD_ZSTAT", "BMD_P")),
            options = list(lengthMenu = c(10, 50, 500), pageLength = 10, dom = 'lfrtipB', 
                           buttons = c('copy', 'csv', 'excel')), 
            escape = FALSE, 
            extensions = 'Buttons',
            rownames = FALSE, 
            filter = "top"
            )
        })
    output$genes_filtered <- DT::renderDT({
        datatable(
            rv_filter() %>%
              select(c(input$mycols, "FRAC_ZSTAT", "FRAC_P", "FRAC_P_Bonf", "FRAC_P_BH", "BMD_ZSTAT", "BMD_P", "BMD_P_Bonf", "BMD_P_BH")),
            options = list(lengthMenu = c(10, 50, 500), pageLength = 10, dom = 'lfrtipB', 
                           buttons = c('copy', 'csv', 'excel')), 
            escape = FALSE, 
            extensions = 'Buttons',
            rownames = FALSE, 
            filter = "top"
        )
    })
    output$downloadData <- downloadHandler(
        filename = function(){
            paste0("data_", Sys.Date(), ".csv")
        }, 
        content = function(file){
            write.csv(dat, file)
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
