#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shiny::navbarPage(
      title = "App 91",
      theme = bslib::bs_theme(
        bootswatch = "solar",
        fg = "#93A1A1",
        bg = "#2c525d",
        version = 4
        ),
      shiny::tabPanel(
        "About",
        add_about_text()
        ),
      shiny::navbarMenu(
        "India's National Growth Trends",
        shiny::tabPanel(
          "What could have been...",# UI side of the module for country level growth trends - past
          mod_country_level_growth_ui("country_level_growth_1")
          ),
        shiny::tabPanel(
          "What can be ...", # UI side of the module for country level growth trends - future
          mod_country_level_growth_extrapolate_ui("country_level_growth_extrapolate_1")
        )
      ),
      shiny::navbarMenu(
        "India's state level Growth Trends",
        shiny::tabPanel(
          "Brief on trends of all states",
        ),
        shiny::tabPanel(
          "State level trends"
        )
      )
      )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "app91"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
