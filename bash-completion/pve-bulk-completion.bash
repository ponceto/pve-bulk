#/usr/bin/env bash

PVE_BULK_ACTIONS="help start shutdown stop status listsnapshot snapshot rollback delsnapshot --help"
PVE_BULK_OPTIONS="--ct-list=ctid1,ctid2,... --vm-list=vmid1,vmid2,... --all"

_dothis_completions()
{
    #if [ "${#COMP_WORDS[@]}" == "2" ] && [ "x${COMP_WORDS[1]}" == "x" ]; then
    #  COMPREPLY=$(compgen -W "help start shutdown stop status listsnapshot snapshot rollback delsnapshot --help")
    #  return
    #fi
    local suggestions=""
    
    if [ "${#COMP_WORDS[@]}" == "2" ]; then
        local suggestions=($(compgen -W "${PVE_BULK_ACTIONS}" -- "${COMP_WORDS[1]}"))
        elif [ "${#COMP_WORDS[@]}" -ge "2" ]; then
        case ${COMP_WORDS[1]} in
            listsnapshot)
                if [ "${#COMP_WORDS[@]}" == "3" ] ; then
                    suggestions=($(compgen -W "${PVE_BULK_OPTIONS}" -- "${COMP_WORDS[2]}"))
                else
                    return
                fi
            ;;
            snapshot|rollback|delsnapshot)
                if [ "${#COMP_WORDS[@]}" == "3" ] && [ -z ${COMP_WORDS[2]} ] ; then
                    suggestions="SNAPSHOT_NAME"
                    elif [ "${#COMP_WORDS[@]}" == "4" ] ; then
                    suggestions=($(compgen -W "${PVE_BULK_OPTIONS}" -- "${COMP_WORDS[3]}"))
                fi
            ;;
            
            *)
                return
            ;;
        esac
    fi
    
    COMPREPLY=("${suggestions[@]}")
}