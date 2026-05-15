# AWS Infrastructure and Microservices Deployment to EKS

## Kubernetes in Kind

Creating the cluster and loading the images
```
kind create cluster --name microservices-demo

kind load docker-image product-service:v1 --name a002-microservices-demo
kind load docker-image order-service:v1 --name a002-microservices-demo

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

If needed
```
kubectl port-forward service/order-service 8081:8081
```



