#' add_instruction_explation_text_national_growth_extrapolate
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd

add_instruction_explation_text_national_growth_extrapolate <- function(){
  shiny::withTags({
    list(
      shiny::div(class = "divheader",
                 shiny::h1(
                   class = "h1",
                   id = "forwardlookingh1instruction",
                   "What can be"
                 )
      ),
      shiny::div(class = "normaltext",id = "forwardlookingh1instructiontext",
                 shiny::p(
                   "This section presents you a chart that traces the actual GDP and GDP per capita trend of India from the year 1960 to 2020. Here there is room for you to set a rate of growth from the year 2020 onwards.The actual tend will be extrapolated for you till the year 2050."
                 ),
                 shiny::h2(class = "h2",
                           id = "Instructions",
                           "How to create a new trend:"),
                 shiny::p("Follow these steps to manipulate the growth numbers. We allow you to define one parameter, the rate of growth. The rate at which you wish the growth numbers to change for the consequent years after 2020."),
                 shiny::h5(class = "h5",
                           id = "step1Instruction",
                           "Step 1: Choose the rate of growth"
                 ),
                 shiny::p(
                   "This the the rate at which the GDP and GDP per capita will change, starting from the year after 2020. We have provided a range from which you can choose the percentage growth rate."
                 ),
                 shiny::h5(class = "h5",
                           id = "step2Instruction",
                           "Step 2: Submit your choices"
                 ),
                 shiny::p(
                   "You have set the parameter that will define a new growth trend. Submit these changes by clicking on the Apply Changes button to see the updated growth trends."
                 ),
                 shiny::hr()
      )
    )
  })
}
