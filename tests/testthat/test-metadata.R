
context("Getting package metadata")

test_that("works well for CRAN packages", {

  skip_on_cran()
  skip_if_offline()

  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  install.packages("pkgconfig", lib = tmp, quiet = TRUE)
  install.packages("falsy", lib = tmp, quiet = TRUE)

  pkgs <- get_package_metadata(tmp, priority = NA_character_)

  expect_equal(
    pkgs$Source,
    c("cran", "cran")
  )

})

test_that("works for bioc packages", {

  skip_on_cran()
  skip_if_offline()

  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  withr::with_libpaths(tmp, {
    ## Install
    install.packages("pkgconfig", lib = tmp, quiet = TRUE)
    source("https://bioconductor.org/biocLite.R")
    biocLite("BiocInstaller", lib = tmp, quiet = TRUE, ask = FALSE,
             suppressUpdates = TRUE)

    pkgs <- get_package_metadata(tmp, priority = NA_character_)

    expect_equal(
      pkgs$Source,
      c("bioc", "cran")
    )
  })
})

test_that("works for url packages", {

  skip_on_cran()
  skip_if_offline()

  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  install.packages("pkgconfig", lib = tmp, quiet = TRUE)
  remotes::install_url(
    "https://cran.rstudio.com/src/contrib/sankey_1.0.0.tar.gz",
    lib = tmp,
    quiet = TRUE
  )

  pkgs <- get_package_metadata(tmp, priority = NA_character_)

  expect_equal(
    pkgs$Source,
    c("cran", "url")
  )

  expect_equal(
    pkgs$Link,
    c(NA_character_,
      "https://cran.rstudio.com/src/contrib/sankey_1.0.0.tar.gz"
      )
  )
})
