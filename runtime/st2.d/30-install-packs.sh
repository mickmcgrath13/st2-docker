#!/bin/bash

GITHUB_PACK=$(st2 pack get github)
GITHUB_EXISTS_CHECK='Pack "github" is not found.'

BITOVI_PACKS_PACK=$(st2 pack get bitovi_packs)
BITOVI_PACKS_EXISTS_CHECK='Pack "bitovi_packs" is not found.'


# install github if it doesn't exist
if [ "$GITHUB_PACK" == "$GITHUB_EXISTS_CHECK" ]; then
  st2 pack install https://github.com/bitovi-stackstorm-exchange/github
fi

# install bitovi_packs if it doesn't exist
if [ "$BITOVI_PACKS_PACK" == "$BITOVI_PACKS_EXISTS_CHECK" ]; then
  st2 pack install https://github.com/bitovi-stackstorm-exchange/bitovi_packs
fi


