#!/bin/bash
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v aflat)" ]; then
    echo 'Error: aflat is not installed.' >&2
    exit 1
fi
git clone https://{{repo}} {{name}}
cp -r ./{{name}}/src ./src/{{name}}
cp ./{{name}}/aflat.cfg ./{{name}}.aflat.cfg
rm -rf ./{{name}}