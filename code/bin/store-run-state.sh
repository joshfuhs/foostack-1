#!/bin/bash
#
#

set -e

echo "foostack: Storing active instance"

FOOSTACK_DATA=/var/lib/foostack
RUNNING_INSTANCES_FILE=$FOOSTACK_DATA/running

DEVSTACK_HOME=/opt/stack/devstack

source $DEVSTACK_HOME/openrc admin admin
openstack server list --all-projects --host $(hostname) --status ACTIVE -c ID -f value > $RUNNING_INSTANCES_FILE
