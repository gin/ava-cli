#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2214
###############################################################################
AVM_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$AVM_SCRIPT/../../cli/color.sh" ;
source "$AVM_SCRIPT/../../cli/command.sh" ;
source "$AVM_SCRIPT/../../cli/rpc/data.sh" ;
source "$AVM_SCRIPT/../../cli/rpc/post.sh" ;

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-t|--tx-id=\${AVA_TX_ID}]" ;
    usage+=" [-b|--blockchain-id=\${AVA_BLOCKCHAIN_ID-X}]" ;
    usage+=" [-N|--node=\${AVA_NODE-127.0.0.1:9650}]" ;
    usage+=" [-S|--silent-rpc|\${AVA_SILENT_RPC}]" ;
    usage+=" [-V|--verbose-rpc|\${AVA_VERBOSE_RPC}]" ;
    usage+=" [-Y|--yes-run-rpc|\${AVA_YES_RUN_RPC}]" ;
    usage+=" [-h|--help]" ;
    source "$AVM_SCRIPT/../../cli/help.sh" ; # shellcheck disable=2046
    printf '%s\n\n%s\n' "$usage" "$(help_for $(command_fqn "${0}"))" ;
}

function cli_options {
    local -a options ;
    options+=( "-t" "--tx-id=" ) ;
    options+=( "-b" "--blockchain-id=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    while getopts ":hSVYN:t:b:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            t|tx-id)
                AVA_TX_ID="${OPTARG}" ;;
            b|blockchain-id)
                AVA_BLOCKCHAIN_ID="${OPTARG}" ;;
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
    if [ -z "$AVA_TX_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_BLOCKCHAIN_ID" ] ; then
        AVA_BLOCKCHAIN_ID="X" ;
    fi
    if [ -z "$AVA_NODE" ] ; then
        AVA_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}


function rpc_method {
    printf "avm.getTxStatus" ;
}

function rpc_params {
    printf '{' ;
    printf '"txID":"%s"' "$AVA_TX_ID" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVA_NODE/ext/bc/$AVA_BLOCKCHAIN_ID" "$(rpc_data)" ;

###############################################################################
###############################################################################
