#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034,SC2059
###############################################################################
CLI_HELP_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_HELP_SCRIPT/color.sh" ;

###############################################################################
###############################################################################

function cli_help {
    printf "${BB}Usage:${NB} $(basename "$0") [OPTIONS] COMMMAND" ;
    printf "\n" ;
    printf "\nA command line interface for AVA APIs" ;
    printf "\n" ;
    printf "\n${BB}Options:${NB}" ;
    printf "\n" ;
    printf "$(line_for "-h")" ;
    printf "$(line_for "-v")" ;
    if [[ -z "$1" || "$1" == "keystore" ]] ; then
        printf "\n" ;
        printf "\n${BB}Keystore API:${NB}\n\n$(text_for 'keystore')" ;
        printf "\n" ;
        printf "$(line_for 'keystore' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "avm" ]] ; then
        printf "\n" ;
        printf "\n${BB}AVM (X-Chain) API:${NB}\n\n$(text_for 'avm')" ;
        printf "\n" ;
        printf "$(line_for 'avm' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "platform" ]] ; then
        printf "\n" ;
        printf "\n${BB}Platform API:${NB}\n\n$(text_for 'platform')" ;
        printf "\n" ;
        printf "$(line_for 'platform' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "evm" ]] ; then
        printf "\n" ;
        printf "\n${BB}EVM API:${NB}\n\n$(text_for 'evm')" ;
        printf "\n" ;
        printf "$(line_for 'evm' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "admin" ]] ; then
        printf "\n" ;
        printf "\n${BB}Admin API:${NB}\n\n$(text_for 'admin')" ;
        printf "\n" ;
        printf "$(line_for 'admin' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "health" ]] ; then
        printf "\n" ;
        printf "\n${BB}Health API:${NB}\n\n$(text_for 'health')" ;
        printf "\n" ;
        printf "$(line_for 'health' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "ipcs" ]] ; then
        printf "\n" ;
        printf "\n${BB}IPC API:${NB}\n\n$(text_for 'ipcs')" ;
        printf "\n" ;
        printf "$(line_for 'ipcs' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "metrics" ]] ; then
        printf "\n" ;
        printf "\n${BB}Metrics API:${NB}\n\n$(text_for 'metrics')" ;
        printf "\n" ;
        printf "$(line_for 'metrics' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "timestamp" ]] ; then
        printf "\n" ;
        printf "\n${BB}Timestamp API:${NB}\n\n$(text_for 'timestamp')" ;
        printf "\n" ;
        printf "$(line_for 'timestamp' "$2")" ;
    fi
}

