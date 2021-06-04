# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

RUN echo "alias l='ls -al'" >> /root/.bashrc
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y \
	&& apt install apt-utils -y  \
	&& apt install tzdata -y \
	&& ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
	&& dpkg-reconfigure --frontend noninteractive tzdata \
	&& apt install wget -y \
	&& apt install vim -y \
	&& apt install curl -y \
	&& apt install jq -y \
	&& apt-get install -y --no-install-recommends ffmpeg \
	&& rm -rf /var/lib/apt/lists/* 
	
USER $NB_UID

# Install Python 3 packages
RUN conda install --quiet --yes \
    'beautifulsoup4=4.8.*' \
    'conda-forge::blas=*=openblas' \
    'bokeh=1.3*' \
    'cloudpickle=1.2*' \
    'cython=0.29*' \
    'dask=2.2.*' \
    'dill=0.3*' \
    'h5py=2.9*' \
    'hdf5=1.10*' \
    'ipywidgets=7.5*' \
    'matplotlib-base=3.1.*' \
    'numba=0.45*' \
    'numexpr=2.6*' \
    'pandas=0.25*' \
    'patsy=0.5*' \
    'protobuf=3.9.*' \
    'scikit-image=0.15*' \
    'scikit-learn=0.21*' \
    'scipy=1.3*' \
    'seaborn=0.9*' \
    'sqlalchemy=1.3*' \
    'statsmodels=0.10*' \
    'sympy=1.4*' \
    'vincent=0.4.*' \
    'xlrd' \
    && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^1.0.1 --no-build && \
    jupyter labextension install jupyterlab_bokeh@1.0.0 --no-build && \
    jupyter lab build --dev-build=False && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER root

USER $NB_UID
RUN conda update -n base conda -y 
#  conda update anaconda -y && \
RUN conda install -c conda-forge pyomo -y && \
  conda install -c conda-forge pyomo.extras -y && \
  conda install -c conda-forge coincbc -y && \
  conda install -c conda-forge ipopt -y && \
  conda install -c conda-forge glpk -y

USER root

#USER $NB_UID

RUN apt update && apt upgrade -y && apt install gnupg2 -y && \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

	
RUN pip install requests  \
	&& pip install kafka-python \
	&& apt install python-snappy -y \
	&& apt install libsnappy-dev -y \
	&& pip install python-snappy \
	&& pip install ezdxf \
	&& pip install shapely \
	&& pip install lxml \
	&& pip install bs4 \
	&& pip install html5lib \
	&& pip install requests \
	&& pip install pandas \
	&& pip install django

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y install tzdata \
	&& ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
	&& dpkg-reconfigure --frontend noninteractive tzdata

COPY entry.sh /
COPY jupyter_notebook_config.py /home/jovyan/.jupyter/
CMD [ "/bin/bash", "/entry.sh" ]
