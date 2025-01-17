## notes


### Build & Run
Make sure you have docker daemon started.
It is recommended to have docker engine installed directly in wsl, without Docker or Racher Desktops.
Some users may fail to start nomad agent with Rancher Desktops, other may fail to get nomad jobs communicated with each other using Docker Desktop. 

```
mvn clean spring-boot:build-image -DskipTests

docker run -p 8080:8080 notes:0.0.1-SNAPSHOT
```

Run in Nomad cluster
```
// Create dir for postgres volume
sudo mkdir /home/tao/nomad/postgres-data

consul agent -config-file=nomad/consul.hcl

sudo nomad agent -config=nomad/nomad-server.hcl -config=nomad/nomad-client.hcl

nomad job run nomad/notes-postgres.nomad.hcl

nomad job run nomad/notes-flyway.nomad.hcl

nomad job run nomad/notes-web.nomad.hcl 

// See IP addresses
nomad node status -verbose
```

Open Nomad UI
http://localhost:4646/ui/jobs

Open Consul UI
http://localhost:8500

Open Notes
http://172.19.95.218:8080/

You can open Nomad dir with datadir and logs using Visual Code, make sure you use your user name:
```
code /home/tao/nomad
```
Note: you will not see the /home/tao/nomad/postgres-data because it requires sudo access to see it

Run in docker compose. Useful if you want to test your app and db fast:
```
docker compose -f docker-compose/docker-compose.yml up -d
```

References:
Nomad installation, cluster and job create, update, delete https://developer.hashicorp.com/nomad/tutorials/get-started/gs-overview
Consul installation https://developer.hashicorp.com/consul/install?product_intent=consul
consul-cni installation: `sudo apt install consul-cni`
CNI plugins installation https://developer.hashicorp.com/nomad/docs/networking/cni#cni-reference-plugins
Consul Service Mesh configs and requirements https://developer.hashicorp.com/nomad/docs/integrations/consul/service-mesh
Nomad Host Volume tutorial https://developer.hashicorp.com/nomad/tutorials/stateful-workloads/stateful-workloads-host-volumes

```
Run in kubernetes / minikube
```
Prerequisite: Create image before run command

// note: check database credentials in yaml files to correspond your local postgres db

Note: The PersistentVolume definition can be omitted because the default storage class (kubectl get sc) provides dynamic provisioning of storage. Therefore, only the PVC is required. In this example, an explicit configuration for the PV was provided to practice PV configuration definitions.
```
    kubectl apply -f kubernetes/environment.yaml -> kubectl get configmaps
 0) kubectl apply -f kubernetes/postgres-pv.yaml
 1) kubectl apply -f kubernetes/postgres-pvc.yaml
 2) kubectl apply -f kubernetes/postgres-deployment.yaml
 3) kubectl apply -f kubernetes/postgres-service.yaml
 4) kubectl apply -f kubernetes/flyway-job.yaml
 5) kubectl apply -f kubernetes/web-application-deployment.yaml
 6) kubectl apply -f kubernetes/web-application-service.yaml
 7) minikube service notes-service --url
```

```
// to verify if it works 
kubectl get services
minikube service notes-service
```