function line_for {
    local api_max=CLI_HELP_MAX["api"] ;
    local cmd_max=CLI_HELP_MAX["cmd"] ;
    local txt_max=CLI_HELP_MAX["txt"] ;
    local format="\n%s %-$((cmd_max-${#1}))s %s" ;
    for key in "${CLI_HELP_CACHE_ORDER[@]}" ; do
        if [[ "$key" =~ $1:$2 ]] ; then
            local api="${key:0:${#1}}" ;
            local cmd="${key:((${#1}+1))}" ;
            local txt="${CLI_HELP_CACHE[$api:$cmd]}" ;
            if ((${#txt}>txt_max)) ; then
                txt="${txt:0:$txt_max}.." ;
            fi
            printf "$format" "$api" "$cmd" "$txt" ;
        fi
    done
}

function help_for {
    local api_max=CLI_HELP_MAX["api"] ;
    local cmd_max=CLI_HELP_MAX["cmd"] ;
    for key in "${CLI_HELP_CACHE_ORDER[@]}" ; do
        if [[ "$key" =~ $1:$2 ]] ; then
            local api="${key:0:${#1}}" ;
            local cmd="${key:((${#1}+1))}" ;
            local txt="${CLI_HELP_CACHE[$api:$cmd]}" ;
            printf "%s\n" "$txt" ;
        fi
    done
}

function help_cached {
    local col_max ; col_max=$(tput cols) ;
    local api_max=0 ;
    local cmd_max=0 ;
    local txt_max=0 ;
    for line in "${CLI_HELP[@]}" ; do
        local api ;
        api=$([[ $line =~ ^([^|]+) ]] && printf '%s' "${BASH_REMATCH[1]}") ;
        local cmd ;
        cmd=$([[ $line =~ \|([^|]+)\| ]] && printf '%s'  "${BASH_REMATCH[1]}") ;
        local txt ;
        txt=$([[ $line =~ \|([^|]+)$ ]] && printf '%s'  "${BASH_REMATCH[1]}") ;
        CLI_HELP_CACHE_ORDER+=( "$api:$cmd" ) ;
        CLI_HELP_CACHE["$api:$cmd"]="$txt" ;
        if ((api_max<${#api})) ; then
            api_max=$((${#api})) ;
        fi
        if ((cmd_max<${#api}+${#cmd})) ; then
            cmd_max=$((${#api}+${#cmd})) ;
            txt_max=$((col_max-cmd_max-5)) ;
        fi
    done
    CLI_HELP_MAX["api"]=$api_max ;
    CLI_HELP_MAX["cmd"]=$cmd_max ;
    CLI_HELP_MAX["txt"]=$txt_max ;
}

function text_for {
    for key in "${CLI_TEXT_CACHE_ORDER[@]}" ; do
        if [[ "$key" =~ $1 ]] ; then
            printf "%s" "${CLI_TEXT_CACHE[$key]}" ;
        fi
    done
}

function text_cached {
    for line in "${CLI_TEXT[@]}" ; do
        local api ;
        api=$([[ $line =~ ^([^|]+) ]] && printf '%s' "${BASH_REMATCH[1]}") ;
        CLI_TEXT_CACHE_ORDER+=( "$api" ) ;
        local txt ;
        txt=$([[ $line =~ \|([^|]+)$ ]] && printf '%s' "${BASH_REMATCH[1]}") ;
        CLI_TEXT_CACHE["$api"]="$txt" ;
    done
}

###############################################################################
###############################################################################

declare -a CLI_TEXT
declare -A CLI_TEXT_CACHE
declare -a CLI_TEXT_CACHE_ORDER

declare -a CLI_HELP
declare -A CLI_HELP_MAX
declare -A CLI_HELP_CACHE
declare -a CLI_HELP_CACHE_ORDER

###############################################################################

## Options:
CLI_HELP+=( "-h|--help|Show help information and quit." ) ;
CLI_HELP+=( "-v|--version|Print CLI version information and quit." ) ;

## Keystore Commands:
CLI_TEXT+=( "keystore|Every node has a built-in keystore. Clients create users on the keystore, which act as identities to be used when interacting with blockchains. A keystore exists at the node level, so if you create a user on a node it exists only on that node. However, users may be imported and exported using this API. See: ${LK}https://docs.ava.network/v1.0/en/api/keystore${NN}.")
CLI_HELP+=( "keystore|create-user|Create a new user with the specified username and password." ) ;
CLI_HELP+=( "keystore|list-users|List the users in this keystore." ) ;
CLI_HELP+=( "keystore|delete-user|Delete a user." ) ;
CLI_HELP+=( "keystore|export-user|Export a user. The user can be imported to another node with 'keystore import-user'. The user's password remains encrypted." ) ;
CLI_HELP+=( "keystore|import-user|Import a user. 'password' must match the user's password. 'username' doesn't have to match the username user had when it was exported." ) ;

## AVM (X-Chain) Commands:
CLI_TEXT+=( "avm|The X-Chain, AVA's native platform for creating and trading assets, is an instance of the AVA Virtual Machine (AVM). This API allows clients to create and trade assets on the X-Chain and other instances of the AVM. See: ${LK}https://docs.ava.network/v1.0/en/api/avm${NN}.")
CLI_HELP+=( "avm|create-address|Create a new address controlled by the given user." ) ;
CLI_HELP+=( "avm|list-addresses|List addresses controlled by the given user." ) ;
CLI_HELP+=( "avm|get-balance|Get the balance of an asset controlled by a given address." ) ;
CLI_HELP+=( "avm|get-all-balances|Get the balances of all assets controlled by a given address." ) ;
CLI_HELP+=( "avm|get-utxos|Get the UTXOs that reference a given address." ) ;
CLI_HELP+=( "avm|issue-tx|Send a signed transaction to the network." ) ;
CLI_HELP+=( "avm|sign-mint-tx|Sign an unsigned or partially signed transaction." ) ;
CLI_HELP+=( "avm|get-tx-status|Get the status of a transaction sent to the network." ) ;
CLI_HELP+=( "avm|get-tx|Returns the specified transaction." ) ;
CLI_HELP+=( "avm|send|Send a quantity of an asset to an address." ) ;
CLI_HELP+=( "avm|create-fixed-cap-asset|Create a new fixed-cap, fungible asset. A quantity of it is created at initialization and then no more is ever created. The asset can be sent with 'avm send-fungible-asset'." ) ;
CLI_HELP+=( "avm|create-variable-cap-asset|Create a new variable-cap, fungible asset. No units of the asset exist at initialization. Minters can mint units of this asset using 'create-mint-tx', 'sign-mint-tx' and 'issue-tx'. The asset can be sent with 'avm send'." ) ;
CLI_HELP+=( "avm|create-mint-tx|Create an unsigned transaction to mint more of a variable-cap asset (an asset created with 'avm create-variable-cap-asset')." ) ;
CLI_HELP+=( "avm|get-asset-description|Get information about an asset." ) ;
CLI_HELP+=( "avm|export-ava|Send AVA from the X-Chain to an account on the P-Chain. After calling this method, you must call the P-Chain's 'import-ava' method to complete the transfer." ) ;
CLI_HELP+=( "avm|import-ava|Finalize a transfer of AVA from the P-Chain to the X-Chain. Before this method is called, you must call the P-Chain's 'export-ava' method to initiate the transfer." ) ;
CLI_HELP+=( "avm|export-key|Get the private key that controls a given address. The returned private key can be added to a user with 'avm import-key'." ) ;
CLI_HELP+=( "avm|import-key|Give a user control over an address by providing the private key that controls the address." ) ;
CLI_HELP+=( "avm|build-genesis|Given a JSON representation of this Virtual Machine's genesis state, create the byte representation of that state." ) ;

## Platform Commands:
CLI_TEXT+=( "platform|This API allows clients to interact with the P-Chain (Platform Chain), which maintains AVA's validator set and handles blockchain creation. See: ${LK}https://docs.ava.network/v1.0/en/api/platform${NN}.")
CLI_HELP+=( "platform|create-blockchain|Create a new blockchain. Currently only supports creation of new instances of the AVM and the Timestamp VM." ) ;
CLI_HELP+=( "platform|get-blockchain-status|Get the status of a blockchain." ) ;
CLI_HELP+=( "platform|create-account|The P-Chain uses an account model. This method creates an account." ) ;
CLI_HELP+=( "platform|import-key|Give a user control over an address by providing the private key that controls the address." ) ;
CLI_HELP+=( "platform|export-key|Get the private key that controls a given address. The returned private key can be added to a user with 'platform importKey'." ) ;
CLI_HELP+=( "platform|get-account|The P-Chain uses an account model. An account is identified by an address. This method returns the account with the given address." ) ;
CLI_HELP+=( "platform|list-accounts|List the accounts controlled by the specified user." ) ;
CLI_HELP+=( "platform|get-current-validators|List the current validators of the given Subnet." ) ;
CLI_HELP+=( "platform|get-pending-validators|List the validators in the pending validator set of the specified Subnet. Each validator is not currently validating the Subnet but will in the future." ) ;
CLI_HELP+=( "platform|sample-validators|Sample validators from the specified Subnet." ) ;
CLI_HELP+=( "platform|add-default-subnet-validator|Add a validator to the Default Subnet." ) ;
CLI_HELP+=( "platform|add-non-default-subnet-validator|Add a validator to a Subnet other than the Default Subnet. The validator must validate the Default Subnet for the entire duration they validate this Subnet." ) ;
CLI_HELP+=( "platform|add-default-subnet-delegator|Add a delegator to the Default Subnet. A delegator stakes AVA and specifies a validator (the delegatee) to validate on their behalf. The delegatee has an increased probability of being sampled by other validators (weight) in proportion to the stake delegated to them. The delegatee charges a fee to the delegator; the former receives a percentage of the delegator's validation reward (if any). The delegation period must be a subset of the period that the delegatee validates the Default Subnet." ) ;
CLI_HELP+=( "platform|create-subnet|Create an unsigned transaction to create a new Subnet. The unsigned transaction must be signed with the key of the account paying the transaction fee. The Subnet's ID is the ID of the transaction that creates it (i.e. the response from 'issue-tx' when issuing the signed transaction)." ) ;
CLI_HELP+=( "platform|get-subnets|Get all the Subnets that exist." ) ;
CLI_HELP+=( "platform|validated-by|Get the Subnet that validates a given blockchain." ) ;
CLI_HELP+=( "platform|validates|Get the IDs of the blockchains a Subnet validates." ) ;
CLI_HELP+=( "platform|get-blockchains|Get all the blockchains that exist (excluding the P-Chain)." ) ;
CLI_HELP+=( "platform|export-ava|Send AVA from an account on the P-Chain to an address on the X-Chain. This transaction must be signed with the key of the account that the AVA is sent from and which pays the transaction fee. After issuing this transaction, you must call the X-Chain's 'import-ava' method to complete the transfer." ) ;
CLI_HELP+=( "platform|import-ava|Complete a transfer of AVA from the X-Chain to the P-Chain. Before this method is called, you must call the X-Chain's 'export-ava' method to initiate the transfer." ) ;
CLI_HELP+=( "platform|sign|Sign an unsigned or partially signed transaction. Transactions to add non-default Subnets require signatures from control keys and from the account paying the transaction fee. If 'signer' is a control key and the transaction needs more signatures from control keys, 'sign' will provide a control signature. Otherwise, 'signer' will sign to pay the transaction fee." ) ;
CLI_HELP+=( "platform|issue-tx|Issue a transaction to the Platform Chain." ) ;

## EVM Commands:
CLI_TEXT+=( "evm|This section describes the API of the C-Chain, which is an instance of the Ethereum Virtual Machine (EVM). ${UL}Note${NL}: Ethereum has its own notion of 'networkID' and 'chainID'. The C-Chain uses '1' and '43110' for these values, respectively. These have no relationship to AVA's view of 'networkID' and 'chainID', and are purely internal to the C-Chain. See: ${LK}https://docs.ava.network/v1.0/en/api/evm${NN}.")
CLI_HELP+=( "evm|web3-*|EVM's web3 end-points" ) ;
CLI_HELP+=( "evm|net-*|EVM's net end-points" ) ;
CLI_HELP+=( "evm|eth-*|EVM's eth end-points" ) ;
CLI_HELP+=( "evm|personal-*|EVM's personal end-points" ) ;

## Admin Commands:
CLI_TEXT+=( "admin|This API can be used for measuring node health and debugging. See: ${LK}https://docs.ava.network/v1.0/en/api/admin${NN}." ) ;
CLI_HELP+=( "admin|get-node-id|Get the ID of this node." ) ;
CLI_HELP+=( "admin|peers|Get description of peer connections." ) ;
CLI_HELP+=( "admin|get-network-id|Get the ID of the network this node is participating in." ) ;
CLI_HELP+=( "admin|alias|Assign an API an alias, a different endpoint for the API. The original endpoint will still work. This change only affects this node; other nodes will not know about this alias." ) ;
CLI_HELP+=( "admin|alias-chain|Give a blockchain an alias, a different name that can be used any place the blockchain's ID is used." ) ;
CLI_HELP+=( "admin|get-blockchain-id|Given a blockchain's alias, get its ID. (See 'avm alias-chain' for more context)." ) ;
CLI_HELP+=( "admin|start-cpu-profiler|Start profiling the CPU utilization of the node. Will write the profile to the specified file on stop." ) ;
CLI_HELP+=( "admin|stop-cpu-profiler|Stop the CPU profile that was previously started." ) ;
CLI_HELP+=( "admin|memory-profile|Dump the current memory footprint of the node to the specified file." ) ;
CLI_HELP+=( "admin|lock-profile|Dump the mutex statistics of the node to the specified file." ) ;
CLI_HELP+=( "admin|get-node-version|Get the version of this node." ) ;
CLI_HELP+=( "admin|get-network-name|Get the name of the network this node is running on." ) ;

## Health Commands:
CLI_TEXT+=( "health|This API can be used for measuring node health. See: ${LK}https://docs.ava.network/v1.0/en/api/health${NN}." ) ;
CLI_HELP+=( "health|get-liveness|Get health check on this node." ) ;

## IPC Commands:
CLI_TEXT+=( "ipcs|The IPC API allows users to create a UNIX domain socket for a blockchain to publish to. When the blockchain accepts a vertex/block it will publish the vertex to the socket. A node will only expose this API if it is started with command-line argument 'api-ipcs-enabled=true'. See: ${LK}https://docs.ava.network/v1.0/en/api/ipc${NN}." ) ;
CLI_HELP+=( "ipcs|publish-blockchain|Register a blockchain so it publishes accepted vertices to a Unix domain socket." ) ;
CLI_HELP+=( "ipcs|unpublish-blockchain|Deregister a blockchain so that it no longer publishes to a Unix domain socket." ) ;

## Metrics Commands:
CLI_TEXT+=( "metrics|The API allows clients to get statistics about a node's health and performance. See: ${LK}https://docs.ava.network/v1.0/en/api/metrics${NN}." ) ;
CLI_HELP+=( "metrics|get-prometheus|Get Prometheus compatible metrics." ) ;

## Timestamp Commands:
CLI_TEXT+=( "timestamp|This API allows clients to interact with the Timestamp Chain. The Timestamp Chain is a timestamp server. Each block contains a 32 byte payload and the timestamp when the block was created. The genesis data for a new instance of the Timestamp Chain is the genesis block's 32 byte payload. See: ${LK}https://docs.ava.network/v1.0/en/api/timestamp${NN}." ) ;
CLI_HELP+=( "timestamp|get-block|Get a block by its ID. If no ID is provided, get the latest block." ) ;
CLI_HELP+=( "timestamp|propose-block|Propose the creation of a new block." ) ;

###############################################################################

text_cached ;
help_cached ;

###############################################################################
###############################################################################
