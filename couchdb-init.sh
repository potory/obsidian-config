#!/bin/bash
if [[ -z "$HOSTNAME" ]]; then
    echo "ERROR: Hostname missing"
    exit 1
fi
if [[ -z "$USERNAME" ]]; then
    echo "ERROR: Username missing"
    exit 1
fi

if [[ -z "$PASSWORD" ]]; then
    echo "ERROR: Password missing"
    exit 1
fi

echo "-- Configuring CouchDB by REST APIs... -->"

echo "HOSTNAME: ${HOSTNAME}"
echo "USERNAME: ${USERNAME}"
echo "USERNAME: ${USERNAME}"

until (curl -X POST "${HOSTNAME}/_cluster_setup" -H "Content-Type: application/json" -d "{\"action\":\"enable_single_node\",\"username\":\"${USERNAME}\",\"password\":\"${PASSWORD}\",\"bind_address\":\"0.0.0.0\",\"port\":5984,\"singlenode\":true}" --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/chttpd/require_valid_user" -H "Content-Type: application/json" -d '"true"' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/chttpd_auth/require_valid_user" -H "Content-Type: application/json" -d '"true"' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/httpd/WWW-Authenticate" -H "Content-Type: application/json" -d '"Basic realm=\"couchdb\""' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/httpd/enable_cors" -H "Content-Type: application/json" -d '"true"' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/chttpd/enable_cors" -H "Content-Type: application/json" -d '"true"' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/chttpd/max_http_request_size" -H "Content-Type: application/json" -d '"4294967296"' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/couchdb/max_document_size" -H "Content-Type: application/json" -d '"50000000"' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/cors/credentials" -H "Content-Type: application/json" -d '"true"' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done
until (curl -X PUT "${HOSTNAME}/_node/nonode@nohost/_config/cors/origins" -H "Content-Type: application/json" -d '"app://obsidian.md,capacitor://localhost,http://localhost"' --user "${USERNAME}:${PASSWORD}"); do sleep 5; done

echo "<-- Configuring CouchDB by REST APIs Done!"