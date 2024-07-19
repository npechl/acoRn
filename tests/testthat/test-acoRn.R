


test_that("multiplication works", {

    expect_error(acoRn())
    expect_error(acoRn("text"))

    data("parents")
    data("offspring")

    expect_error(acoRn(parents))

    r <- acoRn(parents, offspring)

    expect_equal(class(r), c("data.table", "data.frame"))
    expect_equal(nrow(r), 75)
    expect_equal(ncol(r), 5)

})
