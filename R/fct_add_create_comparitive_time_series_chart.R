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
                                                      laby,
                                                      ref_val_gdp = NULL,
                                                      ref_val_gdppc = NULL) {

  if(xval == "gdp_current_usd"){
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
      highcharter::hc_yAxis(title = list(text =  "GDP in Bilions USD"),
                            labels = list(formatter = htmlwidgets::JS("function(){
                                                        return this.value/1000000000 + 'B'
                          }"),
                          format = "${text}"),
                          plotLines = list(
                            list(
                              label = list(text = "GDP of the selected Country",
                                           style = list(
                                             color = "#e7eced",
                                             fontSize = 15
                                           )),
                              color = "#74aadb",
                              width = 2,
                              value = ref_val_gdp
                            )
                          ),
                          max = ifelse(is.null(ref_val_gdppc),NA,
                                       ifelse(ref_val_gdppc > 7*(10^14),
                                              ref_val_gdppc,7*(10^14)))
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
      highcharter::hc_yAxis(title = list(text = "GDP per capita in USD"),
                            labels = list(formatter = htmlwidgets::JS("function(){return this.value + 'USD'}"),
                          format = "${text}"),
                          plotLines = list(
                            list(
                              label = list(text = "GDP per capita of the selected Country",
                                           style = list(
                                             color = "#e7eced",
                                             fontSize = 15
                                           )),
                              color = "#74aadb",
                              width = 2,
                              value = ref_val_gdppc
                            )
                          ),
                          max = ifelse(is.null(ref_val_gdppc),NA,
                                       ifelse(ref_val_gdppc > 50000,
                                              ref_val_gdppc,50000))
                          ) %>%
      highcharter::hc_tooltip(
        shared = T,
        crosshairs = T
      )
  }

}
