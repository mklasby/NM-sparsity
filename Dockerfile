FROM pytorch/pytorch:1.8.0-cuda11.1-cudnn8-runtime
ARG USERNAME=user
ARG WORKSPACE_DIR=/home/${USERNAME}/NM-sparsity
ARG BUILD_DIR=/home/${USERNAME}/build
ARG VENV_PATH=${BUILD_DIR}/.venv
ARG USER_UID=1000003
ARG USER_GID=1000001
SHELL ["/bin/bash", "-c"]

# Create the user
RUN groupadd --gid $USER_GID ${USERNAME} \
    && useradd --uid $USER_UID --gid $USER_GID -m ${USERNAME}

# Install git/ssh/tmux
RUN apt-get update \
    && apt-get install -y git ssh curl

USER ${USERNAME}

RUN mkdir ${BUILD_DIR}
WORKDIR ${BUILD_DIR}

COPY ./requirements.txt ./
RUN python3 -m venv .venv && source .venv/bin/activate && pip3 install --upgrade pip && pip install -r requirements.txt
RUN echo "source ${VENV_PATH}/bin/activate" >> /home/$USERNAME/.bashrc
WORKDIR ${WORKSPACE_DIR}