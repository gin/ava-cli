#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2214
###############################################################################
PLATFORM_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$PLATFORM_SCRIPT/../../cli/color.sh" ;
source "$PLATFORM_SCRIPT/../../cli/command.sh" ;
source "$PLATFORM_SCRIPT/../../cli/rpc/data.sh" ;
source "$PLATFORM_SCRIPT/../../cli/rpc/post.sh" ;

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-b|--blockchain-id=|--chain=\${AVA_BLOCKCHAIN_ID}]" ;
    usage+=" [-a|--alias=\${AVA_ALIAS}]" ;
    usage+=" [-N|--node=\${AVA_NODE-127.0.0.1:9650}]" ;
    usage+=" [-S|--silent-rpc|\${AVA_SILENT_RPC}]" ;
    usage+=" [-V|--verbose-rpc|\${AVA_VERBOSE_RPC}]" ;
    usage+=" [-Y|--yes-run-rpc|\${AVA_YES_RUN_RPC}]" ;
    usage+=" [-h|--help]" ;
    source "$PLATFORM_SCRIPT/../../cli/help.sh" ; # shellcheck disable=2046
    printf '%s\n\n%s\n' "$usage" "$(help_for $(command_fqn "${0}"))" ;
}

function cli_options {
    local -a options ;
    options+=( "-b" "--blockchain-id=" "--chain=" ) ;
    options+=( "-a" "--alias=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    while getopts ":hSVYN:b:a:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            b|blockchain-id|chain)
                AVA_BLOCKCHAIN_ID="${OPTARG}" ;;
            a|alias)
                AVA_ALIAS="${OPTARG}" ;;
            N|node)
                AVA_NODE="${OPTARG}" ;;
            S|silent-rpc)
                export AVA_SILENT_RPC=1 ;;
            V|verbose-rpc)
                export AVA_VERBOSE_RPC=1 ;;
            Y|yes-run-rpc)
                export AVA_YES_RUN_RPC=1 ;;
            h|help)
                cli_help && exit 0 ;;
            :|*)
                cli_help && exit 1 ;;
        esac
    done
    if [ -z "$AVA_BLOCKCHAIN_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_ALIAS" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_NODE" ] ; then
        AVA_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function rpc_method {
    printf "admin.aliasChain" ;
}

function rpc_params {
    printf '{' ;
    printf '"chain":"%s",' "$AVA_BLOCKCHAIN_ID" ;
    printf '"alias":"%s"' "$AVA_ALIAS" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVA_NODE/ext/admin" "$(rpc_data)" ;

###############################################################################
###############################################################################
