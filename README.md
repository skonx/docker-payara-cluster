# docker-payara-cluster
:sparkles: Payara Cluster (Deployment Group) based on Docker instances :sparkles:
- **1 Payara DAS (Xmx/Xms 2GB)**
  - based on the latest payara/server-full image
- **3 Payara Nodes (each hosting 2 Xmx/Xms 1GB instances)**
  - based on the latest openjdk:8-jdk image
- **1 Mysql Server (standalone, for the moment)**
  - based on the latest mysql:5.7 image

## Build and Start the cluster

### build the payara node image
`sudo docker build -f payara-node.dockerfile -t payara-node .`
> payara-node image will be used in the compose file

### compose the Payara DAS, the 3 Payara nodes + 1 MySQL Server
`sudo docker-compose up -d`

### create nodes/instances and add them in the deployment group (dg-comptandye)
`sudo docker exec -i payara-das /opt/config-cluster.sh`

### copy and deploy clusterjsp
`sudo docker cp clusterjsp.war payara-das:/opt`
`sudo docker exec -i payara-das /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile deploy --availabilityenabled=true --target dg-webapp /opt/clusterjsp.war`

### start the deployment group
`sudo docker exec -i payara-das /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile start-deployment-group dg-webapp`
