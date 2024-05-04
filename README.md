# Bulk actions for Proxmox VE

## Abstract

`pve-bulk` is a utility script for the [Proxmox VE](https://www.proxmox.com) hypervisor, which is designed to perform some CT/VM bulk actions.

## Description

This script will execute the given action on each container and each virtual machine specified int the command-line.

You can specify the CT list by providing the `--ct-list` command-line option or by setting the `PVE_CT_LIST` environment variable.

You can specify the VM list by providing the `--vm-list` command-line option or by setting the `PVE_VM_LIST` environment variable.

By default, CT/VM lists default to `none`, meaning that no CTs/VMs are selected. You can specify `all`, `running` or `stopped` to pass the list of all, running or stopped CTs/VMs.

You can specify `--all`, `--running` or `--stopped` as a shortcut to set the corresponding value for both `--ct-list` and `--vm-list` options.

## Install

If you have `make` on your system:

```
make install
```

If you don't have `make` on your system:

```
./utils/install.sh
```

## Uninstall

If you have `make` on your system:

```
make uninstall
```

If you don't have `make` on your system:

```
./utils/uninstall.sh
```

## Usage

```
Usage: pve-bulk [ACTION [PARAMETERS]] [OPTIONS]

Actions:

    help
    start
    shutdown
    stop
    status
    listsnapshot
    snapshot <snapname>
    rollback <snapname>
    delsnapshot <snapname>

Options:

    --help
    --ct-list={ctid,...}    ct list (defaults to 'none'; specify 'all' to select all CTs as with pct list, 'running' to select all running CTs or 'stopped' to select all stopped CTs)
    --vm-list={vmid,...}    vm list (defaults to 'none'; specify 'all' to select all VMs as with qm list, 'running' to select all running CTs or 'stopped' to select all stopped VMs)
    --all                   set ct-list and vm-list to 'all'
    --running               set ct-list and vm-list to 'running'
    --stopped               set ct-list and vm-list to 'stopped'

Environment variables:

    PVE_CT_MANAGER          ct manager (defaults to pct)
    PVE_CT_LIST             ct list    (defaults to none)
    PVE_VM_MANAGER          vm manager (defaults to qm)
    PVE_VM_LIST             vm list    (defaults to none)

```

## Examples

Create the snapshot named `STABLE` on each CT/VM:

```
root@pve-node:~# pve-bulk snapshot STABLE --all
ct1001 : snapshot STABLE has succeeded
ct1002 : snapshot STABLE has succeeded
ct1003 : snapshot STABLE has succeeded
vm1101 : snapshot STABLE has succeeded
vm1102 : snapshot STABLE has succeeded
vm1103 : snapshot STABLE has succeeded
```

Rollback the snapshot named `STABLE` on VM 1101 and 1102 but not on CT:

```
root@pve-node:~# pve-bulk rollback STABLE --vm-list=1101,1102
vm1101 : rollback STABLE has succeeded
vm1102 : rollback STABLE has succeeded
```

Delete the snapshot named `STABLE` on each CT but not on VM:

```
root@pve-node:~# pve-bulk delsnapshot STABLE --ct-list=all
ct1001 : delsnapshot STABLE has succeeded
ct1002 : delsnapshot STABLE has succeeded
ct1003 : delsnapshot STABLE has succeeded
```

Shutdown all running VMs:

```
pve-bulk shutdown --vm-list=running
```

Stop all running VMs/CTs:

```
pve-bulk stop --running
```
