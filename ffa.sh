#!/bin/bash
if [ $# -ne 3 ]
then
  echo "usage: sh ffa.sh <nom du fichier> <source id> <sink id>"
else
  ./mtest.byte $1 $2 $3 _temp/ffa.dot
  dot -Tsvg _temp/ffa.dot > _temp/ffa.svg
  firefox _temp/ffa.svg
fi