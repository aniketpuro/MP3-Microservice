#!/bin/bash
# Install Node Exporter as a systemd service
# Run this on EVERY EC2 instance you want to monitor.

NODE_EXPORTER_VERSION="1.7.0"

echo "--- Creating node_exporter user ---"
sudo useradd --no-create-home --shell /bin/false node_exporter || true

echo "--- Downloading Node Exporter v${NODE_EXPORTER_VERSION} ---"
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64*

echo "--- Creating systemd service ---"
sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

echo "--- Starting Node Exporter ---"
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

echo "✅ Node Exporter is running on port 9100"
