FROM rockylinux:9

ARG user=phil

COPY certs/ /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust

RUN yum update -y
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y sudo zsh procps-ng python3-devel python3-pip

RUN useradd -ms /bin/zsh $user
RUN usermod -aG wheel $user
RUN echo "$user:password" | chpasswd

USER $user
WORKDIR /home/$user
