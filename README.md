# docker-payara-cluster
Payara Cluster (Deployment Group) based on Docker instances

# build
`docker build -f payara-node.dockerfile -t payara-node .`

`docker-compose up`

`docker exec -i payara-das /opt/config-cluster.sh`

`docker exec -i payara-das /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile start-deployment-group dg-comptandye`
