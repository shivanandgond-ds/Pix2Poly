FROM pytorch/pytorch:2.1.2-cuda11.8-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive 

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/program

# Copy environment file
COPY environment.yml .

# Create conda environment
# RUN conda env update -n base -f environment.yml && \
#     conda clean -afy
# RUN conda install -n base -c conda-forge mamba -y

# RUN mamba install -n base -y -f environment.yml && \
#     conda clean -afy
    
# Install micromamba
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
    | tar -xvj bin/micromamba && \
    mv bin/micromamba /usr/local/bin/micromamba

# Install dependencies directly into base
RUN micromamba install -n base -y -f environment.yml && \
    micromamba clean --all --yes

# Copy the model code
COPY . .

# Set environment variables
ENV PYTHONPATH=/opt/program
ENV OPENBLAS_NUM_THREADS=1

# Use the startup script as entrypoint
ENTRYPOINT ["./start_api.sh"] 
