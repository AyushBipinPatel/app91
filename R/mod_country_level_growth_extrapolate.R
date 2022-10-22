#' country_level_growth_extrapolate UI Function
#'
#' @description Module to create a time series chart for India National GDP and GDP per capita, forward looking
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_country_level_growth_extrapolate_ui <- function(id){
  ns <- NS(id)
  tagList(

    add_instruction_explation_text_national_growth_extrapolate(),
    shiny::sidebarLayout(
      sidebarPanel = shiny::sidebarPanel(

        shinyWidgets::sliderTextInput(
          inputId = ns("choice_rate"),
          label = "Choose rate of growth (%)",
          choices = seq(1,20,by = 0.5),
          selected = 10,
          grid = T
        ),
        shiny::actionButton(
          inputId = ns("set_changes"),
          label = "Change Growth Rate"
        ),
        shiny::tags$hr(),
        shiny::tags$p(shiny::tags$b("Add a reference threshold for GDP/GDPP")),
        shinyWidgets::pickerInput(
          inputId = ns("choice_country_compare"),
          label = "Pick a country to compare",
          choices = unique(data_gdppc_countries$country_name),
          selected = "Australia",
          options = list(`live-search` = TRUE)
        ),
        shinyWidgets::sliderTextInput(
          inputId = ns("choice_country_year"),
          label = "Choose year for GDP/GDP per capita",
          choices = seq(1960,2020,by = 1),
          selected = 1990,
          grid = T
        ),
        shiny::actionButton(
          inputId = ns("set_country_changes"),
          label = "Add refrence to compare"
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

#' country_level_growth_extrapolate Server Functions
#'
#' @noRd
mod_country_level_growth_extrapolate_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # setting reactive values that will be need in further calculations-----------


    react_rate <- shiny::eventReactive(input$set_changes,{
      input$choice_rate
    },ignoreNULL = F)
    start_gdp_val <-  data_gdp_future$gdp_current_usd[data_gdp_future$year == 2020]

    # create a reactive data frame----------------------------------------

    data_reactive <- shiny::eventReactive(input$set_changes,{
      data_gdp_future %>%
        dplyr::mutate(
          trend_gdp = ifelse(year >= 2021,
                             start_gdp_val * (((react_rate()/100)+1)^(year-2020)),
                             NA
          ),
          trend_gdp_per_capita = trend_gdp/total_population
        )
    },ignoreNULL = F)


    # section to control Dynamic UI for the  forward looking  comparis --------

    shiny::observeEvent(input$choice_country_compare,{
      shinyWidgets::updateSliderTextInput(session = session,
        inputId = "choice_country_year",
        choices = seq(min(data_gdppc_countries$year[data_gdppc_countries == input$choice_country_compare & (!is.na(data_gdppc_countries$gdp_per_capita))],na.rm =T),
                      max(data_gdppc_countries$year[data_gdppc_countries == input$choice_country_compare & (!is.na(data_gdppc_countries$gdp_per_capita))],na.rm =T),
                      by = 1)
      )
    },ignoreNULL = F)


    # set the reference gdppc of a country as reactive val --------------------

        compare_country <- shiny::eventReactive(input$set_country_changes,{

          input$choice_country_compare

        },ignoreNULL = F)

        compare_country_year <- shiny::eventReactive(input$set_country_changes,{

          input$choice_country_year

        },ignoreNULL = F)

        reference_gdppc <- reactive({

          data_gdppc_countries$gdp_per_capita[data_gdppc_countries$country_name == compare_country() &
                                                data_gdppc_countries$year == compare_country_year()]

        })

        reference_gdp <- reactive({

          data_gdp_countries$gdp[data_gdp_countries$`Country Name` == compare_country() &
                                                data_gdp_countries$Year == compare_country_year()]

        })





    # create charts -----------------------------------------------------------

    output$line_gdp <- highcharter::renderHighchart({

      add_create_comparitive_time_series_chart(
        data_fetch = data_reactive(),
        xval = "gdp_current_usd",
        yval = "trend_gdp",
        plt_title = "Actual GDP trend and the Extrapolated GDP trend",
        flname = "actual_vs_extrapolated_gdp",
        labx = "Actual GDP trend",
        laby = "Extrapolated GDP trend",
        ref_val_gdp = reference_gdp()
      )
    })


    output$line_gdp_per_capita <- highcharter::renderHighchart({

      add_create_comparitive_time_series_chart(
        data_fetch = data_reactive(),
        xval = "gdp_per_capita_current_usd",
        yval = "trend_gdp_per_capita",
        plt_title = "Actual GDP per capita trend compared to the Extrapolated GDP per capita trend",
        flname = "actual_vs_extrapolated_gdp_per_capita",
        labx = "Actual GDP per capita trend",
        laby = "Extrapolated GDP per capita trend",
        ref_val_gdppc = reference_gdppc()
      )
    })

  })
}

## To be copied in the UI
# mod_country_level_growth_extrapolate_ui("country_level_growth_extrapolate_1")

## To be copied in the server
# mod_country_level_growth_extrapolate_server("country_level_growth_extrapolate_1")
