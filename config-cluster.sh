#!/bin/bash

# number of payara nodes
# should be the same number as defined in the compose file
N=3
# node default name
NODE="payara-node"
# default payara deployment group
DG="dg-webapp"
# default user
USER="root"

for i in `seq 1 $N`;
do
  /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-node-ssh --nodehost $NODE$i --sshuser $USER --install=true $NODE$i;
  /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-instance --node $NODE$i i1n$i;
  /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-instance --node $NODE$i i2n$i;
  /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile add-instance-to-deployment-group --instance i1n$i --deploymentgroup $DG;
  /opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile add-instance-to-deployment-group --instance i2n$i --deploymentgroup $DG;
done
