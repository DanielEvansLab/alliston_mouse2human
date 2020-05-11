library(shiny)
library(DT)
library(tidyverse)
library(multtest)

dat <- read_rds("data/gene_dat.rds")

ui <- fluidPage( 
    titlePanel("Mouse2Human BMD and Fracture table"),
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput('mycols', 'Select columns to display', choices = names(dat), selected = names(dat)),
            radioButtons("batch_input", "Batch query input", c(
                "None selected" = "",
                "Human Gene Symbol" = "symbol_human",
                "Mouse Gene Symbol" = "symbol_mouse"
            )),
            conditionalPanel(
                condition = "input.batch_input != ''",
                textAreaInput(inputId = 'query_symbol', 
                            label = "Enter gene symbols, one per line"
                            ),
                actionButton("show_filter", "Execute! Results in Batch query tab")
            )
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
        # Multiple testing P_FRAC
        if(sum(!is.na(dat_filtered$P_FRAC)) > 0){
          adjp1 <- mt.rawp2adjp(dat_filtered[["P_FRAC"]], proc = c("Bonferroni", "BH"))
          dat_filtered <- dat_filtered %>%
            mutate(P_FRAC_Bonf = adjp1$adjp[order(adjp1$index),"Bonferroni"])  %>%
            mutate(P_FRAC_BH = adjp1$adjp[order(adjp1$index),"BH"])
        }
        # Multiple testing P_BMD
        if(sum(!is.na(dat_filtered$P_BMD)) > 0){
          adjp1 <- mt.rawp2adjp(dat_filtered[["P_BMD"]], proc = c("Bonferroni", "BH"))
          dat_filtered <- dat_filtered %>%
            mutate(P_BMD_Bonf = adjp1$adjp[order(adjp1$index),"Bonferroni"]) %>%
            mutate(P_BMD_BH = adjp1$adjp[order(adjp1$index),"BH"])
        }
    }) #end reactive
    
    output$genes <- DT::renderDT({
        datatable(
            dat %>%
                select(input$mycols),
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
              select(c(input$mycols, "P_FRAC_Bonf", "P_FRAC_BH", "P_BMD_Bonf", "P_BMD_BH")),
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
