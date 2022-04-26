#' add_about_text
#'
#' @description A fct function to add text to the landing page, "About", of the application
#'
#' @return The return value, if any, is the html format of the text needed to be added on the About page.
#'
#' @noRd

add_about_text <- function(){
  shiny::withTags({
    list(
    shiny::div(class = "divheader",
               shiny::h1(
                 class = "h1",id = "abouth1motivation",
                 "Motivation for this application"
                 )
               ),
    shiny::div(class = "normaltext",id = "aboutpageh1text",
               shiny::p("It is deceptively tricky to imagine how a number will
                        trace if it is compounded over a period of time or
                        grows exponentialy overy time. One can do this
                        accurately or develop an intuition about how this
                        number will trace only after frequent and ample
                        practice. It is precisely this excercise that needs to
                        be carried out when one is trying to
                        imagine scenarios such as:"),shiny::p(shiny::tags$i("'What if the GDP of a country grew every year, at a
                        rate of 10%, for the next 10 years?'.")),shiny::p(
                        "This is where, we hope, this application will prove
                        helpful for people to visualize such scenarios and
                        develop an intuition when they think about it.")
               ),
    shiny::div(class = "divheader",
               shiny::h2(class = "h2",id = "abouth2",
                         "A thought experiment on compounding")
               ),
    shiny::div(class = "normaltext",id = "aboutpageh2text",
               shiny::p("A man in India, in the year 1950, receives rupees 1,00,000 in generational wealth. If this amount were to compound at the rate of 10% once a year, starting from 1950, how much money would this man have in the year 2000? Try and arrive at an estimate in your mind. Below is a graph that traces the compounded amount every year."),
               shiny::div(class = "divimage", id = "imggif",
                          shiny::img(id = "gif_compound",
                                     src = "www/expl_compound.gif",
                                     width = "800px", height = "600px",
                                     alt = "An animation of compounded amount"),

                                     style="text-align: center;"          )
    ),

    shiny::div(class = "divhorizontalrule",
               shiny::hr(shiny::tags$style(color = "#2c525d"))
               ),
    shiny::div(class = "divheader",
               shiny::h1(class = "h1",id = "abouth1project91",
               "About the 1991 Project")
               ),
    shiny::div(class = "normaltext",id = "aboutpageh1project91",
               shiny::p("Stuff about the 1991 Project, Ask Shruti/Kadambari")
               ),
    shiny::div(class = "divhorizontalrule",
               shiny::hr(shiny::tags$style(color = "#2c525d"))
    )
    )
  })
}
