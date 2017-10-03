test_that("Check projects", {
  L = fe_projects(project_number = "5R01MH092950-05")
  expect_equal(httr::status_code(L$response), 200)

  expect_error(fe_projects(), regexp = "must specify")
  expect_error(fe_projects_multiple(), regexp = "must be")
})

