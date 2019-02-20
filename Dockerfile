# Derived from the Jupyter R Notebook container
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=3.5.1' \
    'r-rodbc=1.3*' \
    'unixodbc=2.3.*' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-tidyverse=1.2*' \
    'r-shiny=1.2*' \
    'r-rmarkdown=1.11*' \
    'r-forecast=8.2*' \
    'r-rsqlite=2.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=1.0*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-sparklyr=0.9*' \
    'r-htmlwidgets=1.2*' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

# Install hdf5r for Seurat and Seurat itself
# FIXME Don't hardcode CRAN mirrors
RUN export CRAN_MIRROR="https://cloud.r-project.org/" \
 && Rscript -e "install.packages(\"hdf5r\", configure.args=\"--with-hdf5=/usr/bin/h5cc\", repos=\"${CRAN_MIRROR}\")" \
 && Rscript -e "install.packages(\"Seurat\", repos=\"${CRAN_MIRROR}\")"
