#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

vec_questiones <- c(
    site = "What is your Evotec site?",
    vehicle = "How do you come to Evotec?"
)

# Define UI for application that draws a histogram
ui <- fluidPage(# Application title
    titlePanel("Transport survey"),
    selectInput(
        names(vec_questiones)[1],
        vec_questiones[1],
        choices = c()
    ),
    selectInput(
        names(vec_questiones)[2],
        vec_questiones[2],
        choices = c(),
        selected = NULL
    ),
    downloadButton("button_save", label = "Save answers")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observe({
        updateSelectInput(
            session,
            inputId = names(vec_questiones)[1],
            choices = LETTERS[1:5]
        )
    })
    observe({
        updateSelectInput(
            session,
            inputId = names(vec_questiones)[2],
            choices = LETTERS[3:9],
            selected = NULL
        )
    })
    
    # save ansers to file
    output$button_save <- downloadHandler(
        filename = function() {
            idx <- "0001"
            f <- paste0(getwd(), "/", idx, "_answers.txt")
            return(f)
        },
        content = function(con) {
            tmp_answers <- names(input)
            print(tmp_answers)
            tmp_answers <- setdiff(
                tmp_answers, grep("selectized", tmp_answers, value = T)
            )
            tab_answers <- data.frame(
                questions = vec_questiones, 
                answers = sapply(tmp_answers, function(x) input[[x]])
            )
            print(tab_answers)
            write.table(
                tab_answers, file = con, sep = '\t', quote = F, row.names = F
            )
        }
    )
    
}

# Run the application
shinyApp(ui = ui, server = server)
