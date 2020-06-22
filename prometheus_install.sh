#!/bin/bash
sudo useradd -M -r -s /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.19.1/prometheus-2.19.1.linux-amd64.tar.gz
tar xzf prometheus-2.19.1.linux-amd64.tar.gz
sudo cp prometheus-2.19.1.linux-amd64/prometheus /usr/local/bin
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo cp -r prometheus-2.19.1.linux-amd64/{consoles,console_libraries}
sudo cp prometheus-2.19.1.linux-amd64/prometheus.yml /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheuss

sudo tee -a /etc/systemd/system/prometheus.service > /dev/null <<EOT
     [Unit]
     Description=Prometheus Time Series Collection and Processing Server
     Wants=network-online.target
     After=network-online.target

     [Service]
     User=prometheus
     Group=prometheus
     Type=simple
     ExecStart=/usr/local/bin/prometheus \
        --config.file /etc/prometheus/prometheus.yml \
        --storage.tsdb.path /var/lib/prometheus/ \
        --web.console.templates=/etc/prometheus/consoles \
        --web.console.libraries=/etc/prometheus/console_libraries

     [Install]
     WantedBy=multi-user.target

EOT

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
