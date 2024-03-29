library(shiny)
library(DT)
library(tidyverse)
library(multtest)

dat <- read_rds("data/gene_dat.rds")

ui <- fluidPage( 
    titlePanel("Mouse to Human BMD and Fracture Results"),
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
                            label = HTML("Enter gene symbols<br/>One gene per line<br/>Case sensitive<br/>Human gene example: SOST<br/>Mouse gene example: Sost"),
                            width = "70%"
                            ),
                actionButton("show_filter", HTML("Execute!<br/>Results in Batch query tab"))
            ),
            width = 3
        ),
        mainPanel(
            tabsetPanel(id = "myTabset",
		        tabPanel(title = "About", includeMarkdown("data/README_about.md")),
                tabPanel(title = "Readme", includeMarkdown("data/README_results.md")),
                tabPanel(title = "Full table", DT::DTOutput("genes")),
                tabPanel(title = "Batch query", value = "myBatch", DT::DTOutput("genes_filtered")),
                tabPanel(title = "Download", downloadButton("downloadData", "Download all data")),
		        tabPanel(title = "Code", includeMarkdown("data/README_code.md"))
            )
        )
    )
)


server <- function(input, output, session) {
    
    observeEvent(input$show_filter, {
        updateTabsetPanel(session,
                          inputId = "myTabset",
                          selected = "myBatch"
        )
    })
    
    rv_filter <- eventReactive(input$show_filter, {
        #clean input of free text field
        myrows <- str_trim(str_split(input$query_symbol, pattern = "\n")[[1]], 
                                 side = "both")
        myrows <- myrows[myrows != ""]
        if(length(myrows) <= 1){
            showModal(modalDialog(
                title = "Batch query error",
                HTML("Query must include more than one gene.<br/>One gene per line.<br/>Gene name matching is case sensitive!<br/>Human gene example: SOST<br/>Mouse gene example: Sost"),
                easyClose = TRUE
                )
                )
            dat_filtered <- dat[1,]
        } else if(input$batch_input == "symbol_human"){
            dat_filtered <- dat %>%
                filter(symbol_human %in% myrows) 
        } else if(input$batch_input == "symbol_mouse"){
            dat_filtered <- dat %>%
                filter(symbol_mouse %in% myrows) 
        }
        if(length(dat_filtered) > 0 & nrow(dat_filtered) > 1){
            # Multiple testing FRAC_P
            if(sum(!is.na(dat_filtered$FRAC_P)) > 1){
                adjp1 <- mt.rawp2adjp(dat_filtered[["FRAC_P"]], proc = c("Bonferroni", "BH"))
                dat_filtered <- dat_filtered %>%
                    mutate(FRAC_P_Bonf = adjp1$adjp[order(adjp1$index),"Bonferroni"])  %>%
                    mutate(FRAC_P_BH = adjp1$adjp[order(adjp1$index),"BH"])
            }
            # Multiple testing BMD_P
            if(sum(!is.na(dat_filtered$BMD_P)) > 1){
                adjp1 <- mt.rawp2adjp(dat_filtered[["BMD_P"]], proc = c("Bonferroni", "BH"))
                dat_filtered <- dat_filtered %>%
                    mutate(BMD_P_Bonf = adjp1$adjp[order(adjp1$index),"Bonferroni"]) %>%
                    mutate(BMD_P_BH = adjp1$adjp[order(adjp1$index),"BH"])
            }
        } else{
            showModal(modalDialog(
                title = "Batch query error",
                HTML("Query must include more than one gene.<br/>One gene per line.<br/>Gene name matching is case sensitive!<br/>Human gene example: SOST<br/>Mouse gene example: Sost"),
                easyClose = TRUE
            )
            )
            dat_filtered <- dat[1,]
        }
        
    }) #end reactive
    
    output$genes_filtered <- DT::renderDT({
        if(length(rv_filter()) > 0 & nrow(rv_filter()) > 1){
            datatable(
                rv_filter() %>%
                    select(c(input$mycols, "FRAC_ZSTAT", "FRAC_P", "FRAC_P_Bonf", "FRAC_P_BH", "BMD_ZSTAT", "BMD_P", "BMD_P_Bonf", "BMD_P_BH")),
                options = list(lengthMenu = c(10, 50, 500, 1500), pageLength = 10, dom = 'lfrtipB', 
                               buttons = c('copy', 'csv', 'excel')), 
                escape = FALSE, 
                extensions = 'Buttons',
                rownames = FALSE, 
                filter = "top"
            )
        } else {
            showModal(modalDialog(
                title = "Batch query error",
                HTML("Query matched one or no genes.<br/>Batch query requires more than one matching gene.<br/>Gene name matching is case sensitive!<br/>Human gene example: SOST<br/>Mouse gene example: Sost"),
                easyClose = TRUE
            )
            )
        }
        
    })
    
    output$genes <- DT::renderDT({
        datatable(
            dat %>%
                select(c(input$mycols, "FRAC_ZSTAT", "FRAC_P", "BMD_ZSTAT", "BMD_P")),
            options = list(lengthMenu = c(10, 50, 500, 1500), pageLength = 10, dom = 'lfrtipB', 
                           buttons = c('copy', 'csv', 'excel')), 
            escape = FALSE, 
            extensions = 'Buttons',
            rownames = FALSE, 
            filter = "top"
        )
    })
    
    output$downloadData <- downloadHandler(
        filename = function(){
            paste0("data_", Sys.Date(), ".rds")
        }, 
        content = function(file){
            dat_download <- read_rds("data/gene_dat_download.rds")
            write_rds(dat_download, file)
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
