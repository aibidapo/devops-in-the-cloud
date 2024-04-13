#!/bin/bash

# Import the GPG key:
wget -q -O gpg.key https://rpm.grafana.com/gpg.key &&
sudo rpm --import gpg.key &&

# Create /etc/yum.repos.d/grafana.repo with the following content:
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt

# To prevent beta versions from being installed, add the following exclude line to your .repo file.
exclude=*beta*


# To install Grafana Enterprise, run the following command:
sudo dnf install grafana-enterprise &&

sudo systemctl start grafana-server &&

sudo systemctl enable grafana-server.service