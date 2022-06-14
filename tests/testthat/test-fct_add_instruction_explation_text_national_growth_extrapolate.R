test_that("Function that adds instruction and expalnation to the national forward looking section", {
  golem::expect_html_equal(add_instruction_explation_text_national_growth_extrapolate())
})
