#!/bin/bash
sudo useradd -M -r -s /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/promethues
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.19.1/prometheus-2.19.1.linux-amd64.tar.gz
tar xzf prometheus-2.19.1.linux-amd64.tar.gz
sudo cp prometheus-2.19.1.linux-amd64.tar.gz/promethues /usr/local/bin
sudo chown promethues:promethues /usr/local/bin/prometheus
sudo cp -r prometheus-2.19.1.linux-amd64.tar.gz/{consoles,console_libraries}
sudo chown -R promethues:prometheus /etc/promethues
sudo chown prometheus:prometheus /var/lib/promethues

cat <<EOF >> /etc/systemd/system/prometheus.service
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
     EOF

sudo systemctl daemon-reload