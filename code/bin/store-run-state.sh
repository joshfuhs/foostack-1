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
cp $RUNNING_INSTANCES_FILE $RUNNING_INSTANCES_FILE.record
openstack server list --all-projects --host $(hostname) -c ID -f value > $FOOSTACK_DATA/all_instances

RUNNING_INSTANCES_TMPFILE=/tmp/foostack.store-$$-$RANDOM
cp $RUNNING_INSTANCES_FILE $RUNNING_INSTANCES_TMPFILE

LINE_COUNT=$(wc -l $RUNNING_INSTANCES_TMPFILE | awk '{ print $1 }')
while [ $LINE_COUNT -gt 0 ]; do
	for i in $(cat $RUNNING_INSTANCES_TMPFILE); do
		# @todo: Will this work with a locked instance?
		# This shouldn't trigger an error. We're just trying to make sure
		# all servers get shut down.
		openstack server stop $i || /bin/true
	done
	openstack server list --all-projects --host $(hostname) --status ACTIVE -c ID -f value > RUNNING_INSTANES_TMPFILE
	LINE_COUNT=$(wc -l $RUNNING_INSTANCES_TMPFILE | awk '{ print $1 }')
done

rm $RUNNING_INSTANCES_TMPFILE
