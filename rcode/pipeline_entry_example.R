if (interactive()) {
  devtools::load_all()
} else {
  library(canexample)
}

# Package function example ----------

hello_world()

# Database example ------------------

con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
# This loads the database into RStudio's Connections pane
connections::connection_view(con)
# Copy in some test data:
dplyr::copy_to(con, nycflights13::flights, "FLIGHTS")
# View stats with SQL:
DBI::dbListTables(con)
DBI::dbGetQuery(con, statement = readr::read_file("sql/get-delta.sql"))
# View tables with dplyr wrapper:
library(dplyr)
avg <- tbl(con, "FLIGHTS") %>%
  filter(carrier == "DL") %>%
  dplyr::group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))

