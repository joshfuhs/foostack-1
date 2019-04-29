#
# Script to get initial single-node OpenStack install running.
#

set -e

PROJECT_NAME=foostack

SCRIPTDIR=$(realpath $(dirname $0))
STACK_HOME=/opt/stack

# Needed at least for Ubuntu 16.04
sudo apt-get install bridge-utils

# From: https://docs.openstack.org/devstack/latest/

sudo useradd -s /bin/bash -d $STACK_HOME -m stack

echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

sudo -u stack -H sh -c "cd && git clone https://git.openstack.org/openstack-dev/devstack"
# @todo: I suspect auto-update processes are causing things to break.
#   It grabs the dpkg lock and doesn't let go until it's done.
sudo -u stack -H cp $SCRIPTDIR/local.conf $STACK_HOME/devstack
sudo -u stack -H sh -c 'cd $HOME/devstack && ./stack.sh'

# Place for recording the state of all nodes on shutdown.
sudo mkdir /var/lib/$PROJECT_NAME
sudo mkdir /usr/lib/$PROJECT_NAME

sudo cp $SCRIPTDIR/systemd/* /etc/systemd/system
sudo cp $SCRIPTDIR/bin/* /usr/lib/$PROJECT_NAME

for i in $(ls /usr/lib/$PROJECT_NAME); do
	sudo chmod +x /usr/lib/$PROJECT_NAME/$i
done

sudo systemctl enable foostack@prep-c-vol.service
sudo systemctl enable foostack@run-state-recovery.service
sudo systemctl start foostack@run-state-recovery.service

# Make sure that the public network interface gets restored on reboot.
if [ -d /etc/netplan ]; then
	sudo cp $SCRIPTDIR/conf/netplan-br-ex.yaml /etc/netplan
	sudo netplan apply
else
	sudo cp $SCRIPTDIR/conf/ifcfg-br-ex /etc/network/interfaces.d
fi

# @todo: Set up shutdown process that migrates all instances off the host
#   before shutdown if the entire cluster isn't in a shutdown state.
#   To maintain a level of availability, the total utilization of the cluster
#   should stay one or two nodes below the max.

# @todo: Come up with a strategy for remembering running state and shutting down
#   when the whole cluster is in a shutdown state. In this event, project
#   owners/members should be made aware of the fact that they will be losing
#   VM state.

# @todo: If a node crashes and storage is shared, 'nova evacuate' can be used
#   to recover the instances. If storage isn't shared, you're probably screwed
#   until the node comes back. Use gluster or similar.
