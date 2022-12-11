#' add_create_comparitive_time_series_chart
#'
#' @param data_fetch the data to create the chart
#' @param xval the actual series name, column name in the data_fetch
#' @param yval the new trend series name, column name in the data_fetch
#' @param plt_title String for plot title
#' @param flname String for saving the file
#' @param labx String, tooltip for actual series
#' @param laby String, tooltip for new trend series
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd


add_create_comparitive_time_series_chart  <- function(data_fetch,
                                                      xval,
                                                      yval,
                                                      plt_title,
                                                      flname,
                                                      labx,
                                                      laby) {

  if(xval == "gdp_current_usd" | xval == "gdp"){
    highcharter::hchart(data_fetch, "line",
                        highcharter::hcaes(year, .data[[xval]]),
                        color = "#e7eced",  name = labx) %>%
      highcharter::hc_add_series(data = data_fetch,type = "line",
                                 highcharter::hcaes(year,.data[[yval]]),
                                 name = laby,
                                 color = "#ffc051") %>%
      highcharter::hc_exporting(
        enabled = TRUE,
        filename = flname
      ) %>%
      highcharter::hc_title(
        text = plt_title,
        margin = 20,
        align = "left",
        style = list(color = "#22A884", useHTML = TRUE)
      )  %>%
      highcharter::hc_xAxis(title = list(text = "Year")) %>%
      highcharter::hc_yAxis(title = list(text =  ifelse(xval == "gdp","GDP in Bilions INR",
                                                        "GDP in Bilions USD")),
                            labels = list(formatter = if(xval == "gdp"){
                              htmlwidgets::JS("function(){
                                                        return this.value/10000 + 'B'
                          }")
                            }else{
                              htmlwidgets::JS("function(){
                                                        return this.value/1000000000 + 'B'
                          }")
                            },
                          format = "${text}"
                          )
                          ) %>%
      highcharter::hc_tooltip(
        shared = T,
        crosshairs = T
      )
  }else{
    highcharter::hchart(data_fetch, "line",
                        highcharter::hcaes(year, .data[[xval]]),
                        color = "#e7eced",  name = labx) %>%
      highcharter::hc_add_series(data = data_fetch,type = "line",
                                 highcharter::hcaes(year,.data[[yval]]),
                                 name = laby,
                                 color = "#ffc051") %>%
      highcharter::hc_exporting(
        enabled = TRUE,
        filename = flname
      ) %>%
      highcharter::hc_title(
        text = plt_title,
        margin = 20,
        align = "left",
        style = list(color = "#22A884", useHTML = TRUE)
      )  %>%
      highcharter::hc_xAxis(title = list(text = "Year")) %>%
      highcharter::hc_yAxis(title = list(text = ifelse(xval == "gdppc","GDP per capita in INR",
                                                       "GDP per capita in USD")),
                            labels = list(formatter = if(xval == "gdppc"){
                              htmlwidgets::JS("function(){return this.value + 'INR'}")
                              }else{
                                htmlwidgets::JS("function(){return this.value + 'USD'}")
                              },
                          format = "${text}")
                          ) %>%
      highcharter::hc_tooltip(
        shared = T,
        crosshairs = T
      )
  }

}
