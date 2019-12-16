#!/bin/bash
if [ $# -ne 1 ]
then
  echo "usage: sh money.sh <nom du fichier>"
else
  mkdir -p _temp
  ./mtest.byte $1 _temp/money.dot
  dot -Tsvg _temp/money.dot > _temp/money.svg
  firefox _temp/money.svg
fi