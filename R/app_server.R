#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  # Server side of the module for country level growth trends - past
  mod_country_level_growth_server("country_level_growth_1")

  # Server side of the module for the country level growth trends - future
  mod_country_level_growth_extrapolate_server("country_level_growth_extrapolate_1")

}
