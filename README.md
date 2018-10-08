# docker-payara-cluster
Payara Cluster (Deployment Group) based on Docker instances

## Build and Start the cluster

### build the payara node image (based on openjdk docker image)
`sudo docker build -f payara-node.dockerfile -t payara-node .`

### compose the Payara DAS, the 3 Payara nodes + 1 MySQL Server
`sudo docker-compose up -d`

### create nodes/instances and add them in the deployment group (dg-comptandye)
`sudo docker exec -i payara-das /opt/config-cluster.sh`

### copy and deploy clusterjsp
`sudo docker cp clusterjsp.war payara-das:/opt`
`sudo docker exec -i payara-das /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile deploy --availabilityenabled=true --target dg-webapp /opt/clusterjsp.war`

### start the deployment group
`sudo docker exec -i payara-das /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile start-deployment-group dg-webapp`
