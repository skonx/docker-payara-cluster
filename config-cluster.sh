#!/bin/bash

NODE1="payara-node1"
NODE2="payara-node2"
CONFIG="dg-config"
DG="dg-comptandye"
USER="payara"

/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-node-ssh --nodehost $NODE1 --sshuser $USER --install=true $NODE1
/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-node-ssh --nodehost $NODE2 --sshuser $USER --install=true $NODE2

/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-instance --node $NODE1 --config $CONFIG i1n1
/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-instance --node $NODE1 --config $CONFIG i2n1
/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-instance --node $NODE2 --config $CONFIG i1n2
/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile create-instance --node $NODE2 --config $CONFIG i2n2

/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile add-instance-to-deployment-group --instance i1n1 --deploymentgroup $DG
/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile add-instance-to-deployment-group --instance i2n1 --deploymentgroup $DG
/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile add-instance-to-deployment-group --instance i1n2 --deploymentgroup $DG
/opt/payara5/bin/asadmin --passwordfile=/opt/pwdfile add-instance-to-deployment-group --instance i2n2 --deploymentgroup $DG
