#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  rate_reactive <- reactive(input$change_rate)

  output$linechart <- highcharter::renderHighchart({
    data_alt_scenario <- dplyr::tibble(
      year = c(range(data_gdp$year)[1] :  range(data_gdp$year)[2]),
      year_seq = c(0:60),
      alt_gdp = data_gdp$gdp_current_usd[1]*(((rate_reactive()/100)+1)^year_seq)
    )

    dplyr::left_join(data_gdp,data_alt_scenario, by = c("year" = "year")) -> data_both





    highcharter::hchart(data_both, "line",
                        highcharter::hcaes(year, gdp_current_usd),
                        color = "#e7eced",  name = "GDP in Current USD") %>%
      highcharter::hc_add_series(data = data_both,type = "line",
                                 highcharter::hcaes(year,alt_gdp),
                                 name = "Alternate Scenario GDP",
                                 color = "#ffc051") %>%
      highcharter::hc_exporting(
        enabled = TRUE,
        filename = "comparing_actual_with_alternate_gdp"
      ) %>%
      highcharter::hc_title(
        text = "Comparison between Actual GDP with Alternate Scenario GDP",
        margin = 20,
        align = "left",
        style = list(color = "#22A884", useHTML = TRUE)
      )  %>%
      highcharter::hc_xAxis(title = list(text = "Year")) %>%
      highcharter::hc_yAxis(title = list(text = "GDP" ),
                            labels = list(formatter = htmlwidgets::JS("function(){
                                                        return this.value/1000000000 + 'B'
                          }"), format = "${text}")) %>%
      highcharter::hc_tooltip(
        shared = T,
        crosshairs = T
      )
  })



}
