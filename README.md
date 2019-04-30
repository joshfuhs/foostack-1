# foostack-1

This project sets up a single-node DevStack system with minimal intervention. It adds some extra tools to allow DevStack to restart on reboot (which it was not designed for).

This is not intended for production use.

## Prerequisites

- Fresh install of Ubuntu 16.04 or 18.04
- `git`

## Installation

```
git clone https://github.com/joshfuhs/foostack-1.git
bash foostack-1/code/setup.sh
```

wait a bit...

## Known Problems

- VMs don't always restart after rebooting the node.
- System passwords are fixed rather than chosen at install time.
