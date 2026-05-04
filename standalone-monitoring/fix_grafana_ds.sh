#!/bin/bash
cat << 'DS' > /tmp/ds.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: monitoring-kube-prometheus-grafana-datasource
  namespace: monitoring
  labels:
    grafana_datasource: "1"
data:
  datasource.yaml: |-
    apiVersion: 1
    datasources:
    - name: "Prometheus"
      type: prometheus
      uid: prometheus
      url: http://monitoring-kube-prometheus-prometheus.monitoring:9090/
      access: proxy
      isDefault: true
      jsonData:
        httpMethod: POST
        timeInterval: 30s
    - name: "Alertmanager"
      type: alertmanager
      uid: alertmanager
      url: http://monitoring-kube-prometheus-alertmanager.monitoring:9093/
      access: proxy
      jsonData:
        handleGrafanaManagedAlerts: false
        implementation: prometheus
DS
sudo microk8s kubectl apply -f /tmp/ds.yaml
