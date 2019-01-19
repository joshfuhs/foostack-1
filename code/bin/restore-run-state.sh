#!/bin/bash

echo "foostack: Restoring active instances"

FOOSTACK_DATA=/var/lib/foostack
RUN_STATE_STORAGE=$FOOSTACK_DATA/running
DEVSTACK_HOME=/opt/stack/devstack

source $DEVSTACK_HOME/openrc admin admin

for i in $(cat $RUN_STATE_STORAGE); do
	echo "    Restoring $i"
	openstack server start $i
done

rm -f $RUN_STATE_STORAGE
