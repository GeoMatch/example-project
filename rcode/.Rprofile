# This creates a stack trace for errors
options(error = function() {
  calls <- sys.calls()
  if (length(calls) >= 2L) {
    sink(stderr())
    on.exit(sink(NULL))
    cat("Backtrace:\n")
    calls <- rev(calls[-length(calls)])
    for (i in seq_along(calls)) {
      cat(i, ": ", deparse(calls[[i]], nlines = 1L), "\n", sep = "")
    }
  }
  if (!interactive()) {
    q(status = 1)
  }
})

# Activate renv
source("renv/activate.R")
cat("renv/activate.R Loaded\n")

# In prod we use Docker, but when running locally and not-interactive (i.e. via python)
# we install manually to try and replicate the Docker prod environment.
if (!interactive() && Sys.getenv("GEOMATCH_VERSION") == "dev") {
  renv::remove("geomatchnld")
  renv::install(".", prompt = FALSE)
}

# Management scripts are only used interactively and depend on renv.
if (interactive() && renv.opt.in) {
  source("renv/manage.R")
  cat("renv/manage.R Loaded\n")
}
