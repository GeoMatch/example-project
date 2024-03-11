FROM rocker/r-ver:4.3.2 AS base
ENV APP_WORKDIR "/app" 

# -------- Install R deps ----------
ENV RENV_VERSION 1.0.3
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"
WORKDIR $APP_WORKDIR
RUN apt-get update -qq && \
    apt-get install -y libssl-dev libgit2-dev libxml2-dev libcurl4-openssl-dev libglpk-dev libmpfr-dev libgmp-dev 
COPY rcode/renv.lock rcode/renv.lock
COPY rcode/.Rprofile rcode/.Rprofile
COPY rcode/DESCRIPTION rcode/DESCRIPTION
COPY rcode/renv/activate.R rcode/renv/activate.R
COPY rcode/renv/settings.json rcode/renv/settings.json
ENV RENV_PATHS_LIBRARY renv/library
RUN cd ./rcode && R -e 'renv::restore()'

# -------- Install Python ----------
ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # pip
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    # poetry
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=true \
    # make poetry install to this location
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_VERSION=1.3.2 \
    # path
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv" \
    # PYTHONPATH="$PYTHONPATH:/runtime/lib/python3.9/site-packages" \
    BUILDER_WORKDIR="/src" 
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
RUN apt-get update -qq && \
    apt-get install -y python3.12 python3-pip gettext curl libssl-dev libjpeg-dev \
    libtcl8.6 libxml2-dev libcurl4-openssl-dev libpng-dev tk curl && \
    rm -rf /var/lib/apt/lists/*
RUN ln -sf /usr/bin/python3.12 /usr/bin/python3
RUN ln -sf /usr/bin/python3.12 /usr/bin/python



FROM base AS builder

# -------- System Deps ----------
RUN apt-get update && apt-get install --no-install-recommends -y build-essential curl python3.12-venv
RUN curl -sSL https://install.python-poetry.org | python -
RUN R --version
RUN python --version
RUN poetry --version

# -------- Python Deps ----------
WORKDIR $PYSETUP_PATH
COPY pyproject.toml poetry.lock poetry.toml ./ 
RUN poetry install --without dev


FROM base AS final
WORKDIR $APP_WORKDIR
COPY . $APP_WORKDIR
ENV RENV_PATHS_LIBRARY renv/library
RUN cd ./rcode && R -e 'renv::restore()' -e 'renv::install(packages=c("./"))'
COPY --from=builder $PYSETUP_PATH $PYSETUP_PATH
ENV PYTHONPATH="${APP_WORKDIR}:$PYTHONPATH"

CMD ["python", "geomatch/r_entry_example.py"]
