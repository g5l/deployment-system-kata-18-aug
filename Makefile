.PHONY: help setup build deploy status clean port-forward

help: ## Show this help
	@echo 'Usage: make [target]'
	@echo ''
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[33m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Setup everything (Minikube + App)
	@echo "🚀 Setting up your DevOps foundation..."
	chmod +x scripts/setup.sh
	./scripts/setup.sh

build: ## Build the application image
	@echo "🔨 Building application..."
	cd applications/hello-app && docker build -t hello-app:latest .
	minikube image load hello-app:latest

deploy: ## Deploy the application
	@echo "🚀 Deploying application..."
	kubectl apply -f k8s/namespaces/namespaces.yaml
	kubectl apply -f applications/hello-app/k8s.yaml

status: ## Show deployment status
	@echo "📊 Cluster Status:"
	kubectl get nodes
	@echo "\n📦 Namespaces:"
	kubectl get namespaces
	@echo "\n🚀 Applications:"
	kubectl get pods,svc -n applications
	@echo "\n🏗️  Infrastructure:"
	kubectl get pods,svc -n infrastructure

port-forward: ## Access the application locally
	@echo "🌐 Accessing application at http://localhost:8080"
	@echo "Press Ctrl+C to stop"
	kubectl port-forward svc/hello-app 8080:80 -n applications

dashboard: ## Open Kubernetes dashboard
	minikube dashboard

clean: ## Clean up everything
	@echo "🧹 Cleaning up..."
	kubectl delete -f applications/hello-app/k8s.yaml --ignore-not-found=true
	kubectl delete -f k8s/namespaces/namespaces.yaml --ignore-not-found=true
	minikube delete

restart: clean setup ## Full restart