#/usr/bin/env bash

#######################################
# Bash Completion script for pve-bulk #
#                                     #
# Version: 0.1                         #
#######################################

PVE_BULK_ACTIONS="help start shutdown stop status listsnapshot snapshot rollback delsnapshot --help"
PVE_BULK_OPTIONS="--ct-list= --vm-list= --all"

_pve_bulk_completion()
{
    PVE_BULK_VM_VARS=$(env | grep PVE_BULK_VM_ | cut -d= -f 1)
    PVE_BULK_CT_VARS=$(env | grep PVE_BULK_CT_ | cut -d= -f 1)

    #if [ "${#COMP_WORDS[@]}" == "2" ] && [ "x${COMP_WORDS[1]}" == "x" ]; then
    #  COMPREPLY=$(compgen -W "help start shutdown stop status listsnapshot snapshot rollback delsnapshot --help")
    #  return
    #fi
    local suggestions=""
    
    if [ "${#COMP_WORDS[@]}" == "2" ]; then
        suggestions=($(compgen -W "${PVE_BULK_ACTIONS}" -- "${COMP_WORDS[1]}" ))
    elif [ "${#COMP_WORDS[@]}" -ge "2" ]; then
        case ${COMP_WORDS[1]} in
            listsnapshot|snapshot|rollback|delsnapshot)
                if [ ${COMP_WORDS[1]} != "listsnapshot" ] && [ "${#COMP_WORDS[@]}" == "3" ] && [ -z ${COMP_WORDS[2]} ] ; then
                    suggestions="SNAP-NAME"
                else
                    if [ ${COMP_WORDS[1]} != "listsnapshot" ] ; then
                        COMP_WORDS=("${COMP_WORDS[@]:1}")
                    fi
                    
                    if [ "${#COMP_WORDS[@]}" == "3" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_OPTIONS}" -- "${COMP_WORDS[2]}"))
                    elif [ "${#COMP_WORDS[@]}" == "6" ] ; then
                        if [ ${COMP_WORDS[2]} == "--vm-list" ] ; then
                            suggestions=($(compgen -W "--ct-list=" -- "${COMP_WORDS[5]}"))
                        elif [ ${COMP_WORDS[2]} == "--ct-list" ] ; then
                            suggestions=($(compgen -W "--vm-list=" -- "${COMP_WORDS[5]}")) 
                        else
                            return
                        fi

                    elif [ "${#COMP_WORDS[@]}" == "4" ] && [ ${COMP_WORDS[2]} == "--vm-list" ] && [ ${COMP_WORDS[3]} == "=" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_VM_VARS}" -P '$'))
                    elif [ "${#COMP_WORDS[@]}" == "7" ] && [ ${COMP_WORDS[5]} == "--vm-list" ] && [ ${COMP_WORDS[6]} == "=" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_VM_VARS}" -P '$'))

                    elif [ "${#COMP_WORDS[@]}" == "5" ] && [ ${COMP_WORDS[2]} == "--vm-list" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_VM_VARS}" -P '$' -- "${COMP_WORDS[4]##$}"))
                    elif [ "${#COMP_WORDS[@]}" == "8" ] && [ ${COMP_WORDS[5]} == "--vm-list" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_VM_VARS}" -P '$' -- "${COMP_WORDS[7]##$}"))

                    elif [ "${#COMP_WORDS[@]}" == "4" ] && [ ${COMP_WORDS[2]} == "--ct-list" ] && [ ${COMP_WORDS[3]} == "=" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_CT_VARS}" -P '$'))
                    elif [ "${#COMP_WORDS[@]}" == "7" ] && [ ${COMP_WORDS[5]} == "--ct-list" ] && [ ${COMP_WORDS[6]} == "=" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_CT_VARS}" -P '$'))
                 
                    elif [ "${#COMP_WORDS[@]}" == "5" ] && [ ${COMP_WORDS[2]} == "--ct-list" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_CT_VARS}" -P '$' -- "${COMP_WORDS[4]##$}"))
                    elif [ "${#COMP_WORDS[@]}" == "8" ] && [ ${COMP_WORDS[5]} == "--ct-list" ] ; then
                        suggestions=($(compgen -W "${PVE_BULK_CT_VARS}" -P '$' -- "${COMP_WORDS[7]##$}"))
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
