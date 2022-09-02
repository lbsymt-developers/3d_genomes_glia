FROM python:3.9.1-slim-buster

RUN pip install --upgrade pip\
    && conda install -c conda-forge -c bioconda cooler\
    && conda install numpy\
    && conda install pandas\
    && conda install scipy\
    && conda install h5py\
    && pip install ipython\
