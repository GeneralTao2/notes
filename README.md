## notes


### Build & Run
Make sure you have docker daemon started.
```
mvn clean spring-boot:build-image -DskipTests
docker run -p 8080:8080 notes:0.0.1-SNAPSHOT
```

Run in kubernetes / minikube
```
Prerequisite: Create image before run command

minikube start --driver=docker
minikube -p minikube docker-env after that enter the following:
SET DOCKER_TLS_VERIFY=1
SET DOCKER_HOST=tcp://127.0.0.1:32816
SET DOCKER_CERT_PATH=your value from the command above
SET MINIKUBE_ACTIVE_DOCKERD=minikube

// Load image from your local pc to minikube 
minikube image load notes:0.0.1-SNAPSHOT

kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml

// to verify if it works 

kubectl get services
minikube service notes-service

```