#!/bin/bash
# scripts/setup.sh

set -e

echo "🚀 Setting up your DevOps foundation..."

# Check if tools are installed
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 is not installed. Please install it first."
        exit 1
    else
        echo "✅ $1 is installed"
    fi
}

echo "Checking required tools..."
check_tool docker
check_tool kubectl
check_tool minikube

# Start Minikube
echo "🔄 Starting Minikube..."
minikube start --driver=docker --cpus=2 --memory=4096

# Enable required addons
echo "🔄 Enabling Minikube addons..."
minikube addons enable dashboard
minikube addons enable metrics-server

# Set kubectl context
kubectl config use-context minikube

echo "✅ Minikube is ready!"

# Create namespaces
echo "🔄 Creating namespaces..."
kubectl apply -f k8s/namespaces/namespaces.yaml

# Build and load application image
echo "🔄 Building application..."
cd applications/hello-app
docker build -t hello-app:latest .
minikube image load hello-app:latest
cd ../..

# Deploy application
echo "🔄 Deploying application..."
kubectl apply -f applications/hello-app/k8s.yaml

# Wait for deployment
echo "🔄 Waiting for deployment..."
kubectl wait --for=condition=available --timeout=300s deployment/hello-app -n applications

echo "Setup completed!"
echo ""
echo "What's running:"
echo " - Minikube cluster"
echo " - Hello-app in 'applications' namespace"
echo " - Infrastructure namespace ready for monitoring"
echo ""
echo "Check your deployment:"
echo "kubectl get pods -n applications"
echo "kubectl get svc -n applications"
echo ""
echo "Access your app:"
echo "kubectl port-forward svc/hello-app 8080:80 -n applications"
echo "Then visit: http://localhost:8080"
echo ""
echo "Open Kubernetes dashboard:"
echo "minikube dashboard"