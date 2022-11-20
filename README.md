# Bulk actions for Proxmox VE

## Abstract

`pve-bulk` is a utility script for the [Proxmox VE](https://www.proxmox.com) hypervisor, which is designed to perform some CT/VM bulk actions.

## Description

This script will execute the given action on containers and virtual machines specified in the CT/VM lists.

You can specify the CT list by providing the `--ct-list` command-line option or by setting the `PVE_CT_LIST` environment variable.

You can specify the VM list by providing the `--vm-list` command-line option or by setting the `PVE_VM_LIST` environment variable.

CT/VM lists default to 0, i.e. no CTs/VMs are selected by default. To specify all CTs/VMs pass all as parameter, like --ct-list=all.

## Installation

Clone the repository in the `/opt/pve-bulk` directory on your PVE node:

```
git clone {repository-url} /opt/pve-bulk
```

Then create a symbolic link into the `/usr/local/bin` directory:

```
cd /usr/local/bin
ln -sf ../../../opt/pve-bulk/bin/pve-bulk ./pve-bulk
```

## Usage

```
Usage: pve-bulk [ACTION [PARAMETERS]] [OPTIONS]

Actions:

    help
    start
    shutdown
    stop
    listsnapshot
    snapshot <snapname>
    rollback <snapname>
    delsnapshot <snapname>

Options:

    --help
    --ct-list={ctid,...}    ct list (defaults to none, specify all to select all CTs as with pct list)
    --vm-list={vmid,...}    vm list (defaults to none, specify all to select all VMs as with qm list)

Environment variables:

    PVE_CT_MANAGER          ct manager (defaults to pct)
    PVE_CT_LIST             ct list    (defaults to none)
    PVE_VM_MANAGER          vm manager (defaults to qm)
    PVE_VM_LIST             vm list    (defaults to none)

```

## Examples

Create the snapshot named `STABLE` on each CT/VM:

```
root@pve-node:~# pve-bulk snapshot STABLE --vm-list=all --ct-list=all
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
