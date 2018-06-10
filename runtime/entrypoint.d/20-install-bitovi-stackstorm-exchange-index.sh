#!/bin/bash

CURRENT_INDEX="$(crudini --get /etc/st2/st2.conf content index_url)"
# crudini --set /etc/st2/st2.conf content index_url "${CURRENT_INDEX}",https://github.com/bitovi-stackstorm-exchange/index
# crudini --set /etc/st2/st2.conf content index_url "${CURRENT_INDEX}",https://github.com/bitovi-stackstorm-exchange/index
crudini --del /etc/st2/st2.conf content index_url
