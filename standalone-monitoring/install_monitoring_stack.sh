#!/bin/bash
# Install Prometheus and Grafana on the Central Monitoring Server
# Run this ONLY on the Central Monitoring EC2 instance.

PROM_VERSION="2.45.0"

echo "--- 1. Setting up Prometheus ---"
sudo useradd --no-create-home --shell /bin/false prometheus || true
sudo mkdir -p /etc/prometheus /var/lib/prometheus

wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
sudo mv prometheus-${PROM_VERSION}.linux-amd64/prometheus prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/consoles prometheus-${PROM_VERSION}.linux-amd64/console_libraries /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
rm -rf prometheus-${PROM_VERSION}.linux-amd64*

# Create Prometheus Systemd Service
sudo tee /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus
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

echo "--- 2. Setting up Grafana ---"
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana

echo "--- 3. Starting Services ---"
sudo systemctl daemon-reload
sudo systemctl enable --now grafana-server
# Prometheus will be started after the config file is placed in /etc/prometheus/prometheus.yml

echo "✅ Monitoring stack (Prometheus & Grafana) installed!"
echo "Next step: Copy prometheus.yml to /etc/prometheus/ and run 'sudo systemctl start prometheus'"
