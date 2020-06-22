#!/bin/bash
sudo useradd -M -r -s /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar xzf node_exporter-1.0.1.linux-amd64.tar.gz
sudo cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin

sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

sudo tee -a /etc/systemd/system/node_exporter.service > /dev/null <<EOT
     [Unit]    
     Description=node exporter service
     Wants=network-online.target

     [Service]
     User=node_exporter
     Group=node_exporter
     Type=simple
     ExecStart=/usr/local/bin/node_exporter

     [Install]
     WantedBy=multi-user.target

EOT

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter