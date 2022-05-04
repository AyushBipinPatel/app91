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
          ),
        shiny::actionButton(
          inputId = ns("set_changes"),
          label = "Apply Changes"
          )
      ),
      mainPanel = shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel(title = "GDP Trends",
                          highcharter::highchartOutput(outputId = ns("line_gdp"),
                                                       height = "750px",
                                                       width = "100%")
                          ),
          shiny::tabPanel(title = "GDP per Capita Trends",
                          highcharter::highchartOutput(outputId = ns("line_gdp_per_capita"),
                                                       height = "750px",
                                                       width = "100%")
                          )
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

    # setting reactive values that will be need in further calculations-----------

    react_year <- shiny::eventReactive(input$set_changes,{
      input$choice_year
    })
    react_rate <- shiny::eventReactive(input$set_changes,{
      input$choice_rate
    })
    react_start_gdp_val <- shiny::eventReactive(input$set_changes,{
      data_gdp$gdp_current_usd[data_gdp$year == react_year()]
    })

    # create a reactive data frame----------------------------------------

    data_reactive <- shiny::eventReactive(input$set_changes,{
      data_gdp %>%
        dplyr::mutate(
          trend_gdp = ifelse(year >= react_year(),
                             react_start_gdp_val() * (((react_rate()/100)+1)^(year-react_year())),
                             gdp_current_usd
          ),
          trend_gdp_per_capita = trend_gdp/total_population
        )
    })


# create charts -----------------------------------------------------------

    output$line_gdp <- highcharter::renderHighchart({

      add_create_comparitive_time_series_chart(
        data_fetch = data_reactive(),
        xval = "gdp_current_usd",
        yval = "trend_gdp",
        plt_title = "Actual GDP trend compared to the scenario GDP trend",
        flname = "actual_vs_scenario_gdp",
        labx = "Actual GDP trend",
        laby = "Scenario GDP trend"
      )
    })


    output$line_gdp_per_capita <- highcharter::renderHighchart({

      add_create_comparitive_time_series_chart(
        data_fetch = data_reactive(),
        xval = "gdp_per_capita_current_usd",
        yval = "trend_gdp_per_capita",
        plt_title = "Actual GDP per capita trend compared to the scenario GDP per capita trend",
        flname = "actual_vs_scenario_gdp_per_capita",
        labx = "Actual GDP per capita trend",
        laby = "Scenario GDP per capita trend"
      )
    })


  })
}

## To be copied in the UI
# mod_country_level_growth_ui("country_level_growth_1")

## To be copied in the server
# mod_country_level_growth_server("country_level_growth_1")
