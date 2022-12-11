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


    # function to extract detials from data_cc

    get_from_data_cc <- function(measure_passed,value_passed,detail_extract){

      data_cc[[detail_extract]][which.min(abs(data_cc[[measure_passed]] - value_passed))]


    }


    #get the reference data prepared for gdppc/gdp of a countries --------------------

    shiny::reactive({
      tibble::tibble(
        ind_gdp = data_reactive() %>%
          dplyr::filter(year %in% c(2025,2030,2035,2040,2045,2050)) %>%
          dplyr::pull(trend_gdp),
        year = c(2025,2030,2035,2040,2045,2050),
        ind_gdppc = data_reactive() %>%
          dplyr::filter(year %in% c(2025,2030,2035,2040,2045,2050)) %>%
          dplyr::pull(trend_gdp_per_capita),
        cc_gdp = purrr::pmap_dbl(.l = list(
          measure_passed = "gdp",
          value_passed = ind_gdp,
          detail_extract = "gdp"
        ) ,.f = get_from_data_cc),
        cc_year_gdp = purrr::pmap_dbl(.l = list(
          measure_passed = "gdp",
          value_passed = ind_gdp,
          detail_extract = "year"
        ) ,.f = get_from_data_cc),
        cc_country_gdp = purrr::pmap_chr(.l = list(
          measure_passed = "gdp",
          value_passed = ind_gdp,
          detail_extract = "country_name"
        ) ,.f = get_from_data_cc),
        cc_gdppc = purrr::pmap_dbl(.l = list(
          measure_passed = "gdppc",
          value_passed = ind_gdppc,
          detail_extract = "gdppc"
        ) ,.f = get_from_data_cc),
        cc_year_gdppc = purrr::pmap_dbl(.l = list(
          measure_passed = "gdppc",
          value_passed = ind_gdppc,
          detail_extract = "year"
        ) ,.f = get_from_data_cc),
        cc_country_gdppc =  purrr::pmap_chr(.l = list(
          measure_passed = "gdppc",
          value_passed = ind_gdppc,
          detail_extract = "country_name"
        ) ,.f = get_from_data_cc)
      )
    }) -> data_cc_plot


    # create charts -----------------------------------------------------------

    output$line_gdp <- highcharter::renderHighchart({

      highcharter::hchart(data_reactive(), "line",
                          highcharter::hcaes("year", "gdp_current_usd"),
                          color = "#e7eced",  name = "Actual GDP trend",
                          tooltip = list(
                            pointFormatter = htmlwidgets::JS(
                              "
                                       function(){
                                       return this.series.name + ': ' + this.y/1000000000 + 'B'
                                       }
                                       "
                            )
                          )) %>%
        highcharter::hc_add_series(data = data_reactive(),type = "line",
                                   highcharter::hcaes("year","trend_gdp"),
                                   name = "Extrapolated GDP",
                                   color = "#ffc051",
                                   tooltip = list(
                                     pointFormatter = htmlwidgets::JS(
                                       "
                                       function(){
                                       return this.series.name + ': ' + this.y/1000000000 + 'B'
                                       }
                                       "
                                     )
                                   )) %>%
        highcharter::hc_add_series(data = data_cc_plot(),
                                   type = "column",
                                   pointWidth = 0.1,
                                   highcharter::hcaes("year","cc_gdp"),
                                   name = "Comparative Countries",
                                   color = "#898999",
                                   tooltip = list(
                                     pointFormatter = htmlwidgets::JS(
                                       "
                                       function(){
                                       return '<br>GDP of ' + this.cc_country_gdp + ' in ' + this.cc_year_gdp + ': ' + this.y/1000000000 + 'B'
                                       }
                                       "
                                       )
                                   )
                                   ) %>%
        highcharter::hc_exporting(
          enabled = TRUE,
          filename = "actual_vs_extrapolated_gdp"
        ) %>%
        highcharter::hc_title(
          text = "Actual GDP trend and the Extrapolated GDP trend",
          margin = 20,
          align = "left",
          style = list(color = "#22A884", useHTML = TRUE)
        )  %>%
        highcharter::hc_xAxis(title = list(text = "Year")) %>%
        highcharter::hc_yAxis(title = list(text =  "GDP in Bilions USD"),
                              labels = list(formatter = htmlwidgets::JS("function(){
                                                        return this.value /1000000000 + 'B'
                          }"),
                          format = "${text}"
                              )
        ) %>%
        highcharter::hc_tooltip(
          shared = T,
          crosshairs = T
        )

    })


    output$line_gdp_per_capita <- highcharter::renderHighchart({

      highcharter::hchart(data_reactive(), "line",
                          highcharter::hcaes("year","gdp_per_capita_current_usd" ),
                          color = "#e7eced",
                          name = "Actual GDP per capita trend",
                          tooltip = list(
                            pointFormatter = htmlwidgets::JS(
                              "
                                       function(){
                                       return this.series.name + ': ' + this.y + 'USD'
                                       }
                                       "
                            )
                          )) %>%
        highcharter::hc_add_series(data = data_reactive(),type = "line",
                                   highcharter::hcaes("year","trend_gdp_per_capita"),
                                   name = "Extrapolated GDP per capita trend",
                                   color = "#ffc051",
                                   tooltip = list(
                                     pointFormatter = htmlwidgets::JS(
                                       "
                                       function(){
                                       return this.series.name + ': ' + this.y + 'USD'
                                       }
                                       "
                                     )
                                   )) %>%
        highcharter::hc_add_series(data = data_cc_plot(),
                                   type = "column",
                                   pointWidth = 0.1,
                                   highcharter::hcaes("year","cc_gdppc"),
                                   name = "Comparative Countries",
                                   color = "#898999",
                                   tooltip = list(
                                     pointFormatter = htmlwidgets::JS(
                                       "
                                       function(){
                                       return '<br>GDP per capita of ' + this.cc_country_gdppc + ' in ' + this.cc_year_gdppc + ': ' + this.y + 'USD'
                                       }
                                       "
                                     )
                                   )
        ) %>%
        highcharter::hc_exporting(
          enabled = TRUE,
          filename = "actual_vs_extrapolated_gdp_per_capita"
        ) %>%
        highcharter::hc_title(
          text = "Actual GDP per capita trend compared to the Extrapolated GDP per capita trend",
          margin = 20,
          align = "left",
          style = list(color = "#22A884", useHTML = TRUE)
        )  %>%
        highcharter::hc_xAxis(title = list(text = "Year")) %>%
        highcharter::hc_yAxis(title = list(text = "GDP per capita in USD"),
                              labels = list(formatter =
                                htmlwidgets::JS("function(){return this.value + 'USD'}"),
                              format = "${text}")
        ) %>%
        highcharter::hc_tooltip(
          shared = T,
          crosshairs = T
        )
    })

  })
}

## To be copied in the UI
# mod_country_level_growth_extrapolate_ui("country_level_growth_extrapolate_1")

## To be copied in the server
# mod_country_level_growth_extrapolate_server("country_level_growth_extrapolate_1")
