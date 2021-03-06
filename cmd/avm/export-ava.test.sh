#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./ava-cli.sh avm export-ava" ;
}

function check {
    local result="$1";
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/bc/${2-X}'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"avm.exportAVA",' ;
    expect_d+='"params":{' ;
    expect_d+='"to":"TO",' ;
    expect_d+='"amount":999,' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__export_ava_1a {
    check "$(RPC_ID=1 $(cmd) -# 999 -@ TO -u USERNAME -p PASSWORD)" ;
}

function test_avm__export_ava_1b {
    check "$(RPC_ID=1 AVA_AMOUNT=999 $(cmd) -@ TO -u USERNAME -p PASSWORD)" ;
}

function test_avm__export_ava_1c {
    check "$(RPC_ID=1 AVA_TO=TO $(cmd) -# 999 -u USERNAME -p PASSWORD)" ;
}

function test_avm__export_ava_1d {
    check "$(RPC_ID=1 AVA_USERNAME=USERNAME $(cmd) -# 999 -@ TO -p PASSWORD)" ;
}

function test_avm__export_ava_1e {
    check "$(RPC_ID=1 AVA_PASSWORD=PASSWORD $(cmd) -# 999 -@ TO -u USERNAME)" ;
}

function test_avm__export_ava_2a {
    check "$(RPC_ID=1 $(cmd) \
        -# 999 -@ TO -u USERNAME -p PASSWORD -b BC_ID)" BC_ID ;
}

function test_avm__export_ava_2b {
    check "$(RPC_ID=1 AVA_BLOCKCHAIN_ID=BC_ID $(cmd) \
        -# 999 -@ TO -u USERNAME -p PASSWORD)" BC_ID ;
}

###############################################################################
###############################################################################
