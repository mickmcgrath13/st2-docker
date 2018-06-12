#!/bin/bash

# Create directories needed for bitovi stackstorm exchange development
EXCHANGE_DIR="bitovi-stackstorm-exchange"
CHATOPS_DIR="stackstorm-chatops"
CONFIG_DIR="stackstorm-config"
VIRTUALENV_DIR="stackstorm-virtualenvs"



if [ ! -d ${EXCHANGE_DIR} ]; then
  mkdir -p ${EXCHANGE_DIR}
fi

if [ ! -d ${CHATOPS_DIR} ]; then
  mkdir -p ${CHATOPS_DIR}
fi

if [ ! -d ${CONFIG_DIR} ]; then
  mkdir -p ${CONFIG_DIR}
fi

if [ ! -d ${VIRTUALENV_DIR} ]; then
  mkdir -p ${VIRTUALENV_DIR}
fi