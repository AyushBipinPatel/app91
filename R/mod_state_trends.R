#' state_trends UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_state_trends_ui <- function(id){
  ns <- NS(id)
  tagList(
    add_instruction_explation_text_whatiff(), ## change this for states
    shiny::sidebarLayout(
      sidebarPanel = shiny::sidebarPanel(
        shinyWidgets::sliderTextInput(
          inputId = ns("choice_state"),
          label = "Choose State",
          choices = unique(india_states_gdp$states),
          selected = unique(india_states_gdp$states)[1],
          grid = T
        ),
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

#' state_trends Server Functions
#'
#' @noRd
mod_state_trends_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Update year range depending on the state selection -------------

    shiny::observeEvent(input$choice_state,{
      shinyWidgets::updateSliderTextInput(inputId = "choice_year",
                                          choices = seq(india_states_gdp|>
                                                          dplyr::filter(states == input$choice_state & !is.na(year))|>
                                                          pull(year)|>min(),
                                                        india_states_gdp|>
                                                          dplyr::filter(states == input$choice_state & !is.na(year))|>
                                                          pull(year)|>max(),
                                                        by = 1))
    })



    # setting reactive values that will be need in further calculations-----------

    react_state <- shiny::eventReactive(input$set_changes,{
      input$choice_state
    },ignoreNULL = F)
    react_year <- shiny::eventReactive(input$set_changes,{
      input$choice_year
    },ignoreNULL = F)
    react_rate <- shiny::eventReactive(input$set_changes,{
      input$choice_rate
    },ignoreNULL = F)
    react_state_data_gdp <- shiny::eventReactive(input$set_changes,{
      india_states_gdp[india_states_gdp$states == react_state()]
    })
    react_state_data_gdppc <- shiny::eventReactive(input$set_changes,{
      india_states_gdppc[india_states_gdppc$states == react_state()]
    })
    react_start_gdp_val <- shiny::eventReactive(input$set_changes,{
      react_start_gdp_val() |>
        dplyr::filter(year == react_year())|>
        dplyr::pull(gdp)
    },ignoreNULL = F)
    react_start_gdppc_val <- shiny::eventReactive(input$set_changes,{
      react_start_gdppc_val() |>
        dplyr::filter(year == react_year())|>
        dplyr::pull(gdppc)
    },ignoreNULL = F)

    # create a reactive data frames----------------------------------------

    data_reactive_gdp <- shiny::eventReactive(input$set_changes,{
      react_state_data_gdp |>
        dplyr::filter(!is.na(year))|>
        dplyr::mutate(
          gdp = gdp*100000,
          trend_gdp = ifelse(year >= react_year(),
                             react_start_gdp_val() * (((react_rate()/100)+1)^(year-react_year())),
                             gdp
          )
        )
    },ignoreNULL = F)

    data_reactive_gdppc <- shiny::eventReactive(input$set_changes,{
      react_state_data_gdppc |>
        dplyr::filter(!is.na(year))|>
        dplyr::mutate(
          trend_gdppc = ifelse(year >= react_year(),
                             react_start_gdp_val() * (((react_rate()/100)+1)^(year-react_year())),
                             gdppc
          )
        )
    },ignoreNULL = F)


    # create charts -----------------------------------------------------------

    output$line_gdp <- highcharter::renderHighchart({

      add_create_comparitive_time_series_chart(
        data_fetch = data_reactive_gdp,
        xval = "gdp",
        yval = "trend_gdp",
        plt_title = paste(react_state(),
                          ": Actual GDP trend compared to the scenario GDP trend",
                          sep = ""),
        flname = paste(react_state(),
                                   "_actual_vs_scenario_gdp",
                       sep = ""),
        labx = "Actual GDP trend",
        laby = "Scenario GDP trend"
      )
    })


    output$line_gdp_per_capita <- highcharter::renderHighchart({

      add_create_comparitive_time_series_chart(
        data_fetch = data_reactive_gdppc,
        xval = "gdp_per_capita",
        yval = "trend_gdp_per_capita",
        plt_title = paste(
          react_state(),
          ": Actual GDP per capita trend compared to the scenario GDP per capita trend",
          sep = ""
        ),
        flname = paste(
          react_state(),
          "_actual_vs_scenario_gdp_per_capita",
          sep = ""
        ),
        labx = "Actual GDP per capita trend",
        laby = "Scenario GDP per capita trend"
      )
    })


  })
}

## To be copied in the UI
# mod_state_trends_ui("state_trends_1")

## To be copied in the server
# mod_state_trends_server("state_trends_1")
