# Dockerfile for Docker dev container for sharethings-web project. This is heavily based
# on https://registry.hub.docker.com/u/fgrehm/vagrant-ubuntu/dockerfile but has been
# modified so as to remove extraneous stuff, e.g install of Chef/Puppet.
FROM ubuntu-upstart:trusty

# Create and configure vagrant user.
RUN useradd --create-home -s /bin/bash vagrant
WORKDIR /home/vagrant

# Create ssh directory, required for sshd to run.
RUN mkdir /var/run/sshd

# Enable universe (required by dpkg).
RUN echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe' > /etc/apt/sources.list

# Update apt and install required packages.
RUN apt-get update && \
    apt-get install openssh-server sudo curl ntp vim-youcompleteme git -y && \
    apt-get upgrade -y && \
    apt-get clean

# Configure SSH access.
RUN mkdir -p /home/vagrant/.ssh
RUN curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant: /home/vagrant/.ssh
RUN adduser vagrant sudo
RUN echo -n 'vagrant:vagrant' | chpasswd

# Enable passwordless sudo for users in the "sudo" group, i.e. vagrant.
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers


