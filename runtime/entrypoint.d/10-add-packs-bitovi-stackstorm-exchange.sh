#!/bin/bash

EXCHANGE_PATH="/opt/stackstorm/bitovi-stackstorm-exchange"
mkdir -p "${EXCHANGE_PATH}"
CURRENT_BASE_PATHS="$(crudini --get /etc/st2/st2.conf content packs_base_paths)"

EXCHANGE_PATH_STRING=",${EXCHANGE_PATH}"
REPLACE_VAL=""
NEW_CURRENT_BASE="${CURRENT_BASE_PATHS//,\/opt\/stackstorm\/bitovi-stackstorm-exchange/$REPLACE_VAL}"
crudini --set /etc/st2/st2.conf content packs_base_paths ""
crudini --set /etc/st2/st2.conf content packs_base_paths "${EXCHANGE_PATH}"

# TODO: figure out how to specify multiple pack base paths
#   This will cause an error when loading the sensor:
#     ValueError: Directory "/opt/stackstorm/packs.dev,/opt/stackstorm/bitovi-stackstorm-exchange" doesn't exist
#
# crudini --set /etc/st2/st2.conf content packs_base_paths "${NEW_CURRENT_BASE}""${EXCHANGE_PATH_STRING}"
