#!/bin/bash
if [ $# -ne 1 ]
then
  echo "usage: sh money.sh <nom du fichier>"
else
  ./ftest.byte $1 0 0 graphs/money2
  dot -Tsvg graphs/money2 > graphs/money2.svg
  firefox graphs/money2.svg
fi