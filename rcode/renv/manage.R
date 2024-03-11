assert_rcode_pilot_wd <- function() {
    if (!grepl("rcode$", getwd())) {
        message("ERROR: Working directory must be rcode_pilot for management functions.")
        stop()
    }
}

#' Snapshots explicit dependencies (those in DESCRIPTION's Imports)
#' to the lockfile
gm_snapshot <- function(for_check = FALSE) {
    assert_rcode_pilot_wd()

    renv::snapshot(type = "explicit")
}

#' Checks for missing dependencies via code analysis
gm_check_missing <- function() {
    assert_rcode_pilot_wd()
    # Document before so auto-discovery
    # works better (for for_check mode).
    gm_document()

    message("Checking root")
    message("Add any new dependencies to DESCRIPTION via gm_add_prod")
    renv::snapshot(type = "implicit")
}

#' Installs and records a development package 
gm_add_dev <- function(pkg) {
    assert_rcode_pilot_wd()

    renv::install(pkg)

    desc <- desc::description$new()
    desc$set_dep(pkg, "Suggests")
    desc$write()
}

#' Installs and records a production package 
gm_add_prod <- function(pkg) {
    assert_rcode_pilot_wd()

    renv::install(pkg)

    desc <- desc::description$new()
    desc$set_dep(pkg, "Imports")
    desc$write()

    gm_snapshot()
}

#' Documents the package from roxygen documentation
#' This also process "@imports" and "@importFrom",
#' which is required for loading of packages.
gm_document <- function() {
    assert_rcode_pilot_wd()

    devtools::document()
}

#' Tests the package.
gm_test <- function() {
    assert_rcode_pilot_wd()
    devtools::test()
}

gm_install_all <- function(dev = TRUE) {
    assert_rcode_pilot_wd()

    message("Installing production packages from renv.lock:")
    renv::restore()
    if (dev) {
        message("Installing development / testing pacakges from DESCRIPTION:")
        renv::install(dependencies = "Suggests")
    }
}
