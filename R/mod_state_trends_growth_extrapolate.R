#' state_trends_growth_extrapolate UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_state_trends_growth_extrapolate_ui <- function(id){
  ns <- NS(id)
  tagList(

    add_instruction_explation_text_national_growth_extrapolate(), ## change this for states
    shiny::sidebarLayout(
      sidebarPanel = shiny::sidebarPanel(
        shinyWidgets::pickerInput(
          inputId = ns("choice_state"),
          label = "Choose State",
          choices = unique(india_states_gdp$states),
          options = list(
            `live-search` = TRUE
          )
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
          label = "Apply changes"
        )
      ),
      mainPanel = shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel(title = "State GDP Trends",
                          highcharter::highchartOutput(outputId = ns("line_gdp"),
                                                       height = "750px",
                                                       width = "100%")
          ),
          shiny::tabPanel(title = "State GDP per Capita Trends",
                          highcharter::highchartOutput(outputId = ns("line_gdp_per_capita"),
                                                       height = "750px",
                                                       width = "100%")
          )
        )
      )
    )

  )
}

#' state_trends_growth_extrapolate Server Functions
#'
#' @noRd
mod_state_trends_growth_extrapolate_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    # setting reactive values that will be need in further calculations-----------

    react_state <- shiny::eventReactive(input$set_changes,{
      input$choice_state
    },ignoreNULL = F)

    react_rate <- shiny::eventReactive(input$set_changes,{
      input$choice_rate
    },ignoreNULL = F)


    react_start_gdp_val <- shiny::eventReactive(input$set_changes,{

       if(react_state() == "ANDAMAN AND NICOBAR ISLANDS"){

        data_states_future %>%
          dplyr::filter(states == react_state() & year == 2019) %>% # andaman islands have missing values for gdp in year 2020
          dplyr::pull(gdp)

      }else{
        data_states_future %>%
          dplyr::filter(states == react_state() & year == 2020) %>%
          dplyr::pull(gdp)
      }


    }, ignoreNULL = F)

    # create a reactive data frame----------------------------------------

    data_reactive <- shiny::eventReactive(input$set_changes,{
      data_states_future %>%
        dplyr::filter(states == react_state()) %>%
        dplyr::mutate(
          trend_gdp = ifelse(year >= 2021,
                             react_start_gdp_val() * (((react_rate()/100)+1)^(year-2020)),
                             NA
          ),
          trend_gdppc = trend_gdp*100000/pop_proj # state gdp in epw data is in rs lakhs
        )
    },ignoreNULL = F)


    # create charts -----------------------------------------------------------

    output$line_gdp <- highcharter::renderHighchart({

      add_create_comparitive_time_series_chart(
        data_fetch = data_reactive(),
        xval = "gdp",
        yval = "trend_gdp",
        plt_title = paste("Actual GDP trend and the Extrapolated GDP trend for ",react_state()),
        flname = "actual_vs_extrapolated_gdp",
        labx = "Actual GDP trend",
        laby = "Extrapolated GDP trend"
      )
    })


    output$line_gdp_per_capita <- highcharter::renderHighchart({

      add_create_comparitive_time_series_chart(
        data_fetch = data_reactive(),
        xval = "gdppc",
        yval = "trend_gdppc",
        plt_title = paste("Actual GDP per capita trend compared to the Extrapolated GDP per capita trend for ",
                          react_state()),
        flname = "actual_vs_extrapolated_gdp_per_capita",
        labx = "Actual GDP per capita trend",
        laby = "Extrapolated GDP per capita trend"
      )
    })

  })
}

## To be copied in the UI
# mod_state_trends_growth_extrapolate_ui("state_trends_growth_extrapolate_1")

## To be copied in the server
# mod_state_trends_growth_extrapolate_server("state_trends_growth_extrapolate_1")
