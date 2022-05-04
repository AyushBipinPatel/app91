test_that("Function that adds instruction and expalnation to the What iff section", {
  golem::expect_html_equal(add_instruction_explation_text_whatiff())
})
