# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/minimal-notebook
FROM $BASE_CONTAINER
ARG JUPYTERHUB_VERSION=3.0.0

LABEL maintainer="Fabian Hausmann <fabian.hausmann@zmnh.uni-hamburg.de>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# R pre-requisites
#RUN apt-get update --yes && \
#    apt-get install --yes --no-install-recommends \
#    fonts-dejavu \
#    unixodbc \
#    unixodbc-dev \
#    r-cran-rodbc \
#    gfortran \
#    gcc \
#    libxml2 \
#    libxml2-dev \
#    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache jupyterhub==$JUPYTERHUB_VERSION

USER ${NB_UID}

RUN mamba install --yes -c "conda-forge" \
    "bash_kernel" \
    "pandas" \
    "scanpy" \
    "squidpy" \
    "seaborn" \
    "scikit-learn" \
    "leidenalg" \
    "scipy"

RUN mamba install --yes -c "bioconda" \
    "decoupler" \
    "gseapy"

USER root
RUN rm -r /home/jovyan/work/ && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
USER ${NB_UID}
