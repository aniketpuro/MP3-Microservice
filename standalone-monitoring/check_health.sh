#!/bin/bash
ssh -i /home/aniket/accesskey -o StrictHostKeyChecking=no ubuntu@100.25.246.38 << 'EOF'
echo "--- Prometheus Health ---"
curl -s http://localhost:9090/-/healthy
echo -e "\n--- Grafana Health ---"
curl -s http://localhost:3000/api/health
echo -e "\n--- Prometheus Targets Up ---"
curl -s http://localhost:9090/api/v1/targets | grep -o '"health":"up"' | wc -l
EOF
