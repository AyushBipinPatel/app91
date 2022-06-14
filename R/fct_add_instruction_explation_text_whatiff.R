#' add_instruction_explation_text_whatiff
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd


add_instruction_explation_text_whatiff <- function(){
  shiny::withTags({
    list(
      shiny::div(class = "divheader",
                 shiny::h1(
                   class = "h1",
                   id = "whatiffh1instruction",
                   "What if..."
                 )
                 ),
      shiny::div(class = "normaltext",id = "whatifpageh1instructiontext",
                 shiny::p(
                   "Here in this section we have created a space to help you visualise the trend in GDP and GDP per capita. We have data starting from year 1960, up to the year 2020.You will be able to compare this actual trend with a trend that you can define."
                 ),
                 shiny::h2(class = "h2",
                           id = "Instructions",
                           "How to create a new trend:"),
                 shiny::p("Follow these steps to manipulate the growth numbers. We allow you to define two parameters. First, the year from which you want to deviate from the actual numbers. Second, the rate at which you wish the growth numbers to change for the consequent years."),
                 shiny::h5(class = "h5",
                           id = "step1Instruction",
                           "Step 1: Choose the Year"
                           ),
                 shiny::p(
                   "The data that is available to us ranges from the year 1960 to the year 2020. This means that you can select any year between 1960 and 2019, from this selected year a new trend will emarge. This new trend will deviate from the actual trend depending on the rate of growth you chose in the next step."
                 ),
                 shiny::h5(class = "h5",
                           id = "step2Instruction",
                           "Step 2: Choose a rate of growth"
                           ),
                 shiny::p(
                   "This the the rate at which the GDP and GDP per capita will change, starting from the year after the selected year. We have provided a range from which you can choose the percentage growth rate."
                 ),
                 shiny::h5(class = "h5",
                           id = "step3Instruction",
                           "Step 3: Submit your choices"
                           ),
                 shiny::p(
                   "You have set two parameters that will define a new growth trend. Even you you have changed one of the parameters, submit these changes by clicking on the Apply Changes button to see the updated growth trends."
                 ),
                 shiny::hr()
                 )
    )
  })
}
