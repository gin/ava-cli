#!/usr/bin/env bash
# shellcheck disable=2207
###############################################################################

function _ava_cli_args {
    local curr_0="${COMP_WORDS[COMP_CWORD]}" ;
    local word_1="${COMP_WORDS[1]}" ;
    local word_2="${COMP_WORDS[2]}" ;
    COMPREPLY=() ;
    local sup_cmds ; sup_cmds="$(ava-cli --list-commands)" ;
    local sub_cmds ;
    local sup_opts ; sup_opts="$(ava-cli --list-options)" ;
    local sub_opts ;
    if [[ -n ${word_1} ]] && [[ " ${sup_cmds[*]} " == *" ${word_1} "* ]] ; then
        sub_cmds="$(ava-cli "${word_1}" --list-commands)" ;
        if [[ -n ${word_2} ]] && [[ " ${sub_cmds[*]} " == *" ${word_2} "* ]] ; then
            ## ava-cli command sub-command * [TAB]
            sub_opts="$(ava-cli "${word_1}" "${word_2}" --list-options)" ;
            COMPREPLY+=( $(compgen -W "${sub_opts}" -- "${curr_0}") )
            return 0 ;
        fi
        ## ava-cli command [TAB]
        sub_opts="$(ava-cli "${word_1}" --list-options)" ;
        COMPREPLY+=( $(compgen -W "${sub_opts}" -- "${curr_0}") )
        sub_cmds="$(ava-cli "${word_1}" --list-commands)" ;
        COMPREPLY+=( $(compgen -W "${sub_cmds}" -- "${curr_0}") )
        return 0 ;
    fi
    ## ava-cli [TAB]
    COMPREPLY+=( $(compgen -W "${sup_opts}" -- "${curr_0}") )
    COMPREPLY+=( $(compgen -W "${sup_cmds}" -- "${curr_0}") )
    return 0 ;
}

###############################################################################

complete -F _ava_cli_args ava-cli.sh ;
complete -F _ava_cli_args ava-cli ;

###############################################################################
###############################################################################
