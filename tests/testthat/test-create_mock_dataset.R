

test_that("Mock parents", {

    expect_error(create_mock_parents("text"))

    p <- create_mock_parents(15, 50, 6)

    expect_type(p, "list")
    expect_equal(class(p[[1]]), c("data.table", "data.frame"))
    expect_equal(class(p[[2]]), c("data.table", "data.frame"))

    expect_length(p, 2)

    expect_equal(nrow(p[[1]]), 50)
    expect_equal(ncol(p[[1]]), 15 + 1)

})
