This is an example of a potential GeoMatch repository.

It is structured as a python project, with code living in `geomatch` and
dependencies managed with poetry.
R code is managed as a package in the `rcode` subdirectory. See it's README
for more information.

For some sub-systems, it may be useful to use both Python and R.
Since this is the most complicated case, this repo is setup to demonstrate this.
However, it will likely eventually be sufficient to have Python and R entrypoints
separate (or remove Python as a dependency altogether).

System dependencies:
- Python 3.12
- Python Poetry
- R 4.3

There is also a (potentially not working) example Dockerfile to demonstrate
how a batch sub-system could be run.
