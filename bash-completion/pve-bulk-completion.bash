#/usr/bin/env bash

#######################################
# Bash Completion script for pve-bulk #
#                                     #
# Version: 1.0                        #
#######################################

PVE_BULK_ACTIONS="help start shutdown stop status listsnapshot snapshot rollback delsnapshot --help"
PVE_BULK_OPTIONS="--ct-list= --vm-list= --all --stopped --running"

_pve_bulk_completion()
{
    # Retrieve environment variables with lists of VMs and CTs
    PVE_BULK_VM_VARS=$(env | grep PVE_BULK_VM_ | cut -d= -f 1)
    PVE_BULK_CT_VARS=$(env | grep PVE_BULK_CT_ | cut -d= -f 1)

    local suggestions=""
    
    if [ "${#COMP_WORDS[@]}" == "2" ]; then
        # Complete actions at the beginning of the command
        suggestions=($(compgen -W "${PVE_BULK_ACTIONS}" -- "${COMP_WORDS[1]}" ))
    elif [ "${#COMP_WORDS[@]}" -ge "2" ]; then
        # Complete options for specific actions
        case ${COMP_WORDS[1]} in
            listsnapshot|snapshot|rollback|delsnapshot)
                if [ ${COMP_WORDS[1]} != "listsnapshot" ] && [ "${#COMP_WORDS[@]}" == "3" ] && [ -z ${COMP_WORDS[2]} ] ; then
                    # For snapshot, rollback and delsnapshot actions give users an hint about the need to specify the name of the snapshot
                    suggestions="SNAP-NAME"
                else
                    if [ ${COMP_WORDS[1]} != "listsnapshot" ] ; then
                        # If action is snapshot, rollback or delsnapshot, pop the first element of the COMP_WORDS array in order to
                        # have the same processing as listsnapshot options
                        COMP_WORDS=("${COMP_WORDS[@]:1}")
                    fi
                    
                    if [ "${#COMP_WORDS[@]}" == "3" ] ; then
                        # Suggest all the options if this is the first option after the action
                        suggestions=($(compgen -W "${PVE_BULK_OPTIONS}" -- "${COMP_WORDS[2]}"))
                    elif [ "${#COMP_WORDS[@]}" == "6" ] ; then
                        # If this is the second option specified, suggest --vm-list if first option is --ct-list and vice versa
                        if [ ${COMP_WORDS[2]} == "--vm-list" ] ; then
                            suggestions=($(compgen -W "--ct-list=" -- "${COMP_WORDS[5]}"))
                        elif [ ${COMP_WORDS[2]} == "--ct-list" ] ; then
                            suggestions=($(compgen -W "--vm-list=" -- "${COMP_WORDS[5]}")) 
                        else
                            return
                        fi

                    ####################################
                    # Completions for --vm-list option #
                    ####################################

                    # If we have --vm-list= without any character after "=", return the available PVE_BULK_VM_* vars, if available, as suggestions
                    elif [ "${#COMP_WORDS[@]}" == "4" ] && [ ${COMP_WORDS[2]} == "--vm-list" ] && [ ${COMP_WORDS[3]} == "=" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_VM_VARS}" -P '$') $(compgen -W "running stopped"))
                    elif [ "${#COMP_WORDS[@]}" == "7" ] && [ ${COMP_WORDS[5]} == "--vm-list" ] && [ ${COMP_WORDS[6]} == "=" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_VM_VARS}" -P '$') $(compgen -W "running stopped"))

                    # If we have --vm-list=XXX, return the available PVE_BULK_VM_* vars, if available, that have XXX as prefix
                    elif [ "${#COMP_WORDS[@]}" == "5" ] && [ ${COMP_WORDS[2]} == "--vm-list" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_VM_VARS}" -P '$' -- "${COMP_WORDS[4]##$}") $(compgen -W "running stopped" -- "${COMP_WORDS[4]##$}"))
                    elif [ "${#COMP_WORDS[@]}" == "8" ] && [ ${COMP_WORDS[5]} == "--vm-list" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_VM_VARS}" -P '$' -- "${COMP_WORDS[7]##$}") $(compgen -W "running stopped" -- "${COMP_WORDS[7]##$}"))

                    ####################################
                    # Completions for --ct-list option #
                    ####################################

                    # If we have --vm-list= without any character after "=", return the available PVE_BULK_CT_* vars, if available, as suggestions
                    elif [ "${#COMP_WORDS[@]}" == "4" ] && [ ${COMP_WORDS[2]} == "--ct-list" ] && [ ${COMP_WORDS[3]} == "=" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_CT_VARS}" -P '$') $(compgen -W "running stopped"))
                    elif [ "${#COMP_WORDS[@]}" == "7" ] && [ ${COMP_WORDS[5]} == "--ct-list" ] && [ ${COMP_WORDS[6]} == "=" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_CT_VARS}" -P '$') $(compgen -W "running stopped"))
                 
                    # If we have --vm-list=XXX, return the available PVE_BULK_CT_* vars, if available, that have XXX as prefix
                    elif [ "${#COMP_WORDS[@]}" == "5" ] && [ ${COMP_WORDS[2]} == "--ct-list" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_CT_VARS}" -P '$' -- "${COMP_WORDS[4]##$}") $(compgen -W "running stopped" -- "${COMP_WORDS[4]##$}"))
                    elif [ "${#COMP_WORDS[@]}" == "8" ] && [ ${COMP_WORDS[5]} == "--ct-list" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_CT_VARS}" -P '$' -- "${COMP_WORDS[7]##$}") $(compgen -W "running stopped" -- "${COMP_WORDS[7]##$}"))
                    else
                        return
                    fi
                fi
            ;;
            
            *)
                return
            ;;
        esac
    fi
    
    COMPREPLY=("${suggestions[@]}")
}

complete -o nospace -F _pve_bulk_completion pve-bulk
