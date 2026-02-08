# Kubernetes Application & Monitoring Stack (Learning Project)

This repository contains a fully working Kubernetes stack built from scratch
to practice and demonstrate understanding of core Kubernetes concepts.

This is a learning and portfolio project, not production-ready.

---

## Architecture Overview

Application stack:
- nginx (custom Docker image)
- php-fpm (custom Docker image)

Monitoring stack:
- node-exporter (DaemonSet)
- Prometheus
- Grafana

---

## Kubernetes concepts covered

- Deployment
- DaemonSet
- Service
- ConfigMap
- Secret
- PersistentVolumeClaim (PVC)

---

## Repository structure

This is how the project looks (example output of: tree -L 4)
```text

k8_hero
├── apps
│   ├── nginx
│   │   ├── nginx-Dockerfile
│   │   ├── nginx-deployment.yaml
│   │   ├── nginx-configmap.yaml
│   │   └── index.html
│   └── php
│       ├── php-Dockerfile
│       ├── php-fpm-deployment.yaml
│       └── index.php
├── monitoring
│   ├── node-exporter
│   │   └── node-exporter.yaml
│   ├── prometheus
│   │   ├── prometheus-configmap.yaml
│   │   └── prometheus-deployment.yaml
│   └── grafana
│       ├── grafana-deployment.yaml
│       ├── grafana-service.yaml
│       ├── grafana-pvc.yaml
│       ├── grafana-secret.example.yaml
│       └── grafana-datasource-configmap.yaml
├── scripts
│   └── deploy.sh
└── README.md
```
---

## Requirements

- Docker
- kubectl
- minikube

---

## How to run locally (Minikube)

1) Start Minikube
```md
minikube start
```
2) Build application Docker images
```md
docker build -t my-nginx -f apps/nginx/nginx-Dockerfile apps/nginx
docker build -t my-php-fpm -f apps/php/php-Dockerfile apps/php
```
3) Deploy application stack
```md
kubectl apply -f apps/nginx
kubectl apply -f apps/php
```
4) Deploy monitoring stack
```md
kubectl apply -f monitoring/node-exporter
kubectl apply -f monitoring/prometheus
kubectl apply -f monitoring/grafana
```
5) Create Grafana admin credentials (Secret)
```bash
cp monitoring/grafana/grafana-secret.example.yaml monitoring/grafana/grafana-secret.yaml
nano monitoring/grafana/grafana-secret.yaml
```
```text
Change password "CHANGE_ME"
```
```md
kubectl apply -f monitoring/grafana/grafana-secret.yaml
kubectl rollout restart deployment/grafana
```
6) Access Grafana UI
```md
minikube service grafana
```
Login:
- user: admin
- password: value defined in the secret

---

## Updating application code

If you change the PHP application code (for example apps/php/index.php), the PHP Docker image must be rebuilt and redeployed.

To apply the change, run the deploy script:

scripts/deploy.sh

(That script rebuilds the PHP image and triggers a rolling update of the php-fpm Deployment.)

---

## Grafana dashboards

Recommended dashboard:
- Node Exporter Full (Grafana dashboard ID: 1860)

---

## Security notes

- Real secret is not committed to the repository
- Secret file is excluded via .gitignore
- Only example secret file (*.example.yaml) is committed
- Base64 encoding is not encryption

