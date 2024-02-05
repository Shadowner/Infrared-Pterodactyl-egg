#!/bin/bash
cd /home/container

# Replace Startup Variables
MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Prepare the proxies

# check if the folder proxies doesn't exists
if [ ! -d "/home/container/proxies" ]; then
    # create the folder
    mkdir /home/container/proxies
fi

function createProxyYml {

    local proxyNumber=$1
    local domains="DOMAINS_${proxyNumber}"
    local addresses="ADDRESSES_${proxyNumber}"

    # Check if the env variable is set
    if [ -z "${!domains}" ]; then
        echo "The domains variable is not set. Please set it to the $1 domain of the proxy"
        exit 1
    fi

    # Check if the env variable is set
    if [ -z "${!addresses}" ]; then
        echo "The addresses env variable is not set. Please set it to the $1 domain of the proxy"
        exit 1
    fi

    # If file exists, delete it
    if [ -f "/home/container/proxies/$1.yml" ]; then
        rm /home/container/proxies/$1.yml
    fi

    # Create the file
    echo "domains:" >"/home/container/proxies/$1.yml"
    echo "${!domains}" | while IFS=',' read -r domain; do
        echo "  - \"$domain\"" >>"/home/container/proxies/$1.yml"
    done

    echo "addresses:" >>"/home/container/proxies/$1.yml"
    echo "${!addresses}" | while IFS=',' read -r address; do
        echo "  - $address" >>"/home/container/proxies/$1.yml"
    done
}

# Check if PROXY_COUNT is set if not assume the User configured everything manually
if [ -n "$PROXY_COUNT" ]; then
    # Check if it's a number
    if ! [[ $PROXY_COUNT =~ ^[0-9]+$ ]]; then
        echo "The PROXY_COUNT env variable is not a number"
        exit 1
    fi

    # Loop through the number of proxies and create the yml files
    for i in $(seq 1 $PROXY_COUNT); do
        createProxyYml $i
    done
fi

# Run the Server
${MODIFIED_STARTUP}
