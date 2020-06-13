[![Build Status](https://travis-ci.org/hsk81/ava-cli.svg?branch=master)](https://travis-ci.org/hsk81/ava-cli)

# A Command Line Interface for AVA APIs

```
Usage: ava-cli [OPTIONS] COMMMAND
```

## Options

```
-h --help                                 Show help information and quit.
-v --version                              Print CLI version information and quit.
```

## [Keystore API](https://docs.ava.network/v1.0/en/api/keystore)

Every node has a built-in keystore. Clients create users on the keystore, which act as identities to be used when interacting with blockchains. A keystore exists at the node level, so if you create a user on a node it exists only on that node. However, users may be imported and exported using this API.

```
keystore create-user                      Create a new user with the specified username and password.
keystore list-users                       List the users in this keystore.
keystore delete-user                      Delete a user.
keystore export-user                      Export a user. The user can be imported to another node with 'keystore import-user'. The user's password remains encrypted.
keystore import-user                      Import a user. 'password' must match the user's password. 'username' doesn't have to match the username user had when it was exported.
```

## [AVM (X-Chain) API](https://docs.ava.network/v1.0/en/api/avm)

The X-Chain, AVA's native platform for creating and trading assets, is an instance of the AVA Virtual Machine (AVM). This API allows clients to create and trade assets on the X-Chain and other instances of the AVM.

```
avm create-address                        Create a new address controlled by the given user.
avm list-addresses                        List addresses controlled by the given user.
avm get-balance                           Get the balance of an asset controlled by a given address.
avm get-all-balances                      Get the balances of all assets controlled by a given address.
avm get-utxos                             Get the UTXOs that reference a given address.
avm issue-tx                              Send a signed transaction to the network.
avm sign-mint-tx                          Sign an unsigned or partially signed transaction.
avm get-tx-status                         Get the status of a transaction sent to the network.
avm get-tx                                Returns the specified transaction.
avm send                                  Send a quantity of an asset to an address.
avm create-fixed-cap-asset                Create a new fixed-cap, fungible asset. A quantity of it is created at initialization and then no more is ever created. The asset can be sent with 'avm send-fungible-asset'.
avm create-variable-cap-asset             Create a new variable-cap, fungible asset. No units of the asset exist at initialization. Minters can mint units of this asset using 'create-mint-tx', 'sign-mint-tx' and 'issue-tx'. The asset can be sent with 'avm send'.
avm create-mint-tx                        Create an unsigned transaction to mint more of a variable-cap asset (an asset created with 'avm create-variable-cap-asset').
avm get-asset-description                 Get information about an asset.
avm export-ava                            Send AVA from the X-Chain to an account on the P-Chain. After calling this method, you must call the P-Chain's 'import-ava' method to complete the transfer.
avm import-ava                            Finalize a transfer of AVA from the P-Chain to the X-Chain. Before this method is called, you must call the P-Chain's 'export-ava' method to initiate the transfer.
avm export-key                            Get the private key that controls a given address. The returned private key can be added to a user with 'avm import-key'.
avm import-key                            Give a user control over an address by providing the private key that controls the address.
avm build-genesis                         Given a JSON representation of this Virtual Machine's genesis state, create the byte representation of that state.
```

## [Platform API](https://docs.ava.network/v1.0/en/api/platform)

This API allows clients to interact with the P-Chain (Platform Chain), which maintains AVA's validator set and handles blockchain creation.

```
platform create-blockchain                Create a new blockchain. Currently only supports creation of new instances of the AVM and the Timestamp VM.
platform get-blockchain-status            Get the status of a blockchain.
platform create-account                   The P-Chain uses an account model. This method creates an account.
platform import-key                       Give a user control over an address by providing the private key that controls the address.
platform export-key                       Get the private key that controls a given address. The returned private key can be added to a user with 'platform importKey'.
platform get-account                      The P-Chain uses an account model. An account is identified by an address. This method returns the account with the given address.
platform list-accounts                    List the accounts controlled by the specified user.
platform get-current-validators           List the current validators of the given Subnet.
platform get-pending-validators           List the validators in the pending validator set of the specified Subnet. Each validator is not currently validating the Subnet but will in the future.
platform sample-validators                Sample validators from the specified Subnet.
platform add-default-subnet-validator     Add a validator to the Default Subnet.
platform add-non-default-subnet-validator Add a validator to a Subnet other than the Default Subnet. The validator must validate the Default Subnet for the entire duration they validate this Subnet.
platform add-default-subnet-delegator     Add a delegator to the Default Subnet. A delegator stakes AVA and specifies a validator (the delegatee) to validate on their behalf. The delegatee has an increased probability of being sampled by other validators (weight) in proportion to the stake delegated to them. The delegatee charges a fee to the delegator; the former receives a percentage of the delegator's validation reward (if any). The delegation period must be a subset of the perdiod that the delegatee validates the Default Subnet.
platform create-subnet                    Create an unsigned transaction to create a new Subnet. The unsigned transaction must be signed with the key of the account paying the transaction fee. The Subnet's ID is the ID of the transaction that creates it (i.e. the response from 'issue-tx' when issuing the signed transaction).
platform get-subnets                      Get all the Subnets that exist.
platform validated-by                     Get the Subnet that validates a given blockchain.
platform validates                        Get the IDs of the blockchains a Subnet validates.
platform get-blockchains                  Get all the blockchains that exist (excluding the P-Chain).
platform export-ava                       Send AVA from an account on the P-Chain to an address on the X-Chain. This transaction must be signed with the key of the account that the AVA is sent from and which pays the transaction fee. After issuing this transaction, you must call the X-Chain's 'import-ava' method to complete the transfer.
platform import-ava                       Complete a transfer of AVA from the X-Chain to the P-Chain. Before this method is called, you must call the X-Chain's 'export-ava' method to initiate the transfer.
platform sign                             Sign an unsigned or partially signed transaction. Transactions to add non-default Subnets require signatures from control keys and from the account paying the transaction fee. If 'signer' is a control key and the transaction needs more signatures from control keys, 'sign' will provide a control signature. Otherwise, 'signer' will sign to pay the transaction fee.
platform issue-tx                         Issue a transaction to the Platform Chain.
```

## [EVM API](https://docs.ava.network/v1.0/en/api/evm) [TBD]

This section describes the API of the C-Chain, which is an instance of the Ethereum Virtual Machine (EVM). **Note:** Ethereum has its own notion of `networkID` and `chainID`. The C-Chain uses `1` and `43110` for these values, respectively. These have no relationship to AVA's view of `networkID` and `chainID`, and are purely internal to the C-Chain.

```
evm web3-*                                EVM's web3 end-points
evm net-*                                 EVM's net end-points
evm eth-*                                 EVM's eth end-points
evm personal-*                            EVM's personal end-points
```

## [Admin API](https://docs.ava.network/v1.0/en/api/admin)

This API can be used for measuring node health and debugging.

```
admin get-node-id                         Get the ID of this node.
admin peers                               Get description of peer connections.
admin get-network-id                      Get the ID of the network this node is participating in.
admin alias                               Assign an API an alias, a different endpoint for the API. The original endpoint will still work. This change only affects this node; other nodes will not know about this alias.
admin alias-chain                         Give a blockchain an alias, a different name that can be used any place the blockchain's ID is used.
admin get-blockchain-id                   Given a blockchain's alias, get its ID. (See 'avm alias-chain' for more context).
admin start-cpu-profiler                  Start profiling the CPU utilization of the node. Will write the profile to the specified file on stop.
admin stop-cpu-profiler                   Stop the CPU profile that was previously started.
admin memory-profile                      Dump the current memory footprint of the node to the specified file.
admin lock-profile                        Dump the mutex statistics of the node to the specified file.
admin get-node-version                    Get the version of this node.
admin get-network-name                    Get the name of the network this node is running on.
```

## [Health API](https://docs.ava.network/v1.0/en/api/health)

This API can be used for measuring node health.

```
health get-liveness                       Get health check on this node.
```

## [IPC API](https://docs.ava.network/v1.0/en/api/ipc)

The IPC API allows users to create a UNIX domain socket for a blockchain to publish to. When the blockchain accepts a vertex/block it will publish the vertex to the socket. A node will only expose this API if it is started with command-line argument `api-ipcs-enabled=true`.

```
ipcs publish-blockchain                   Register a blockchain so it publishes accepted vertices to a Unix domain socket.
ipcs unpublish-blockchain                 Deregister a blockchain so that it no longer publishes to a Unix domain socket.
```

## [Metrics API](https://docs.ava.network/v1.0/en/api/metrics)

The API allows clients to get statistics about a node's health and performance.

```
metrics                                   Get node metrics.
```

## [Timestamp API](https://docs.ava.network/v1.0/en/api/timestamp)

This API allows clients to interact with the Timestamp Chain. The Timestamp Chain is a timestamp server. Each block contains a 32 byte payload and the timestamp when the block was created. The genesis data for a new instance of the Timestamp Chain is the genesis block's 32 byte payload.

```
timestamp get-block                       Get a block by its ID. If no ID is provided, get the latest block.
timestamp propose-block                   Propose the creation of a new block.
```

## Installation

Clone GIT repository:
```
$ git clone https://github.com/hsk81/ava-cli
```
Move it for example to `/opt`:
```
$ (sudo) mv ./ava-cli /opt
```
Link `ava-cli.sh` as `ava-cli`:
```
$ (sudo) ln -s /opt/ava-cli/ava-cli.sh /usr/local/bin/ava-cli
```
Enable bash completion (activates after a terminal reload):
```
$ (sudo) ln -s /opt/ava-cli/ava-cli-completion.bash /etc/bash_completion.d/ava-cli-completion.bash
```

## Copyright

(c) 2020, Hasan Karahan.
