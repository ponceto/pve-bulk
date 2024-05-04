#/usr/bin/env bash -x

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
    PVE_BULK_VM_VARS=$(env | grep PVB_VM_ | cut -d= -f 1)
    PVE_BULK_CT_VARS=$(env | grep PVB_CT_ | cut -d= -f 1)

    local suggestions=""
    
    if [ "${#COMP_WORDS[@]}" == "2" ]; then
        # Complete actions at the beginning of the command
        suggestions=($(compgen -W "${PVE_BULK_ACTIONS}" -- "${COMP_WORDS[1]}" ))
    elif [ "${#COMP_WORDS[@]}" -ge "2" ]; then
        # Complete options for specific actions 
        ACTION_TYPE="STOP_COMPLETION"
        case ${COMP_WORDS[1]} in
            "snapshot" | "rollback" | "delsnapshot")
                ACTION_TYPE="NEED_SNAPSHOT"
                ;;
            "start" | "shutdown" | "stop" | "status" | "listsnapshot")
                ACTION_TYPE="NO_SNAPSHOT"
                ;;
        esac

        if [ ${ACTION_TYPE} == "STOP_COMPLETION" ] ; then
            return
        else
            if [ ${ACTION_TYPE} == "NEED_SNAPSHOT" ] && [ "${#COMP_WORDS[@]}" == "3" ] && [ -z ${COMP_WORDS[2]} ] ; then
                # For snapshot, rollback and delsnapshot actions give users an hint about the need to specify the name of the snapshot
                suggestions="SNAP-NAME"
            else
                if [ ${ACTION_TYPE} == "NEED_SNAPSHOT" ] ; then
                    # If action is snapshot, rollback or delsnapshot, pop the first element of the COMP_WORDS array in order to
                    # have the same processing as listsnapshot and similar options without the need to enter a snapshot name
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
                else
                    #################################
                    # Completions for active option #
                    #################################

                    for option in "--vm-list" "--ct-list"
                    do
                        #echo "option=<$option>"

                        VARS="$PVE_BULK_VM_VARS"
                        if [ ${option} == "--ct-list" ] ; then
                            VARS="$PVE_BULK_CT_VARS"
                        fi

                        # If we have --XX-list= without any character after "=", return the available $PVE_BULK_XX_* vars, if available, as suggestions, along with running and stopped keywords
                        if [ "${#COMP_WORDS[@]}" == "4" ] && [ ${COMP_WORDS[2]} == "${option}" ] && [ ${COMP_WORDS[3]} == "=" ] ; then
                            suggestions=($(compgen -W "${VARS}" -P '$' ; compgen -W "running stopped"))
                        elif [ "${#COMP_WORDS[@]}" == "7" ] && [ ${COMP_WORDS[5]} == "${option}" ] && [ ${COMP_WORDS[6]} == "=" ] ; then
                            suggestions=($(compgen -W "${VARS}" -P '$' ; compgen -W "running stopped"))
                        # If we have --vm-list=XXX, return the available $PVE_BULK_VM_* vars, if available, or the keyword running or stopped that have XXX as prefix
                        elif [ "${#COMP_WORDS[@]}" == "5" ] && [ ${COMP_WORDS[2]} == "${option}" ] ; then
                            suggestions=($(compgen -W "${VARS}" -P '$' -- "${COMP_WORDS[4]##$}" ; compgen -W "running stopped" -- "${COMP_WORDS[4]##$}"))
                        elif [ "${#COMP_WORDS[@]}" == "8" ] && [ ${COMP_WORDS[5]} == "${option}" ] ; then
                            suggestions=($(compgen -W "${VARS}" -P '$' -- "${COMP_WORDS[7]##$}" ; compgen -W "running stopped" -- "${COMP_WORDS[7]##$}"))
                        fi
                    done
                fi
            fi
            
            if [ -z $suggestions ] ; then
                return
            fi
        fi
    fi
    
    COMPREPLY=("${suggestions[@]}")
}

complete -o nospace -F _pve_bulk_completion pve-bulk
