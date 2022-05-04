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
    add_instruction_explation_text_whatiff()
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
