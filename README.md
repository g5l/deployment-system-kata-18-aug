# deployment-system-kata-18-aug

This project demonstrates a full deployment system with CI/CD and monitoring capabilities using:

- Jenkins
- Helm
- OpenTofu (Terraform fork)
- Kubernetes (Minikube)
- Prometheus
- Grafana

## Setup Guide

### 1. Prerequisites

- Docker
- kubectl
- Helm
- Minikube
- OpenTofu
- Git

## Quick Start
```bash
# Setup everything
make setup

# Check status  
make status

# Access your app
make port-forward
# Visit http://localhost:8080
