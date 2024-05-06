# Bulk actions for Proxmox VE - Bash Completion Script

## Abstract

This script contains the definitions that enable bash completion for `pve-bulk` command. It can complete `pve-bulk` actions and options and it can also suggest some of the parameters after the `--vm-list` and `--ct-list` options.

## Environment Variables for VMs' and CTs' lists

You can define some specific environment variables with a list of IDs (of VMs or CTs) which can be used by the bash completion script to be suggested after `--vm-list` and `--ct-list` options:

- `PVB_CT_*` variables are used for completion after `--ct-list` option
- `PVB_VM_*` variables are used for completion after `--vm-list` option

For example, you can place within the `~/.bashrc` of the user running `pve-bulk` the following variables and then restart the shell or execute `source ~/.bashrc`:

```bash
export PVB_CT_TEST="101,102"
export PVB_CT_PROD="103,104"
export PVB_VM_DEVEL="1001,1011,1012,1013,1021,1022"
export PVB_VM_TEST="1211,1212,1213"
```

These variables allow you to call `pve-bulk` with a command like this and will be used by bash completion:

```bash
pve-bulk listsnapshot --vm-list=${PVB_VM_DEVEL}
```

## Testing pve-bulk completion script

You can test `pve-bulk` bash completion by loading it with source:

```bash
source pve-bulk-completion
```

## Installing pve-bulk permanently for all users

You can install `pve-bulk` along with the other bash completion scripts with the following command:

```bash
sudo install -m 0644 -o root -g root pve-bulk-completion /etc/bash_completion.d/
```

When you'll start a new shell `pve-bulk` completion script will be active.

## Uninstalling pve-bulk

It is sufficient to remove it from the global bash completion folder and then restart the shell:

```bash
rm -f /etc/bash_completion.d/pve-bulk-completion -i
rm: remove regular file '/etc/bash_completion.d/pve-bulk-completion'? y
removed '/etc/bash_completion.d/pve-bulk-completion'
```

## Completion examples

Follow some examples of how pressing `<TAB>` (double `<TAB>` if there are multiple options) triggers pve-bulk bash completion:

```bash
$ pve-bulk <TAB><TAB>
delsnapshot   help          rollback      snapshot      status
--help        listsnapshot  shutdown      start         stop

$ pve-bulk st<TAB><TAB>
start   status  stop

# The following expands the command on the same line
$ pve-bulk sn<TAB><TAB>
# producing the following
$ pve-bulk snapshot

# The following triggers a suggestion to specify a snapshot name, you can delete it and enter the desired name
$ pve-bulk snapshot <TAB>
$ pve-bulk snapshot SNAP_NAME
$ pve-bulk snapshot my-snapshot --<TAB><TAB>
--all       --ct-list=  --running   --stopped   --vm-list=

# If we specify --vm-list then the completion scripts looks for environment variables starting with PVB_VM_
$ pve-bulk snapshot my-snapshot --vm-list=<TAB><TAB>
$PVB_VM_CEPH   $PVB_VM_DEVEL     running        stopped
$ pve-bulk snapshot my-snapshot --vm-list=$P<TAB>
$ pve-bulk snapshot my-snapshot --vm-list=$PVB_VM_<TAB><TAB>
$PVB_VM_CEPH   $PVB_VM_DEVEL
$ pve-bulk snapshot my-snapshot --vm-list=$PVB_VM_D<TAB>
$ pve-bulk snapshot my-snapshot --vm-list=$PVB_VM_DEVEL

# We can press <TAB> after --vm-list=xxx the completion immediately completes with --ct-list which is the only other
# valid option after --vm-list. It works vice versa too.
$ pve-bulk snapshot my-snapshot --vm-list=$PVB_VM_DEVEL <TAB>
$ pve-bulk snapshot my-snapshot --vm-list=$PVB_VM_DEVEL --ct-list=<TAB><TAB>
$PVB_CT_PROD   $PVB_CT_TEST      running        stopped
$ pve-bulk snapshot my-snapshot --vm-list=$PVB_VM_DEVEL --ct-list=r<TAB>
$ pve-bulk snapshot my-snapshot --vm-list=$PVB_VM_DEVEL --ct-list=running

$ pve-bulk listsnapshot --<TAB><TAB>
--all       --ct-list=  --running   --stopped   --vm-list=
$ pve-bulk listsnapshot --a<TAB>
$ pve-bulk listsnapshot --all
```
