An example R package.

# Overview

Functions are located in `R`

Entry points are at the top level, and are prefixed with `pipeline_`.
These entrypoints load the package at the top of the script.

Package dependencies are managed with `renv`, but helper functions
for package management are stored in `renv/manage.R`.

## Installation

.Rprofile should `source` automatically if you load RStudio to this directory.
If not, please source it manually and let me know.
Afterwards, you should be able to run the following management command
to install all prod / dev dependencies:

```R
gm_install_all()
```

Then you can step through `pipelint_entry_example.R` using `Run` or `Source` to run the hello world.
