library(shiny)
library(dplyr)
library(plotly)
library(e1071)

# Define UI
ui <- fluidPage(
  titlePanel("Przewidywanie ceny złota"),
  
  tags$head(
    tags$style(HTML("
      body {
        font-size: 1em;
        font-family: 'Roboto', sans-serif;
      }
      .tab-content {
        margin-top: 20px;
      }
      .tab-pane {
        padding: 15px;
      }
    ")),
    tags$script(HTML("
      Shiny.addCustomMessageHandler('applySettings', function(message) {
        $('body').css('font-size', message.fontScale + 'em');
        $('body').css('font-family', message.font);
        var themeLink = $('#shiny-theme-css');
        if (themeLink.length == 0) {
          $('head').append('<link id=\"shiny-theme-css\" rel=\"stylesheet\" href=\"https://bootswatch.com/4/' + message.theme + '/bootstrap.min.css\">');
        } else {
          themeLink.attr('href', 'https://bootswatch.com/4/' + message.theme + '/bootstrap.min.css');
        }
      });
    "))
  ),
  
  tabsetPanel(id = "tabset",
              tabPanel("Opis i ustawienia", value = "Opis i ustawienia",
                       h3("Opis"),
                       p("Aplikacja do przewidywania ceny złota, za pomocą wybranych modeli. Aplikacja zwiera trzy zakładki: pierwsza z opisem aplikacji oraz ustawieniami interfejsu, druga z wczytywaniem zbioru danych z pliku, trzecia z analizą i predykcją modelami."),
                       h3("Ustawienia wyglądu"),
                       selectInput("theme", "Wybierz motyw", 
                                   choices = c("flatly", "cerulean", "darkly", "sandstone", "yeti")),
                       numericInput("font_scale", "Wybierz rozmiar czcionki", 
                                    value = 1.2, min = 0.5, max = 2, step = 0.1),
                       selectInput("font", "Wybierz czcionkę", 
                                   choices = c("Roboto", "Open Sans", "Lato", "Montserrat", "Source Sans Pro")),
                       actionButton("apply_settings", "Zastosuj ustawienia")
              ),
              tabPanel("Wczytywanie danych", value = "Wczytywanie danych",
                       fluidPage(
                         fluidRow(
                           column(12, align = "center", 
                                  fileInput("fileUpload", "Wybierz plik CSV", accept = ".csv", buttonLabel = "Wybierz plik")
                           )
                         ),
                         verbatimTextOutput("fileInfo")
                       )
              ),
              tabPanel("Modelowanie i przewidywania", value = "Modelowanie i przewidywania",
                       fluidPage(
                         fluidRow(
                           column(4, 
                                  dateRangeInput(
                                    inputId = "date_range",
                                    label = "Wybierz zakres daty",
                                    start = "1970-01-01",  
                                    end = "2020-03-13"     
                                  ),
                                  selectInput(
                                    inputId = "model",
                                    label = "Wybierz model",
                                    choices = c("Drzewo", "SVM"),
                                    selected = "Drzewo"
                                  ),
                                  dateInput(
                                    inputId = "prediction_date",
                                    label = "Wybierz datę do predykcji",
                                    value = "2020-03-13"
                                  )
                           ),
                           column(8,
                                  plotlyOutput(outputId = "plot"),
                                  verbatimTextOutput("prediction_output"),
                                  verbatimTextOutput("error_output")
                           )
                         )
                       )
              )
  )
)

# Define server logic
# Define server logic
server <- function(input, output, session) {
  
  observeEvent(input$apply_settings, {
    theme <- input$theme
    fontScale <- input$font_scale
    font <- switch(input$font,
                   "Roboto" = "'Roboto', sans-serif",
                   "Open Sans" = "'Open Sans', sans-serif",
                   "Lato" = "'Lato', sans-serif",
                   "Montserrat" = "'Montserrat', sans-serif",
                   "Source Sans Pro" = "'Source Sans Pro', sans-serif")
    
    session$sendCustomMessage(type = 'applySettings', list(theme = theme, fontScale = fontScale, font = font))
  })
  
  data <- reactiveVal(NULL)
  
  observeEvent(input$fileUpload, {
    req(input$fileUpload)
    tryCatch({
      data(read.csv(input$fileUpload$datapath))
    }, error = function(e) {
      showNotification("Błąd wczytywania pliku CSV.", duration = 5000, type = "error")
      return(NULL)
    })
  })
  
  output$fileInfo <- renderPrint({
    req(data())
    if (!is.null(data())) {
      cat("Przesłano plik:", input$fileUpload$name, "\n")
      cat("Liczba wczytanych wierszy:", nrow(data()), "\n")
    }
  })
  
  df <- reactive({
    req(data())
    if (!is.null(data())) {
      data() %>%
        mutate(Date = as.Date(Date))
    }
  })
  
  model_tree_path <- file.path("..", "models", "model_tree.rds")
  model_tree <- readRDS(model_tree_path)
  model_svm_path <- file.path("..", "models", "model_svm.rds")
  model_svm <- readRDS(model_svm_path)
  
  normalization_values <- reactive({
    req(df())
    list(mean = mean(df()$Value, na.rm = TRUE), sd = sd(df()$Value, na.rm = TRUE))
  })
  
  denormalize <- function(x, mean, sd) {
    return((x * sd) + mean)
  }
  
  output$plot <- plotly::renderPlotly({
    req(input$model, df(), input$date_range)
    
    filtered_data <- df() %>%
      filter(Date >= input$date_range[1] & Date <= input$date_range[2])
    
    if (input$model == "Drzewo") {
      predictions <- predict(model_tree, newdata = filtered_data)
    } else if (input$model == "SVM") {
      predictions <- predict(model_svm, newdata = filtered_data)
    }
    
    plot_ly(data = filtered_data, x = ~Date, y = ~Value, type = 'scatter', mode = 'markers', marker = list(size = 5)) %>%
      layout(title = "Cena złota na przestrzeni czasu", xaxis = list(title = "Data"), yaxis = list(title = "Cena złota"))
  })
  
  output$prediction_output <- renderText({
    req(input$model, input$prediction_date, df())
    
    prediction_date <- as.Date(input$prediction_date)
    prediction_data <- df() %>%
      filter(Date == prediction_date)
    
    if (nrow(prediction_data) == 0) {
      return("Brak danych dla wybranej daty.")
    }
    
    if (input$model == "Drzewo") {
      prediction <- predict(model_tree, newdata = prediction_data)
    } else if (input$model == "SVM") {
      prediction <- predict(model_svm, newdata = prediction_data)
    }
    
    prediction <- denormalize(prediction, normalization_values()$mean, normalization_values()$sd)
    
    paste("Predykcja ceny złota na dzień", prediction_date, ":", round(prediction, 2))
  })
  
  output$error_output <- renderText({
    req(input$model, df())
    
    if (input$model == "Drzewo") {
      predictions <- predict(model_tree, newdata = df())
    } else if (input$model == "SVM") {
      predictions <- predict(model_svm, newdata = df())
    }
    
    actual_values <- df()$Value
    mae <- mean(abs(predictions - actual_values))
    paste("Średni błąd bezwzględny (MAE):", round(mae, 2))
  })
}

# Run the app
shinyApp(ui = ui, server = server)
