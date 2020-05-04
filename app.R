library(shiny)
library(DT)
library(dplyr)
library(readr)
#library(multtest)

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
                actionButton("show_filter", "Execute batch query")
            )
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Readme", includeMarkdown("data/README_results.md")),
                tabPanel("Full table", DT::DTOutput("genes")),
                tabPanel("Batch query", DT::DTOutput("genes_filtered")),
                tabPanel("Download", downloadButton("downloadData", "Download all data"))
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
	    if(sum(!is.na(dat_filtered$P_FRAC)) > 0 & sum(!is.na(dat_filtered$P_BMD)) > 0){
                dat_filtered <- dat_filtered %>%
                    mutate(P_FRAC_Bonf = P_FRAC*sum(!is.na(dat_filtered$P_FRAC))) %>%
                    mutate(P_BMD_Bonf = P_BMD*sum(!is.na(dat_filtered$P_BMD))) 
                #adjp1 <- mt.rawp2adjp(dat_filtered[["P_FRAC"]], proc = "BH")
                #dat_filtered <- dat_filtered %>%
                #    mutate(P_FRAC_BH = adjp1$adjp[order(adjp1$index),"BH"])
                #adjp1 <- mt.rawp2adjp(dat_filtered[["P_BMD"]], proc = "BH")
                #dat_filtered %>%
                #    mutate(P_BMD_BH = adjp1$adjp[order(adjp1$index),"BH"])
	    }
        } else if(input$batch_input == "symbol_mouse"){
            dat_filtered <- dat %>%
                filter(symbol_mouse %in% myrows) 
	    if(sum(!is.na(dat_filtered$P_FRAC)) > 0 & sum(!is.na(dat_filtered$P_BMD)) > 0){
                dat_filtered <- dat_filtered %>%
                    mutate(P_FRAC_Bonf = P_FRAC*sum(!is.na(dat_filtered$P_FRAC))) %>%
                    mutate(P_BMD_Bonf = P_BMD*sum(!is.na(dat_filtered$P_BMD))) 
                #adjp1 <- mt.rawp2adjp(dat_filtered[["P_FRAC"]], proc = "BH")
                #dat_filtered <- dat_filtered %>%
                #    mutate(P_FRAC_BH = adjp1$adjp[order(adjp1$index),"BH"])
                #adjp1 <- mt.rawp2adjp(dat_filtered[["P_BMD"]], proc = "BH")
                #dat_filtered %>%
                #    mutate(P_BMD_BH = adjp1$adjp[order(adjp1$index),"BH"])
        }
    }
    }) #end reactive
    
    output$genes <- DT::renderDT({
        datatable(
            dat %>%
                select(input$mycols),
            options = list(lengthMenu = c(10, 50, 500), pageLength = 8, dom = 'lfrtipB', 
                           buttons = c('copy', 'csv', 'excel')), 
            escape = FALSE, 
            extensions = 'Buttons',
            rownames = FALSE, 
            filter = "top"
            )
        })
    output$genes_filtered <- DT::renderDT({
        datatable(
            rv_filter(),
            options = list(lengthMenu = c(10, 50, 500), pageLength = 8, dom = 'lfrtipB', 
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
