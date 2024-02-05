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
    # Check if the env variable is set
    if [ -z "$1" ]; then
        echo "The domains variable is not set. Please set it to the $3 domain of the proxy"
        exit 1
    fi

    # Check if the env variable is set
    if [ -z "$2" ]; then
        echo "The addresses env variable is not set. Please set it to the $3 domain of the proxy"
        exit 1
    fi

    # Split the firstDomains and firstAddresses into arrays
    IFS=',' read -r -a domainsArray <<<"$1"
    IFS=',' read -r -a addressesArray <<<"$2"

    # Create a first.yml file in the proxies folder

    # If file exists, delete it
    if [ -f "/home/container/proxies/$3.yml" ]; then
        rm /home/container/proxies/$3.yml
    fi

    echo "domains:" >/home/container/proxies/$3.yml
    for domain in "${domainsArray[@]}"; do
        echo "  - $domain" >>/home/container/proxies/$3.yml
    done

    echo "addresses:" >>/home/container/proxies/$3.yml
    for address in "${addressesArray[@]}"; do
        echo "  - $address" >>/home/container/proxies/$3.yml
    done
}

# Check if PROXY_COUNT is set if not assume the User configured everything manually
if [ -z "$PROXY_COUNT" ]; then
    # Loop through the number of proxies and create the yml files
    for i in $(seq 1 $PROXY_COUNT); do
        # Check if both env variables are set if not continue
        if [ -n "${i}_DOMAINS" ] && [ -n "${i}_ADDRESSES" ]; then
            createProxyYml ${i}_DOMAINS ${i}_ADDRESSES $i
        fi
    done
fi

# Run the Server
${MODIFIED_STARTUP}
