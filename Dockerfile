FROM ubuntu:24.04

ARG TZ=Europe/London
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=$TZ
ENV SHELL=/bin/zsh

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Minimal setup to run the installer
RUN apt-get update && apt-get install -y sudo locales && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Create a non-root user with sudo access
RUN useradd -m -s /bin/bash devuser \
    && echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy install files
COPY --chown=devuser:devuser . /devenv

# Run the installer
USER devuser
WORKDIR /devenv
RUN ./install.sh

WORKDIR /home/devuser
CMD ["zsh"]
