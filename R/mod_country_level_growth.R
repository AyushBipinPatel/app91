#' country_level_growth UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_country_level_growth_ui <- function(id){
  ns <- NS(id)
  tagList(
    add_instruction_explation_text_whatiff(),
    shiny::sidebarLayout(
      sidebarPanel = shiny::sidebarPanel(
        shinyWidgets::sliderTextInput(
          inputId = ns("choice_year"),
          label = "Choose Year",
          choices = seq(1960,2019,by = 1),
          selected = 1960,
          grid = T
        ),
        shinyWidgets::sliderTextInput(
          inputId = ns("choice_rate"),
          label = "Choose rate of growth (%)",
          choices = seq(1,20,by = 0.5),
          selected = 10,
          grid = T
          )
      ),
      mainPanel = shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel(title = "GDP Trends"),
          shiny::tabPanel(title = "GDP per Capita Trends")
        )
      )
                           )
  )
}

#' country_level_growth Server Functions
#'
#' @noRd
mod_country_level_growth_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_country_level_growth_ui("country_level_growth_1")

## To be copied in the server
# mod_country_level_growth_server("country_level_growth_1")
