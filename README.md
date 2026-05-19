# AWS Infrastructure and Microservices Deployment to EKS

## Creating Docker Images of the Services
<TODO>
product-service:v2
order-service:v2

## Kubernetes in Kind

Install Kind, Docker and start docker

Creating the cluster and loading the images
```
kind get clusters
kind delete cluster --name a002-microservices-demo
kind create cluster --name a002-microservices-demo
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl get pods -n ingress-nginx
```

Load the images to Kind
```
kind load docker-image product-service:v2 --name a002-microservices-demo
kind load docker-image order-service:v2 --name a002-microservices-demo

kubectl config use-context kind-a002-microservices-demo
```

Checking the cluster
```
kubectl config get-contexts
kubectl config current-context
kubectl cluster-info
kubectl cluster-info --context kind-a002-microservices-demo
```

To apply the deployments and services to the Kubernetes Cluster
```
kubectl apply -f k8s/
```

Check if the pods and services are running
```
kubectl get pods
kubectl get services
```
Test
```
kubectl port-forward service/order-service 8081:8081
```
From browser:
```
http://localhost:8080/orders
```

--------------------------------------------------------------------------
## Metrics Server added to Kubernetes
### Step 1 — Install Metrics Server

HPA needs cluster metrics.

Run:
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
### Step 2 — Patch Metrics Server for kind

IMPORTANT:
kind requires insecure TLS setting.

Run:
```
kubectl patch deployment metrics-server -n kube-system --type=json -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```

### Step 3 — Wait for Metrics Server

Run:
```
kubectl get pods -n kube-system
```
Wait until: metrics-server = Running

### Step 4 — Verify Metrics Work

Run:
```
kubectl top pods
```
You should now see:
CPU
memory usage

If this works:
metrics pipeline is ready.

