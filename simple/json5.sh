#!/usr/bin/env bash

_here=$(cd $(dirname $0); pwd)
for j5 in ${_here}/*.json5; do json5 -s 2 ${j5} > ${_here}/generated/json/$(basename ${j5}).json; done
