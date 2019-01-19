#!/bin/sh

# @todo: Check to see if these exist first
sudo losetup -f /opt/stack/data/stack-volumes-lvmdriver-1-backing-file
sudo losetup -f /opt/stack/data/stack-volumes-default-backing-file
