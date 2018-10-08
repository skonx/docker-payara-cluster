# docker-payara-cluster
:sparkles: Payara Cluster (Deployment Group) based on Docker instances :sparkles:
- **1 Payara DAS (Xmx/Xms 2GB)**
  - based on the latest payara/server-full image
- **3 Payara Nodes (each hosting 2 Xmx/Xms 1GB instances)**
  - based on the latest openjdk:8-jdk image
- **1 Mysql Server (standalone, for the moment)**
  - based on the latest mysql:5.7 image

## Build and Start the cluster

### Build the payara node image
`sudo docker build -f payara-node.dockerfile -t payara-node .`
> *payara-node* image will be used in the compose file

### Compose the platform
`sudo docker-compose up -d`
> remove `-d` option if you don't want to detach the DAS container and display the logs on INPUT

### Create nodes/instances and Add them in the Deployment Group (dg-webapp)
`sudo docker exec -i payara-das /opt/config-cluster.sh`

### Copy and Deploy clusterjsp (Oracle's Sample Application)
`sudo docker cp clusterjsp.war payara-das:/opt`

`sudo docker exec -i payara-das /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile deploy --availabilityenabled=true --target dg-webapp /opt/clusterjsp.war`

### Start the deployment group
`sudo docker exec -i payara-das /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile start-deployment-group dg-webapp`

# :+1: You're done  :clap::clap::clap:

:see_no_evil: Try to test session replication accessing ports `18080, 18081, 28080, 28081, 38080 and 38081`
